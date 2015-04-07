//
//  ScannerViewController.m
//  nRF Toolbox
//
//  Created by Aleksander Nowakowski on 16/12/13.
//  Copyright (c) 2013 Nordic Semiconductor. All rights reserved.
//

#import "ScannerViewController.h"
#import "ScannedPeripheral.h"

@interface ScannerViewController ()
{

    UITableView *devicesTable;

}

/*!
 * List of the peripherals shown on the table view. Peripheral are added to this list when it's discovered.
 * Only peripherals with bridgeServiceUUID in the advertisement packets are being displayed.
 */
@property (strong, nonatomic) NSMutableArray *peripherals;
/*!
 * The timer is used to periodically reload table
 */
@property (strong, nonatomic) NSTimer *timer;

- (void)timerFireMethod:(NSTimer *)timer;

@end

@implementation ScannerViewController
@synthesize bluetoothManager;

@synthesize filterUUID;
@synthesize peripherals;
@synthesize timer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
	// Do any additional setup after loading the view.
    peripherals = [NSMutableArray arrayWithCapacity:8];
    devicesTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, 320, 400) style:UITableViewStylePlain];
    devicesTable.delegate = self;
    devicesTable.dataSource = self;
    [self.view addSubview:devicesTable];
    
    
    UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake(106, 80, 108, 21)];
    headLabel.font = [UIFont systemFontOfSize:17.0];
    headLabel.text = @"Select device:";
    headLabel.textColor = [UIColor colorWithRed:0/255 green:156.0/255 blue:222.0/255 alpha:1];
    
    UIButton *cancleButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 515, 320, 53)];
    [cancleButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancleButton setTitleColor:[UIColor colorWithRed:0/255 green:156.0/255 blue:222.0/255 alpha:1] forState:UIControlStateNormal];
    [cancleButton addTarget:self action:@selector(didCancelClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:headLabel];
    [self.view addSubview:cancleButton];
    cancleButton.enabled = YES;
    
    // We want the scanner to scan with dupliate keys (to refresh RRSI every second) so it has to be done using non-main queue
    dispatch_queue_t centralQueue = dispatch_queue_create("no.nordicsemi.ios.nrftoolbox", DISPATCH_QUEUE_SERIAL);
    bluetoothManager = [[CBCentralManager alloc]initWithDelegate:self queue:centralQueue];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self scanForPeripherals:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didCancelClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Central Manager delegate methods

-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state == CBCentralManagerStatePoweredOn) {
        [self scanForPeripherals:YES];
    }
}

/*!
 * @brief Starts scanning for peripherals with rscServiceUUID
 * @param enable If YES, this method will enable scanning for bridge devices, if NO it will stop scanning
 * @return 0 if success, -1 if Bluetooth Manager is not in CBCentralManagerStatePoweredOn state.
 */
- (int) scanForPeripherals:(BOOL)enable
{
    if (bluetoothManager.state != CBCentralManagerStatePoweredOn)
    {
        return -1;
    }
    
    // Scanner uses other queue to send events. We must edit UI in the main queue
    dispatch_async(dispatch_get_main_queue(), ^{
        if (enable)
        {
            NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], CBCentralManagerScanOptionAllowDuplicatesKey, nil];
            if (filterUUID != nil)
            {
                [bluetoothManager scanForPeripheralsWithServices:@[ filterUUID ] options:options];
            }
            else
            {
                [bluetoothManager scanForPeripheralsWithServices:nil options:options];
            }
            
            timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
        }
        else
        {
            [timer invalidate];
            timer = nil;
            
            [bluetoothManager stopScan];
        }
    });
    return 0;
}

/*!
 * @brief This method is called periodically by the timer. It refreshes the devices list. Updates from Central Manager comes to fast and it's hard to select a device if refreshed from there.
 * @param timer the timer that has called the method
 */
- (void)timerFireMethod:(NSTimer *)timer
{
    [devicesTable reloadData];
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    
    // Scanner uses other queue to send events. We must edit UI in the main queue
    dispatch_async(dispatch_get_main_queue(), ^{
        // Add the sensor to the list and reload deta set
        ScannedPeripheral* sensor = [ScannedPeripheral initWithPeripheral:peripheral rssi:RSSI.intValue];
        if (![peripherals containsObject:sensor])
        {
            [peripherals addObject:sensor];
        }
        else
        {
            sensor = [peripherals objectAtIndex:[peripherals indexOfObject:sensor]];
            sensor.RSSI = RSSI.intValue;
        }
        NSLog(@"peripherals = %@",peripherals);
        // The table is refreshed using a periodic timer
        //[devicesTable reloadData];
    });
}

#pragma mark Table View delegate methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [bluetoothManager stopScan];
    [self.navigationController popViewControllerAnimated:YES];
    
    // Call delegate method
    [self.delegate centralManager:bluetoothManager didPeripheralSelected:[[peripherals objectAtIndex:indexPath.row] peripheral]];
}

#pragma mark Table View Data Source delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return peripherals.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
     cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    // Update sensor name
    ScannedPeripheral *peripheral = [peripherals objectAtIndex:indexPath.row];
    cell.textLabel.text = [peripheral name];
    
    NSLog(@"cell = %@",cell.textLabel.text);
    // Update RSSI indicator
    int RSSI = peripheral.RSSI;
    UIImage* image;
    if (RSSI < -90) {
        image = [UIImage imageNamed: @"Signal_0"];
    }
    else if (RSSI < -70)
    {
        image = [UIImage imageNamed: @"Signal_1"];
    }
    else if (RSSI < -50)
    {
        image = [UIImage imageNamed: @"Signal_2"];
    }
    else
    {
        image = [UIImage imageNamed: @"Signal_3"];
    }
    cell.imageView.image = image;
    return cell;
}

@end

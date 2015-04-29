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

/*!
 * The timer is used to periodically reload table
 */
@property (strong, nonatomic) NSTimer *timer;


@end

@implementation ScannerViewController


@synthesize filterUUID;
@synthesize peripherals;
@synthesize timer;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (id)init:(NSMutableArray *)periphera
{
    self = [super init];
    peripherals = [NSMutableArray arrayWithArray:periphera];
    self.backgroundColor = [UIColor whiteColor];
	// Do any additional setup after loading the view.
  //  peripherals = [NSMutableArray arrayWithCapacity:8];
    devicesTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 80, 320, 400) style:UITableViewStylePlain];
    devicesTable.delegate = self;
    devicesTable.dataSource = self;
    [self addSubview:devicesTable];
    
    
    UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake(106, 50, 108, 21)];
    headLabel.font = [UIFont systemFontOfSize:17.0];
    headLabel.text = @"Select device:";
    headLabel.textColor = [UIColor colorWithRed:0/255 green:156.0/255 blue:222.0/255 alpha:1];
    
    UIButton *cancleButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 515, 320, 53)];
    [cancleButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancleButton setTitleColor:[UIColor colorWithRed:0/255 green:156.0/255 blue:222.0/255 alpha:1] forState:UIControlStateNormal];
    [cancleButton addTarget:self action:@selector(didCancelClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:headLabel];
    [self addSubview:cancleButton];
    cancleButton.enabled = YES;
    
    // We want the scanner to scan with dupliate keys (to refresh RRSI every second) so it has to be done using non-main queue
//    dispatch_queue_t centralQueue = dispatch_queue_create("no.nordicsemi.ios.nrftoolbox", DISPATCH_QUEUE_SERIAL);
//    bluetoothManager = [[CBCentralManager alloc]initWithDelegate:self queue:centralQueue];
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    //[self scanForPeripherals:NO];
}

//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

- (void)didCancelClicked:(id)sender {
    [self removeFromSuperview];
}


#pragma mark Table View delegate methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [bluetoothManager stopScan];
//    //[self.navigationController popViewControllerAnimated:YES];
//    [self removeFromSuperview];
//    // Call delegate method
    [self.delegate didPeripheralSelected:[[peripherals objectAtIndex:indexPath.row] peripheral]];
    [self removeFromSuperview];
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
    cell.detailTextLabel.text =[NSString stringWithFormat:@"%d",[peripheral RSSI] ];
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

-(void)setPeripherals:(NSMutableArray *)myperipherals
{
    
    peripherals = myperipherals;
    [devicesTable reloadData];

}




@end

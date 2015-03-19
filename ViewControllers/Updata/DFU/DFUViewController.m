//
//  DFUViewController.m
//  iSeed
//
//  Created by Chan Bill on 15/1/26.
//  Copyright (c) 2015年 elias kang. All rights reserved.
//

#import "DFUViewController.h"
#import "ScannerViewController.h"
@interface DFUViewController ()
@property (strong, nonatomic) CBPeripheral *selectedPeripheral;
@property DFUOperations *dfuOperations;
@property (strong, nonatomic) IBOutlet UILabel *deviceName;
@property (strong,nonatomic) CBCentralManager *my;
@end

@implementation DFUViewController
{
    NSMutableArray *CBperArray;
    NSMutableArray *RssiArray;

}
@synthesize selectedPeripheral;
@synthesize dfuOperations;
@synthesize deviceName;
@synthesize my;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
     dfuOperations = [[DFUOperations alloc] initWithDelegate:self];
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithView];
    CBperArray = [[NSMutableArray alloc]init];
    RssiArray = [[NSMutableArray alloc]init];
    UIButton *myButton = [[UIButton alloc]init];
    [myButton setTitle:@"返回" forState:UIControlStateNormal];
    //self.navigationItem.backBarButtonItem = myButton;
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithCustomView:myButton];
    self.navigationItem.backBarButtonItem=leftButton;
    // Do any additional setup after loading the view from its nib.
    self.my = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)DeviceSelect
{
//    ScannerViewController *controller = [[ScannerViewController alloc]init];
//    [self.navigationController pushViewController:controller animated:YES];
//    // controller.filterUUID = dfuServiceUUID; - the DFU service should not be advertised. We have to scan for any device hoping it supports DFU.
//    controller.delegate = self;
    
    
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(scanTimer) userInfo:nil repeats:NO];
    //[self.my scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:@"6e40fff0-b5a3-f393-e0a9-e50e24dcca9e"]] options:@{CBCentralManagerScanOptionAllowDuplicatesKey: [NSNumber numberWithBool:NO]}];
    [self.my scanForPeripheralsWithServices:nil options:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], CBCentralManagerScanOptionAllowDuplicatesKey, nil]];

}

-(void)initWithView
{
    UIButton *SelcetButton = [[UIButton alloc]initWithFrame:CGRectMake(79, 486, 163, 43)];
    [SelcetButton setTitle:@"SelectDevice" forState:UIControlStateNormal];
    [SelcetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    SelcetButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
    SelcetButton.backgroundColor = [UIColor blackColor];
    [SelcetButton addTarget:self action:@selector(DeviceSelect) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:SelcetButton];
    
    
    UIView *firmwareView = [[UIView alloc] initWithFrame:CGRectMake(35, 133, 251, 122)];
    firmwareView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:firmwareView];
    
    UILabel *Name = [[UILabel alloc]initWithFrame:CGRectMake(12, 11, 49, 21)];
    UILabel *NameText = [[UILabel alloc]initWithFrame:CGRectMake(69, 11, 173, 21)];
    UILabel *Size = [[UILabel alloc]initWithFrame:CGRectMake(12, 40, 49, 21)];
    UILabel *SizeText = [[UILabel alloc]initWithFrame:CGRectMake(69, 40, 173, 21)];
    UILabel *Type = [[UILabel alloc]initWithFrame:CGRectMake(12, 69, 49, 21)];
    UILabel *TypeText = [[UILabel alloc]initWithFrame:CGRectMake(69, 69, 173, 21)];
    Name.text = @"name:";
    Size.text = @"size:";
    Type.text = @"type:";
    TypeText.text = @"Required";
    [firmwareView addSubview:Name];
    [firmwareView addSubview:NameText];
    [firmwareView addSubview:Size];
    [firmwareView addSubview:SizeText];
    [firmwareView addSubview:Type];
    [firmwareView addSubview:TypeText];
    
    UIButton *choiceFile = [[UIButton alloc]initWithFrame:CGRectMake(12, 92, 88, 30)];
    UIButton *choiceType = [[UIButton alloc]initWithFrame:CGRectMake(130, 92, 112, 30)];
    [choiceFile setTitle:@"Selcet File" forState:UIControlStateNormal];
    [choiceType setTitle:@"Select FileType" forState:UIControlStateNormal];
    [choiceFile setTitleColor:[UIColor colorWithRed:0/255 green:156.0/255 blue:222.0/255 alpha:1] forState:UIControlStateNormal];
    [choiceType setTitleColor:[UIColor colorWithRed:0/255 green:156.0/255 blue:222.0/255 alpha:1] forState:UIControlStateNormal];
    choiceType.titleLabel.font = [UIFont systemFontOfSize:14.0];
    choiceFile.titleLabel.font = [UIFont systemFontOfSize:14.0];
    choiceFile.enabled = YES;
    choiceType.enabled = YES;
    [firmwareView addSubview:choiceFile];
    [firmwareView addSubview:choiceType];
    
    UIView *LoadingView = [[UIView alloc]initWithFrame:CGRectMake(35, 279, 251, 93)];
    LoadingView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:LoadingView];
    
    UIButton *UpLoad = [[UIButton alloc]initWithFrame:CGRectMake(102,9 , 50, 30) ];
    [UpLoad setTitle:@"Upload" forState:UIControlStateNormal];
    UpLoad.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [UpLoad setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [LoadingView addSubview:UpLoad];
    UpLoad.enabled = YES;
    [UpLoad addTarget:self action:@selector(Uploadpressed) forControlEvents:UIControlEventTouchUpInside];
    
    SelcetButton.showsTouchWhenHighlighted =YES;
    choiceFile.showsTouchWhenHighlighted = YES;
    choiceType.showsTouchWhenHighlighted = YES;
    UpLoad.showsTouchWhenHighlighted = YES;
    
    deviceName = [[UILabel alloc]initWithFrame:CGRectMake(34, 71, 252, 27)];
    deviceName.font = [UIFont systemFontOfSize:20.0];
    deviceName.text = @"DEFAULT DFU";
    deviceName.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:deviceName];
    
    
    
    
}
-(void)Uploadpressed
{
    [self performDFU];

}
-(void)performDFU
{
    NSString* path = [NSHomeDirectory() stringByAppendingPathComponent:@"s110_v0_0.29e.hex"];
    NSLog(@"path = %@",path);
    [dfuOperations performDFUOnLocalFile:path firmwareType:APPLICATION];
   // [dfuOperations performDFUOnFile:nil firmwareType:APPLICATION];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self disableOtherButtons];
//        uploadStatus.hidden = NO;
//        progress.hidden = NO;
//        progressLabel.hidden = NO;
//        uploadButton.enabled = NO;
//    });
//    if (self.isSelectedFileZipped) {
//        switch (enumFirmwareType) {
//            case SOFTDEVICE_AND_BOOTLOADER:
//                [dfuOperations performDFUOnFiles:self.softdeviceURL bootloaderURL:self.bootloaderURL firmwareType:SOFTDEVICE_AND_BOOTLOADER];
//                break;
//            case SOFTDEVICE:
//                [dfuOperations performDFUOnFile:self.softdeviceURL firmwareType:SOFTDEVICE];
//                break;
//            case BOOTLOADER:
//                [dfuOperations performDFUOnFile:self.bootloaderURL firmwareType:BOOTLOADER];
//                break;
//            case APPLICATION:
//                [
//                break;
//                
//            default:
//                NSLog(@"Not valid File type");
//                break;
//        }
//    }
//    else {
//        [dfuOperations performDFUOnFile:selectedFileURL firmwareType:enumFirmwareType];
//    }
}


-(void)scanTimer
{
    [self.my stopScan];
    CBPeripheral *myperipheral;
    
    if (CBperArray.count>1) {
        do{
            if ([RssiArray objectAtIndex:0]>=[RssiArray objectAtIndex:1]) {
                [CBperArray removeObjectAtIndex:1];
                [RssiArray removeObjectAtIndex:1];
            }
            else{
                [CBperArray removeObjectAtIndex:0];
                [RssiArray removeObjectAtIndex:0];
            }
           
            NSLog(@"rssiarry = %@",RssiArray);
            NSLog(@"CBarray = %@",CBperArray);
            NSLog(@"rcount = %ld  CBcount = %ld",RssiArray.count,CBperArray.count);
        } while (CBperArray.count>1);
        
    }
    if (CBperArray.count>0) {
        myperipheral = [CBperArray objectAtIndex:0];
        NSLog(@"connect id = %@",myperipheral.identifier);
        
        selectedPeripheral = myperipheral;
        [dfuOperations setCentralManager:my];
        deviceName.text = myperipheral.name;
        [dfuOperations connectDevice:myperipheral];
 
    }
    else
        deviceName.text = @"未找到DFU设备";

    
    
}




#pragma mark CBcentrlDelegate
-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state == CBCentralManagerStatePoweredOn) {
        
    }

}

-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"peripheral name = %@ rssi = %@ id = %@", peripheral.name,RSSI,peripheral.identifier);
    if ([peripheral.name isEqual:@"V0Dfu"]) {
        [RssiArray addObject:RSSI];
        [CBperArray addObject:peripheral];
        
    }
}

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{




}



#pragma mark BLE
//-(void)centralManager:(CBCentralManager *)manager didPeripheralSelected:(CBPeripheral *)peripheral
//{
//    selectedPeripheral = peripheral;
//    [dfuOperations setCentralManager:manager];
//    deviceName.text = peripheral.name;
//    [dfuOperations connectDevice:peripheral];
//}
#pragma mark DFUOperations delegate methods
-(void)onDeviceConnected:(CBPeripheral *)peripheral
{
    NSLog(@"onDeviceConnected %@",peripheral.name);
//    self.isConnected = YES;
//    [self enableUploadButton];
}

-(void)onDeviceDisconnected:(CBPeripheral *)peripheral
{
    NSLog(@"device disconnected %@",peripheral.name);
    deviceName.text = @"DEFAULT DFU";
//    self.isTransferring = NO;
//    self.isConnected = NO;
//    
//    // Scanner uses other queue to send events. We must edit UI in the main queue
    dispatch_async(dispatch_get_main_queue(), ^{
    //    [self clearUI];
       // if (!self.isTransfered && !self.isTransferCancelled && !self.isErrorKnown) {
            [Utility showAlert:@"The connection has been lost"];
       // }
//        self.isTransferCancelled = NO;
//        self.isTransfered = NO;
//        self.isErrorKnown = NO;
    });
}

-(void)onDFUStarted
{
    NSLog(@"onDFUStarted");
//    self.isTransferring = YES;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        uploadButton.enabled = YES;
//        [uploadButton setTitle:@"Cancel" forState:UIControlStateNormal];
//        NSString *uploadStatusMessage = [self getUploadStatusMessage];
//        uploadStatus.text = uploadStatusMessage;
//    });
}

-(void)onDFUCancelled
{
    NSLog(@"onDFUCancelled");
//    self.isTransferring = NO;
//    self.isTransferCancelled = YES;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self enableOtherButtons];
//    });
}

-(void)onSoftDeviceUploadStarted
{
    NSLog(@"onSoftDeviceUploadStarted");
}

-(void)onSoftDeviceUploadCompleted
{
    NSLog(@"onSoftDeviceUploadCompleted");
}

-(void)onBootloaderUploadStarted
{
    NSLog(@"onBootloaderUploadStarted");
//    dispatch_async(dispatch_get_main_queue(), ^{
//        uploadStatus.text = @"uploading bootloader ...";
//    });
    
}

-(void)onBootloaderUploadCompleted
{
    NSLog(@"onBootloaderUploadCompleted");
}

-(void)onTransferPercentage:(int)percentage
{
    NSLog(@"onTransferPercentage %d",percentage);
    // Scanner uses other queue to send events. We must edit UI in the main queue
//    dispatch_async(dispatch_get_main_queue(), ^{
//        progressLabel.text = [NSString stringWithFormat:@"%d %%", percentage];
//        [progress setProgress:((float)percentage/100.0) animated:YES];
//    });
}

-(void)onSuccessfulFileTranferred
{
    NSLog(@"OnSuccessfulFileTransferred");
    // Scanner uses other queue to send events. We must edit UI in the main queue
//    dispatch_async(dispatch_get_main_queue(), ^{
//        self.isTransferring = NO;
//        self.isTransfered = YES;
//        NSString* message = [NSString stringWithFormat:@"%u bytes transfered in %u seconds", dfuOperations.binFileSize, dfuOperations.uploadTimeInSeconds];
//        [Utility showAlert:message];
//    });
}

-(void)onError:(NSString *)errorMessage
{
    NSLog(@"OnError %@",errorMessage);
//    self.isErrorKnown = YES;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [Utility showAlert:errorMessage];
//        [self clearUI];
//    });
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  DFUViewController.m
//  iSeed
//
//  Created by Chan Bill on 15/1/26.
//  Copyright (c) 2015年 elias kang. All rights reserved.
//

#import "DFUViewController.h"
#import "ScannerViewController.h"
#import "XYLoadingView.h"
#import "AppDelegate.h"
@interface DFUViewController ()
@property (strong, nonatomic) CBPeripheral *selectedPeripheral;
@property DFUOperations *dfuOperations;
@property (strong, nonatomic) IBOutlet UILabel *deviceName;
@property (strong,nonatomic) CBCentralManager *my;
@property (strong, nonatomic) IBOutlet UIProgressView *progress;
@property (strong, nonatomic) IBOutlet UILabel *progressLabel;
@property (strong, nonatomic) IBOutlet UILabel *uploadStatus;

@end

@implementation DFUViewController
{
    NSMutableArray *CBperArray;
    NSMutableArray *RssiArray;
    BOOL  isTransfered;
    XYLoadingView *loading;
    UIButton *SelcetButton;
    BOOL isConnected;
    UILabel *SizeText;
}
@synthesize selectedPeripheral;
@synthesize dfuOperations;
@synthesize deviceName;
@synthesize my;
@synthesize progress;
@synthesize progressLabel;
@synthesize uploadStatus;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
     dfuOperations = [[DFUOperations alloc] initWithDelegate:self];
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithView];
    isTransfered = NO;
    isConnected = NO;
    CBperArray = [[NSMutableArray alloc]init];
    RssiArray = [[NSMutableArray alloc]init];
    UIButton *myButton = [[UIButton alloc]init];
    [myButton setTitle:NSLocalizedStringFromTable(@"SettingVC_ReturnButton",@"MyLoaclization" , @"") forState:UIControlStateNormal];
    //self.navigationItem.backBarButtonItem = myButton;
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithCustomView:myButton];
    self.navigationItem.backBarButtonItem=leftButton;
    // Do any additional setup after loading the view from its nib.
    self.my = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(DeviceSelect) userInfo:nil repeats:NO];
    loading = [XYLoadingView loadingViewWithMessage:NSLocalizedStringFromTable(@"InforVCLoadview_Title",@"MyLoaclization" , @"")];
    [loading show];
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
    
    NSLog(@"扫描");
    [self.my scanForPeripheralsWithServices:nil options:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], CBCentralManagerScanOptionAllowDuplicatesKey, nil]];
    [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(scanTimer) userInfo:nil repeats:NO];
//    [self.my scanForPeripheralsWithServices:nil options:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], CBCentralManagerScanOptionAllowDuplicatesKey, nil]];

}

-(void)initWithView
{
    SelcetButton = [[UIButton alloc]initWithFrame:CGRectMake(79, 486, 163, 43)];
    [SelcetButton setTitle:@"Scan" forState:UIControlStateNormal];
    [SelcetButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    SelcetButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
    SelcetButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [SelcetButton addTarget:self action:@selector(DeviceSelect) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:SelcetButton];
    SelcetButton.enabled = YES;
    
    UIView *firmwareView = [[UIView alloc] initWithFrame:CGRectMake(35, 133, 251, 122)];
    firmwareView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:firmwareView];
    
    UILabel *Name = [[UILabel alloc]initWithFrame:CGRectMake(12, 11, 49, 21)];
    UILabel *NameText = [[UILabel alloc]initWithFrame:CGRectMake(69, 11, 173, 21)];
    UILabel *Size = [[UILabel alloc]initWithFrame:CGRectMake(12, 40, 49, 21)];
    SizeText = [[UILabel alloc]initWithFrame:CGRectMake(69, 40, 173, 21)];
    
    Name.text = @"name:";
    NameText.text = @"iBirthstone.hex";
    Size.text = @"size:";
    
    
    [firmwareView addSubview:Name];
    [firmwareView addSubview:NameText];
    [firmwareView addSubview:Size];
    [firmwareView addSubview:SizeText];
  
    
    UIView *LoadingView = [[UIView alloc]initWithFrame:CGRectMake(35, 279, 251, 93)];
    LoadingView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:LoadingView];
    
    UIButton *UpLoad = [[UIButton alloc]initWithFrame:CGRectMake(102,9 , 50, 30) ];
    [UpLoad setTitle:@"Upload" forState:UIControlStateNormal];
    UpLoad.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [UpLoad setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [LoadingView addSubview:UpLoad];
    UpLoad.enabled = NO;
    [UpLoad addTarget:self action:@selector(Uploadpressed) forControlEvents:UIControlEventTouchUpInside];
    
    //SelcetButton.showsTouchWhenHighlighted =YES;
    
    UpLoad.showsTouchWhenHighlighted = YES;
    
    deviceName = [[UILabel alloc]initWithFrame:CGRectMake(34, 71, 252, 27)];
    deviceName.font = [UIFont systemFontOfSize:20.0];
    deviceName.text = @"DEFAULT DFU";
    deviceName.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:deviceName];
    
    
    progress = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 67, 251, 2)];
    //[progress setTintColor:CELLTEXTLABELHIGHTCOLOR];
    
    uploadStatus = [[UILabel alloc]initWithFrame:CGRectMake(22, 41, 206, 21)];
    uploadStatus.textColor = [UIColor blackColor];
    uploadStatus.textAlignment = NSTextAlignmentCenter;
    uploadStatus.font = [UIFont systemFontOfSize:13.0];
    
    progressLabel = [[UILabel alloc]initWithFrame:CGRectMake(22, 72, 206, 21)];
    progressLabel.textColor = [UIColor blackColor];
    progressLabel.textAlignment = NSTextAlignmentCenter;
    progressLabel.font = [UIFont systemFontOfSize:13.0];
    
//    progressLabel.text = @"1111";
//    uploadStatus.text = @"22222";
    
    uploadStatus.hidden = YES;
    progress.hidden = YES;
    progressLabel.hidden = YES;
    
    uploadStatus.text = @"Wait...";
    
    [LoadingView addSubview:progress];
    [LoadingView addSubview:progressLabel];
    [LoadingView addSubview:uploadStatus];
    
}
-(void)Uploadpressed
{
    [self performDFU];

}
-(void)performDFU
{
   // NSString* path = [NSString stringWithFormat:@"%@/%@/%@",NSHomeDirectory(),@"Documents",@"s110_v0_0.29e.hex"];//s110_v0_0.36xe.hex
    
    uploadStatus.hidden = NO;
    progress.hidden = NO;
    progressLabel.hidden = NO;
    //NSURL *firmpath = [NSURL URLWithString:AppDelegateAccessor.FirmwareUpdateURL];
    //NSURL *firmpath = [NSURL URLWithString:@"http://120.24.237.180:8080/uploadfiles/ibs.hex"];
    NSLog(@"path = %@",AppDelegateAccessor.FirmwareUpdateURL);
   
 //   NSLog(@"下载的数据为%@",[NSData dataWithContentsOfURL:firmpath]);
    [dfuOperations performDFUOnFile:[NSURL URLWithString:AppDelegateAccessor.FirmwareUpdateURL] firmwareType:APPLICATION];
    //[dfuOperations performDFUOnLocalFile:path firmwareType:APPLICATION];
    
    SizeText.text = [NSString stringWithFormat:@"%lu",(unsigned long)dfuOperations.binFileSize];
    
   }


-(void)scanTimer
{
    [self.my stopScan];
    if (!isConnected) {
        [loading dismiss];
        deviceName.text = NSLocalizedStringFromTable(@"UpdateFirm_NoScaner", @"MyLoaclization" , @"");
    }
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
//        [RssiArray addObject:RSSI];
//        [CBperArray addObject:peripheral];
        
        [dfuOperations setCentralManager:my];
        deviceName.text = peripheral.name;
        [dfuOperations connectDevice:peripheral];
        
    }
}

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    
    NSLog(@"已经连接上设备");
       // [self performDFU];
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
    isConnected = YES;
//    [self enableUploadButton];
     [self performDFU];
}

-(void)onDeviceDisconnected:(CBPeripheral *)peripheral
{
    NSLog(@"device disconnected %@",peripheral.name);
    deviceName.text = @"DEFAULT DFU";
//    self.isTransferring = NO;
    isConnected = NO;
    [self clearUI];
//    
//    // Scanner uses other queue to send events. We must edit UI in the main queue
    dispatch_async(dispatch_get_main_queue(), ^{
    //    [self clearUI];
        if (!isTransfered ) {
            [Utility showAlert:@"The connection has been lost"];
        }
//        self.isTransferCancelled = NO;
        isTransfered = NO;
        [loading dismiss];
        
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
    dispatch_async(dispatch_get_main_queue(), ^{
        progressLabel.text = [NSString stringWithFormat:@"%d %%", percentage];
        [progress setProgress:((float)percentage/100.0) animated:YES];
    });
}

-(void)onSuccessfulFileTranferred
{
    NSLog(@"OnSuccessfulFileTransferred");
    // Scanner uses other queue to send events. We must edit UI in the main queue
//    dispatch_async(dispatch_get_main_queue(), ^{
//        self.isTransferring = NO;
        isTransfered = YES;
        NSString* message = [NSString stringWithFormat:@"%lu bytes transfered in %lu seconds", (unsigned long)dfuOperations.binFileSize, (unsigned long)dfuOperations.uploadTimeInSeconds];
        [Utility showAlert:message];
    [loading dismiss];
   // SelcetButton.enabled = YES;
    AppDelegateAccessor.isFirmwareNeedUpdate = NO;
    NSLog(@"DFU firm=  %d",AppDelegateAccessor.isFirmwareNeedUpdate);
    uploadStatus.text =@"Success";
    [self.navigationController popViewControllerAnimated:YES];
    
//    });
}

-(void)onError:(NSString *)errorMessage
{
    NSLog(@"OnError %@",errorMessage);
//    self.isErrorKnown = YES;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [Utility showAlert:errorMessage];
     //  [self clearUI];
//    });
}

-(void)clearUI
{
    deviceName.text = @"DEFAULT DFU";
    uploadStatus.text = @"waiting ...";
    uploadStatus.hidden = YES;
    progress.progress = 0.0f;
    progress.hidden = YES;
    progressLabel.hidden = YES;
    progressLabel.text = @"";
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

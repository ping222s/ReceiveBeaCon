//
//  ViewController.m
//  ReceiveBeaCon
//
//  Created by Ios8dian on 2017/10/27.
//  Copyright © 2017年 ping222s. All rights reserved.
//

#import "ViewController.h"

#define MY_UUID @"2B590EBE-E330-497E-89A2-A69A678D375F"
#define MY_REGION_IDENTIFIER @"123456"

@interface ViewController (){
    
    BOOL isalert;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    isalert = NO;
    
    [self turnOnBeacon];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Beacons Methods
- (void) turnOnBeacon{
    [self initLocationManager];
    [self initBeaconRegion];
    [self initDetectedBeaconsList];
    [self startBeaconRanging];
}
#pragma mark Init Beacons
- (void) initLocationManager{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        [self checkLocationAccessForRanging];
    }
}

- (void) initDetectedBeaconsList{
    if (!_detectedBeacons) {
        _detectedBeacons = [[NSArray alloc] init];
    }
}

- (void) initBeaconRegion{
    if (_region)
        return;
    
    NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:MY_UUID];
    _region = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID identifier:MY_REGION_IDENTIFIER];
    _region.notifyEntryStateOnDisplay = YES;
}

#pragma mark Beacons Ranging

- (void) startBeaconRanging{
    if (!_locationManager || !_region) {
        return;
    }
    if (_locationManager.rangedRegions.count > 0) {
        NSLog(@"Didn't turn on ranging: Ranging already on.");
        return;
    }
    
    [_locationManager startRangingBeaconsInRegion:_region];
    
}

- (void) stopBeaconRanging{
    if (!_locationManager || !_region) {
        return;
    }
    [_locationManager stopRangingBeaconsInRegion:_region];
}

//Location manager delegate method
- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region{
    if (beacons.count == 0) {
        NSLog(@"No beacons found nearby.");
    } else {
        _detectedBeacons = beacons;
        NSLog(@"beacons count:%lu", beacons.count);
        
        for (CLBeacon *beacon in beacons) {
            NSLog(@"%@", [self detailsStringForBeacon:beacon]);
        }
    }
}

#pragma mark Process Beacon Information
//将beacon的信息转换为NSString并返回
- (NSString *)detailsStringForBeacon:(CLBeacon *)beacon
{
//    if(beacon.accuracy < 2){
//        isalert = NO;
//    }
    
    if (beacon.accuracy < 5 && !isalert) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"message:@"欢迎来到" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:nil];
        isalert = YES;
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"谢谢" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:cancelAction];
        [alert addAction:okAction];
    }
    
    NSString *format = @"%@ • %@ • %@ • %f • %li";
    return [NSString stringWithFormat:format, beacon.major, beacon.minor, [self stringForProximity:beacon.proximity], beacon.accuracy, beacon.rssi];
}

- (NSString *)stringForProximity:(CLProximity)proximity{
    NSString *proximityValue;
    switch (proximity) {
        case CLProximityNear:
            proximityValue = @"Near";
            break;
        case CLProximityImmediate:
            proximityValue = @"Immediate";
            break;
        case CLProximityFar:
            proximityValue = @"Far";
            break;
        case CLProximityUnknown:
        default:
            proximityValue = @"Unknown";
            break;
    }
    return proximityValue;
}

- (void)checkLocationAccessForRanging {
    if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [_locationManager requestWhenInUseAuthorization];
    }
}

@end

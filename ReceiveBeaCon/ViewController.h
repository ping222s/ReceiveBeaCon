//
//  ViewController.h
//  ReceiveBeaCon
//
//  Created by Ios8dian on 2017/10/27.
//  Copyright © 2017年 ping222s. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController<CLLocationManagerDelegate>{
    CLLocationManager *_locationManager;
    CLBeaconRegion *_region;
    NSArray *_detectedBeacons;
}
@end


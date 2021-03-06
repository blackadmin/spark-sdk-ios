//
//  SparkViewController.m
//  Spark-SDK
//
//  Created by Ido Kleinman on 03/01/2015.
//  Copyright (c) 2014 Ido Kleinman. All rights reserved.
//

#import "SparkViewController.h"
#import "Spark-SDK.h"

@interface SparkViewController ()

@end

@implementation SparkViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)testButton:(id)sender {
    // logging in
    [[SparkCloud sharedInstance] loginWithUser:@"ido@particle.io" password:@"<password>" completion:^(NSError *error) {
        if (!error)
            NSLog(@"Logged in to cloud");
        else
            NSLog(@"Wrong credentials or no internet connectivity, please try again");
    }];
    
    // get specific device by name:
    __block SparkDevice *myPhoton;
    
    [[SparkCloud sharedInstance] getDevices:^(NSArray *sparkDevices, NSError *error) {
        NSLog(@"%@",sparkDevices.description); // print all devices claimed to user
      
        // search for a specific device by name
        for (SparkDevice *device in sparkDevices)
        {
            if ([device.name isEqualToString:@"myNewPhotonName"])
                myPhoton = device;
        }
    }];
    
    // reading a variable
    [myPhoton getVariable:@"temprature" completion:^(id result, NSError *error) {
        if (!error)
        {
            NSNumber *tempratureReading = (NSNumber *)result;
            NSLog(@"Room temprature is %f degrees",tempratureReading.floatValue);
        }
        else
        {
            NSLog(@"Failed reading temprature from Photon device");
        }
    }];
    
    // calling a function
    [myPhoton callFunction:@"digitalwrite" withArguments:@[@"D7",@1] completion:^(NSNumber *resultCode, NSError *error) {
        if (!error)
        {
            NSLog(@"LED on D7 successfully turned on");
        }
    }];
    
    // get a device instance by ID
    __block SparkDevice *myOtherDevice;
    NSString *deviceID = @"53fa73265066544b16208184";
    [[SparkCloud sharedInstance] getDevice:deviceID completion:^(SparkDevice *device, NSError *error) {
        if (!error)
            myOtherDevice = device;
    }];
    
    // get device variables and functions
    NSDictionary *myDeviceVariables = myPhoton.variables;
    NSLog(@"MyDevice first Variable is called %@ and is from type %@", myDeviceVariables.allKeys[0], myDeviceVariables.allValues[0]);
    
    NSArray *myDeviceFunctions = myPhoton.functions;
    NSLog(@"MyDevice first Function is called %@", myDeviceFunctions[0]);
    
    // renaming a device
    myPhoton.name = @"myNewDeviceName";
    [myPhoton rename:@"myNewDeviecName" completion:^(NSError *error) {
        if (!error)
            NSLog(@"Device renamed successfully");
    }];
    
    // removing a device from your account
    [myPhoton unclaim:^(NSError *error) {
        if (!error)
            NSLog(@"Device was successfully removed from your account");
    }];
    

    // logout
    [[SparkCloud sharedInstance] logout];
    
}

@end

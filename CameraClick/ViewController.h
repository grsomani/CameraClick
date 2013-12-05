//
//  ViewController.h
//  CameraClick
//
//  Created by aptara on 02/12/13.
//  Copyright (c) 2013 GS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *cameraView;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *galleryBtn;
@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;
@property (copy,   nonatomic) NSURL *movieURL;

@end

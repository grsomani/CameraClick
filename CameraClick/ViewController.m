//
//  ViewController.m
//  CameraClick
//
//  Created by aptara on 02/12/13.
//  Copyright (c) 2013 GS. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize cameraView;
@synthesize moviePlayer = _moviePlayer;
@synthesize movieURL = _movieURL;
@synthesize popoverController;
UIImagePickerController *imgPicker;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (IBAction)openGallery:(UIButton *)sender
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        imgPicker = [[UIImagePickerController alloc] init];
        imgPicker.delegate = self;
        imgPicker.allowsEditing = NO;
        imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imgPicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:imgPicker.sourceType];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
            popoverController = [[UIPopoverController alloc] initWithContentViewController:imgPicker];
            [popoverController presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        else
        {
            [self presentViewController:imgPicker animated:YES completion:nil];
        }
    }
}

#pragma mark - UIImagePicker Delegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if([mediaType isEqualToString: (NSString *)kUTTypeImage])
    {
        self.cameraView.image = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    else if([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        self.movieURL = info[UIImagePickerControllerMediaURL];
        NSLog(@"URL is %@",self.movieURL);
    }
    
    if(self.movieURL != nil)
    {
        UIButton *playMovieButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        playMovieButton.frame = CGRectMake(_galleryBtn.frame.origin.x + 150, _galleryBtn.frame.origin.y, 100, _galleryBtn.frame.size.height);
        [playMovieButton setTitle:@"Play Movie" forState:UIControlStateNormal];
        [playMovieButton addTarget:self action:@selector(playMovie) forControlEvents:UIControlEventTouchDown];
        playMovieButton.tag = 101;
        [self.view addSubview:playMovieButton];
    }
    [popoverController dismissPopoverAnimated:YES];
    popoverController = nil;
}

-(void) playMovie
{
    self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:self.movieURL];
    [self.moviePlayer prepareToPlay];
    self.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    [self.moviePlayer.view setFrame:self.view.frame];
    
    [self.view addSubview:self.moviePlayer.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:self.moviePlayer];
    
    [self.moviePlayer play];

}

// When the movie is done, release the controller.
- (void)moviePlayBackDidFinish:(NSNotification *)notification {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    [[self.view viewWithTag:101] removeFromSuperview];
    [self.moviePlayer stop];
    [self.moviePlayer.view removeFromSuperview];
    self.movieURL = nil;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
{
    
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

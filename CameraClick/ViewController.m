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

UIPopoverController *popover;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void) viewWillDisappear:(BOOL)animated
{
    
}

-(void) viewDidDisappear:(BOOL)animated
{
    
}

- (IBAction)shoot:(UIButton *)sender
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        NSLog(@"UIImagePickerControllerSourceTypeCamera is available");
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

- (IBAction)openGallery:(UIButton *)sender
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
            popover = [[UIPopoverController alloc] initWithContentViewController:picker];
            [popover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        else
        {
            [self presentViewController:picker animated:YES completion:nil];
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
        
        //Copy file to our directory
        NSString * documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString * storePath = [documentsDirectory stringByAppendingPathComponent:@"myMovie.MOV"];
        
        NSError * error = nil;
        
        //replace file if it already exits
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:storePath] == YES)
        {
            [[NSFileManager defaultManager]  removeItemAtPath:storePath error:&error];
        }
        [[NSFileManager defaultManager] copyItemAtURL:self.movieURL
                                                toURL:[NSURL fileURLWithPath:storePath]
                                                error:&error];
        
        if ( error )
            NSLog(@"%@", error);

    }
    
    if([popover isPopoverVisible])
        [popover dismissPopoverAnimated:YES];
    else
        [picker dismissViewControllerAnimated:YES completion:NULL];
    
    if(self.movieURL != nil)
    {
        [self playMovie];
    }
}

-(void) playMovie
{
//    self.moviePlayer = [[MPMoviePlayerController alloc] init];
//    [self.moviePlayer setContentURL:self.movieURL];
//    self.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
//    [self.moviePlayer.view setFrame:CGRectMake ( 0, 0, 320, 476)];
//    
//    [self.view addSubview:self.moviePlayer.view];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(moviePlayBackDidFinish:)
//                                                 name:MPMoviePlayerPlaybackDidFinishNotification
//                                               object:self.moviePlayer];
//    
//    [self.moviePlayer play];
    
    NSURL *vedioURL;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSArray *filePathsArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:documentsDirectory  error:nil];
    NSLog(@"files array %@", filePathsArray);
    
    NSString *fullpath = [documentsDirectory stringByAppendingPathComponent:@"/myMovie.MOV"];
    vedioURL = [NSURL fileURLWithPath:fullpath];
    
    NSLog(@"vurl %@",vedioURL);
    MPMoviePlayerViewController *videoPlayerView = [[MPMoviePlayerViewController alloc] initWithContentURL:vedioURL];
    [self presentMoviePlayerViewControllerAnimated:videoPlayerView];
    [videoPlayerView.moviePlayer play];
}

// When the movie is done, release the controller.
- (void)moviePlayBackDidFinish:(NSNotification *)notification {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    [self.moviePlayer stop];
    [self.moviePlayer.view removeFromSuperview];
    self.movieURL = nil;
    self.moviePlayer = nil;
    
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

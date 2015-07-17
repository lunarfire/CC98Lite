//
//  CC98EditPostViewController.m
//  CC98Lite
//
//  Created by S on 15/6/13.
//  Copyright (c) 2015年 zju. All rights reserved.
//

#import "CC98EditPostViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIColor+CC98Style.h"
#import "CC98Topic.h"
#import "CC98Post.h"
#import "CC98Client.h"
#import "NSString+CC98Style.h"
#import "NSError+CC98Style.h"
#import "UIViewController+KNSemiModal.h"
#import "CC98FaceIconMultiplePageView.h"
#import "CC98PostListViewController.h"
#import "UIImage+CC98Style.h"

@interface CC98EditPostViewController () <UITextViewDelegate, UITextFieldDelegate, CC98FaceIconPageViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *postTitle;
@property (weak, nonatomic) IBOutlet UITextView *postContent;
@property (weak, nonatomic) IBOutlet UILabel *postPlaceholder;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet CC98FaceIconMultiplePageView *faceIconPage;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *pictureItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *faceItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *keyboardItem;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolBarBottomLocation;

@end

@implementation CC98EditPostViewController

- (IBAction)takePhotos:(UIBarButtonItem *)sender {
    UIImagePickerController *uiipc = [[UIImagePickerController alloc] init];
    uiipc.delegate = self;
    uiipc.mediaTypes = @[(NSString *)kUTTypeImage];
    uiipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    uiipc.allowsEditing = YES;
    [self presentViewController:uiipc animated:YES completion:NULL];
}

- (IBAction)choosePicture:(UIBarButtonItem *)sender {
    UIImagePickerController *uiipc = [[UIImagePickerController alloc] init];
    uiipc.delegate = self;
    uiipc.mediaTypes = @[(NSString *)kUTTypeImage];
    uiipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:uiipc animated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:NULL];

    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (!image) image = info[UIImagePickerControllerOriginalImage];
    
    static const NSUInteger MAX_FILE_SIZE = 512*1024;
    ALAssetsLibrary* alLibrary = [[ALAssetsLibrary alloc] init];

    [alLibrary assetForURL:[info objectForKey:UIImagePickerControllerReferenceURL] resultBlock:^(ALAsset *asset) {        
        CGFloat compressionQuality = 1.0f;
        CGFloat maxCompressionQuality = 0.1f;

        NSData *imageToUpload = UIImageJPEGRepresentation([image imageScaledToMaxWidth:400 maxHeight:400], compressionQuality);
        while ([imageToUpload length] >= MAX_FILE_SIZE && compressionQuality > maxCompressionQuality) {
            compressionQuality -= 0.1f;
            imageToUpload = UIImageJPEGRepresentation([image imageScaledToMaxWidth:400 maxHeight:400], compressionQuality);
        }
        
        [[CC98Client sharedInstance] POST:[NSString stringWithFormat:@"saveannouce_upfile.asp?boardid=%@", self.post.boardID]
                               parameters:nil
                constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                    [formData appendPartWithFormData:[@"upload" dataUsingEncoding:NSUTF8StringEncoding] name:@"act"];
                    [formData appendPartWithFormData:[@"zju1.jpg" dataUsingEncoding:NSUTF8StringEncoding] name:@"fname"];
                    [formData appendPartWithFileData:imageToUpload name:@"file1" fileName:@"zju1.jpg" mimeType:@"image/jpeg"];

                } success:^(NSURLSessionDataTask *task, id responseObject) {
                    NSString *content = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                    
                    if ([content rangeOfString:@"文件上传成功"].length == 0) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSError cc98ErrorDomain] message:@"图片上传失败"
                            delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                        [alert show];
                    } else {
                        NSString *imageURL = [content firstMatchRegex:@"(?<=\\[upload=jpg,1\\]).*?(?=\\[/upload\\])"];
                        self.postContent.text = [NSString stringWithFormat:@"%@[upload=jpg]%@[/upload]\n", self.postContent.text, imageURL];
                        [self textViewDidChange:self.postContent];
                    }
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSError cc98ErrorDomain] message:@"图片上传失败"
                                                                   delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                    [alert show];
        }];
    }
    failureBlock:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSError cc98ErrorDomain] message:@"图片获取失败"
                                                       delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
    }];
}

- (IBAction)hideKeyboard:(UIBarButtonItem *)sender {
    if (self.postTitle.isFirstResponder) {
        [self.postTitle resignFirstResponder];
    } else if (self.postContent.isFirstResponder) {
        [self.postContent resignFirstResponder];
    }
    
    [self.keyboardItem setImage:nil];
    [self.keyboardItem setEnabled:NO];
}

- (IBAction)selectFaceIcon:(UIBarButtonItem *)sender {
    if (self.postTitle.isFirstResponder) {
        return;
    }
    
    if (self.faceIconPage.hidden == YES) {
        if (self.postContent.isFirstResponder) {
            [self.postContent resignFirstResponder];
        }
        
        self.faceIconPage.hidden = NO;
        self.toolBarBottomLocation.constant = self.faceIconPage.frame.size.height;
        
        [UIView animateWithDuration:0.2 animations:^{
            [self.view setNeedsLayout];
            [self.view layoutIfNeeded];
        } completion:nil];
        
        [self.postContent scrollRangeToVisible:self.postContent.selectedRange];
    } else {
        self.faceIconPage.hidden = YES;
        [self.postContent becomeFirstResponder];
    }
}

- (void)presetPostContent {
    if (self.presetContent.length > 0) {
        self.postContent.text = self.presetContent;
        self.postContent.selectedRange = NSMakeRange(self.presetContent.length, 0);
        [self textViewDidChange:self.postContent];
    }
}

- (NSString *)presetContent {
    if (!_presetContent) {
        _presetContent = @"";
    }
    return _presetContent;
}

- (void)didSelectFaceIconWithString:(NSString *)faceIconString {
    NSUInteger location = self.postContent.selectedRange.location;

    NSString *content = self.postContent.text;
    NSString *partOne = [content substringToIndex:location];
    NSString *partTwo = [content substringFromIndex:location];

    self.postContent.text = [NSString stringWithFormat:@"%@%@%@", partOne, faceIconString, partTwo];
    self.postContent.selectedRange = NSMakeRange(location+faceIconString.length, 0);

    [self textViewDidChange:self.postContent];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.postTitle.delegate = self;
    self.postPlaceholder.text = @"帖子内容 ...";
    
    self.postContent.delegate = self;
    self.postContent.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    self.postContent.layoutManager.allowsNonContiguousLayout = NO;
    [self presetPostContent];
    
    CGRect newFrame = self.faceIconPage.frame;
    newFrame.size.width = self.view.frame.size.width;
    self.faceIconPage.frame = newFrame;
    [self.faceIconPage setupUserInterface];
    self.faceIconPage.delegate = self;
    
    [self.cameraItem setImage:[UIImage imageNamed:@"camera"]];
    [self.pictureItem setImage:[UIImage imageNamed:@"picture"]];
    [self.faceItem setImage:[UIImage imageNamed:@"face"]];
    
    self.cameraItem.enabled = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ? YES : NO;
    self.tabBarController.tabBar.hidden = YES;
    
    [self.keyboardItem setImage:nil];
    [self.keyboardItem setEnabled:NO];
    
    NSDictionary *dict = @{NSForegroundColorAttributeName: [UIColor lightGrayColor]};
    self.postTitle.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"帖子标题 ..."
                                                                           attributes:dict];
    self.navigationItem.title = @"发布帖子";
    
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                         style:UIBarButtonItemStylePlain
                                                                        target:self
                                                                        action:@selector(cancelPost)];
    self.navigationItem.leftBarButtonItem = cancelButtonItem;
    
    UIBarButtonItem *postButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发表"
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(proposePost)];
    self.navigationItem.rightBarButtonItem = postButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.postContent scrollRangeToVisible:self.postContent.selectedRange];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    if (self.toolBarBottomLocation.constant != keyboardRect.size.height) {
        self.toolBarBottomLocation.constant = keyboardRect.size.height;
    }
    
    double duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    } completion:nil];
    
    [self.keyboardItem setImage:[UIImage imageNamed:@"keyboard"]];
    [self.keyboardItem setEnabled:YES];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.toolBarBottomLocation.constant = 0;
    
    NSDictionary *userInfo = [notification userInfo];
    double duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    } completion:nil];
    
    [self.keyboardItem setImage:nil];
    [self.keyboardItem setEnabled:NO];
}

- (void)cancelPost {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)proposePost {
    self.post.title = self.postTitle.text;
    self.post.content = self.postContent.text;
    
    [self.post postWithBlock:^(NSError *error) {
        if (error != nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:error.domain
                                                            message:error.localizedDescription
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"发帖成功"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            [self.navigationController popViewControllerAnimated:YES];
            
            NSArray *viewControllers = self.navigationController.viewControllers;
            UIViewController *previousVC = [viewControllers objectAtIndex:viewControllers.count-1];
            
            if ([previousVC isKindOfClass:[CC98PostListViewController class]]) {
                CC98PostListViewController *postListVC = (CC98PostListViewController *)previousVC;
                [postListVC reloadContent];
            }
            ;
        }
    }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.faceIconPage.hidden == NO) {
        self.faceIconPage.hidden = YES;
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (self.faceIconPage.hidden == NO) {
        self.faceIconPage.hidden = YES;
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 0) {
        self.postPlaceholder.hidden = YES;
    } else {
        self.postPlaceholder.hidden = NO;
    }
}


@end

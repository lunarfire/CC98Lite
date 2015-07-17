/*
 
 UIWebView+Clean.h
 
 A simple category that performs recommended UIWebView clean before dealloc
 
 Created by Jason Baker (jason@onejasonforsale.com) for TumbleOn on 3/18/12.
 
 Copyright (c) 2012, Pocket Sized Giraffe, LLC
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met: 
 
 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer. 
 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution. 
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 The views and conclusions contained in the software and documentation are those
 of the authors and should not be interpreted as representing official policies, 
 either expressed or implied.
 
 */

#import "UIWebView+Clean.h"

@implementation UIWebView (clean)

/*
 
 Using this Category is easy, simply add this to the top of your file where 
 you have a UIWebView:
 
 #import "UIWebView+Clean.h"
 
 Then, any time you want to throw away or deallocate a UIWebView instance, do 
 the following before you throw it away:
 
 [self.webView cleanForDealloc];
 self.webView = nil;
 
 If you still have leak issues, read the notes at the bottom of this class, 
 they  may help you.
 
 */


- (void) cleanForDealloc
{
    /*
     
     There are several theories and rumors about UIWebView memory leaks, and how 
     to properly handle cleaning a UIWebView instance up before deallocation. This 
     method implements several of those recommendations. 
     
     #1: Various developers believe UIWebView may not properly throw away child 
     objects & views without forcing the UIWebView to load empty content before 
     dealloc.
     
     Source: http://stackoverflow.com/questions/648396/does-uiwebview-leak-memory
     
     */        
    [self loadHTMLString:@"" baseURL:nil];
    
    /*
     
     #2: Others claim that UIWebView's will leak if they are loading content 
     during dealloc.
     
     Source: http://stackoverflow.com/questions/6124020/uiwebview-leaking
     
     */
    [self stopLoading];
    
    /*
     
     #3: Apple recommends setting the delegate to nil before deallocation: 
     "Important: Before releasing an instance of UIWebView for which you have set 
     a delegate, you must first set the UIWebView delegate property to nil before 
     disposing of the UIWebView instance. This can be done, for example, in the 
     dealloc method where you dispose of the UIWebView."
     
     Source: UIWebViewDelegate class reference     
     
     */
    self.delegate = nil;
    
    
    /*
     
     #4: If you're creating multiple child views for any given view, and you're 
     trying to deallocate an old child, that child is pointed to by the parent 
     view, and won't actually deallocate until that parent view dissapears. This 
     call below ensures that you are not creating many child views that will hang 
     around until the parent view is deallocated.
     */
    
    [self removeFromSuperview];
    
    /* 
     
     Further Help with UIWebView leak problems: 
     
     #1: Consider implementing the following in your UIWebViewDelegate:
     
     - (void) webViewDidFinishLoad:(UIWebView *)webView
     {
        //source: http://blog.techno-barje.fr/post/2010/10/04/UIWebView-secrets-part1-memory-leaks-on-xmlhttprequest/
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
     }
     
     #2: If you can, avoid returning NO in your UIWebViewDelegate here:
     
     - (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
     {
        //this source says don't do this: http://stackoverflow.com/questions/6421813/lots-of-uiwebview-memory-leaks
        //return NO;
        return YES;
     }
     
     #3: Some leaks appear to be fixed in IOS 4.1
     Source: http://stackoverflow.com/questions/3857519/memory-leak-while-using-uiwebview-load-request-in-ios4-0
     
     #4: When you create your UIWebImageView, disable link detection if possible:         
     
     webView.dataDetectorTypes = UIDataDetectorTypeNone;
     
     (This is also the "Detect Links" checkbox on a UIWebView in Interfacte Builder.)
     
     Sources:
     http://www.iphonedevsdk.com/forum/iphone-sdk-development/46260-how-free-memory-after-uiwebview.html
     http://www.iphonedevsdk.com/forum/iphone-sdk-development/29795-uiwebview-how-do-i-stop-detecting-links.html
     http://blog.techno-barje.fr/post/2010/10/04/UIWebView-secrets-part2-leaks-on-release/
     
     #5: Consider cleaning the NSURLCache every so often:
     
     [[NSURLCache sharedURLCache] removeAllCachedResponses];
     [[NSURLCache sharedURLCache] setDiskCapacity:0];
     [[NSURLCache sharedURLCache] setMemoryCapacity:0];
     
     Source: http://blog.techno-barje.fr/post/2010/10/04/UIWebView-secrets-part2-leaks-on-release/
     
     Be careful with this, as it may kill cache objects for currently executing URL 
     requests for your application, if you can't cleanly clear the whole cache in 
     your app in some place where you expect zero URLRequest to be executing, use 
     the following instead after you are done with each request (note that you won't 
     be able to do this w/ UIWebView's internal request objects..):
     
     [[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];
     
     Source: http://stackoverflow.com/questions/6542114/clearing-a-webviews-cache-for-local-files  
     
     */
}

@end

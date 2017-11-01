//
//  TCWebViewController.m
//  SecurityNote
//
//  Created by Des on 2017/9/27.
//  Copyright © 2017年 JoonSheng. All rights reserved.
//

#import "TCWebViewController.h"
#import "MBProgressHUD.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
@interface TCWebViewController ()<UIWebViewDelegate>
{
    
    UIWebView *_webView;
    UIPercentDrivenInteractiveTransition *_interactiveTransition;
}
@end



@implementation TCWebViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    self.navigationController.navigationBarHidden=YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = NO;
    CGFloat H= [[UIScreen mainScreen] bounds].size.height;
    CGFloat W= [[UIScreen mainScreen] bounds].size.width;
    self.view.backgroundColor=[UIColor orangeColor];
    _webView=[[UIWebView alloc] initWithFrame:CGRectMake(0,0,W,H)];
    
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
    [_webView loadRequest:request];
    _webView.delegate=self;
    _webView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    [self.view addSubview:_webView];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}


-(void)webViewDidStartLoad:(UIWebView *)webView{
    
    //    NSString *requests=[webView.request.URL absoluteString];
    //    webViewController *vc=[[webViewController alloc] init];
    //    vc.url=requests;
    //    [self.navigationController pushViewController:vc animated:YES];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
   
    NSString *requests=[webView.request.URL absoluteString];
//    NSLog(@"---------%@------------",requests);
//    if(requests!=nil){
    
//    if(navigationType==UIWebViewNavigationTypeLinkClicked){
//        NSLog(@"1-------------%@----",requests);
//    }else if (navigationType==UIWebViewNavigationTypeFormSubmitted){
//        NSLog(@"2------------%@----",requests);
//    }else if (navigationType==UIWebViewNavigationTypeBackForward){
//        NSLog(@"3-----------%@----",requests);
//    }else if (navigationType==UIWebViewNavigationTypeReload){
//        NSLog(@"4-----------%@----",requests);
//    }else if (navigationType==UIWebViewNavigationTypeFormResubmitted){
//        NSLog(@"5-----------%@----",requests);
//    }else if (navigationType==UIWebViewNavigationTypeOther){
//        NSLog(@"6-----------%@----",requests);
//    }
    
    
    
        if (navigationType == UIWebViewNavigationTypeLinkClicked)
        {
            NSLog(@"1-----------%@----",requests);

//            if([requests isEqualToString:_url] || requests==nil){
//                return YES;
//            }else{
                TCWebViewController *vc=[[TCWebViewController alloc] init];
                vc.url=requests;
                self.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:vc animated:YES];
                return NO;
//            }

//            return YES;
        }else{
            NSLog(@"2-----------%@----",requests);
            return YES;
        }
//    }else{
//        return YES;
//    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

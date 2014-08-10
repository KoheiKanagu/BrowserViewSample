//  Copyright (c) 2014年 KoheiKanagu. All rights reserved.

#import "BrowserViewController.h"

@implementation BrowserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 300, 44)];
    [mySearchBar setPlaceholder:@"URL"];
    [mySearchBar setKeyboardType:UIKeyboardTypeURL];
    [mySearchBar setSearchBarStyle:UISearchBarStyleMinimal];
    [mySearchBar setDelegate:self];
    
    UIView *searchBarContainer = [[UIView alloc]initWithFrame:mySearchBar.frame];
    [searchBarContainer addSubview:mySearchBar];
    
    [self.navigationItem setTitleView:searchBarContainer];
    [self.navigationItem.titleView setFrame:searchBarContainer.frame];

    [self setToolbarItems:[self initializeToolBarButton]];
    [beforeButtonItem setEnabled:NO];
    [nextButtonItem setEnabled:NO];
    [refreshButtonItem setEnabled:NO];
}

-(NSArray *)initializeToolBarButton
{
    beforeButtonItem = [self makeBarButtonItemWith:101
                                            action:@selector(beforePageButtonAction:)];
    nextButtonItem = [self makeBarButtonItemWith:102
                                          action:@selector(nextPageButtonAction:)];
    refreshButtonItem = [self makeBarButtonItemWith:UIBarButtonSystemItemRefresh
                                             action:@selector(refreshButtonAction:)];
    
    UIBarButtonItem *fixedSpace = [self makeBarButtonItemWith:UIBarButtonSystemItemFixedSpace
                                                       action:nil];
    fixedSpace.width = 42;
    UIBarButtonItem *flexibleSpace = [self makeBarButtonItemWith:UIBarButtonSystemItemFlexibleSpace
                                                          action:nil];
    return @[beforeButtonItem, fixedSpace, nextButtonItem, flexibleSpace, refreshButtonItem];
}

-(UIBarButtonItem *)makeBarButtonItemWith:(UIBarButtonSystemItem )systemItem action:(SEL)action
{
    return [[UIBarButtonItem alloc]initWithBarButtonSystemItem:systemItem
                                                        target:self
                                                        action:action];
}

-(void)viewDidAppear:(BOOL)animated
{
    [myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.google.co.jp/"]]];
}

#pragma mark - ButtonAction

-(void)beforePageButtonAction:(UIBarButtonItem *)item
{
    [myWebView stopLoading];
    [myWebView goBack];
}

-(void)nextPageButtonAction:(UIBarButtonItem *)item
{
    [myWebView stopLoading];
    [myWebView goForward];
}

-(void)refreshButtonAction:(UIBarButtonItem *)item
{
    [myWebView reload];
}


#pragma mark - UIWebView

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = request.URL;
    if([[url scheme] isEqualToString:@"http"] || [[url scheme] isEqualToString:@"https"]){
        return YES;
    }
    [[UIApplication sharedApplication] openURL:url];
    return NO;
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    refreshButtonItem.enabled = NO;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    if(webView.canGoBack){
        beforeButtonItem.enabled = YES;
    }else{
        beforeButtonItem.enabled = NO;
    }
    if(webView.canGoForward){
        nextButtonItem.enabled = YES;
    }else{
        nextButtonItem.enabled = NO;
    }
    refreshButtonItem.enabled = YES;
    
    [mySearchBar setText:[webView stringByEvaluatingJavaScriptFromString:@"document.URL"]];
    requestURL = [NSURL URLWithString:mySearchBar.text];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if(error){
        NSLog(@"%@", error.localizedDescription);
    }
}



#pragma mark - UISearchBar

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    if(searchBar.text.length){
        [searchBar setShowsCancelButton:YES
                               animated:YES];
    }
}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)searchText
{
    [searchBar setShowsCancelButton:YES
                           animated:YES];
}

-(void)searchBarCancelButtonClicked:(UISearchBar*)searchBar
{
    [searchBar setShowsCancelButton:NO
                           animated:YES];
    [searchBar resignFirstResponder];
    
    if(!searchBar.text.length){
        searchBar.text = [requestURL description];
    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar*)searchBar
{
    [searchBar setShowsCancelButton:NO
                           animated:YES];
    [searchBar resignFirstResponder];
    [myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:searchBar.text]]];
}

@end

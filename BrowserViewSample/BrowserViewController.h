//  Copyright (c) 2014年 KoheiKanagu. All rights reserved.

#import <UIKit/UIKit.h>

@interface BrowserViewController : UIViewController <UISearchBarDelegate, UIWebViewDelegate>
{
    IBOutlet UIWebView *myWebView;
    UISearchBar *mySearchBar;
    
    NSURL *requestURL;
    
    UIBarButtonItem *beforeButtonItem;
    UIBarButtonItem *nextButtonItem;
    UIBarButtonItem *refreshButtonItem;
}


@end

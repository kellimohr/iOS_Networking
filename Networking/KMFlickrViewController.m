//
//  KMFlickrViewController.m
//  Networking
//
//  Created by Kelli Mohr on 11/14/13.
//  Copyright (c) 2013 Kelli Mohr. All rights reserved.
//

#import "KMFlickrViewController.h"
#import <RestKit/RestKit.h>
#import "KMPhoto.h"
#import <JSONKit/JSONKit.h>
#define kCLIENTID "f0c7467314cb4fc4c0d1ffe1977440f8"
#define kCLIENTSECRET "9d53123a7d8d170a"

NSString *const FlickrAPIKey = @"f0c7467314cb4fc4c0d1ffe1977440f8";

@interface KMFlickrViewController () //: UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *photoSmallImageData;
    NSMutableArray *photoTitles;
}

@end

@implementation KMFlickrViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        photoSmallImageData = [[NSMutableArray alloc] init];
        photoTitles = [[NSMutableArray alloc] init];
        
        [self searchFlickrPhotos:@"cat"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)searchFlickrPhotos:(NSString *)text
{
    // Build the string to call the Flickr API
    NSString *urlString =
    [NSString stringWithFormat:
     @"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&tags=%@&per_page=15&format=json&nojsoncallback=1", FlickrAPIKey, text];
    
    // Create NSURL string from formatted string
    NSURL *url = [NSURL URLWithString:urlString];
    
    // Setup and start async download
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *results = [jsonString JSONData];
    
    NSArray *photos = [[results objectForKey:@"photos"] objectForKey:@"photo"];
    
    for (NSDictionary *photo in photos)
    {
        NSString *title = [photo objectForKey:@"title"];
        [photoTitles addObject:(title.length > 0 ? title: @"Untitled")];
        
        NSString *URLString = [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_s.jpg",
                               [photo objectForKey:@"farm"], [photo objectForKey:@"server"],
                               [photo objectForKey:@"id"], [photo objectForKey:@"secret"]];
        
        NSLog(@"photoURLString: %@", URLString);
        
        [photoSmallImageData addObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:URLString]]];
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return photoTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [photoTitles objectAtIndex:indexPath.row];
    NSData *imageData = [photoSmallImageData objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageWithData:imageData];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end

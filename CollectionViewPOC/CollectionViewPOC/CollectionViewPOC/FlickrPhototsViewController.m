//
//  FlickrPhototsViewController.m
//  CollectionViewPOC
//
//  Created by Qingchuan Zhu on 7/26/18.
//  Copyright © 2018 Qingchuan Zhu. All rights reserved.
//

#import "FlickrPhototsViewController.h"
#import "CollectionViewPOC-Swift.h"

@interface FlickrPhototsViewController ()<UITextFieldDelegate>

@property (nonatomic, assign) UIEdgeInsets const sectionInsets;
@property (nonatomic, strong) NSMutableArray<FlickrSearchResults *> *searches;
@property (nonatomic, strong) Flickr *flickr;

@end

@implementation FlickrPhototsViewController

static NSString * const reuseIdentifier = @"FlickrCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sectionInsets = UIEdgeInsetsMake(50.0, 20.0, 50.0, 20.0);
    self.searches = [NSMutableArray new];
    self.flickr = [Flickr new];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete implementation, return the number of sections
    return 0;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of items
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

#pragma mark Utilities
- (FlickrPhoto *)photoForIndexPath:(NSIndexPath *)indexPath{
    return self.searches[indexPath.section].searchResults[indexPath.row];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [textField addSubview:activityIndicator];
    activityIndicator.frame = textField.bounds;
    [activityIndicator startAnimating];
    __weak FlickrPhototsViewController *weakSelf = self;
    
    [self.flickr searchFlickrForTerm:textField.text completion:^(FlickrSearchResults * _Nullable results, NSError * _Nullable error) {
        [activityIndicator removeFromSuperview];
        if (error) {
            NSLog(@"error happened: %@", error.description);
            return;
        }
        if (results) {
            NSLog(@"Found %ld results matching %@", results.searchResults.count, results.searchTerm);
            [weakSelf.searches insertObject:results atIndex:0];
            [weakSelf.collectionView reloadData];
        }
    }];
    
    textField.text = nil;
    [textField resignFirstResponder];
    return YES;
}

@end

//
//  SICatalogsViewController.m
//  SUS Inspector
//
//  Created by Juutilainen Hannes on 8.3.2013.
//  Copyright (c) 2013 Hannes Juutilainen. All rights reserved.
//

#import "SICatalogsViewController.h"
#import "DataModelHeaders.h"

@interface SICatalogsViewController ()

@end

@implementation SICatalogsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)updateSourceList
{
    // Expand all items in the source list
    [self.sourceListOutlineView expandItem:nil expandChildren:YES];
    
    // Make sure the "All Products" item is selected
    NSUInteger defaultIndexes[] = {0,0};
    [self.sourceListTreeController setSelectionIndexPath:[NSIndexPath indexPathWithIndexes:defaultIndexes length:2]];
}

- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSourceList) name:@"SIDidSetupSourceListItems" object:nil];
    
    NSSortDescriptor *sortByTitle = [NSSortDescriptor sortDescriptorWithKey:@"sortIndex" ascending:YES selector:@selector(compare:)];
    NSSortDescriptor *sortByOSVersion = [NSSortDescriptor sortDescriptorWithKey:@"catalogReference.catalogOSVersion" ascending:NO selector:@selector(compare:)];
    [self.sourceListTreeController setSortDescriptors:[NSArray arrayWithObjects:sortByTitle, sortByOSVersion, nil]];
    
    // The basic recipe for a sidebar. Note that the selectionHighlightStyle is set to NSTableViewSelectionHighlightStyleSourceList in the nib
    [self.sourceListOutlineView sizeLastColumnToFit];
    [self.sourceListOutlineView reloadData];
    [self.sourceListOutlineView setFloatsGroupRows:NO];
    
    // NSTableViewRowSizeStyleDefault should be used, unless the user has picked an explicit size. In that case, it should be stored out and re-used.
    [self.sourceListOutlineView setRowSizeStyle:NSTableViewRowSizeStyleDefault];
    
    // Disable animation
    //[NSAnimationContext beginGrouping];
    //[[NSAnimationContext currentContext] setDuration:0];
    
    
    
    //[NSAnimationContext endGrouping];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item
{
    if ([[item representedObject] isGroupItemValue]) {
        return YES;
    } else {
        return NO;
    }
}

- (NSView *)outlineView:(NSOutlineView *)ov viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item {
    NSTableCellView *view = nil;
    
    if ([[item representedObject] isGroupItemValue]) {
        view = [ov makeViewWithIdentifier:@"HeaderCell" owner:self];
    } else {
        view = [ov makeViewWithIdentifier:@"DataCell" owner:self];
    }
    
    return view;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item
{
    if ([[item representedObject] isGroupItemValue]) {
        return NO;
    } else {
        return YES;
    }
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
    if ([self.delegate respondsToSelector:@selector(outlineViewSelectionDidChange)]) {
        [self.delegate performSelectorOnMainThread:@selector(outlineViewSelectionDidChange)
                                        withObject:nil
                                     waitUntilDone:NO];
    }
}



@end
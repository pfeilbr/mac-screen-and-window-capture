//
//  ViewController.m
//  mac-screen-and-window-capture
//
//  Created by Brian Pfeil on 1/28/18.
//  Copyright © 2018 Brian Pfeil. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self capture];
}

- (void) capture {
    
    CFArrayRef windowList = CGWindowListCopyWindowInfo(kCGWindowListOptionOnScreenOnly, kCGNullWindowID);
    NSArray *windows=(__bridge NSArray *)windowList;
    
    // capture image from every open window
    for (NSDictionary *window in windows) {
        NSNumber *windowNumber = (NSNumber*)[window valueForKey:(NSString*)kCGWindowNumber];
        CGWindowID windowID = (CGWindowID)[windowNumber longValue];
        NSDictionary *windowBounds = (NSDictionary*)[window valueForKey:(NSString*)kCGWindowBounds];
        CGFloat windowX = [[windowBounds valueForKey:@"X"] floatValue];
        CGFloat windowY = [[windowBounds valueForKey:@"Y"] floatValue];
        CGFloat windowWidth = [[windowBounds valueForKey:@"Width"] floatValue];
        CGFloat windowHeight = [[windowBounds valueForKey:@"Height"] floatValue];
        
        CGRect windowRect = CGRectMake(windowX, windowY, windowWidth, windowHeight);
        CGImageRef windowImage = CGWindowListCreateImage(windowRect, kCGWindowListOptionIncludingWindow, windowID, kCGWindowImageDefault);
        NSLog(@"breakpoint line");
    }
    
    // capture image of entire screen
    CGDirectDisplayID display = CGMainDisplayID();
    CGImageRef cgImage = CGDisplayCreateImage(display);
    CGFloat width = CGImageGetWidth(cgImage);
    CGFloat height = CGImageGetHeight(cgImage);
    NSImage *image = [[NSImage alloc] initWithCGImage:cgImage size:NSMakeSize(width, height)];
    
    NSURL *documentsURL = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask][0];
    NSURL *fileURL = [documentsURL URLByAppendingPathComponent:@"screen.png"];
    
    NSData *tiffData = [image TIFFRepresentation];
    id bitmap = [NSBitmapImageRep imageRepWithData:tiffData];
    NSData *pngData = [bitmap representationUsingType:NSBitmapImageFileTypePNG properties:[NSDictionary dictionary]];
    if (![pngData writeToURL:fileURL atomically:YES]) {
        NSLog(@"failed to save");
    }
}



- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end

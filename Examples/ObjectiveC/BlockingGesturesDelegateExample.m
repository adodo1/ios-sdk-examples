#import "BlockingGesturesDelegateExample.h"
@import Mapbox;

NSString *const MBXExampleBlockingGesturesDelegate = @"BlockingGesturesDelegateExample";

@interface BlockingGesturesDelegateExample () <MGLMapViewDelegate>
@property (nonatomic) MGLCoordinateBounds colorado;
@end

@implementation BlockingGesturesDelegateExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MGLMapView *mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds];
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    mapView.rotateEnabled = NO;
    mapView.minimumZoomLevel = 10;
    mapView.delegate = self;
    
    mapView.styleURL = [MGLStyle outdoorsStyleURLWithVersion:9];
    
    // Denver, Colorado
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(39.748947, -104.995882);
    
    // Starting point.
    [mapView setCenterCoordinate:center zoomLevel:10 direction:0 animated:NO];
    
    // Colorado's bounds
    CLLocationCoordinate2D ne = CLLocationCoordinate2DMake(40.989329, -102.062592);
    CLLocationCoordinate2D sw = CLLocationCoordinate2DMake(36.986207, -109.049896);
    self.colorado = MGLCoordinateBoundsMake(sw, ne);
    
    [self.view addSubview:mapView];
}

- (BOOL)mapView:(MGLMapView *)mapView shouldChangeFromCamera:(MGLMapCamera *)oldCamera toCamera:(MGLMapCamera *)newCamera
{
    // Get current coordinates
    CLLocationCoordinate2D newCameraCenter = newCamera.centerCoordinate;
    MGLMapCamera *camera = mapView.camera;
    
    // Get new bounds
    mapView.camera = newCamera;
    MGLCoordinateBounds newVisibleCoordinates = mapView.visibleCoordinateBounds;
    mapView.camera = camera;
    
    // Test if the new camera center point and boundaries are inside colorado
    BOOL inside = MGLCoordinateInCoordinateBounds(newCameraCenter, self.colorado);
    BOOL intersects = MGLCoordinateInCoordinateBounds(newVisibleCoordinates.ne, self.colorado) && MGLCoordinateInCoordinateBounds(newVisibleCoordinates.sw, self.colorado);
    
    return inside && intersects;

}

@end

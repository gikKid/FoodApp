import Foundation
import UIKit
import MapKit

final class MapViewModel {
    
    public func didUpdateLocations(locations:[CLLocation],mapView:MKMapView) {
        guard let location = locations.first else {return}
        mapView.centerToLocation(location)
        self.addPin(mapView: mapView, location: location, title: "Me")
    }
    
    public func didChangeAuthorization(status: CLAuthorizationStatus, locationManager:CLLocationManager) {
        guard status == .authorizedWhenInUse else {return}
        locationManager.requestLocation()
    }
    
    private func addPin(mapView:MKMapView, location:CLLocation, title:String) {
        let pin = MKPointAnnotation()
        pin.title = title
        pin.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        mapView.addAnnotation(pin)
    }
    
}

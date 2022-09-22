import Foundation
import UIKit
import MapKit

final class MapViewModel {
    
    public var restaraunts = [Restaraunt]()
    
    public func didUpdateLocations(locations:[CLLocation],mapView:MKMapView) {
        guard let location = locations.first else {return}
        mapView.centerToLocation(location)
        self.addPin(mapView: mapView, location: location, title: "Me")
        self.getRestarauntsData(coordinate: location.coordinate)
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

    private func getRestarauntsData(coordinate:CLLocationCoordinate2D) {
        let restarauntsResource = RestarauntsResource(coordinate: coordinate)
        
        let apiRequest = ApiRestarauntsRequest(resource: restarauntsResource)
        apiRequest.execute(withCompletion: { [weak self] (restaraunts,error) in
            guard let restaraunts = restaraunts else {return}
            self?.restaraunts = restaraunts // Cache data
            print(restaraunts)
        })
        
    }
    
}

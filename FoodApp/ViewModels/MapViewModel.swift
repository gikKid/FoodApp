import Foundation
import MapKit

protocol MapViewModelProtocol {
    func passError(message:String)
}

final class MapViewModel {
    
    public var restaraunts = [Restaraunt](){
        didSet {
            guard let mapView = mapView_ else {return}
            self.addRestarauntsToMap(mapView: mapView)
        }
    }
    private var mapView_:MKMapView?
    public var delegate:MapViewModelProtocol?
    
    public func createDirectionRequest(mapView:MKMapView ,startCoordinate:CLLocationCoordinate2D, endCoordinate:CLLocationCoordinate2D)  {
        
        mapView.removeOverlays(mapView.overlays)
        
        let sourcePlacemark = MKPlacemark(coordinate: startCoordinate, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: endCoordinate, addressDictionary: nil)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .walking
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate {
          (response, error) -> Void in
          
          guard let response = response else {
            if let error = error {
                self.delegate?.passError(message: "Error: \(error)")
            }
            return
          }
          let route = response.routes[0]
            mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
          
          let rect = route.polyline.boundingMapRect
            mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }
    
    public func didUpdateLocations(locations:[CLLocation],mapView:MKMapView) {
        guard let location = locations.first else {return}
        mapView.centerToLocation(location)
        self.mapView_ = mapView
        self.getRestarauntsData(mapView: mapView, coordinate: location.coordinate)
    }
    
    public func didChangeAuthorization(status: CLAuthorizationStatus, locationManager:CLLocationManager) {
        guard status == .authorizedWhenInUse else {return}
        locationManager.requestLocation()
    }

    private func getRestarauntsData(mapView: MKMapView,coordinate:CLLocationCoordinate2D) {
        let restarauntsResource = RestarauntsResource(coordinate: coordinate)
        
        let apiRequest = ApiRestarauntsRequest(resource: restarauntsResource)
        apiRequest.execute(withCompletion: { [weak self] (restaraunts,error) in
            if let error = error {
                self?.delegate?.passError(message: "Network fail: \(error)")
                return
            }
            guard let restaraunts = restaraunts else {return}
            self?.restaraunts = restaraunts // Cache data
        })
    }
    
    private func addRestarauntsToMap(mapView:MKMapView) {
        mapView.removeAnnotations(mapView.annotations) //clear map from all annotations
        for restaraunt in restaraunts {
            guard let latitude = CLLocationDegrees(exactly: restaraunt.position.lat), let longutide = CLLocationDegrees(exactly: restaraunt.position.lng) else {return}
            let location = CLLocation(latitude: latitude, longitude: longutide)
            
            let restaraunt = RestarauntAnnotation(title: restaraunt.title, distance: restaraunt.distance, address: restaraunt.address, categories: restaraunt.categories, foodTypes: restaraunt.foodTypes, contacts: restaraunt.contacts, payment: restaraunt.payment, openingHours: restaraunt.openingHours, coordinate: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
            mapView.addAnnotation(restaraunt)
        }
    }
    
    public func setupAnnotationView(annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? RestarauntAnnotation else {return nil}
        
        let identefier = "restarauntAnnotation"
        var view:MKMarkerAnnotationView
        
        view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identefier)
        view.canShowCallout = true
        view.calloutOffset = CGPoint(x: -5, y: 5)
        view.rightCalloutAccessoryView = UIButton(type: .contactAdd)
        let detailLabel = UILabel()
        detailLabel.numberOfLines = 0
        detailLabel.font = detailLabel.font.withSize(12)
        detailLabel.text =
        """
        Address: \(annotation.address?.label ?? "-")
        Distance: \(annotation.distance ?? 0)
        Category: \(annotation.categories?[0].name ?? "-")
        Food type: \(annotation.foodTypes?[0].name ?? "-")
        Contacts: \(annotation.contacts?[0].phone?[0].value ?? "-")
        Payment: \(annotation.payment?.methods[0].id ?? "-")
        Opening hours: \(annotation.openingHours?[0].text[0] ?? "-")
        """
        view.detailCalloutAccessoryView = detailLabel
        return view
    }
    
    public func createOverlayRenderer(overlay:MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .red
        renderer.lineWidth = 4.0
        return renderer
    }
    
    
}

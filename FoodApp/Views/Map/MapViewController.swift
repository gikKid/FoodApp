import UIKit
import MapKit

final class MapViewController: UIViewController {
    
    let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    let locationManager = CLLocationManager()
    let viewModel = MapViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupLocationManager()
        mapView.delegate = self
    }
    
    private func setupLocationManager() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        mapView.showsUserLocation = true
    }
    
    

    //MARK: - Setup view
    
    private func setupView() {
        self.view.addSubview(mapView)
        self.view.backgroundColor = .secondarySystemBackground
        
        
        
        let addAddressButton:UIButton = {
           let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setImage(UIImage(systemName: "mappin.and.ellipse"), for: .normal)
            button.imageView?.transform3D = CATransform3DMakeScale(2, 2, 2)
            button.tintColor = .white
            button.backgroundColor = .clear
            button.addTarget(self, action: #selector(addAddressButtonTapped(_:)), for: .touchUpInside)
            return button
        }()
        self.mapView.addSubview(addAddressButton)
        
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            mapView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            mapView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            addAddressButton.topAnchor.constraint(equalTo: mapView.topAnchor,constant: 30),
            addAddressButton.rightAnchor.constraint(equalTo: mapView.rightAnchor, constant: -30)
        ])

    }


    //MARK: - Buttons methods
    @objc private func addAddressButtonTapped(_ sender: UIButton) {
        
    }
    
    
}

//MARK: - CLLocationManagerDelegate
extension MapViewController:CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.viewModel.didChangeAuthorization(status: status, locationManager: locationManager)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.viewModel.didUpdateLocations(locations: locations, mapView: self.mapView)
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        present(errorAC(message: "Im sorry, something went wrong, please restart application or rechecked your location settings"),animated: true)
        print(error.localizedDescription)
    }
}


//MARK: - MKMapViewDelegate
extension MapViewController:MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? { // called for every annotation which was added to map
        self.viewModel.setupAnnotationView(annotation: annotation)
        
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let restaraunt = view.annotation as? RestarauntAnnotation, let userLocation = locationManager.location?.coordinate else {return}
        self.viewModel.createDirectionRequest(mapView: mapView, startCoordinate: userLocation, endCoordinate: restaraunt.coordinate)
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .red
        renderer.lineWidth = 4.0
        return renderer
 }
}

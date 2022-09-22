import Foundation
import MapKit

struct RestarauntsResource:RestarauntsAPIResource {
    var coordinate: CLLocationCoordinate2D
    
    typealias ModelType = Restaraunt
}


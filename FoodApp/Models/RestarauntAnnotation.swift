import MapKit

class RestarauntAnnotation:NSObject,MKAnnotation {
    
    var title: String?
    var address:Address?
    var distance:Int?
    var categories:[CategoryPlace]?
    var foodTypes:[CategoryPlace]?
    var contacts:[Contact]?
    var payment: Payment?
    var openingHours:[OpeningHour]?
    var coordinate: CLLocationCoordinate2D
    
    init(title:String?,distance:Int?,address:Address?, categories:[CategoryPlace]?, foodTypes:[CategoryPlace]?, contacts:[Contact]?, payment: Payment?,openingHours:[OpeningHour]?, coordinate:CLLocationCoordinate2D) {
        self.coordinate = coordinate
        self.title = title
        self.address = address
        self.distance = distance
        self.categories = categories
        self.foodTypes = foodTypes
        self.contacts = contacts
        self.payment = payment
        self.openingHours = openingHours
        
        super.init()
    }
    
    
    
}

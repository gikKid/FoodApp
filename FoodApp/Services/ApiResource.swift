import Foundation
import MapKit

protocol APIResource {
    associatedtype ModelType:Decodable
    var methodPath:String {get}
}

extension APIResource {
    var url:URL{
        return URL(string: Constant.sourceApiLink + methodPath)!
    }
}

protocol RestarauntsAPIResource {
    associatedtype ModelType:Decodable
    
    var coordinate:CLLocationCoordinate2D {get}
}

extension RestarauntsAPIResource {
    var url:URL{
        return URL(string: "https://discover.search.hereapi.com/v1/discover?in=circle:\(coordinate.latitude),\(coordinate.longitude);r=100000&q=restaraunts&apiKey=\(PrivateConstant.restarauntsAPIKey)")!
    }
}

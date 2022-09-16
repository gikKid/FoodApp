import Foundation

protocol APIResource {
    associatedtype ModelType:Decodable
}

extension APIResource {
    var url:URL{
        return URL(string: Constant.sourceApiLink)!
    }
}

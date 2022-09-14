import Foundation

struct ListItem {
    let title:String
    let image:String
}

enum ListSection {
    case category([ListItem])
    case meal([ListItem])
    
    var items:[ListItem]{
        switch self {
        case .category(let items),.meal(let items):
        return items
        }
    }
    
    var count:Int{
        items.count
    }
    
    var title:String {
        switch self {
        case .category(_):
            return "Categories"
        case .meal(_):
            return "Most Recommended"
        }
    }
}

import Foundation


// MARK: - Restaraunts
struct Restaraunts: Decodable {
    let items: [Restaraunt]
}

// MARK: - Restaraunt
struct Restaraunt: Decodable {
    let title: String
    let address: Address?
    let position: Position
    let distance: Int
    let categories: [CategoryPlace]
    let foodTypes: [CategoryPlace]?
    let contacts: [Contact]?
    let payment: Payment?
    let openingHours: [OpeningHour]?

}

// MARK: - Position
struct Position: Decodable {
    let lat, lng: Double
}

// MARK: - Address
struct Address: Decodable {
    let label: String
    let postalCode: String?
    let houseNumber:String?
    let street:String?
}


// MARK: - Category
struct CategoryPlace: Decodable {
    let name: String
}

// MARK: - Contact
struct Contact: Decodable {
    let phone: [Email]?
    let www, fax, email, tollFree: [Email]?
}

// MARK: - Email
struct Email: Decodable {
    let value: String
}



// MARK: - OpeningHour
struct OpeningHour: Decodable {
    let text: [String]
    let isOpen: Bool
}

// MARK: - Payment
struct Payment: Decodable {
    let methods: [Method]
}

// MARK: - Method
struct Method: Decodable {
    let id: String
}



//MARK: - Wrapper

struct WrapperRestaraunts<T:Decodable>:Decodable {
    let items:[T]
}

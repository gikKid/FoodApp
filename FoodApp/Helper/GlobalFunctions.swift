import Foundation
import UIKit


func errorAC(message:String) -> UIAlertController {
    let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    return alertController
}

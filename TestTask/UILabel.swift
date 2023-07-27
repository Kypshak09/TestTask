import UIKit

extension UILabel {
    static func createLabel(name: String, fontSize: Int, font: String?) -> UILabel {
        let label: UILabel = {
            let label = UILabel()
            label.text = "\(name)"
            label.font = UIFont(name: font ?? "Arial", size: CGFloat(fontSize))
            label.numberOfLines = 0
            label.layer.masksToBounds = true
            return label
        }()
        return label
    }
 }

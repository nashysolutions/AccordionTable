import UIKit
import AccordionTable

final class ArrowHeaderView: HeaderView {

    @IBOutlet fileprivate weak var mainTitleLabel: UILabel!
    @IBOutlet fileprivate weak var arrowImageView: UIImageView?

    func updateTitle(with value: String) {
        mainTitleLabel.text = value
        accessibilityLabel = value
    }
    
    override func open(animationDuration: CGFloat) {
        let animated = animationDuration > 0
        if animated == true && isRotating == false {
            isRotating = true
            UIView.animate(withDuration: animationDuration, delay: 0, options: [.curveLinear,.allowUserInteraction], animations: {
                self.arrowImageView?.transform = .identity
            }, completion: { _ in
                self.isRotating = false
            })
        } else {
            layer.removeAllAnimations()
            arrowImageView?.transform = .identity
            isRotating = false
        }
    }
    
    override func close(animationDuration: CGFloat) {
        let animated = animationDuration > 0
        let angle = radians(degrees: 90)
        let transform = CGAffineTransform(rotationAngle: angle)
        if animated == true && isRotating == false {
            isRotating = true
            UIView.animate(withDuration: animationDuration, delay: 0, options: [.curveLinear,.allowUserInteraction], animations: {
                self.arrowImageView?.transform = transform
            }, completion: { _ in
                self.isRotating = false
            })
        } else {
            layer.removeAllAnimations()
            arrowImageView?.transform = transform
            isRotating = false
        }
    }
    
    private func radians(degrees: CGFloat) -> CGFloat {
        .pi * degrees / 180
    }
    
    static let height: CGFloat = 49
    static let name = "ArrowHeaderView"
    static let identifier = "DepartmentHeaderViewID"
    private var isRotating = false
}

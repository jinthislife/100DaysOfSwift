import PlaygroundSupport
import UIKit

class ViewController: UIViewController {}
let vc = ViewController()
vc.view.backgroundColor = .white
PlaygroundPage.current.liveView = vc

extension UIView {
    func bounceOut(duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        }
    }
}

var testView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
testView.backgroundColor = .red
testView.bounceOut(duration: 5)
testView.center = vc.view.center
vc.view.addSubview(testView)


extension Int {
    func times(_ operation: () -> Void) {
        guard self > 0 else { return }
        for _ in 0..<self {
            operation()
        }
    }
}

5.times { print("Hello world") }

extension Array where Element: Comparable {
    @inlinable public mutating func remove(item: Element) {
        guard let index = self.firstIndex(of: item) else { return }
        self.remove(at: index)
    }
}

var names = ["swift", "java", "go", "c", "c++", "swift", "java"]
names.remove(item: "java")

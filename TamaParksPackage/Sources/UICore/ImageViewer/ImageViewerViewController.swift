import UIKit

public final class ImageViewerViewController: UIViewController {
    private let image: UIImage

    override public var prefersStatusBarHidden: Bool {
        true
    }

    public init(image: UIImage) {
        self.image = image

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        hostSwiftUIView(
            ImageViewerScreen(
                image: image,
                onCloseButtonTapped: { [weak self] in self?.dismiss(animated: true) }
            )
        )
    }
}

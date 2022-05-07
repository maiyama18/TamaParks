import Resources
import UICore
import UIKit

public final class ParkDetailViewController: UIViewController {
    private let viewModel: ParkDetailViewModel

    private var subscription: Task<Void, Never>?

    init(viewModel: ParkDetailViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        subscription?.cancel()
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        subscribeEvents()
        hostSwiftUIView(ParkDetailScreen(viewModel: viewModel))
    }

    private func subscribeEvents() {
        subscription = Task { [weak self, events = viewModel.events] in
            for await event in events.values {
                guard let self = self else { return }
                switch event {
                case let .showUnVisitConfirmation(parkName):
                    Dialogs.showDestructiveActionConfirmation(
                        from: self,
                        message: L10n.Alert.UnVisit.message(parkName),
                        confirmationText: L10n.Common.delete,
                        onConfirmed: { [weak self] in self?.viewModel.onParkUnVisitConfirmed() }
                    )
                case let .showDeletePhotoConfirmation(photo):
                    Dialogs.showDestructiveActionConfirmation(
                        from: self,
                        message: L10n.Alert.DeletePhoto.message,
                        confirmationText: L10n.Common.delete,
                        onConfirmed: { [weak self] in self?.viewModel.onDeletePhotoConfirmed(photo) }
                    )
                case .launchCamera:
                    ImagePickers.showCamera(from: self)
                case let .showError(message):
                    Dialogs.showErrorMessage(from: self, message: message)
                }
            }
        }
    }
}

extension ParkDetailViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    public func imagePickerController(
        _: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        guard let image = info[.editedImage] as? UIImage else { return }
        UIImageWriteToSavedPhotosAlbum(
            image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil
        )
        dismiss(animated: true)
        viewModel.onPhotoTaken(image: image)
    }

    @objc func image(
        _: UIImage, didFinishSavingWithError error: Error?, contextInfo _: UnsafeRawPointer
    ) {
        guard let error = error else { return }
        print(error)
    }
}

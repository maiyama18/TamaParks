import Combine
import Entities
import Foundation
import Persistence
import Repositories
import Resources
import SwiftUtils
import UIKit

@MainActor
class ParkDetailViewModel: ObservableObject {
    enum Event {
        case showUnVisitConfirmation(parkName: String)
        case showDeletePhotoConfirmation(photo: ParkPhoto)
        case launchCamera
        case showPhoto(photos: [ParkPhoto], initialIndex: Int)
        case showError(message: String)
    }

    @Published var park: Park
    @Published var isEditingPhotos: Bool = false

    var events: AnyPublisher<Event, Never> {
        eventSubject.eraseToAnyPublisher()
    }

    private let eventSubject: PassthroughSubject<Event, Never> = .init()

    private let parkRepository: ParkRepositoryProtocol
    private let cameraService: CameraServiceProtocol

    init(
        park: Park,
        parkRepository: ParkRepositoryProtocol = ParkRepository(),
        cameraService: CameraServiceProtocol = CameraService.shared
    ) {
        self.park = park
        self.parkRepository = parkRepository
        self.cameraService = cameraService
    }

    func onStampTapped() {
        if park.visited {
            eventSubject.send(.showUnVisitConfirmation(parkName: park.name))
        } else {
            do {
                try parkRepository.visit(park)
                objectWillChange.send()
            } catch {
                print(error)
            }
        }
    }

    func onParkRated(rating: Int) {
        do {
            try parkRepository.rate(park, rating: rating)
            objectWillChange.send()
        } catch {
            print(error)
        }
    }

    func onParkUnVisitConfirmed() {
        do {
            try parkRepository.unVisit(park)
            objectWillChange.send()
        } catch {
            print(error)
        }
    }

    func onCameraButtonTapped() {
        switch cameraService.checkPermission() {
        case .allowed:
            eventSubject.send(.launchCamera)
        case .notDetermined:
            Task {
                let allowed = await cameraService.requestCameraPermission()

                if allowed {
                    eventSubject.send(.launchCamera)
                } else {
                    eventSubject.send(.showError(message: L10n.Alert.CameraPermissionPrompt.message))
                }
            }
        case .denied:
            eventSubject.send(.showError(message: L10n.Alert.CameraPermissionPrompt.message))
        case .unAvailable:
            eventSubject.send(.showError(message: L10n.Alert.CameraUnavailable.message))
        }
    }

    func onPhotoTaken(image: UIImage) {
        do {
            try parkRepository.addPhoto(park, image: image)
            objectWillChange.send()
        } catch {
            print(error)
        }
    }

    func onDeletePhotoButtonTapped(_ photo: ParkPhoto) {
        eventSubject.send(.showDeletePhotoConfirmation(photo: photo))
    }

    func onDeletePhotoConfirmed(_ photo: ParkPhoto) {
        do {
            try parkRepository.deletePhoto(photo)
            objectWillChange.send()
        } catch {
            print(error)
        }
    }

    func onPhotoTapped(_ photo: ParkPhoto) {
        guard !isEditingPhotos else { return }
        eventSubject.send(.showPhoto(photos: park.photos, initialIndex: park.photos.firstIndex(of: photo) ?? 0))
    }
}

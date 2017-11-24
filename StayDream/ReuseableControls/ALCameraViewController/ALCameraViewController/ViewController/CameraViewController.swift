//
//  CameraViewController.swift
//  CameraViewController
//
//  Created by Alex Littlejohn.
//  Copyright (c) 2016 zero. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

public typealias CameraViewCompletion = (UIImage?, PHAsset?) -> Void

public class CameraViewController: UIViewController {
    var didUpdateViews = false
    var allowCropping = false
    var animationRunning = false
    var lastInterfaceOrientation: UIInterfaceOrientation?
    var onCompletion: CameraViewCompletion?
    var volumeControl: VolumeControl?
    var animationDuration: TimeInterval = 0.5
    var animationSpring: CGFloat = 0.5
    var rotateAnimation: UIViewAnimationOptions = .curveLinear
    var cameraButtonEdgeConstraint: NSLayoutConstraint?
    var cameraButtonGravityConstraint: NSLayoutConstraint?
    var closeButtonEdgeConstraint: NSLayoutConstraint?
    var closeButtonGravityConstraint: NSLayoutConstraint?
    var containerButtonsEdgeOneConstraint: NSLayoutConstraint?
    var containerButtonsEdgeTwoConstraint: NSLayoutConstraint?
    var containerButtonsGravityConstraint: NSLayoutConstraint?
    var swapButtonEdgeOneConstraint: NSLayoutConstraint?
    var swapButtonEdgeTwoConstraint: NSLayoutConstraint?
    var swapButtonGravityConstraint: NSLayoutConstraint?
    var libraryButtonEdgeOneConstraint: NSLayoutConstraint?
    var libraryButtonEdgeTwoConstraint: NSLayoutConstraint?
    var libraryButtonGravityConstraint: NSLayoutConstraint?
    var flashButtonEdgeConstraint: NSLayoutConstraint?
    var flashButtonGravityConstraint: NSLayoutConstraint?
    var cameraOverlayEdgeOneConstraint: NSLayoutConstraint?
    var cameraOverlayEdgeTwoConstraint: NSLayoutConstraint?
    var cameraOverlayWidthConstraint: NSLayoutConstraint?
    var cameraOverlayCenterConstraint: NSLayoutConstraint?
    let cameraView: CameraView = {
        let cameraView = CameraView()
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        return cameraView
    }()
    let cameraOverlay: CropOverlay = {
        let cameraOverlay = CropOverlay()
        cameraOverlay.translatesAutoresizingMaskIntoConstraints = false
        return cameraOverlay
    }()
    let cameraButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        button.setImage(UIImage(named: "cameraButton", in: CameraGlobals.shared.bundle, compatibleWith: nil), for: .normal)
        button.setImage(UIImage(named: "cameraButtonHighlighted", in: CameraGlobals.shared.bundle, compatibleWith: nil), for: .highlighted)
        return button
    }()

    let closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "closeButton", in: CameraGlobals.shared.bundle, compatibleWith: nil), for: .normal)
        return button
    }()

    let swapButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "swapButton", in: CameraGlobals.shared.bundle, compatibleWith: nil), for: .normal)
        return button
    }()

    let libraryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "libraryButton", in: CameraGlobals.shared.bundle, compatibleWith: nil), for: .normal)
        return button
    }()

    let flashButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "flashAutoIcon", in: CameraGlobals.shared.bundle, compatibleWith: nil), for: .normal)
        return button
    }()

    let containerSwapLibraryButton: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    public init(croppingEnabled: Bool, allowsLibraryAccess: Bool = true, completion: @escaping CameraViewCompletion) {
        super.init(nibName: nil, bundle: nil)
        onCompletion = completion
        allowCropping = croppingEnabled
        //        cameraOverlay.isHidden = !allowCropping
        cameraOverlay.isHidden = true
        libraryButton.isEnabled = allowsLibraryAccess
        libraryButton.isHidden = !allowsLibraryAccess
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    public override var prefersStatusBarHidden: Bool {
        return true
    }

    public override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.slide
    }

    // Configure the background of the superview to black  and add the views on this superview. Then, request the update of constraints for this superview.
    public override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor.black
        [cameraView, cameraOverlay, cameraButton, closeButton, flashButton, containerSwapLibraryButton].forEach({ self.view.addSubview($0) })
        [swapButton, libraryButton].forEach({ containerSwapLibraryButton.addSubview($0) })
        view.setNeedsUpdateConstraints()
    }

    // Setup the constraints when the app is starting or rotating  the screen. To avoid the override/conflict of stable constraint, these  stable constraint are one time configurable. Any other dynamic constraint are configurable when the device is rotating, based on the device orientation.

    override public func updateViewConstraints() {
        if !didUpdateViews {
            configCameraViewConstraints()
            didUpdateViews = true
        }
        let statusBarOrientation = UIApplication.shared.statusBarOrientation
        let portrait = statusBarOrientation.isPortrait
        configCameraButtonEdgeConstraint(statusBarOrientation)
        configCameraButtonGravityConstraint(portrait)
        removeCloseButtonConstraints()
        configCloseButtonEdgeConstraint(statusBarOrientation)
        configCloseButtonGravityConstraint(statusBarOrientation)
        removeContainerConstraints()
        configContainerEdgeConstraint(statusBarOrientation)
        configContainerGravityConstraint(statusBarOrientation)
        removeSwapButtonConstraints()
        configSwapButtonEdgeConstraint(statusBarOrientation)
        configSwapButtonGravityConstraint(portrait)
        removeLibraryButtonConstraints()
        configLibraryEdgeButtonConstraint(statusBarOrientation)
        configLibraryGravityButtonConstraint(portrait)
        configFlashEdgeButtonConstraint(statusBarOrientation)
        configFlashGravityButtonConstraint(statusBarOrientation)
        let padding: CGFloat = portrait ? 16.0 : -16.0
        removeCameraOverlayEdgesConstraints()
        configCameraOverlayEdgeOneContraint(portrait, padding: padding)
        configCameraOverlayEdgeTwoConstraint(portrait, padding: padding)
        configCameraOverlayWidthConstraint(portrait)
        configCameraOverlayCenterConstraint(portrait)
        rotate(actualInterfaceOrientation: statusBarOrientation)
        super.updateViewConstraints()
    }
    // Add observer to check when the camera has started, enable the volume buttons to take the picture, configure the actions of the buttons on the screen, check the permissions of access of the camera and  the photo library. Configure the camera focus when the application start, to avoid any bluried image.
    public override func viewDidLoad() {
        super.viewDidLoad()
        addCameraObserver()
        addRotateObserver()
        setupVolumeControl()
        setupActions()
        checkPermissions()
        cameraView.configureFocus()
    }
    // Start the session of the camera.
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraView.startSession()
    }
    // Enable the button to take the picture when the  camera is ready.
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if cameraView.session?.isRunning == true {
            notifyCameraReady()
        }
    }
    // This method will disable the rotation
    override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        lastInterfaceOrientation = UIApplication.shared.statusBarOrientation
        if animationRunning {
            return
        }
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        coordinator.animate(alongsideTransition: { _ in
            self.view.setNeedsUpdateConstraints()
            }, completion: { _ in
                CATransaction.commit()
        })
    }
    // Observer the camera status, when it is ready, it calls the method cameraReady to enable the  button to take the picture.
    private func addCameraObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(notifyCameraReady), name: NSNotification.Name.AVCaptureSessionDidStartRunning, object: nil)
    }
    // Observer the device orientation to update the orientation of CameraView.
    private func addRotateObserver() {
        NotificationCenter.default.addObserver( self, selector: #selector(rotateCameraView), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }

    internal func notifyCameraReady() {
        cameraButton.isEnabled = true
    }
    // Attach the take of picture for any volume button.
    private func setupVolumeControl() {
        volumeControl = VolumeControl(view: view) { [weak self] _ in
            if self?.cameraButton.isEnabled == true {
                self?.capturePhoto()
            }
        }
    }
    // Configure the action for every button on this layout.
    private func setupActions() {
        cameraButton.action = { [weak self] in self?.capturePhoto() }
        swapButton.action = { [weak self] in self?.swapCamera() }
        libraryButton.action = { [weak self] in self?.showLibrary() }
        closeButton.action = { [weak self] in self?.close() }
        flashButton.action = { [weak self] in self?.toggleFlash() }
    }

    // This method will rotate the buttons based on  the last and actual orientation of the device.
    internal func rotate(actualInterfaceOrientation: UIInterfaceOrientation) {
        if lastInterfaceOrientation != nil {
            let lastTransform = CGAffineTransform(rotationAngle: CGFloat(radians(currentRotation(
                lastInterfaceOrientation!, newOrientation: actualInterfaceOrientation))))
            self.setTransform(transform: lastTransform)
        }

        let transform = CGAffineTransform(rotationAngle: 0)
        animationRunning = true
        // Dispach delay to avoid any conflict between the CATransaction of rotation of the screen and CATransaction of animation of buttons.
        let time: DispatchTime = DispatchTime.now() + Double(1 * UInt64(NSEC_PER_SEC)/10)
        DispatchQueue.main.asyncAfter(deadline: time) {
            CATransaction.begin()
            CATransaction.setDisableActions(false)
            CATransaction.commit()
            UIView.animate(
                withDuration: self.animationDuration,
                delay: 0.1,
                usingSpringWithDamping: self.animationSpring,
                initialSpringVelocity: 0,
                options: self.rotateAnimation,
                animations: {
                    self.setTransform(transform: transform)
                }, completion: { _ in
                    self.animationRunning = false
            })

        }
    }

    internal func layoutCameraResult(asset: PHAsset) {
        cameraView.stopSession()
        startConfirmController(asset: asset)
        toggleButtons(enabled: true)
    }
    private func startConfirmController(asset: PHAsset) {
        let confirmViewController = ConfirmViewController(asset: asset, allowsCropping: allowCropping)
        confirmViewController.onComplete = { image, asset in
            if let image = image, let asset = asset {
                self.onCompletion?(image, asset)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
        confirmViewController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        present(confirmViewController, animated: true, completion: nil)
    }
}

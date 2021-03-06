//
//  DrawingViewController.swift
//  Batikin
//
//  Created by Windy on 29/07/20.
//  Copyright © 2020 BatikAja. All rights reserved.
//

import UIKit
import Macaw
import PhotosUI

class DrawingViewController: UIViewController {
    
    @IBOutlet weak var shapeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomContainer: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var drawingView: UIView!
    @IBOutlet weak var drawingViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var drawingViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var drawingViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var drawingViewTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var sliderView: UIView!
    @IBOutlet weak var hueSlider: GradientSlider!
    @IBOutlet weak var saturationSlider: GradientSlider!
    @IBOutlet weak var brightnessSlider: GradientSlider!
    
    let shapeModel = ShapeModel()
    let toolView = UIView()
    
    var selectedView: UIView?
    var buttonColorClose: UIButton?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(handleSelected(notification:)), name: Notification.Name.sendViews, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self, name: .sendViews, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupSegmentedControl()
        setupScrollView()
        setupToolBox()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setupColorSlider()
    }
    
    // MARK: Navbar
    private func setupNavigationBar() {
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: .done, target: self, action: #selector(handleDone))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Preview", comment: ""), style: .plain, target: self, action: #selector(handlePreview))
    }
    
    @objc private func handlePreview() {
        let vc = storyboard?.instantiateViewController(identifier: "PreviewViewController") as! PreviewViewController
        
        self.selectedView?.layer.borderColor = UIColor.clear.cgColor
        UIGraphicsBeginImageContextWithOptions(self.drawingView.bounds.size, false, UIScreen.main.scale)
        self.drawingView.drawHierarchy(in: self.drawingView.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        vc.image = image
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc private func handleDone() {
        let alert = UIAlertController(title: NSLocalizedString("Done", comment: ""), message: NSLocalizedString("Are you finish make your Batik?", comment: ""), preferredStyle: .alert)
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel)
        let done = UIAlertAction(title: NSLocalizedString("Done", comment: ""), style: .default) { (_) in
            
            UIGraphicsBeginImageContextWithOptions(self.drawingView.bounds.size, false, UIScreen.main.scale)
            self.drawingView.drawHierarchy(in: self.drawingView.bounds, afterScreenUpdates: true)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            if let imageData = image?.pngData() {
                CoreDataServices.saveData(UUID(), Date().toString(), imageData)
                self.navigationController?.popToRootViewController(animated: true)
            }
            
        }
        
        if drawingView.subviews == [] {
            self.navigationController?.popViewController(animated: true)
        } else {
            alert.addAction(cancel)
            alert.addAction(done)
            self.selectedView?.layer.borderColor = UIColor.clear.cgColor
            present(alert, animated: true)
        }
        
    }
    
    private func setupColorSlider() {
        sliderView.alpha = 0
        saturationSlider.maxColor = UIColor(hue: 0.5, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        brightnessSlider.maxColor = UIColor(hue: 0.5, saturation: 1.0, brightness: 1.0, alpha: 1.0)
    }
    
    @objc func handleSelected(notification: Notification) {
        
        guard let selectedViews = notification.object as? [String: UIView] else { return }
        
        if let selectedView = selectedViews["selectedView"] as? MacawView {
            self.selectedView = selectedView
        }
        
        if selectedViews["selectedView"] != drawingView {
            UIView.animate(withDuration: 0.3) {
                self.toolView.alpha = 1
            }
        } else if selectedViews["drawingView"] == drawingView {
            self.selectedView = drawingView
            UIView.animate(withDuration: 0.3) {
                self.toolView.alpha = 0
                self.sliderView.alpha = 0
                self.buttonColorClose?.removeFromSuperview()
            }
        }
    }
    
    // MARK: ScrollView
    private func setupScrollView() {
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = UIColor(named: CustomColor.canvasBackground.color)
        view.backgroundColor = UIColor(named: CustomColor.canvasBackground.color)
    }
    
    // MARK: Segmented Control
    private func setupSegmentedControl() {
        shapeSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        shapeSegmentedControl.backgroundColor = UIColor(named: CustomColor.segmentBackground.color)
        shapeSegmentedControl.selectedSegmentTintColor = UIColor(named: CustomColor.tintColor.color)
        
        bottomContainer.backgroundColor = UIColor.systemBackground
    }
    
    @IBAction func handleSegmentedControl(_ sender: UISegmentedControl) {
        collectionView.reloadData()
    }
    
    @IBAction func colorSlider(_ sender: GradientSlider) {
        // Update color slider saturation and brightness to match current hue
        saturationSlider.maxColor = UIColor(hue: hueSlider.value, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        brightnessSlider.maxColor = UIColor(hue: hueSlider.value, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        
        // Update selected motif element color
        guard let selectedView = selectedView as? MacawView else { return }
        updateStroke(node: selectedView.node)
    }
    
    @objc func colorTool() {
        sliderView.alpha = 1
    }
    
    private func setupToolBox() {
        
        toolView.backgroundColor = UIColor.systemBackground
        toolView.alpha = 0
        bottomContainer.addSubview(toolView)
        
        toolView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toolView.topAnchor.constraint(equalTo: bottomContainer.topAnchor),
            toolView.bottomAnchor.constraint(equalTo: bottomContainer.bottomAnchor),
            toolView.leadingAnchor.constraint(equalTo: bottomContainer.leadingAnchor),
            toolView.trailingAnchor.constraint(equalTo: bottomContainer.trailingAnchor)
        ])
        
        let colorButton = UIButton(type: .system)
        colorButton.setBackgroundImage(UIImage(systemName: "circle.grid.hex"), for: .normal)
        colorButton.translatesAutoresizingMaskIntoConstraints = false
        colorButton.contentMode = .scaleAspectFit
        colorButton.widthAnchor.constraint(equalToConstant: 56).isActive = true
        colorButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        colorButton.addTarget(self, action: #selector(handleColor), for: .touchUpInside)
        let colorLabel = UILabel()
        colorLabel.text = NSLocalizedString("Color", comment: "")
        colorLabel.textColor = UIColor.label
        colorLabel.font = UIFont.preferredFont(forTextStyle: .body)
        let colorStackView = UIStackView()
        colorStackView.addArrangedSubview(colorButton)
        colorStackView.addArrangedSubview(colorLabel)
        colorStackView.axis = .vertical
        colorStackView.alignment = .center
        colorStackView.spacing = 8
        
        let mirrorButton = UIButton(type: .system)
        mirrorButton.setBackgroundImage(UIImage(systemName: "arrow.right.arrow.left"), for: .normal)
        mirrorButton.contentMode = .scaleAspectFit
        mirrorButton.widthAnchor.constraint(equalToConstant: 56).isActive = true
        mirrorButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        mirrorButton.addTarget(self, action: #selector(handleMirror), for: .touchUpInside)
        let mirrorLabel = UILabel()
        mirrorLabel.text = NSLocalizedString("Flip", comment: "")
        mirrorLabel.textColor = UIColor.label
        mirrorLabel.font = UIFont.preferredFont(forTextStyle: .body)
        let mirrorStackView = UIStackView()
        mirrorStackView.addArrangedSubview(mirrorButton)
        mirrorStackView.addArrangedSubview(mirrorLabel)
        mirrorStackView.axis = .vertical
        mirrorStackView.alignment = .center
        mirrorStackView.spacing = 8
        
        let duplicateButton = UIButton(type: .system)
        duplicateButton.setBackgroundImage(UIImage(systemName: "rectangle.on.rectangle"), for: .normal)
        duplicateButton.contentMode = .scaleAspectFit
        duplicateButton.widthAnchor.constraint(equalToConstant: 56).isActive = true
        duplicateButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        duplicateButton.addTarget(self, action: #selector(handleDuplicate), for: .touchUpInside)
        duplicateButton.isEnabled = false
        let duplicateLabel = UILabel()
        duplicateLabel.text = NSLocalizedString("Copy", comment: "")
        duplicateLabel.textColor = UIColor.label
        duplicateLabel.font = UIFont.preferredFont(forTextStyle: .body)
        
        let duplicateStackView = UIStackView()
        duplicateStackView.addArrangedSubview(duplicateButton)
        duplicateStackView.addArrangedSubview(duplicateLabel)
        duplicateStackView.axis = .vertical
        duplicateStackView.alignment = .center
        duplicateStackView.spacing = 8
        
        let deleteButton = UIButton(type: .system)
        deleteButton.setBackgroundImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.addTarget(self, action: #selector(handleDelete), for: .touchUpInside)
        deleteButton.contentMode = .scaleAspectFit
        deleteButton.widthAnchor.constraint(equalToConstant: 56).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        let deleteLabel = UILabel()
        deleteLabel.text = NSLocalizedString("Delete", comment: "")
        deleteLabel.textColor = UIColor.label
        deleteLabel.font = UIFont.preferredFont(forTextStyle: .body)
        let deleteStackView = UIStackView()
        deleteStackView.addArrangedSubview(deleteButton)
        deleteStackView.addArrangedSubview(deleteLabel)
        deleteStackView.axis = .vertical
        deleteStackView.alignment = .center
        deleteStackView.spacing = 8
        
        let buttonStackView = UIStackView()
        buttonStackView.axis = .horizontal
        buttonStackView.alignment = .fill
        buttonStackView.distribution = .equalSpacing
        buttonStackView.spacing = view.bounds.width / 10
        
        buttonStackView.addArrangedSubview(colorStackView)
        buttonStackView.addArrangedSubview(mirrorStackView)
        //        buttonStackView.addArrangedSubview(duplicateStackView)
        buttonStackView.addArrangedSubview(deleteStackView)
        
        toolView.addSubview(buttonStackView)
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonStackView.centerYAnchor.constraint(equalTo: toolView.centerYAnchor),
            buttonStackView.centerXAnchor.constraint(equalTo: toolView.centerXAnchor),
        ])
        
        let layerDown = UIButton(type: .system)
        layerDown.setBackgroundImage(UIImage(systemName: "arrow.down.to.line"), for: .normal)
        layerDown.addTarget(self, action: #selector(handleDownLayer), for: .touchUpInside)
        layerDown.imageView?.contentMode = .scaleToFill
        view.addSubview(layerDown)
        
        layerDown.translatesAutoresizingMaskIntoConstraints = false
        layerDown.widthAnchor.constraint(equalToConstant: 36).isActive = true
        layerDown.heightAnchor.constraint(equalToConstant: 36).isActive = true
        layerDown.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        layerDown.bottomAnchor.constraint(equalTo: bottomContainer.topAnchor, constant: -16).isActive = true
        
        let layerUp = UIButton(type: .system)
        layerUp.setBackgroundImage(UIImage(systemName: "arrow.up.to.line"), for: .normal)
        layerUp.addTarget(self, action: #selector(handleUpLayer), for: .touchUpInside)
        view.addSubview(layerUp)
        
        layerUp.translatesAutoresizingMaskIntoConstraints = false
        layerUp.widthAnchor.constraint(equalToConstant: 36).isActive = true
        layerUp.heightAnchor.constraint(equalToConstant: 36).isActive = true
        layerUp.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        layerUp.bottomAnchor.constraint(equalTo: layerDown.topAnchor, constant: -8).isActive = true
        
    }
    
    @objc private func handleUpLayer() {
        if let selectedView = selectedView {
            drawingView.bringSubviewToFront(selectedView)
        }
    }
    
    @objc private func handleDownLayer() {
        if let selectedView = selectedView {
            drawingView.sendSubviewToBack(selectedView)
        }
    }
    
    @objc private func handleColor() {
        buttonColorClose = UIButton(type: .system)
        buttonColorClose?.setTitle(NSLocalizedString("Close", comment: ""), for: .normal)
        buttonColorClose?.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        view.addSubview(buttonColorClose!)
        buttonColorClose?.translatesAutoresizingMaskIntoConstraints = false
        buttonColorClose?.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        buttonColorClose?.bottomAnchor.constraint(equalTo: bottomContainer.topAnchor, constant: -8).isActive = true
        UIView.animate(withDuration: 0.3) {
            self.sliderView.alpha = 1
        }
    }
    
    @objc private func handleClose() {
        UIView.animate(withDuration: 0.3) {
            self.sliderView.alpha = 0
            self.buttonColorClose?.removeFromSuperview()
        }
    }
    
    @objc private func handleMirror() {
        if selectedView?.isFlip == false {
            selectedView?.flipX()
            selectedView?.isFlip = true
        } else {
            selectedView?.flipX()
            selectedView?.isFlip = false
        }
    }
    
    @objc private func handleDuplicate() {
        
    }
    
    @objc private func handleDelete() {
        UIView.animate(withDuration: 0.3) {
            self.selectedView?.removeFromSuperview()
            self.toolView.alpha = 0
        }
    }
    
    func handleAddShape(shape: String) {
        guard let node = try? SVGParser.parse(resource: shape) else { return }
        
        var view: UIView
        
        if shapeSegmentedControl.selectedSegmentIndex == 0 {
            view = MacawView(node: node, frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        } else if shapeSegmentedControl.selectedSegmentIndex == 1 {
            view = MacawView(node: node, frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        } else {
            view = MacawView(node: node, frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        }
        
        view.transform = .init(translationX: drawingView.bounds.midX - CGFloat(150), y: drawingView.bounds.midY - CGFloat(150))
        view.backgroundColor = .clear
        view.contentMode = .scaleAspectFit
        view.isFlip = false
        self.drawingView.addSubview(view)
        updateStroke(node: node)
    }
    
    func updateStroke(node: Node) {
        
        if let shape = node as? Shape {
            let colorConvertor = ColorConvertor()
            
            let fillColor = colorConvertor.HSBtoRGB(h: hueSlider.value, s: saturationSlider.value, b: brightnessSlider.value)
            
            shape.fill = Color.rgb(r: fillColor.r, g: fillColor.g, b: fillColor.b)
        } else if let group = node as? Group {
            group.contents.forEach(updateStroke(node:))
        }
    }
    
}

// MARK: Collection View
extension DrawingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch shapeSegmentedControl.selectedSegmentIndex {
        case 0:
            return shapeModel.mainShape.count
        case 1:
            return shapeModel.fillerShape.count
        case 2:
            return shapeModel.isenShape.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.shapeCollectionViewCell, for: indexPath) as? BtnCollectionViewCell else { return UICollectionViewCell() }
        
        switch shapeSegmentedControl.selectedSegmentIndex {
        case 0:
            cell.btnImg.fileName = shapeModel.mainShape[indexPath.row]
        case 1:
            cell.btnImg.fileName = shapeModel.fillerShape[indexPath.row]
        case 2:
            cell.btnImg.fileName = shapeModel.isenShape[indexPath.row]
        default:
            break
        }
        cell.btnImg.contentMode = .scaleAspectFit
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch shapeSegmentedControl.selectedSegmentIndex {
        case 0:
            handleAddShape(shape: shapeModel.mainShape[indexPath.row])
        case 1:
            handleAddShape(shape: shapeModel.fillerShape[indexPath.row])
        case 2:
            handleAddShape(shape: shapeModel.isenShape[indexPath.row])
        default:
            break
        }
    }
    
}

// MARK: DrawingScreen Logic
extension DrawingViewController: UIScrollViewDelegate {
    
    func updateMinZoomScaleForSize(_ size:CGSize) {
        let widthScale = size.width / drawingView.bounds.width
        let heightScale = size.height / drawingView.bounds.height
        let minScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateMinZoomScaleForSize(view.bounds.size)
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraintsForSize(view.bounds.size)
    }
    
    func updateConstraintsForSize(_ size:CGSize) {
        
        var yOffset: CGFloat = 0
        
        if size.height >= 896 {
            yOffset = max(0, (size.height - drawingView.frame.height) / 4.5)
        } else {
            yOffset = max(0, (size.height - drawingView.frame.height) / 10)
        }
        
        drawingViewTopConstraint.constant = yOffset
        drawingViewBottomConstraint.constant = yOffset
        let xOffset = max(0, (size.width - drawingView.frame.width)/4.5)
        drawingViewLeadingConstraint.constant = xOffset
        drawingViewTrailingConstraint.constant = xOffset
        view.layoutIfNeeded()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return drawingView
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        if selectedView != drawingView && selectedView != nil {
            self.scrollView.isScrollEnabled = false
        }
        self.scrollView.isScrollEnabled = true
    }
    
}


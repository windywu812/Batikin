//
//  DrawingViewController.swift
//  Batikin
//
//  Created by Windy on 29/07/20.
//  Copyright © 2020 BatikAja. All rights reserved.
//

import UIKit
import Macaw

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
    
    var selectedView: MacawView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleSelected(notification:)), name: Notification.Name.sendViews, object: nil)
        
        setupNavigationBar()
        setupSegmentedControl()
        setupScrollView()
        setupToolBox()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Default Slider Values
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
            UIView.animate(withDuration: 0.5) {
                self.toolView.center.y = 85
                self.toolView.alpha = 1
            }
        } else if selectedViews["drawingView"] == drawingView {
            UIView.animate(withDuration: 0.5) {
                
                // Forces return to Tool View after Slider View
                if self.sliderView.alpha == 1 {
                    self.sliderView.alpha = 0
                } else {
                    self.toolView.alpha = 0
                    self.toolView.center.y = 300
                }
            }
        }
        
    }
    
    private func setupScrollView() {
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = UIColor(named: CustomColor.canvasBackground.rawValue)
        view.backgroundColor = UIColor(named: CustomColor.canvasBackground.rawValue)
    }
    
    // MARK: Navbar
    private func setupNavigationBar() {
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    // MARK: Segmented Control
    private func setupSegmentedControl() {
        shapeSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        shapeSegmentedControl.backgroundColor = UIColor(named: CustomColor.segmentBackground.rawValue)
        shapeSegmentedControl.selectedSegmentTintColor = UIColor(named: CustomColor.tintColor.rawValue)
        
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
        guard let selectedView = selectedView else { return }
        updateStroke(node: selectedView.node)
    }
    
    @objc func colorButton() {
        sliderView.alpha = 1
    }
    
    private func setupToolBox() {
        
        toolView.backgroundColor = UIColor.systemBackground
        bottomContainer.addSubview(toolView)
        toolView.translatesAutoresizingMaskIntoConstraints = false
        toolView.alpha = 0
        NSLayoutConstraint.activate([
            toolView.topAnchor.constraint(equalTo: bottomContainer.topAnchor),
            toolView.centerXAnchor.constraint(equalTo: bottomContainer.centerXAnchor),
            toolView.widthAnchor.constraint(equalTo: bottomContainer.widthAnchor),
            toolView.heightAnchor.constraint(equalTo: bottomContainer.heightAnchor)
        ])
        
        let colorTool = UIButton()
        let buttonStackView = UIStackView()
        colorTool.setBackgroundImage(UIImage(systemName: "circle.grid.hex"), for: .normal)
        colorTool.translatesAutoresizingMaskIntoConstraints = false
        colorTool.addTarget(self, action: #selector(colorButton), for: .touchUpInside)
        
        let mirrorTool = UIButton()
        mirrorTool.setBackgroundImage(UIImage(systemName: "arrow.right.arrow.left"), for: .normal)
        mirrorTool.translatesAutoresizingMaskIntoConstraints = false
        
        let duplicateTool = UIButton()
        duplicateTool.setBackgroundImage(UIImage(systemName: "rectangle.on.rectangle"), for: .normal)
        duplicateTool.translatesAutoresizingMaskIntoConstraints = false
        
        let deleteTool = UIButton()
        deleteTool.setBackgroundImage(UIImage(systemName: "trash"), for: .normal)
        deleteTool.translatesAutoresizingMaskIntoConstraints = false
        
        buttonStackView.alignment = .fill
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 64.0
        
        buttonStackView.addArrangedSubview(colorTool)
        buttonStackView.addArrangedSubview(mirrorTool)
        buttonStackView.addArrangedSubview(duplicateTool)
        buttonStackView.addArrangedSubview(deleteTool)
        
        toolView.addSubview(buttonStackView)
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: bottomContainer.topAnchor , constant: 50),
            buttonStackView.rightAnchor.constraint(equalTo: bottomContainer.rightAnchor , constant: -20),
            buttonStackView.leftAnchor.constraint(equalTo: bottomContainer.leftAnchor, constant: 20),
            buttonStackView.bottomAnchor.constraint(equalTo: bottomContainer.bottomAnchor,constant: -80),
            
        ])
        
//        let colorLabel = UILabel()
//        colorLabel.text = "Color"
//        colorLabel.textColor = UIColor.label
//        colorLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
//        colorLabel.translatesAutoresizingMaskIntoConstraints = false
//
//        let mirroLabel = UILabel()
//        mirroLabel.text = "Mirror"
//        mirroLabel.textColor = UIColor.label
//        mirroLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
//        mirroLabel.translatesAutoresizingMaskIntoConstraints = false
//
//        let duplicateLabel = UILabel()
//        duplicateLabel.text = "Copy"
//        duplicateLabel.textColor = UIColor.label
//        duplicateLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
//        duplicateLabel.translatesAutoresizingMaskIntoConstraints = false
//
//        let deleteLabel = UILabel()
//        deleteLabel.text = "Delete"
//        deleteLabel.textColor = UIColor.label
//        deleteLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
//        deleteLabel.translatesAutoresizingMaskIntoConstraints = false
//
//        let stackLabel = UIStackView()
//        stackLabel.alignment = .fill
//        stackLabel.distribution = .fillEqually
//        stackLabel.spacing = 63.0
//        stackLabel.addArrangedSubview(colorLabel)
//        stackLabel.addArrangedSubview(mirroLabel)
//        stackLabel.addArrangedSubview(duplicateLabel)
//        stackLabel.addArrangedSubview(deleteLabel)
//        buttonStackView.addSubview(stackLabel)
//        stackLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            stackLabel.topAnchor.constraint(equalTo: buttonStackView.topAnchor),
//            stackLabel.rightAnchor.constraint(equalTo: buttonStackView.rightAnchor,constant: 4),
//            stackLabel.leftAnchor.constraint(equalTo: buttonStackView.leftAnchor,constant: 5),
//            stackLabel.bottomAnchor.constraint(equalTo: buttonStackView.bottomAnchor,constant: 90),
//        ])
    }
    
    func handleAddShape(shape: String) {
          guard let node = try? SVGParser.parse(resource: shape) else { return }
          
          let view = MacawView(node: node, frame: CGRect(x: 0, y: 0, width: 300, height: 300))
          view.transform = .init(translationX: drawingView.bounds.midX - CGFloat(150), y: drawingView.bounds.midY - CGFloat(150))
          view.backgroundColor = .clear
          view.contentMode = .scaleAspectFit
          
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
    
    func updateConstraintsForSize(_ size:CGSize){
        
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



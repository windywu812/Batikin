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
    
    let shapeModel = ShapeModel()
    let toolView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleSelected(notification:)), name: Notification.Name.init("tes"), object: nil)
        
        
        setupNavigationBar()
        setupSegmentedControl()
        setupScrollView()
        hidingContent()
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    func move(view: UIView){
        view.center.y -= 300
    }
    func moveBack(view: UIView){
        view.center.y += 300
    }
    @objc func handleSelected(notification:Notification){
        
        guard let selectedView = notification.object as? MacawView else { return }
        
        if selectedView != drawingView {
            moveBack(view:toolView)
            toolView.isHidden = false
            let duration: Double = 0.7
            UIView.animate(withDuration: duration){
                self.move(view: self.toolView)
            }
            
        }
        
        drawingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapDrawingView(_:))))
        
        
        
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
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "arrow.uturn.right.circle"), style: .plain, target: self, action: #selector(handleRedo)),
            UIBarButtonItem(image: UIImage(systemName: "arrow.uturn.left.circle"), style: .plain, target: self, action: #selector(handleUndo))
        ]
    }
    
    @objc private func handleRedo() {
        
    }
    
    @objc private func handleUndo() {
        
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
    
    func handleAddShape(shape: String) {
        guard let node = try? SVGParser.parse(resource: shape) else { return }
        guard let bounds = node.bounds else { return }
        let view = MacawView(node: node, frame: CGRect(x: 0, y: 0, width: bounds.w, height: bounds.h))
        view.transform = .init(translationX: drawingView.bounds.midX - CGFloat(bounds.w)/2  , y: drawingView.bounds.midY - CGFloat(bounds.h)/2)
        view.backgroundColor = .clear
        
        
        
        self.drawingView.addSubview(view)
        updateStroke(node: node)
    }
    
    func updateStroke(node: Node) {
        if let shape = node as? Shape {
            var r = [Int]()
            var g = [Int]()
            var b = [Int]()
            for i in 0...255 {
                r.append(i)
                g.append(i)
                b.append(i)
            }
            shape.fill = Color.rgb(r: r.randomElement()!, g: g.randomElement()!, b: b.randomElement()!)
        } else if let group = node as? Group {
            group.contents.forEach(updateStroke(node:))
        }
    }
    
    // MARK: Content Hiding
    private func hidingContent(){
        
        let stackLabel = UIStackView()
        toolView.backgroundColor = UIColor.systemBackground
        bottomContainer.addSubview(toolView)
        toolView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toolView.topAnchor.constraint(equalTo: bottomContainer.topAnchor),
            toolView.centerXAnchor.constraint(equalTo: bottomContainer.centerXAnchor),
            toolView.widthAnchor.constraint(equalTo: bottomContainer.widthAnchor),
            toolView.heightAnchor.constraint(equalTo: bottomContainer.heightAnchor)
        ])
        toolView.isHidden = true
        let btnTool1 = UIButton()
        let buttonStackView = UIStackView()
        btnTool1.setBackgroundImage(UIImage(systemName: "circle.grid.hex"), for: .normal)
        btnTool1.translatesAutoresizingMaskIntoConstraints = false
        
        let btnTool2 = UIButton()
        btnTool2.setBackgroundImage(UIImage(systemName: "arrow.right.arrow.left"), for: .normal)
        btnTool2.translatesAutoresizingMaskIntoConstraints = false
        
        let btnTool3 = UIButton()
        btnTool3.setBackgroundImage(UIImage(systemName: "rectangle.on.rectangle"), for: .normal)
        btnTool3.translatesAutoresizingMaskIntoConstraints = false
        
        let btnTool4 = UIButton()
        btnTool4.setBackgroundImage(UIImage(systemName: "trash"), for: .normal)
        btnTool4.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        buttonStackView.alignment = .fill
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 64.0
        
        buttonStackView.addArrangedSubview(btnTool1)
        buttonStackView.addArrangedSubview(btnTool2)
        buttonStackView.addArrangedSubview(btnTool3)
        buttonStackView.addArrangedSubview(btnTool4)
        
        toolView.addSubview(buttonStackView)
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: bottomContainer.topAnchor , constant: 50),
            buttonStackView.rightAnchor.constraint(equalTo: bottomContainer.rightAnchor , constant: -20),
            buttonStackView.leftAnchor.constraint(equalTo: bottomContainer.leftAnchor, constant: 20),
            buttonStackView.bottomAnchor.constraint(equalTo: bottomContainer.bottomAnchor,constant: -80),
            
        ])
        
        let label1 = UILabel()
        label1.text = "Color"
        label1.textColor = UIColor.label
        label1.font = UIFont.systemFont(ofSize:17.0)
        label1.translatesAutoresizingMaskIntoConstraints = false
        
        let label2 = UILabel()
        label2.text = "Mirror"
        label2.textColor = UIColor.label
        label2.font = UIFont.systemFont(ofSize:17.0)
        label2.translatesAutoresizingMaskIntoConstraints = false
        
        let label3 = UILabel()
        label3.text = "Copy"
        label3.textColor = UIColor.label
        label3.font = UIFont.systemFont(ofSize:17.0)
        label3.translatesAutoresizingMaskIntoConstraints = false
        
        let label4 = UILabel()
        label4.text = "Delete"
        label4.textColor = UIColor.label
        label4.font = UIFont.systemFont(ofSize:17.0)
        label4.translatesAutoresizingMaskIntoConstraints = false
        
        
        stackLabel.alignment = .fill
        stackLabel.distribution = .fillEqually
        //                stackLabel.spacing = 55.0
        stackLabel.addArrangedSubview(label1)
        stackLabel.addArrangedSubview(label2)
        stackLabel.addArrangedSubview(label3)
        stackLabel.addArrangedSubview(label4)
        buttonStackView.addSubview(stackLabel)
        stackLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackLabel.topAnchor.constraint(equalTo: buttonStackView.topAnchor),
            stackLabel.rightAnchor.constraint(equalTo: buttonStackView.rightAnchor,constant: 68),
            stackLabel.leftAnchor.constraint(equalTo: buttonStackView.leftAnchor),
            stackLabel.bottomAnchor.constraint(equalTo: buttonStackView.bottomAnchor,constant: 90),
        ])
        
        
    }
    
    @objc func tapDrawingView(_ gestureRecognizer:UITapGestureRecognizer){
        let duration: Double = 0.7
        
        moveBack(view: toolView)
        UIView.animate(withDuration: duration){
            self.move(view: self.toolView)
            self.toolView.isHidden = true
        }
        
        
        
        
        moveBack(view: bottomContainer)
        UIView.animate(withDuration: duration){
            self.move(view: self.bottomContainer)
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


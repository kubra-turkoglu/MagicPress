//
//  ViewController.swift
//  MagicPress
//
//  Created by Kubra Bozdogan on 7/2/25.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    let pressData = PressData()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()

        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "NewspaperImages", bundle: Bundle.main) {
            configuration.trackingImages = imageToTrack
            configuration.maximumNumberOfTrackedImages = imageToTrack.count
//            print("The image of Harry Potter inside the assets.xcassets was recognized.")
        }
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: any SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
//            print("Detected image name: \(imageAnchor.referenceImage.name ?? "none")")
            
            if let imageName = imageAnchor.referenceImage.name,
               let video = pressData.videoData[imageName] {
                let videoNode = SKVideoNode(fileNamed: video)
                videoNode.play()
                let videoScene = SKScene(size: CGSize(width: 480, height: 360))
                videoScene.addChild(videoNode)
                videoNode.position = CGPoint(x: videoScene.size.width / 2 , y: videoScene.size.height / 2)
                videoNode.yScale = -1.0
                let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
                plane.firstMaterial?.diffuse.contents = videoScene
                let planeNode = SCNNode(geometry: plane)
                planeNode.eulerAngles.x = -.pi / 2
                node.addChildNode(planeNode)
            }
        }
        return node
    }
}

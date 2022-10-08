//
//  ViewController.swift
//  RealityMeasurement
//
//  Created by NULL on 10/7/22.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    var dotNode = [SCNNode]()
    
    var textNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if dotNode.count >= 2 {
            for dot in dotNode {
                dot.removeFromParentNode()
            }
            dotNode = [SCNNode]()
        }
        if let touchesLocation = touches.first?.location(in: sceneView) {
            let hitTestResult = sceneView.hitTest(touchesLocation, types: .featurePoint)
            if let hitresult = hitTestResult.first {
                addDot(at: hitresult)
            }
        }
            
            }
    
    func addDot(at hitresult : ARHitTestResult) {
        let DotGeometry = SCNSphere(radius: 0.005)
        DotGeometry.firstMaterial?.diffuse.contents = UIColor(ciColor: .blue)
        let dotnode = SCNNode(geometry: DotGeometry)
        dotnode.position = SCNVector3(hitresult.worldTransform.columns.3.x, hitresult.worldTransform.columns.3.y, hitresult.worldTransform.columns.3.z)
        sceneView.scene.rootNode.addChildNode(dotnode)
        dotNode.append(dotnode)
        
        if dotNode.count >= 2 {
            calculate()
        }
    }
    func calculate() {
// must print to calculate the space distance that appear in the debug and  * 100
        let start = dotNode[0]
        let end = dotNode[1]
        //print(start.position)
        //print(end.position)
        //distance = √ ((x2-x1)^2 + (y2-y1)^2 + (z2-z1)^2)
        let distance = sqrt(
            pow(end.position.x - start.position.x, 2) +
            pow(end.position.y - start.position.y, 2) +
            pow(end.position.z - start.position.z, 2)
        )
        //print(abs(distance)) -> removing any negative signs
        updateText(text: "\(abs(distance))", atPosition: end.position)
        
    }
    func updateText(text: String, atPosition position: SCNVector3) {
        textNode.removeFromParentNode()
        
        let textGeometry = SCNText(string: text, extrusionDepth: 1.0)
        textGeometry.firstMaterial?.diffuse.contents = UIColor(ciColor: .blue)
        textNode = SCNNode(geometry: textGeometry)
        textNode.position = SCNVector3(position.x, position.y + 0.01, position.z)
        textNode.scale = SCNVector3(0.01, 0.01, 0.01)
        sceneView.scene.rootNode.addChildNode(textNode)
    }
    
    
    
    
    
        }




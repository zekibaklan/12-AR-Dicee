//
//  ViewController.swift
//  ARDicee
//
//  Created by Zeki Baklan on 7.08.2023.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    
    
    var diceArray = [SCNNode]()
    
    
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        sceneView.delegate = self
        
        sceneView.autoenablesDefaultLighting = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = .horizontal
    
        sceneView.session.run(configuration)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        sceneView.session.pause()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first
        {
            let touchLocation = touch.location(in: sceneView)
            let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            
            
            
            if let hitResult = results.first {
                
                
                addDice(atLocation: hitResult)
                
        }
            
            
        }
    }
    
    func addDice(atLocation location : ARHitTestResult) {
        
        // Create a new scene
        let diceScene = SCNScene(named: "art.scnassets/diceColladacopy.scn")!

        if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {

            diceNode.position = SCNVector3(x: location.worldTransform.columns.3.x,
                                           y: location.worldTransform.columns.3.y + diceNode.boundingSphere.radius,
                                           z: location.worldTransform.columns.3.z)

            diceArray.append(diceNode)
            
            sceneView.scene.rootNode.addChildNode(diceNode)
            
            roll(dice: diceNode)
            
            
        }
        
        
        
    }
    
    func roll(dice: SCNNode) {
        
        let randomX = Float(arc4random_uniform(4) + 1) * (Float.pi/2)
        
        let randomZ = Float(arc4random_uniform(4) + 1) * (Float.pi/2)
        
        dice.runAction(SCNAction.rotateBy(
            x: CGFloat(randomX * 5),
            y: 0,
            z: CGFloat(randomZ * 5),
            duration: 0.5)
        )
    }
    
    func rollAll() {
        
        
        if !diceArray.isEmpty {
            
            for dice in diceArray {
                
                roll(dice : dice)
                
            }
            
        }
    }
    
    
    @IBAction func rollAgain(_ sender: UIBarButtonItem) {
        
        rollAll()
        
    }
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        rollAll()
    }
    
    @IBAction func removeAllDice(_ sender: UIBarButtonItem) {
        
        if !diceArray.isEmpty {
            
            for dice in diceArray {
                
                dice.removeFromParentNode()
            }
        }
    }
    
    //MARK: - ARSCNViewDelegateMethod
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        guard anchor is ARPlaneAnchor else {return}
        

    }
    
    
    
}





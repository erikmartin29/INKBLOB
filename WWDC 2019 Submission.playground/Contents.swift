//: A SpriteKit based Playground

import PlaygroundSupport
import SpriteKit
import Carbon.HIToolbox

let playerCategory: UInt32 = 0x1 << 0 //1
let groundCategory: UInt32 = 0x1 << 1 //2
let goalCategory:   UInt32 = 0x1 << 2 //4

//change debug mode to true to see things more clearly
let debugMode = false

class GameScene: SKScene, SKPhysicsContactDelegate {
	
	var leftPressed = false
	var rightPressed = false
	var upPressed = false
	var downPressed = false
	
	var touchingGround = false
	
	let thePlayer: SKShapeNode = SKShapeNode(rectOf: CGSize(width: 20, height: 20))
    
    override func didMove(to view: SKView) {
		
		//set the bg to white if we aren't debugging
		if(!debugMode) {self.backgroundColor = .white}
		
		self.physicsWorld.contactDelegate = self
		
		//thePlayer.fillColor = .red
		thePlayer.position = CGPoint(x: -200, y: -100)
			
		thePlayer.physicsBody = SKPhysicsBody.init(rectangleOf: thePlayer.frame.size)
		thePlayer.physicsBody?.affectedByGravity = true
		thePlayer.physicsBody?.restitution = 0.0
		
		thePlayer.physicsBody?.categoryBitMask = playerCategory
		thePlayer.physicsBody?.collisionBitMask = groundCategory
		
		self.addChild(thePlayer)
		
		let platformArray: [Platform] = [  Platform(rectOf: CGSize(width: 200, height: 100)),
										   Platform(rectOf: CGSize(width: 200, height: 100))
										]
		
		let platformPositionArray: [CGPoint] = [
												CGPoint(x: 0, y: -200),
												CGPoint(x: 50, y: 50)
												]
		
		//levels will be something like this:
		/*
		class Level {
			var platformFormation: [([Platform],[CGPoint])]
		}
		let levelsArray: [Level] = []
		*/
		
		for index in 0..<platformArray.count {
			platformArray[index].setupProperties(pos: platformPositionArray[index])
			self.addChild(platformArray[index])
		}
		
		let floor: SKShapeNode = SKShapeNode(rectOf: CGSize(width: self.scene?.frame.width ?? 400, height: 100))
		
		floor.fillColor = .white
		floor.position = CGPoint(x: 0, y: -350)
		
		self.addChild(floor)
		floor.physicsBody = SKPhysicsBody(rectangleOf: floor.frame.size)
		floor.physicsBody?.affectedByGravity = false
		floor.physicsBody?.isDynamic = false
		floor.physicsBody?.restitution = 0.0
		
		floor.physicsBody?.categoryBitMask = groundCategory
		floor.physicsBody?.contactTestBitMask = playerCategory
		
		let goal: SKShapeNode = SKShapeNode(rectOf: CGSize(width: 50, height: 50))
		
		goal.fillColor = .red
		goal.position = CGPoint(x: 300, y: 300)
		
		self.addChild(goal)
		goal.physicsBody = SKPhysicsBody(rectangleOf: goal.frame.size)
		goal.fillColor = .white
		goal.physicsBody?.affectedByGravity = false
		goal.physicsBody?.isDynamic = false
		
		goal.physicsBody?.categoryBitMask = goalCategory
		goal.physicsBody?.contactTestBitMask = playerCategory
		
    }
	
	func didBegin(_ contact: SKPhysicsContact) {
		let collision: UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
		
		touchingGround = true
		
		if collision == playerCategory | groundCategory {
			print("collision between ground and player occured")
		}
		
		if collision == playerCategory | goalCategory {
			print("collision between goal and player occured")
		}
	}
	
	
    @objc static override var supportsSecureCoding: Bool {
        // SKNode conforms to NSSecureCoding, so any subclass going
        // through the decoding process must support secure coding
        get {
            return true
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
		let shaderTest: InkBlob = InkBlob(rectOf: CGSize(width: 800, height: 800))
		shaderTest.setupProperties(pos: pos)
		self.addChild(shaderTest)
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    override func mouseDown(with event: NSEvent) {
        touchDown(atPoint: event.location(in: self))
    }
    
    override func mouseDragged(with event: NSEvent) {
        touchMoved(toPoint: event.location(in: self))
    }
    
    override func mouseUp(with event: NSEvent) {
        touchUp(atPoint: event.location(in: self))
    }
	
	override func keyDown(with event: NSEvent) {
		switch Int(event.keyCode) {
		case kVK_LeftArrow:
			leftPressed = true
		case kVK_RightArrow:
			rightPressed = true
		case kVK_UpArrow:
			upPressed = true
		default:
			break
		}
	}
	
	override func keyUp(with event: NSEvent) {
		switch Int(event.keyCode) {
		case kVK_LeftArrow:
			leftPressed = false
		case kVK_RightArrow:
			rightPressed = false
		case kVK_UpArrow:
			upPressed = false
		default:
			break
		}
	}
    
    override func update(_ currentTime: TimeInterval) {
		
		//print(updatingVariable)
		
        // Called before each frame is rendered
		if leftPressed {
			thePlayer.position.x -= 10
		}
		if rightPressed {
			thePlayer.position.x += 10
		}
		if upPressed && touchingGround {
			thePlayer.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 15))
			touchingGround = false
		}
    }
}

///INKBLOB///
public class InkBlob: SKShapeNode{
	//TODO: make this not ugly
	func setupProperties(pos: CGPoint) {
		self.fillColor = .red
		self.strokeColor = .clear
		self.position = pos
		self.zPosition = -1
		
		let shader = SKShader(fileNamed: "inkBlobShader.fsh")
		self.fillShader = shader
		
		var updatingVariable: Float = 0
		shader.uniforms =  [SKUniform(name: "TEST", float: updatingVariable)]
		
		//ew this code is bad fix me
		let blockAction = SKAction.run { () -> Void in
			updatingVariable += 0.016666667
			shader.uniforms =  [SKUniform(name: "TEST", float: updatingVariable)]
		}
		let waitAction = SKAction.wait(forDuration:0.016666667)
		let sequenceAction = SKAction.sequence([waitAction, blockAction])
		let repeatAction = SKAction.repeat(sequenceAction, count: 360)
		self.run(repeatAction)
	}
}

///PLATFORM///
public class Platform: SKShapeNode {
	func setupProperties(pos: CGPoint) {
		if(debugMode) {self.fillColor = .red}
		else {self.fillColor = .white}
		
		self.position = pos
		self.physicsBody = SKPhysicsBody(rectangleOf: self.frame.size)
		self.physicsBody?.affectedByGravity = false
		self.physicsBody?.isDynamic = false
		self.physicsBody?.restitution = 0.0
		self.physicsBody?.categoryBitMask = groundCategory
		self.physicsBody?.contactTestBitMask = playerCategory
	}
}


//delays animations, this makes the code musch easier to read
public func delay(_ delay: Double, closure: @escaping ()->()) {
	let when = DispatchTime.now() + delay
	DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}



// Load the SKScene from 'GameScene.sks'
let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 640, height: 480))
if let scene = GameScene(fileNamed: "GameScene") {
    // Set the scale mode to scale to fit the window
    scene.scaleMode = .aspectFill
    
    // Present the scene
    sceneView.presentScene(scene)
}

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView

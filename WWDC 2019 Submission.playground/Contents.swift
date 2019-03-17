//: A SpriteKit based Playground

import PlaygroundSupport
import SpriteKit
import Carbon.HIToolbox

class GameScene: SKScene, SKPhysicsContactDelegate {
	
	let playerCategory: UInt32 = 0x1 << 0 //1
	let groundCategory: UInt32 = 0x1 << 1 //2
	
	var leftPressed = false
	var rightPressed = false
	var upPressed = false
	var downPressed = false
	
	var touchingGround = false
	
	let thePlayer: SKShapeNode = SKShapeNode(rectOf: CGSize(width: 20, height: 20))
    
    override func didMove(to view: SKView) {
		
		self.physicsWorld.contactDelegate = self
		
		thePlayer.fillColor = .red
		thePlayer.position = CGPoint(x: 200, y: 200)
			
		thePlayer.physicsBody = SKPhysicsBody.init(rectangleOf: thePlayer.frame.size)
		thePlayer.physicsBody?.affectedByGravity = true
		
		thePlayer.physicsBody?.categoryBitMask = playerCategory
		thePlayer.physicsBody?.collisionBitMask = groundCategory
		
		self.addChild(thePlayer)
		
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
		
		//TODO: Steamline creation of platforms
		let platform: SKShapeNode = SKShapeNode(rectOf: CGSize(width: 200, height: 100))
		
		platform.fillColor = .white
		platform.position = CGPoint(x: 0, y: -200)
		
		self.addChild(platform)
		platform.physicsBody = SKPhysicsBody(rectangleOf: platform.frame.size)
		platform.physicsBody?.affectedByGravity = false
		platform.physicsBody?.isDynamic = false
		platform.physicsBody?.restitution = 0.0
		
		platform.physicsBody?.categoryBitMask = groundCategory
		platform.physicsBody?.contactTestBitMask = playerCategory
		
    }
	
	func didBegin(_ contact: SKPhysicsContact) {
		let collision: UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
		
		touchingGround = true
		
		if collision == playerCategory | groundCategory {
			print("collision occured")
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
		case kVK_DownArrow:
			downPressed = true
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
		case kVK_DownArrow:
			downPressed = false
		default:
			break
		}
	}
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
		if leftPressed {
			thePlayer.position.x -= 10
		}
		if rightPressed {
			thePlayer.position.x += 10
		}
		if upPressed && touchingGround {
			thePlayer.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 10))
			touchingGround = false
		}
    }
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

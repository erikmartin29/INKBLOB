import Foundation
import SpriteKit
import Carbon.HIToolbox

let playerCategory: UInt32 = 0x1 << 0 //1
let groundCategory: UInt32 = 0x1 << 1 //2
let goalCategory:   UInt32 = 0x1 << 2 //4

//change debug mode to true to see things more clearly
let debugMode = false

let shader = SKShader(fileNamed: "inkBlobShader.fsh")

public class GameScene: SKScene, SKPhysicsContactDelegate {
	
	//this works for now but find a better solution
	//-1: incomplete, notstarted
	//0: in progress
	//1: complete
	var tutorialStep1Completion = -1
	var tutorialStep2Completion = -1
	var tutorialStep3Completion = -1
	
	//labels
	let label1 = SKLabelNode(text: "Oh.. I should probably tell you how to play. ")
	let label2 = SKLabelNode(text: "Click here to continue.")
	let label3 = SKLabelNode(text: "This is your player")
	let label4 = SKLabelNode(text: "Click here to continue.")
	let label5 = SKLabelNode(text: "This is your goal. Get here to advance to the next level.")
	let label6 = SKLabelNode(text: "Use your arrow keys to move")
	
	var blottingAllowed = false
	
	var leftPressed = false
	var rightPressed = false
	var upPressed = false
	var downPressed = false
	
	var touchingGround = false
	
	let thePlayer: SKShapeNode = SKShapeNode(rectOf: CGSize(width: 20, height: 20))
	
	///level loading///
	//TODO: parse this data in a file (maybe JSON?)
	//let levelsArray: [Level] = []
	let level1: Level = Level(formation: [(Platform(rectOf: CGSize(width: 200, height: 100)),CGPoint(x: 0, y: -200))], playerStartPos: CGPoint(x: 50, y: 50))
	let level2: Level = Level(formation: [(Platform(rectOf: CGSize(width: 3, height: 500)),CGPoint(x: 100, y: -200))], playerStartPos: CGPoint(x: -200, y: 50))
	
	//make it so that I can use those varibles ^^^
	let levelsArray: [Level] = [
		Level(formation: [(Platform(rectOf: CGSize(width: 3, height: 500)),CGPoint(x: 100, y: -200))], playerStartPos: CGPoint(x: -200, y: 50)),
		Level(formation: [(Platform(rectOf: CGSize(width: 200, height: 100)),CGPoint(x: 0, y: -200))], playerStartPos: CGPoint(x: 50, y: 50)),
		]
	
	var currentLevel = 1
	
	public override func didMove(to view: SKView) {
		
		//set the bg to white if we aren't debugging
		if(!debugMode) {self.backgroundColor = .white}
		
		self.physicsWorld.contactDelegate = self
		
		//self.introAnimation()
		self.loadLevel(self.levelsArray[0])
		startTutorial()
		
		self.thePlayer.physicsBody = SKPhysicsBody.init(rectangleOf: self.thePlayer.frame.size)
		self.thePlayer.physicsBody?.affectedByGravity = true
		self.thePlayer.physicsBody?.restitution = 0.0
		self.thePlayer.physicsBody?.allowsRotation = false
		self.thePlayer.physicsBody?.categoryBitMask = playerCategory
		self.thePlayer.physicsBody?.collisionBitMask = groundCategory
	}
	
	//make this better it sucks
	func startTutorial() {
		self.tutorialStep1Completion = 0
		label1.fontColor = .black
		addChild(label1)
		delay(2.0) {
			self.label1.removeFromParent()
			self.label2.fontColor = .black
			self.addChild(self.label2)
			self.blottingAllowed = true
			self.tutorialStep1Completion = 1
			//TODO: add arrow
		}
	}
	
	//find other solution later!
	func tutorialStep2() {
		print("step 2 started")
		self.blottingAllowed = false
		self.tutorialStep2Completion = 0
		self.label2.removeFromParent()
		self.label3.fontColor = .black
		self.addChild(label3)
		delay(2.0) {
			self.blottingAllowed = true
			self.label3.removeFromParent()
			self.label4.fontColor = .black
			self.addChild(self.label4)
			self.tutorialStep2Completion = 1
		}
	}
	
	func tutorialStep3() {
		print("step 3 started")
		self.blottingAllowed = false
		self.tutorialStep3Completion = 0
		self.label4.removeFromParent()
		self.label5.fontColor = .black
		self.addChild(label5)
		delay(2.0) {
			self.blottingAllowed = true
			self.label5.removeFromParent()
			self.label6.fontColor = .black
			self.addChild(self.label6)
			self.tutorialStep3Completion = 1
		}
	}
	
	func introAnimation() {
		/*let shaderTest: InkBlob = InkBlob(rectOf: CGSize(width: 1200, height: 1200))
		shaderTest.setupProperties(pos: CGPoint(x: 0, y: 0))
		self.addChild(shaderTest)*/
	}
	
	//TODO: levelID is a bad param name think of a new one later
	func loadLevel(_ level: Level) {
		////INSERT ANIMTION HERE LATER/////
		//add platforms
		for index in 0..<level.platformFormation.count {
			//access values from tuple: (Platform, CGPoint)
			let platform = level.platformFormation[index].0
			let platformPos = level.platformFormation[index].1
			platform.setupProperties(pos: platformPos)
			self.addChild(platform)
		}
		//add player at its start position
		thePlayer.position = level.playerStartPosition
		self.addChild(thePlayer)
		
		//add the floor
		let floor: SKShapeNode = SKShapeNode(rectOf: CGSize(width: self.scene?.frame.width ?? 400, height: 100))
		floor.fillColor = .white
		floor.position = CGPoint(x: 0, y: -350)
		floor.physicsBody = SKPhysicsBody(rectangleOf: floor.frame.size)
		floor.physicsBody?.affectedByGravity = false
		floor.physicsBody?.isDynamic = false
		floor.physicsBody?.restitution = 0.0
		floor.physicsBody?.categoryBitMask = groundCategory
		floor.physicsBody?.contactTestBitMask = playerCategory
		self.addChild(floor)
		
		//add the goal 
		let goal: SKShapeNode = SKShapeNode(rectOf: CGSize(width: 50, height: 50))
		goal.fillColor = .red
		goal.position = CGPoint(x: 300, y: 300)
		goal.physicsBody = SKPhysicsBody(rectangleOf: goal.frame.size)
		goal.fillColor = .white
		goal.physicsBody?.affectedByGravity = false
		goal.physicsBody?.isDynamic = false
		goal.physicsBody?.categoryBitMask = goalCategory
		goal.physicsBody?.contactTestBitMask = playerCategory
		self.addChild(goal)
	}
	
	public func didBegin(_ contact: SKPhysicsContact) {
		let collision: UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
		
		touchingGround = true
		
		if collision == playerCategory | groundCategory {
			print("collision between ground and player occured")
		}
		
		if collision == playerCategory | goalCategory {
			print("collision between goal and player occured")
			//TODO: maybe animate this?
			self.removeAllChildren()
			print(currentLevel)
			if(currentLevel < levelsArray.count) {
				self.loadLevel(levelsArray[currentLevel])
				currentLevel += 1
			} else {
				print("WINNER!")
				blottingAllowed = false
				//WIN ANIMATION
			}
		}
	}
	
	
	@objc public static override var supportsSecureCoding: Bool {
		// SKNode conforms to NSSecureCoding, so any subclass going
		// through the decoding process must support secure coding
		get {
			return true
		}
	}
	
	/////////////////////
	///MOUSE HANDLERS////
	/////////////////////
	
	func touchDown(atPoint pos : CGPoint) {
		//possibly make it so that ink bleed until mouse is released??
		
		print("\(tutorialStep1Completion)  \(tutorialStep2Completion) \(tutorialStep3Completion)")
		
		if(blottingAllowed) {
			/* ADD THIS WHEN SHADERS ARE WORKING
			let shaderTest: InkBlob = InkBlob(rectOf: CGSize(width: 1000, height: 1000))
			shaderTest.setupProperties(pos: pos)
			self.addChild(shaderTest)
			*/
			
			//this is just for testing
			let blob = SKShapeNode(rectOf: CGSize(width: 100, height: 100))
			blob.position = pos
			blob.strokeColor = .black
			blob.zPosition = -1
			blob.fillColor = .black
			self.addChild(blob)
		}
		
		//this is bad but...
		if(tutorialStep1Completion == 1 && tutorialStep2Completion == -1) {
			tutorialStep2()
		}
		if(tutorialStep2Completion == 1 && tutorialStep3Completion == -1) {
			tutorialStep3()
		}
	}
	
	func touchMoved(toPoint pos : CGPoint) {
	}
	
	func touchUp(atPoint pos : CGPoint) {
	}
	
	public override func mouseDown(with event: NSEvent) {
		touchDown(atPoint: event.location(in: self))
	}
	
	public override func mouseDragged(with event: NSEvent) {
		touchMoved(toPoint: event.location(in: self))
	}
	
	public override func mouseUp(with event: NSEvent) {
		touchUp(atPoint: event.location(in: self))
	}
	
	///////////////////
	///KEY HANDLERS////
	///////////////////
	
	public override func keyDown(with event: NSEvent) {
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
	
	public override func keyUp(with event: NSEvent) {
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
	
	public override func update(_ currentTime: TimeInterval) {
		
		// Called before each frame is rendered
		if leftPressed  { thePlayer.position.x -= 10 }
		if rightPressed { thePlayer.position.x += 10 }
		if upPressed && touchingGround {
			thePlayer.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 20))
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
		
		self.fillShader = shader
		
		//TODO: smooth animation curves
		var updatingVariable: Float = 0
		shader.uniforms =  [SKUniform(name: "TEST", float: updatingVariable)]
		
		//this is awful pls fix
		
		print("starting animation")
		var speedFactor = 1.0
		let timer : Timer?
		timer =  Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (Timer) in
			speedFactor += 0.04
			updatingVariable += Float(0.01 * speedFactor)
			shader.uniforms =  [SKUniform(name: "TEST", float: updatingVariable)]
		})
		delay(2.0) {
			timer?.invalidate()
			
			let timer2 : Timer?
			timer2 =  Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (Timer) in
				
				if(speedFactor > 0.03){
					speedFactor -= 0.03
				}
				print(speedFactor)
				updatingVariable += Float(0.016666667 * speedFactor)
				shader.uniforms =  [SKUniform(name: "TEST", float: updatingVariable)]
			})
			
			delay(4.0) {
				timer2?.invalidate()
			}
		}
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

//levels will be something like this:
class Level {
	var platformFormation: [(Platform,CGPoint)]
	var playerStartPosition: CGPoint
	
	init(formation: [(Platform,CGPoint)], playerStartPos: CGPoint) {
		platformFormation = formation
		playerStartPosition = playerStartPos
	}
}

//delays animations, this makes the code musch easier to read
public func delay(_ delay: Double, closure: @escaping ()->()) {
	let when = DispatchTime.now() + delay
	DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

import Foundation
import SpriteKit
import Carbon.HIToolbox

let playerCategory: UInt32 = 0x1 << 0 //1
let groundCategory: UInt32 = 0x1 << 1 //2
let goalCategory:   UInt32 = 0x1 << 2 //4

//change debug mode to true to see things more clearly
let debugMode = false
var numberOfBlobs = 0
var numberOfPlatforms = 0
var goalCollisions = 0

enum GameState {
	case part1
	case part2
	case part3
	case part4
	case part5
	case playing
}

public class GameScene: SKScene, SKPhysicsContactDelegate {
	var gameState: GameState = .part1
	var stateLocked = true //state locked for both mouse and key
	var keyInteractionEnabled   = false
	var mouseInteractionEnabled = false
	
	//labels
	let label1 = SKLabelNode(text: "Oh.. I should probably tell you how to play. ")
	let label2 = SKLabelNode(text: "Click here to continue.")
	let label3 = SKLabelNode(text: "This is your player")
	let label4 = SKLabelNode(text: "Click here to continue.")
	let label5 = SKLabelNode(text: "This is your goal.")
	let label6 = SKLabelNode(text: "Use your arrow keys to move")
	let label7 = SKLabelNode(text: "You have 3 ink drops per level. If you mess up, press r to restart the level.")
	let label8 = SKLabelNode(text: "Go ahead and use your third ink blob to revel the map.")
	let label9 = SKLabelNode(text: "GOOD LUCK")
	
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
		Level(formation: [(Platform(rectOf: CGSize(width: 50, height: 100)),CGPoint(x: 100, y: -200))], playerStartPos: CGPoint(x: -200, y: 50)),
		Level(formation: [(Platform(rectOf: CGSize(width: 200, height: 100)),CGPoint(x: 0, y: -200))], playerStartPos: CGPoint(x: 50, y: 50)),
		]
	
	var currentLevel = 1
	
	public override func didMove(to view: SKView) {
		
		//set the bg to white if we aren't debugging
		if(!debugMode) {self.backgroundColor = .white}
		
		self.physicsWorld.contactDelegate = self
		
		self.introAnimation()
		self.loadLevel(self.levelsArray[0])
		//startTutorial()
		
		self.thePlayer.physicsBody = SKPhysicsBody.init(rectangleOf: self.thePlayer.frame.size)
		self.thePlayer.physicsBody?.affectedByGravity = true
		self.thePlayer.physicsBody?.restitution = 0.0
		self.thePlayer.physicsBody?.allowsRotation = false
		self.thePlayer.physicsBody?.categoryBitMask = playerCategory
		self.thePlayer.physicsBody?.collisionBitMask = groundCategory
		
		//make sure the player cannot go outside of the screen
		let xRange = SKRange(lowerLimit:-1*size.width/2,upperLimit:size.width/2)
		let yRange = SKRange(lowerLimit:-1*size.width/2,upperLimit:size.height/2)
		//sprite.constraints = [SKConstraint.positionX(xRange,Y:yRange)] // iOS 9
		thePlayer.constraints = [SKConstraint.positionX(xRange,y:yRange)]

	}
	
	func startTutorial() {
		label1.fontColor = .black
		label1.fontSize = 45
		addChild(label1)
		stateLocked = true
		delay(2.0) {
			self.label1.removeFromParent()
			self.label2.fontColor = .black
			self.label2.fontSize = 45
			self.addChild(self.label2)
			self.blottingAllowed = true
			self.stateLocked = false
			self.mouseInteractionEnabled = true
			//TODO: add arrow
		}
	}
	
	//find other solution later!
	func tutorialStep2() {
		print("step 2 started")
		self.blottingAllowed = false
		self.label2.removeFromParent()
		label3.fontColor = .white
		label3.fontSize = 20
		label3.position = CGPoint(x: -250, y: -200)
		self.addChild(label3)
		self.gameState = .part2
		stateLocked = true
		self.mouseInteractionEnabled = false
		delay(4.0) {
			self.blottingAllowed = true
			self.label3.removeFromParent()
			self.label4.fontColor = .black
			self.label4.fontSize = 45
			self.addChild(self.label4)
			self.stateLocked = false
			self.mouseInteractionEnabled = true
		}
	}
	
	func tutorialStep3() {
		print("step 3 started")
		self.blottingAllowed = false
		self.label4.removeFromParent()
		label5.fontColor = .white
		label5.fontSize = 20
		label5.position = CGPoint(x: 350, y: 250)
		self.addChild(label5)
		self.gameState = .part3
		stateLocked = true
		self.mouseInteractionEnabled = false
		delay(2.0) {
			self.blottingAllowed = true
			self.label5.removeFromParent()
			self.label6.fontColor = .black
			self.label6.fontSize = 45
			self.addChild(self.label6)
			self.gameState = .part4
			self.stateLocked = false
			self.keyInteractionEnabled = true
			self.mouseInteractionEnabled = false
		}
	}
	
	func tutorialStep4() {
		print("step 4 started")
		self.blottingAllowed = false
		self.label6.removeFromParent()
		self.label7.fontColor = .black
		self.label7.fontSize = 45
		self.addChild(label7)
		self.gameState = .part4
		stateLocked = true
		self.keyInteractionEnabled = false
		delay(2.0) {
			self.blottingAllowed = true
			self.label7.removeFromParent()
			self.label8.fontColor = .black
			self.label8.fontSize = 45
			self.addChild(self.label8)
			self.gameState = .part5
			self.stateLocked = false
			self.mouseInteractionEnabled = true
		}
	}
	
	func tutorialStep5() {
		print("step 5 started")
		self.blottingAllowed = false
		self.label8.removeFromParent()
		self.label9.fontColor = .black
		self.label9.fontSize = 45
		self.addChild(label9)
		self.gameState = .part5
		stateLocked = true
		self.mouseInteractionEnabled = false
		delay(2.0) {
			self.blottingAllowed = true
			self.label9.removeFromParent()
			self.gameState = .playing
			self.stateLocked = false
			self.mouseInteractionEnabled = true
		}
	}
	
	func tutorialPlaying() {
		print("PLAYING IS CALLED YEET")
		self.blottingAllowed = false
		self.label8.removeFromParent()
		stateLocked = true
		delay(2.0) {
			self.blottingAllowed = true
		}
	}
	
	func introAnimation() {
		let shaderTest: InkBlob = InkBlob(rectOf: CGSize(width: 1200, height: 1200))
		shaderTest.setupProperties(pos: CGPoint(x:0,y:0), inBack: false)
		self.addChild(shaderTest)
		shaderTest.animate(amount: 5.5)
		delay(5.5) {
			//18
			self.startTutorial()
		}
		//animate(mode:)
		
		//start tutorial:
	}
	
	//TODO: levelID is a bad param name think of a new one later
	func loadLevel(_ level: Level) {
		////INSERT ANIMTION HERE LATER/////
		//add platforms
		levelLoading = true
		
		for index in 0..<level.platformFormation.count {
			//access values from tuple: (Platform, CGPoint)
			let platform = level.platformFormation[index].0
			let platformPos = level.platformFormation[index].1
			platform.setupProperties(pos: platformPos)
			numberOfPlatforms += 1
			platform.name = "platform\(numberOfPlatforms)"
			self.addChild(platform)
		}
		//add player at its start position
		thePlayer.position = level.playerStartPosition
		thePlayer.name = "player"
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
		floor.name = "floor"
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
		goal.name = "goal"
		self.addChild(goal)
	}
	
	var levelLoading = false
	
	public func didBegin(_ contact: SKPhysicsContact) {
		let collision: UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
		
		touchingGround = true
		
		if collision == playerCategory | groundCategory {
			print("collision between ground and player occured")
		}
		
		if collision == playerCategory | goalCategory {
			print("collision between goal and player occured")
			//TODO: maybe animate this?
			//print(currentLevel)
			if(currentLevel < levelsArray.count) {
				
			//remove player instantly
			if let child = self.childNode(withName: "player") as? SKShapeNode { child.removeFromParent() }
			self.transistionAnimation()
			delay(3.5) {
				self.unloadLevel()
				self.loadLevel(self.levelsArray[self.currentLevel])
				self.currentLevel += 1
			}
				
			} else {
				print("WINNER!")
				self.transistionAnimation()
				blottingAllowed = false
				//WIN ANIMATION
			}
		}
	}
	
	func transistionAnimation() {
		let shaderTest: InkBlob = InkBlob(rectOf: CGSize(width: 1200, height: 1200))
		shaderTest.setupProperties(pos: CGPoint(x:0,y:0), inBack: false)
		shaderTest.animate(amount: 5.5)
		addChild(shaderTest)
	}
	
	func unloadLevel() {
		if let child = self.childNode(withName: "floor") as? SKShapeNode {
			child.removeFromParent()
		}
		
		for i in 1...numberOfPlatforms {
			if let child = self.childNode(withName: "platform\(i)") as? SKShapeNode {
				child.removeFromParent()
			}
		}
		
		for i in 1...numberOfBlobs {
			if let child = self.childNode(withName: "normalBlob\(i)") as? SKShapeNode {
				child.removeFromParent()
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
		guard mouseInteractionEnabled == true else { return }
		
		let shaderTest: InkBlob = InkBlob(rectOf: CGSize(width: 1000, height: 1000))
		shaderTest.setupProperties(pos: pos, inBack: true)
		self.addChild(shaderTest)
		shaderTest.animate(amount: 2.0)

		switch gameState {
			case .part1:
				tutorialStep2()
			case .part2:
				tutorialStep3()
			case .part3:
				break
			case .part4:
				print("they added the blob yo")
				//tutor
			case .part5:
				tutorialStep5()
			case .playing:
				//do game stuff in here
				tutorialPlaying()
				print("playing")
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
		
		//print("PLEASE PLEASE \(gameState)")
		guard stateLocked == false else { return }
		if(gameState == .part4) {
			tutorialStep4()
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
	let shader = SKShader(fileNamed: "inkBlobShader.fsh")
	
	func setupProperties(pos: CGPoint, inBack: Bool) {

		self.fillColor = .clear
		self.strokeColor = .clear
		self.position = pos
		if(inBack) {self.zPosition = -1} else {self.zPosition = 1}
		if(inBack) {
			numberOfBlobs += 1
			print("normalBlob\(numberOfBlobs)")
			self.name = "normalBlob\(numberOfBlobs)"
		} else {self.name = "transistionBlob"}
		self.fillShader = shader
	}
	
	func animate(amount: Double) {
		
		let action = SKAction.customAction(withDuration: amount) { (node, time) in
			//print(time)
			//maybe play w/ different equations later
			self.shader.uniforms =  [SKUniform(name: "TEST", float: Float((3*time) + 2))]
		}
		//set animation curve
		action.timingMode = .easeInEaseOut
		self.run(action)
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

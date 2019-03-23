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
	var currentLevel = 1
	
	var keyInteractionEnabled   = false
	var mouseInteractionEnabled = false
	
	//labels
	let titleLabel = SKLabelNode(text: "INKBLOB")
	
	let label1 = SKLabelNode(text: "Oh.. I should probably tell you how to play. ")
	let label2 = SKLabelNode(text: "Click here to continue.")
	let label3 = SKLabelNode(text: "This is your player")
	let label4 = SKLabelNode(text: "Click here to continue.")
	let label5 = SKLabelNode(text: "This is your goal.")
	let label5Line2 = SKLabelNode(text: "Get your player here to advance to the next level.")
	let label6 = SKLabelNode(text: "Use your arrow keys to move")
	let label7 = SKLabelNode(text: "You have 3 ink drops per level. If you mess up, press r to restart the level.")
	let label8 = SKLabelNode(text: "Click here to continue")
	let label9 = SKLabelNode(text: "As you can see, using ink reveals the map.")
	let label9Line2 = SKLabelNode(text: "You have 3 ink blobs per level. Use them wisely")
	
	var blottingAllowed = false
	
	//key press statuses
	var leftPressed = false
	var rightPressed = false
	var upPressed = false
	var downPressed = false
	
	var touchingGround = false
	
	let thePlayer: SKShapeNode = SKShapeNode(rectOf: CGSize(width: 20, height: 20))
	
	let clickIndicator = ClickIndicator(ellipseOf: CGSize(width: 50.0, height: 50.0))
	
	///level loading///
	//TODO: parse this data in a file (maybe JSON?)
	//let levelsArray: [Level] = []
	let level1: Level = Level(formation: [(Platform(rectOf: CGSize(width: 200, height: 100)),CGPoint(x: 0, y: -200))], playerStartPos: CGPoint(x: -350, y: 50))
	let level2: Level = Level(formation: [(Platform(rectOf: CGSize(width: 3, height: 500)),CGPoint(x: 100, y: -200))], playerStartPos: CGPoint(x: -200, y: 50))
	
	//make it so that I can use those varibles ^^^
	let levelsArray: [Level] = [
		Level(formation: [(Platform(rectOf: CGSize(width: 50, height: 100)),CGPoint(x: 100, y: -200))], playerStartPos: CGPoint(x: -350, y: 50)),
		Level(formation: [(Platform(rectOf: CGSize(width: 200, height: 100)),CGPoint(x: 0, y: -200))], playerStartPos: CGPoint(x: 50, y: 50)),
		]
	
	public override func didMove(to view: SKView) {
		//set the bg to white if we aren't debugging
		if(!debugMode) {self.backgroundColor = .white}
		
		self.physicsWorld.contactDelegate = self
		
		self.introAnimation()
		self.loadLevel(self.levelsArray[0])
		
		self.thePlayer.physicsBody = SKPhysicsBody.init(rectangleOf: self.thePlayer.frame.size)
		self.thePlayer.physicsBody?.affectedByGravity = true
		self.thePlayer.physicsBody?.restitution = 0.0
		self.thePlayer.physicsBody?.allowsRotation = false
		self.thePlayer.physicsBody?.categoryBitMask = playerCategory
		self.thePlayer.physicsBody?.collisionBitMask = groundCategory
		
		//make sure the player cannot go outside of the screen
		let xRange = SKRange(lowerLimit:-1*size.width/2,upperLimit:size.width/2)
		let yRange = SKRange(lowerLimit:-1*size.width/2,upperLimit:size.height/2)
		thePlayer.constraints = [SKConstraint.positionX(xRange,y:yRange)]

	}
	
	func introAnimation() {
		let shaderTest: InkBlob = InkBlob(rectOf: CGSize(width: 1200, height: 1200))
		shaderTest.setupProperties(pos: CGPoint(x:0,y:0), inBack: false)
		addChild(shaderTest)
		shaderTest.animate(amount: 5.5)
		titleLabel.fontSize = 50
		titleLabel.fontColor = .white
		titleLabel.zPosition = 2
		addChild(titleLabel)
		delay(5.5) {
			self.titleLabel.removeFromParent()
			self.startTutorial()
		}
	}
	
	func startTutorial() {
		label1.fontColor = .black
		label1.fontSize = 45
		addChild(label1)
		delay(2.0) {
			self.label1.removeFromParent()
			self.label2.fontColor = .black
			self.label2.fontSize = 20
			self.label2.position = CGPoint(x: -350, y: -200)
			
			self.clickIndicator.setupProperties(pos: CGPoint(x: -350, y: -250))
			self.addChild(self.clickIndicator)
			
			self.addChild(self.label2)
			self.blottingAllowed = true
			self.mouseInteractionEnabled = true
			//TODO: add arrow
		}
	}
	
	func tutorialStep2() {
		print("step 2 started")
		self.blottingAllowed = false
		self.label2.removeFromParent()
		self.label3.fontColor = .white
		self.label3.fontSize = 20
		self.label3.position = CGPoint(x: -350, y: -200)
		self.addChild(label3)
		self.gameState = .part2
		self.mouseInteractionEnabled = false
		
		delay(0.5) {
			self.clickIndicator.removeFromParent()
		}
		delay(4.0) {
			self.blottingAllowed = true
			self.label3.removeFromParent()
			self.label4.fontColor = .black
			self.label4.fontSize = 20
			self.label4.position = CGPoint(x: 300, y: 250)
			
			self.clickIndicator.setupProperties(pos: CGPoint(x: 300, y: 380))
			self.addChild(self.clickIndicator)
			
			self.addChild(self.label4)
			self.mouseInteractionEnabled = true
		}
	}
	
	func tutorialStep3() {
		print("step 3 started")
		self.blottingAllowed = false
		self.label4.removeFromParent()
		self.label5.fontColor = .white
		self.label5.fontSize = 20
		self.label5.position = CGPoint(x: 300, y: 250)
		self.label5Line2.fontColor = .white
		self.label5Line2.fontSize = 20
		self.label5Line2.position = CGPoint(x: 300, y: 225)
		self.addChild(label5)
		self.addChild(label5Line2)
		self.gameState = .part3
		self.mouseInteractionEnabled = false
		delay(4.0) {
			self.keyInteractionEnabled = true
			self.blottingAllowed = true
			self.label5.removeFromParent()
			self.label5Line2.removeFromParent()
			self.label6.fontColor = .white
			self.label6.fontSize = 20
			self.label6.position = CGPoint(x: -350, y: -200)
			self.addChild(self.label6)
			self.gameState = .part4
			self.mouseInteractionEnabled = false
		}
	}
	
	func tutorialStep4() {
		print("step 4 started")
		self.gameState = .part5
		self.blottingAllowed = false
		delay(2.0) {
			self.label6.removeFromParent()
			self.blottingAllowed = true
			self.label7.removeFromParent()
			self.label8.fontColor = .black
			self.label8.fontSize = 20
			self.label8.position = CGPoint(x: 150, y: -100)
			self.addChild(self.label8)
			self.gameState = .part5
			self.mouseInteractionEnabled = true
		}
	}
	
	func tutorialStep5() {
		print("step 5 started")
		self.blottingAllowed = false
		self.label8.removeFromParent()
		self.label9.fontColor = .white
		self.label9.fontSize = 20
		self.label9.position = CGPoint(x: 150, y: -100)
		self.label9Line2.fontColor = .white
		self.label9Line2.fontSize = 20
		self.label9Line2.position = CGPoint(x: 150, y: -75)
		self.addChild(label9)
		self.addChild(label9Line2)
		self.gameState = .part5
		self.mouseInteractionEnabled = false
		delay(4.0) {
			self.label9.text = "Good luck! See you on the other end :)"
			self.label9Line2.text = "If you mess up, press R to restart the level."
			delay(4.0) {
			self.blottingAllowed = true
			self.label9.removeFromParent()
			self.label9Line2.removeFromParent()
			self.gameState = .playing
			self.mouseInteractionEnabled = true
			}
		}
	}
	
	func tutorialPlaying() {
		print("PLAYING IS CALLED YEET")
		self.blottingAllowed = false
		self.label8.removeFromParent()
		delay(2.0) {
			self.blottingAllowed = true
		}
	}
	
	func loadLevel(_ level: Level) {
		//add platforms
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
	
	public func didBegin(_ contact: SKPhysicsContact) {
		let collision: UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
		
		//fix this. this isn't always true
		
		if collision == playerCategory | groundCategory {
			touchingGround = true
			//print("collision between ground and player occured")
		}
		
		if collision == playerCategory | goalCategory {
			//print("collision between goal and player occured")
			//TODO: maybe animate this?
			if(currentLevel < levelsArray.count) {
				//remove player instantly
				if let child = self.childNode(withName: "player") as? SKShapeNode { child.removeFromParent() }
				self.transistionAnimation()
				
				//unload level and load next level
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
		shaderTest.animate(amount: 1.8)

		switch gameState {
			case .part1:
				tutorialStep2()
			case .part2:
				tutorialStep3()
			case .part3:
				break
			case .part4:
				break
			case .part5:
				tutorialStep5()
			case .playing:
				tutorialPlaying()
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
		
		guard keyInteractionEnabled == true else { return }
		
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
		
		if(gameState == .part4) {
			self.tutorialStep4()
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

//delays animations, this makes the code musch easier to read
public func delay(_ delay: Double, closure: @escaping ()->()) {
	let when = DispatchTime.now() + delay
	DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

class ClickIndicator: SKShapeNode {
	func setupProperties(pos: CGPoint) {
		print("CALLED YES YSE")
		self.position = pos
		self.fillColor = .clear
		self.strokeColor = .black
		
		let action = SKAction.scale(to: 1.5, duration: 1.0)
		action.timingMode = .easeInEaseOut
		
		let action2 = SKAction.scale(to: 1.0, duration: 1.0)
		action.timingMode = .easeInEaseOut
		
		let sequence = SKAction.sequence([action, action2])
		let continuous = SKAction.repeatForever(sequence)
		self.run(continuous)
	}
}
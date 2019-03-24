import Foundation
import SpriteKit
import Carbon.HIToolbox

let playerCategory: UInt32 = 0x1 << 0 //1
let groundCategory: UInt32 = 0x1 << 1 //2
let goalCategory:   UInt32 = 0x1 << 2 //4

//change debug mode to true to see things more clearly
let debugMode = false
public var numberOfBlobs = 0
var numberOfPlatforms = 0

public var totalBlobsAdded = 0

enum GameState {
	case part1
	case part2
	case part3
	case part4
	case part5
	case part6
	case part7
	case part8
	case part9
	case playing
}

public class GameScene: SKScene, SKPhysicsContactDelegate {
	var gameState: GameState = .part1
	var currentLevel = 1
	
	var keyInteractionEnabled   = false
	var arrowKeyControlsEnabled = false
	var mouseInteractionEnabled = false
	var spaceInteractionEnabled = false
	
	var spaceClicked = false
	
	//labels
	let titleLabel = SKLabelNode(text: "INKBLOB")
	let spaceLabel = SKLabelNode(text: "Press space to proceed")
	let goodLuck = SKLabelNode(text: "Good Luck!")
	let label1 = SKLabelNode(text: "Oh.. I should probably tell you how to play. ")
	let label2 = SKLabelNode(text: "Click here to continue.")
	let label3 = SKLabelNode(text: "This is your player")
	let label4 = SKLabelNode(text: "Click here to continue.")
	let label5 = SKLabelNode(text: "This is your goal.")
	let label6 = SKLabelNode(text: "Use your arrow keys to move")
	let label7 = SKLabelNode(text: "But the more you use, the lower your score")
	let label8 = SKLabelNode(text: "Click here to continue")
	let label9 = SKLabelNode(text: "Clicking will cause ink to spill, revealing the map.")
	let label9Line2 = SKLabelNode(text: "But the more you use, the lower your score will be.")
	let label5Line2 = SKLabelNode(text: "Get here to advance to the next level.")
	
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
	/*let level1: Level = Level(formation: [(Platform(rectOf: CGSize(width: 200, height: 50)),CGPoint(x: 0, y: -200)),
	(Platform(rectOf: CGSize(width: 200, height: 50)),CGPoint(x:300, y: -50)),
	(Platform(rectOf: CGSize(width: 200, height: 100)),CGPoint(x: 0, y: -200)),
	(Platform(rectOf: CGSize(width: 200, height: 100)),CGPoint(x: 0, y: -200))],
	playerStartPos: CGPoint(x: -350, y: 50))
	
	let level2: Level = Level(formation: [(Platform(rectOf: CGSize(width: 3, height: 500)),CGPoint(x: 100, y: -200))], playerStartPos: CGPoint(x: -200, y: 50))*/
	
	//make it so that I can use those varibles ^^^
	let levelsArray: [Level] =
		[
			Level(formation: [(Platform(rectOf: CGSize(width: 200, height: 50)),CGPoint(x: 150, y: -200))],  playerStartPos: CGPoint(x: -300, y: 50), goalPos: CGPoint(x: 275, y: 300)),
			/*Level 1:*/
			Level(formation: [  (Platform(rectOf: CGSize(width: 180, height: 60)),CGPoint(x: -30, y:  -150)),
								(Platform(rectOf: CGSize(width: 120, height: 60)),CGPoint(x: 270, y: -30)),
								(Platform(rectOf: CGSize(width: 180, height: 60)),CGPoint(x: 30, y: 150)),
								(Platform(rectOf: CGSize(width: 180, height: 60)),CGPoint(x: 380, y: 280)),
								],
				  
				  playerStartPos: CGPoint(x: 50, y: 50),
				  goalPos: CGPoint(x: 440, y: 410)),
			/*Level 2:*/
			Level(formation: [  (Platform(rectOf: CGSize(width: 120, height: 60)),CGPoint(x: -540, y: -90)),
								(Platform(rectOf: CGSize(width: 180, height: 60)),CGPoint(x: 30, y: -150)),
								(Platform(rectOf: CGSize(width: 120, height: 60)),CGPoint(x: 540, y: -90)),
								(Platform(rectOf: CGSize(width: 60, height:  60)),CGPoint(x: 210, y: -30)),
								(Platform(rectOf: CGSize(width: 60, height:  60)),CGPoint(x: 270, y: 90)),
								(Platform(rectOf: CGSize(width: 60, height: 60)),CGPoint(x: 150, y: 150)),
								(Platform(rectOf: CGSize(width: 60, height: 300)),CGPoint(x: 30, y: 90)),
								(Platform(rectOf: CGSize(width: 60, height: 60)),CGPoint(x: -90, y: 150)),
								(Platform(rectOf: CGSize(width: 60, height: 180)),CGPoint(x: -150, y: 330)),
								(Platform(rectOf: CGSize(width: 60, height: 60)),CGPoint(x: -210, y: 90)),
								(Platform(rectOf: CGSize(width: 60, height: 60)),CGPoint(x: -270, y: 210)),
								],
				  
				  playerStartPos: CGPoint(x: 450, y: -270),
				  goalPos: CGPoint(x: -390, y: 330)),
			
			/*Level 3*/
			Level(formation: [  (Platform(rectOf: CGSize(width: 360, height: 60)),CGPoint(x: -420, y: 330)),
								(Platform(rectOf: CGSize(width: 120, height: 60)),CGPoint(x: -240, y: 270)),
								(Platform(rectOf: CGSize(width: 120, height: 60)),CGPoint(x: -60, y: 270)),
								(Platform(rectOf: CGSize(width: 120, height:  60)),CGPoint(x: 180, y: 270)),
								(Platform(rectOf: CGSize(width: 180, height:  60)),CGPoint(x: -150, y: -150)),
								(Platform(rectOf: CGSize(width: 360, height: 60)),CGPoint(x: 240, y: 150)),
								(Platform(rectOf: CGSize(width: 120, height: 180)),CGPoint(x: 540, y: 150)),
								(Platform(rectOf: CGSize(width: 60, height: 60)),CGPoint(x: 270, y: -270)),
								(Platform(rectOf: CGSize(width: 120, height: 60)),CGPoint(x: 480, y: -150)),
								(Platform(rectOf: CGSize(width: 180, height: 60)),CGPoint(x: 390, y: -210)),
								],
				  
				  playerStartPos: CGPoint(x: -510, y: 400),
				  goalPos: CGPoint(x: 330, y: -225))
			
			
	]
	
	public override func didMove(to view: SKView) {
		//set the bg to white if we aren't debugging
		if(!debugMode) {self.backgroundColor = .white}
		
		self.physicsWorld.contactDelegate = self
		
		self.introAnimation()
		levelLoading = true
		self.loadLevel(self.levelsArray[self.currentLevel - 1])
		
		//unload level and load next level
		delay(3.0) {
			//add player at its start position
			self.thePlayer.position = self.levelsArray[self.currentLevel - 1].playerStartPosition
			self.thePlayer.fillColor = .black
			self.thePlayer.name = "player"
			self.addChild(self.thePlayer)
			
			//add the goal
			let goal: SKShapeNode = SKShapeNode(ellipseOf: CGSize(width: 50, height: 50))
			goal.position = CGPoint(x: 275, y: 300)
			goal.physicsBody = SKPhysicsBody.init(circleOfRadius: 25)
			goal.fillColor = .black
			goal.physicsBody?.affectedByGravity = false
			goal.physicsBody?.isDynamic = false
			goal.physicsBody?.categoryBitMask = goalCategory
			goal.physicsBody?.contactTestBitMask = playerCategory
			goal.name = "goal"
			self.addChild(goal)
		}
		
		fadeInAction.timingMode = .easeIn
		fadeOutAction.timingMode = .easeIn
		spaceLabel.fontSize = 28
		spaceLabel.fontName = "AvenirNext-Bold"
		
		self.thePlayer.physicsBody = SKPhysicsBody.init(rectangleOf: self.thePlayer.frame.size)
		self.thePlayer.physicsBody?.affectedByGravity = true
		self.thePlayer.physicsBody?.restitution = 0.0
		self.thePlayer.physicsBody?.allowsRotation = false
		self.thePlayer.physicsBody?.categoryBitMask = playerCategory
		self.thePlayer.physicsBody?.collisionBitMask = groundCategory
		
		//make sure the player cannot go outside of the screen
		let xRange = SKRange(lowerLimit:((-1*size.width/2) + 10),upperLimit:((size.width/2) - 10))
		let yRange = SKRange(lowerLimit:((-1*size.height/2) + 10),upperLimit:((size.height/2) - 10))
		thePlayer.constraints = [SKConstraint.positionX(xRange,y:yRange)]
		
		label1.fontName = "AvenirNext-Heavy"
		label2.fontName = "AvenirNext-Heavy"
		label3.fontName = "AvenirNext-Heavy"
		label4.fontName = "AvenirNext-Heavy"
		label5.fontName = "AvenirNext-Heavy"
		label6.fontName = "AvenirNext-Heavy"
		label7.fontName = "AvenirNext-Heavy"
		label8.fontName = "AvenirNext-Heavy"
		label9.fontName = "AvenirNext-Heavy"
		
		label5Line2.fontName = "AvenirNext-DemiBold"
		label9Line2.fontName = "AvenirNext-DemiBold"
		
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
			self.step1() //self.startTutorial()
		}
	}
	
	////TUTORIAL STEPS//////
	
	//start -> click to continue
	func step1() {
		print("step 1 started")
		self.gameState = .part1
		
		//intro label thing
		label1.fontColor = .black
		label1.fontSize = 45
		addChild(label1)
		
		delay(2.0) {
			self.label1.removeFromParent()
			self.label2.fontColor = .black
			self.label2.fontSize = 35
			self.label2.position = CGPoint(x: -275, y: -160)
			self.clickIndicator.setupProperties(pos: CGPoint(x: -300, y: -285))
			self.addChild(self.clickIndicator)
			self.addChild(self.label2)
			self.blottingAllowed = true
			self.mouseInteractionEnabled = true
			//TODO: add arrow
		}
	}
	
	//this is ur player -> wait until space pressed
	func step2() {
		print("step 2 started")
		self.blottingAllowed = false
		self.label2.removeFromParent()
		
		self.label3.fontColor = .white
		self.label3.fontSize = 40
		self.label3.position = CGPoint(x: -300, y: -160)
		
		self.spaceLabel.position = CGPoint(x: label3.position.x, y: label3.position.y - 30)
		self.addChild(spaceLabel)
		
		self.addChild(label3)
		self.gameState = .part2
		self.keyInteractionEnabled = true
		self.clickIndicator.removeFromParent()
		
		self.mouseInteractionEnabled = false
		self.spaceInteractionEnabled = false
		delay(1.8) {
			self.spaceInteractionEnabled = true
			self.mouseInteractionEnabled = true
		}
		//self.keyInteractionEnabled = true
		//waiting for space press
	}
	
	//space pressed -> click to continue
	func step3() {
		print("step 3 started")
		self.gameState = .part3
		
		self.label3.removeFromParent()
		self.spaceLabel.removeFromParent()
		
		self.label4.fontColor = .black
		self.label4.fontSize = 40
		self.label4.position = CGPoint(x: 290, y: 225)
		self.addChild(label4)
		
		self.clickIndicator.setupProperties(pos: CGPoint(x: 275, y: 300))
		self.addChild(self.clickIndicator)
	}
	
	//this is your goal -> space to continue
	func step4() {
		print("step 4 started")
		self.gameState = .part4
		
		self.label4.removeFromParent()
		
		self.label5.fontColor = .white
		self.label5.fontSize = 40
		self.label5.position = CGPoint(x: 275, y: 225)
		self.label5Line2.fontColor = .white
		self.label5Line2.fontSize = 30
		self.label5Line2.position = CGPoint(x: 275, y: 195)
		self.addChild(label5)
		self.addChild(label5Line2)
		
		self.mouseInteractionEnabled = false
		self.spaceInteractionEnabled = false
		delay(1.8) {
			self.spaceInteractionEnabled = true
			self.mouseInteractionEnabled = true
		}
		
		self.spaceLabel.position = CGPoint(x: label5Line2.position.x, y: label5Line2.position.y - 30)
		self.addChild(spaceLabel)
		
		self.clickIndicator.removeFromParent()
		//add "this is your goal " label
		
		
	}
	
	func step5() {
		print("step 5 started")
		self.gameState = .part5
		
		self.label5.removeFromParent()
		self.label5Line2.removeFromParent()
		self.spaceLabel.removeFromParent()
		
		//add "use arrow keys to move" label
		self.label6.fontColor = .white
		self.label6.fontSize = 28
		self.label6.position = CGPoint(x: -290, y: -200)
		self.addChild(self.label6)
		
		//animation
		let goRight = SKAction.moveTo(x: self.thePlayer.position.x + 100, duration: 0.5)
		let goLeft = SKAction.moveTo(x: self.thePlayer.position.x - 100, duration: 0.5)
		let goBack = SKAction.moveTo(x: self.thePlayer.position.x, duration: 0.5)
		let jump = SKAction.run {
			self.thePlayer.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 20))
		}
		let sequence = SKAction.sequence([goRight, goLeft, goBack, jump])
		thePlayer.run(sequence)
		
		delay(2.5) {
			self.step6()
			self.arrowKeyControlsEnabled = true
		}
		
	}
	
	func step6() {
		print("step 6 started")
		self.gameState = .part6
		
		self.label6.removeFromParent()
		
		/*delay(2.0) {
		self.arrowKeyControlsEnabled = false
		}*/
		
		self.label8.fontColor = .black
		self.label8.fontSize = 35
		self.label8.position = CGPoint(x: 280, y: -190)
		self.addChild(label8)
		
		//click here indicator
		self.clickIndicator.setupProperties(pos: CGPoint(x: 150, y: -90))
		self.addChild(self.clickIndicator)
		
	}
	
	func step7() {
		print("step 7 started")
		self.gameState = .part7
		
		self.clickIndicator.removeFromParent()
		
		self.mouseInteractionEnabled = false
		self.spaceInteractionEnabled = false
		
		delay(1.8) {
			self.spaceInteractionEnabled = true
			self.mouseInteractionEnabled = true
		}
		
		self.label8.removeFromParent()
		
		self.label9.fontColor = .white
		self.label9.fontSize = 25
		self.label9.position = CGPoint(x: 150, y: -20)
		self.label9Line2.fontColor = .white
		self.label9Line2.fontSize = 25
		self.label9Line2.position = CGPoint(x: 150, y: -50)
		self.label9.alpha = 0.0
		self.label9Line2.alpha = 0.0
		
		delay(2.1) {
		let fadeInAction = SKAction.fadeAlpha(to: 1.0, duration: 1.0)
		fadeInAction.timingMode = .easeIn
		self.spaceLabel.position = CGPoint(x: self.label9Line2.position.x, y: self.label9Line2.position.y - 30)
		self.spaceLabel.alpha = 0.0
		self.addChild(self.spaceLabel)
		self.addChild(self.label9)
		self.addChild(self.label9Line2)
		self.label9.run(fadeInAction)
		self.label9Line2.run(fadeInAction)
		self.spaceLabel.run(fadeInAction)
		}
		
		//ink explain label #1
		
	}
	
	func step8() {
		print("step 8 started")
		self.gameState = .part8
		
		let fadeOutAction = SKAction.fadeAlpha(to: 0.0, duration: 1.0)
		fadeInAction.timingMode = .easeIn
		
		self.label9.run(fadeOutAction)
		self.label9Line2.run(fadeOutAction)
		self.spaceLabel.run(fadeOutAction)
		/*self.spaceLabel.removeFromParent()
		goodLuck.fontColor = .white
		goodLuck.fontSize = 40
		goodLuck.fontName = "AvenirNext-Bold"
		goodLuck.position = CGPoint(x: 150, y: 25)
		addChild(goodLuck)*/
		//label9.text = "Press space to start the first level."
		//label9Line2.text = ""
		
		delay(1.0) {
			//add the other platforms
			let platform1 = Platform(rectOf: CGSize(width: 200, height: 50))
			platform1.setupProperties(pos: CGPoint(x: 300, y: 0))
			numberOfPlatforms += 1
			platform1.name = "platform\(numberOfPlatforms)"
			platform1.alpha = 0.0
			self.addChild(platform1)
			platform1.run(self.fadeInAction)
			
			let platform2 = Platform(rectOf: CGSize(width: 200, height: 50))
			platform2.setupProperties(pos: CGPoint(x: 150, y: 150))
			numberOfPlatforms += 1
			platform2.name = "platform\(numberOfPlatforms)"
			platform2.alpha = 0.0
			self.addChild(platform2)
			platform2.run(self.fadeInAction)
		}
		
		//print("numberOfPlatforms: \(numberOfPlatforms)")
		
		self.gameState = .playing
		
	}
	
	func step9() {
		/*
		print("step 9 started")
		self.label9Line2.removeFromParent()
		self.label9.removeFromParent()
		self.goodLuck.removeFromParent()
		
		currentLevel += 1
		
		if(currentLevel <= levelsArray.count) {
			//remove player instantly
			self.transistionAnimation()
			
			//unload level and load next level
			delay(3.5) {
				self.arrowKeyControlsEnabled = true
				if let child = self.childNode(withName: "player") as? SKShapeNode { child.removeFromParent() }
				self.unloadLevel()
				self.loadLevel(self.levelsArray[self.currentLevel - 1])
			}
		}*/
	}
	
	func loadLevel(_ level: Level) {
		
		print("LOADING LEVEL \(level.playerStartPosition)")
		
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
		
		if(currentLevel > 1) {
			//add player at its start position
			thePlayer.position = level.playerStartPosition
			thePlayer.fillColor = .black
			thePlayer.name = "player"
			self.addChild(thePlayer)
			
			//add the goal
			let goal: SKShapeNode = SKShapeNode(ellipseOf: CGSize(width: 50, height: 50))
			goal.position = CGPoint(x: level.goalPosition.x, y: level.goalPosition.y - 50)
			goal.physicsBody = SKPhysicsBody.init(circleOfRadius: 25)
			goal.fillColor = .black
			goal.physicsBody?.affectedByGravity = false
			goal.physicsBody?.isDynamic = false
			goal.physicsBody?.categoryBitMask = goalCategory
			goal.physicsBody?.contactTestBitMask = playerCategory
			goal.name = "goal"
			self.addChild(goal)
		}
		
		//add the floor
		let floor: SKShapeNode = SKShapeNode(rectOf: CGSize(width: self.scene?.frame.width ?? 400, height: 200))
		floor.fillColor = .white
		floor.position = CGPoint(x: 0, y: -400)
		floor.physicsBody = SKPhysicsBody(rectangleOf: floor.frame.size)
		floor.physicsBody?.affectedByGravity = false
		floor.physicsBody?.isDynamic = false
		floor.physicsBody?.restitution = 0.0
		floor.physicsBody?.categoryBitMask = groundCategory
		floor.physicsBody?.contactTestBitMask = playerCategory
		floor.name = "floor"
		self.addChild(floor)
		
		//print("FINISHED LOADING LEVEL")
		
		levelLoading = false
	}
	
	var levelLoading = false
	
	public func didBegin(_ contact: SKPhysicsContact) {
		let collision: UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
		
		if collision == playerCategory | groundCategory {
			touchingGround = true
			//print("collision between ground and player occured")
		}
		
		if collision == playerCategory | goalCategory && !levelLoading {
			//print("collision between goal and player occured")
			//TODO: maybe animate this?
			
			//remove player instantly
			if let child = self.childNode(withName: "player") as? SKShapeNode { child.removeFromParent() }
			
			currentLevel += 1
			
			if(currentLevel <= levelsArray.count) {
				//remove player instantly
				self.transistionAnimation()
				
				//unload level and load next level
				delay(3.5) {
					self.arrowKeyControlsEnabled = true
					if let child = self.childNode(withName: "player") as? SKShapeNode { child.removeFromParent() }
					self.unloadLevel()
					self.loadLevel(self.levelsArray[self.currentLevel - 1])
				}
			} else {
				print("WINNER!")
				self.winnerAnimation()
				blottingAllowed = false
				//WIN ANIMATION
			}
		}
	}
	
	let title = SKLabelNode(text: "LEVEL X")
	
	func transistionAnimation() {
		let shaderTest: InkBlob = InkBlob(rectOf: CGSize(width: 1200, height: 1200))
		shaderTest.setupProperties(pos: CGPoint(x:0,y:0), inBack: false)
		shaderTest.animate(amount: 5.5)
		addChild(shaderTest)
		
		title.text = "LEVEL \(currentLevel - 1)"
		title.fontSize = 50
		title.setScale(0.0)
		title.fontColor = .white
		title.zPosition = 2
		
		let zoom = SKAction.scale(to: 1.5, duration: 3.5)
		zoom.timingMode = .easeOut
		addChild(title)
		title.run(zoom)
		
		delay(5.5) { self.title.removeFromParent() }
	}
	
	func winnerAnimation() {
		let shaderTest: InkBlob = InkBlob(rectOf: CGSize(width: 1200, height: 1200))
		shaderTest.setupProperties(pos: CGPoint(x:0,y:0), inBack: false)
		shaderTest.animate(amount: 3.5)
		addChild(shaderTest)
		
		title.text = "YOU WON"
		title.fontSize = 50
		title.setScale(0.0)
		title.fontColor = .white
		title.zPosition = 2
		
		let scoreLabel = SKLabelNode(text: "Score \(1000 - (totalBlobsAdded * 10))")
		scoreLabel.fontSize = 25
		scoreLabel.position.y = -60
		scoreLabel.setScale(0.0)
		scoreLabel.fontColor = .white
		scoreLabel.zPosition = 2
		
		let zoom = SKAction.scale(to: 1.5, duration: 4.5)
		zoom.timingMode = .easeOut
		
		addChild(title)
		addChild(scoreLabel)
		scoreLabel.run(zoom)
		title.run(zoom)
		
		//delay(5.5) { self.title.removeFromParent() }
	}
	
	func unloadLevel() {
		
		//print("UNLOADING LEVEL")
		
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
		
		if let child = self.childNode(withName: "goal") as? SKShapeNode {
			child.removeFromParent()
		}
		
		//print("UNLOAD SUCCESSFUL")
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
		print("CLICK WAS ALLOWED")
		
		let touchedNodes = self.nodes(at: pos)
		print(touchedNodes)
		
		//make sure that extra blobs aren't created during the tutorial scene
		for i in 0..<touchedNodes.count {
			if touchedNodes[i].name == "clickIndicator" {
				let shaderTest: InkBlob = InkBlob(rectOf: CGSize(width: 1000, height: 1000))
				shaderTest.setupProperties(pos: pos, inBack: true)
				self.addChild(shaderTest)
				shaderTest.animate(amount: 2.2)
				
				switch gameState {
				case .part1:
					step2()
				case .part2:
					step3()
				case .part3:
					step4()
				case .part4:
					step5()
				case .part5:
					step6()
				case .part6:
					step7()
				default:
					break
				}
			}
		}
		
		//this is how blobs can be added after the tutorial scene
		if(gameState == .playing) {
			let shaderTest: InkBlob = InkBlob(rectOf: CGSize(width: 1000, height: 1000))
			shaderTest.setupProperties(pos: pos, inBack: true)
			self.addChild(shaderTest)
			shaderTest.animate(amount: 1.5)
			totalBlobsAdded += 1
			print("Blobs added: \(totalBlobsAdded)")
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
			guard arrowKeyControlsEnabled == true else { return }
			leftPressed = true
		case kVK_RightArrow:
			guard arrowKeyControlsEnabled == true else { return }
			rightPressed = true
		case kVK_UpArrow:
			guard arrowKeyControlsEnabled == true else { return }
			upPressed = true
		case kVK_Space:
			guard spaceInteractionEnabled == true else { return }
			spaceClicked = true
			switch gameState {
			case .part2:
				step3()
			case .part4:
				step5()
			case .part7:
				step8()
			case .part8:
				step9()
			default:
				break
			}
		default:
			break
		}
		
		//something onther than sapce
		if(gameState == .part5 && !spaceClicked) {
			step6()
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
		case kVK_Space:
			spaceClicked = false
		default:
			break
		}
	}
	
	public override func update(_ currentTime: TimeInterval) {
		// Called before each frame is rendered
		if leftPressed  { thePlayer.position.x -= 10 }
		if rightPressed { thePlayer.position.x += 10 }
		
		if upPressed && thePlayer.physicsBody?.velocity.dy == 0 {
			thePlayer.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 20))
			
		}
	
		/*if upPressed && touchingGround {
			thePlayer.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 20))
			touchingGround = false
		}*/
	}
}

//delays animations, this makes the code musch easier to read
public func delay(_ delay: Double, closure: @escaping ()->()) {
	let when = DispatchTime.now() + delay
	DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

class ClickIndicator: SKShapeNode {
	func setupProperties(pos: CGPoint) {
		//print("CALLED YES YSE")
		self.position = pos
		self.fillColor = .clear
		self.strokeColor = .black
		self.lineWidth = 0.5
		self.isAntialiased = false
		self.name = "clickIndicator"
		
		let action = SKAction.scale(to: 1.5, duration: 1.0)
		action.timingMode = .easeInEaseOut
		
		let action2 = SKAction.scale(to: 1.0, duration: 1.0)
		action.timingMode = .easeInEaseOut
		
		let sequence = SKAction.sequence([action, action2])
		let continuous = SKAction.repeatForever(sequence)
		self.run(continuous)
	}
}

import Foundation
import SpriteKit
import Carbon.HIToolbox

//keeps track of where we are in the game
enum GameState {
	case part1
	case part2
	case part3
	case part4
	case part5
	case part6
	case part7
	case part8
	case playing
}

public class GameScene: SKScene, SKPhysicsContactDelegate {
	var gameState: GameState = .part1
	var currentLevel = 1
	
	var keyInteractionEnabled   = false
	var arrowKeyControlsEnabled = false
	var mouseInteractionEnabled = false
	var spaceInteractionEnabled = false
	
	//custom SKActions
	let fadeInAction  = SKAction.fadeAlpha(to: 1.0, duration: 1.0)
	let fadeOutAction = SKAction.fadeAlpha(to: 0.0, duration: 1.0)
	
	//labels
	let titleLabel  = SKLabelNode(text: "INKBLOB")
	let spaceLabel  = SKLabelNode(text: "(Press space to proceed)")
	let goodLuck    = SKLabelNode(text: "Good Luck!")
	let label1      = SKLabelNode(text: "Oh.. I should probably tell you how to play. ")
	let label2      = SKLabelNode(text: "Click here to continue.")
	let label3      = SKLabelNode(text: "This is your player")
	let label4      = SKLabelNode(text: "Click here to continue.")
	let label5      = SKLabelNode(text: "This is your goal.")
	let label6      = SKLabelNode(text: "Use your arrow keys to move")
	let label7      = SKLabelNode(text: "But the more you use, the lower your score")
	let label8      = SKLabelNode(text: "Click here to continue")
	let label9      = SKLabelNode(text: "Clicking will cause ink to spill, revealing the map.")
	let label9Line2 = SKLabelNode(text: "But the more you use, the lower your score will be.")
	let label5Line2 = SKLabelNode(text: "Get here to advance to the next level.")
	
	//key press statuses
	var leftPressed = false
	var rightPressed = false
	var upPressed = false
	var downPressed = false
	var spacePressed = false
	
	//player node
	let thePlayer: SKShapeNode = SKShapeNode(rectOf: CGSize(width: 20, height: 20))
	//click indicator
	let clickIndicator = ClickIndicator(ellipseOf: CGSize(width: 50.0, height: 50.0))
	//levels info array
	let levelsArray = LevelData().array
	
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
		let xRange = SKRange(lowerLimit:((-1*size.width/2) + 50),upperLimit:((size.width/2) - 50))
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
		titleLabel.fontName = "AvenirNext-Heavy"
		titleLabel.fontColor = .white
		titleLabel.zPosition = 2
		addChild(titleLabel)
		delay(5.5) {
			self.titleLabel.removeFromParent()
			self.step1()
		}
	}
	
	//////////////////////
	////TUTORIAL STUFF////
	//////////////////////
	
	let whiteArrow = SKSpriteNode(texture: SKTexture(imageNamed: "whiteArrow"))
	let blackArrow = SKSpriteNode(texture: SKTexture(imageNamed: "blackArrow"))
	
	//start -> click to continue
	func step1() {
		self.gameState = .part1
		
		//intro label thing
		label1.fontColor = .black
		label1.fontSize = 45
		addChild(label1)
		
		delay(2.0) {
			self.label1.removeFromParent()
			self.label2.fontColor = .black
			self.label2.fontSize = 35
			self.label2.position = CGPoint(x: -275, y: -190)
			self.clickIndicator.setupProperties(pos: CGPoint(x: -300, y: -285))
			
			self.blackArrow.position = CGPoint(x: -300, y: -220)
			self.blackArrow.setScale(0.05)
			self.blackArrow.zRotation = 3.92699
			self.addChild(self.blackArrow)
			
			self.addChild(self.clickIndicator)
			self.addChild(self.label2)
			self.mouseInteractionEnabled = true
		}
	}
	
	//this is ur player -> wait until space pressed
	func step2() {
		self.gameState = .part2
		
		self.label2.removeFromParent()
		self.blackArrow.removeFromParent()
		
		self.label3.fontColor = .white
		self.label3.fontSize = 40
		self.label3.position = CGPoint(x: -300, y: -160)
		self.addChild(label3)
		
		self.spaceLabel.position = CGPoint(x: label3.position.x, y: label3.position.y - 30)
		self.addChild(spaceLabel)
		
		whiteArrow.position = CGPoint(x: -300, y: -220)
		whiteArrow.setScale(0.05)
		whiteArrow.zRotation = 3.92699
		self.addChild(whiteArrow)
		
		self.keyInteractionEnabled = true
		self.clickIndicator.removeFromParent()
		
		self.mouseInteractionEnabled = false
		self.spaceInteractionEnabled = false
		delay(1.8) {
			self.spaceInteractionEnabled = true
			self.mouseInteractionEnabled = true
		}
	}
	
	//space pressed -> click to continue
	func step3() {
		self.gameState = .part3
		
		self.label3.removeFromParent()
		self.spaceLabel.removeFromParent()
		self.whiteArrow.removeFromParent()
		
		self.label4.fontColor = .black
		self.label4.fontSize = 40
		self.label4.position = CGPoint(x: 290, y: 180)
		self.addChild(label4)
		
		self.clickIndicator.setupProperties(pos: CGPoint(x: 275, y: 300))
		self.addChild(self.clickIndicator)
		
		blackArrow.position = CGPoint(x: 275, y: 235)
		blackArrow.setScale(0.05)
		blackArrow.zRotation = 0.79
		self.addChild(blackArrow)
	}
	
	//this is your goal -> space to continue
	func step4() {
 		self.gameState = .part4
		
		self.label4.removeFromParent()
		self.blackArrow.removeFromParent()
		
		whiteArrow.position = CGPoint(x: 275, y: 235)
		whiteArrow.setScale(0.05)
		whiteArrow.zRotation = 0.79
		
		self.addChild(whiteArrow)
		
		self.label5.fontColor = .white
		self.label5.fontSize = 40
		self.label5.position = CGPoint(x: 275, y: 180)
		self.label5Line2.fontColor = .white
		self.label5Line2.fontSize = 30
		self.label5Line2.position = CGPoint(x: 275, y: 150)
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
	}
	
	func step5() {
		self.gameState = .part5
		
		self.label5.removeFromParent()
		self.label5Line2.removeFromParent()
		self.spaceLabel.removeFromParent()
		self.whiteArrow.removeFromParent()
		
		self.label6.fontColor = .white
		self.label6.fontSize = 28
		self.label6.position = CGPoint(x: -290, y: -200)
		self.addChild(self.label6)
		
		let arrowsNormal = SKSpriteNode(texture: SKTexture(imageNamed: "arrowsNormal"))
		arrowsNormal.setScale(0.5)
		arrowsNormal.position = CGPoint(x: -290, y: -100)
		self.addChild(arrowsNormal)
		
		
		let goRight = SKAction.moveTo(x: self.thePlayer.position.x + 100, duration: 1.0)
		let goLeft = SKAction.moveTo(x: self.thePlayer.position.x - 100, duration: 1.0)
		let goBack = SKAction.moveTo(x: self.thePlayer.position.x, duration: 1.0)
		let jump = SKAction.run {
			self.thePlayer.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 20))
		}
		
		//arrow animation
		arrowsNormal.texture = SKTexture(imageNamed: "arrowsRight")
		self.thePlayer.run(goRight)
		delay(1.0) {
			arrowsNormal.texture = SKTexture(imageNamed: "arrowsLeft")
			self.thePlayer.run(goLeft)
				delay(1.0) {
					arrowsNormal.texture = SKTexture(imageNamed: "arrowsRight")
					self.thePlayer.run(goBack)
					delay(1.0) {
						arrowsNormal.texture = SKTexture(imageNamed: "arrowsUp")
						self.thePlayer.run(jump)
						delay(1.0) {
							arrowsNormal.removeFromParent()
						}
					}
				}
			}
		
		delay(4.0) {
			self.step6()
			self.arrowKeyControlsEnabled = true
		}
		
	}
	
	func step6() {
		self.gameState = .part6
		
		self.label6.removeFromParent()
		
		blackArrow.position = CGPoint(x: 210, y: -130)
		blackArrow.setScale(0.05)
		blackArrow.zRotation = 0.79 + 0.785398
		self.addChild(blackArrow)
		
		self.label8.fontColor = .black
		self.label8.fontSize = 35
		self.label8.position = CGPoint(x: 280, y: -190)
		self.addChild(label8)
		
		self.clickIndicator.setupProperties(pos: CGPoint(x: 150, y: -90))
		self.addChild(self.clickIndicator)
	}
	
	func step7() {
		self.gameState = .part7
		
		self.clickIndicator.removeFromParent()
		self.blackArrow.removeFromParent()
		
		self.mouseInteractionEnabled = false
		self.spaceInteractionEnabled = false

		self.label8.removeFromParent()
		
		self.label9.fontColor = .white
		self.label9.fontSize = 25
		self.label9.position = CGPoint(x: 150, y: -20)
		self.label9Line2.fontColor = .white
		self.label9Line2.fontSize = 25
		self.label9Line2.position = CGPoint(x: 150, y: -60)
		self.label9.alpha = 0.0
		self.label9Line2.alpha = 0.0
		
		delay(2.1) {
		let fadeInAction = SKAction.fadeAlpha(to: 1.0, duration: 1.0)
		fadeInAction.timingMode = .easeIn
		self.spaceLabel.position = CGPoint(x: self.label9Line2.position.x, y: self.label9Line2.position.y - 40)
		self.spaceLabel.alpha = 0.0
		self.addChild(self.spaceLabel)
		self.addChild(self.label9)
		self.addChild(self.label9Line2)
		self.label9.run(fadeInAction)
		self.label9Line2.run(fadeInAction)
		self.spaceLabel.run(fadeInAction)
			delay(1.0) {
				self.spaceInteractionEnabled = true
				self.mouseInteractionEnabled = true
			}
		}
	}
	
	func step8() {
		self.gameState = .part8
		
		self.label9.run(fadeOutAction)
		self.label9Line2.run(fadeOutAction)
		self.spaceLabel.run(fadeOutAction)
		
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
		
		self.gameState = .playing
		
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
		
		levelLoading = false
	}
	
	var levelLoading = false
	
	public func didBegin(_ contact: SKPhysicsContact) {
		let collision: UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
		
		if collision == playerCategory | goalCategory && !levelLoading {
			//remove player instantly
			if let child = self.childNode(withName: "player") as? SKShapeNode { child.removeFromParent() }
			
			currentLevel += 1
			
			if(currentLevel <= levelsArray.count) {
				self.transistionAnimation()
				//unload level and load next level
				delay(3.5) {
					self.arrowKeyControlsEnabled = true
					if let child = self.childNode(withName: "player") as? SKShapeNode { child.removeFromParent() }
					self.unloadLevel()
					self.loadLevel(self.levelsArray[self.currentLevel - 1])
				}
			} else {
				//winning animation
				self.winnerAnimation()
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
		title.fontName = "AvenirNext-Heavy"
		title.setScale(0.0)
		title.fontColor = .white
		title.zPosition = 2
		
		let zoom = SKAction.scale(to: 1.5, duration: 3.5)
		zoom.timingMode = .easeOut
		addChild(title)
		title.run(zoom)
		delay(4.5) { self.title.removeFromParent() }
	}
	
	func winnerAnimation() {
		let shaderTest: InkBlob = InkBlob(rectOf: CGSize(width: 1200, height: 1200))
		shaderTest.setupProperties(pos: CGPoint(x:0,y:0), inBack: false)
		shaderTest.animate(amount: 4.5)
		addChild(shaderTest)
		
		title.text = "YOU WON"
		title.fontName = "AvenirNext-Heavy"
		title.fontSize = 50
		title.setScale(0.0)
		title.fontColor = .white
		title.zPosition = 2
		
		var score = 1000 - (totalBlobsAdded * 20)
		if(score < 0) {score = 0}
		
		let scoreLabel = SKLabelNode(text: "Score: \(score)")
		scoreLabel.fontSize = 25
		scoreLabel.fontName = "AvenirNext-Bold"
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
	}
	
	//removes all the nodes from the level
	func unloadLevel() {
		
		if let child = self.childNode(withName: "floor") as? SKShapeNode { child.removeFromParent() }
		if let child = self.childNode(withName: "goal") as? SKShapeNode { child.removeFromParent() }
		for i in 1...numberOfPlatforms {
			if let child = self.childNode(withName: "platform\(i)") as? SKShapeNode { child.removeFromParent() }
		}
		for i in 1...numberOfBlobs {
			if let child = self.childNode(withName: "normalBlob\(i)") as? SKShapeNode { child.removeFromParent() }
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
		guard mouseInteractionEnabled == true else { return }
		
		let touchedNodes = self.nodes(at: pos)
		
		//make sure that extra blobs aren't created during the tutorial scene
		for i in 0..<touchedNodes.count {
			if touchedNodes[i].name == "clickIndicator" {
				let shaderTest: InkBlob = InkBlob(rectOf: CGSize(width: 1000, height: 1000))
				shaderTest.setupProperties(pos: pos, inBack: true)
				shaderTest.animate(amount: 2.2)
				self.addChild(shaderTest)
				
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
			shaderTest.animate(amount: 1.5)
			self.addChild(shaderTest)
			totalBlobsAdded += 1
		}
	}
	
	public override func mouseDown(with event: NSEvent) {
		touchDown(atPoint: event.location(in: self))
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
				spacePressed = true
				switch gameState {
					case .part2:
						step3()
					case .part4:
						step5()
					case .part7:
						step8()
					default:
						break
				}
			default:
				break
		}
		
		//something onther than sapce pressed
		if(gameState == .part5 && !spacePressed) {
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
			spacePressed = false
		default:
			break
		}
	}
	
	public override func update(_ currentTime: TimeInterval) {
		// Called before each frame is rendered
		if leftPressed  { thePlayer.position.x -= 10 }
		if rightPressed { thePlayer.position.x += 10 }
		
		//jump (only if grounded)
		if upPressed && thePlayer.physicsBody?.velocity.dy == 0 {
			thePlayer.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 20))
		}
	}
}

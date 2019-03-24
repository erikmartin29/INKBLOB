import Foundation
import SpriteKit

/////////////////////////
////GLOBAL VARIABLES/////
/////////////////////////

//bitmask declarations
public let playerCategory: UInt32 = 0x1 << 0 //1
public let groundCategory: UInt32 = 0x1 << 1 //2
public let goalCategory:   UInt32 = 0x1 << 2 //4

//change debug mode to true to see things more clearly
public let debugMode = false

public var numberOfBlobs = 0
public var numberOfPlatforms = 0
public var totalBlobsAdded = 0

//delays animations, this makes the code musch easier to read
public func delay(_ delay: Double, closure: @escaping ()->()) {
	let when = DispatchTime.now() + delay
	DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

public class ClickIndicator: SKShapeNode {
	public func setupProperties(pos: CGPoint) {
		self.position = pos
		self.fillColor = .clear
		self.strokeColor = .black
		self.lineWidth = 1.0
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

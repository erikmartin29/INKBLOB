import Foundation
import SpriteKit

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
		self.physicsBody?.collisionBitMask = playerCategory
		self.physicsBody?.contactTestBitMask = playerCategory
	}
}

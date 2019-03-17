import Foundation
import SpriteKit

public class Player: SKShapeNode {
	
	public var runSpeed:CGFloat =  3
	
	public func makeJump() {
		
		let jumpUp:SKAction = SKAction.moveBy(x: 0, y: 40, duration: 1)
		let fallDown:SKAction = SKAction.moveBy(x: 0, y: -40, duration: 1)
		
		let seq:SKAction = SKAction.sequence( [ jumpUp, fallDown ])
		
		self.run(seq)
		
	}
}

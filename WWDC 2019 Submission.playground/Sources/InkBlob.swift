import Foundation
import SpriteKit

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

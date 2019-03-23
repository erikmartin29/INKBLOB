import Foundation

class Level {
	var platformFormation: [(Platform,CGPoint)]
	var playerStartPosition: CGPoint
	
	init(formation: [(Platform,CGPoint)], playerStartPos: CGPoint) {
		platformFormation = formation
		playerStartPosition = playerStartPos
	}
}

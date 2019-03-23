import Foundation

class Level {
	var platformFormation: [(Platform,CGPoint)]
	var playerStartPosition: CGPoint
	var goalPosition: CGPoint
	
	init(formation: [(Platform,CGPoint)], playerStartPos: CGPoint, goalPos: CGPoint) {
		platformFormation = formation
		playerStartPosition = playerStartPos
		goalPosition = goalPos
	}
}

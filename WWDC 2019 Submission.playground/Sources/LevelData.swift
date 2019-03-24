import Foundation


public class LevelData {
//make it so that I can use those varibles ^^^
	let array: [Level] = [
		
			/*Tutorial*/
			Level(formation: [(Platform(rectOf: CGSize(width: 200, height: 50)),CGPoint(x: 150, y: -200))],  playerStartPos: CGPoint(x: -300, y: 50), goalPos: CGPoint(x: 275, y: 300)),
			
			/*Level 1:*/
			Level(formation:
				
			[   (Platform(rectOf: CGSize(width: 180, height: 60)),CGPoint(x: -30, y:  -150)),
			    (Platform(rectOf: CGSize(width: 120, height: 60)),CGPoint(x: 270, y: -30)),
				(Platform(rectOf: CGSize(width: 180, height: 60)),CGPoint(x: 30, y: 150)),
				(Platform(rectOf: CGSize(width: 180, height: 60)),CGPoint(x: 380, y: 280)),
			],
				  
				playerStartPos: CGPoint(x: 50, y: 50),
				goalPos: CGPoint(x: 440, y: 410)),
			
			/////////////////////////////////*Level 2:*///////////////////////////////////////////
			Level(formation:
				
				[
				   (Platform(rectOf: CGSize(width: 120, height: 60)),CGPoint(x: -540, y: -90)),
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
			
			////////////////////*Level 3*///////////////////
			Level(formation:
				
				[
				   (Platform(rectOf: CGSize(width: 360, height: 60)),CGPoint(x: -420, y: 330)),
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
				  goalPos: CGPoint(x: 330, y: -225)),
			
			////////////////////*Level 4*///////////////////
			Level(formation:
				
				[
					(Platform(rectOf: CGSize(width: 360, height: 60)),CGPoint(x: -420, y: 330)),
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
				  goalPos: CGPoint(x: 330, y: -225)),
			
			
	]
}


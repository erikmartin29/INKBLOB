import Foundation


public class LevelData {
	let array: [Level] = [
		
			/*Tutorial*/
			Level(formation:
				
				[
					(Platform(rectOf: CGSize(width: 200, height: 50)),CGPoint(x: 150, y: -200))
				],
				  
				playerStartPos: CGPoint(x: -300, y: 50),
				goalPos: CGPoint(x: 275, y: 300)),
			
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
				(Platform(rectOf: CGSize(width:240 , height:60  )),CGPoint(x:-480 ,y:150  )),
				(Platform(rectOf: CGSize(width:60  , height:60  )),CGPoint(x:-390 ,y:210  )),
				(Platform(rectOf: CGSize(width:300 , height:120 )),CGPoint(x:-210 ,y:360  )),
				(Platform(rectOf: CGSize(width:240 , height:120 )),CGPoint(x:-180 ,y:180  )),
				(Platform(rectOf: CGSize(width:120 , height:60  )),CGPoint(x:-120 ,y:270  )),
				(Platform(rectOf: CGSize(width:300 , height:60  )),CGPoint(x:-30  ,y:90   )),
				(Platform(rectOf: CGSize(width:240 , height:180 )),CGPoint(x:-510 ,y:-30  )),
				(Platform(rectOf: CGSize(width:60  , height:60  )),CGPoint(x:-330 ,y:30   )),
				(Platform(rectOf: CGSize(width:60  , height:120 )),CGPoint(x:-90  ,y:0    )),
				(Platform(rectOf: CGSize(width:60  , height:120 )),CGPoint(x:-90  ,y:-240 )),
				(Platform(rectOf: CGSize(width:180 , height:60  )),CGPoint(x:-210 ,y:-90  )),
				(Platform(rectOf: CGSize(width:240 , height:60  )),CGPoint(x:120  ,y:-150 )),
				(Platform(rectOf: CGSize(width:300 , height:120 )),CGPoint(x:270  ,y:-240 )),
				(Platform(rectOf: CGSize(width:420 , height:120 )),CGPoint(x:390  ,y:-30  )),
				(Platform(rectOf: CGSize(width:600 , height:60  )),CGPoint(x:300  ,y:270  )),
				(Platform(rectOf: CGSize(width:360 , height:60  )),CGPoint(x:420  ,y:330  )),
				(Platform(rectOf: CGSize(width:120 , height:60  )),CGPoint(x:540  ,y:390  )),
			],
			  
			  playerStartPos: CGPoint(x: -510, y: 300),
			  goalPos: CGPoint(x: 450, y: 430)),
			
			////////////////////*Level 3*///////////////////
			Level(formation:
				
				[
				   (Platform(rectOf: CGSize(width:360 , height:60)),CGPoint(x: -420 ,y:330)),
				   (Platform(rectOf: CGSize(width:120 , height:60)),CGPoint(x: -240 ,y:270)),
				   (Platform(rectOf: CGSize(width:120 , height:60)),CGPoint(x: -60  ,y:270)),
				   (Platform(rectOf: CGSize(width:180 , height:60)),CGPoint(x: -150 ,y:150)),
				   (Platform(rectOf: CGSize(width:600 , height:60)),CGPoint(x:  -300,y:90)),
				   (Platform(rectOf: CGSize(width:180 , height:180)),CGPoint(x:  150 ,y:90)),
				   (Platform(rectOf: CGSize(width:180 , height:60)),CGPoint(x:  330 ,y:150)),
				   (Platform(rectOf: CGSize(width:60  , height:60)),CGPoint(x:  390 ,y:210)),
				   (Platform(rectOf: CGSize(width:120 , height:240)),CGPoint(x:  540 ,y:120)),
				   (Platform(rectOf: CGSize(width:60  , height:120)),CGPoint(x:  450 ,y:60)),
				   (Platform(rectOf: CGSize(width:180 , height:60)),CGPoint(x:  -30 ,y:-210)),
				   (Platform(rectOf: CGSize(width:240 , height:60)),CGPoint(x:  -60 ,y:-30)),
				   (Platform(rectOf: CGSize(width:120 , height:60)),CGPoint(x:  120 ,y:-150)),
				   (Platform(rectOf: CGSize(width:60  , height:60)),CGPoint(x:  270 ,y:-270)),
				   (Platform(rectOf: CGSize(width:180 , height:60)),CGPoint(x:  390 ,y:-210)),
				   (Platform(rectOf: CGSize(width:120 , height:60)),CGPoint(x:  480 ,y:-180)),
				   (Platform(rectOf: CGSize(width:180 , height:60)),CGPoint(x:  330 ,y:-90 )),
				],
				  
				  playerStartPos: CGPoint(x: -510, y: 400),
				  goalPos: CGPoint(x: 330, y: -225)),
			
			////////////////////*Level 4*///////////////////
			Level(formation:
				
				[
					(Platform(rectOf: CGSize(width:60 , height:60 )),CGPoint(x:-450 ,y:150  )),
					(Platform(rectOf: CGSize(width:60 , height:60 )),CGPoint(x:-510 ,y:-30  )),
					(Platform(rectOf: CGSize(width:60 , height:60 )),CGPoint(x:-450 ,y:-150 )),
					(Platform(rectOf: CGSize(width:60 , height:420)),CGPoint(x:-390 ,y:-30  )),
					(Platform(rectOf: CGSize(width:120 ,height:60 )),CGPoint(x:-240 ,y:-230 )),
					(Platform(rectOf: CGSize(width:180 ,height:60 )),CGPoint(x:-150 ,y:150  )),
					(Platform(rectOf: CGSize(width:180 ,height:120)),CGPoint(x:30   ,y:0    )),
					(Platform(rectOf: CGSize(width:60 , height:300)),CGPoint(x:90   ,y: 270 )),
					(Platform(rectOf: CGSize(width:60 , height:240 )),CGPoint(x:210 ,y:60 )),
					(Platform(rectOf: CGSize(width:120 , height:60 )),CGPoint(x:300 ,y:-30 )),
				],
				  
				  playerStartPos: CGPoint(x: -30, y: -270),
				  goalPos: CGPoint(x: 510, y: 90)),
			
			
	]
}


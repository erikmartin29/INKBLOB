/*:
# *INKBLOB*
  Welcome to my playground! It's a platformer game with a twist.


## How to Play:
- Use your arrow keys to control the player
- Navigate your player to the goal in order to advance to the next level.
- Click anywhere to creat an ink blob.

The goal of the game is to complete all of the levels while using as little ink as you can.

The less ink you use, the higher your score will be; so try to only use it when you're in a pinch.

## **Have Fun!** 👍
*/
import PlaygroundSupport
import SpriteKit
import Carbon.HIToolbox

let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 640, height: 480))
if let scene = GameScene(fileNamed: "GameScene") {
    scene.scaleMode = .aspectFill
    sceneView.presentScene(scene)
}
PlaygroundSupport.PlaygroundPage.current.liveView = sceneView

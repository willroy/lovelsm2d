Lovelsm2d is a project designed to allow for node based game making with event scripting. It is built on top of Love2d.

See documentation under the wiki tab on the github repo @ https://github.com/willroy/lovelsm2d/wiki

Features:

- Defining game nodes in json
- Giving game nodes properties ( such as x,y,w,h, image/animation, interactable, handle, grouphandle )
- Event listeners
	- e.g "click exampleNode" => triggers on clicking node with handle "exampleNode"
- Task scripting
	- e.g "print test" => test
	- e.g "unLoadNodeGroup nodeExamples" => unloads nodes with group handle "nodeExamples" from game
	- e.g "loadNode exampleNode" => loads node with handle "exampleNode" into game
	- e.g "globals exampleVariable exampleValue" => sets a game variable to a value
- Dialouge handling (by setting a node as "type" = dialouge and setting a "dialougePath")
- Keybind mapping (defined in keybinds.json)
- Debug mode (shows a debug on hovering over an node, with useful info such hovered/clicked nodes, fps, mouse x y)

Roadmap:

- ControllerNode (Node that allows for input to move a node around)
- CollisonNode (Node that acts as a collision object for a controllerNode)
- Target transform variable on nodes with support for instant or linear transition to that target transform
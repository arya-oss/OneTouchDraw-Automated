# One Touch Draw Game Automation


### Game Description
This is a Sigle Player Game.

Playstore Link: [One Touch Draw](https://play.google.com/store/apps/details?id=com.gtcsoft.game.epath1&hl=en)

![Splash](/Images/onetouch_play.png) 
![Image](/Images/onetouch.png)

#### Difficulty level
Moderate

#### Overview

One Touch Drawing Master is a simple and very addictive brain puzzle game.
You have to draw all lines without repeat.

#### Requirements
- Computer with MATLAB, Python, ADB Tool and required drivers set up.
- An Android Device with the One Touch Draw game installed on it. (Turn on the Developer options for better visualization)
- USB data transfer cable.

#### Block Diagram

![BlockDiagram](/Images/BlockDiagram.png)

#### Tutorial
##### Step 1: Using ADB Tool to capture screenshot
The following command instantaneously takes the screenshot of the connected device and stores it in the SD card following the specified path.
  
```
	system(' adb shell screencap -p /sdcard/one.png ');
```

The following command pulls it from the SD card of the android device into the working system following the path specified

```
system(' adb pull /sdcard/one.png ');
```
  
The pulled image is stored in the form of a matrix of pixel values by the Matlab.
```
	img = imread('one.png');
```
                
                
#### Step 2: Image processing

Once the screenshot is obtained, Each Node and Edges bewtween nodes are determined.
For Node marking
```
	[centres,radii] = imfindcircles(im,[18 23], 'ObjectPolarity', 'bright', 'Sensitivity', 0.97);
```
For Edge Detection
```
	BW = red >= 186 & red <= 200 & green >= 186 & green <= 200 & blue >= 186 & blue <= 200;
	[H,T,R] = hough(BW);
	P = houghpeaks(H,35,'threshold',ceil(0.1*max(H(:))));
	lines = houghlines(BW,T,R,P);
```
Now with Nodes and Edges Adjaceny Matrix is Generated for Graph Representation.
#### Step 3: Algorithm

Adjacency matrix is given command line input to Python Code written, which solves and returns
solved path using Euler Path algorithm for undirected Graph.

```
	1. Start with an empty stack and an empty circuit (eulerian path).
		- If all vertices have even degree - choose any of them.
		- If there are exactly 2 vertices having an odd degree - choose one of them.
		- Otherwise no euler circuit or path exists.
	2. If current vertex has no neighbors - add it to circuit, remove the last vertex from the stack and set it as the current one. 
	Otherwise (in case it has neighbors) - add the vertex to the stack, take any of its neighbors, remove the edge between selected neighbor and that vertex, and set that neighbor as the current vertex.
	3. Repeat step 2 until the current vertex has no more neighbors and the stack is empty.

```

##### Step 4: Using ADB Tool to simulate touch

Nodes centres are stored in centres. Now according to path two consecutive point is taken and swipe touch is simulated.

```matlab
	% out is vector of path,returned path indexing from zero but centres indexed from 1 so added 1.
	for i=1:length(out)-1
    	j = str2num(cell2mat(out(i)))+1;
    	k = str2num(cell2mat(out(i+1)))+1;
    	system(['adb shell input swipe ' num2str(centres(j,1)) ' ' num2str(centres(j,2)) ' ' num2str(centres(k,1)) ' ' num2str(centres(k,2)) ' 500']);
	end
```
#### Testing

After connecting your phone to laptop with satisfied envrionment.
check phone is connected or not, with command

```bash
	adb devices
``` 
if device is connected and not authorized it will show in output otherwise it will show device-id and device.

###### Now start game and click play and run matlab file onet.m

The Game was tested on 1280x720 android device ( Moto G3 ).
This will work for upto Level 40. After this level, graph comes with some edge which can be
traveled more than once. so that part is not implemented.

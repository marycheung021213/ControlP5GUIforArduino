# ControlP5GUIforArduino
I mainly use controlp5 lib in Processing to create a GUI for Arduino.

![processing_controller 2022_7_22 22_45_16](https://user-images.githubusercontent.com/106864918/180464494-e669d8f6-db8a-492c-a875-b7bb2a439544.png)

I have posted an interpretation video in Bilibili: https://www.bilibili.com/video/BV1yg411Z7ZT?share_source=copy_web&vd_source=b1841fff6f9f05dc7f41ca12db5f1de6

## Initialize
If you want to refer to my code, please make sure you have downloaded the necessary libs, and also have a /data folder, containing music files and img.jpg(which is a rainbow gradient picture in the size of (72,36))

## Communication between Arduino and Processing
I use serial communication to achieve. To make all tens of controllers can communicate with Arduino, I create a very simple protocol. Every message transmitted looks like this "XXXX123\n". To show which controller sends this message, it starts with a four-char-long code, and to show the end of every message, it ends with "\n". In the middle of every message, there are numbers with actual meaning, such as the speed, the degree, or the RGB color.

There are five functions in all, which are as follows.

## Five Functions
### Music File Load & Change
Music File can be searched in this GUI, and be uploaded timely. You should put your music file in /data in advance, and you can change the default music file in setup().

### ControlP5 Controllers
I use controlp5 lib to create several controllers to control servo and led. Most of the controllers are set in function controller() run in setup().

### Data Table Save & Upload
All the controller's data can be downloaded in data_table.csv if you push the button "SAVE". Also, you can create your .csv data table and upload it by saving it in \data folder and typing its name in the "DATA TABLE" textfield.

### Timeline
There is a timeline divided into three districts. The third district shows the music file and its length, the second district can set servo, and the first district can set led. You can set its length by clicking twice in the corresponding area, change its genre by left-clicking the label, and delete it by right-clicking the label.

### Test Mode & Play Mode
As you can see there is a mode button in the top left corner. Only in Play Mode can the music be played, paused and reset. Also, in Test MAode, all controllers can control their corresponding components in Arduino immediately. But in Play Mode, you wouldn't see actual changes implemented in Arduino components, which means you can change the factor even if the music is played.

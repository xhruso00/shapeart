shapeart
========


WWDC '13 Sample app - Bringing iOS app to OS X (216)
- this source code was not published by Apple
- recreated according to the video
- video contained a bug during version browsing (adding subviews to
  existing document view; should be cleared)
  
 
 ![](https://raw.githubusercontent.com/xhruso00/shapeart/master/appPreview.png)

 Key facts learned : 
  - SEL windowControllerDidLoadNib is not called after SEL
    readFromData:ofType:error:, after exit from version browser
  - inside version browser new windows are created
  - after exit from version browser  the original document window will
      hold the model (KEY FACT). readFromData:ofType:error: is called
  - opening document readFromData:ofType:error: is called the IBOUtles
        still doesn't exists (they exist only in version browsing)
  - it is important to link delegates inSEL
          revertToContentsOfURL:ofType:error:

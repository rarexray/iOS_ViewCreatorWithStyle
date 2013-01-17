iOS_ViewCreatorWithStyle
========================
This is a tool, that you can create views and set properties with a style sheet(CSS).
这个小工具是用来简化创建view的流程，可以使用样式表设定一个view的样式。

Example:
 <default.css>
UIView{background-color:black;width:240px; height:32px;}
.testStyle{border-width:1px;border-color:white;border-radius:5px;}

----
Code:
UIView *widget = [UIView viewWithSelector:@".testStyle"];

The widget just created, will auto setup with the style in "UIView" and ".testStyle"
返回的widget会使用"UIView"以及"testStyle"各自设定的样式。

The view will have balck background color, width 240px, height 32px, and a 1 pixel width round corner
widget会具有黑色背景，宽240像素，高32像素，有一个1像素宽的圆角。

Very easy, huh?
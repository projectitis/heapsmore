package phx.pixel;

import h2d.Font;
import h2d.Object;
import h2d.Text;

class SpeechBubble extends Object{

    var font : Font = null;
    var text : Text = null;
    
    var bgColor : Int = 0x80FFFFFF; // 50% white
    var borderColor : Int = 0xFFFFFFFF; // 100% white
    var textColor : Int = 0x00000000; // 100% black
    
    public function SpeechBubble(){
        
    }
}

package com.youcab.foodie_merchant

import io.flutter.embedding.android.FlutterActivity
import android.view.KeyEvent
import android.widget.Toast

class MainActivity: FlutterActivity() {
    override fun onKeyDown(keyCode: Int, event: KeyEvent?): Boolean {
        if(keyCode == KeyEvent.KEYCODE_VOLUME_DOWN
                || keyCode == KeyEvent.KEYCODE_VOLUME_UP ){
            return true
        }
        return super.onKeyDown(keyCode, event);
    }
}

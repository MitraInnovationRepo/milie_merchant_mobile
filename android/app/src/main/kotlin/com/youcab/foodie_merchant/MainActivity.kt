package com.youcab.foodie_merchant

import io.flutter.embedding.android.FlutterActivity
import android.view.KeyEvent

class MainActivity: FlutterActivity() {
    override fun onKeyDown(keyCode: Int, event: KeyEvent?): Boolean {
        return true
    }
}

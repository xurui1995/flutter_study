package com.xur.flutterstudy;

import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    Log.d("MainActivity","onCreate");

    new MethodChannel(getFlutterView(), "xur.flutter.io/first_flutter").setMethodCallHandler(new MethodChannel.MethodCallHandler() {
        @Override
        public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
            if (methodCall.method.equals("getPhoneMsg")) {
                Log.d("MainActivity","getPhoneMsg");
                result.success(Build.MODEL);
            } else if(methodCall.method.equals("startSecondActivity")) {
                Log.d("MainActivity","startSecondActivity");
                startSecondActivity();
            }else {
                result.notImplemented();
            }
        }
    });
  }

  private void startSecondActivity(){
      Intent i = new Intent(MainActivity.this, SecondActivity.class);
      startActivity(i);
  }
}

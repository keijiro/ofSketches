#pragma once

#include "ofMain.h"
#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"

class testApp : public ofxiPhoneApp {
public:
  void setup();
  void draw();
  void audioReceived(float* pInput, int bufferSize, int nChannels);
  static const int kAudioBufferSize = 512;
  float audioBuffer[kAudioBufferSize];
  float audioRMS;
  ofTrueTypeFont textFont;
};

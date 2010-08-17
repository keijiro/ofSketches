#include "testApp.h"

void testApp::setup() {	
  ofxiPhoneSetOrientation(OFXIPHONE_ORIENTATION_LANDSCAPE_RIGHT);

  ofBackground(64, 64, 64);
  ofSetFrameRate(30);
  
  ofSoundStreamSetup(0, 1, this, 44100, kAudioBufferSize, 4);
  for (int i = 0; i < kAudioBufferSize; i++) audioBuffer[i] = 0;
  audioRMS = 0;

  const int kFontSize = ofGetScreenHeight() / 5;
  textFont.loadFont("cooperBlack.ttf", kFontSize, true, true, true);
}

void testApp::draw() {
  const int kScreenWidth = ofGetScreenWidth();
  const int kScreenHeight = ofGetScreenHeight();
  const int kLineHeight = textFont.getLineHeight();
  string text = "Speak!";
  
  ofSetColor(90, 90, 90);
  for (int i = 0; i < kAudioBufferSize; ++i) {
    float x = float(i) * kScreenWidth / kAudioBufferSize;
    ofLine(x, kScreenHeight / 2, x, kScreenHeight / 2 * (1.0 - audioBuffer[i]));
  }
  
  ofSetColor(255, 255, 255);
  ofNoFill();
  ofTranslate((kScreenWidth - textFont.stringWidth(text)) / 2,
              (kScreenHeight + 0.7f * kLineHeight) / 2, 0);
  
  for (int pos = 0; pos < text.size(); ++pos) {
    ofPushMatrix();
    ofTranslate(textFont.stringWidth(text.substr(0, pos)), 0, 0);
    
    ofTTFCharacter ttfChar;
    ttfChar = textFont.getCharacterAsPoints(text.at(pos));

    ofBeginShape();
    for (int cidx = 0; cidx < ttfChar.contours.size(); ++cidx) {
      if (cidx) ofNextContour(true);
      for (int pidx = 0; pidx < ttfChar.contours[cidx].pts.size(); ++pidx) {
        const ofPoint& pt = ttfChar.contours[cidx].pts[pidx];
        ofVertex(pt.x + ofRandomf() * audioRMS * kLineHeight / 2,
                 pt.y + ofRandomf() * audioRMS * kLineHeight / 2);
      }
    }
    ofEndShape(true);
    ofPopMatrix();
  }
}

void testApp::audioReceived(float* pInput, int bufferSize, int nChannels) {
  assert(kAudioBufferSize == bufferSize);
  float add = 0;
  for (int i = 0; i < bufferSize; ++i){
    audioBuffer[i] = pInput[i];
    add += pInput[i] * pInput[i];
  }
  audioRMS = sqrt(add / bufferSize);
}


import ddf.minim.*;
import ddf.minim.analysis.*;
import controlP5.*;

Minim minim;
AudioPlayer player;
AudioInput input;
AudioPlayer song;
FFT fft;
BeatDetect beat_detect;

ControlP5 cp5;

int T = 0;
float DT = 0.0f;

float T_KICK;
float T_KICK_DECAY = 0.5f;
float T_SNARE;
float T_SNARE_DECAY = 0.75f;
float T_HAT;
float T_HAT_DECAY = 0.95f;
float T_BEAT;
float T_BEAT_DECAY = 0.3f;

float T_MS_FACTOR = 1;

void t_updt() {
  int ms = millis();
  int dms = ms - T;
  
  DT = (float(dms) / 1000) / T_MS_FACTOR;
  T += dms;
  
  T_KICK *= T_KICK_DECAY;
  if (beat_detect.isKick()) {
    T_KICK = 1.0f;
    on_beat(0);
  }
  
  T_SNARE *= T_SNARE_DECAY;
  if (beat_detect.isSnare()) {
    T_SNARE = 1.0f;
    on_beat(1);
  }
  
  T_HAT *= T_HAT_DECAY;
  if (beat_detect.isHat()) {
    T_HAT = 1.0f;
    on_beat(2);
  }
}

void on_beat(int b) {
  for (ILayer l : layers) {
    l.on_beat(b);
  }
}

void t_debug_menu() {
  cp5.addSlider("t_ms_factor").setRange(1f,5f).setValue(T_MS_FACTOR);
}

void t_ms_factor(float t) {
  T_MS_FACTOR = t;
}

// zzz
interface IRandomizable {
  void rng();
  IRandomizable[] get_rng_children();
}

void setup() {
  size(1280, 768, P3D);
  
  cp5 = new ControlP5(this);
  t_debug_menu();
  
  minim = new Minim(this);
  input = minim.getLineIn(Minim.STEREO, 2048);
  song = minim.loadFile("set-kika-master-2h.mp3", 2048);
  song.play();
  
  //fft = new FFT(input.bufferSize(), input.sampleRate());
  beat_detect = new BeatDetect(song.bufferSize(), song.sampleRate());
  beat_detect.detectMode(BeatDetect.FREQ_ENERGY);
  beat_detect.setSensitivity(2);
  
  G_ADD_LAYER(new SlideshowBackground());
  G_ADD_LAYER(new ChromaticAberrationFilter());
  G_ADD_LAYER(new PolyTunnel());
}

void keyPressed() {
  if (key == 'd') {
    if (cp5.isVisible()) cp5.hide(); else cp5.show();
  }
}

void draw() {
  t_updt();
  
  beat_detect.detect(song.mix);
  
  background(0);
  for (ILayer l : layers) {
    pushStyle();
    l.style();
    l.draw();
    popStyle();
  }
  
    text(DT, 100, 100);
    text(T, 100, 200);
}

void generate() {
  
}
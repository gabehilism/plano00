
abstract class ILayer {
  
  ILayer() {
    randomize();
    create_debug_menu(cp5);
  }
  
  void style() {}
  /*
    kick 0
    snare 1
    hat 2
  */
  void on_beat(int b) {}
  void create_debug_menu(ControlP5 cp5) {}
  void debug(boolean show) {
    if (show) {
      cp5.show();
    }
    else {
      cp5.hide();
    }
  }
  abstract void draw();
  abstract void randomize();
  
  String get_tab_name() {
    return "layer " + layers.size();
  }
}

ArrayList<ILayer> layers = new ArrayList<ILayer>();

void G_ADD_LAYER(ILayer l) {
  layers.add(l);
}

void G_REMOVE_LAYER(ILayer l) {
  cp5.getTab(l.get_tab_name()).remove();
  layers.remove(l);
}
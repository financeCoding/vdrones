part of vdrones;

void showScreen(id){
  document.queryAll('.screen_info').forEach((screen) {
    //screen.style.opacity = (screen.id === id)?1 : 0;
    screen.style.display = (screen.id == id) ?'block' : 'none';
  });
}

void setupLayer2D(Evt evt, Element container){

  evt.GameStates.score.add((v){
    container.query("#score").text = v.toString();
  });
  evt.GameStates.progressMax.add((v){
    container.query("#gameload").attributes["max"] = v.toString();
  });
  evt.GameStates.progressCurrent.add((v){
    container.query("#gameload").attributes["value"] = v.toString();
  });
  evt.GameStates.countdown.add((v){
    int totalSec = v.toInt();
    int minutes = totalSec ~/ 60;
    int seconds = totalSec % 60;
    var txt = "${minutes < 10 ? "0" : ""}${minutes}:${seconds < 10 ? "0" : ""}${seconds}";
    container.query("#countdown").text = txt;
  });
  evt.GameStates.energy.add((v){
    var bar = container.query("#energyBar");
    var max = evt.GameStates.energyMax.v;
    if (bar != null && max > 0) {
      int r = (v * 449) ~/ max;
      bar.attributes["width"] = r.toString();
    }
  });


  evt.GameInit.add((areaPath){
    showScreen('screenInit');
  });
  evt.GameInitialized.add(() {
    container.query("#msgConnecting").style.opacity = "0";
    container.query("#btnStart")
    ..attributes.remove("disabled")
    ..onClick.listen((e){
      print("Click");
      showScreen('none');
      evt.GameStart.dispatch(null);
    });
  });
  evt.HudSpawn.add((objId, domElem) {
    if (domElem != null) {
      document.query("#hud").nodes.add(domElem);
      container.query("#score").text = evt.GameStates.score.v.toString();
    }
  });
  evt.Error.add((msg, exc){
    window.console.error(msg);
    window.console.error(exc);
    //_viewModel.alert = msg;
    //_viewModel.shouldShowAlert(true);
  });
}


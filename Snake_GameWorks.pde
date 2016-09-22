int spielfeld_groesse = 30;
int spielfeld_skalierung = 20;
int maximale_spieler_groesse = 100;
int positions_groesse = 2;
int leeres_feld_groesse = 5;
int spieler_feld_groesse = 20;
int beute_feld_groesse = 20;
float maximale_tick_zeit = 0.1;

int [][] spielfeld;
int [][] spieler_position;
int [] beute_position;

int spieler_groesse;
String richtung;
String letzte_richtung;
float tick_zeit = 0;



void setup(){
  size(600,600);
  rectMode(CENTER);
  spielfeld = new int[spielfeld_groesse][spielfeld_groesse];
  spieler_position = new int[maximale_spieler_groesse][positions_groesse];
  beute_position = new int[positions_groesse];
  resetGame();
}

void draw(){
  background(0, 0, 0);
  
  tick_zeit = tick_zeit + 1/frameRate;
  if(tick_zeit > maximale_tick_zeit){
    bewegeSpieler();
    testeSpielerKollision();
    setzeSpielfeldZurueck();
    zeichneSpielfigurenAufSpielfeld();
    tick_zeit = 0;
  }
  
  zeichneSpielfeld();
  setzeSpielerEingabe();
}

void setzeSpielfeldZurueck(){
  for(int i = 0; i < spielfeld_groesse; i++){
   for(int j = 0; j < spielfeld_groesse; j++){
     spielfeld[i][j] = 0;
    } 
  }
}

void bewegeSpieler(){
  int old_position_x = spieler_position[0][0];
  int old_position_y = spieler_position[0][1];
  
  if(richtung.equals("up")){
    spieler_position[0][1] = spieler_position[0][1] - 1;
    letzte_richtung = "up";
  }else if(richtung.equals("left")){
    spieler_position[0][0] = spieler_position[0][0] - 1;
    letzte_richtung = "left";
  }else if(richtung.equals("down")){
    spieler_position[0][1] = spieler_position[0][1] + 1;
    letzte_richtung = "down";
  }else if(richtung.equals("right")){
    spieler_position[0][0] = spieler_position[0][0] + 1;
    letzte_richtung = "right";
  }
  
  //schiebe alle anderen Punkte nach
  for(int p = 1; p < spieler_groesse; p++){
   int temp_x = spieler_position[p][0]; 
   int temp_y = spieler_position[p][1];
   
   spieler_position[p][0] = old_position_x;
   spieler_position[p][1] = old_position_y;
   
   old_position_x = temp_x;
   old_position_y = temp_y;
  }
  
  if(spieler_position[0][0] < 1 || spieler_position[0][0] > (spielfeld_groesse - 1) ||
     spieler_position[0][1] < 1 || spieler_position[0][1] > (spielfeld_groesse - 1)){
       resetGame(); 
     }
  
  for(int p = 1; p < spieler_groesse; p++){
   if(spieler_position[0][0] == spieler_position[p][0] && spieler_position[0][1] == spieler_position[p][1]){
    resetGame(); 
   }
  }
  
}

void zeichneSpielfigurenAufSpielfeld(){
  //zeichne Spieler
  for(int p = 0; p < maximale_spieler_groesse; p++){
    if(spieler_position[p][0] != 0 && spieler_position[p][1] != 0)
    spielfeld[spieler_position[p][0]][spieler_position[p][1]] = 1;
    }  
  
  //setze Beute
  spielfeld[beute_position[0]][beute_position[1]] = 2;
}

void zeichneSpielfeld(){
  for(int i = 1; i < spielfeld_groesse; i++){
   for(int j = 1; j < spielfeld_groesse; j++){
     if(spielfeld[i][j] == 0){
      ellipse(spielfeld_skalierung * i, spielfeld_skalierung * j, leeres_feld_groesse, leeres_feld_groesse); 
     }
     if(spielfeld[i][j] == 1){
      ellipse(spielfeld_skalierung * i, spielfeld_skalierung * j, spieler_feld_groesse, spieler_feld_groesse); 
     }
     if(spielfeld[i][j] == 2){
      rect(spielfeld_skalierung * i, spielfeld_skalierung * j, beute_feld_groesse, beute_feld_groesse); 
     }
    } 
  }
}

void setzeZufaelligBeutePosition(){
  beute_position[0] = floor(random(1, spielfeld_groesse));
  beute_position[1] = floor(random(1, spielfeld_groesse));
}

void setzeSpielerEingabe(){
  if(keyPressed){
    if(keyCode == UP && letzte_richtung != "down"){
     richtung = "up"; 
    }
    if(keyCode == LEFT && letzte_richtung != "right"){
     richtung = "left"; 
    }
    if(keyCode == DOWN && letzte_richtung != "up"){
     richtung = "down"; 
    }
    if(keyCode == RIGHT && letzte_richtung != "left"){
     richtung = "right"; 
    }  
  }
}

void testeSpielerKollision(){
  if(spieler_position[0][0] == beute_position[0] && spieler_position[0][1] == beute_position[1]){
    spieler_groesse = spieler_groesse + 1;
    spieler_position[spieler_groesse - 1][0] = beute_position[0];
    spieler_position[spieler_groesse - 1][1] = beute_position[1];
    setzeZufaelligBeutePosition();
  }
}

void resetGame(){
  setzeZufaelligBeutePosition();
  
  //setzte Spieler
  spieler_position[0][0] = spielfeld_groesse / 2;
  spieler_position[0][1] = spielfeld_groesse / 2;
  for(int p = 1; p < maximale_spieler_groesse; p++){
  spieler_position[p][0] = 0;
  spieler_position[p][0] = 0;
  }
  spieler_groesse = 1;
  
  richtung = "up";
  letzte_richtung = "up";
}
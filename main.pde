int num, numMines, m;
float w;
int[][][] cells; //[x][y][count, mines, hasBeenRevealed, Flagged]
int count;
int foundMines;
boolean gameStart;

void setup(){
  size(1000,500);
  num = 10;
  numMines = 15;
  m = numMines;
  w = height/num;
  cells = new int[2*num][num][4];
  countMines();
  textSize(30);
}

void placeMines(){
  while(numMines > 0){
    int i = (int)random(2*num);
    int j = (int)random(num);
    if(cells[i][j][1] == 0){
      cells[i][j][1]= 1;
      numMines--;
    }
  }  
}

void revealAll(){
  for(int i = 0; i < cells.length ; i++){
    for(int j = 0; j < cells[0].length ; j++){  
      cells[i][j][2] = 1;
    }
  }
}
void draw(){
  display();
  checkMines();
}

void checkMines(){
   if(foundMines == m){
     print("FOUND THEM ALL!");
   }
}
void mouseClicked(){
  int x = (int)(mouseX/w); 
  int y = (int)(mouseY/w);
  if(mouseButton == LEFT){
    checkCell(x, y);
  } else if (mouseButton == RIGHT){
    if(cells[x][y][3] == 0){
      cells[x][y][3] = 1;
      if(cells[x][y][1] == 1){
        foundMines++;
      }
    } else {
      cells[x][y][3] = 0;
      if(cells[x][y][1] == 1){
        foundMines--;
      }      
    }
  }
}

void display(){
  for(int i = 0; i < cells.length ; i++){
    for(int j = 0; j < cells[0].length ; j++){
      fill(255);
      rect(i*w, j*w, w, w);
      //HAS BEEN REVEALED --> [i][j][2] == 1
      if(cells[i][j][2] == 1 && cells[i][j][3]==0){

        fill(220);
        if(cells[i][j][1] == 1){
          fill(0);
        }        
        rect(i*w, j*w, w, w);
        if(cells[i][j][0] == 1){
          fill(0,0,155);
        } else if(cells[i][j][0] == 2){
          fill(0,155,0);
        } else if(cells[i][j][0] == 3){
          fill(155,0,0);
        } else if(cells[i][j][0] == 4){
          fill(155,0,155);
        } 
        text(cells[i][j][0], i*w+w/4, (j+1)*w-w/4);
      } 
      if(cells[i][j][3] == 1){
        fill(255,0,0);
        rect(i*w, j*w, w, w);
      }
    }
  }
}   

void countMines(){
  for(int i = 0; i < cells.length; i++){
    for(int j = 0; j < cells[0].length; j++){
      count = 0;
      //LEFT THREEE
      if(i > 0 && j > 0){
        if(cells[i-1][j-1][1]==1){ count ++; }
      }
      if(i > 0){
        if(cells[i-1][j][1]==1){ count ++; }
      }
      if(i > 0 && j < num-1){
        if(cells[i-1][j+1][1]==1){ count ++; }
      }  
      //middle Two
      if(j > 0){
        if(cells[i][j-1][1]==1){ count ++; }
      }     
      if(j < num-1){
        if(cells[i][j+1][1]==1){ count ++; }
      }      
      //RIGHT THREE
      if(i < 2*num-1 && j > 0){
        if(cells[i+1][j-1][1]==1){ count ++; }
      } 
      if(i < 2*num-1){
        if(cells[i+1][j][1]==1){ count ++; }
      }
      if(i < 2*num-1 && j < num-1){
        if(cells[i+1][j+1][1]==1){ count ++; }
      }      
      cells[i][j][0] = count;
    }
  }
}

void checkCell(int a, int b){
    if(cells[a][b][1] ==1){
      revealAll();
    }
    cells[a][b][2] = 1;
    if(cells[a][b][0] == 0){

      if(a>0 && b >0 && cells[a-1][b-1][2]==0){
        checkCell(a-1,b-1);
      }
      if(b >0 && cells[a][b-1][2]==0){
        checkCell(a,b-1);
      }
      if(a < 2*num-1 && b > 0 && cells[a+1][b-1][2]==0){
        checkCell(a+1, b-1);
      }
      if(a > 0 && cells[a-1][b][2]==0){
        checkCell(a-1,b);
      }
      if(a < 2*num-1 && cells[a+1][b][2]==0){
        checkCell(a+1, b);
      }
      if(a > 0 && b < num-1 && cells[a-1][b+1][2]==0){
        checkCell(a-1,b+1);
      }
      if(b < num-1 && cells[a][b+1][2]==0){
        checkCell(a, b+1);
      }
      if(a < 2*num-1 && b < num-1 && cells[a+1][b+1][2]==0){
        checkCell(a+1, b+1); 
      }
    }
}

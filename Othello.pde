class Othello {
  int size;
  int boardNum;
  int[][] board;
  int wall, blank, black, white, green;
  int turn;
  int num;
  float s;
  float si;
  float tx, ty;
  int scoreB, scoreW;
  PFont font = loadFont("AmericanTypewriter-48.vlw");
  boolean isPlay;
  boolean isNormal;
  boolean isHelp;
  boolean isFrame;
  int[] sPoint;
  Othello() {
    sPoint = new int[2];
    isHelp = true;
    isFrame = true;
    isNormal = true;
    boardNum = 0;
    tx = 50;
    ty = 50;
    textAlign(CENTER, CENTER);
    textSize(30);
    textFont(font);
    wall = -1;
    blank = 0;
    black = 1;
    white = 2;
    green = 3;
    this.turn = 1;
    this.num = 0;
    scoreB = scoreW = 0;
    boardInit(8, isNormal);
  }
  
  void boardInit(int siz, boolean isN) {
    this.turn = 1;
    this.size = siz;
    s = 600.0;
    si = s/size;
    this.board = new int[size + 2][size + 2];
    for (int x = 0; x < size + 2; x++) {
      for (int y = 0; y < size + 2; y++) {
        board[x][y] = wall;
      }
    }
    for (int x = 1; x <= size; x++) {
      for (int y = 1; y <= size; y++) {
        board[x][y] = blank;
      }
    }
    board[size/2][size/2] = board[size/2 + 1][size/2 + 1] = white;
    board[size/2 + 1][size/2] = board[size/2][size/2 + 1] = black;
    countStone(board);
    isPlay = true;
    isNormal = isN;
    if (isNormal == false) {
      sPoint[0] = 10;
      sPoint[1] = 10;
    }
  }
  
  void system() {
    if (scoreB + scoreW == size*size) {
      isPlay = false;
    }
  }
  
  void display() {
    guiBack();
    pushMatrix();
    resetMatrix();
    translate(tx, ty);
    strokeWeight(si/25.0);
    stroke(50);
    fill(#27AA6A);
    rect(0, 0, s, s);
    for (int x = 1; x <= size; x++) line(x*si, 0, x*si, s);
    for (int y = 1; y <= size; y++) line(0, y*si, s, y*si);
    for (int x = 1; x <= size; x++) {
      for (int y = 1; y <= size; y++) {
        noStroke();
        if (board[x][y] == white) {
          fill(#F7F6EB);
          ellipse(x*si - si/2.0, y*si - si/2.0, si/1.3, si/1.3);
        }
        if (board[x][y] == black) {
          fill(#0E1210);
          ellipse(x*si - si/2.0, y*si - si/2.0, si/1.3, si/1.3);
        }
        if (isLegalMove(board, turn, x, y) == true && isHelp == true) {
          fill(70, 120, 120, 100);
          //rect(x*si - si,y*si - si,si,si);
          ellipse(x*si - si/2.0, y*si - si/2.0, si/1.3, si/1.3);
        }
      }
    }
    popMatrix();
    guiFront();
  }
  
  void guiBack() {
    background(#4167CE);
    if (isFrame == true) {
      if (turn == 2)fill(#F7F6EB, 150);
      else fill(#0E1210, 150);
      rect(tx-35, ty-35, 670, 670);
    }
    fill(#4167CE);
    rect(tx-15, ty-15, 630, 630);
    fill(100, 100, 100, 100);
    rect(700, 0, 200, 700);
    fill(60, 70, 100, 170);
    rect(720, 50, 160, 50);
    rect(720, 120, 160, 50);
    rect(720, 200, 160, 200);
    rect(720, 440, 160, 200);
    for (int x = 0; x < 2; x++) {
      for (int y = 0; y < 4; y++) {
        rect(740 + x * 65, 460 + y * 45, 55, 25);
      }
    }
    //rect(740, 220, 120, 60);
    if (isNormal == false) {
      rect(740, 220, 120, 60);
      for (int x = 0; x < 2; x++) {
        for (int y = 0; y < 2; y++) {
          rect(740 + x * 65, 310 + y * 45, 55, 25);
        }
      }
      fill(240);
      textSize(18);
      text("sp", 760, 250);
      textSize(14);
      if (turn == 1) {
        text("Black", 800, 230);
        textSize(24);
        text(sPoint[0], 800, 250);
      } else {
        text("White", 800, 230);
        textSize(24);
        text(sPoint[1], 800, 250);
      }
      textSize(18);
      text("Decoy", 740 + 55/2.0, 310 + 25/2.0);
      text("Bomb", 805 + 55/2.0, 310 + 25/2.0);
      text("Nuke", 740 + 55/2.0, 355 + 25/2.0);
      text("Team", 805 + 55/2.0, 355 + 25/2.0);
    }
    fill(#F7F6EB);
    ellipse(745, 75, 30, 30);
    fill(#0E1210);
    ellipse(745, 145, 30, 30);
    fill(240);
    textSize(30);
    text(scoreW, 820, 75);
    text(scoreB, 820, 145);

    textSize(17);
    text("8x8", 740 + 55/2.0, 460 + 25/2.0);
    text("12x12", 805 + 55/2.0, 460 + 25/2.0);
    text("18x18", 740 + 55/2.0, 505 + 25/2.0);
    text("26x26", 805 + 55/2.0, 505 + 25/2.0);
    textSize(14);
    text("Normal", 740 + 55/2.0, 550 + 25/2.0);
    text("Comboy", 805 + 55/2.0, 550 + 25/2.0);
    text("Help", 740 + 55/2.0, 595 + 25/2.0);
    text("Frame", 805 + 55/2.0, 595 + 25/2.0);
  }
  
  void guiFront() {
    if (isPlay == true) {
      if (mouseX > tx && mouseY > ty && mouseX < tx + 600 && mouseY < ty + 600) {
        if (turn == 2)fill(#F7F6EB, 200);
        else fill(#0E1210, 200);
        ellipse(mouseX, mouseY, si/1.3, si/1.3);
      }
    }
  }
  
  void othelloSystem() {
    for (int x = 1; x <= size; x++) {
      for (int y = 1; y <= size; y++) {
        if (mouseX>x*si-si+tx && mouseX<x*si+tx && mouseY>y*si-si+ty && mouseY<y*si+ty) {
          if (isLegalMove(board, turn, x, y) == true) {
            setTurnOver(board, turn, x, y);
            turn = opponent(turn);
            break;
          }
        }
      }
    }
    int count = 0;
    for (int x = 1; x <= size; x++) {
      for (int y = 1; y <= size; y++) {
        if (isLegalMove(board, turn, x, y)) count++;
      }
    }
    if (count == 0) turn = opponent(turn);
    countStone(board);
  }
  
  void comboySystem() {
    sPoint[0] += sPoint[1] * 2 - sPoint[0];
    sPoint[1] += sPoint[0] * 2 - sPoint[1];
    for (int x = 0; x < 2; x++) {
      for (int y = 0; y < 2; y++) {
        if (mouseAction(740 + x * 65, 310 + y * 45, 55, 25)) {
          int sNum = x + y * 2;
          if (turn == 1) {
            if (sNum == 0) {};
          } else {
            
          }
        }
      }
    }
  }
  
  void skillAction(int player, int which) {
    int uSp = 0;
    switch (which) {
      case 0:
        uSp = 50;
        break;
      case 1:
        uSp = 50;
        break;
      case 2:
        uSp = 50;
        break;
      case 3:
        uSp = 50;
        break;
      default:
        break;
    }
    sPoint[player] -= uSp;
  }
  
  void skillOperation(int which) {
    if (which != 0) {
      // you write skillOpe here and do not forget to shift which to 0;
    }
  }
  
  void mouseListener() {
    if (isPlay == true) {
      othelloSystem();
    }
    if (mouseX > 700) {
      for (int x = 0; x < 2; x++) {
        for (int y = 0; y < 4; y++) {
          if (mouseAction(740 + x * 65, 460 + y * 45, 55, 25)) {
            boardNum = x + y*2;
            if (boardNum == 0) boardInit(8, isNormal);
            if (boardNum == 1) boardInit(12, isNormal);
            if (boardNum == 2) boardInit(18, isNormal);
            if (boardNum == 3) boardInit(26, isNormal);
            if (boardNum == 4) boardInit(size, true);
            if (boardNum == 5) boardInit(size, false);
            if (boardNum == 6) {
              if (isHelp == true) {
                isHelp = false;
              } else {
                isHelp = true;
              }
            }
            if (boardNum == 7) {
              if (isFrame == true) {
                isFrame = false;
              } else {
                isFrame = true;
              }
            }
            break;
          }
        }
      }
    }
  }
  
  boolean mouseAction(float xp, float yp, float xs, float ys) {
    if (mouseX > xp && mouseY > yp && mouseX < xp + xs && mouseY < yp + ys) return true;
    return false;
  }

  int opponent(int player) {
    return 3 - player;
  }
  
  int turnOver(int[][] bo, int player, int p, int q, int d, int e) {
    int i;
    for (i = 1; bo[p + i * d][q + i * e] == opponent (player); i++) {
    }
    if (bo[p + i * d][q + i * e] == player) {
      return i - 1;
    } else {
      return 0;
    }
  }
  
  boolean isLegalMove(int[][] bo, int player, int p, int q) {
    if (p < 1 || p > size || q < 1 || q > size) return false;
    if (board[p][q] != blank) return false;
    for (int d = -1; d <= 1; d++) {
      for (int e = -1; e <= 1; e++) {
        if (d != 0 || e != 0) {
          if (turnOver(bo, player, p, q, d, e) != 0) return true;
        }
      }
    }
    return false;
  }

  boolean existLegalMove(int[][] bo, int player) {
    for (int x = 1; x <= size; x++) {
      for (int y = 1; y <= size; y++) {
        if (isLegalMove(bo, player, x, y) == true) return true;
      }
    }
    return false;
  }
  
  void setTurnOver(int[][] bo, int player, int p, int q) {
    int count;
    for (int d = -1; d <= 1; d++) {
      for (int e = -1; e <= 1; e++) {
        if (d == 0 && e == 0) continue;
        count = turnOver(bo, player, p, q, d, e);
        for (int i = 1; i <= count; i++) {
          bo[p + i * d][q + i * e] = player;
        }
      }
    }
    bo[p][q] = player;
  }
  
  void countStone(int[][] bo) {
    scoreB = 0;
    scoreW = 0;
    for (int x = 1; x <= size; x++) {
      for (int y = 1; y <= size; y++) {
        if (bo[x][y] == black)scoreB++;
        if (bo[x][y] == white)scoreW++;
      }
    }
  }
}
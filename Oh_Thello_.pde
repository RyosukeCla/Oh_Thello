Othello oth;
void setup() {
      size(900, 700);
oth = new Othello();
}

void draw() {
  oth.system();
  oth.display();
}

void mousePressed() {
  oth.mouseListener();
}
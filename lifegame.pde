// Links
import java.net.URI;
import java.awt.Desktop;
import java.awt.Cursor;
import java.awt.Color;

// Saving files
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.io.FileWriter;

// Lists
import java.util.List;
import java.util.ArrayList;

// Swing stuff
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.BorderLayout;
import java.awt.Point;
import java.awt.Dimension;
import javax.swing.*;

import java.util.Random;

void setup() { // Called at the start of the program
  size(1000, 1000, P3D); // Setting the main frame size
  setupFrame(); // Setting up the second frame
  setRandom(); // Sets the cells to random
  applyRules("6", "5 6 7"); // Default rules
  if (args != null) if (args.length != 0) readFile(args[0]); // Opens a state of the game with the executable if there is any
  autogeneration.start(); // Sets up autogeneration
}

String[] premade = { "Empty", "Blinker", "Accordion", "Explosion", "Explosion2", "Explosion3" };

void premake(String name) { // The premade states of the game with their own rules
  switch (name) {
    case "Empty": reset(); setSize(32); break;
    case "Blinker":
      reset();
      setSize(9);
      applyRules("4 5", "5");
      setCell(4, 4, 4, true);
      setCell(4+1, 4, 4, true);
      setCell(4-1, 4, 4, true);
      setCell(4, 4+1, 4, true);
      setCell(4, 4-1, 4, true);
      setCell(4, 4, 4+1, true);
      setCell(4, 4, 4-1, true);
    break;
    case "Accordion":
      reset();
      setSize(31);
      applyRules("4 5", "5");
      setCell(15, 15, 15, true);
      setCell(15+1, 15, 15, true);
      setCell(15-1, 15, 15, true);
      setCell(15, 15+1, 15, true);
      setCell(15, 15-1, 15, true);
    break;
    case "Explosion":
      reset();
      setSize(31);
      applyRules("4 5", "5");
      setCell(15, 15, 15+1, true);
      setCell(15+1, 15, 15+1, true);
      setCell(15-1, 15, 15+1, true);
      setCell(15, 15+1, 15+1, true);
      setCell(15, 15-1, 15+1, true);
      setCell(15, 15, 15-1, true);
      setCell(15+1, 15, 15-1, true);
      setCell(15-1, 15, 15-1, true);
      setCell(15, 15+1, 15-1, true);
      setCell(15, 15-1, 15-1, true);
      setCell(15, 15, 15-2, true);
      setCell(15, 15, 15+2, true);
    break;
    case "Explosion2":
      reset();
      setSize(31);
      applyRules("7 1", "");
      setCell(15, 15, 15, true);
      for (int i = 1; i < 3; i++) {
        setCell(15+i, 15, 15, true);
        setCell(15-i, 15, 15, true);
        setCell(15, 15+i, 15, true);
        setCell(15, 15-i, 15, true);
        setCell(15, 15, 15+i, true);
        setCell(15, 15, 15-i, true);
      }
    break;
    case "Explosion3":
      reset();
      setSize(31);
      applyRules("1 2", "");
      setCell(15, 15, 15, true);
    break;
    
    
  }
}

JLabel createLabel(String name, int posX, int posY, int dimX) { // Faster way to create labels
  JLabel l = new JLabel(name);
  l.setLocation(new Point(posX, posY));
  l.setSize(new Dimension(dimX, 13));
  l.setToolTipText(name);
  return l;
}

JButton createButton(String name, int posX, int posY, int dimX, ActionListener onClick) { // Faster way to create buttons
  JButton b = new JButton(name);
  b.setLocation(new Point(posX, posY));
  b.setSize(new Dimension(dimX, 23));
  b.addActionListener(onClick);
  b.setToolTipText(name);
  return b;
}

JToggleButton createToggle(String name, int posX, int posY, int dimX) { // Faster way to create toggle buttons
  JToggleButton b = new JToggleButton(name);
  b.setLocation(new Point(posX, posY));
  b.setSize(new Dimension(dimX, 23));
  b.setToolTipText(name);
  return b;
}

JSpinner createSpinner(int current, int min, int max, int step, int posX, int posY, int dimX) { // Faster way to create spinners
  JSpinner s = new JSpinner(new SpinnerNumberModel(current, min, max, step));
  s.setLocation(new Point(posX, posY));
  s.setSize(new Dimension(dimX, 20));
  return s;
}

JTextField createText(int posX, int posY, int dimX) { // Faster way to create text fields
  JTextField t = new JTextField();
  t.setLocation(new Point(posX, posY));
  t.setSize(new Dimension(dimX, 20));
  return t;
}

// All the predefined stuff
JLabel lActives = new JLabel();
JTextField tBirth = new JTextField(), tSurvive = new JTextField(), tFileName = new JTextField();
JToggleButton gShouldGenerate = new JToggleButton(), gAutoX = new JToggleButton(), gAutoY = new JToggleButton();
JSpinner nZSet = new JSpinner(), nYSet = new JSpinner(), nXSet = new JSpinner(), nGenTime = new JSpinner(), nSize = new JSpinner(), nFreq = new JSpinner();
JCheckBox cStateSet = new JCheckBox();
JComboBox dPremade = new JComboBox(premade);

void setupFrame() {
  
  // LABELS
  
  JLabel[] labels = { // All the labels in the second frame
    createLabel("Rules:", 8, 9, 37),
    createLabel("B", 8, 33, 14),
    createLabel("S", 8, 59, 14),
    createLabel("every", 132, 67, 33),
    createLabel("milliseconds.", 132, 106, 80),
    createLabel("Set", 9, 213, 23),
    createLabel("X", 32, 213, 14),
    createLabel("Y", 32, 231, 14),
    createLabel("Z", 32, 248, 14),
    createLabel("to", 84, 213, 16),
    createLabel("Camera velocity", 13, 329, 100),
    createLabel("Size", 8, 139, 27),
    createLabel("Frequency", 8, 165, 70)
  };
  
  lActives = createLabel("Actives: ", 13, 274, 200); // Actives was predefined, to be changed later
  
  final JDialog dialog = setupDialog(); // Sets up the About dialog
  
  JButton[] buttons = {
    createButton("Manual generating", 133, 12, 117, new ActionListener() { @Override public void actionPerformed(ActionEvent e) { generate(); } }), // Generates every time you click
    createButton("Reset", 131, 134, 119, new ActionListener() { @Override public void actionPerformed(ActionEvent e) { reset(); } }), // Sets all the cells to dead
    createButton("Set random", 131, 163, 119, new ActionListener() { @Override public void actionPerformed(ActionEvent e) { setRandom(); } }), // Sets all  the cells to random
    createButton("Apply rules", 11, 83, 109, new ActionListener() { @Override public void actionPerformed(ActionEvent e) { applyRules(tBirth.getText(), tSurvive.getText()); } }), // Applies the rules
    createButton("Set premade", 132, 229, 118, new ActionListener(){ @Override public void actionPerformed(ActionEvent e) { premake((String)dPremade.getSelectedItem()); } }), // Sets the game state to a premade one
    createButton("Set", 84, 243, 37, new ActionListener(){ @Override public void actionPerformed(ActionEvent e) { setCell((int)nXSet.getValue(), (int)nYSet.getValue(), (int)nZSet.getValue(), cStateSet.isSelected()); } }), // Sets a specific cell to dead of alive
    createButton("Save", 106, 380, 67, new ActionListener(){ @Override public void actionPerformed(ActionEvent e) { writeFile(tFileName.getText()); } }), // Saves the current game state in a file
    createButton("Load", 180, 380, 67, new ActionListener(){ @Override public void actionPerformed(ActionEvent e) { readFile(tFileName.getText()); } }), // Sets the current game state from a file
    createButton("About", 154, 419, 96, new ActionListener(){ @Override public void actionPerformed(ActionEvent e) { dialog.setVisible(true); } }) // Opens the About dialog
  };
  
  // TOGGLE BUTTONS
  
  gShouldGenerate = createToggle("Autogenerating", 133, 41, 117); // Autogenerates
  
  gAutoX = createToggle("X rotation", 12, 300, 109); // The camera automatically rotates around the X axis
  gAutoY = createToggle("Y rotation", 134, 300, 116);  // The camera automatically rotates around the X axis
  
  // TEXT FIELDS
  
  tBirth = createText(29, 30, 92); // The birth rules
  tSurvive = createText(29, 56, 92); // The survive rules
  
  tFileName = createText(12, 380, 88); // The name of the file to save in or to load from
  
  // SPINNERS
  
  nGenTime = createSpinner(500, 1, 10000, 100, 133, 83, 55); // The speed of the autogeneration
  
  nXSet = createSpinner(0, 0, 31, 1, 46, 211, 32); // The X value of a specific cell
  nYSet = createSpinner(0, 0, 31, 1, 46, 229, 32); // its Y value
  nZSet = createSpinner(0, 0, 31, 1, 46, 246, 32); // and its Z value
  
  nSize = createSpinner(32, 1, 100, 1, 42, 136, 78); // The size of the 'habitat'
  
  nFreq = createSpinner(10, 1, 500, 1, 71, 163, 49); // The frequecy of alive cell in Set Random
  
  // INDIVIDUAL STUFF
  
  cStateSet.setLocation(new Point(95, 213)); // The future state of a specific cell
  cStateSet.setSize(new Dimension(20, 15));
  
  dPremade.setLocation(new Point(132, 206)); // The selected premade game state
  dPremade.setSize(new Dimension(118, 21));
  
  JSlider sCameraSpeed = new JSlider(JSlider.HORIZONTAL, 0, 10, 3); // The speed of the camera rotation
  sCameraSpeed.setLocation(new Point(87, 329));
  sCameraSpeed.setSize(new Dimension(161, 45));
  sCameraSpeed.addChangeListener(new ChangeListener() { public void stateChanged(ChangeEvent e) { cameraSpeed = ((JSlider)e.getSource()).getValue(); } });
  
  // PANEL
  
  JPanel panel = new JPanel();
  panel.setSize(new Dimension(262, 513));
  panel.setLocation(new Point(0, 0));
  panel.setLayout(null);
  
  for (final JLabel l : labels) panel.add(l);
  panel.add(lActives);
  
  for (final JButton b : buttons) panel.add(b);
  
  panel.add(gShouldGenerate);
  panel.add(gAutoX);
  panel.add(gAutoY);
  
  panel.add(tBirth);
  panel.add(tSurvive);
  panel.add(tFileName);
  
  panel.add(nGenTime);
  panel.add(nXSet);
  panel.add(nYSet);
  panel.add(nZSet);
  panel.add(nSize);
  panel.add(nFreq);
  
  panel.add(cStateSet);
  panel.add(dPremade);
  panel.add(sCameraSpeed);
  
  // FRAME
  
  JFrame frame = new JFrame("Conway's Game of Life 3D");
  frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
  frame.setSize(273, 480);
  frame.setResizable(false);
  frame.getContentPane();
  frame.add(panel);
  frame.setVisible(true);
  
  try { UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName()); } catch (Exception e) {}
}

JButton createLink(String name, final String url, int posX, int posY, int dimX) { // Faster way to create hyperlinks
  JButton l = new JButton(name);
  l.setForeground(Color.BLUE.darker());
  l.setCursor(Cursor.getPredefinedCursor(Cursor.HAND_CURSOR));
  l.setBorderPainted(false);
  l.addActionListener(new ActionListener(){ @Override public void actionPerformed(ActionEvent e) {try{Desktop.getDesktop().browse(new URI(url));}catch(Exception x){}} });
  l.setLocation(new Point(posX, posY));
  l.setSize(new Dimension(dimX, 13));
  l.setToolTipText(url);
  return l;
}

JDialog setupDialog() { // The About dialog frame
  
  final JDialog dialog = new JDialog();
  dialog.setSize(520, 150);
  
  JLabel[] labels = {
    createLabel("Idea and code by Catonif", 12, 9, 150),
    createLabel("Blinker, Accordion and Explosion by Raphael Beaulieu and Elliot Coy", 12, 22, 400),
    createLabel("Explosion2 by Redstone Jazz", 12, 35, 200)
  };
  
  JButton bClose = createButton("Close", 174, 70, 75, new ActionListener(){ @Override public void actionPerformed(ActionEvent e) { dialog.setVisible(false); } });
  
  int linkX = 390, linkWidth = 125;
  
  JButton[] links = {
    createLink("GitHub project", "https://github.com/CatonIf/ConwayGameLife3D", linkX, 9, linkWidth),
    createLink("HTML page", "rbeaulieu.github.io/3DGameOfLife/3DGameOfLife.html?", linkX, 22, linkWidth),
    createLink("Youtube video", "https://youtu.be/wBqLxVvDuLY", linkX, 35, linkWidth)
  };
  
  JPanel panel = new JPanel();
  panel.setSize(new Dimension(262, 513));
  panel.setLocation(new Point(0, 0));
  panel.setLayout(null);
  
  for (final JLabel l : labels) panel.add(l);
  
  panel.add(bClose);
  
  for (final JButton b : links) panel.add(b);
  
  dialog.add(panel);
  
  return dialog;

}

List birth = new ArrayList(); // The birth rules
List survive = new ArrayList(); // The survive rules

int size = 32; // The size of the 'habitat'

boolean[][][] cells = new boolean[size][size][size]; // The current state of the game
int[][][] neighbours = new int[size][size][size];

// Camera movement variables
float cY, cX;

int cameraSpeed = 3; // The speed of the camera rotation

Random rnd = new Random();

int frequency = 10; // The frequency of alive cells in Set Random

void resetsFreqAndSize() { // Sets size and frequency from their spinners
  int tileTemp = (int)nFreq.getValue(); if (tileTemp > 0) frequency = tileTemp;
  int sizeTemp = (int)nSize.getValue(); if (sizeTemp > 0) setSize(sizeTemp);
}

void setActivesText(int actives) { // Sets the Actives label text
  lActives.setText("Active cells: " + actives + " / " + (size*size*size));
}

void setRandom() { // Makes all the tiles random.
  resetsFreqAndSize();
  int actives = 0;
  for(int x = 0; x < size; x++)
    for(int y = 0; y < size; y++)
      for(int z = 0; z < size; z++) {
        setCell(x, y, z, rnd.nextInt(frequency) == 0);
        actives += cells[x][y][z] ? 1 : 0;
      }
  setActivesText(actives);
}

void reset() { // Resets all the tiles
  resetsFreqAndSize();
  for(int x = 0; x < size; x++)
    for(int y = 0; y < size; y++)
      for(int z = 0; z < size; z++) {
        setCell(x,y,z, false);
      }
  setActivesText(0);
}

void setSize(int i) { // Sets the size of the 'habitat'
  size = i;
  nSize.setValue(i);
}

void applyRules(String b, String s) { // Applies the rules of the game from the B and S textfields.
  tBirth.setText(b); tSurvive.setText(s);
  birth.clear(); survive.clear();
  if (b != "") {
    String[] bs = b.split(" ");
    for (final String i : bs) birth.add(parseInt(i));
  } if (s != "") {
    String[] ss = s.split(" ");
    for (final String i : ss) survive.add(parseInt(i));
  }
}

boolean getCell(int x, int y, int z) { return cells[x][y][z]; } // Gets the value of a specific cell
void setCell(int x, int y, int z, boolean state) { cells[x][y][z] = state; } // Sets a value to a specific cell

void generate() { // Generates
  int actives = 0;
  
  for(int x = 0; x < size; x++)
    for(int y = 0; y < size; y++)
      for(int z = 0; z < size; z++) neighbours[x][y][z] = neighboursCount(x,y,z);
      
  for(int x = 0; x < size; x++)
    for(int y = 0; y < size; y++)
      for(int z = 0; z < size; z++) {
        setCell(x,y,z, rules(getCell(x,y,z), neighbours[x][y][z]));
        actives += getCell(x,y,z) ? 1 : 0;
      }
  setActivesText(actives);
}

boolean rules(boolean currentValue, int countNeighbours) { // Returns the future state of a cell
  return currentValue ? survive.contains(countNeighbours) : birth.contains(countNeighbours);
}

int neighboursCount(int x, int y, int z) { // The number of neighbours that a cell has.
  int c = 0;
  for(int fx = -1; fx < 2; fx++)
    for(int fy = -1; fy < 2; fy++)
      for(int fz = -1; fz < 2; fz++) {
        if (fx == 0 && fy == 0 && fz == 0) continue;
        c += cells[position(x + fx)][position(y + fy)][position(z + fz)] ? 1 : 0;
      }
  return c;
}

int position(int i) { // Goes back to the start or to the end if a value is bigger than the array or negative.
  return i == -1 ? size-1 : i == size ? 0 : i;
}

void draw() {
  
  background(190);
  fill(255);
  stroke(0);
  
  // automatic camera movement
  cX+=gAutoX.isSelected()?cameraSpeed/100f:0;
  cY+=gAutoY.isSelected()?cameraSpeed/100f:0;
  
  // mouse camera movement
  translate(500, 500, 0);
  if (mousePressed) {
    cX += (mouseX - pmouseX) * cameraSpeed / 1000f;
    cY += -(mouseY - pmouseY) * cameraSpeed / 1000f;
  } rotateX(cY); rotateY(cX);
  translate(-15*size/2, -15*size/2, -15*size/2);
  
  // draws the cubes that are live
  for (int x = 0; x < size; x++) {
    for(int y = 0; y < size; y++) {
      for(int z = 0; z < size; z++) {
        if (getCell(x,y,z)) box(15);
        translate(0, 0, 15);
      } translate(0, 15, -15*size);
    } translate(15, -15*size, 0);
  }
}

void writeFile(String fileName) { // Saves current game state to a file
  if (!fileName.contains(".")) fileName += ".gls"; // adds the Game of Life State extension if there is not already one
  try {
    OutputStreamWriter w = new OutputStreamWriter(new FileOutputStream(fileName), "UTF-8");
    w.write(""+size+birth.toString().replaceAll(",", "")+survive.toString().replaceAll(",", ""));
    for (int x = 0; x < size; x++)
      for(int y = 0; y < size; y++)
        for(int z = 0; z < size; z++)
          w.write(getCell(x,y,z)?'1':'0');
    w.close();
  } catch(Exception e) { }
}

void readFile(String fileName) { // Sets the current game state from a file
  if (!fileName.contains(".")) fileName += ".gls"; // adds the Game of Life State extension if there is not already one
  try {
    InputStreamReader r = new InputStreamReader(new FileInputStream(fileName), "UTF-8");
    String sSize = "", sBirth = "", sSurvive = "";
    while (true) {
      char c = (char)r.read();
      if (c == '[') break;
      sSize += c;
    }
    while (true) {
      char c = (char)r.read();
      if (c == ']') break;
      sBirth += c;
    } r.read();
    while (true) {
      char c = (char)r.read();
      if (c == ']') break;
      sSurvive += c;
    }
    size = parseInt(sSize);
    applyRules(sBirth, sSurvive);
    for (int x = 0; x < size; x++)
      for(int y = 0; y < size; y++)
        for(int z = 0; z < size; z++) {
          setCell(x,y,z, r.read() == '1');
        }
    r.close();
  } catch(Exception e) { }
}


Thread autogeneration = new Thread() { // Autogenerates
  public void run() {
    while (true) {
      try { Thread.sleep((int)(nGenTime.getValue())); } catch (InterruptedException e) { print("rip"); }
      if (gShouldGenerate.isSelected()) generate();
      
    }
  }
};

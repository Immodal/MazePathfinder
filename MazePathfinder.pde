// Global Vars
Maze maze;
int startX;
int startY;
int goalX;
int goalY;
Pathfinder pathfinder;
int margin = 10;
int numCells = 30;
float heuristicWeight = 1;
int fullBtnW = 150;
int fullBtnH = 75;

// UI
Button btnRetryMaze;
Button btnResetMaze;
Button btnShowMazeGeneration;
Button btnShowPathfinding;
Button btnShowDeadEnds;

Button btnDecNumCells;
Button btnIncNumCells;
Button btnPFBFS;
Button btnPFDFS;
Button btnPFAStar;
Button btnDecHeuristicWeight;
Button btnIncHeuristicWeight;

void setup() {
    size(940,620);

    // Initialize Column 1 Buttons
    btnRetryMaze = new Button(false, "Retry\nMaze", 20, 
        margin, margin, fullBtnW, fullBtnH, 5);
    btnResetMaze = new Button(false, "Regenerate\nMaze", 20, 
        margin, margin*2+fullBtnH, fullBtnW, fullBtnH, 5);
    btnShowMazeGeneration = new Button(false, "Show Maze\nGeneration", 20, 
        margin, margin*3+fullBtnH*2, fullBtnW, fullBtnH, 5);
    btnShowPathfinding = new Button(true, "Show\nPathfinding", 20, 
        margin, margin*4+fullBtnH*3, fullBtnW, fullBtnH, 5);
    btnShowDeadEnds = new Button(true, "Show\nDead Ends", 20, 
        margin, margin*5+fullBtnH*4, fullBtnW, fullBtnH, 5);
    
    // Initialize Column 2 Buttons
    btnDecNumCells = new Button(false, "Dec", 20, 
        margin*2+fullBtnW, margin, 50, fullBtnH, 5);
    btnIncNumCells = new Button(false, "Inc", 20, 
        margin*2+fullBtnW+100, margin, 50, fullBtnH, 5);
    btnPFBFS = new Button(true, "Use\nBFS", 20, 
        margin*2+fullBtnW, margin*2+fullBtnH, 70, fullBtnH, 5);
    btnPFDFS = new Button(false, "Use\nDFS", 20, 
        margin*2+fullBtnW+80, margin*2+fullBtnH, 70, fullBtnH, 5);
    btnPFAStar = new Button(false, "Use\nA*", 20, 
        margin*2+fullBtnW, margin*3+fullBtnH*2, 150, fullBtnH, 5);
    btnDecHeuristicWeight = new Button(false, "Dec", 20, 
        margin*2+fullBtnW, margin*4+fullBtnH*3, 50, fullBtnH, 5);
    btnIncHeuristicWeight = new Button(false, "Inc", 20, 
        margin*2+fullBtnW+100, margin*4+fullBtnH*3, 50, fullBtnH, 5);
        
    // Number of cells in x and y direction in maze
    maze = new Maze(numCells, numCells);
    startX = 0;
    startY = 0;
    resetPathfinder();
}

void draw() {
    if(!maze.isComplete) {
        if(btnShowMazeGeneration.state) {
            maze.step();
        } else {
            while(!maze.isComplete) {
                maze.step();
            }
        }
    } else if(!pathfinder.goalReached) {
        if(btnShowPathfinding.state) {
            pathfinder.step();
        } else {
            while(!pathfinder.goalReached) {
                pathfinder.step();
            }
        }
    }
    
    background(0);
    
    //Draw Col 1 Buttons
    btnRetryMaze.draw();
    btnResetMaze.draw();
    btnShowMazeGeneration.draw();
    btnShowPathfinding.draw();
    btnShowDeadEnds.draw();
    
    //Draw Col 2 Buttons
    btnDecNumCells.draw();
    drawNumCellsText();
    btnIncNumCells.draw();
    btnPFBFS.draw();
    btnPFDFS.draw();
    btnPFAStar.draw();
    btnDecHeuristicWeight.draw();
    drawHeuristicWeightText();
    btnIncHeuristicWeight.draw();
    
    drawMaze((height-margin*2)/maze.grid.length, margin*3+fullBtnW*2, margin);
    drawPaths(pathfinder.currentPath, pathfinder.deadEnds, btnShowDeadEnds.state,(height-margin*2)/maze.grid.length, margin*3+fullBtnW*2, margin);
}

void mousePressed() {
    if(btnRetryMaze.mouseIsOver()) {
        btnRetryMaze.state = true;
        resetPathfinder();
    } else if(btnResetMaze.mouseIsOver()) {
        btnResetMaze.state = true;
        maze.reset(numCells, numCells);
        resetPathfinder();
    } else if(btnShowMazeGeneration.mouseIsOver()) {
        btnShowMazeGeneration.state = !btnShowMazeGeneration.state;
    } else if(btnShowPathfinding.mouseIsOver()) {
        btnShowPathfinding.state = !btnShowPathfinding.state;
    } else if(btnShowDeadEnds.mouseIsOver()) {
        btnShowDeadEnds.state = !btnShowDeadEnds.state;
    } else if(btnDecNumCells.mouseIsOver()){
        btnDecNumCells.state = true;
        if(numCells>=10) {
            numCells -= 5;
            maze.reset(numCells, numCells);
            resetPathfinder();
        }
    } else if(btnIncNumCells.mouseIsOver()){
        btnIncNumCells.state = true;
        if(numCells<=95) {
            numCells += 5;
            maze.reset(numCells, numCells);
            resetPathfinder();
        }
    } else if(btnPFBFS.mouseIsOver()) {
        btnPFBFS.state = true;
        btnPFDFS.state = false;
        btnPFAStar.state = false;
        resetPathfinder();
    } else if(btnPFDFS.mouseIsOver()) {
        btnPFBFS.state = false;
        btnPFDFS.state = true;
        btnPFAStar.state = false;
        resetPathfinder();
    } else if(btnPFAStar.mouseIsOver()) {
        btnPFBFS.state = false;
        btnPFDFS.state = false;
        btnPFAStar.state = true;
        resetPathfinder();
    } else if(btnDecHeuristicWeight.mouseIsOver()){
        btnDecHeuristicWeight.state = true;
        if(heuristicWeight>0) {
            heuristicWeight -= 1;
            resetPathfinder();
        }
    } else if(btnIncHeuristicWeight.mouseIsOver()){
        btnIncHeuristicWeight.state = true;
        heuristicWeight += 1;
        resetPathfinder();
    }
}

void mouseReleased() {
    btnDecNumCells.state = false;
    btnIncNumCells.state = false;
    btnResetMaze.state = false;
    btnRetryMaze.state = false;
    btnDecHeuristicWeight.state = false;
    btnIncHeuristicWeight.state = false;
}

void drawNumCellsText() {
    fill(255);
    textSize(20);
    textAlign(CENTER, CENTER);
    text("Cells\n" + numCells, (btnIncNumCells.x-(btnDecNumCells.x+btnDecNumCells.w))/2+btnDecNumCells.x+btnDecNumCells.w, btnDecNumCells.y+(btnDecNumCells.h/2));
}

void drawHeuristicWeightText() {
    fill(255);
    textSize(20);
    textAlign(CENTER, CENTER);
    text("HW\n" + heuristicWeight, (btnIncHeuristicWeight.x-(btnDecHeuristicWeight.x+btnDecHeuristicWeight.w))/2+btnDecHeuristicWeight.x+btnDecHeuristicWeight.w, btnDecHeuristicWeight.y+(btnDecHeuristicWeight.h/2));
}

void resetPathfinder() {
    goalX = maze.grid.length-1;
    goalY = maze.grid[0].length-1;
    if(btnPFBFS.state) {
        pathfinder = new BreadthFirstSearch(maze, startX, startY, goalX, goalY);
    } else if(btnPFDFS.state){
        pathfinder = new DepthFirstSearch(maze, startX, startY, goalX, goalY);
    } else {
        pathfinder = new AStarSearch(maze, startX, startY, goalX, goalY, heuristicWeight);
    }
}

// originX, originY is the top left corner pixel of the maze, 
// it's to make sure the maze is drawn within the margins
void drawPaths(List<Cell> current, List<Cell> deadEnds, boolean showDeadEnds, float cellSize, float originX, float originY) {
    stroke(#0000FF);
    fill(#0000FF);
    if(showDeadEnds && deadEnds instanceof List) {
        drawPath(deadEnds, cellSize, originX, originY);
    }
    
    stroke(#FF0000);
    fill(#FF0000);
    if(current instanceof List) drawPath(current, cellSize, originX, originY);
}

void drawPath(List<Cell> path, float cellSize, float originX, float originY) {
    for(int i=0; i<path.size(); i++) {
        if(path.get(i) instanceof Cell) {
            // draw line and ellipse in the center of the cell
            ellipse(path.get(i).x*cellSize+originX+cellSize/2, path.get(i).y*cellSize+originY+cellSize/2, cellSize/10, cellSize/10);
            if(i+1<path.size() && path.get(i+1) instanceof Cell) {
                line(path.get(i).x*cellSize+originX+cellSize/2, path.get(i).y*cellSize+originY+cellSize/2, 
                    path.get(i+1).x*cellSize+originX+cellSize/2, path.get(i+1).y*cellSize+originY+cellSize/2);
            }
        }
    }
}

void drawMaze(float cellSize, float originX, float originY) {
    for(int i=0; i<maze.grid.length; i++) {
        for(int j=0; j<maze.grid[0].length; j++) {
            drawCell(maze.grid[i][j], cellSize, originX, originY);
        }
    }
}

void drawCell(Cell c, float size, float xOffset, float yOffset) {
    stroke(255);
    strokeWeight(1);
    if(c.visited) {
        fill(255);
    } else {
        fill(0);
    }
    rect(c.x*size+xOffset, c.y*size+yOffset, size, size);
    
    stroke(0);
    if(c.up)     line(c.x*size+xOffset,      c.y*size+yOffset,      c.x*size+size+xOffset, c.y*size+yOffset);
    if(c.down)   line(c.x*size+size+xOffset, c.y*size+size+yOffset, c.x*size+size+xOffset, c.y*size+yOffset);
    if(c.left)   line(c.x*size+xOffset,      c.y*size+yOffset,      c.x*size+xOffset,      c.y*size+size+yOffset);
    if(c.right)  line(c.x*size+size+xOffset, c.y*size+yOffset,      c.x*size+size+xOffset, c.y*size+size+yOffset);
}

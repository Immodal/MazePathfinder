 // Recursive Backtracker
import java.util.*;

class Maze {
    
    Cell[][] grid;
    Cell current;
    Stack<Cell> stack = new Stack<Cell>();
    boolean isComplete;
    
    Maze(int w, int h) {
        reset(w, h);
    }
    
    void step() {
        // Randomly choose one of its unvisited neighbours
        Cell chosen = getRandomNeighbour();
        // If the current cell has any neighbours which have not been visited
        if(chosen instanceof Cell){
            stack.push(current);
            chosen.visited = true;
            removeWall(chosen);
            current = chosen;
        // Else if stack is not empty    
        } else if(stack.size()>0){
            current = stack.pop();
        } else {
            isComplete = true;
        }
    }
    
    Cell getRandomNeighbour() {
        List<Cell> neighbours = new ArrayList<Cell>();
        
        if(current.y-1>=0 && !grid[current.x][current.y-1].visited) {
            neighbours.add(grid[current.x][current.y-1]); // If Top is valid and not visited
        } 
        
        if(current.y+1<grid[0].length && !grid[current.x][current.y+1].visited) {
            neighbours.add(grid[current.x][current.y+1]); // Down
        } 
        
        if(current.x-1>=0 && !grid[current.x-1][current.y].visited) {
            neighbours.add(grid[current.x-1][current.y]); // Left
        } 
        
        if(current.x+1<grid.length && !grid[current.x+1][current.y].visited) {
            neighbours.add(grid[current.x+1][current.y]); // Right
        }
        
        if(neighbours.size()>0) {
            return neighbours.get(new Random().nextInt(neighbours.size()));
        } else {
            return null;
        }
    }
    
    void removeWall(Cell chosen) {
        // Chosen is on top
        if(current.y > chosen.y){
            current.up = false;
            chosen.down = false;
        // Chosen is below
        } else if(current.y < chosen.y){
            current.down = false;
            chosen.up = false;
        // Chosen is on left  
        } else if(current.x > chosen.x){
            current.left = false;
            chosen.right = false;
        // // Chosen is on right
        } else if(current.x < chosen.x){
            current.right = false;
            chosen.left = false;
        }
    }
    
    void reset(int w, int h) {
        grid = new Cell[w][h];
        for(int i=0; i<grid.length; i++) {
            for(int j=0; j<grid[0].length; j++) {
                grid[i][j] = new Cell(i, j);
            }
        }
        
        current = grid[0][0];
        current.visited = true;
        isComplete = false;
    }
}

import java.util.*;

abstract class Pathfinder {
    
    Maze maze;
    
    List<Cell> currentPath;
    List<Cell> deadEnds;
    
    Cell start;
    Cell goal;
    
    boolean goalReached;
    
    abstract void reset(Maze m, int startX, int startY, int goalX, int goalY);
    
    abstract void step();
    

}

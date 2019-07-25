class DepthFirstSearch extends Pathfinder {
    
    Stack<Cell> open;
    Set<Cell> closed;
    Map<Cell, Cell> meta;
    
    DepthFirstSearch(Maze maze, int startX, int startY, int goalX, int goalY) {
        reset(maze, startX, startY, goalX, goalY);
    }
    
    void reset(Maze m, int startX, int startY, int goalX, int goalY) {
        maze = m;
        start = m.grid[startX][startY];
        goal = m.grid[goalX][goalY];
        open = new Stack<Cell>();
        closed = new HashSet<Cell>();
        open.push(start);
        meta = new HashMap();
        meta.put(start, null);
        goalReached = false;
        currentPath = null;
        deadEnds = new ArrayList<Cell>();
    }
    
    void step(){
        if(open.size()>0) {
            int numValidNeighbours=0;
            Cell current = open.pop();
            if(current.equals(goal)) {
                goalReached = true;
            } else {
                numValidNeighbours = enqueueNeighbours(current);
                closed.add(current);
            }
            
            if(goalReached || numValidNeighbours>0){
                currentPath = buildPath(current);
            } else {
                processDeadEnd(current);
            }
        }
    }
    
    int enqueueNeighbours(Cell c) {
        int numValidNeighbours=0;
        List<Cell> neighbours = new ArrayList<Cell>();
        
        if(!c.up && c.y-1>=0)                     neighbours.add(maze.grid[c.x][c.y-1]);
        if(!c.down && c.y+1<maze.grid[0].length)  neighbours.add(maze.grid[c.x][c.y+1]);
        if(!c.left && c.x-1>=0)                   neighbours.add(maze.grid[c.x-1][c.y]);
        if(!c.right && c.x+1<maze.grid.length)    neighbours.add(maze.grid[c.x+1][c.y]);
        
        for(Cell neighbour: neighbours) {
            if(!closed.contains(neighbour) && !open.contains(neighbour)) {
                numValidNeighbours++;
                meta.put(neighbour,c);
                open.push(neighbour);
            }
        }
        
        return numValidNeighbours;
    }
    
    LinkedList<Cell> buildPath(Cell c) {
        LinkedList path = new LinkedList<Cell>();
        path.add(c);
        Cell v = meta.get(c);
        
        while(v instanceof Cell) {
            path.add(0,v);
            v = meta.get(v);
        }
        
        return path;
    }
    
    void processDeadEnd(Cell c) {
        List<Cell> currentDeadEnd = buildPath(c);
        List<Cell> trimmedCurrent;
        int index;
        if(deadEnds.size()>0) {
            // Finds the node that is shared between the current deadEnd and the overall,
            // and then adds only the unique part. Ends are marked with null.
            for(int i=currentDeadEnd.size()-1; i>=0; i--) {
                index = deadEnds.indexOf(currentDeadEnd.get(i));
                if(index>=0) {
                    trimmedCurrent = currentDeadEnd.subList(i, currentDeadEnd.size());
                    trimmedCurrent.add(0, null);
                    deadEnds.addAll(trimmedCurrent);
                    break;
                }
            }
        } else {
            deadEnds.addAll(currentDeadEnd);
        }
    }
}

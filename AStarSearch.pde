class AStarSearch extends BreadthFirstSearch {
    
    float heuristicWeight;
    
    AStarSearch(Maze maze, int startX, int startY, int goalX, int goalY, float weight) {
        super(maze, startX, startY, goalX, goalY);
        heuristicWeight = weight;
    }
    
    @Override
    // open set is a priority queue with heuristic built in to comparator
    void reset(Maze m, int startX, int startY, int goalX, int goalY) {
        maze = m;
        start = m.grid[startX][startY];
        goal = m.grid[goalX][goalY];
        open = new PriorityQueue<Cell>(goalX, new Comparator<Cell>() {
            public int compare(Cell c1, Cell c2) {
                //float dc1 = dist(c1.x, c1.y, goal.x, goal.y);
                //float dc2 = dist(c2.x, c2.y, goal.x, goal.y);
                float dc1 = Math.abs(goal.x-c1.x) + Math.abs(goal.y-c1.y);
                float dc2 = Math.abs(goal.x-c2.x) + Math.abs(goal.y-c2.y);
                
                float costC1 = buildPath(c1).size()+ dc1*heuristicWeight;
                float costC2 = buildPath(c2).size()+ dc2*heuristicWeight;
                
                if (costC1<costC2){
                    return -1;
                } else if(costC1==costC2){
                    return 0;
                } else {
                    return 1;
                }
            }
        });
        closed = new HashSet<Cell>();
        open.offer(start);
        meta = new HashMap();
        meta.put(start, null);
        goalReached = false;
        currentPath = null;
        deadEnds = new ArrayList<Cell>();
    }
}

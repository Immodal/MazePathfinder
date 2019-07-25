class Cell {
    int x;
    int y;
    boolean up;
    boolean down;
    boolean left;
    boolean right;
    boolean visited = false;
    
    Cell(int x, int y) {
        this(x, y, true, true, true, true);
    }
    
    Cell(int x, int y, boolean up, boolean down, boolean left, boolean right) {
        this.x = x;
        this.y = y;
        this.up = up;
        this.down = down;
        this.left = left;
        this.right = right;
    }
    
    boolean equals(Cell other) {
        if(other.x==x && other.y==y) {
                //&& other.up==up && other.down==down && other.left==left && other.right==right) {
            return true;
        } else {
            return false;
        }
    }
}

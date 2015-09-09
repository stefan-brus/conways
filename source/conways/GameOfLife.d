/**
 * Conway's Game Of Life
 */

module conways.GameOfLife;

import adlib.ui.entity.model.Entity;
import adlib.ui.model.IGame;
import adlib.ui.GL;
import adlib.ui.SDL;

/**
 * Cell
 */

class Cell : Entity
{
    /**
     * Alive?
     */

    private bool alive;

    /**
     * Constructor
     *
     * Params:
     *      alive = Whether or not this cell is alive
     */

    this ( bool alive )
    {
        super(0, 0, 5, 5);

        this.alive = alive;
    }

    /**
     * Draw the cell, black if alive, white if dead
     */

    override void draw ( )
    {
        GL.begin(GL.QUADS);

        if ( this.alive )
            GL.color3ub(0x00, 0x00, 0x00);
        else
            GL.color3ub(0xFF, 0xFF, 0xFF);

        GL.vertex2f(this.x, this.y);
        GL.vertex2f(this.x + this.width, this.y);
        GL.vertex2f(this.x + this.width, this.y + this.height);
        GL.vertex2f(this.x, this.y + this.height);
        GL.color3ub(0xFF, 0xFF, 0xFF);
        GL.end();
    }

    /**
     * Collide, do nothing
     */

    override void collide ( Entity )
    {

    }
}

/**
 * The game grid
 */

struct Grid
{
    /**
     * The grid itself, a matrix of cell states
     */

    bool[][] grid;

    alias grid this;

    /**
     * Constructor
     *
     * Params:
     *      rows = The number of rows
     *      cols = The number of columns
     */

    this ( size_t rows, size_t cols )
    {
        this.grid.length = rows;

        foreach ( ref row; this.grid )
        {
            row.length = cols;
        }

        this.randomize();
    }

    /**
     * Randomize the grid
     */

    void randomize ( )
    {
        import std.random;

        foreach ( ref row; this.grid )
        {
            foreach ( ref col; row )
            {
                col = uniform(0, 20) > 18;
            }
        }
    }

    /**
     * Update the grid according to these rules:
     *
     * https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life
     */

    void update ( )
    {
        foreach ( r, ref row; this.grid )
        {
            foreach ( c, ref col; row )
            {
                auto alive_neighbors = this.noAliveNeighbors(r, c);

                switch ( alive_neighbors )
                {
                    case 2:
                        break;
                    case 3:
                        col = true;
                        break;
                    default:
                        col = false;
                        break;
                }
            }
        }
    }

    /**
     * Get the number of alive neighbors for the given coordinates
     *
     * Params:
     *      row = The row index
     *      col = The column index
     */

    private uint noAliveNeighbors ( size_t row, size_t col )
    in
    {
        assert(this.grid.length > 0);
        assert(this.grid[0].length > 0);
    }
    body
    {
        auto max_row = this.grid.length - 1,
             max_col = this.grid[0].length - 1;

        assert(row <= max_row && col <= max_col);

        uint result;

        // Holy shit is this ugly

        // top left
        if ( row > 0 && col > 0 ) result += this.grid[row - 1][col - 1] ? 1 : 0;
        // top
        if ( row > 0 ) result += this.grid[row - 1][col] ? 1 : 0;
        // top right
        if ( row > 0 && col < max_col ) result += this.grid[row - 1][col + 1] ? 1 : 0;
        // left
        if ( col > 0 ) result += this.grid[row][col - 1] ? 1 : 0;
        // right
        if ( col < max_col ) result += this.grid[row][col + 1] ? 1 : 0;
        // bottom left
        if ( row < max_row && col > 0 ) result += this.grid[row + 1][col - 1] ? 1 : 0;
        // bottom
        if ( row < max_row ) result += this.grid[row + 1][col] ? 1 : 0;
        // bottom right
        if ( row < max_row && col < max_col ) result += this.grid[row + 1][col + 1] ? 1 : 0;

        return result;
    }
}

/**
 * Game Of Life class
 */

class GameOfLife : IGame
{
    /**
     * How often the grid should be updated
     */

    private enum MS_PER_STEP = 50;

    /**
     * Cell entities
     */

    private Cell alive;

    private Cell dead;

    /**
     * The grid
     */

    private Grid grid;

    /**
     * Time elapsed counter
     */

    private uint elapsed;

    /**
     * Initialize the game
     */

    void init ( )
    {
        enum GRID_WIDTH = 100,
             GRID_HEIGHT = 100;

        this.alive = new Cell(true);
        this.dead = new Cell(false);

        this.grid = Grid(GRID_WIDTH, GRID_HEIGHT);
    }

    /**
     * Render the world
     */

    void render ( )
    {
        GL.clear(GL.COLOR_BUFFER_BIT);

        foreach ( r, row; this.grid )
        {
            foreach ( c, alive; row )
            {
                auto cell = alive ? this.alive : this.dead;

                cell.setPos(c * cell.width, r * cell.height);
                cell.draw();
            }
        }

        GL.flush();
    }

    /**
     * Handle the given event
     *
     * Params:
     *      event = The event
     *
     * Returns:
     *      True if successful
     */

    bool handle ( SDL.Event event )
    {
        return true;
    }

    /**
     * Update the world
     *
     * Params:
     *      ms = The number of elapsed milliseconds since the last step
     */

     void step ( uint ms )
     {
        this.elapsed += ms;

        if ( this.elapsed > MS_PER_STEP )
        {
            this.grid.update();

            this.elapsed = 0;
        }
     }
 }

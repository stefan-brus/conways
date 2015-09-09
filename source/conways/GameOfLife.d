/**
 * Conway's Game Of Life
 */

module conways.GameOfLife;

import conways.Cell;
import conways.Grid;

import adlib.ui.model.IGame;
import adlib.ui.GL;
import adlib.ui.SDL;

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

/**
 * Conway's Game Of Life
 */

module conways.GameOfLife;

import conways.Cell;
import conways.GameConfig;
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
     * Whether or not the game is paused
     */

    private bool paused;

    /**
     * The game configuration
     */

    private GameConfig config;

    /**
     * Constructor
     *
     * Params:
     *      config = The game configuration
     *      init_grid = The initial grid
     */

    this ( GameConfig config, Grid init_grid )
    {
        this.config = config;
        this.grid = Grid(this.config.height, this.config.width, this.config.init_alive_frequency);

        if ( init_grid == Grid.init )
        {
            this.grid.randomize();
        }
        else
        {
            assert(init_grid.length <= this.config.height && init_grid[0].length <= this.config.width, "Initial grid too big");

            foreach ( r, row; init_grid )
            {
                foreach ( c, col; row )
                {
                    this.grid[r][c] = col;
                }
            }
        }
    }

    /**
     * Initialize the game
     */

    void init ( )
    {
        this.alive = new Cell(true);
        this.dead = new Cell(false);
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
        if ( event().type == SDL.Event.TEXTINPUT ) switch ( event().text.text[0] )
        {
            case ' ':
                this.paused = true;
                break;
            case 'r':
                this.grid.randomize();
                break;
            default:
                break;
        }
        else if ( event().type == SDL.Event.KEYUP ) switch ( event.getScancode() )
        {
            case SDL.Event.SCAN_SPACE:
                this.paused = false;
                break;
            default:
                break;
        }

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

        if ( !this.paused && this.elapsed > this.config.ms_per_step )
        {
            this.grid.update();

            this.elapsed = 0;
        }
     }
 }

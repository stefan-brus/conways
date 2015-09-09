/**
 * Game grid
 */

module conways.Grid;

/**
 * The game grid struct
 */

struct Grid
{
    /**
     * The grid itself, a matrix of cell states
     */

    bool[][] grid;

    alias grid this;

    /**
     * The initial frequency of living cells
     */

    double frequency;

    /**
     * Constructor
     *
     * Params:
     *      rows = The number of rows
     *      cols = The number of columns
     *      frequency = The initial frequency of living cells
     */

    this ( size_t rows, size_t cols, double frequency )
    {
        this.grid.length = rows;

        foreach ( ref row; this.grid )
        {
            row.length = cols;
        }

        this.frequency = frequency;
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
                col = uniform01() < this.frequency;
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
        bool[][] new_grid;

        foreach ( r, row; this.grid )
        {
            new_grid.length++;

            foreach ( c, col; row )
            {
                auto alive_neighbors = this.noAliveNeighbors(r, c);

                switch ( alive_neighbors )
                {
                    case 2:
                        new_grid[r] ~= col;
                        break;
                    case 3:
                        new_grid[r] ~= true;
                        break;
                    default:
                        new_grid[r] ~= false;
                        break;
                }
            }
        }

        this.grid = new_grid;
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

    /**
     * Load a grid from a file
     *
     * Params:
     *      path = The path to the file
     *      grid = The grid to load to
     *
     * Returns:
     *      True if the parsing succeeded, false otherwise
     */

    static bool fromFile ( string path, ref Grid grid )
    {
        import std.stdio;

        if ( grid.length > 0 )
        {
            return false;
        }

        foreach ( size_t i, string line; lines(File(path)) )
        {
            if ( line.length == 0 )
            {
                break;
            }

            grid.length++;

            foreach ( c; line )
            {
                switch ( c )
                {
                    case '0':
                        grid[i] ~= false;
                        break;
                    case '1':
                        grid[i] ~= true;
                        break;
                    default:
                        break;
                }
            }
        }

        if ( grid.length == 0 )
        {
            return false;
        }

        auto row_len = grid[0].length;

        foreach ( row; grid )
        {
            if ( row.length != row_len )
            {
                return false;
            }
        }

        return true;
    }
}

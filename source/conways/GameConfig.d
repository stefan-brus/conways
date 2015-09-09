/**
 * Game configuration
 */

module conways.GameConfig;

/**
 * Config struct
 */

struct GameConfig
{
    /**
     * Game width
     */

    uint width;

    /**
     * Game height
     */

    uint height;

    /**
     * Game speed in ms per step
     */

    uint ms_per_step;

    /**
     * Initial frequency of cells that are alive
     */

    double init_alive_frequency;

    /**
     * Validate the configuration
     *
     * Returns:
     *      True if the config is valid, false otherwise
     */

    bool validate ( )
    {
        enum WIDTH_MAX = 300,
             HEIGHT_MAX = 200,
             SPEED_MAX = 10000;

        bool result = true;

        result &= this.width <= WIDTH_MAX;
        result &= this.height <= HEIGHT_MAX;
        result &= this.ms_per_step <= SPEED_MAX;
        result &= this.init_alive_frequency <= 1.0 && this.init_alive_frequency >= 0.0;

        return result;
    }

    /**
     * Load the configuration from a file
     *
     * Params:
     *      path = The path to the file
     *      config = The config to load to
     *
     * Returns:
     *      True if the parsing succeeded, false otherwise
     */

    static bool fromFile ( string path, ref GameConfig config )
    {
        import std.format;
        import std.stdio;

        auto file = File(path);
        uint no_read;

        foreach ( size_t i, string line; lines(file) )
        {
            switch ( i )
            {
                case 0:
                    formattedRead(line, "width = %d", &config.width);
                    no_read++;
                    break;
                case 1:
                    formattedRead(line, "height = %d", &config.height);
                    no_read++;
                    break;
                case 2:
                    formattedRead(line, "ms_per_step = %d", &config.ms_per_step);
                    no_read++;
                    break;
                case 3:
                    formattedRead(line, "init_alive_frequency = %f", &config.init_alive_frequency);
                    no_read++;
                    break;
                default:
                    break;
            }
        }

        if ( no_read != 4 )
        {
            return false;
        }

        if ( !config.validate() )
        {
            return false;
        }

        return true;
    }
}

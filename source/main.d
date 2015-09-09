/**
 * Main module
 */

module main;

import conways.GameConfig;
import conways.GameOfLife;
import conways.Grid;

import adlib.ui.SDLApp;

int main ( string[] args )
{
    GameConfig config;
    Grid init_grid;

    if ( !GameConfig.fromFile("game.cfg", config) )
    {
        assert(false, "Unable to load game configuration");
    }

    if ( args.length == 2 && !Grid.fromFile(args[1], init_grid) )
    {
        assert(false, "Unable to read grid from file");
    }

    auto game = new GameOfLife(config, init_grid);
    auto app = new SDLApp!false("Conway's Game Of Life", config.width * 5, config.height * 5, game);

    return app.run();
}

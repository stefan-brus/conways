/**
 * Main module
 */

module main;

import conways.GameConfig;
import conways.GameOfLife;

import adlib.ui.SDLApp;

int main ( )
{
    GameConfig config;

    if ( !GameConfig.fromFile("game.cfg", config) )
    {
        assert(false, "Unable to load game configuration");
    }

    auto game = new GameOfLife(config);
    auto app = new SDLApp!false("Conway's Game Of Life", config.width * 5, config.height * 5, game);

    return app.run();
}

/**
 * Main module
 */

module main;

import conways.GameOfLife;

import adlib.ui.SDLApp;

int main ( )
{
    auto game = new GameOfLife();
    auto app = new SDLApp!false("Conway's Game Of Life", 500, 500, game);

    return app.run();
}

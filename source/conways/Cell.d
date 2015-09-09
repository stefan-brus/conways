/**
 * Cell entity
 */

module conways.Cell;

import adlib.ui.entity.model.Entity;
import adlib.ui.GL;

/**
 * Cell entity class
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

Backbone    = require "backbone"
network     = require "./network.coffee"



class Opponent

    sprite:         null
    bounce:         0.1
    gravity:        1000
    walkVelocity:   150
    jumpVelocity:   -350
    lastShot:       new Date().getTime()
    shotDelay:      100
    direction:      "right"
    doubleJump:     false

    # Constructor of the model
    #
    constructor: ( game, sprite ) ->

        @game   = game

        sprite.body.bounce.y             = 0.1
        sprite.body.gravity.y            = 400
        sprite.body.collideWorldBounds   = true

        #  Our two animations, walking left and right.
        #
        sprite.animations.add( "left",     [ 0, 1, 2, 3 ], 10, true )
        sprite.animations.add( "right",    [ 5, 6, 7, 8 ], 10, true )

        @sprite = sprite

        # Our bullet group
        #
        @bullets = @game.add.group();
        @bullets.enableBody = true;
        @bullets.physicsBodyType = Phaser.Physics.ARCADE;
        @bullets.createMultiple( 30, 'bullet' );
        @bullets.setAll('anchor.x', 0.5);
        @bullets.setAll('anchor.y', 1);
        @bullets.setAll('outOfBoundsKill', true);
        @bullets.setAll( "checkWorldBounds", true );


    moveRight: () ->

        @sprite.body.velocity.x = @walkVelocity
        @sprite.animations.play( "right" )
        @direction = "right"

    moveLeft: () ->

        @sprite.body.velocity.x = @walkVelocity * -1
        @sprite.animations.play( "left" )
        @direction = "left"

    jump: ( data ) ->

        @sprite.body.velocity.y = @jumpVelocity

    stop: () ->
        @sprite.body.velocity.x = 0
        @stopAnimations()

    stopAnimations: () ->
        @sprite.animations.stop()

    sync: ( data ) ->

        # @stop()

        @sprite.reset( data.x, data.y )
        @sprite.body.velocity.x = data.velocity.x
        @sprite.body.velocity.y = data.velocity.y



    shoot: () ->

        now = new Date().getTime()

        if ( now - @lastShot ) > @shotDelay

            @lastShot = now

            # Grab the first bullet we can from the pool
            bullet = @bullets.getFirstExists( false );

            if bullet and @direction is "left" or @direction is "right"

                # And fire it
                #
                if @direction is "left"
                    bullet.reset( ( @sprite.x - 5) , @sprite.y + 38)
                    bullet.body.velocity.x = -400

                else if @direction is "right"
                    bullet.reset( @sprite.x + 15, @sprite.y + 38)
                    bullet.body.velocity.x = 400


    # update: () ->
    #     @stop()

module.exports = Opponent

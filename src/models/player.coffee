Backbone    = require "backbone"
network     = require "./network.coffee"



class PlayerModel

    sprite:         null
    bounce:         0.1
    gravity:        400
    walkVelocity:   150
    jumpVelocity:   -350
    lastShot:       new Date().getTime()
    shotDelay:      100
    direction:      "right"
    doubleJump:     false
    isMoving:       false

    # Constructor of the model
    #
    constructor: ( game ) ->

        @game = game

        #  Our controls.
        #
        @cursors    = @game.input.keyboard.createCursorKeys()
        @fireButton = @game.input.keyboard.addKey( Phaser.Keyboard.SPACEBAR )

        @spawnPoint =
            x:  432
            y:  @game.world.height - 250


        # The player and its settings
        #
        @sprite = @game.add.sprite( @spawnPoint.x, @spawnPoint.y, "dude" )

        # Make sure the camera follows the player sprite
        #
        @game.camera.follow( @sprite )

        #  We need to enable physics on the player
        #
        @game.physics.arcade.enable( @sprite )

        #  Player physics properties. Give the little guy a slight bounce.
        #
        @sprite.body.bounce.y             = @bounce
        @sprite.body.gravity.y            = @gravity
        @sprite.body.collideWorldBounds   = true

        #  Our two animations, walking left and right.
        #
        @sprite.animations.add( "left",     [ 0, 1, 2, 3 ], 10, true )
        @sprite.animations.add( "right",    [ 5, 6, 7, 8 ], 10, true )


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


    update: () ->

        # if left arrow is pressed go left
        #
        if @cursors.left.isDown
            @moveLeft()

        # If right arrow is pressed go left
        #
        else if @cursors.right.isDown
            @moveRight()

        # Stand still, stop animations
        #
        else if @sprite.body.velocity.x isnt 0
            #  Reset the players velocity (movement)
            #
            @stop()
            @stopAnimations()

        #  Allow the player to jump if they are touching the ground.
        #
        if @cursors.up.isDown
            @jump()


        if @fireButton.isDown
            @shoot()

    moveRight: () ->


        @sprite.body.velocity.x = @walkVelocity
        @sprite.animations.play( "right" )
        @direction = "right"

        network.sendData( { command: "moveRight" } )

    moveLeft: () ->

        @sprite.body.velocity.x = @walkVelocity * -1
        @sprite.animations.play( "left" )
        @direction = "left"

        network.sendData( { command: "moveLeft" } )


    jump: () ->

        if @sprite.body.touching.down is true
            @sprite.body.velocity.y = @jumpVelocity

            network.sendData(
                command:    "jump"
                x:          @sprite.x
                y:          @sprite.y
            )


    stop: () ->

        @sprite.body.velocity.x = 0

        network.sendData( { command: "stop" } )

    stopAnimations: () ->

        @sprite.animations.stop()


    # updatePosition: ( data ) ->
    #     @sprite.x = data.x
    #     @sprite.y = data.y

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

                network.sendData( { command: "shoot" } )

module.exports = PlayerModel

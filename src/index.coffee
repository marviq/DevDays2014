World               = require( "./world.coffee" )
Player              = require( "./models/player.coffee" )
Opponent            = require "./models/opponent.coffee"
OpponentsCollection = require "./collections/opponents.coffee"
network             = require( "./models/network.coffee" )


$( "a[href='#joingame']" ).click( ( e ) ->
    e.preventDefault()

    network.connect( $( "input[name='username']" ).val() )
)

$( "a[href='#connect']" ).click( ( e ) ->
    e.preventDefault()

    network.connectToUser( $( "input[name='usernameToConnect']" ).val() )
)





player      = undefined
opponents   = {}
opGroup     = undefined
game        = undefined
world       = undefined

create = () ->
    # opponents  = new OpponentsCollection( game )
    world      = new World( game )
    player     = new Player( game )

    opGroup             = game.add.group()
    opGroup.enableBody  = true

    network.on( "newPlayer", ( playerID ) =>

        sprite = opGroup.create( 432, game.world.height - 250 , "dude" )

        opponents[ playerID ] = new Opponent( game, sprite )
    )

    network.on( "dataFromPeer", ( data ) =>
        opponent = opponents[ data.peerID ]

        if data.data.command is "sync"
            opponent.sync( data.data )


        else if opponent[ data.data.command ]
            opponent[ data.data.command ]( data.data )
    )


    window.setInterval( () =>

        sprite = player.sprite

        network.sendData(
            command:        "sync"
            x:              sprite.x
            y:              sprite.y
            velocity:
                x:          sprite.body.velocity.x
                y:          sprite.body.velocity.y
        )

    ,   2000 )


# Function is called by Phaser to preload any assets
#
preload = () ->

    game.load.image(       "ground",       "assets/platform.png" )
    game.load.spritesheet( "dude",         "assets/dude.png", 32, 48 )
    game.load.image(       "background",   "assets/background.png" )
    game.load.image(       "bullet",       "assets/bullet.png" )



# This function is essentially the game loop used by Phaser
# it will be called repeatly when the game is running
#
update = () ->
    # Collide the player and platforms
    #
    game.physics.arcade.collide( player.sprite, world.platforms )
    game.physics.arcade.collide( player.bullets, world.platforms, killBullet, null, this )

    for playerID, opponent of opponents
        game.physics.arcade.collide( opponent.sprite, world.platforms )
        game.physics.arcade.collide( opponent.sprite, player.sprite )
        game.physics.arcade.overlap( player.bullets, opponent.sprite, killPlayer, null, this )


    player.update()


killBullet = ( bullet ) ->
    bullet.kill()


killPlayer = ( player, bullet ) ->
    bullet.kill()
    console.log( "hit player!!!", player )

        # opponent.update()

    # @game.physics.arcade.collide(player2.sprite, world.platforms )
    # @game.physics.arcade.collide(player.sprite, player2.sprite);
    # @game.physics.arcade.collide(player2.sprite, player.sprite);



    #  Checks to see if the player overlaps with any of the stars, if he does call the collectStar function

    # @game.physics.arcade.overlap( player.bullets, world.platforms, destroyBullet, null, this )
    # @game.physics.arcade.overlap( player.sprite, world.ground, killPlayer, null, this )





game = new Phaser.Game( 1280, 550, Phaser.AUTO, '', { preload: preload, create: create, update: update } )
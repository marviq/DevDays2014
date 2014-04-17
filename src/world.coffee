
class World


    constructor: ( game ) ->

        # We're going to be using physics, so enable the Arcade Physics system
        game.physics.startSystem(Phaser.Physics.ARCADE);

        #  A simple background for our game
        game.add.sprite( 0, 0, "background" );

        # set game world size
        game.world.setBounds( 0, 0, 1280, 650 );

        # The platforms group contains the ground and the 2 ledges we can jump on
        @platforms = game.add.group();

        #  We will enable physics for any object that is created in this group
        @platforms.enableBody = true;


        @ground = game.add.group()
        @ground.enableBody = true

        # # # Here we create the ground.
        ground = @ground.create(0, game.world.height - 1 , 'ground');

        # #  This stops it from falling away when you jump on it
        ground.body.immovable = true;


        #  Scale it to fit the width of the game (the original sprite is 400x32 in size)
        ground.scale.setTo(20, 2);




        mainPlatform = @platforms.create( 350, game.world.height - 150, "ground" )
        mainPlatform.body.immovable = true
        mainPlatform.scale.setTo( 1.08, 1 )

        subPlatform =  @platforms.create( 750, game.world.height - 50, "ground" )
        subPlatform.body.immovable = true
        subPlatform.scale.setTo( 0.8, 1 )

        towerPlatform =  @platforms.create( 905, game.world.height - 230, "ground" )
        towerPlatform.body.immovable = true
        towerPlatform.scale.setTo( 0.16, 0.2 )

        # leftAnglePlatform = @platforms.create( 200, game.world.height - 100, "ground" )
        # leftAnglePlatform.body.immovable = true
        # leftAnglePlatform.scale.setTo( 0.5, 0.5 )
        # leftAnglePlatform.pivot.x = leftAnglePlatform.width * .5;
        # leftAnglePlatform.pivot.y = leftAnglePlatform.height * .5;

        # Create the stairs
        #
        ledge = @platforms.create( 580, game.world.height - 235, 'ground');
        ledge.body.immovable = true
        ledge.scale.setTo( 0.18, 0.4 )

        ledge = @platforms.create( 645, game.world.height - 315, 'ground');
        ledge.body.immovable = true
        ledge.scale.setTo( 0.2, 0.4 )

        ledge = @platforms.create( 590, game.world.height - 405, 'ground');
        ledge.body.immovable = true
        ledge.scale.setTo( 0.17, 0.4 )


module.exports = World

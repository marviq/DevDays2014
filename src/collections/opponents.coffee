Backbone = require "backbone"


class OpponentsCollection extends Backbone.Collection


    initialize: ( game ) ->
        @game = game

        @group = @game.add.group()
        @group.enableBody = true


        @spawnPoint =
            x:  432
            y:  @game.world.height - 250


    createOpponent: () ->
        sprite = @group.create( @spawnPoint.x, @spawnPoint.y , 'dude' )


        #  We need to enable physics on the player
        #
        @game.physics.arcade.enableBody( sprite )


        #  Player physics properties. Give the little guy a slight bounce.
        #
        sprite.body.bounce.y             = @get( "bounce" )
        sprite.body.gravity.y            = 400
        sprite.body.collideWorldBounds   = true

        #  Our two animations, walking left and right.
        #
        sprite.animations.add( "left",     [ 0, 1, 2, 3 ], 10, true )
        sprite.animations.add( "right",    [ 5, 6, 7, 8 ], 10, true )




module.exports = OpponentsCollection
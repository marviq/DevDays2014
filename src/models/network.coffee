Backbone = require "backbone"

class Network extends Backbone.Model

    defaults:

        # contains our peer object when connected
        #
        peers: []
        # contains all peers we are connected to
        #
        peer: undefined


    # Connect to the network using the supplied username
    #
    connect: ( username ) ->

        # Make a peer for ourselfs
        #
        @peer = new Peer( username, { key: "yrvr7bmdn5mqjjor" } )

        # This event is called when someone connects to use
        #
        @peer.on( "connection", ( connection ) =>

            # When we receive data from this peer we might want
            # to do something with it
            #
            connection.on( "data", ( data ) =>

                @trigger( "dataFromPeer",
                    peerID:     connection.peer
                    data:       data
                )
            )
        )

        # Setup the central error handler for the peer
        # this emmits errors as peerID ( username ) already
        # taken and things like that
        #
        @peer.on( "error", ( error ) =>
            alert( error.message )
        )

    connectToUser: ( username ) ->
        connection = @peer.connect( username )

        connection.on( "open", ( conn ) =>

            # Add the new peer to the peers object so we can
            # send data to it
            #
            peers = @get( "peers" )
            peers[ connection.peer ] = connection

            @set( "peers", peers )

            # Let anyone know there is new player with its peerID ( username )
            #
            @trigger( "newPlayer", connection.peer )

            console.log( "[ Network ] connected to: ", username )
        )

    # Used to send data to all of our peers
    #
    sendData: ( data ) ->
        peers = @get( "peers" )

        for peerid, peer of peers
            peer.send( data )


module.exports = new Network()


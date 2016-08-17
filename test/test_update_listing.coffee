# run with "coffee test/test_get_listing.coffee <userId> <listingId>"

Lokka = require('lokka').Lokka
Transport = require('lokka-transport-http').Transport
{coroutine} = require 'bluebird'
startServer = require '../src/start_server'


userId = process.argv[2]
listingId = process.argv[3]


client = new Lokka transport: new Transport 'http://localhost:8080/graphql'
mutationQuery = """
  ($input: listingInput!){
    updateListing(id: "#{listingId}", data: $input) {
      id
      name
      ownerId
      spaces {
        index
        suite
      }
    }
  }
  """

mutationVariables =
  input:
    name: 'Fizz'
    spaces: [
      suite: 'A'
    ,
      suite: 'C'
    ]


query = """
  {
    getListing(id: "#{listingId}") {
      id
      name
      ownerId
      spaces {
        index
        suite
      }
    }
  }
  """



do coroutine ->
  yield startServer userId
  try
    result = yield client.query query
    console.log 'Get Success:\n', JSON.stringify(result, null, 2)
    result = yield client.mutate mutationQuery, mutationVariables
    console.log 'Update Success:\n', JSON.stringify(result, null, 2)
    result = yield client.query query
    console.log 'Get Success:\n', JSON.stringify(result, null, 2)
    # Don't exit in order to let the hook run
  catch error
    console.error 'Error:\n', error.stack or error, '\n', JSON.stringify(error, null, 2)
    process.exit 1

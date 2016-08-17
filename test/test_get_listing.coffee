# run with "coffee test/test_get_listing.coffee <userId> <listingId>"

Lokka = require('lokka').Lokka
Transport = require('lokka-transport-http').Transport
{coroutine} = require 'bluebird'
startServer = require '../src/start_server'


userId = process.argv[2]
listingId = process.argv[3]


client = new Lokka transport: new Transport 'http://localhost:8080/graphql'
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
    console.log 'Success:', JSON.stringify(result, null, 2)
    process.exit 0
  catch error
    console.error 'Error:', error.stack or error
    process.exit 1

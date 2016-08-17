# run with "coffee test/test_introspection.coffee"

Lokka = require('lokka').Lokka
Transport = require('lokka-transport-http').Transport
{coroutine} = require 'bluebird'
startServer = require '../src/start_server'


client = new Lokka transport: new Transport 'http://localhost:8080/graphql'

# View on the structure of a type
listingTypeQuery = """
  {
    __type(name: "listing") {
      name
      fields {
        name
        type {
          name
        }
      }
    }
  }
  """

# View all the queries available
queriesAvailableQuery = """
  {
    __schema {
      queryType {
        name
        fields {
          name
        }
      }
    }
  }
  """

# View all the mutations available
mutationsAvailableQuery = """
  {
    __schema {
      mutationType {
        name
        fields {
          name
        }
      }
    }
  }
  """


do coroutine ->
  yield startServer 'user1'
  try
    result = yield client.query listingTypeQuery
    console.log 'Success:\n', JSON.stringify(result, null, 2)
    result = yield client.query queriesAvailableQuery
    console.log 'Success:\n', JSON.stringify(result, null, 2)
    result = yield client.query mutationsAvailableQuery
    console.log 'Success:\n', JSON.stringify(result, null, 2)
    process.exit 0
  catch error
    console.error 'Error:\n', error.stack or error
    process.exit 1

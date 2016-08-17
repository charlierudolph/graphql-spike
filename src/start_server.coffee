express = require 'express'
graphQlHttp = require 'express-graphql'
schema = require './schema'


app = express()


startServer = (userId) ->
  app.use '/graphql', graphQlHttp (req) ->
    {
      schema,
      context: {uid: userId} # req.session
    }

  new Promise (resolve, reject) ->
    app.listen 8080, (err) -> if err then reject err else resolve()


module.exports = startServer

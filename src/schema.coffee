_ = require 'lodash'
{coroutine} = require 'bluebird'
{createListingSpaces, deleteListingSpaces, getListing, getListingSpaces} = require './helpers'
graphql = require 'graphql'
hooks = require './hooks'
permissions = require './permissions'
integratePermissionsAndHooks = require './integrate_permissions_and_hooks'


listingSpaceModel = new graphql.GraphQLObjectType
  name: 'listingSpace'
  fields:
    index:
      type: graphql.GraphQLString
    suite:
      type: graphql.GraphQLString


listingModel = new graphql.GraphQLObjectType
  name: 'listing'
  fields:
    id:
      type: graphql.GraphQLString
    ownerId:
      type: graphql.GraphQLString
    name:
      type: graphql.GraphQLString
    spaces:
      type: new graphql.GraphQLList(listingSpaceModel)
      resolve: (listing) ->
        getListingSpaces listing.id



listingSpaceInputModel = new graphql.GraphQLInputObjectType
  name: 'listingSpaceInput'
  fields:
    index:
      type: graphql.GraphQLInt
    suite:
      type: graphql.GraphQLString


listingInputModel = new graphql.GraphQLInputObjectType
  name: 'listingInput'
  fields:
    name:
      type: graphql.GraphQLString
    spaces:
      type: new graphql.GraphQLList(listingSpaceInputModel)


getListingConfig =
  type: listingModel
  name: 'getListing'
  args:
    id:
      type: graphql.GraphQLString
  resolve: coroutine (source, args) ->
    yield getListing args.id


updateListingConfig =
  type: listingModel
  name: 'updateListing'
  args:
    id:
      type: graphql.GraphQLString
    data:
      type: listingInputModel
  resolve: coroutine (source, args) ->
    listing = yield getListing args.id
    throw new Error 'Invalid listing id' unless listing
    _.assign listing, _.omit(args.data, ['spaces'])
    yield deleteListingSpaces listing.id
    yield createListingSpaces listing.id, args.data.spaces
    listing


queryObjectTypeConfig =
  name: 'query'
  fields:
    getListing: getListingConfig


mutationObjectTypeConfig =
  name: 'mutation'
  fields:
    updateListing: updateListingConfig


query = new graphql.GraphQLObjectType integratePermissionsAndHooks(queryObjectTypeConfig, permissions, hooks)
mutation = new graphql.GraphQLObjectType integratePermissionsAndHooks(mutationObjectTypeConfig, permissions, hooks)
schema = new graphql.GraphQLSchema {query, mutation}


module.exports = schema

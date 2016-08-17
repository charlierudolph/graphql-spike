# Fake asynchronous services

{listings, listingSpaces, userDelegates} = require './data'
_ = require 'lodash'


createListingSpaces = (listingId, spaces) ->
  _.forEach spaces, (space, index) ->
    listingSpaces.push _.assign {index, listingId}, space
  Promise.resolve()


deleteListingSpaces = (listingId) ->
  _.remove listingSpaces, (space) -> space.listingId is listingId
  Promise.resolve()


getListing = (listingId) ->
  listing = _.find listings, ({id}) -> id is listingId
  Promise.resolve listing


getListingSpaces = (listingId) ->
  spaces = _.chain listingSpaces
    .filter (space) -> space.listingId is listingId
    .sortBy 'index'
    .value()
  Promise.resolve spaces


getUserDelegateIds = (userId) ->
  delegateIds = _.chain userDelegates
    .filter (userDelegate) -> userDelegate.userId is userId
    .map (userDelegate) -> userDelegate.delegateId
    .value()
  Promise.resolve delegateIds


module.exports = {
  createListingSpaces
  deleteListingSpaces
  getListing
  getListingSpaces
  getUserDelegateIds
}

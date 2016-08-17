{coroutine} = require 'bluebird'
{getListing, getUserDelegateIds} = require './helpers'


# Functions per query/mutation that return whether or not the query/mutation is authorized
# If no function is defined for the query/mutation, it is by default authorized
#
# Parameters - same as passed to the query/mutation resolve function
# Return - a boolean or a Promise that resolves to a boolean
#          true = authorized, false = unauthorized


canUserEditListing = coroutine (listing, userId) ->
  return true if listing.ownerId is userId
  delegateIds = yield getUserDelegateIds listing.ownerId
  userId in delegateIds


module.exports =

  updateListing: coroutine (source, args, session) ->
    listing = yield getListing args.id
    yield canUserEditListing listing, session.uid

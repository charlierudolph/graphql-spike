# Functions per query/mutation that are run after successful resolution
#   these functions do not block the request from returning
#
# Parameters - same as passed to the query/mutation resolve function
# Return - undefined or a promise if asynchronous
#
# Must also specify an `onError` function that will be called if any hook
#   throws or returns a promise which rejects


module.exports =

  onError: (err) ->
    console.log 'Hook Error:\n', err.stack or err

  updateListing: (source, args, session, info) ->
    new Promise (resolve, reject) ->
      setTimeout ->
        reject(new Error('the end is nigh'))
      , 100

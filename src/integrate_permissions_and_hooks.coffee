_ = require 'lodash'
Promise = require 'bluebird'
{coroutine} = Promise


runHook = coroutine ({args, context, hook, info, onHookError, source}) ->
  try
    yield Promise.resolve hook(source, args, context, info)
  catch error
    onHookError error


wrapResolve = ({authorize, fn, hook, onHookError}) ->
  coroutine (source, args, context, info) ->
    if authorize
      authorized = yield Promise.resolve authorize(source, args, context, info)
      throw new Error 'Unauthorized' unless authorized
    result = yield Promise.resolve fn(source, args, context, info)
    if hook
      runHook {args, context, hook, info, onHookError, source}
    result


wrapResolves = (queryObjectConfig, permissions, hooks) ->
  _.each queryObjectConfig.fields, (fieldConfig, fieldName) ->
    fieldConfig = fieldConfig() if typeof fieldConfig is 'function'
    return unless fieldConfig.resolve and (permissions[fieldName] or hooks[fieldName])
    fieldConfig.resolve = wrapResolve {
      authorize: permissions[fieldName]
      fn: fieldConfig.resolve
      hook: hooks[fieldName]
      onHookError: hooks.onError
    }
  queryObjectConfig


module.exports = wrapResolves

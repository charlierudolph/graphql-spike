# Fake database

userDelegates = [
  delegateId: 'user3'
  userId: 'user1'
,
  delegateId: 'user4'
  userId: 'user1'
,
  delegateId: 'user5'
  userId: 'user2'
]


listings = [
  id: 'listing1'
  ownerId: 'user1'
  name: 'Foo'
,
  id: 'listing2'
  ownerId: 'user2'
  name: 'Bar'
]


listingSpaces = [
  index: 0
  listingId: 'listing1'
  suite: 'A'
,
  index: 1
  listingId: 'listing1'
  suite: 'B'
]


module.exports = {listings, listingSpaces, userDelegates}

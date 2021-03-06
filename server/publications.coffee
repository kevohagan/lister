Meteor.publish 'lists', (username) ->
  List.find(username: username)

Meteor.publish 'contributedLists', (username) ->
  items = Item.find(
    {itemUsername: username}
  ).fetch()

  listIds = _.uniq(_.pluck(items, 'listId'))

  List.find(
    {_id: { $in: listIds }}
  )

 Meteor.publish 'currentList', (listId) ->
  List.find(_id: listId)

Meteor.publish 'items', (listId) ->
  Item.find(listId: listId)

LIMIT = 20

Meteor.publish 'recentLists', (query) ->
  if query
    Item.find({$or: [
        {text: {$regex: query, $options: 'i'}},
        {listName: {$regex: query, $options: 'i'}}
      ]}, {sort: {createdAt: -1}, limit: LIMIT})
  else
    List.find({}, {sort: {updatedAt: -1}, limit: LIMIT})

Meteor.publish 'recentItems', () ->
  ids = _.pluck(List.where({}, {sort: {updatedAt: -1}, limit: LIMIT, fields: {id: 1}}), 'id')

  Item.find({listId: {$in: ids}})

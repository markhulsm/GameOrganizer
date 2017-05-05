Mongo   = require('mongodb').MongoClient
Promise = require 'promise'
config  = require 'config'

class MongoClient

  @db         = null
  @collection = null
  @events     = null

  constructor: (url) ->
    if !url
      @url = process.env.MONGOLAB_URI || config.get 'mongo.url'
      return
    @url = url

  connect: () ->
    promise = new Promise (resolve, reject) =>
      console.log @url
      Mongo.connect @url, (err, db) =>
        if err is null
          @collection = db.collection 'users'
          @events = db.collection 'events'
          resolve db
        else
          db.close()
          reject()

  userExists: (userId) =>
    promise = new Promise (resolve, reject) =>
      @collection.find({ id: userId }).toArray (err, docs) =>
        resolve docs.length > 0

  saveUser: (user) ->
    promise = new Promise (resolve, reject) =>
      @userExists(user.id).then (res) =>

        console.log res

        if res
          return resolve user

        userObj =
          id        : user.id
          name      : user.name
          real_name : user.real_name
          tz        : user.tz
          tz_offset : user.tz_offset
          image_48  : user.profile.image_48

        console.log "save user"
        console.log userObj

        @collection.insert userObj, (err, result) ->
          if err is null
            resolve result
          else
            reject()

  saveUserStatus: (userId, status) ->
    promise = new Promise (resolve, reject) =>

      user =
        id: userId

      update =
        $push:
          activity:
            status: status
            timestamp: Date.now()

      @collection.update user, update, (err, result) =>
        if err isnt null
          return reject()
        resolve result

  saveUserFeedback: (userId, feedback) ->
    promise = new Promise (resolve, reject) =>

      user =
        id: userId

      update =
        $push:
          feedback:
            status: feedback
            timestamp: Date.now()

      @collection.update user, update, (err, result) =>
        if err isnt null
          return reject()
        resolve result

  saveUserFeedbackMessage: (userId, feedbackMessage) ->
    promise = new Promise (resolve, reject) =>
      @getLatestUserTimestampForProperty('feedback', userId).then (res) =>

        find =
          id: userId
          feedback:
            $elemMatch:
              timestamp: res

        update =
          $set:
            'feedback.$.message': feedbackMessage

        @collection.update find, update, (err, result) =>
          if err isnt null
            return reject()
          resolve result

  getUserData: (userId) ->
    promise = new Promise (resolve, reject) =>
      @collection.find({ id: userId }).toArray (err, docs) =>

        if err isnt null
          return reject()

        if docs.length is 0
          return resolve false

        resolve docs[0]

  getLatestUserFeedback: (userId) ->
    promise = new Promise (resolve, reject) =>
      @collection.find({ id: userId }).toArray (err, docs) =>

        if err isnt null
          return reject()

        if docs.length is 0
          return resolve false

        if !docs[0].hasOwnProperty 'feedback'
          return resolve null

        timestamp = 0
        feedback = null

        # get latest message according to timestamp
        for obj in docs[0].feedback
          if obj.timestamp > timestamp
            timestamp = obj.timestamp
            feedback = obj

        resolve feedback

  getAllUserFeedback: (userIds) ->
    promise = new Promise (resolve, reject) =>
      @collection.find({ id: { $in: userIds } }).toArray (err, docs) =>

        if err isnt null
          reject()

        users = docs.map (elem) ->
          feedback = null
          if elem.feedback
            elem.feedback.sort (a, b) ->
              a.timestamp > b.timestamp
            feedback = elem.feedback.pop()

          res =
            id: elem.id
            feedback: feedback

        resolve users

  getUserFeedbackCount: (userId, date) ->
    promise = new Promise (resolve, reject) =>
      @collection.find({ id: userId }).toArray (err, docs) =>

        if err isnt null
          return reject()

        if docs.length is 0
          return resolve false

        filtered = []
        day = date.getDate()
        month = date.getMonth()

        if docs[0].feedback
          filtered = docs[0].feedback.filter (feedback) ->
            date = new Date feedback.timestamp
            return (date.getDate() is day && date.getMonth() is month)
          return resolve filtered.length

        resolve(0)

  getLatestUserTimestampForProperty: (property, userId) ->
    promise = new Promise (resolve, reject) =>
      @collection.find({ id: userId }).toArray (err, docs) =>

        if err is not null
          return reject()

        if docs.length is 0
          return resolve false

        if !docs[0].hasOwnProperty property
          return resolve null

        docs[0][property].sort (a, b) ->
          a.timestamp > b.timestamp

        resolve docs[0][property].pop().timestamp

  getOnboardingStatus: (userId) ->
    promise = new Promise (resolve, reject) =>
      @collection.find({ id: userId }).toArray (err, docs) =>

        if err is not null
          return reject()

        if docs.length is 0
          return resolve false

        if !docs[0].hasOwnProperty 'onboarding'
          return resolve 0

        resolve docs[0].onboarding

  setOnboardingStatus: (userId, status) ->
    promise = new Promise (resolve, reject) =>

        find =
          id: userId

        update =
          $set:
            'onboarding': status

        @collection.update find, update, (err, result) =>
          if err is null
            resolve result
          else
            reject()

  saveEvent: (event) ->
    promise = new Promise (resolve, reject) =>
      eventObj =
        name      : event.name
        startDate : event.date
        recur     : event.recur

      console.log "save event"
      console.log eventObj

      @events.insert eventObj, (err, result) ->
        if err is null
          resolve result
        else
          reject()

  getEvents: () ->
    promise = new Promise (resolve, reject) =>
      @events.find().toArray (err, docs) =>

        console.log err, docs

        if err isnt null
          reject()

        filtered = []
        today = new Date
        day = today.getDate()
        month = today.getMonth()
        year = today.getYear()

        console.log docs

        if docs[0]
          filtered = docs.filter (doc) ->
            date = new Date doc.startDate
            console.log date, day, month, year, (date.getDate() is day && date.getMonth() is month && date.getYear() is year)
            return (date.getDate() is day && date.getMonth() is month && date.getYear() is year)
          return resolve filtered

        resolve docs

  saveEventAttendance: (userId, event, response) ->
    promise = new Promise (resolve, reject) =>
      if !event.attendance
        event.attendance = []

      found = false
      event.attendance.forEach (att) ->
        if(att.userId = userId)
          att.response = response
          found = true

      if !found
        event.attendance.push {userId : userId, response : response}

      @events.save event, (err, result) ->
        if err is null
          resolve result
        else
          reject()


  getEventAttendanceCount: (eventName) ->
    promise = new Promise (resolve, reject) =>
      @events.find({ name: eventName }).toArray (err, docs) =>

        if err isnt null
          return reject()

        if docs.length is 0
          return resolve 0

        if docs[0].feedback
          return resolve docs[0].feedback.lenth

        resolve(0)

module.exports = MongoClient

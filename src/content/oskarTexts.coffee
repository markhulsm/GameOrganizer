# needed in order to do string replacement
String.prototype.format = ->
  args = arguments
  return this.replace /{(\d+)}/g, (match, number) ->
    return if typeof args[number] isnt 'undefined' then args[number] else match

OskarTexts =
  statusText:
    '1': 'pretty bad'
    '2': 'a bit down'
    '3': 'alright'
    '4': 'really good'
    '5': 'awesome'

  introduction: "Hey {0}! Let me quickly introduce myself.\nMy name is Oskar, and the team has drafted me in to help organize events in Slack.  Ready? *Just reply to this message and we'll give us a try* :smile:"

  firstMessage: "Alright! Let me know when you are coming to my events in the future.'\n\nYou can reply to me with Yes or No I'll keep track of your answers so that other people know how many are coming.\n\nOK?"

  firstMessageSuccess: "That was easy, wasn't it?"

  firstMessageFailure: "Whoops, it looks like you're trying to answer me, but unfortunately I only understand Yes and No. Can you give it another go?"

  requestFeedback:
    random: [
      "Hey {0}, Are you coming to the {1} event at {2}? Let me know and I'll share who is coming.\n",
      "Hello, me again! Just checking in to see if you are coming to {1} at {2}?\n",
    ]
    selection: ""
    options: [
      "Perhaps you missed my last message... I'd really love to hear how you're doing. Would you mind letting me know?"
      "Hey, looks like you missed me last time, but if you can give me a number between 1-5 to let me know how you feel, I'll be on my way :smile:"
    ]

  faq: "Looks like you need a little help. Here's the link to the <http://oskar.herokuapp.com/faq|Oskar FAQ>"

  revealChannelStatus:
    error: "*{0}* hasn\'t submitted a status yet."
    status: "*{0}* is feeling *{1}/5*"
    message: "\n>\"{0}\""

  revealUserStatus:
    error: "Oh, it looks like I haven\'t heard from {0} for a while. Sorry!"
    status: "*{0}* is feeling *{1}/5*"
    message: "\n>\"{0}\""

  newUserFeedback: "*{0}* is feeling *{1}/5*\n>\"{2}\""

  alreadySubmitted: [
    "Oops, looks like you've already told me how you feel in the last couple of hours. Let's check in again later.",
    "Oh, hey there! I actually have some feedback from you already, in the last 4 hours. Let's leave it a little longer before we catch up :smile:",
    "Easy, tiger! I know you love our number games, but let\'s wait a bit before we play again! I'll ping you in a few hours to see how you're doing."
  ]

  invalidInput: [
    "Oh! I'm not sure what you meant, there.  I only understand Yes and No. Do you mind phrasing that a little differently?",
    "I\'d really love to understand what you\'re saying, but until I become a little more educated, I'll need you to stick to using Yes and No."
  ]

  lowFeedback: [
    "That sucks. I was really hoping you'd be feeling a little better than that. *Is there anything I should know?*",
    "Oh dear :worried: I'm having a rough day over here too... :tired_face: *Wanna tell me a little more?* Perhaps one of our teammates will be able to help out.",
    "Ah, man :disappointed: I really hate to hear when a friend is having a rough time. *Wanna explain a little more?* "
  ]

  averageFeedback: [
    "Alright! Go get em :tiger: *If you've got something you want to share, feel free. If not, have a grrreat day!*",
    "Good luck with powering through things. *If you've got something you want to share, feel free.*",
    "That's alright. We can't all be having crazy highs and killer lows. *If you feel like telling me more, feel free!*"
  ]

  highFeedback: [
    ":trophy: Winning! It's so great to hear that. *Why not type a message to let your team know why things are going so well?*",
    ":thumbsup: looks like you're on :fire: today. *Is there anything you'd like to share with the team?*",
    "There's nothing I like more than great feedback! :clap::skin-tone-4: *What's made you feel so awesome today?*"
  ]

  # feedback already received
  feedbackReceived: [
    "Thanks a lot, buddy! Keep up the good work!",
    "You\'re a champion. Thanks for the response and have a great day!",
    "That\'s really helpful. I wish you good luck with everything today!"
  ]

  # feedback received
  feedbackMessageReceived: [
    "Thanks for sharing with me, my friend. Let's catch up again soon.",
    "Thanks for being so open! Let's catch up in a few hours.",
    "Gotcha. I've pinged that message to the rest of the team."
  ]

  eventCreated: "Thanks for creating that event, I will notify people about it"

  eventCreatedChannel: "{0} created an event called \"{1}\" at {2}"

  eventAttendance: "{0} people are coming to the event {1}"

  upcomingEvent: "{0} is today at {1}"

  noEvent: "Sorry I couldn't find an event for today"

module.exports = OskarTexts

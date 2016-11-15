# katter

This Kata is to create a small service in the FP language and framwork of your choice. There are two REST endpoints to be exposed but feel free to make the service as feature rich as you like!

The service will be a stripped down version of Twitter. It is up to you to go as far with the implementation as you like. This can include a DB or just an in memory store of some sort.

You can even add a UI if you like, or, you could build solely a UI to consume this REST service in the FP language and framework of your choice. 
e.g Elm, Clojurescript, Purescript.

During our meetup, we can have some fun connecting up UI implementations to different service implementations.

The REST service should support the following 2 endpoints with related JSON structures:

Post a message from a User

POST HOSTNAME/katter/messsges
JSON Body
```javascript
{
 "username": "priort",
 "message": "a humorous tweet"
 "mensions": ["jcretel", "dodonovan"] // this is optional to be used if you want to add an endpoint to retrieve all mentions of a username.
}
```
Retrieve all messages that were posted by a user

JSON Response
200
```javascript
{
  "messasgeId" : 12
}
```

GET HOSTNAME/katter/messages?username="priort"
JSON Response 200
```javascript
[
{
 "username": "priort",
 "message": "a humorous tweet 1"
 "mensions": ["enoonan"], // this is optional to be used if you want to add an endpoint to retrieve all mentions of a username.
},
{
 "username": "priort",
 "message": "a humorous tweet 2"
 "mensions": ["hmurphy", "jdillon"], // this is optional to be used if you want to add an endpoint to retrieve all mentions of a username.
},
{
 "username": "priort",
 "message": "a humorous tweet 3"
 "mensions": ["bobrien"], // this is optional to be used if you want to add an endpoint to retrieve all mentions of a username.
}
]
```

Add any more endpoints you like.
For example and endpoint that gets all messages that a user was mentioned in.
HOSTNAME/katter/messasges?mentioned="priort"

JSON Response 200
```javascript
[
{
 "username": "enoonan",
 "message": "a humorous tweet 1"
 "mensions": ["priort", "bobrien"], // this is optional to be used if you want to add an endpoint to retrieve all mentions of a username.
},
{
 "username": "hmurphy",
 "message": "a humorous tweet 2"
 "mensions": ["priort", "enoonan"], // this is optional to be used if you want to add an endpoint to retrieve all mentions of a username.
}
]
```


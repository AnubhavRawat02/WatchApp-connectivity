
DATA TRANSFER BETWEEN IPHONE AND APPLE WATCH. 


immediate messaging only works when watch app is also active. check that by using isReachable property of session. if the app is closed, it wont update after opening the app. 

updating context is only possible when session is activated. It also allows us to get the error while sending the data. if the app is closed, the context will be updated when the app is opened again. 

transfer user info is by far the best method. It works on background thread. it also requires the session to be activated. if the app is closed, user info will be updated when the app is opened again. 



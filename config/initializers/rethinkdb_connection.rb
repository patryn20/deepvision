require 'lovelyrethink'

#this is not threadsafe and the connection can go away before the next request is processed
#@TODO need to extend lovelyrethink to detect connection failures and reconnect
#@TODO also need to extend the object to run the queries with the connection included automatically
#@TODO maybe something like LovelyRethink.run(@r.table().order.blah)
LovelyRethink.configure 'rethinkdb://localhost:28015/deepvision'
# test.py
def application(env, start_response):
    start_response('200 OK', [('Content-Type','text/html')])
    import time
    timestamp = int(time.time())
    return str(timestamp)

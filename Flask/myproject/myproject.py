from flask import Flask
application = Flask(__name__)

@application.route("/")
def application(env, start_response):
    start_response('200 OK', [('Content-Type','text/html')])
    import time
    timestamp = int(time.time())
    return str(timestamp)

if __name__ == "__main__":
    application.run(host='0.0.0.0')


from flask import Flask

app = Flask(__name__)

@app.route('/')
def index():
	mytext = "<h1>Andersen DevOps cource</h1><h2>exam</h2><p>Hello world 1</p>"
	return mytext

if __name__ == "__main__":
    app.run(host= '0.0.0.0')

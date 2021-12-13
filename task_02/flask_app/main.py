from flask import Flask

app = Flask(__name__)

@app.route('/')
def index():
	mytext = "<h1>task_02:</h1> <h2>Hello DevOps!</h2> <p>This is a simple phyton3 + flask application made by Albert Fedorovsky! :-)</p>"
	return mytext

if __name__ == "__main__":
    app.run(host= '0.0.0.0')

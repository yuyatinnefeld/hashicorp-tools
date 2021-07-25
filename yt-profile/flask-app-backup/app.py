from flask import Flask, render_template

app = Flask(__name__)

@app.route("/")
def home():
    return render_template("index.html")
        
@app.route("/project")
def salvador():
    return render_template("project.html")
            
if __name__ == "__main__":
    #app.run(debug=True)
    #app.run(host='127.0.0.1', port=5000, debug=True)
    app.run(host="0.0.0.0")

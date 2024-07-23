from flask import Flask
from flask import send_from_directory
from os import listdir
from os.path import isfile, join, exists

app = Flask(__name__)

app.config['WORLDS_FOLDER'] = 'Worlds'

@app.route("/")
def hello_world():
    return "<p>Hello, World!</p>"

@app.route("/worlds/<path:name>")
def download_file(name):
    return send_from_directory(
        app.config['WORLDS_FOLDER'], name
    )

@app.route("/get_texture_file_list/<username>/<world_name>")
def get_texture_file_list(username, world_name):
    path = "./"+ app.config['WORLDS_FOLDER'] + "/"+username+"/"+world_name+"/"+"mainScene/textures"
    if exists(path):
      return listdir(path)
    
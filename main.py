from flask import Flask
from flask import abort
from flask import make_response
from flask import redirect
from flask import render_template
from flask import request
from flask import session
from pathlib import Path
from werkzeug.utils import secure_filename
import os
import uuid

app = Flask(__name__)

@app.route("/")
def welcome():
    return render_template("welcome.html")

@app.route("/start")
def start():
    return render_template("record.html")

@app.route('/upload', methods=['POST'])
def upload():
    word = request.args.get('word')
    audio_data = request.data
    filename = word + '_' + uuid.uuid4().hex + '.ogg'
    secure_name = os.path.join("oggs", word, secure_filename(filename))
    Path(os.path.join("oggs", word)).mkdir(parents=True, exist_ok=True)
    with open(secure_name, 'wb') as f:
       f.write(audio_data)
    return make_response('All good')

# CSRF protection, see http://flask.pocoo.org/snippets/3/.
@app.before_request
def csrf_protect():
    if request.method == "POST":
        token = session['_csrf_token']
        if not token or token != request.args.get('_csrf_token'):
            abort(403)

def generate_csrf_token():
    if '_csrf_token' not in session:
        session['_csrf_token'] = uuid.uuid4().hex
    return session['_csrf_token']

app.jinja_env.globals['csrf_token'] = generate_csrf_token

# Change this to your own number before you deploy.
app.secret_key = '01010101' #uuid.uuid4().hex

if __name__ == "__main__":
    app.run(debug=True)

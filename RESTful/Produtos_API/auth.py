from flask_httpauth import HTTPBasicAuth
from werkzeug.security import check_password_hash

auth = HTTPBasicAuth()

password = "senha_teste"

users = {
  "admin": "pbkdf2:sha256:600000$UrJU40qkk4quCnZN$7b2b5fbb3d5af80997da442ffa30546359e8a5bf392925dfaf90687460b87a22"
}

@auth.verify_password
def verify_password(username, password):
    if username in users:
        return check_password_hash(users.get(username), password)
    return False

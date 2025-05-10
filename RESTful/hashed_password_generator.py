from werkzeug.security import generate_password_hash

plain = "senha_teste"
hashed = generate_password_hash(plain, method="pbkdf2:sha256")
print(hashed)
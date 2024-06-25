# -*- coding: utf-8 -*-
import pickle
from cryptography.fernet import Fernet
import base64
from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC
from cryptography.hazmat.primitives import hashes
import sys
import types

def generate_key(password: str, salt: bytes) -> bytes:
    # Derive a key from the password and salt using PBKDF2
    kdf = PBKDF2HMAC(
        algorithm=hashes.SHA256(),
        length=32,
        salt=salt,
        iterations=100000,
    )
    key = base64.urlsafe_b64encode(kdf.derive(password.encode()))
    return key

def decrypt_data(encrypted_data: bytes, key: bytes) -> bytes:
    fernet = Fernet(key)
    return fernet.decrypt(encrypted_data)

def decrypt_and_run(pkl_file_path: str, password: str):
    # Read the salt and encrypted data from the .pkl file
    with open(pkl_file_path, 'rb') as file:
        salt = file.read(16)
        encrypted_data = file.read()

    # Generate a key from the password and salt
    key = generate_key(password, salt)

    # Decrypt the data
    decrypted_data = decrypt_data(encrypted_data, key)

    # Unpickle the data
    code = pickle.loads(decrypted_data)

    # Create a new module
    module_name = "decrypted_module"
    decrypted_module = types.ModuleType(module_name)
    
    # Execute the code within the module's namespace
    exec(code, decrypted_module.__dict__)

    # Optionally, you can import the module into the current namespace if needed
    sys.modules[module_name] = decrypted_module

    # If the script has an entry point (like a function to start the bot), call it here
    # Example: if the script has a function `main()`, call `decrypted_module.main()`
    # decrypted_module.main()

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python decrypt_and_run.py <pkl_file_path> <password>")
        sys.exit(1)

    pkl_file_path = sys.argv[1]
    password = sys.argv[2]

    # Decrypt, unpickle, and run the file
    decrypt_and_run(pkl_file_path, password)

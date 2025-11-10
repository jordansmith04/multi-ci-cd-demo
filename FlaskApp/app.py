import os
from flask import Flask

app = Flask(__name__)

# Environment variable for dynamic message display
APP_VERSION = os.environ.get('APP_VERSION', '1.0.0')

@app.route('/')
def home():
    """
    Returns a simple message indicating the successful deployment 
    and the application version.
    """
    return (
        f'<div style="font-family: sans-serif; text-align: center; padding: 50px; background: #f0f4f8; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">'
        f'<h1 style="color: #1e40af;">CI/CD Pipeline Demo</h1>'
        f'<p style="font-size: 1.2rem; color: #374151;">'
        f'The Flask application is running successfully inside a Docker container.'
        f'</p>'
        f'<p style="font-size: 1.5rem; color: #b91c1c; font-weight: bold;">'
        f'Version: {APP_VERSION}'
        f'</p>'
        f'<p style="margin-top: 30px; color: #6b7280;">'
        f'This is Project 2 for the SRE/DevOps Portfolio.'
        f'</p>'
        f'</div>'
    )

if __name__ == '__main__':
    # Running the app on port 8080 as is common in container environments
    app.run(host='0.0.0.0', port=8080)
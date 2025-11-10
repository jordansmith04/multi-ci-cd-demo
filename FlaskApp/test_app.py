import unittest
# Import the Flask application object from the app.py file
from app import app

class AppTestCase(unittest.TestCase):
    """
    Test case for the core functionality of the Flask application.
    This ensures the application loads, the main route is accessible, 
    and the expected content is present.
    """

    def setUp(self):
        """
        Set up the test client and context before each test runs.
        """
        # Create a test client for the application
        self.app = app.test_client()
        # Propagate exceptions to the test client
        self.app.testing = True

    def test_home_page_status(self):
        """
        Test that the home page ('/') loads successfully (HTTP 200).
        """
        print("Running: test_home_page_status")
        response = self.app.get('/')
        self.assertEqual(response.status_code, 200, "Home page did not return HTTP 200 OK.")

    def test_home_page_content(self):
        """
        Test that the home page contains the expected signature text.
        """
        print("Running: test_home_page_content")
        response = self.app.get('/')
        # Decode response data and assert a key phrase is present
        content = response.data.decode('utf-8')
        self.assertIn('CI/CD Pipeline Demo', content, "Title text missing from home page content.")
        self.assertIn('The Flask application is running successfully', content, "Confirmation message missing.")

    def test_app_version_display(self):
        """
        Test that the application version is displayed, checking the default value.
        """
        print("Running: test_app_version_display")
        response = self.app.get('/')
        content = response.data.decode('utf-8')
        # Check for the default version defined in app.py
        self.assertIn('Version: 1.0.0', content, "Default app version '1.0.0' not found.")


if __name__ == '__main__':
    unittest.main()
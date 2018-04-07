from hello_app import hello
import unittest

class HelloTestCase(unittest.TestCase):

    def test_hello(self):
        response = hello.app.test_client().get('/')
        assert b'Hello world!' in response.data

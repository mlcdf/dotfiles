import argparse
import smtplib
import ssl
import os

def env_or_raise(key: str):
    try:
        return os.environ[key]
    except KeyError:
        print(f"{key} not found in env")

def env_or_default(key: str, default: str):
    try:
        return os.environ[key]
    except KeyError:
        pass

    return default


port = 465 # For SSL
password = env_or_raise("MAIL_MAILBOX_PASSWORD")
login = env_or_raise("MAIL_MAILBOX_LOGIN")

sender_email = env_or_default("MAIL_SENDER", "")
receiver_email = ""
message = """\
Subject: Hi there

This message is sent from Python."""

# Create a secure SSL context
context = ssl.create_default_context()

with smtplib.SMTP_SSL("mail.gandi.net", port, context=context) as server:
    server.login(login, password)
    server.sendmail(sender_email, receiver_email, message)

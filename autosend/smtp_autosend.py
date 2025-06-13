#!/usr/bin/env python3
import os,time,json,smtplib,ssl,pathlib
from email.message import EmailMessage
from dotenv import load_dotenv

BASE  = pathlib.Path.home()/ "orion_guard"
QUEUE = BASE/"autosend"/"queue.json"
LOG   = BASE/"logs"/"smtp_autosend.out"

load_dotenv(BASE/".env_orion_guard")
USER=os.getenv("EMAIL_USER"); PASS=os.getenv("EMAIL_PASS")
SMTP=os.getenv("SMTP_HOST","smtp.gmail.com"); PORT=int(os.getenv("SMTP_PORT","465"))

LINKS={"19":"https://github.com/Kneo1984/orion_guard/releases/download/v1.0/orion_guard_community.deb",
      "49":"https://github.com/Kneo1984/orion_guard/releases/download/v1.0/orion_guard_1.0.deb",
     "149":"https://github.com/Kneo1984/orion_guard/releases/download/v1.0/orion_guard_release_package.zip"}

def log(m):
    with open(LOG,"a",encoding="utf-8") as f:
        f.write(f"{time.strftime('%F %T')}  {m}\n")
    print(m,flush=True)

def send(to,lvl):
    msg=EmailMessage(); msg["Subject"]=f"ORION GUARD – Zugang {lvl}"
    msg["From"]=USER; msg["To"]=to
    msg.set_content(f"Dein Link (Stufe {lvl}):\n\n{LINKS[lvl]}")
    ctx=ssl.create_default_context()
    with smtplib.SMTP_SSL(SMTP,PORT,context=ctx) as s:
        s.login(USER,PASS); s.send_message(msg)
    log(f"✅ Mail an {to} gesendet (Level {lvl})")

while True:
    if QUEUE.exists() and QUEUE.stat().st_size:
        data=json.loads(QUEUE.read_text("utf-8"))
        if data:
            e=data.pop(0); lvl=e["level"]; to=e["sender"]
            if lvl in LINKS: send(to,lvl)
            QUEUE.write_text(json.dumps(data,indent=2),"utf-8")
    time.sleep(15)

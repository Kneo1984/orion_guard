#!/usr/bin/env python3
import os,time,ssl,json,re,imaplib,email,pathlib
from email.header import decode_header
from dotenv import load_dotenv

BASE=pathlib.Path.home()/ "orion_guard"
QUEUE=BASE/"autosend"/"queue.json"
LOG  =BASE/"logs"/"imap_watch.out"

load_dotenv(BASE/".env_orion_guard")
USER=os.getenv("EMAIL_USER"); PASS=os.getenv("EMAIL_PASS")
IMAP=os.getenv("IMAP_HOST","imap.gmail.com")

def log(m):
    with open(LOG,"a",encoding="utf-8") as f:
        f.write(f"{time.strftime('%F %T')}  {m}\n")
    print(m,flush=True)

def parse_lvl(s): 
    m=re.search(r"Zugang\s*(\d+)",s); return m.group(1) if m else None
def save_q(e):
    data=json.loads(QUEUE.read_text("utf-8")) if QUEUE.exists() else []
    data.append(e); QUEUE.write_text(json.dumps(data,indent=2),"utf-8")

def main():
    ctx=ssl.create_default_context()
    with imaplib.IMAP4_SSL(IMAP,993,ssl_context=ctx) as m:
        m.login(USER,PASS); log("📥 IMAP-Login ok")
        while True:
            m.select("INBOX"); _,ids=m.search(None,"(UNSEEN)")
            for num in ids[0].split():
                _,d=m.fetch(num,"(RFC822)")
                msg=email.message_from_bytes(d[0][1])
                subj=decode_header(msg["Subject"])[0][0]
                subj=subj.decode() if isinstance(subj,bytes) else subj
                lvl=parse_lvl(subj or "")
                if lvl:
                    sender=email.utils.parseaddr(msg["From"])[1]
                    save_q({"sender":sender,"level":lvl})
                    log(f"➡️  Bestellung {sender}  Level {lvl}")
                m.store(num,"+FLAGS","\\Seen")
            time.sleep(30)
if __name__=="__main__":
    try: main()
    except Exception as e: log(f"❌ IMAP-Fehler: {e}")

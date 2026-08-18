import os
from dotenv import load_dotenv
from supabase import create_client, Client

load_dotenv()

# Pure Supabase Production Cloud Initialization
SUPABASE_URL = os.getenv("SUPABASE_URL", "https://zvrgniyqgubooaniallx.supabase.co")
SUPABASE_KEY = os.getenv("SUPABASE_KEY", "sb_publishable_MLF1JYN2SwmnuIYbx2Skig_RBLLI65B")

if not SUPABASE_URL or not SUPABASE_KEY:
    raise RuntimeError("SUPABASE_URL and SUPABASE_KEY must be configured in environment.")

supabase_client: Client = create_client(SUPABASE_URL, SUPABASE_KEY)

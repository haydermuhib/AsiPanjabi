import os
from typing import Optional, List
from fastapi import FastAPI, HTTPException, status, Request
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
from fastapi.responses import HTMLResponse, JSONResponse
from pydantic import BaseModel, EmailStr

from app.database import supabase_client

app = FastAPI(title="AsiPanjabi - Modern Panjabi Learning Portal")

# Static files & templates
static_dir = os.path.join(os.path.dirname(__file__), "..", "static")
templates_dir = os.path.join(os.path.dirname(__file__), "..", "templates")

os.makedirs(static_dir, exist_ok=True)
os.makedirs(templates_dir, exist_ok=True)

app.mount("/static", StaticFiles(directory=static_dir), name="static")
templates = Jinja2Templates(directory=templates_dir)

def render_template(request: Request, name: str, context: dict = None):
    if context is None:
        context = {}
    context["request"] = request
    return templates.TemplateResponse(request=request, name=name, context=context)

# --- Pydantic Schemas ---
class UserRegister(BaseModel):
    email: EmailStr
    password: str
    full_name: str

class UserLogin(BaseModel):
    email: EmailStr
    password: str

# --- Pure Supabase Cloud REST API Endpoints ---
@app.get("/api/categories")
def get_categories():
    res = supabase_client.table("categories").select("*").order("display_order").execute()
    categories = []
    for c in (res.data or []):
        categories.append({
            "id": c["id"],
            "title": c["title"],
            "slug": c["slug"],
            "description": c.get("description", ""),
            "image_url": c.get("image_url", "")
        })
    return categories

@app.get("/api/categories/{slug}")
def get_category_detail(slug: str):
    # Fetch Category
    cat_res = supabase_client.table("categories").select("*").eq("slug", slug).execute()
    if not cat_res.data or len(cat_res.data) == 0:
        raise HTTPException(status_code=404, detail="Category not found")
    c = cat_res.data[0]
    category_id = c["id"]

    # Fetch lessons & nested vocabularies for this category
    less_res = supabase_client.table("lessons").select("*, vocabularies(*)").eq("category_id", category_id).order("display_order").execute()
    vocabularies = []
    for l in (less_res.data or []):
        for v in l.get("vocabularies", []):
            vocabularies.append(v)

    return {
        "id": c["id"],
        "title": c["title"],
        "slug": c["slug"],
        "description": c.get("description", ""),
        "image_url": c.get("image_url", ""),
        "vocabularies": vocabularies
    }

@app.post("/api/auth/register")
def register_user(data: UserRegister):
    auth_res = supabase_client.auth.sign_up({
        "email": data.email,
        "password": data.password,
        "options": {"data": {"full_name": data.full_name}}
    })
    if not auth_res.user:
        raise HTTPException(status_code=400, detail="Failed to create user account")
    
    token = auth_res.session.access_token if auth_res.session else "registered"
    return {
        "access_token": token,
        "token_type": "bearer",
        "user": {"email": auth_res.user.email, "full_name": data.full_name}
    }

@app.post("/api/auth/login")
def login_user(data: UserLogin):
    try:
        auth_res = supabase_client.auth.sign_in_with_password({"email": data.email, "password": data.password})
        if auth_res.user and auth_res.session:
            return {
                "access_token": auth_res.session.access_token,
                "token_type": "bearer",
                "user": {"email": auth_res.user.email, "full_name": auth_res.user.user_metadata.get("full_name", "Learner")}
            }
    except Exception as e:
        raise HTTPException(status_code=401, detail=str(e))
    raise HTTPException(status_code=401, detail="Invalid credentials")


# --- Page Route Handlers ---
@app.get("/", response_class=HTMLResponse)
def page_home(request: Request):
    categories = get_categories()
    return render_template(request, "index.html", {"categories": categories})

@app.get("/category/{slug}", response_class=HTMLResponse)
def page_category(request: Request, slug: str):
    category = get_category_detail(slug)
    return render_template(request, "category.html", {"category": category})

@app.get("/login", response_class=HTMLResponse)
def page_login(request: Request):
    return render_template(request, "login.html")

@app.get("/register", response_class=HTMLResponse)
def page_register(request: Request):
    return render_template(request, "register.html")

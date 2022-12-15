from dotenv import load_dotenv
from pathlib import Path
import os


# Build paths inside the project like this: BASE_DIR / 'subdir'.
BASE_DIR = Path(__file__).resolve().parent.parent
ENV_PATH = BASE_DIR / ".env"

if ENV_PATH.exists():
    """
    Load in the .env file
    If it exists
    """
    load_dotenv(str(ENV_PATH))

SECRET_KEY = os.environ.get("DJANGO_SECRET_KEY")

DEBUG = str(os.environ.get("DJANGO_DEBUG")) == "1"

ALLOWED_HOSTS = [""]

# Domain name or other Github Action Host Value
ALLOWED_HOST = os.environ.get("ALLOWED_HOST", "127.0.0.1")
if ALLOWED_HOST:
    ALLOWED_HOSTS += [ALLOWED_HOST]

# Individual Web App Linode Host IP
WEBAPP_NODE_PRIVATE = os.environ.get("WEBAPP_NODE_PRIVATE")
if WEBAPP_NODE_PRIVATE:
    ALLOWED_HOSTS += [WEBAPP_NODE_PRIVATE]

# Linode Nodebalancer Host
LOAD_BALANCER_HOST = os.environ.get("LOAD_BALANCER_HOST")
if LOAD_BALANCER_HOST:
    ALLOWED_HOSTS += [LOAD_BALANCER_HOST]

# Linode Nodebalancer IP
LOAD_BALANCER_IP = os.environ.get("LOAD_BALANCER_IP")
if LOAD_BALANCER_IP:
    ALLOWED_HOSTS += [LOAD_BALANCER_IP]

INSTALLED_APPS = [
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "django.contrib.staticfiles",
    "django.contrib.humanize",
    # External apps
    "django_celery_beat",
    "django_celery_results",
]

MIDDLEWARE = [
    "django.middleware.security.SecurityMiddleware",
    "django.contrib.sessions.middleware.SessionMiddleware",
    "django.middleware.locale.LocaleMiddleware",
    "django.middleware.common.CommonMiddleware",
    "django.middleware.csrf.CsrfViewMiddleware",
    "django.contrib.auth.middleware.AuthenticationMiddleware",
    "django.contrib.messages.middleware.MessageMiddleware",
    "django.middleware.clickjacking.XFrameOptionsMiddleware",
]

ROOT_URLCONF = "django_project.urls"

TEMPLATES = [
    {
        "BACKEND": "django.template.backends.django.DjangoTemplates",
        "DIRS": [
            BASE_DIR / "templates",
        ],
        "APP_DIRS": True,
        "OPTIONS": {
            "context_processors": [
                "django.template.context_processors.debug",
                "django.template.context_processors.request",
                "django.contrib.auth.context_processors.auth",
                "django.contrib.messages.context_processors.messages",
            ],
        },
    },
]

WSGI_APPLICATION = "django_project.wsgi.application"

DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.sqlite3",
        "NAME": BASE_DIR / "db.sqlite3",
    }
}

from .db.postgres import *

AUTH_PASSWORD_VALIDATORS = [
    {
        "NAME": "django.contrib.auth.password_validation.UserAttributeSimilarityValidator",
    },
    {
        "NAME": "django.contrib.auth.password_validation.MinimumLengthValidator",
    },
    {
        "NAME": "django.contrib.auth.password_validation.CommonPasswordValidator",
    },
    {
        "NAME": "django.contrib.auth.password_validation.NumericPasswordValidator",
    },
]

LANGUAGE_CODE = "de"

TIME_ZONE = "Europe/Berlin"

CELERY_TIMEZONE = "Europe/Berlin"

USE_L10N = True

USE_TZ = True

# fallback static file handling
STATIC_URL = "/static/"
STATICFILES_DIRS = [BASE_DIR / "staticfiles"]
STATIC_ROOT = BASE_DIR / "staticroot"
MEDIA_URL = "/media/"
MEDIA_ROOT = BASE_DIR / "mediafiles"

# use django-storages to serve & host
# staticfiles and file/media uploads
from .storages.conf import *  # noqa

# redis caching
from .cache import *

# get production logging settings
from .logging import *

DEFAULT_AUTO_FIELD = "django.db.models.BigAutoField"

CELERY_RESULT_BACKEND = "django-db"
CELERY_BROKER_URL = f"redis://{os.environ.get('REDIS_HOST', 'localhost')}:{os.environ.get('REDIS_PORT', '6379')}"
CELERY_BEAT_SCHEDULER = "django_celery_beat.schedulers.DatabaseScheduler"

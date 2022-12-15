import json
import logging.config
import os

PRODUCTION = str(os.environ.get("DJANGO_DEBUG")) == "0"
# Logging Configuration
if PRODUCTION:
    # Clear prev config
    LOGGING_CONFIG = None

    LOGLEVEL = "INFO"
    logging.config.dictConfig(
        {
            "version": 1,
            "disable_existing_loggers": False,
            "formatters": {
                "console": {
                    "format": "%(asctime)s %(levelname)s [%(name)s:%(lineno)s] %(module)s %(process)d %(thread)d %(message)s",
                },
            },
            "handlers": {
                "console": {
                    "class": "logging.StreamHandler",
                    "formatter": "console",
                },
            },
            "loggers": {
                "": {
                    "level": LOGLEVEL,
                    "handlers": [
                        "console",
                    ],
                },
            },
        }
    )

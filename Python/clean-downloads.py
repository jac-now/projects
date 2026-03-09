import os
import shutil
from datetime import datetime, timedelta

def clean_downloads(folder_path, days=30):
    now = datetime.now()
    threshold = now - timedelta(days=days)

    for filename in os.listdir(folder_path):
        file_path = os.path.join(folder_path, filename)
        if os.path.isfile(file_path):
            file_mtime = datetime.fromtimestamp(os.path.getmtime(file_path))
            if file_mtime < threshold:
                shutil.move(file_path, os.path.join(folder_path, "Archive", filename))

clean_downloads("~/Downloads")
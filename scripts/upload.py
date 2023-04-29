import os
from sys import argv

from googleapiclient.discovery import build
from googleapiclient.errors import HttpError
from googleapiclient.http import MediaFileUpload
from google.oauth2 import service_account

SCOPES = ['https://www.googleapis.com/auth/drive']

def main():
  service_account_file_path = argv[1]
  credentials = service_account.Credentials.from_service_account_file(
    service_account_file_path, scopes=SCOPES)

  upload_file_path = argv[2]
  upload_file_name = os.path.basename(upload_file_path)

  google_drive_folder_id = argv[3]
  try:
    service = build('drive', 'v3', credentials=credentials)
    file_metadata = {'name': upload_file_name, 'parents': [google_drive_folder_id]}
    media = MediaFileUpload(upload_file_path, mimetype='text/plain')
    file_resp = service.files().create(body=file_metadata, media_body=media).execute()
  except HttpError as error:
    print(f'An error occurred: {error}')
    raise error

if __name__ == '__main__':
    main()

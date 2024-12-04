# File Upload Server

This repository contains a simple file upload server built using Flask. The server provides an HTML interface and two API endpoints for file uploading and listing uploaded files.

# Description

The project is implemented as a full-stack web application utilising a client-side javascript frontend that captures a webform, appending user location in the form of a city string, acquired through using builtin browser modules to get the user’s latitude and longitude coordinates and checking them against the public OpenStreetMap API. It additionally appends a hash of the uploaded file obtained via the builtin Web Crypto API, to enable crosschecking of file integrity by the backend. The form is then submitted to an endpoint defined on the backend, which captures the information provided by the upload request, crosschecks the hash to verify file integrity, and then stores the file in the server filesystem based on the city name string provided. As a fallback, the frontend provides for manual user input of a city name string should user-configured permissions interfere with the frontend’s ability to capture it automatically. After each refresh of the DOM in frontend, the backend is queried for a list of uploaded files broken down by city through a specialised endpoint. The server responds to this request with a json formatted response which is then parsed in javascript and output to the user in the form of a hierarchical list. Backend services are implemented in Python 3 with Flask. Endpoints are defined for each of the needed endpoints and file system and hashing interfaces are provided through default Python libraries.

## Features

1. **Flask Backend**: The server is implemented with Flask. When `index.html` is requested, it serves an HTML page for file uploads.
2. **APIs**:
   - `upload`: Parses the `city` field from the form as the folder name and saves the uploaded file under the corresponding folder. *(TODO: Add `md5` field for integrity check.)*
   - `list`: *(TODO:)* Returns a list of files already uploaded to the server. The structure is `[(filename, city), ...]`.
3. **File Storage**: Uploaded files are saved in the directory structure `./files/{city}/`.
4. *(TODO:)* Handle conflicts for files with the same name in the same city.

## Project Structure

```
.
├── app.py           # Backend server Python code
├── statics/
│   ├── script.js    # JavaScript code for sending requests
│   └── styles.css   # CSS for styling the index page
├── templates/
│   └── index.html   # HTML for the upload page
```

## How to Run

1. Ensure you have Python 3.x installed.
2. Install Flask using pip:
   ```bash
   pip install Flask
   ```
3. Clone the repository from Github
4. Start the Flask server in debug mode:
   ```bash
   flask run --debug
   ```
5. Open a browser and navigate to `127.0.0.1:5000` to see the upload page. *(For debugging, you could use Chrome's Inspect tool.)*
6. Changes take effect immediately upon saving.



## Todos

1. Md5 checksum
2. Test cases

# Test result
https://docs.google.com/spreadsheets/d/1ZhsIjSrQZfqTYPAW9eVbuJvHnjNMRwyTETHD0rOdnhM/edit?gid=0#gid=0

# Collaborators
[Chris McLaughlin](https://github.com/christopher0936) - Responsible for implementation of all functionality related to file hash checking, as well as non-visual-design elements of listing uploaded files, on both frontend and backend.
[Ricky Lin](https://github.com/ricl9) - Responsible for Frontend Development with regards to core file upload functionality, user interface and experience, and OpenStreetMap API integration.
[Onkar Prakash Kadam](https://github.com/Onkar1130) - Responsible for initial exploratory investigation of file hash checking, attempted md5-based implementation which was later scrapped in favour of sha-256 checking due to depreciation by default javascript modules.
[Xuqiao Jiang](https://github.com/xuqiaoJiang) - Designed and implemented all application testing protocols, test cases, and manual functionality testing across all areas of the application.
Zhang Zhang - Responsible for Backend Development with regards to server environment setup and deployment, core file upload and functionality, file system interfacing, file conflict handling, and sanity checking of city name strings.
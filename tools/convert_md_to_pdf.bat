@echo off
REM Script to convert a Markdown file to PDF using md-to-pdf
REM The output PDF will be placed in the same directory as the input Markdown file.

IF "%~1"=="" (
  echo Usage: %~nx0 ^<path_to_markdown_file^>
  exit /b 1
)

SET "MD_FILE=%~1"

IF NOT EXIST "%MD_FILE%" (
  echo Error: Markdown file not found at '%MD_FILE%'
  exit /b 1
)

REM Get the directory and base name of the Markdown file
FOR %%I IN ("%MD_FILE%") DO (
  SET "MD_DIR=%%~dpI"
  SET "MD_BASENAME=%%~nI"
)
SET "PDF_FILE=%MD_DIR%%MD_BASENAME%.pdf"

echo Converting '%MD_FILE%' to PDF...

REM Execute the conversion
REM Assuming style.css is in the project root, adjust path if necessary
npx md-to-pdf "%MD_FILE%" --stylesheet style.css --pdf-options "{ \"format\": \"A4\", \"margin\": \"15mm\", \"printBackground\": true }" --launch-options "{ \"args\": [\"--no-sandbox\"] }"

IF %ERRORLEVEL% NEQ 0 (
  echo Error: PDF conversion failed.
  exit /b %ERRORLEVEL%
)

echo Conversion successful. PDF saved to '%PDF_FILE%'
exit /b 0

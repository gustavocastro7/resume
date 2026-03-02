@echo off
setlocal
set NOMEEMPRESA=%~1
set VAGAFOLDER=%~2
set LINK=%~3
if "%NOMEEMPRESA%"=="" (
  echo Uso: %~nx0 nomeEmpresa vagafolder linktoprompt
  exit /b 1
)
if "%VAGAFOLDER%"=="" (
  echo Uso: %~nx0 nomeEmpresa vagafolder linktoprompt
  exit /b 1
)
if "%LINK%"=="" (
  echo Uso: %~nx0 nomeEmpresa vagafolder linktoprompt
  exit /b 1
)
set ROOT=%~dp0
set DEST=%ROOT%local\%NOMEEMPRESA%\%VAGAFOLDER%
set TEMPLATE=%ROOT%local\_templates\vagaYY
set PROMPTS=%ROOT%local\_propmtsBase.txt
set RESUMEBASE=%ROOT%local\_resumeBase\Gustavo Castro - Engineering Manager.md
mkdir "%DEST%"
copy /Y "%TEMPLATE%\coverLetter_GustavoCastro.md" "%DEST%\"
copy /Y "%TEMPLATE%\resume_GustavoCastro.md" "%DEST%\"
(
  echo Vaga:
  echo %LINK%
) > "%DEST%\prpt.txt"
type "%PROMPTS%" >> "%DEST%\prpt.txt"
type "%RESUMEBASE%" >> "%DEST%\prpt.txt"
endlocal

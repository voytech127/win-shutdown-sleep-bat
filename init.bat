@ECHO Off

REM			- COMMENT LINE
REM CLS		- Clear Screen
REM	ECHO.	- Empty Line
REM REM		- Comment
REM COLOR A	- Change Font Color to Green
REM EXIT	- Close CMD
REM PAUSE	- Press any key to continue

CLS
:START
ECHO.
ECHO 1. SHUTDOWN
ECHO 2. CANCEL SHUTDOWN
ECHO 3. SLEEP MODE
ECHO 4. CLEAR SCREEN
ECHO 5. EXIT
ECHO.
SET choice=
SET /p choice=Type the number for the action:

REM if not empty take first char only, cut the rest (456 -> 4)
IF NOT '%choice%'=='' SET choice=%choice:~0,1%
IF '%choice%'=='1' GOTO SHUTDOWN
IF '%choice%'=='2' GOTO CANCEL
IF '%choice%'=='3' GOTO SLEEP
IF '%choice%'=='4' GOTO CLEAR
IF '%choice%'=='5' GOTO EXIT

CLS

ECHO.
ECHO "%choice%" is not valid, try again, use 1,2,3,4 or 5 only!
ECHO.
GOTO START
ECHO you choose "%choice%"

:CANCEL
CLS
ECHO.
ECHO 2. CANCEL SHUTDOWN
ECHO.

REM REM =================== REM
REM REM perform a "test" shutdown with a large time

REM Tyr shutdown.exe to chk if there is already a shutdown pending if yes error %ERRORLEVEL% will be 1190

shutdown.exe /s /t 999999
if errorlevel == 1190 (
	shutdown.exe /a
	COLOR A
	echo SHUTDOWN DEACTIVATED!
	GOTO START
) else (
	REM cancel the "test" shutdown
	shutdown.exe /a
	COLOR 7
	ECHO THERE IS NO PENDING SHUTDOWN TO CANCEL
)
GOTO START
REM =================== REM


:SHUTDOWN
ECHO.
ECHO 1. SHUTDOWN
ECHO.
SET /p minutes=Shutdown in how many minutes?
SET "var="&FOR /f "delims=0123456789" %%i IN ("%minutes%") DO SET var=%%i
CLS
IF DEFINED var (
	ECHO.
	ECHO "%minutes%" IS NOT A INTEGER
	GOTO SHUTDOWN
) ELSE (
	CLS
	ECHO.
	REM try to shutdown with big number to chk if there is already a shutdown pending
	REM if yes then %ERRORLEVEL% will be 1190
	shutdown.exe /s /t 999999
	if errorlevel == 1190 (
		ECHO SHUTDOWN ALREADY SETUP!
		ECHO.
		ECHO TO CANCEL SHUTDOWN PRESS [2]
		GOTO START
	) else (
		REM cancel the "test" shutdown
		shutdown.exe /a
		GOTO EXECUTE_SHUTDOWN:%minutes%
	)
)
:EXECUTE_SHUTDOWN

REM ======================== REM
SET int=60
SET /a hours=%minutes%/%int%
SET /a mod=%minutes% %% %int%
ECHO PC will SHUTDOWN in %minutes% min [%hours%hrs	%mod%min]!
SET /a "minutes=%minutes%*%int%"
COLOR C
ECHO       `shutdown.exe /s /f /t %minutes%`
shutdown.exe /s /f /t %minutes%
REM ======================== REM
ECHO.
ECHO TO CANCEL PRESS 2
GOTO START

:SLEEP
CLS
ECHO.
ECHO 4. SLEEP MODE ACTIVATED
ECHO.
ECHO       `RUNDLL32.EXE powrprof.dll,SetSuspendState 0,1,0`
RUNDLL32.EXE powrprof.dll,SetSuspendState 0,1,0
GOTO START

:CLEAR
CLS
COLOR 7
GOTO START


:EXIT
EXIT

PSNSYNCNDFFILES ; OSE/SMH - PPS-N National File Updates File Sync;2018-04-05  1:11 PM
 ;;4.0;NATIONAL DRUG FILE;**10001**; 30 Oct 98;Build 53
 ;
EN ; [Private] Main Entry Point to download files
 ; Now now
 N PSNDNLDB S PSNDNLDB=$$NOW^XLFDT()
 ;
 ; 
 ; Sanity Check:
 ; 1. Create Local Directory (no-op if it exists)
 ; 2. Check Remote Site Information
 ; 3. Check Remote Site Path
 ;
 ; Make directory; or else.
 N PSWRKDIR S PSWRKDIR=$$GETD^PSNFTP()
 N % S %=$$MKDIR^%ZISH(PSWRKDIR)
 I % D  QUIT
 . N MSG S MSG="Error creating directory "_PSWRKDIR
 . D EN^DDIOL(MSG)
 . D MAILFTP^PSNFTP(0,"n/a",0,MSG)
 ;
 ; Get list of files in that directory, so we can identify are new
 N A,ORIG S A("*")=""
 D LIST^%ZISH(PSWRKDIR,"A","ORIG")
 ;
 ; Check Server
 N PSADDR S PSADDR=$$GET1^DIQ(57.23,1,20)
 I PSADDR="" DO  QUIT
 . N MSG S MSG="Remote Server Address in the PPS-N Site Parameters is not defined or invalid"
 . D EN^DDIOL(MSG)
 . D MAILFTP^PSNFTP(0,"n/a",0,MSG)
 ;
 ; Check Remote Site Path
 N PSREMDIR S PSREMDIR=$$GET1^DIQ(57.23,1,21)
 I PSREMDIR="" DO  QUIT
 . N MSG S MSG="REMOTE DIRECTORY ACCESS in PPS-N UPDATE CONTROL (#57.23) file is not defined"
 . D EN^DDIOL(MSG)
 . D MAILFTP^PSNFTP(0,"n/a",0,MSG)
 ;
 ; Checks are okay. Now we need to download.
 ;
 ; Change download status to downloading
 N DIE,DA,DR
 S DIE="^PS(57.23,",DA=1,DR="9///Y" D ^DIE
 ;
 ; Sync remote site contents with current folder
 N % S %=$$WGETSYNC^%ZISH(PSADDR,PSREMDIR,PSWRKDIR,"*.DAT*")
 I '% DO  QUIT
 . N MSG S MSG="WGET came back with an error. Error code: "_%
 . D EN^DDIOL(MSG)
 . D MAILFTP^PSNFTP(0,"n/a",0,MSG)
 ;
 ; Find the new files that we got. Put in NEW(F)
 ; This is a boolean operation (ORIG U CURR) 'C ORIG
 ; U is Union; C is Contains
 N A,CURR S A("*")=""
 N NEW
 D LIST^%ZISH(PSWRKDIR,"A","CURR")
 N F S F=""
 F  S F=$O(CURR(F)) Q:F=""  I '$D(ORIG(F)) S NEW(F)=""
 ;
 ; For each new file
 N PSREMFIL
 F  S PSREMFIL=$O(NEW(PSREMFIL))  Q:PSREMFIL=""  D
 . ; - update PPS-N UPDATE CONTROL:RETRIEVAL VERSION (#57.23:8)
 . N PSNEW S PSNEW=+$P(PSREMFIL,"PRV_",2)
 . N DIE,DA,DR
 . S DIE="^PS(57.23,",DA=1,DR="8///"_PSNEW D ^DIE
 . ;
 . ; get size
 . N PSSIZE S PSSIZE=$$SIZE^%ZISH(PSWRKDIR,F)
 . ;
 . ; email that we are done
 . D MAILFTP^PSNFTP(1,PSREMFIL,PSSIZE,"")
 . ;
 . ; update the control file
 . D UPDTCTRL^PSNFTP
 ;
 ; Turn off downloading flag
 K DIE,DA,DR
 S DIE="^PS(57.23,",DA=1,DR="9///N" D ^DIE K DIE,DA,DR
 ;
 ; ??
 D NOW^%DTC S DIE="^PS(57.23,1,4,",DA=1,DR="3///"_% D ^DIE K DIE,DA,DR
 Q

PSNPPSMG ;HP/MJE-PPSN update NDF data ;2019-02-14  10:41 AM
 ;;4.0;NATIONAL DRUG FILE;**513,10001,565,10002**; 30 Oct 98;Build 2
 ;Reference to ^PSDRUG supported by DBIA #2352,#221
 ; Original code authored by Department of Veterans Affairs
 ; *10001*/*10002* modification made by OSEHRA/Sam Habiel (c) 2018-2019
 ; *10002* does not introduce any changes. It restores 10001 changes over 565.
 ; See https://github.com/shabiel/PSN-4-513
 ;
MESSAGE ;
 D CTRKDL^PSNPPSMS("Sending DATA UPDATE FOR NDF email")
 W:'$G(PSNSCJOB) !,"Sending mail messages...",!
 K FDA
 S FDA(57.231,CTRLXIEN_","_CTRLIEN_",",6)="MESSAGE"
 D UPDATE^DIE("","FDA","CTRLIEN")
 K FDA
 S FILE=0,GROOT=$NA(^TMP("PSN PPSN PARSED",$J,"DATAO"))
 ;
 S PSNPS=$P($G(^PS(59.7,1,10)),"^",12) I PSNPS'="N" G G1
 N MESSC S MESSC=""
 F  S MESSC=$O(^TMP("PSN PPSN PARSED",$J,"MESSAGE",MESSC)) Q:MESSC=""  D
 .I MESSC=0 S ^NDFK(5000,1,2,0)=^TMP("PSN PPSN PARSED",$J,"MESSAGE",MESSC) Q
 .S ^NDFK(5000,1,2,MESSC,0)=^TMP("PSN PPSN PARSED",$J,"MESSAGE",MESSC)
 S MESSC=""
 F  S MESSC=$O(^TMP("PSN PPSN PARSED",$J,"MESSAGE2",MESSC)) Q:MESSC=""  D
 .I MESSC=0 S ^NDFK(5000,1,3,0)=^TMP("PSN PPSN PARSED",$J,"MESSAGE2",MESSC) Q
 .S ^NDFK(5000,1,3,MESSC,0)=^TMP("PSN PPSN PARSED",$J,"MESSAGE2",MESSC)
 ;
G1 K ^TMP($J) M ^TMP($J)=^TMP("PSN PPSN PARSED",$J,"MESSAGE") K ^TMP($J,0)
 ;
GROUP K XMY S X=$G(^TMP("PSN PPSN PARSED",$J,"GROUP")) I X]"" S XMY("G."_X_"@"_^XMB("NETNAME"))=""
 S PSNPS=$P($G(^PS(59.7,1,10)),"^",12)
 D XMY
 S XMSUB="DATA UPDATE FOR NDF"
 S XMDUZ="noreply@domain.ext"
 S XMTEXT="^TMP($J," N DIFROM D ^XMD
 D CTRKDL^PSNPPSMS("Sent email for DATA UPDATE FOR NDF.")
 K FDA
 S FDA(57.231,CTRLXIEN_","_CTRLIEN_",",6)="MESSAGE2"
 D UPDATE^DIE("","FDA","CTRLIEN")
 K FDA
 K ^TMP($J) M ^TMP($J)=^TMP("PSN PPSN PARSED",$J,"MESSAGE2") K ^TMP($J,0)
 K XMY S X=$G(^TMP("PSN PPSN PARSED",$J,"GROUP")) I X]"" S XMY("G."_X_"@"_^XMB("NETNAME"))=""
 ;
 D XMY
 D CTRKDL^PSNPPSMS("Sending UPDATED INTERACTIONS and FDA MED GUIDE message")
 S XMSUB="UPDATED INTERACTIONS AND FDA MED GUIDE"
 S XMDUZ="noreply@domain.ext"
 S XMTEXT="^TMP($J," N DIFROM D ^XMD
 D CTRKDL^PSNPPSMS("Sent email for UPDATED INTERACTIONS and FDA MED GUIDE.")
 K DA
 Q
 ;
COMMSG ;Send error message that comm link with PPSN is not available
 K ^TMP("PSN PPSN PARSED",$J,"COMMSG")
 N PSNPS,PSMSGTXT,XMY,X,XMSUB,XMTEXT,PSGRP,LNCNT,FIRST,I3,I4,I5,I6,I7,III
 S LNCNT=1,FIRST=0,(I3,I4,I5,I6,I7)="",PSNPS=$P($G(^PS(59.7,1,10)),"^",12)
 S ^TMP("PSN PPSN PARSED",$J,"COMMSG",1)="*************************************************************************"
 S ^TMP("PSN PPSN PARSED",$J,"COMMSG",3)="*************************************************************************"
 S ^TMP("PSN PPSN PARSED",$J,"COMMSG",4)="The following file completed installation with error(s)"_$S(PSNPS="Q":" for QA",1:"")_":"
 S ^TMP("PSN PPSN PARSED",$J,"COMMSG",5)=""
 S ^TMP("PSN PPSN PARSED",$J,"COMMSG",6)="      Update file Name"
 S ^TMP("PSN PPSN PARSED",$J,"COMMSG",7)="      -------------------"
 S ^TMP("PSN PPSN PARSED",$J,"COMMSG",8)="      "_$P(PSNHLD,";")
 S ^TMP("PSN PPSN PARSED",$J,"COMMSG",9)=""
 S ^TMP("PSN PPSN PARSED",$J,"COMMSG",10)=""
 S LNCNT=10
 G:'$D(^TMP("PSN PPSN ERR",$J)) LZ S LNCNT=11 F  S I3=$O(^TMP("PSN PPSN ERR",$J,I3)) Q:I3=""  D
 .F  S I4=$O(^TMP("PSN PPSN ERR",$J,I3,I4)) Q:'I4  D
 ..F  S I5=$O(^TMP("PSN PPSN ERR",$J,I3,I4,I5)) Q:I5=""  D
 ...F  S I6=$O(^TMP("PSN PPSN ERR",$J,I3,I4,I5,I6)) Q:I6=""  D
 ....F  S I7=$O(^TMP("PSN PPSN ERR",$J,I3,I4,I5,I6,I7)) Q:'I7  D
 .....S III=$G(^TMP("PSN PPSN ERR",$J,I3,I4,I5,I6,I7)) D
 ......I FIRST=0 S ^TMP("PSN PPSN PARSED",$J,"COMMSG",LNCNT)="Error Message: " S LNCNT=LNCNT+1,FIRST=1
 ......S ^TMP("PSN PPSN PARSED",$J,"COMMSG",LNCNT)=$$TRNS(I4,I5,I6) S LNCNT=LNCNT+1
 ......S ^TMP("PSN PPSN PARSED",$J,"COMMSG",LNCNT)="      "_$P(III,"^")
 ......S LNCNT=LNCNT+1
LZ I '$D(^TMP("PSN PPSN ERR",$J)) S ^TMP("PSN PPSN PARSED",$J,"COMMSG",LNCNT+1)="Error Message: "_$P(COMM,"^",2)
 S ^TMP("PSN PPSN PARSED",$J,"COMMSG",LNCNT+2)="               The update file completed installation but the completion"
 S ^TMP("PSN PPSN PARSED",$J,"COMMSG",LNCNT+3)="               message was not accepted by PPS-N."
 S ^TMP("PSN PPSN PARSED",$J,"COMMSG",LNCNT+4)=""
 S ^TMP("PSN PPSN PARSED",$J,"COMMSG",LNCNT+5)="Contact the National Help Desk or enter a ticket."
 S ^TMP("PSN PPSN PARSED",$J,"COMMSG",LNCNT+6)=""
 S X=$G(^TMP("PSN PPSN PARSED",$J,"GROUP")) I X]"" S XMY("G."_X_"@"_^XMB("NETNAME"))=""
 D XMY
 S XMDUZ="noreply@domain.ext"
 S XMSUB="ERROR: PPS-N/NDF File "_$P(PSNHLD,";",1)_" INSTALL"
 I PSNPS'="" I PSNPS="Q" S XMSUB="ERROR: PPS-N/NDF File "_$P(PSNHLD,";",1)_" INSTALL FOR QA"
 S XMTEXT="^TMP(""PSN PPSN PARSED"",$J,""COMMSG"","
 N DIFROM D ^XMD
 D CTRKDL^PSNPPSMS("Error email sent (COMMSG).")
 Q
 ;
IERRMSG ;Send error message that comm link with PPSN is not available
 K ^TMP("PSN PPSN PARSED",$J,"IERRMSG")
 Q:INSTIEN=""
 Q:'$D(^PS(57.23,1,5,INSTIEN,2,1))
 N PSNEDATA,PSNPS,PSMSGTXT,XMY,X,XMSUB,XMTEXT,PSGRP,LNCNT,FIRST,I3,I4,I5,I6,I7,III
 S LNCNT=1,FIRST=0,I3="",PSNPS=$P($G(^PS(59.7,1,10)),"^",12)
 S ^TMP("PSN PPSN PARSED",$J,"IERRMSG",1)="*************************************************************************"
 S ^TMP("PSN PPSN PARSED",$J,"IERRMSG",2)="  Error(s) occurred during the install of "_$P(PSNHLD,";")_$S(PSNPS="Q":" for QA",1:"")_":"
 S ^TMP("PSN PPSN PARSED",$J,"IERRMSG",3)="*************************************************************************"
 S ^TMP("PSN PPSN PARSED",$J,"IERRMSG",4)=""
 S ^TMP("PSN PPSN PARSED",$J,"IERRMSG",5)="The "_$P(PSNHLD,";")_"NDF Update file completed installation with error(s)."
 S ^TMP("PSN PPSN PARSED",$J,"IERRMSG",6)="Contact the National Help Desk or enter a ticket."
 S ^TMP("PSN PPSN PARSED",$J,"IERRMSG",7)=""
 S LNCNT=7
 G:'$D(^PS(57.23,1,5,INSTIEN,2)) LZ2
 S LNCNT=11,I3=0 F  S I3=$O(^PS(57.23,1,5,INSTIEN,2,I3)) Q:I3=""  I $D(^PS(57.23,1,5,INSTIEN,2,I3,0)) D
 .I FIRST=0 S ^TMP("PSN PPSN PARSED",$J,"IERRMSG",LNCNT)="Error Message(s): " S LNCNT=LNCNT+1,FIRST=1
 .S PSNEDATA="",PSNEDATA=^PS(57.23,1,5,INSTIEN,2,I3,0)
 .S ^TMP("PSN PPSN PARSED",$J,"IERRMSG",LNCNT)="   File: "_$$LJ^XLFSTR($P(PSNEDATA,"^",2),13," ")_"   IEN: "_$$LJ^XLFSTR($P(PSNEDATA,"^",3),13," ")_"   Record Type: "_$$LJ^XLFSTR($P(PSNEDATA,"^",4),13," ") S LNCNT=LNCNT+1
 .S ^TMP("PSN PPSN PARSED",$J,"IERRMSG",LNCNT)="       Last Record: "_$P(PSNEDATA,"|",2,3) S LNCNT=LNCNT+1
 .S ^TMP("PSN PPSN PARSED",$J,"IERRMSG",LNCNT)="       Message: "_$P(PSNEDATA,"^",5) S LNCNT=LNCNT+1
 .S ^TMP("PSN PPSN PARSED",$J,"IERRMSG",LNCNT)="  " S LNCNT=LNCNT+1
 ;
LZ2 ;
 S ^TMP("PSN PPSN PARSED",$J,"IERRMSG",LNCNT)="",XMSUB="ERROR: PPS-N/NDF File "_$P(PSNHLD,";",1)_" INSTALL"
 S X=$G(^TMP("PSN PPSN PARSED",$J,"GROUP")) I X]"" S XMY("G."_X_"@"_^XMB("NETNAME"))=""
 I PSNPS'="",PSNPS="Q" S XMSUB="ERROR: PPS-N/NDF File "_$P(PSNHLD,";",1)_" INSTALL FOR QA"
 K XMY S X=$G(^TMP("PSN PPSN PARSED",$J,"GROUP")) I X]"" S XMY("G."_X_"@"_^XMB("NETNAME"))=""
 D XMY
 S XMDUZ="noreply@domain.ext"
 S XMTEXT="^TMP(""PSN PPSN PARSED"",$J,""IERRMSG"","
 N DIFROM D ^XMD
 D CTRKDL^PSNPPSMS("Install completed with errors and email with errors was sent (IERRMSG).")
 Q
 ;
SMSG ;Send install successful message
 K XMY
 N PSNPS
 ;SETUP PRODUCTION OR SQA
 K ^TMP("PSN PPSN PARSED",$J,"MSG2")
 N PSGRP,PSNFSIZE,PSSIZE,PSFILE,PSWRKDIR,PSOS
 S PSWRKDIR=$$GETD^PSNFTP()
 S PSNFSIZE=1,PSSIZE=""
 S PSOS=$$GETOS^PSNFTP
 I +PSOS=3 D UXFSIZE(PSWRKDIR,PSNHLD,.PSSIZE)
 I +PSOS'=3 D FILSIZE^PSNFTP2(PSWRKDIR,PSNHLD,.PSSIZE,1)
 ;
 S PSNPS=$P($G(^PS(59.7,1,10)),"^",12)
 ;
 S XMSUB="PPS-N/NDF File "_$P(PSNHLD,";",1)_" INSTALLED"
 I PSNPS'="" I PSNPS="Q" S XMSUB=XMSUB_" FOR QA"
 S ^TMP("PSN PPSN PARSED",$J,"MSG2",1)="PPS-N/NDF File "_$P(PSNHLD,";",1)_" (Size "_PSSIZE_$S(+PSOS=1:"",+PSOS=3:" bytes",1:"")_")"
 S ^TMP("PSN PPSN PARSED",$J,"MSG2",2)="INSTALLED successfully."
 D XMY
 S XMTEXT="^TMP(""PSN PPSN PARSED"",$J,""MSG2""," N DIFROM D ^XMD
 K ^TMP("PSN PPSN PARSED",$J,"MSG2")
 K ^TMP($J)
 K XMSUB,XMDUZ,XMTEXT
 Q
 ;
DRGMSG ;
 W:'$G(PSNSCJOB) !,"Generating mail messages for unmatched/re-matched drugs...",!
 D REPORT^PSNPPSNW ;        ********************
 ;
 N INDX,LINE,XMZ,PSNPS K ^TMP("PSN",$J) S LINE=1
 S ^TMP("PSN",$J,LINE,0)="PPS-N Update File: "_$P(PSNHLD,";",1),LINE=LINE+1,^TMP("PSN",$J,LINE,0)="",LINE=LINE+1
 F INDX="A","X","I" D LOAD1^PSNPPSMS
 ;S XMDUZ="NDF_MANAGER"
 S XMDUZ="noreply@domain.ext"
 ;
 S XMSUB="DRUGS UNMATCHED FROM NATIONAL DRUG FILE"
 ;
 S XMTEXT="^TMP(""PSN"",$J,"
 K XMY S X=$G(^TMP("PSN PPSN PARSED",$J,"GROUP")) I X]"" S XMY("G."_X_"@"_^XMB("NETNAME"))=""
 S PSGRP="",PSGRP=$$GET1^DIQ(57.23,1,5) ;get PPS-N UPDATE CONTROL:LOCAL EMAIL GROUP NAME (57.23:5)
 S:PSGRP'="" XMY(PSGRP)=""
 ;
 S PSNPS=$P($G(^PS(59.7,1,10)),"^",12)
 D XMY
 N DIFROM D ^XMD I $D(XMZ) S DA=XMZ,DIE=3.9,DR="1.7///P;" D ^DIE
 ;
 S FDA(57.231,CTRLXIEN_","_CTRLIEN_",",10)="MESSAGE3"
 D UPDATE^DIE("","FDA","CTRLIEN")
 K FDA
 K ^TMP($J) M ^TMP($J)=^TMP("PSN PPSN PARSED",$J,"MESSAGE3") K ^TMP($J,0)
 K XMY S X=$G(^TMP("PSN PPSN PARSED",$J,"GROUP")) I X]"" S XMY("G."_X_"@"_^XMB("NETNAME"))=""
 S PSNPS=$P($G(^PS(59.7,1,10)),"^",12)
 D XMY
 S XMSUB="LOCAL DRUGS REMATCHED TO NDF"
 S XMDUZ="noreply@domain.ext"
 S XMTEXT="^TMP($J," N DIFROM
 D ^XMD
 K DIE,DR
 Q
UXFSIZE(PSWRKDIR,PSNHLD,PSSIZE) ; get linux file size (OSE/SMH - modified in *10001*/restored in *10002*)
 S:'$D(PSWRKDIR) PSWRKDIR=$$GETD^PSNFTP()
 S PSSIZE=$$SIZE^%ZISH(PSWRKDIR,PSNHLD)
 QUIT
 ; OSE/SMH *10001*/*10002*
 ;
TRNS(PSNFILE,IEN,PSNFIELD) ; get the label of file/field
 N PSNF,FILE,FILENM,FIELD,PSNARR,FLD,FIELDX
 S (FIELD,FILE,FILENM,PSNARR,FLD,PSNF)=""
 S FILE=PSNFILE,(FIELD,FIELDX)=PSNFIELD
 S PSNF=$S($D(^DIC(FILE,0)):$P($G(^DIC(FILE,0)),U),1:"**Wrong file number**")
 I FIELD["," S FILENM=$P($G(^DD(FILE,+FIELD,0)),"^"),FILE=+$P($G(^DD(FILE,$P(FIELD,","),0)),"^",2) S:FILE FIELD=$P(FIELD,",",2)
 K PSNARR D FIELD^DID(FILE,FIELD,"","LABEL","PSNARR") S FLD=$S(FIELDX[",":FILENM_" >>> ",1:"")_$G(PSNARR("LABEL"))
 Q "   File: "_$$LJ^XLFSTR(PSNF,13," ")_"   IEN#: "_$$LJ^XLFSTR(IEN,13," ")_"   Field: "_$$LJ^XLFSTR(FLD,13," ")
 ;
XMY ;set XMY for mail message
 S XMDUZ="noreply@domain.ext"
 S DA=0 F  S DA=$O(^XUSEC("PSNMGR",DA)) Q:'DA  S XMY(DA)=""
 I $D(DUZ) S XMY(DUZ)=""
 S PSGRP="",PSGRP=$$GET1^DIQ(57.23,1,5) S:PSGRP'="" XMY($$MG(PSGRP))="" ;PRIMARY PPS-N MAIL GROUP
 S PSGRP="",PSGRP=$$GET1^DIQ(57.23,1,6) S:PSGRP'="" XMY($$MG(PSGRP))="" ;SECONDARY MAIL GROUP
 Q
 ;
MG(PSNGG) ; look for Mail Group
 I $E(PSNGG,1,2)="G." Q:$O(^XMB(3.8,"B",$E(PSNGG,3,99),0)) PSNGG
 Q:$O(^XMB(3.8,"B",PSNGG,0)) "G."_PSNGG
 Q PSNGG

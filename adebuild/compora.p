/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
** This sets things up so that the oracle dictionary parts can be compiled.
*/

{ prodict/dictvar.i NEW }
define variable system as character initial "add".

FIND FIRST DICTDB._Db WHERE DICTDB._Db._Db-name = "DICTDBG"  EXCLUSIVE-LOCK NO-ERROR.

IF AVAILABLE DICTDB._Db THEN DO:
    IF DICTDB._Db._Db-type  = "ORACLE" THEN RETURN.
    DELETE DICTDB._Db.
END.

IF NOT AVAILABLE DICTDB._Db THEN DO:
    IF CAN-DO(GATEWAYS,"ORACLE") THEN DO:
   CREATE DICTDB._Db.                         
   ASSIGN DICTDB._Db._Db-name    = "DICTDBG"  
          DICTDB._Db._Db-type    = "ORACLE"
          DICTDB._Db._Db-slave   = TRUE
          DICTDB._Db._Db-addr    = ""
          DICTDB._Db._Db-comm    = ""
          DICTDB._Db._Db-xl-name = "ibm850".
   RUN prodict/ora/_ora_sys.p (RECID(DICTDB._Db), 
                  INPUT-OUTPUT system).
    END.
END.
RETURN.

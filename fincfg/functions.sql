
--
-- TOC entry 360 (class 1255 OID 62544)
-- Name: changequeuestatus(integer, integer); Type: FUNCTION; Schema: fincfg; Owner: fincfg
--

CREATE FUNCTION changequeuestatus(inqueueid integer, instatus integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE

/*
* FinTP - Financial Transactions Processing Application
* Copyright (C) 2013 Business Information Systems (Allevo) S.R.L.
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program. If not, see <http://www.gnu.org/licenses/>
* or contact Allevo at : 031281 Bucuresti, 23C Calea Vitan, Romania,
* phone +40212554577, office@allevo.ro <office@allevo.ro>, www.allevo.ro.
*/
/************************************************
  Change history:  05.Jun.2018, DanielC - 12857
  Created:         10.Jun.2013, DenisaN  - 7168
  Description:     Changes the status of a specified queue
  Parameters:      inQueueID - queue to be modified
                   inStatus - new status of the queue                    
  Returns:         n/a
  Used:            FinTP/BASE/RE
***********************************************/


BEGIN

   update  fincfg.queues   set   holdstatus = inStatus where  id = inQueueID;
         

EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while configuring queue: %', SQLERRM;
       
END;
$$;


ALTER FUNCTION fincfg.changequeuestatus(inqueueid integer, instatus integer) OWNER TO fincfg;

--
-- TOC entry 361 (class 1255 OID 62545)
-- Name: getactiveschemas(character varying); Type: FUNCTION; Schema: fincfg; Owner: fincfg
--

CREATE FUNCTION getactiveschemas(incurrenttime character varying) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
DECLARE

/*
* FinTP - Financial Transactions Processing Application
* Copyright (C) 2013 Business Information Systems (Allevo) S.R.L.
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program. If not, see <http://www.gnu.org/licenses/>
* or contact Allevo at : 031281 Bucuresti, 23C Calea Vitan, Romania,
* phone +40212554577, office@allevo.ro <office@allevo.ro>, www.allevo.ro.
*/
/************************************************
  Change history:  dd.mon.yyyy  --  author  --   description
  Created:         29.May.2013, DenisaN 7496
  Description:     Gets active routing schemas  info at invoke time
  Parameters:      inCurrentTime - current time [format:HH24:MI:SS]
  Returns:         cursor representing schema info    
  Used:            FinTP/BASE/RE
***********************************************/

 v_currentTime timestamp;
 v_cursor      refcursor;
  
BEGIN
 
   v_currentTime := to_timestamp( inCurrentTime,'HH24:MI:SS' );
   
  open v_cursor for
     select id, name, sessioncode from fincfg.routingschemas where
        timelimitid1 in ( select id from fincfg.timelimits where ( cutoff - date_trunc( 'day', cutoff ) ) < ( v_currentTime - date_trunc( 'day', v_currentTime ) ) )
       and 
        timelimitid2 in ( select id from fincfg.timelimits where ( cutoff - date_trunc( 'day', cutoff ) ) > ( v_currentTime - date_trunc( 'day', v_currentTime ) ) );
  return (v_cursor);


EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while retrieving active schemas: %', SQLERRM;
       
END;
$$;


ALTER FUNCTION fincfg.getactiveschemas(incurrenttime character varying) OWNER TO fincfg;

--
-- TOC entry 362 (class 1255 OID 62546)
-- Name: getduplicatesettings(); Type: FUNCTION; Schema: fincfg; Owner: fincfg
--

CREATE FUNCTION getduplicatesettings(OUT outretcursor refcursor) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
DECLARE

/*
* FinTP - Financial Transactions Processing Application
* Copyright (C) 2013 Business Information Systems (Allevo) S.R.L.
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program. If not, see <http://www.gnu.org/licenses/>
* or contact Allevo at : 031281 Bucuresti, 23C Calea Vitan, Romania,
* phone +40212554577, office@allevo.ro <office@allevo.ro>, www.allevo.ro.
*/
/************************************************
  Change history:  dd.mon.yyyy  --  author  --   description
  Created:         21.Jan.2014, DenisaN                
  Description:     Gathers duplicate settings for every service defined.
  Parameters:      n/a
  Returns:         outRetCursor  cursor representing schema info    
  Used:            FinTP/BASE/RE,Conn
***********************************************/

BEGIN

  open outretcursor for
    select name, 
               case 
                     when duplicatecheck = 2 then 0
                     when duplicatecheck = 1 then 1
                     when duplicatecheck = 0 then 0
                      else null
               end duplicatecheck, 
               case 
                    when duplicatecheck = 2 then 1
                    when duplicatecheck = 1  then 1
                    when duplicatecheck = 0 then 0
                    else null
               end duplicateservice, 
               duplicatequeue, duplicatemap  from fincfg.servicemaps;

EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while retrieving duplicate settings: %', SQLERRM;
       
END;
$$;


ALTER FUNCTION fincfg.getduplicatesettings(OUT outretcursor refcursor) OWNER TO fincfg;

--
-- TOC entry 363 (class 1255 OID 62547)
-- Name: getkeywordmappings(); Type: FUNCTION; Schema: fincfg; Owner: fincfg
--

CREATE FUNCTION getkeywordmappings(OUT outretcursor refcursor) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
DECLARE

/*
* FinTP - Financial Transactions Processing Application
* Copyright (C) 2013 Business Information Systems (Allevo) S.R.L.
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program. If not, see <http://www.gnu.org/licenses/>
* or contact Allevo at : 031281 Bucuresti, 23C Calea Vitan, Romania,
* phone +40212554577, office@allevo.ro <office@allevo.ro>, www.allevo.ro.
*/
/************************************************
  Change history:  11.Jun.2018, DanielC 12857
  Created:         29.May.2013, DenisaN 7496
  Description:     Gets the routing keyword mappings
  Parameters:      n/a
  Returns:         cursor 
  Used:            FinTP/BASE/RE
***********************************************/

BEGIN

   open outretcursor for
         select  rk.name, rkm.tag, rkm.messagetype, rkm.selector 
           from fincfg.routingkeywordmaps rkm, fincfg.routingkeywords rk
         where  rkm.routingkeywordid = rk.id;


EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while retrieving keywords: %', SQLERRM;
       
END;
$$;


ALTER FUNCTION fincfg.getkeywordmappings(OUT outretcursor refcursor) OWNER TO fincfg;

--
-- TOC entry 364 (class 1255 OID 62548)
-- Name: getkeywords(); Type: FUNCTION; Schema: fincfg; Owner: fincfg
--

CREATE FUNCTION getkeywords(OUT outretcursor refcursor) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
DECLARE

/*
* FinTP - Financial Transactions Processing Application
* Copyright (C) 2013 Business Information Systems (Allevo) S.R.L.
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program. If not, see <http://www.gnu.org/licenses/>
* or contact Allevo at : 031281 Bucuresti, 23C Calea Vitan, Romania,
* phone +40212554577, office@allevo.ro <office@allevo.ro>, www.allevo.ro.
*/
/************************************************
  Change history:  dd.mon.yyyy  --  author  --   description
  Created:         29.May.2013, DenisaN 7496
  Description:     Gets the routing keywords
  Parameters:      n/a
  Returns:         cursor 
  Used:            FinTP/BASE/RE
***********************************************/

BEGIN

   open outretcursor for
         select id, name,  comparer,  selector,  description,  selectoriso from fincfg.routingkeywords;


EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while retrieving keywords: %', SQLERRM;
       
END;
$$;


ALTER FUNCTION fincfg.getkeywords(OUT outretcursor refcursor) OWNER TO fincfg;

--
-- TOC entry 456 (class 1255 OID 62549)
-- Name: getlastbusinessday(date, integer); Type: FUNCTION; Schema: fincfg; Owner: fincfg
--

CREATE FUNCTION getlastbusinessday(indate date, innoofdays integer) RETURNS date
    LANGUAGE plpgsql
    AS $$
DECLARE

/*
* FinTP - Financial Transactions Processing Application
* Copyright (C) 2013 Business Information Systems (Allevo) S.R.L.
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program. If not, see <http://www.gnu.org/licenses/>
* or contact Allevo at : 031281 Bucuresti, 23C Calea Vitan, Romania,
* phone +40212554577, office@allevo.ro <office@allevo.ro>, www.allevo.ro.
*/
/************************************************
  Change history:  dd.mon.yyyy  --  author  --   description
  Created:         06.Feb.2014, DenisaN 8192
  Description:     Returns the last business day, given a number of days (to decrease or increase)
  Parameters:      inDate - starting date
                   inNoOfDays - days to decrease/increase                                
  Returns:         date
  Used:            FinTP/BASE/BD
***********************************************/


v_lastBusinessDay   date;
v_count             integer default 0; 


BEGIN

  v_lastBusinessDay := inDate - inNoOfDays;

  if inNoOfDays > 0 then 

       --number of non working days in the interval (before)
        select count(*) into v_count from fincfg.nonbussdayscalendar where nonbusinessdate < inDate and nonbusinessdate >= (inDate - inNoOfDays);
        
        if v_count = 0 then
            return v_lastBusinessDay;
        else
            return fincfg.getlastbusinessday(v_lastBusinessDay, v_count);
        end if;


  else  
    
         --number of non working days in the interval (ahead)
        select count(*) into v_count from fincfg.nonbussdayscalendar where nonbusinessdate > inDate and nonbusinessdate <= (inDate - inNoOfDays);
        
        if v_count = 0 then
            return v_lastBusinessDay;
        else
            return fincfg.getlastbusinessday(v_lastBusinessDay, v_count*(-1));
        end if;
  
  end if;
  

EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while reading the calendar: %', SQLERRM;
       
END;
$$;


ALTER FUNCTION fincfg.getlastbusinessday(indate date, innoofdays integer) OWNER TO fincfg;

--
-- TOC entry 365 (class 1255 OID 62550)
-- Name: getmsgtypebusinessname(character varying); Type: FUNCTION; Schema: fincfg; Owner: fincfg
--

CREATE FUNCTION getmsgtypebusinessname(inmsgtype character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE

/*
* FinTP - Financial Transactions Processing Application
* Copyright (C) 2013 Business Information Systems (Allevo) S.R.L.
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program. If not, see <http://www.gnu.org/licenses/>
* or contact Allevo at : 031281 Bucuresti, 23C Calea Vitan, Romania,
* phone +40212554577, office@allevo.ro <office@allevo.ro>, www.allevo.ro.
*/
/************************************************
  Change history:  dd.mon.yyyy  --  author  --   description
  Created:        10.Nov.2013, DenisaN
  Description:    Returns the friendly/business name for one given message type
  Parameters:     message type internal name
  Returns:        message type friendly name
  Used:           FinTP/BASE/DB
***********************************************/

v_fname varchar;

BEGIN

     select friendlyname into v_fname from fincfg.messagetypes where messagetype = inMsgType;
     return v_fname;

EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while retrieving messagetype: %', SQLERRM;
       
END;
$$;


ALTER FUNCTION fincfg.getmsgtypebusinessname(inmsgtype character varying) OWNER TO fincfg;

--
-- TOC entry 434 (class 1255 OID 62551)
-- Name: getqueueid(character varying); Type: FUNCTION; Schema: fincfg; Owner: fincfg
--

CREATE FUNCTION getqueueid(inqueuename character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE

/*
* FinTP - Financial Transactions Processing Application
* Copyright (C) 2013 Business Information Systems (Allevo) S.R.L.
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program. If not, see <http://www.gnu.org/licenses/>
* or contact Allevo at : 031281 Bucuresti, 23C Calea Vitan, Romania,
* phone +40212554577, office@allevo.ro <office@allevo.ro>, www.allevo.ro.
*/
/************************************************
  Change history:  dd.mon.yyyy  --  author  --   description
  Created:        10.Aug.2018, dd 
  Description:    Returns the queue identifier 
  Parameters:     queue name
  Returns:        queue id
  Used:           FinTPc//DB
***********************************************/

v_queueid integer;

BEGIN

     select id into v_queueid from fincfg.queues where name = inqueuename;
     return v_queueid;

EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while retrieving queue id: %', SQLERRM;
       
END;
$$;


ALTER FUNCTION fincfg.getqueueid(inqueuename character varying) OWNER TO fincfg;

--
-- TOC entry 366 (class 1255 OID 62552)
-- Name: getqueues(); Type: FUNCTION; Schema: fincfg; Owner: fincfg
--

CREATE FUNCTION getqueues(OUT outretcursor refcursor) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$DECLARE

/*
* FinTP - Financial Transactions Processing Application
* Copyright (C) 2013 Business Information Systems (Allevo) S.R.L.
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program. If not, see <http://www.gnu.org/licenses/>
* or contact Allevo at : 031281 Bucuresti, 23C Calea Vitan, Romania,
* phone +40212554577, office@allevo.ro <office@allevo.ro>, www.allevo.ro.
*/
/************************************************
  Change history:  05.Jun.2018, DanielC - 12857
  Created:         27.Mar.2013, DenisaN
  Description:     Gets all queues and all service maps non/associated
  Parameters:      n/a
  Returns:         cursor result set
  Used:            FinTP/BASE/RE
***********************************************/

BEGIN

   open outretcursor  for
             select  q.id, q.name,  sm.exitpoint,  sm.name as servicename,  sm.id as servicemapid, sm.duplicatequeue, q.holdstatus, sm.duplicatenotificationqueue, sm.delayednotificationqueue 
              from  fincfg.queues q
              left join fincfg.servicemaps sm
              on q.exitpoint = sm.id;


EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while retrieving queues: %', SQLERRM;
       
END;
$$;


ALTER FUNCTION fincfg.getqueues(OUT outretcursor refcursor) OWNER TO fincfg;

--
-- TOC entry 367 (class 1255 OID 62553)
-- Name: getrule(integer); Type: FUNCTION; Schema: fincfg; Owner: fincfg
--

CREATE FUNCTION getrule(inruleid integer, OUT outretcursor refcursor) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
DECLARE

/*
* FinTP - Financial Transactions Processing Application
* Copyright (C) 2013 Business Information Systems (Allevo) S.R.L.
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program. If not, see <http://www.gnu.org/licenses/>
* or contact Allevo at : 031281 Bucuresti, 23C Calea Vitan, Romania,
* phone +40212554577, office@allevo.ro <office@allevo.ro>, www.allevo.ro.
*/
/************************************************
  Change history:  dd.mon.yyyy  --  author  --   description
  Created:         29.May.2013, DenisaN 7496
  Description:     Gets a routing rule by its identifier
  Parameters:      inRuleID - identifier of the rule being retrieved
  Returns:         cursor  representing  specified routing rule
  Used:            FinTP/BASE/RE
***********************************************/

BEGIN

   open outretcursor for
      select id, queueid, description, messagecondition, functioncondition,  metadatacondition,  action
        from  fincfg.routingrules where  id = inRuleID;

EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while retrieving routing rule: %', SQLERRM;
       
END;
$$;


ALTER FUNCTION fincfg.getrule(inruleid integer, OUT outretcursor refcursor) OWNER TO fincfg;

--
-- TOC entry 369 (class 1255 OID 62554)
-- Name: getrulesforschema(character varying); Type: FUNCTION; Schema: fincfg; Owner: fincfg
--

CREATE FUNCTION getrulesforschema(OUT outretcursor refcursor, inschemaname character varying) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
DECLARE

/*
* FinTP - Financial Transactions Processing Application
* Copyright (C) 2013 Business Information Systems (Allevo) S.R.L.
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program. If not, see <http://www.gnu.org/licenses/>
* or contact Allevo at : 031281 Bucuresti, 23C Calea Vitan, Romania,
* phone +40212554577, office@allevo.ro <office@allevo.ro>, www.allevo.ro.
*/
/************************************************
  Change history:  dd.mon.yyyy  --  author  --   description
  Created:         29.May.2013, DenisaN 7496
  Description:     Gets routing definition for the specified routing schema
  Parameters:      inSchemaName - name of the routing schema
  Returns:         cursor  representing the routing definition
  Used:            FinTP/BASE/RE
***********************************************/    
 
BEGIN

   open outretcursor for
        select rr.id, rr.sequence, rr.ruletype from fincfg.routingrules rr
       join fincfg.routingschemas rs 
       on rs.id = rr.routingschemaid and  rs.name = inschemaname;


EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while retrieving rules: %', SQLERRM;
       
END;
$$;


ALTER FUNCTION fincfg.getrulesforschema(OUT outretcursor refcursor, inschemaname character varying) OWNER TO fincfg;

--
-- TOC entry 368 (class 1255 OID 62555)
-- Name: getservicestate(); Type: FUNCTION; Schema: fincfg; Owner: fincfg
--

CREATE FUNCTION getservicestate() RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
DECLARE

/*
* FinTP - Financial Transactions Processing Application
* Copyright (C) 2013 Business Information Systems (Allevo) S.R.L.
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program. If not, see <http://www.gnu.org/licenses/>
* or contact Allevo at : 031281 Bucuresti, 23C Calea Vitan, Romania,
* phone +40212554577, office@allevo.ro <office@allevo.ro>, www.allevo.ro.
*/
/************************************************
  Change history:  dd.mon.yyyy  --  author  --   description
  Created:         06.Dec.2013, DenisaN
  Description:     Collects service statistic data
  Parameters:      n/a
  Returns:         outRetCursor  cursor  representing service info
  Used:            FinTP/BASE/RE
***********************************************/

v_cursor REFCURSOR;

BEGIN
 
   
  open v_cursor for
     select id, status, name, heartbeatinterval, sessionid from fincfg.servicemaps;
  return (v_cursor);
     
EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while retrieving active schemas: %', SQLERRM;
       
END;
$$;


ALTER FUNCTION fincfg.getservicestate() OWNER TO fincfg;

--
-- TOC entry 370 (class 1255 OID 62556)
-- Name: gettimelimits(); Type: FUNCTION; Schema: fincfg; Owner: fincfg
--

CREATE FUNCTION gettimelimits(OUT outretcursor refcursor) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$DECLARE

/*
* FinTP - Financial Transactions Processing Application
* Copyright (C) 2013 Business Information Systems (Allevo) S.R.L.
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program. If not, see <http://www.gnu.org/licenses/>
* or contact Allevo at : 031281 Bucuresti, 23C Calea Vitan, Romania,
* phone +40212554577, office@allevo.ro <office@allevo.ro>, www.allevo.ro.
*/
/************************************************
  Change history:  dd.mon.yyyy  --  author  --   description
  Created:         29.May.2013, DenisaN 
  Description:     Gets the time limits
  Parameters:      n/a
  Returns:         cursor  representing schema time limits
  Used:            FinTP/BASE/RE
***********************************************/

BEGIN

  open outretcursor for
    select id, name, to_char(cutoff, 'HH24:Mi:ss') limittime from fincfg.timelimits;

EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while retrieving time limits: %', SQLERRM;
       
END;
$$;


ALTER FUNCTION fincfg.gettimelimits(OUT outretcursor refcursor) OWNER TO fincfg;

--
-- TOC entry 371 (class 1255 OID 62557)
-- Name: getusername(integer); Type: FUNCTION; Schema: fincfg; Owner: fincfg
--

CREATE FUNCTION getusername(inuserid integer) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE

/*
* FinTP - Financial Transactions Processing Application
* Copyright (C) 2013 Business Information Systems (Allevo) S.R.L.
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program. If not, see <http://www.gnu.org/licenses/>
* or contact Allevo at : 031281 Bucuresti, 23C Calea Vitan, Romania,
* phone +40212554577, office@allevo.ro <office@allevo.ro>, www.allevo.ro.
*/
/************************************************
  Change history:  dd.mon.yyyy  --  author  --   description
  Created:        23.Sep.2015, DenisaN 
  Description:    Returns the username one given user identifier
  Parameters:     user identifier
  Returns:        user name
  Used:           FinTP/BASE/DB
***********************************************/

v_uname varchar;

BEGIN

     select username into v_uname from fincfg.users where id = inuserid;
     return v_uname;

EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while retrieving user name: %', SQLERRM;
       
END;
$$;


ALTER FUNCTION fincfg.getusername(inuserid integer) OWNER TO fincfg;

--
-- TOC entry 372 (class 1255 OID 62558)
-- Name: updateservicestate(integer, integer, character varying); Type: FUNCTION; Schema: fincfg; Owner: fincfg
--

CREATE FUNCTION updateservicestate(inserviceid integer, instatus integer, insessionid character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE

/*
* FinTP - Financial Transactions Processing Application
* Copyright (C) 2013 Business Information Systems (Allevo) S.R.L.
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program. If not, see <http://www.gnu.org/licenses/>
* or contact Allevo at : 031281 Bucuresti, 23C Calea Vitan, Romania,
* phone +40212554577, office@allevo.ro <office@allevo.ro>, www.allevo.ro.
*/
/************************************************
  Change history:  dd.mon.yyyy  --  author  --   description
  Created:         29.May.2013, DenisaN
  Description:     Updates the state of the specified service
  Parameters:      inServiceID - service identifier to be updated
                   inStatus - service new state
                   inSessionID - session identifier
  Returns:         n/a
  Used:            FinTP/BASE/RE
***********************************************/ 

BEGIN

  update fincfg.servicemaps set status = inStatus, sessionid = inSessionID where id = inServiceID;


EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while updating service status: %', SQLERRM;
       
END;
$$;


ALTER FUNCTION fincfg.updateservicestate(inserviceid integer, instatus integer, insessionid character varying) OWNER TO fincfg;

--
-- TOC entry 373 (class 1255 OID 62559)
-- Name: updateversion(character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: fincfg; Owner: fincfg
--

CREATE FUNCTION updateversion(inservicename character varying, inname character varying, inversion character varying, inmachine character varying, inhash character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$DECLARE

/*
* FinTP - Financial Transactions Processing Application
* Copyright (C) 2013 Business Information Systems (Allevo) S.R.L.
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program. If not, see <http://www.gnu.org/licenses/>
* or contact Allevo at : 031281 Bucuresti, 23C Calea Vitan, Romania,
* phone +40212554577, office@allevo.ro <office@allevo.ro>, www.allevo.ro.
*/
/************************************************
  Change history:  dd.mon.yyyy  --  author  --   description
  Created:         18.Feb.2014, DenisaN
  Description:     Update app service version 
  Parameters:      inservicename  - service name
                   inname - short description
                   inversion - current version
                    inmachine - hosting machine
                   inhash - hash value                         
  Returns:         n/a
  Used:            FinTP/BASE/EW
***********************************************/

v_count integer;

BEGIN

  select count(servicename) into v_Count from fincfg.versions where servicename=inServiceName;

  if v_Count > 0 then
     
        update fincfg.versions set servicename=inServiceName, name=inName,
                version=inVersion, machine=inMachine, hash=inHash where servicename=inServiceName;
         
     else
     
        insert into fincfg.versions( servicename, name, version, machine, hash ) 
                             values( inServiceName, inName, inVersion, inMachine, inHash );
        
  end if;
     
         

EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while config app: %', SQLERRM;
       
END;
$$;


ALTER FUNCTION fincfg.updateversion(inservicename character varying, inname character varying, inversion character varying, inmachine character varying, inhash character varying) OWNER TO fincfg;


CREATE FUNCTION editedtxabort() RETURNS refcursor
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
  Created:         13.Jan.2020 - dd, 14477
  Description:     
  Parameters:      n/a
  Returns:         cursor result set
  Used:            
***********************************************/


BEGIN

    update finbo.editedtransactions set status = 9  where status = 1;
     
EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while gathering message: % ', SQLERRM;
       
END;
$$;


ALTER FUNCTION finbo.editedtxabort() OWNER TO finbo;

--
-- TOC entry 447 (class 1255 OID 183396)
-- Name: editedtxcommit(); Type: FUNCTION; Schema: finbo; Owner: finbo
--

CREATE FUNCTION editedtxcommit() RETURNS refcursor
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
  Created:         13.Jan.2020 - dd, 14477
  Description:     
  Parameters:      n/a
  Returns:         cursor result set
  Used:            
***********************************************/


BEGIN

    update finbo.editedtransactions set status = 2  where status = 1;
     
EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while gathering message: % ', SQLERRM;
       
END;
$$;


ALTER FUNCTION finbo.editedtxcommit() OWNER TO finbo;

--
-- TOC entry 449 (class 1255 OID 183397)
-- Name: editedtxsearchfordata(); Type: FUNCTION; Schema: finbo; Owner: finbo
--

CREATE FUNCTION editedtxsearchfordata(OUT outretcursor refcursor) RETURNS refcursor
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
  Created:         13.Jan.2020 - dd, 14477
  Description:     
  Parameters:      n/a
  Returns:         cursor result set
  Used:            
***********************************************/

v_msgid     varchar(32);

BEGIN

    select correlationid "ROWID" into v_msgid from finbo.editedtransactions where status = 0 limit 1;
     
    update finbo.editedtransactions set status = -1 where correlationid = v_msgid;

    if v_msgid is not null then
    open outretcursor for 
       select v_msgid "ROWID";  
    else
       open outretcursor for 
       select v_msgid "ROWID" where 1=2;  
    end if; 

EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while gathering message: % ', SQLERRM;
       
END;
$$;


ALTER FUNCTION finbo.editedtxsearchfordata(OUT outretcursor refcursor) OWNER TO finbo;

--
-- TOC entry 451 (class 1255 OID 183398)
-- Name: editedtxselectforprocess(character varying); Type: FUNCTION; Schema: finbo; Owner: finbo
--

CREATE FUNCTION editedtxselectforprocess(OUT outretcursor refcursor, inmsgid character varying) RETURNS refcursor
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
  Created:         13.Jan.2020 - dd, 14477
  Description:     
  Parameters:      n/a
  Returns:         cursor result set
  Used:            
***********************************************/


BEGIN

    update finbo.editedtransactions set status = 1  where status = -1  and correlationid = inmsgID;
     
     open outretcursor for
        select translate(encode(payload::bytea, 'base64'), E'\n', '') payload, correlationid from finbo.editedtransactions where correlationid = inmsgID;
  

EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while gathering message: % ', SQLERRM;
       
END;
$$;


ALTER FUNCTION finbo.editedtxselectforprocess(OUT outretcursor refcursor, inmsgid character varying) OWNER TO finbo;

--
-- TOC entry 450 (class 1255 OID 183400)
-- Name: manualtxabort(); Type: FUNCTION; Schema: finbo; Owner: finbo
--

CREATE FUNCTION manualtxabort() RETURNS refcursor
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
  Created:         13.Jan.2020 - dd, 14406
  Description:     
  Parameters:      n/a
  Returns:         cursor result set
  Used:            
***********************************************/


BEGIN

    update finbo.manualtransactions set status = 9  where status = 1;
     
EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while gathering message: % ', SQLERRM;
       
END;
$$;


ALTER FUNCTION finbo.manualtxabort() OWNER TO finbo;

--
-- TOC entry 448 (class 1255 OID 183401)
-- Name: manualtxcommit(); Type: FUNCTION; Schema: finbo; Owner: finbo
--

CREATE FUNCTION manualtxcommit() RETURNS refcursor
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
  Created:         13.Jan.2020 - dd, 14406
  Description:     
  Parameters:      n/a
  Returns:         cursor result set
  Used:            
***********************************************/


BEGIN

    update finbo.manualtransactions set status = 2  where status = 1;
     
EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while gathering message: % ', SQLERRM;
       
END;
$$;


ALTER FUNCTION finbo.manualtxcommit() OWNER TO finbo;

--
-- TOC entry 452 (class 1255 OID 183402)
-- Name: manualtxsearchfordata(); Type: FUNCTION; Schema: finbo; Owner: finbo
--

CREATE FUNCTION manualtxsearchfordata(OUT outretcursor refcursor) RETURNS refcursor
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
  Created:         13.Jan.2020 - dd, 14477
  Description:     
  Parameters:      n/a
  Returns:         cursor result set
  Used:            
***********************************************/

v_msgid     varchar(32);

BEGIN

    select id::char "ROWID" into v_msgid from finbo.manualtransactions where status = 0 and rownum = 1;
     
    update finbo.manualtransactions set status = -1 where id = v_msgid;

    open outretcursor for 
       select v_msgid "ROWID";   

EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while gathering message: % ', SQLERRM;
       
END;
$$;


ALTER FUNCTION finbo.manualtxsearchfordata(OUT outretcursor refcursor) OWNER TO finbo;

--
-- TOC entry 453 (class 1255 OID 183403)
-- Name: manualxselectforprocess(character varying); Type: FUNCTION; Schema: finbo; Owner: finbo
--

CREATE FUNCTION manualxselectforprocess(OUT outretcursor refcursor, inmsgid character varying) RETURNS refcursor
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
  Created:         13.Jan.2020 - dd, 14406
  Description:     
  Parameters:      n/a
  Returns:         cursor result set
  Used:            
***********************************************/


BEGIN

    update finbo.manualtransactions set status = 1  where status = -1  and id = inmsgID;
     
     open outretcursor for
        select encode(payload, 'base64') payload from finbo.manualtransactions where id = inmsgID;
  

EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while gathering message: % ', SQLERRM;
       
END;
$$;


ALTER FUNCTION finbo.manualxselectforprocess(OUT outretcursor refcursor, inmsgid character varying) OWNER TO finbo;

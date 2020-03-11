--
-- PostgreSQL database dump
--

CREATE FUNCTION abortjob(injobid character varying) RETURNS void
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
  Change history: dd.mon.yyyy  --  author  --   description
  Created:        17.May.2013,DenisaN - 7164
  Description:    Removes one given routing job.Reason:aborted;
  Parameters:     inJobID - routing job identifier
  Returns:        n/a
  Used:          FinTP/BASE/RE
***********************************************/

BEGIN

   delete from findata.routingjobs where id = inJobID;


EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while deleting job: %', SQLERRM;
       
END;
$$;


ALTER FUNCTION findata.abortjob(injobid character varying) OWNER TO findata;

--
-- TOC entry 375 (class 1255 OID 62561)
-- Name: batchjob(character varying, integer, character varying, character varying, character varying, text, character varying, character varying); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION batchjob(injobid character varying, insequence integer, incombatchid character varying, incorrelid character varying, infeedback character varying, inxformitem text, initemamountbdp character varying, initemamountadp character varying, OUT outbatchstatus integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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
  Created:         27.Mar.2013, DenisaN
  Description:     Includes a message in a batch and updates totals
  Parameters:      inJobID  -  routing job identifier          
                   inSequence   -  rule sequence
                   inComBatchID   -  batch identifier
                   inCorrelID  - message correlation identifier        
                   inFeedback   -    feedback code
                   inXformItem  -  transformed (xslt) payload                              
  Returns:         outBatchStatus parameter representing the batch status 
  Used:            FinTP/BASE/RE
***********************************************/

DECLARE

BEGIN

   update findata.batchjobs set status = case when currentmessagecount = messagecount - 1 and  status < 15  then 15
 					                               when status = 0 then 10
     						                       else status                     
					                          end, 
			                    currentmessagecount = currentmessagecount + 1,  
			                    insertdate = now()
   where batchid = inComBatchID returning status into outBatchStatus;   

   -- defer job, if batch not completed/failed
   if outBatchStatus = 10 or outBatchStatus = 15 then
      perform findata.deferbatchjob(inJobID,  inCombatchID, inCorrelID,  inFeedback,  inSequence,  inXformItem); 
   end if;

EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while creating batch: %', SQLERRM;
       
END;
$$;


ALTER FUNCTION findata.batchjob(injobid character varying, insequence integer, incombatchid character varying, incorrelid character varying, infeedback character varying, inxformitem text, initemamountbdp character varying, initemamountadp character varying, OUT outbatchstatus integer) OWNER TO findata;

--
-- TOC entry 376 (class 1255 OID 62565)
-- Name: commitjob(character varying); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION commitjob(injobid character varying) RETURNS void
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
                   10.Feb.2014, DenisaN - review 
  Created:         17.May.2013,DenisaN - 7164
  Description:     Removes one given routing job. Reason:commited;
  Parameters:      inJobID - routing job identifier
  Returns:         n/a
  Used:            FinTP/BASE/RE
***********************************************/


BEGIN

      delete from findata.routingjobs where id = inJobID ;


EXCEPTION
   WHEN OTHERS THEN
         RAISE EXCEPTION 'Unexpected error occured while committing job: %', SQLERRM;
       
END;
$$;


ALTER FUNCTION findata.commitjob(injobid character varying) OWNER TO findata;

--
-- TOC entry 377 (class 1255 OID 62566)
-- Name: createbatchrequest(character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION createbatchrequest(inqueuename character varying, inmsgtype character varying, ingroupkey character varying, intimekey character varying, infield1val character varying, infield2val character varying, infield3val character varying, infield4val character varying, infield5val character varying, inuserid integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$DECLARE

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
  Change history: 05.Jun.2018, DanielC 12857
                  06.Jan.2016, DenisaN 9496                       
  Created:        02.Apr.2014, DenisaN 7488
  Description:   Initiates the batching mechanism; gathers messages in given group and assignes routing jobs.  
  Parameters:    inqueuename   - queue name
                 inmsgtype     - message type [for messages in group]
                 ingroupkey    - message group key [unique hash]
                 intimekey     - message group time reference
                 infield1val   - kword1 group value 
                 infield2val   - kword2 group value
                 infield3val   - kword3 group value
                 infield4val   - kword4 group value
                 infield5val   - kword5 group value
                 inusername    - user name 
  Returns:       cursor
  Used:          FinTP/BASE/UI
***********************************************/             

v_groupkey        varchar(100);
v_filterfields    varchar(1000);
v_qreportingview  varchar(35);
v_maxbatchcnt     integer;
v_priority        integer;
v_batchuid        varchar(30);
v_batchuidold     varchar(30) default 'X';
v_guid            varchar(30);
v_func            varchar(1000);
v_msgs            refcursor;
    
BEGIN

  --get specific storage
  select reportingstorage into v_qreportingview from fincfg.messagetypes where messagetype = inmsgtype;   
      
  --get specific filter fields
  select case when routingkeyword1 is not null then ' and '||routingkeyword1||' = '''||infield1val||'''' else ' ' end ||
         case when routingkeyword2 is not null then ' and '||routingkeyword2||' = '''||infield2val||'''' else ' ' end ||
         case when routingkeyword3 is not null then ' and '||routingkeyword3||' = '''||infield3val||'''' else ' ' end ||
         case when routingkeyword4 is not null then ' and '||routingkeyword4||' = '''||infield4val||'''' else ' ' end ||
         case when routingkeyword5 is not null then ' and '||routingkeyword5||' = '''||infield5val||'''' else ' ' end         
  into v_filterfields
  from fincfg.queuemessagegroups where messagetype = inmsgtype;

  --recompute group key
  execute 
 ' select md5(string_agg(id,'''' order by id)) '||
 ' from findata.'||v_qreportingview||' where queuename = $1 '||
         ' and insertdate <= $2'||v_filterfields
  into v_groupkey
  using inqueuename, to_timestamp(intimekey, 'ddmmyyyyhh24:mi:ss');
   
if v_groupkey = ingroupkey then
         
     --max msgs per batch
     select maxtrxonbatch, priority into v_maxbatchcnt, v_priority from fincfg.queues where name = inqueuename;
     
  --insert Batch routing jobs
  open v_msgs for execute
     ' select id, '||      
       ' ''F=Route, F=Unhold,''|| '||
       ' ''P=GroupOrder(''|| ( row_number() over ( partition by ceil(rn/$1 ) order by rn) ) ||''), ''|| '||
       ' ''P=GroupCount('' || ( count( rn ) over ( partition by ceil(rn/$1) ) )  || ''), ''|| '||
       ' ''P=BatchID('' || trim( max( id ) over ( partition by ceil(rn/$1) ) ) || ''), ''|| '||
       ' ''P=BatchSum('' || to_char(sum(  to_number(CASE 
                       WHEN (rtrim((amount)::text) IS NULL) THEN ''0,00''::text 
                       WHEN (rtrim((amount)::text) = ''''::text) THEN ''0,00''::text 
                       WHEN (rtrim((amount)::text) = '',''::text) THEN ''0,00''::text 
                       ELSE replace(rtrim((amount)::text), '',''::text, ''.''::text) END, ''FM99999999999999999D99''::text))  
                      over ( partition by ceil(rn/$1) ), ''FM999999999999999990D99'')||''), ''|| '||
       case when inmsgtype = 'MFILoanDisb' then
       ' ''P=BatchRef('' ||''ENCOT '' || to_char(current_date, ''dd-mm-yyyy'') ||'' AU ''|| '')'' func, '
            when inmsgtype = 'MFILoanRepay' then
       ' ''P=BatchRef('' ||''ENCOT '' || to_char(current_date, ''dd-mm-yyyy'') ||'' FU ''|| '')'' func, '
            when inmsgtype in ('CstmrCdtTrfInitnSala', 'CstmrCdtTrfInitnSupp', 'CstmrCdtTrfInitnTaxs', 'CstmrCdtTrfInitnVatx', 'CstmrCdtTrfInitnOthr') then
       ' ''P=BatchRef('' || to_char(current_date, ''YYMMDD'') || '')'' func, '
           else
       ' ''P=BatchRef('' || substr( receiver, 1, 4 ) || to_char(current_date, ''yyyymmdd'') || '')'' func, '
       end||                            
       ' trim( max (id) over ( partition by ceil(rn/$1) ) ) batchuid '||                 
    ' from '||
      '( select id, receiver, amount, row_number() over () rn, count(receiver) over (partition by receiver) tm '||
       ' from findata.'||v_qreportingview|| ' where queuename = $2 and insertdate <= $3 '||v_filterfields||
     ' ) tmp '  
  using  v_maxbatchcnt, inQueueName, to_timestamp(intimekey, 'ddmmyyyyhh24:mi:ss');       
  loop          
     fetch v_msgs into v_guid, v_func, v_batchuid;
     exit when not found;
                  
     insert into findata.routingjobs(id, status, priority, backout, routingpoint, function, userid)  
                              values(v_guid, 0, v_priority, 0, inQueueName, v_func, inuserid);
             
     --register batch request / batchuid - group key correlation                   
     if (v_batchuidold != v_batchuid and v_batchuid is not null) then
         
         insert into findata.batchrequests(groupkey, batchuid, userid) 
                                    values(v_groupkey, v_batchuid, inuserid);     
         v_batchuidold := v_batchuid;
     end if;                      
  end loop;
       
  close v_msgs;   
    
else 
    raise exception 'data_changed';
  
end if;
 

EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while creating batch: %', SQLERRM;

END;
$_$;


ALTER FUNCTION findata.createbatchrequest(inqueuename character varying, inmsgtype character varying, ingroupkey character varying, intimekey character varying, infield1val character varying, infield2val character varying, infield3val character varying, infield4val character varying, infield5val character varying, inuserid integer) OWNER TO findata;

--
-- TOC entry 378 (class 1255 OID 62569)
-- Name: createroutingjob(character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION createroutingjob(inqueuename character varying, inaction character varying, inreason character varying, inactiondetails character varying, inmsgtype character varying, inmsgid character varying, ingroupkey character varying, intimekey character varying, infield1val character varying, infield2val character varying, infield3val character varying, infield4val character varying, infield5val character varying, inuserid integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE


/************************************************
  Change history: dd.mon.yyyy  --  author  --   description   
                  10.Jan.2020, dd 14477                   
  Created:        26.Jul.2018, dd 12964
  Description:    Create routing jobs for given user actions;  
  Parameters:    inqueuename   - queue name
                 inmsgtype     - message type 
                 inactioan     - internal action name
                 inmsgid       - message identifier [for single transaction actions]
                 ingroupkey    - message group key [unique hash]
                 intimekey     - message group time reference
                 infield1val   - kword1 group value 
                 infield2val   - kword2 group value
                 infield3val   - kword3 group value
                 infield4val   - kword4 group value
                 infield5val   - kword5 group value
                 inusername    - user name 
  Returns:       cursor
  Used:          FinTP/BASE/UI
***********************************************/             

v_priority    integer;
v_function    varchar(255);
v_qname varchar(50);
 
BEGIN

 if inaction = 'Batch' then
    perform findata.createbatchrequest(inqueuename, inmsgtype, ingroupkey, intimekey, 
                               infield1val, infield2val, infield3val, infield4val, infield5val, inuserid);

 elsif inaction in ('Route', 'Reject', 'Suspend', 'Investigate', 'Edit', 'Complete') then
  
        if inaction = 'Route' then
                                      v_priority :=  80;
                                      v_function := 'F=Route, F=Unhold';
                                                  
         elsif inaction = 'Reject' and inreason = 'duplicate' then
                                      v_priority :=  70;
                                      v_function := 'F=Unhold, F=Complete, P=Feedback(PDM00)'; 
                                        
         elsif inaction = 'Reject' and inreason = 'others' then
                                      v_priority :=  70;
                                      v_function := 'F=Unhold, F=Complete, P=Feedback(FTP09)'; 
                                        
         elsif inaction = 'Suspend' and inreason = 'duplicate' then
                                      v_priority :=  70;
                                      v_function := 'F=Unhold, F=Complete, P=Feedback(PDM10), P=NoReply(true)'; 

         elsif inaction = 'Suspend' and inreason = 'others' then
                                      v_priority :=  70;
                                      v_function := 'F=Unhold, F=Complete, P=Feedback(FTP19), P=NoReply(true)'; 

         elsif inaction = 'Complete' then --not user action;used for edit
                                      v_priority :=  70;
                                      v_function := 'F=Unhold, F=Complete, P=NoReply(true)'; 

           
         elsif inaction = 'Investigate' and inmsgtype in ('CstmrCdtTrfInitnVatx', 'CstmrCdtTrfInitnTaxs', 
'CstmrCdtTrfInitnSupp', 'CstmrCdtTrfInitnSala', 'CstmrCdtTrfInitnOthr') then
                    select name into v_qname from fincfg.queues where messagetypesbusinessarea = 'Payments';
                    v_priority :=  70;
                    v_function := 'F=Unhold, F=Dispose, P=Destination('||v_qname||')'; 
             
          elsif inaction = 'Edit' and inmsgtype in ('CstmrCdtTrfInitnVatx', 'CstmrCdtTrfInitnTaxs', 
'CstmrCdtTrfInitnSupp', 'CstmrCdtTrfInitnSala', 'CstmrCdtTrfInitnOthr') then                  
                    v_priority :=  70;
                    v_function := 'F=Unhold, F=Dispose, P=Destination(Edit)'; 

         else raise exception 'bad_req_excp';
         end if;

    begin  
       insert into findata.routingjobs(id, status, backout, priority, routingpoint, function, userid, operationdetails)
                        values(inmsgid, 0, 0, v_priority, inqueuename, v_function, inuserid, inactiondetails);
      exception when unique_violation then 
       raise exception 'already_exists_excp';
     end;


 else
     raise exception 'bad_req_excp';

 end if;

--operation details, de inclus in evveniment

EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while creating routing job: %', SQLERRM;

END;
$$;


ALTER FUNCTION findata.createroutingjob(inqueuename character varying, inaction character varying, inreason character varying, inactiondetails character varying, inmsgtype character varying, inmsgid character varying, ingroupkey character varying, intimekey character varying, infield1val character varying, infield2val character varying, infield3val character varying, infield4val character varying, infield5val character varying, inuserid integer) OWNER TO findata;

--
-- TOC entry 379 (class 1255 OID 62570)
-- Name: deferbatchjob(character varying, character varying, character varying, character varying, integer, text); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION deferbatchjob(injobid character varying, inbatchid character varying, incorrelid character varying, infeedback character varying, insequence integer, inxformitem text) RETURNS void
    LANGUAGE plpgsql
    AS $$
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
  Created:         27.Mar.2013, DenisaN
  Description:     Deffers one given batch job;
  Parameters:      inJobID - routing job identifier
                   inBatchID - batch identifier - computed by RE
                   inCorrelID  -  correlation identifier
                   inFeedback - feedback code
                   inSequence - routing sequence
                   inXformItem - 
  Returns:         n/a
  Used:            FinTP/BASE/RE
***********************************************/

DECLARE


BEGIN

  insert into findata.tempbatchjobs (id, sequence, batchid, correlationId, feedback, xformitem) 
                            values  (inJobID, inSequence, inBatchID, inCorrelID, inFeedback, inXformItem);

EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while deffering job. Message is: %', SQLERRM;
       
END;
$$;


ALTER FUNCTION findata.deferbatchjob(injobid character varying, inbatchid character varying, incorrelid character varying, infeedback character varying, insequence integer, inxformitem text) OWNER TO findata;

--
-- TOC entry 455 (class 1255 OID 184102)
-- Name: deferjob(character varying, integer, character varying, character varying, integer); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION deferjob(injobid character varying, inqueueid integer, inroutingpoint character varying, inroutingfunction character varying, inroutinguser integer) RETURNS void
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
  Created:         17.May.2013, DenisaN - 7164
  Description:     Defers one given routing job;
  Parameters:      inJobID - routing job identifier
                   inQueueID - queue identifier
                   inRoutingPoint  - queue name   
                   inRoutingFunction - routing function
                   inRoutingUser - user identifier
  Returns:         n/a
  Used:            FinTP/BASE/RE
***********************************************/

BEGIN

  update routingjobs  set status    = inQueueID,  routingpoint = inRoutingPoint,  function  = inRoutingFunction, userid   = inRoutingUser
                where routingjobs.id = inJobID;

EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while deffering job: %', SQLERRM;
       
END;
$$;


ALTER FUNCTION findata.deferjob(injobid character varying, inqueueid integer, inroutingpoint character varying, inroutingfunction character varying, inroutinguser integer) OWNER TO findata;

--
-- TOC entry 380 (class 1255 OID 62572)
-- Name: deletemessagefromqueue(character varying, character varying, integer); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION deletemessagefromqueue(inguid character varying, inqueuename character varying, inisreply integer) RETURNS void
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
  Change history:      dd.mon.yyyy  --  author  --   description
                       20.Mar.2014, DenisaN 8303
  Created:             09.Aug.2013, LucianP 7163
  Description:         Removes messages from queue [message has been routed to the end point] or
                                   removes reply messages from queue.  
  Parameters:          inGuid - message identifier
                       inQueueName -  destination queue name [null]
                       inIsReply - 1/0 values whether the message is a reply                                   
  Returns:             n/a
  Used:                FinTP/BASE/RE
***********************************************/


BEGIN
    if inIsReply = 0 then
        
        update findata.routedmessages set currentqueue = null where correlationid = (select correlationid from entryqueue where id = inGuid);
        delete from findata.entryqueue where id = inGuid;
        
    elsif inIsReply = 1 then    
        delete from findata.entryqueue where id = inGuid;             
    end if;

EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while moving message. Message is: %', SQLERRM;
       
END;
$$;


ALTER FUNCTION findata.deletemessagefromqueue(inguid character varying, inqueuename character varying, inisreply integer) OWNER TO findata;

--
-- TOC entry 357 (class 1255 OID 183196)
-- Name: enrichmessagedata(character varying, character varying, character varying, character varying, character varying, character varying[], character varying); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION enrichmessagedata(inmsgtype character varying, insenderapp character varying, inreceiverapp character varying, inguid character varying, incorrelid character varying, inkwnames character varying[], inentity character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$
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
  Created:         20.Jan.2020, luisa
  Description:     Update every routed message into common table and specific tables.
  Parameters:      inMsgType       - message type to be updated
		           inCorrelID      - correlation identifier  
		           inKWNames       - message keywords [see cfg.routingkeywordmapps] followed by their values
  Returns:        
  Used:            FinTP/BASE/RE
***********************************************/


v_ReferenceIdx     integer default 0;
v_SenderIdx        integer default 0;
v_ReceiverIdx      integer default 0;
v_AmountIdx        integer default 0;
v_tablename        varchar(35);
v_updatefields     varchar(2000) default '(';
v_updatevalues     varchar(2000) default '(';
v_half             integer;
--v_kwvalues         varchar[];
v_dateformat       varchar(6);
v_ioidentifier     varchar(1);

BEGIN

     v_half:= array_length(inKWNames,1)/2;
     
     for i in 1..v_half loop
            
            case  
                     --extract message common info  and ammount
                      when inKWNames[i] = 'Reference' then v_ReferenceIdx:=i;
                      when inKWNames[i] = 'Sender' then v_SenderIdx:=i;
                      when inKWNames[i] = 'Receiver' then v_ReceiverIdx:=i;
                      --when inKWNames[i] = 'Amount' then v_AmountIdx:=i;
                      
            else 
                      --extract message specific info
                      v_updatefields := v_updatefields||inKWNames[i];

                     if inKWNames[i + v_half] is null then 
					    v_updatevalues := v_updatevalues||''''||'null'||'''';
					    
					  --standard date format
					 elsif lower(inKWNames[i]) like '%date' then                          
                        select findata.getbusinessdateformat(inKWNames[i + v_half]) into v_dateformat;  
                        v_updatevalues := v_updatevalues||''''||v_dateformat||'''';
                          
                     else
       				    v_updatevalues := v_updatevalues||''''||inKWNames[i + v_half]||'''';
       				    
                     end if;
                                 
                     v_updatefields := v_updatefields||',';
                     v_updatevalues := v_updatevalues||','; 
            end case; 
     end loop;  

    --retrieve specific message table storage                                           
    select distinct storage into  v_tablename from fincfg.messagetypes where messagetype =  inMsgType; 
  
   --update message info into storage tables    
    update findata.routedmessages SET (currentqueue, messagetype, sender, receiver, reference, requestorservice, responderservice, entity) 
                                   = (fincfg.getqueueid(insenderapp||'Queue'), inMsgType, inKWNames[v_SenderIdx+v_half], inKWNames[v_ReceiverIdx+v_half], inKWNames[v_ReferenceIdx+v_half], inSenderApp, inReceiverApp, inentity)
        where correlationid = inCorrelID;    
							   
							                                                                                             
 execute 'update findata.'||v_tablename||' SET '||v_updatefields||' correlationid) = '||v_updatevalues||' $1 ) where correlationid = $1' using inCorrelID;
	

EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while updating message: %', SQLERRM;
       
END;
$_$;


ALTER FUNCTION findata.enrichmessagedata(inmsgtype character varying, insenderapp character varying, inreceiverapp character varying, inguid character varying, incorrelid character varying, inkwnames character varying[], inentity character varying) OWNER TO findata;

--
-- TOC entry 445 (class 1255 OID 62575)
-- Name: getbatchjobs(character varying); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION getbatchjobs(OUT outretcursor refcursor, incombatchid character varying) RETURNS refcursor
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
  Created:         02.Dec.2013, DenisaN
  Description:     Gathers info for one batch job not yet completed.
  Parameters:      inCombatchID - computed batch identifier
  Returns:         outRetCursor parameter representing cursor result set
  Used:            FinTP/BASE/RE
***********************************************/

BEGIN

 open outRetCursor for
    select tbj.id id, tbj.sequence, tbj.correlationid, tbj.feedback,
                 tbj.xformitem, bj.routingpoint,  bj.messagecount,   bj.amount
    from findata.tempbatchjobs tbj 
    left  join findata.batchjobs bj on tbj.batchid = bj.batchid 
    where tbj.batchid = inCombatchID;

EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while gathering job info. Message is: %', SQLERRM;
       
END;
$$;


ALTER FUNCTION findata.getbatchjobs(OUT outretcursor refcursor, incombatchid character varying) OWNER TO findata;

--
-- TOC entry 382 (class 1255 OID 62576)
-- Name: getbatchstatus(character varying, integer, integer, character varying, integer, character varying, character varying); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION getbatchstatus(inbatchid character varying, inuserid integer, inbatchcount integer, inbatchamount character varying, inserviceid integer, inroutingpoint character varying, inbatchuid character varying, OUT outbatchstatus integer, OUT outcombatchid character varying) RETURNS record
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
  Change history:   dd.mon.yyyy  --  author  --   description
                    28.Jan.2014, DenisaN 
  Created:          20.Aug.2013, LucianP
  Description:      Creates a batch job, if none existing with the given values   
  Parameters:       inBatchID   - batch identifier
                    inUserID   - user identifier
                    inBatchCount  - no of messages in batch
                    inBatchAmount  - batch total amount
                    inServiceID   - service identifier
                    inRoutingPoint   - queue name
                    inBatchUID   - 
  Returns:          outBatchStatus,  outComBatchID 
                    parameters representing batch identifier and status
  Used:             FinTP/BASE/RE
***********************************************/        

v_comBatchId  character varying(35);
v_serviceSeq  integer;

BEGIN

  -- this select may fail if the batch was not created
  select into outBatchStatus, outComBatchID  
  status, batchid 
  from findata.batchjobs where initialbatchid = inBatchID and userid = inUserID
                           and messagecount = inBatchCount and amount = inBatchAmount
                           and batchuid = inBatchUID ;

  if outBatchStatus is null and outComBatchID is null then 

    --get batchid sequence - service specific
    select findata.getnextservicesequence(inServiceID) into v_serviceSeq; 
    v_comBatchId := inBatchID ||substr(to_char(v_serviceSeq,'0000'),2);

--    ENCOT
--    v_comBatchId := inBatchID ||substr(to_char(v_serviceSeq,'00'),2);

	outBatchStatus := 0; 
  
      --create batching job
	 insert into findata.batchjobs (initialbatchid, userid, messagecount, amount, batchid, currentmessagecount, status,
                                    insertdate, finalamount, routingpoint, batchtype, batchuid)
                                 values (inBatchID, inUserID,  inBatchCount,  inBatchAmount, v_comBatchId,  0, outBatchStatus, 
                                         now(),  0,  inRoutingPoint, 'UnknownType',  inBatchUID)
     returning batchid into outComBatchID;

 end if;


EXCEPTION
WHEN OTHERS THEN
         RAISE EXCEPTION 'Unexpected error occured while retrieving batch status. Message is: %', SQLERRM;
       
END;
$$;


ALTER FUNCTION findata.getbatchstatus(inbatchid character varying, inuserid integer, inbatchcount integer, inbatchamount character varying, inserviceid integer, inroutingpoint character varying, inbatchuid character varying, OUT outbatchstatus integer, OUT outcombatchid character varying) OWNER TO findata;

--
-- TOC entry 381 (class 1255 OID 62579)
-- Name: getbatchtype(character varying, character varying, character varying); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION getbatchtype(inbatchid character varying, intablename character varying, insender character varying, OUT outbatchtype character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$
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
                   03.Jun.2014, DenisaN
  Created:         20.Aug.2013, LucianP
  Description:     Gets the batch type for one given batch
  Parameters:      inBatchID  - batch identifier
                   inTableName - batch table
                   inSender - sender bank BIC
  Returns:         outBatchType  parameter representing the batch type
  Used:            FinTP/BASE/RE
***********************************************/          

v_stmt  character varying(250);

BEGIN

      if inSender = '' then           
         --  get batch type from outgoing batch storage
         v_stmt := 'select batchtype from findata.' || inTableName || ' t where batchid = $1'; 
         execute v_stmt into outBatchType using inBatchID;
      else
        -- get batch type from incoming batch storage
         v_stmt := 'select batchtype from findata.' || inTableName || ' t where batchid = $1 and sender = $2';
         execute v_stmt into outBatchType using inBatchID, inSender ;
      end if;

EXCEPTION
   WHEN NO_DATA_FOUND THEN 
         outBatchType := null;
   WHEN OTHERS THEN
         RAISE EXCEPTION 'Unexpected error occured while retrieving batch type. Message is: %', SQLERRM;
       
END;
$_$;


ALTER FUNCTION findata.getbatchtype(inbatchid character varying, intablename character varying, insender character varying, OUT outbatchtype character varying) OWNER TO findata;

--
-- TOC entry 353 (class 1255 OID 101636)
-- Name: getbusinessareabyid(character varying); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION getbusinessareabyid(incorelid character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$

DECLARE

/************************************************
  Change history: dd.mon.yyyy  --  author  --   description                      
  Created:        06.Feb.2019 - DanielC - 13035
  Description:    Create routing jobs for given user actions;  
  Parameters:    incorelid   - correlation id
  Returns:       business area
  Used:          FinTP/BASE/UI
***********************************************/             

v_msgtype character varying;
v_area    character varying;
 
BEGIN

	select messagetype into v_msgtype from findata.routedmessages where correlationid = incorelid;
    select businessarea into v_area from fincfg.messagetypes where messagetype = v_msgtype;
    RETURN v_area;
    

EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while creating routing job: %', SQLERRM;

END;

$$;


ALTER FUNCTION findata.getbusinessareabyid(incorelid character varying) OWNER TO findata;

--
-- TOC entry 383 (class 1255 OID 62580)
-- Name: getbusinessdateformat(character varying); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION getbusinessdateformat(indate character varying) RETURNS character varying
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
  Created:         03.Feb.2014, DenisaN 
  Description:     Returns business standard date format  
  Parameters:      inDate - date to be formatted		 
  Returns:         [yymmdd]
  Used:            FinTP/BASE/DB
***********************************************/


BEGIN

        
    if length(inDate) = 8 then
        return substr(inDate,3,6);
    elsif inDate like '%-%'  then 
        return substr(replace(inDate,'-',''),3,6);
    else
        return inDate;
    end if;
                   

EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while inserting message: %', SQLERRM;
       
END;
$$;


ALTER FUNCTION findata.getbusinessdateformat(indate character varying) OWNER TO findata;

--
-- TOC entry 384 (class 1255 OID 62581)
-- Name: getdipayments(character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, numeric, numeric, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying, character varying, character varying, integer, integer); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION getdipayments(insdatemin character varying, insdatemax character varying, inmsgtype character varying, insender character varying, inreceiver character varying, inref character varying, inissdate character varying, inmatdate character varying, inamtmin numeric, inamtmax numeric, inccy character varying, indacc character varying, indcname character varying, indbtid character varying, incacc character varying, inccname character varying, indirect character varying, instate character varying, inbatchid character varying, inuserid integer, inqname character varying, inordfield character varying, inorddir character varying, inllimit integer, inulimit integer, OUT outretcursor refcursor) RETURNS refcursor
    LANGUAGE plpgsql
    AS $_$DECLARE

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
  Change history:  05.Jun.2015, CRaluca 8817
  Created:         25.Mar.2014, DenisaN 8307
  Description:    Gathers data for the Debit Instruments reporting according to the given filtering     
  Parameters:     insdatemin - low date interval value
                  insdatemax - high date interval value
                  inmsgtype  - message type
                  insender   - sender BIC
                  inreceiver - receiver BIC
                  inref      - tx reference
                  inissdate  - issuance date
                  inmatdate  - maturity date
                  inamtmin   - low amount interval value
                  inamtmax   - high amount interval value
                  inccy      - currency
                  indacc     - dbt account
                  indcname   - dbt cust name
                  incacc     - cdt account
                  inccname   - cdt cust name
                  indirect   - I/O direction
                  instate    - tx state
                  inbatchid  - batchid
                  inuserid   - user identifier
                  inqname    - queue name
                  inordfield - order by field
                  inorddir   - order by direction 
                  inllimit   - low limit / msg per page
                  inulimit   - upper limit / msg per page                          
  Returns:        cursor
  Used:           FinTP/BASE/UI Direct Debit
***********************************************/

BEGIN

open outretcursor for execute
 'select * from ('||
 ' select tmp.*, max(tmp.rnum) over() rnummax'||
 ' from ( '||
 ' select  row_number() over (order by '||coalesce(inordfield, 'insertdate ')||' '||coalesce(inorddir, ' desc')||' ) rnum, '||   
         ' insertdate, messagetype, sender, receiver, reference, issuancedate, maturitydate, amount, currency,	'||
         ' dbtaccount, dbtcustomername, dbtid, cdtaccount, cdtcustomername, '||
         ' direction, case when errcode is null then state '||
                         ' else state||'' [''||errcode||'']'' '||
                    ' end state, batchid, userid, correlationid, queuename ' ||
  ' from findata.repstatdi '||
  ' where insertdate >= to_timestamp($1,''dd mm yyyy hh24:mi:ss'') and insertdate <= to_timestamp($2,''dd mm yyyy hh24:mi:ss'') '||
       ' and  ( $3 is null or  messagetype = $4 )'||
       ' and  ( $5 is null or lower(sender) = lower($6) ) '||       
       ' and  ( $7 is null or lower(receiver) = lower($8) ) '||       
       ' and  ( $9 is null or lower(reference) like lower(''%''||$10||''%'')) '||
       ' and  ( $11 is null or issuancedate = $12) ' ||
       ' and  ( $13 is null or maturitydate = $14) ' ||
       ' and ( (amount >= coalesce($15,0) and amount <= coalesce($16,99999999999999999999) ) )'||
       ' and ( $17 is null or currency = $18 ) ' ||
       ' and ( $19 is null or lower(dbtaccount) like lower(''%''||$20||''%'')) ' ||
       ' and ( $21 is null or lower(dbtcustomername) like lower(''%''||$22||''%'') ) ' ||
       ' and ( $23 is null or lower(dbtid) like lower(''%''||$24||''%'') ) ' ||
       ' and ( $25 is null or lower(cdtaccount) like lower(''%''||$26||''%'')) ' ||
       ' and ( $27 is null or lower(cdtcustomername) like lower(''%''||$28||''%'')) ' ||
       ' and ( $29 is null or direction = $30) ' ||
       ' and ( $31 is null or state = $32) ' ||
       ' and ( $33 is null or lower(batchid) like lower(''%''||$34||''%'')) ' ||
       ' and ( $35 is null or userid = $36 ) ' ||
       ' and ( $37 is null or lower(queuename)= lower($38) ) ' ||
  ' order by '||coalesce(inordfield, 'insertdate')||' '||coalesce(inorddir, 'desc')||') tmp ) tmp1'||
  ' where rnum > coalesce($39,0) and rnum <= coalesce($40,100)+ coalesce($41,0)'
using insdatemin, insdatemax, inmsgtype, inmsgtype, insender, insender, inreceiver, inreceiver, inref, inref,  inissdate, inissdate, 
      inmatdate, inmatdate, inamtmin, inamtmax, inccy, inccy, indacc, indacc, indcname, indcname, indbtid, indbtid, incacc, incacc, inccname, inccname, 
      indirect, indirect, instate, instate, inbatchid, inbatchid,  inuserid, inuserid,inqname, inqname,  inllimit, inulimit, inllimit;


EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while gathering messages. Message is: %', SQLERRM;
       
END;
$_$;


ALTER FUNCTION findata.getdipayments(insdatemin character varying, insdatemax character varying, inmsgtype character varying, insender character varying, inreceiver character varying, inref character varying, inissdate character varying, inmatdate character varying, inamtmin numeric, inamtmax numeric, inccy character varying, indacc character varying, indcname character varying, indbtid character varying, incacc character varying, inccname character varying, indirect character varying, instate character varying, inbatchid character varying, inuserid integer, inqname character varying, inordfield character varying, inorddir character varying, inllimit integer, inulimit integer, OUT outretcursor refcursor) OWNER TO findata;

--
-- TOC entry 385 (class 1255 OID 62584)
-- Name: getduplicatemsgdetails(character varying, integer, character varying); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION getduplicatemsgdetails(inmsgid character varying, inlivearch integer, inqueuename character varying, OUT outretcursor refcursor) RETURNS refcursor
    LANGUAGE plpgsql
    AS $_$
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
  Created:         05.Jun.2014, DenisaN - 8442
  Description:     Gets message details and feedback for all duplicates of one given message 
  Parameters:      inMsgID      - message identifier      
                   inLiveArch   - 1- live message/ 0- archived message      
                   inQueueName  - duplicate queue name / if null, message selected from Duplicate Report      
  Returns:         cursor
  Used:            FinTP/2D/UI
***********************************************/     

v_hash         varchar(32);
v_dupQueue     varchar(35);
v_stmt         varchar(3000);
v_senderapp    varchar(35);
v_insertdate   date;
v_startdate    date;
v_enddate      date;
v_period       integer;



BEGIN


  --TODO: enable archive search

if inLiveArch = 1 then

with  
    MH    as ( select routedmessageid, hash, date_trunc('day', insertdate) insertdate from findata.messagehashes 
                        where routedmessageid = inmsgid and length(hash) > 0) ,
    RM    as ( select id, correlationid, messagetype, requestorservice  from findata.routedmessages where id =  inmsgid)
        select    mh.hash, rm.requestorservice, mh.insertdate 
             into v_hash, v_senderapp, v_insertdate
         from  mh  
            join rm on mh.routedmessageid = rm.id;  
/*          
else   
  with  
    MH    as ( select   messageid, hash, date_trunc('day', insertdate) insertdate  from messagehashes   where messageid= inMsgID
                   union 
                   select   messageid, hash, date_trunc('day', insertdate) insertdate  from finarch.messagehashes   where messageid= inMsgID 
             ) ,
    RM   as ( select guid, correlationid, msgtype, senderapp from finarch.routedmessages where guid =  inMsgID),
 select mh.hash, senderapp, insertdate 
  into v_hash,  v_senderapp, v_insertdate
 from  mh  
 join bm on messageid = rm.guid;
*/
end if;


    --get duplicate detection period for optimizing the search
    select value::integer into v_period from fincfg.params where replace(upper(name),' ','') = 'DUPLICATEDETECTIONPERIOD';
    v_startdate := fincfg.getlastbusinessday(v_insertdate,v_period);
    v_enddate := fincfg.getlastbusinessday(v_insertdate,-1 * v_period);

v_stmt:='with  '||
          ' MHASHES as ( select routedmessageid from messagehashes where hash = $1  and date_trunc(''day'', insertdate) >= $2'||
                        ' and date_trunc(''day'', insertdate) <= $3) ,'||
           ' RMLIVE   as ( select id, reference, messagetype, correlationid, 1 LiveArch from routedmessages ),'||           
           ' FBLIVE   as ( select correlationid, payload, '||
                             '   case '||
                             '     when mqid is null and interfacecode is null and networkcode is null and correspondentcode is null and applicationcode is null then ''New'' '||
                             '     when interfacecode = ''FTP00'' then ''Received'' '||
                             '     when applicationcode is not null and applicationcode!= ''FTP12'' then ''User action: ''||applicationcode '||
                             '     when mqid is not null and interfacecode != ''FTP00'' then ''Sent: ''||coalesce(applicationcode, correspondentcode, networkcode, interfacecode,'' '') '||
                             '     else ''Unknown'' '||
                             '  end feedback  '||
                         ' from feedbackagg ) '||     
        ' select rmlive.id, rmlive.correlationid, coalesce(rmlive.reference,'' '') trn, rmlive.livearch, fblive.feedback '||
        ' from  mhashes  '||
        ' join rmlive on mhashes.routedmessageid = rmlive.id  '||
        ' join fblive on rmlive.correlationid = fblive.correlationid ';
                      
v_stmt:=' select dup.id, dup.correlationid, dup.reference, dup.livearch, dup.feedback, '|| 
                  ' case '||
                  ' when q.queuename is null then ''n/a'' else q.queuename '
                                 ' end queuename 

                                 from ('||v_stmt;
v_stmt:=v_stmt||'  ) dup left join (select correlationid, id, queuename from entryqueue where queuename = $4) q on dup.correlationid = q.correlationid' ;
      
--dupQueue: 2-original message; 1- message in queue; 0- message not in queue    
if inQueueName is not null then 
    --duplicate queue message details        
   open outRetCursor for execute v_stmt using v_hash, v_startdate, v_enddate, inQueueName;
        
else 
   --duplicate report message details       
   select duplicatequeue into v_dupQueue from fincfg.servicemaps where name = v_senderapp;
   open outRetCursor for execute v_stmt using v_hash, v_startdate, v_enddate, v_dupQueue;

end if;


EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while gathering messages. Message is: %', SQLERRM;
       
END;
$_$;


ALTER FUNCTION findata.getduplicatemsgdetails(inmsgid character varying, inlivearch integer, inqueuename character varying, OUT outretcursor refcursor) OWNER TO findata;

--
-- TOC entry 386 (class 1255 OID 62587)
-- Name: getfirstjob(); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION getfirstjob(OUT outretcursor refcursor) RETURNS refcursor
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
  Created:         17.May.2013, DenisaN 7164
  Description:     Returns the count of new routing jobs. 
  Parameters:      n/a
  Returns:         count
  Used:            FinTP/BASE/RE
***********************************************/

BEGIN

open outRetCursor for
   select count(status) as outCount from findata.routingjobs where status = 0;

EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while gathering job info: %', SQLERRM;
       
END;
$$;


ALTER FUNCTION findata.getfirstjob(OUT outretcursor refcursor) OWNER TO findata;

--
-- TOC entry 387 (class 1255 OID 62588)
-- Name: getfirstnewjob(); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION getfirstnewjob(OUT outretcursor refcursor) RETURNS refcursor
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
  Created:         17.May.2013, DenisaN 7164
  Description:     Returns first new job by highest priority and marks it as 'in process' 
  Parameters:      n/a
  Returns:         cursor result set
  Used:            FinTP/BASE/RE
***********************************************/

v_guid      findata.routingjobs.id%type;

BEGIN

  update findata.routingjobs set status = -1 where id in 
   (select id from (select id from findata.routingjobs where status = 0 order by priority desc)rj limit 1) 
  returning id into v_guid;
  
  open outretcursor for
    select id, status,  backout,  priority,  routingpoint, function, userid
    from findata.routingjobs where id = v_guid;

EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while gathering job: % ', SQLERRM;
       
END;
$$;


ALTER FUNCTION findata.getfirstnewjob(OUT outretcursor refcursor) OWNER TO findata;

--
-- TOC entry 388 (class 1255 OID 62591)
-- Name: getftpayments(character varying, character varying, character varying, character varying, character varying, character varying, character varying, numeric, numeric, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying, character varying, character varying, integer, integer); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION getftpayments(insdatemin character varying, insdatemax character varying, inmsgtype character varying, insender character varying, inreceiver character varying, inref character varying, invdate character varying, inamtmin numeric, inamtmax numeric, inccy character varying, indacc character varying, indcname character varying, inordbank character varying, inbenbank character varying, incacc character varying, inccname character varying, inservice character varying, indirect character varying, instate character varying, inbatchid character varying, inuserid integer, inqname character varying, inordfield character varying, inorddir character varying, inllimit integer, inulimit integer, OUT outretcursor refcursor) RETURNS refcursor
    LANGUAGE plpgsql
    AS $_$DECLARE

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
  Change history:  05.Jun.2015, CRaluca 8817
  Created:         21.Mar.2014, DenisaN 8307
  Description:    Gathers data for the Funds Transfer reporting according to the given filtering     
  Parameters:     insdatemin - low date interval value
                  insdatemax - high date interval value
                  inmsgtype  - message type
                  insender   - sender BIC
                  inreceiver - receiver BIC
                  inref      - tx reference
                  invdate    - value date
                  inamtmin   - low amount interval value
                  inamtmax   - high amount interval value
                  inccy      - currency
                  indacc     - dbt account
                  indcname   - dbt cust name
                  inordbank  - ordering bank
                  inbenbank  - beneficiary bank
                  incacc     - cdt account
                  inccname   - cdt cust name
                  inservice  - service
                  indirect   - I/O direction
                  instate    - tx state
                  inbatchid  - batchid
                  inuserid   - user identifier
                  inqname    - queue name
                  inordfield - order by field
                  inorddir   - order by direction 
                  inllimit   - low limit / msg per page
                  inulimit   - upper limit / msg per page                          
  Returns:        cursor
  Used:           FinTP/BASE/UI Funds Transfer
***********************************************/

BEGIN


open outretcursor for execute
'select * from ('||
 ' select tmp.*, max(tmp.rnum) over() rnummax'||
 ' from ( '||
 ' select  row_number() over (order by '||coalesce(inordfield, 'insertdate ')||' '||coalesce(inorddir, ' desc')||' ) rnum, '||   
         ' insertdate, ''test'' messagetype, sender, receiver, reference, valuedate, amount, currency,	'||
         ' dbtaccount, dbtcustomername, orderingbank, beneficiarybank, cdtaccount, cdtcustomername, service, '||
         ' direction, case when errcode is null then state '||
                         ' else state||'' [''||errcode||'']'' '||
                    ' end state, batchid, userid, correlationid, queuename ' ||
  ' from findata.repstatft '||
  ' where insertdate >= to_timestamp($1,''dd mm yyyy hh24:mi:ss'') and insertdate <= to_timestamp($2,''dd mm yyyy hh24:mi:ss'') '||
       ' and  ( $3 is null or  messagetype = $4 )'||
       ' and  ( $5 is null or lower(sender) = lower($6) ) '||       
       ' and  ( $7 is null or lower(receiver) = lower($8) ) '||       
       ' and  ( $9 is null or lower(reference) like lower(''%''||$10||''%'')) '||
       ' and  ( $11 is null or valuedate = $12) ' ||
       ' and ( (amount >= coalesce($13,0) and amount <= coalesce($14,99999999999999999999) ) )'||
       ' and ( $15 is null or currency = $16 ) ' ||
       ' and ( $17 is null or lower(dbtaccount) like lower(''%''||$18||''%'')) ' ||
       ' and ( $19 is null or lower(dbtcustomername) like lower(''%''||$20||''%'') ) ' ||
       ' and ( $21 is null or lower(orderingbank) = lower($22)) ' ||
       ' and ( $23 is null or lower(beneficiarybank) = lower($24)) '||
       ' and ( $25 is null or lower(cdtaccount) like lower(''%''||$26||''%'')) ' ||
       ' and ( $27 is null or lower(cdtcustomername) like lower(''%''||$28||''%'')) ' ||
       ' and ( $29 is null or service = $30) ' ||
       ' and ( $31 is null or direction = $32) ' ||
       ' and ( $33 is null or state = $34) ' ||
       ' and ( $35 is null or lower(batchid) like lower(''%''||$36||''%'')) ' ||
       ' and ( $37 is null or userid = $38 ) ' ||
       ' and ( $39 is null or lower(queuename) = lower($40 )) ' ||
  ' order by '||coalesce(inordfield, 'insertdate')||' '||coalesce(inorddir, 'desc')||') tmp ) tmp1'||
  ' where rnum > coalesce($41,0) and rnum <= coalesce($42,100)+ coalesce($43,0)'
using insdatemin, insdatemax, inmsgtype, inmsgtype, insender, insender, inreceiver, inreceiver, inref, inref,  invdate, invdate, inamtmin, inamtmax,
      inccy, inccy, indacc, indacc, indcname, indcname,  inordbank, inordbank, inbenbank, inbenbank, incacc, incacc, inccname, inccname,  inservice, inservice,  
      indirect, indirect, instate, instate, inbatchid, inbatchid,  inuserid,  inuserid,inqname,inqname,  inllimit, inulimit, inllimit;

EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while gathering messages. Message is: %', SQLERRM;
       
END;
$_$;


ALTER FUNCTION findata.getftpayments(insdatemin character varying, insdatemax character varying, inmsgtype character varying, insender character varying, inreceiver character varying, inref character varying, invdate character varying, inamtmin numeric, inamtmax numeric, inccy character varying, indacc character varying, indcname character varying, inordbank character varying, inbenbank character varying, incacc character varying, inccname character varying, inservice character varying, indirect character varying, instate character varying, inbatchid character varying, inuserid integer, inqname character varying, inordfield character varying, inorddir character varying, inllimit integer, inulimit integer, OUT outretcursor refcursor) OWNER TO findata;

--
-- TOC entry 356 (class 1255 OID 147239)
-- Name: getgroupsformtqueue(character varying, character varying, numeric, character varying); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION getgroupsformtqueue(inqueuename character varying, inmsgtype character varying, inamount numeric, inreference character varying, OUT outretcursor refcursor) RETURNS refcursor
    LANGUAGE plpgsql
    AS $_$
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
  Change history: dd.mon.yyyy  --  author  --   description
                  22.Aug.2014, DenisaN 8539                        
  Created:        27.Mar.2014, DenisaN 7488
  Description:    Returns the group header / grouping criteria for the given message type;
                  may filter trx in groups
  Parameters:     inqueuename - queue name
                  inmsgtype - message type
                  inamount  - filter: trx amount
                  inreference - filter: reference
  Returns:        cursor
  Used:           FinTP/BASE/UI
***********************************************/             

v_groupfields          varchar(1000);
v_groupaliasfields     varchar(1000);
v_qreportingview       varchar(35);
v_timekey              varchar(17);

  
  
BEGIN

  --timekey
  select to_char(now(), 'ddmmyyyyhh24:mi:ss') into v_timekey;

  --get specific storage
  select reportingstorage into v_qreportingview from fincfg.messagetypes where messagetype = inmsgtype;

  --get specific group fields
  select case when routingkeyword1 is not null then lower(routingkeyword1) else ' ' end ||
         case when routingkeyword2 is not null then ', '||lower(routingkeyword2) else ' ' end ||
         case when routingkeyword3 is not null then ', '||lower(routingkeyword3) else ' ' end ||
         case when routingkeyword4 is not null then ', '||lower(routingkeyword4) else ' ' end ||
         case when routingkeyword5 is not null then ', '||lower(routingkeyword5) else ' ' end, 
         case when routingkeyword1 is not null then routingkeyword1 else ' ' end ||
         case when routingkeyword2 is not null then ', '||routingkeyword2 else ' ' end ||
         case when routingkeyword3 is not null then ', '||routingkeyword3 else ' ' end ||
         case when routingkeyword4 is not null then ', '||routingkeyword4 else ' ' end ||
         case when routingkeyword5 is not null then ', '||routingkeyword5 else ' ' end
  into v_groupaliasfields, v_groupfields
  from fincfg.queuemessagegroups where messagetype = inmsgtype;


  --get tx groups (if defined) along with assigned keys
  if v_groupfields is null then
     open outretcursor for execute 
        'select ''X'' where 1 = 2';
  else     
     open outretcursor for execute 
        ' select '||v_groupaliasfields||', sum(to_number( CASE 
    WHEN (
      rtrim((amount)::text) IS NULL
    ) THEN ''0,00''::text 
    WHEN (
      rtrim((amount)::text) = ''''::text
    ) THEN ''0,00''::text 
    WHEN (
      rtrim((amount)::text) = '',''::text
    ) THEN ''0,00''::text 
    ELSE replace(rtrim((amount)::text), '',''::text, ''.''::text) 
  END, ''FM99999999999999999D99''::text)) totamt, 
count(*) cnt, '||
              ''''||v_timekey||''' timekey, md5(string_agg(id,'''' order by id)) groupkey '||
        ' from findata.'||v_qreportingview||' where queuename = $1 '||
   --     ' and ($2 is null or (upper(reference) like (''%''||$3||''%'') or amount = $4))'||
        ' group by '||v_groupfields||
        ' order by '||v_groupfields
     using inqueuename, inreference, inreference, inamount;
  end if;
  
  
EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while gathering messages: %', SQLERRM;

END;
$_$;


ALTER FUNCTION findata.getgroupsformtqueue(inqueuename character varying, inmsgtype character varying, inamount numeric, inreference character varying, OUT outretcursor refcursor) OWNER TO findata;

--
-- TOC entry 355 (class 1255 OID 147243)
-- Name: getgroupsheaderformtqueue(character varying, character varying); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION getgroupsheaderformtqueue(inmsgtype character varying, inheadertype character varying, OUT outretcursor refcursor) RETURNS refcursor
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
  Change history: 11.Jun.2018, DanielC 12857
                  26.Apr.2018, DanielC 12692                      
  Created:        27.Mar.2014, DenisaN 7488
  Description:    Returns the group header / grouping criteria for the given message type
  Parameters:     inmsgtype - message type
                  inheadertype - T - transaction level
                                 G - transaction group level
  Returns:        cursor
  Used:           FinTP/BASE/UI
***********************************************/             

  
BEGIN

if inheadertype = 'G' then 

open outretcursor for 
    select kwn.description kfname, lower(fields.kword) kname, rnum from
     (select kword, row_number() over() rnum from
             ( select unnest(string_to_array(xx,',')) kword from
               (select coalesce(routingkeyword1,' ')||','||coalesce(routingkeyword2,' ')||','||
                       coalesce(routingkeyword3,' ')||','||coalesce(routingkeyword4,' ')||','||
                       coalesce(routingkeyword5, ' ') xx
                from  fincfg.queuemessagegroups where messagetype = inmsgtype
               )kwarr
             )kws
      ) fields                  
   join fincfg.routingkeywords kwn
   on fields.kword = kwn.name
    union
   select 'Total Amount' kfname, 'totamt' kname, 6 rnum
    union
   select 'No. of transactions' kfname, 'cnt' kname, 7 rnum 
  order by rnum;


elsif inheadertype = 'T'then
  	
    open outretcursor for
    	select label, routingkeywordname, displayorder, contenttype from fincfg.queuemessagetrxheader
        where messagetype = inmsgtype
        order by displayorder;
        
end if;


EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while gathering messages: %', SQLERRM;

END;
$$;


ALTER FUNCTION findata.getgroupsheaderformtqueue(inmsgtype character varying, inheadertype character varying, OUT outretcursor refcursor) OWNER TO findata;

--
-- TOC entry 389 (class 1255 OID 62598)
-- Name: gethash(character varying, character varying); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION gethash(inservicename character varying, inmessageid character varying, OUT outcount integer) RETURNS integer
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
  Created:         17.Feb.2014, DenisaN
  Description:     Gets the total number of identical hashes, for one given message    
  Parameters:      inServiceName - service identifier   
                   inMessageID -  message identifier
  Returns:         no. of appearances
  Used:            FinTP/2D/RE
***********************************************/

BEGIN
          
          
  select count (*) into outCount  from findata.messagehashes where  servicename = inServiceName
             and hash = (select hash from findata.messagehashes where servicename = inServiceName and routedmessageid = inMessageID );
          



EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while getting hash: %', SQLERRM;
       
END;
$$;


ALTER FUNCTION findata.gethash(inservicename character varying, inmessageid character varying, OUT outcount integer) OWNER TO findata;

--
-- TOC entry 390 (class 1255 OID 62599)
-- Name: getimageforcsm(character varying); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION getimageforcsm(OUT outretcursor refcursor, incorrelationid character varying) RETURNS refcursor
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
  Created:         09.May.2014, DenisaN 8380
  Description:     Extracts transaction attached image 
  Parameters:      inCorrelID -  message correlation identifier
  Returns:         cursor
  Used:            FinTP/BASE/CONN
***********************************************/

BEGIN

  open outRetCursor for 

     select payload, imageref from findata.blobsqueue where correlationid = inCorrelationID; 


EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while processing image: %', SQLERRM;
       
END;
$$;


ALTER FUNCTION findata.getimageforcsm(OUT outretcursor refcursor, incorrelationid character varying) OWNER TO findata;

--
-- TOC entry 436 (class 1255 OID 62600)
-- Name: getmessagesinbatch(character varying, character varying); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION getmessagesinbatch(OUT outretcursor refcursor, inbatchid character varying, inbatchissuer character varying) RETURNS refcursor
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
  Created:         02.Dec.2013, DenisaN
  Description:     Gets all messages in the specified batch
  Parameters:      inBatchID    - batch identifier
                   inBatchIssuer  - not used                                                                                                                                   
  Returns:         outCursor  parameter representing Cursor result set
  Used:            FinTP/BASE/RE
***********************************************/


BEGIN

 open outRetCursor for
    select correlationid, batchsequence, reference, requestorservice from findata.feedbackagg where batchid = inBatchID;

EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while retrieving messages in batch. Message is: %', SQLERRM;
       
END;
$$;


ALTER FUNCTION findata.getmessagesinbatch(OUT outretcursor refcursor, inbatchid character varying, inbatchissuer character varying) OWNER TO findata;

--
-- TOC entry 392 (class 1255 OID 62601)
-- Name: getmessagesinbatchrfd(character varying, character varying); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION getmessagesinbatchrfd(OUT outretcursor refcursor, inbatchid character varying, inbatchissuer character varying) RETURNS refcursor
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
  Change history: dd.mon.yyyy  --  author  --   description                        
  Created:        19.May.2014, DenisaN
  Description:    Returns all messages in given batch that are not refused; 
                  used for msgs accepting refusal. 
  Parameters:     inBatchID      - batch identifier
                  inBatchIssuer  - batch issuer bank
  Returns:        cursor
  Used:           FinTP/BASE/RE
***********************************************/  


BEGIN

--if issuer is specified
if  length( inBatchIssuer ) > 0  then
  
  open outRetCursor for
    select correlationid, batchsequence, reference, requestorservice from findata.feedbackagg 
        where batchid = inBatchID and issuer = inBatchIssuer 
         and (correspondentcode not like 'RFD%' or correspondentcode is null) ;

--if issuer is not specified
else    

  open outRetCursor for   
    select correlationid, batchsequence, reference, requestorservice from findata.feedbackagg
           where batchid = inBatchID and (correspondentcode not like 'RFD%' or correspondentcode is null);
           
end if;
  
EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while gathering messages in batch: %', SQLERRM;

END;
$$;


ALTER FUNCTION findata.getmessagesinbatchrfd(OUT outretcursor refcursor, inbatchid character varying, inbatchissuer character varying) OWNER TO findata;

--
-- TOC entry 393 (class 1255 OID 62609)
-- Name: getnextservicesequence(integer); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION getnextservicesequence(inservice integer, OUT outsequence integer) RETURNS integer
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
  Created:         27.Aug.2013, LucianP
  Description:     Gets the next sequence (used in batch identifier) for the specified service
  Parameters:      inService -  service identifier
  Returns:         outSequence parameter representing the sequence to be used
  Used:            FinTP/BASE/RE
***********************************************/

v_service    fincfg.servicemaps.name%type;

BEGIN

  select name into v_service from fincfg.servicemaps where id = inService;

  select nextval('findata.commbatchseq') into outSequence;

EXCEPTION
   WHEN NO_DATA_FOUND THEN 
         RAISE EXCEPTION 'Service not found.';
   WHEN OTHERS THEN
         RAISE EXCEPTION 'Unexpected error occured while generating batch sequence. Message is: %', SQLERRM;
       
END;
$$;


ALTER FUNCTION findata.getnextservicesequence(inservice integer, OUT outsequence integer) OWNER TO findata;

--
-- TOC entry 394 (class 1255 OID 62610)
-- Name: getoriginalmessageid(character varying); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION getoriginalmessageid(incorrelid character varying, OUT outmsgid character varying) RETURNS character varying
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
  Created:         17.May.2013, DenisaN 7164
  Description:     Gets the original message identifier [ guid ]
  Parameters:      inCorrelID -  message correlation identifier
  Returns:         message guid
  Used:            FinTP/BASE/RE
***********************************************/


BEGIN

  select id into outMsgID from findata.routedmessages where correlationid = inCorrelID;

EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while processing message: %', SQLERRM;
       
END;
$$;


ALTER FUNCTION findata.getoriginalmessageid(incorrelid character varying, OUT outmsgid character varying) OWNER TO findata;

--
-- TOC entry 395 (class 1255 OID 62611)
-- Name: getoriginalpayload(character varying); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION getoriginalpayload(OUT outrefcursor refcursor, inmsgid character varying) RETURNS refcursor
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
  Created:         17.May.2013, DenisaN 7164
  Description:     Returns the original message payload
  Parameters:      inMsgID -  message  identifier
  Returns:         cursor result set
  Used:            FinTP/BASE/RE
***********************************************/

BEGIN

 open outrefcursor for
    select payload from findata.history where id = inMsgID;

EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while processing message: %', SQLERRM;
       
END;
$$;


ALTER FUNCTION findata.getoriginalpayload(OUT outrefcursor refcursor, inmsgid character varying) OWNER TO findata;

--
-- TOC entry 397 (class 1255 OID 62612)
-- Name: getoriginalref(character varying, character varying); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION getoriginalref(intrn character varying, inbatchid character varying, OUT outref character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$
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
  Created:         10.Feb.2014, DenisaN
  Description:     Gets the refusal transaction reference.
  Parameters:      inTrn -  original message transaction reference
                   inBatchID - refusal batch identifier
  Returns:         outRef parameter reperesenting refusal transaction reference 
  Used:            FinTP/BASE/RE
***********************************************/


--TO REVIEW: - unicitate pe trn cand search for msgtype
--           - move trn into specific tables
--  

v_storage varchar(35);
v_stmt    varchar(1000);

BEGIN

       --get original message type & storage        
       select storage into v_storage from fincfg.messagetypes where messagetype in (select messagetype  from findata.routedmessages where reference = inTRN);
         
       --get refusal reference
       v_stmt :=  ' select reference from '||
                                   ' ( select correlationid, reference from findata.feedbackagg where batchid = $1 ) fb '||
                            ' join '|| 
                                    ' ( select correlationid from findata.'||v_storage||' where originalreference = $2 ) mt '||
                             ' on fb.correlationid = mt.correlationid ';  
      execute v_stmt into outRef using inBatchID, inTrn;
      
      
EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while retrieving reference: %', SQLERRM;
       
END;
$_$;


ALTER FUNCTION findata.getoriginalref(intrn character varying, inbatchid character varying, OUT outref character varying) OWNER TO findata;

--
-- TOC entry 398 (class 1255 OID 62613)
-- Name: getpymtpayments(character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, numeric, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer, integer); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION getpymtpayments(insdatemin character varying, insdatemax character varying, inmsgtype character varying, inendtoendid character varying, intrn character varying, indbtname character varying, indbtaccount character varying, inordbank character varying, inamount numeric, incurrency character varying, invaluedate character varying, inacctcode character varying, inloccode character varying, inbudgcode character varying, instatus character varying, incdtname character varying, incdtaccount character varying, inbenbank character varying, insourcefname character varying, indestfname character varying, inordfield character varying, inorddir character varying, inllimit integer, inulimit integer, OUT outretcursor refcursor) RETURNS refcursor
    LANGUAGE plpgsql
    AS $_$
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
  Change history: dd.mon.yyyy  --  author  --   description 
  Created:        20.Jun.2018, DanielC 12889
  Description:    Gathers data for the Payments Instructions reporting according to the given filtering     
  Parameters:   insdatemin - low date interval value
                insdatemax - high date interval value   
  				inmsgtype  - message type
  				inendtoendid - end to end identification
    			intrn - transaction reference
    			indbtname - debtor name
    			indbtaccount - debtor account
    			inordbank - debtor agent bic
    			inamount - amount
    			incurrency - currency
    			invaluedate - requested execution date
    			inacctcode - accounting code
    			inloccode - location code
    			inbudgcode - budget code
    			instatus - status
    			incdtname - creditor name
          		incdtaccount - creditor account
    			inbenbank - creditor agent bic
    			insourcefname - source file name
    			indestfname - destination file name
                inordfield - order by field
                inorddir   - order by direction 
                inllimit   - low limit / msg per page
                inulimit   - upper limit / msg per page  
   Returns:        cursor
   Used:           FinTP/BASE
***********************************************/ 

BEGIN

open outretcursor for execute
'select * from (' ||
'  select tmp.*, max(tmp.rnum) over() rnummax' ||
'  from ( ' ||
'    select  row_number() over (order by '||coalesce(inordfield, 'insertdate ')||' '||coalesce(inorddir, 'desc')||' ) rnum, '|| 
'            correlationid, messagetype, endtoendid, reference, dbtcustomername, dbtaccount, ' ||
'            orderingbank, amount, currency, valuedate, accountingcode, locationcode, ' ||
'            budgetcode, status, coalesce(currentqueue, ''n/a'') currentqueue, cdtcustomername, cdtaccount, ' ||
'            beneficiarybank, sourcefilename, destinationfilename, remittanceinfo ' ||
'    from findata.repstatpymt'
'    where insertdate >= to_timestamp($1,''DD/MM/YYYY'') and insertdate <= to_timestamp($2,''DD/MM/YYYY'') '||
'          and  ( $3 is null or  messagetype = $4 )' ||
'          and  ( $5 is null or lower(endtoendid) like lower(''%''||$6||''%''))' ||
'          and  ( $7 is null or lower(reference) like lower(''%''||$8||''%''))' || 
'          and  ( $9 is null or lower(dbtcustomername) = lower($10) ) '|| 
'          and  ( $11 is null or dbtaccount = $12 ) '||
'          and  ( $13 is null or orderingbank = $14 ) '||
'          and  ( $15 is null or amount = $16 ) '||
'          and  ( $17 is null or currency = $18 ) '||
'          and  ( $19 is null or to_date(valuedate, ''YYMMDD'') = to_date($20, ''DD/MM/YYYY'') ) '||
'          and  ( $21 is null or accountingcode = $22 ) '||
'          and  ( $23 is null or locationcode = $24 ) '||
'          and  ( $25 is null or budgetcode = $26 ) '||
'          and  ( $27 is null or status = $28 ) '||
'          and  ( $29 is null or lower(cdtcustomername) = lower($30) ) '||
'          and  ( $31 is null or cdtaccount = $32 ) '||
'          and  ( $33 is null or beneficiarybank = $34 ) '||
'          and  ( $35 is null or lower(sourcefilename) like lower(''%''||$36||''%'')) '||
'          and  ( $37 is null or lower(destinationfilename) like lower(''%''||$38||''%'')) '||
' order by '||coalesce(inordfield, 'insertdate')||' '||coalesce(inorddir, 'desc')||') tmp ) tmp1'||
' where rnum > coalesce($39,0) and rnum <= coalesce($40,100)+ coalesce($41,0)'
using insdatemin, insdatemax, inmsgtype, inmsgtype, inendtoendid, inendtoendid, intrn, intrn,
       indbtname, indbtname, indbtaccount, indbtaccount, inordbank, inordbank, inamount, inamount,
       incurrency, incurrency, invaluedate, invaluedate, inacctcode, inacctcode, inloccode, inloccode,
       inbudgcode, inbudgcode, instatus, instatus, incdtname, incdtname, incdtaccount, incdtaccount,
       inbenbank, inbenbank, insourcefname, insourcefname, indestfname, indestfname, inllimit, inulimit, inllimit;
       

EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while gathering messages. Message is: %', SQLERRM;
       
END;
$_$;


ALTER FUNCTION findata.getpymtpayments(insdatemin character varying, insdatemax character varying, inmsgtype character varying, inendtoendid character varying, intrn character varying, indbtname character varying, indbtaccount character varying, inordbank character varying, inamount numeric, incurrency character varying, invaluedate character varying, inacctcode character varying, inloccode character varying, inbudgcode character varying, instatus character varying, incdtname character varying, incdtaccount character varying, inbenbank character varying, insourcefname character varying, indestfname character varying, inordfield character varying, inorddir character varying, inllimit integer, inulimit integer, OUT outretcursor refcursor) OWNER TO findata;

--
-- TOC entry 402 (class 1255 OID 62616)
-- Name: getqueuetxno(); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION getqueuetxno(OUT outretcursor refcursor) RETURNS refcursor
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
  Change history: dd.mon.yyyy  --  author  --   description
  Created:        04.Sep.2018, dd
  Description:    Returns all queues and current no of tx
  Parameters:     
  Returns:        n/a
  Used:          FinTP/BASE/UI
***********************************************/

BEGIN

open outretcursor for execute
    'select x.id, x.name as queuename, x.label, coalesce(x.txno, 0) nooftx
    from ((select id, name, label from fincfg.queues) q 
         left join (select queuename, count(id) txno from findata.entryqueue group by queuename) eq 
         on q.name = eq.queuename) x'; 

EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while getting queueus: %', SQLERRM;
       
END;
$$;


ALTER FUNCTION findata.getqueuetxno(OUT outretcursor refcursor) OWNER TO findata;

--
-- TOC entry 400 (class 1255 OID 62617)
-- Name: getstatus(character varying); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION getstatus(incorrelid character varying) RETURNS character varying
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
  Created:         19.Jun.2018, DanielC 12889
  Description:     Function that uses a given correlation identifier and
                   returns the status of the specific message
  Parameters:     inCorrelId - correlation identifier                        
  Returns:        status as character varying
  Used:           FinTP/BASE/RE
***********************************************/

 v_queueId     integer;
 v_appcode 	   character varying(10);
 v_qtypeName   fincfg.queuetypes.name%type;
 v_status      character varying(140);
 v_qlabel      fincfg.queues.label%type;

BEGIN

	select currentqueue into v_queueId from findata.routedmessages
    where correlationid = incorrelid;
    
    if (v_queueId is null) then
    	
        select applicationcode into v_appcode from findata.feedbackagg
        where correlationid = incorrelid;
        
        case when v_appcode = 'FTP09' then v_status := 'Completed - Rejected (reason: others)';
             when v_appcode = 'FTP19' then v_status := 'Completed - Suspended (reason: others)';
             when v_appcode = 'PDM00' then v_status := 'Completed - Rejected (reason: duplicate)';
             when v_appcode = 'PDM10' then v_status := 'Completed - Suspended (reason: others)';
             when v_appcode = 'FTP39' then v_status := 'Completed - Suspended (reason: flow)';
             else v_status := 'Completed - Sent';
        end case;

     else
        --transaction in queues
        select qt.name, q.label into v_qtypeName, v_qlabel
        from fincfg.queues q join fincfg.queuetypes qt on q.queuetypeid = qt.id
        where q.id = v_queueId;
        
        case when v_qtypeName = 'Authorization' then v_status := 'Waiting for Authorization';
             when v_qtypeName = 'Business Investigation' then v_status := 'Waiting for Business Investigation';
             when v_qtypeName = 'Technical Investigation' then v_status := 'Waiting for Technical Investigation';
             when v_qtypeName = 'Duplicates Investigation' then v_status := 'Waiting for Duplicates Investigation';
             else v_status := 'In Process';
        end case;
      
        v_status := v_status||'~~'||v_qlabel;

      end if;
      
RETURN v_status;
  
EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while gathering original message. Message is: %', SQLERRM;
       
END;
$$;


ALTER FUNCTION findata.getstatus(incorrelid character varying) OWNER TO findata;

--
-- TOC entry 401 (class 1255 OID 62618)
-- Name: getstmpayments(character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, numeric, numeric, numeric, numeric, character varying, character varying, character varying, character varying, integer, character varying, character varying, character varying, integer, integer); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION getstmpayments(insdatemin character varying, insdatemax character varying, inmsgtype character varying, insender character varying, inreceiver character varying, instmtref character varying, inobdate character varying, incbdate character varying, inobamountmin numeric, inobamountmax numeric, incbamountmin numeric, incbamountmax numeric, inccy character varying, inaccnumber character varying, indirect character varying, instate character varying, inuserid integer, inqname character varying, inordfield character varying, inorddir character varying, inllimit integer, inulimit integer, OUT outretcursor refcursor) RETURNS refcursor
    LANGUAGE plpgsql
    AS $_$DECLARE

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
  Change history:  05.Jun.2015, CRaluca 8817
  Created:         30.Jun.2014, DenisaN 8461
  Description:    Gathers data for the Funds Transfer reporting according to the given filtering     
  Parameters:     insdatemin - low date interval value
                  insdatemax - high date interval value
                  inmsgtype  - message type
                  insender   - sender BIC
                  inreceiver - receiver BIC 
                  instmtref  - stmt reference    
                  inobdate   - ob date  
                  incbdate   - cb date   
                  inobamountmin - low amount interval value
                  inobamountmax - high amount interval value
                  incbamountmin - low amount interval value
                  incbamountmax - high amount interval value
                  inccy         - currency
                  inaccnumber  - account number  
                  indirect   - I/O direction
                  instate    - tx state
                  inuserid   - user identifier
                  inqname    - queue name
                  inordfield - order by field
                  inorddir   - order by direction 
                  inllimit   - low limit / msg per page
                  inulimit   - upper limit / msg per page                          
  Returns:        cursor
  Used:           FinTP/BASE/UI Statements
***********************************************/

BEGIN


open outretcursor for execute
'select * from ('||
 ' select tmp.*, max(tmp.rnum) over() rnummax'||
 ' from ( '||
 ' select  row_number() over (order by '||coalesce(inordfield, 'receiver ')||' '||coalesce(inorddir, 'asc')||' ) rnum, '||   
         ' messagetype, sender, receiver, currency, accountnumber, openbalancemark||openbalanceamount ibalance, '||
         ' closebalancemark||closebalanceamount fbalance, openbalancedate, closebalancedate, statementuid, statementref, stmtnumber, '||
         ' direction, max(case when errorcode is null then state '||
                         ' else state||'' [''||errorcode||'']'' '||
                    ' end) state, max(userid) userid, queuename ' ||
  ' from findata.repstatstm '||
  ' where insertdate >= to_timestamp($1,''dd mm yyyy hh24:mi:ss'') and insertdate <= to_timestamp($2,''dd mm yyyy hh24:mi:ss'') '||
       ' and  ( $3 is null or  messagetype = $4 )'||
       ' and  ( $5 is null or lower(sender) = lower($6) ) '||       
       ' and  ( $7 is null or lower(receiver) = lower($8) ) '|| 
       ' and ( $9 is null or currency = $10 ) ' ||
       ' and ( $11 is null or lower(accountnumber) like lower(''%''||$12||''%'')) ' ||
       ' and ( (openbalanceamount >= coalesce($13,0) and openbalanceamount <= coalesce($14,99999999999999999999) ) )'||
       ' and ( (closebalanceamount >= coalesce($15,0) and closebalanceamount <= coalesce($16,99999999999999999999) ) )'||
       ' and  ( $17 is null or openbalancedate = $18) ' ||      
       ' and  ( $19 is null or closebalancedate = $20) ' ||      
       ' and  ( $21 is null or lower(statementref) like lower(''%''||$22||''%'')) '||
       ' and ( $23 is null or direction = $24) ' ||
       ' and ( $25 is null or state = $26) ' ||
       ' and ( $27 is null or userid = $28 ) ' ||
      ' and ( $29 is null or lower(queuename) = lower($30)) ' ||
   ' group by messagetype, sender, receiver, currency, accountnumber, openbalancemark||openbalanceamount, '||
              'closebalancemark||closebalanceamount, openbalancedate, closebalancedate, statementuid, stmtref, stmtnumber, '||
             ' direction, queuename'||           
   ' order by '||coalesce(inordfield, 'receiver')||' '||coalesce(inorddir, 'asc')||') tmp ) tmp1'||
   ' where rnum > coalesce($31,0) and rnum <= coalesce($32,100)+ coalesce($33,0)'
using insdatemin, insdatemax, inmsgtype, inmsgtype, insender, insender, inreceiver, inreceiver, 
      inccy, inccy, inaccnumber, inaccnumber, inobamountmin, inobamountmax, incbamountmin, incbamountmax,
      inobdate, inobdate, incbdate, incbdate, instmtref, instmtref, 
      indirect, indirect, instate, instate, inuserid, inuserid, inqname, inqname, inllimit, inulimit, inllimit;

EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while gathering messages. Message is: %', SQLERRM;
       
END;
$_$;


ALTER FUNCTION findata.getstmpayments(insdatemin character varying, insdatemax character varying, inmsgtype character varying, insender character varying, inreceiver character varying, instmtref character varying, inobdate character varying, incbdate character varying, inobamountmin numeric, inobamountmax numeric, incbamountmin numeric, incbamountmax numeric, inccy character varying, inaccnumber character varying, indirect character varying, instate character varying, inuserid integer, inqname character varying, inordfield character varying, inorddir character varying, inllimit integer, inulimit integer, OUT outretcursor refcursor) OWNER TO findata;

--
-- TOC entry 404 (class 1255 OID 62621)
-- Name: insertevent(character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION insertevent(inguid character varying, inservice integer, incorrelid character varying, insession character varying, inevtype character varying, inmachine character varying, inevdate character varying, inmessage character varying, inclass character varying, inaddinfo character varying, ininnerex character varying) RETURNS void
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
  Created:         17.May.2013, DenisaN  7164
  Description:     Auditing one event. 
  Parameters:   inGuid         - generated identifier
	        inService      - audited service
	        inCorrelID     - message correlation identifier
	        inSession      - session identifier
	        inEvType       - Info, Warning, Error
	        inMachine      - host machine
	        inEvDate       - event date [format: "YYYY-MM-DD-HH24.MI.SS"]
	        inMessage      - event text
	        inClass        - [not used] 
	        inAddInfo      - event additional info 
	        inInnerEx      - related subevents
  Returns:      n/a
  Used:         FinTP/BASE/RE/Conn
***********************************************/   

v_id integer;

BEGIN

	select id into v_id from fincfg.servicemaps
    where name = 'RoutingEngine';
    
    if (inService = v_id) then
    	inClass = 'Transaction.Route';
    end if;

   insert into status ( guid, service,  sessionid, correlationid,  additionalinfo, type, class,  machine, 
                        eventdate,  insertdate,  message, innerexception )
               values ( inGuid, inService, inSession, inCorrelID, inAddinfo, inEvtype, inClass, inMachine,
                        to_timestamp( inEvDate, 'YYYY-MM-DD-HH24.MI.SS' ), now(), inMessage, inInnerex);

EXCEPTION
  WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while auditing: %', SQLERRM;
       
END;
$$;


ALTER FUNCTION findata.insertevent(inguid character varying, inservice integer, incorrelid character varying, insession character varying, inevtype character varying, inmachine character varying, inevdate character varying, inmessage character varying, inclass character varying, inaddinfo character varying, ininnerex character varying) OWNER TO findata;

--
-- TOC entry 405 (class 1255 OID 62622)
-- Name: insertevent(character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, integer, character varying); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION insertevent(inguid character varying, inservice integer, incorrelid character varying, insession character varying, inevtype character varying, inmachine character varying, inevdate character varying, inmessage character varying, inclass character varying, inaddinfo character varying, ininnerex character varying, inuserid integer, inroutingpoint character varying) RETURNS void
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
                   17.May.2016, DenisaN sync
  Created:         17.May.2013, DenisaN  7164
  Description:     Auditing one event. 
  Parameters:   inGuid         - generated identifier
	        inService      - audited service
	        inCorrelID     - message correlation identifier
	        inSession      - session identifier
	        inEvType       - Info, Warning, Error
	        inMachine      - host machine
	        inEvDate       - event date [format: "YYYY-MM-DD-HH24.MI.SS"]
	        inMessage      - event text
	        inClass        - [not used] 
	        inAddInfo      - event additional info 
	        inInnerEx      - related subevents
  Returns:      n/a
  Used:         FinTP/BASE/RE/Conn
***********************************************/   
v_id integer;

BEGIN

	select id into v_id from fincfg.servicemaps
    where name = 'RoutingEngine';
    
    if (inService = v_id) then
    	inClass = 'Transaction.Route';
    end if;

   insert into status ( guid, service,  sessionid, correlationid,  additionalinfo, type, class,  machine, 
                        eventdate,  insertdate,  message, innerexception )
               values ( inGuid, inService, inSession, inCorrelID, inAddinfo, inEvtype, inClass, inMachine,
                        to_timestamp( inEvDate, 'YYYY-MM-DD-HH24.MI.SS' ), now(), inMessage, inInnerex);

EXCEPTION
  WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while auditing: %', SQLERRM;
       
END;
$$;


ALTER FUNCTION findata.insertevent(inguid character varying, inservice integer, incorrelid character varying, insession character varying, inevtype character varying, inmachine character varying, inevdate character varying, inmessage character varying, inclass character varying, inaddinfo character varying, ininnerex character varying, inuserid integer, inroutingpoint character varying) OWNER TO findata;

--
-- TOC entry 391 (class 1255 OID 62623)
-- Name: inserthash(character varying, character varying, character varying); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION inserthash(inservicename character varying, inmessageid character varying, inhash character varying) RETURNS void
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
  Description:     Inserts hashes for every given message 
  Parameters:      inServiceID  - service identifier
                   inMessageID  - message identifier
                   inHash       - message hash          
  Returns:         n/a
  Used:            FinTP/2D/RE
***********************************************/

BEGIN


    insert into findata.messagehashes (servicename, routedmessageid, hash, insertdate, receivingorder)
                                      (select  inServiceName, inMessageID, inHash, now(), count(inServiceName) + 1 from findata.messagehashes 
                                                           where servicename = inServiceName and hash = inHash );
      
EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while storing message hash: %', SQLERRM;
       
END;
$$;


ALTER FUNCTION findata.inserthash(inservicename character varying, inmessageid character varying, inhash character varying) OWNER TO findata;

--
-- TOC entry 406 (class 1255 OID 62625)
-- Name: insertincomingbatch(character varying, character varying, character varying); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION insertincomingbatch(inbatchid character varying, inmessageid character varying, innamespace character varying) RETURNS void
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
                   03.Jun.2014, DenisaN - 8428 
  Created:         27.Mar.2013, DenisaN
  Description:     Recording incoming batch info. 
  Parameters:      inBatchID  - batch identifier
                   inMessageID  - message identifier
                   inNamespace - batch namespace
  Returns:         n/a
  Used:            FinTP/BASE/RE
***********************************************/ 


v_Sender varchar(12);

BEGIN

  select sender into v_Sender from findata.routedmessages where id = inMessageID;

  insert into findata.batchjobsinc  (sender, batchid, batchtype, insertdate)
                             values (v_Sender, inBatchID, inNamespace, now());
                                                                        
      
EXCEPTION
WHEN  unique_violation THEN
    null;
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while processing batch: %', SQLERRM;
       
END;
$$;


ALTER FUNCTION findata.insertincomingbatch(inbatchid character varying, inmessageid character varying, innamespace character varying) OWNER TO findata;

--
-- TOC entry 409 (class 1255 OID 62626)
-- Name: insertmessage(character varying, character varying, character varying, character varying, character varying, character varying[], character varying); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION insertmessage(inmsgtype character varying, insenderapp character varying, inreceiverapp character varying, inguid character varying, incorrelid character varying, inkwnames character varying[], inentity character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$
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
  Change history:  31.Aug.2018, DanielC - 12963
  				   14.Jun.2018, DanielC - 12880
                   11.Jun.2018, DanielC - 12857
                   23.May.2018, DanielC - 12835
                   03.Feb.2014, DenisaN - date format
  Created:         20.May.2013, DenisaN - 7164
  Description:     Inserts every routed message into common table and specific tables.  
  Parameters:    inMsgType       - message type to be inserted
		         inSenderApp     - sender application service
                 inGuid          - unique identifier
		         inCorrelID      - correlation identifier  
		         inKWNames       - message keywords [see cfg.routingkeywordmapps] followed by their values
  Returns:       n/a
  Used:          FinTP/BASE/RE
***********************************************/

v_ReferenceIdx     integer default 0;
v_SenderIdx        integer default 0;
v_ReceiverIdx      integer default 0;
v_AmountIdx        integer default 0;
v_tablename        varchar(35);
v_insertfields     varchar(2000) default '(';
v_insertvalues     varchar(2000) default '(';
v_half             integer;
--v_kwvalues         varchar[];
v_dateformat       varchar(6);
v_ioidentifier     varchar(1);

BEGIN

     v_half:= array_length(inKWNames,1)/2;
     
     for i in 1..v_half loop
            
            case  
                     --extract message common info  and ammount
                      when inKWNames[i] = 'Reference' then v_ReferenceIdx:=i;
                      when inKWNames[i] = 'Sender' then v_SenderIdx:=i;
                      when inKWNames[i] = 'Receiver' then v_ReceiverIdx:=i;
                      --when inKWNames[i] = 'Amount' then v_AmountIdx:=i;
                      
            else 
                      --extract message specific info
                      v_insertfields := v_insertfields||inKWNames[i];

                     if inKWNames[i + v_half] is null then 
					    v_insertvalues := v_insertvalues||''''||'null'||'''';
					    
					  --standard date format
					 elsif lower(inKWNames[i]) like '%date' then                          
                        select findata.getbusinessdateformat(inKWNames[i + v_half]) into v_dateformat;  
                        v_insertvalues := v_insertvalues||''''||v_dateformat||'''';
                          
                     else
       				    v_insertvalues := v_insertvalues||''''||inKWNames[i + v_half]||'''';
       				    
                     end if;
                                 
                     v_insertfields := v_insertfields||',';
                     v_insertvalues := v_insertvalues||','; 
            end case; 
     end loop;  

    --retrieve specific message table storage                                           
    select distinct storage into  v_tablename from fincfg.messagetypes where messagetype =  inMsgType; 
   
   select ioidentifier into v_ioidentifier from findata.entryqueue where correlationid = incorrelid;  

   --insert message info into storage tables    
   insert into findata.routedmessages (currentqueue, id, correlationid, messagetype, sender, receiver, reference, requestorservice, responderservice, entity, ioidentifier) 
                               values (fincfg.getqueueid(insenderapp||'Queue'), inGuid, inCorrelID, inMsgType, inKWNames[v_SenderIdx+v_half], inKWNames[v_ReceiverIdx+v_half], inKWNames[v_ReferenceIdx+v_half], inSenderApp, inReceiverApp, inentity, v_ioidentifier);                                                                       
 execute 'insert into findata.'||v_tablename||' '||v_insertfields||' correlationid, messagetype) values '||v_insertvalues||' $1, $2 )'using inCorrelID, inMsgType;
	

EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while inserting message: %', SQLERRM;
       
END;
$_$;


ALTER FUNCTION findata.insertmessage(inmsgtype character varying, insenderapp character varying, inreceiverapp character varying, inguid character varying, incorrelid character varying, inkwnames character varying[], inentity character varying) OWNER TO findata;

--
-- TOC entry 407 (class 1255 OID 62629)
-- Name: insertmessageinqueue(character varying, text, character varying, character varying, character varying, character varying, character varying, character varying, integer, integer, integer, character varying, character varying, character varying); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION insertmessageinqueue(inguid character varying, inpayload text, inbatchid character varying, incorrelid character varying, insessid character varying, inreqservice character varying, inrespservice character varying, inreqtype character varying, inpriority integer, inholdstatus integer, insequence integer, infeedback character varying, inqueuename character varying, inioidentifier character varying) RETURNS void
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
                       27.May.2014, DenisaN         
  Created:             09.Aug.2013, LucianP 7698
  Description:         Inserts a message into one given queue (as entry queue)
  Parameters:                      inGuid - message identifier
                                   inPayload  - message payload
                                   inBatchID  - batch identifier
                                   inCorrelID  - correlation identifier
                                   inReqService  - requestor service
                                   inRespService   - responder service
                                   inReqType  - request type
                                   inPriority   - processing priority
                                   inHoldstatus  - hold status 1/0
                                   inSequence - routing rule sequence
                                   inFeedback  - message feedback
                                   inSessID - session identifier                    
                                  inQueueName -  destination queue name
                                  inIOIdentifier -  I/O/U (incoming/outgoing/undefined)
  Returns:              n/a
  Used:                 FinTP/BASE/RE
***********************************************/

BEGIN

    insert into findata.entryqueue (id, payload, batchid, correlationid, requestorservice, responderservice, requesttype, priority, holdstatus, sequence, feedback, sessionid, queuename, ioidentifier)
       values (inGuid, inPayload, inBatchID, inCorrelID, inReqService, inRespService, inReqType, inPriority, inHoldstatus, inSequence, inFeedback, inSessID, inQueueName, inIOIdentifier);
    update findata.routedmessages set currentqueue = fincfg.getqueueid(inqueuename) where correlationid =  inCorrelID;

EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while inserting message. Message is: %', SQLERRM;
       
END;
$$;


ALTER FUNCTION findata.insertmessageinqueue(inguid character varying, inpayload text, inbatchid character varying, incorrelid character varying, insessid character varying, inreqservice character varying, inrespservice character varying, inreqtype character varying, inpriority integer, inholdstatus integer, insequence integer, infeedback character varying, inqueuename character varying, inioidentifier character varying) OWNER TO findata;

--
-- TOC entry 418 (class 1255 OID 96979)
-- Name: loadqpcms(character varying, text, character varying); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION loadqpcms(inhash character varying, inmessage text, intablename character varying) RETURNS void
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
  				   22.May.2018, DanielC - 12835
                   06.Feb.2014, DenisaN - 8192               
  Created:     12.Mar.2013, DenisaN - 7164  
  Description: Extracting and routing message to entry queue (+ history);
  Parameters: inHash  - message computed hash value
              inMessage  - xml format message
              inTableName   - message entry queue
              inBufferSize  - 
  Returns:    outResultCode, outResultMessage 
  Used:       FinTP/BASE/Conn
***********************************************/             

  v_XMLData                  xml;
  v_PayloadOrg               text;
  v_PayloadTrf               text;
  v_Guid                     varchar(30);
  v_BatchId                  varchar(35);
  v_CorrelId                 varchar(30);
  v_SessionId                varchar(30);
  v_RequestorService         varchar(30);
  v_Hash                     varchar(50);
  v_ResponderService         varchar(30);
  v_RequestType              varchar(30);
  v_Feedback                 varchar(40);
  v_priority                 integer;
  v_IOIdentifier			 varchar(1);

BEGIN

select xmlparse(DOCUMENT inMessage) into v_XMLData;

select (xpath('/qPCMessageSchema/Message/Payload/Original/text()', v_XMLData))[1]::varchar into v_PayloadOrg;
select (xpath('/qPCMessageSchema/Message/Payload/Transformed/text()', v_XMLData))[1]::varchar into v_PayloadTrf;
select (xpath('/qPCMessageSchema/Message/Guid/text()', v_XMLData))[1]::varchar into v_Guid;
select (xpath('/qPCMessageSchema/Message/BatchId/text()', v_XMLData))[1]::varchar into v_BatchId; --nullable
select (xpath('/qPCMessageSchema/Message/CorrelationId/text()', v_XMLData))[1]::varchar into v_CorrelId;
select (xpath('/qPCMessageSchema/Message/SessionId/text()', v_XMLData))[1]::varchar into v_SessionId;
select (xpath('/qPCMessageSchema/Message/RequestorService/text()', v_XMLData))[1]::varchar into v_RequestorService;
select (xpath('/qPCMessageSchema/Message/ResponderService/text()', v_XMLData))[1]::varchar into v_ResponderService; --nullable
select (xpath('/qPCMessageSchema/Message/RequestType/text()', v_XMLData))[1]::varchar into v_RequestType;
select (xpath('/qPCMessageSchema/Message/Feedback/text()', v_XMLData))[1]::varchar into v_Feedback;
select (xpath('/qPCMessageSchema/Message/IOIdentifier/text()', v_XMLData))[1]::varchar into v_IOIdentifier;


  if inHash is not null  then
    perform findata.inserthash(v_RequestorService, v_Guid, inHash);
  else
    select (xpath('/qPCMessageSchema/Message/Hash/text()', v_XMLData))[1]::varchar into v_Hash;
    if v_Hash is not null then 
        perform findata.inserthash(v_RequestorService, v_Guid, v_Hash); 
    end if;
  end if; 

insert into findata.history (id, payload, batchid, correlationid, sessionid, requestorservice, responderservice, requesttype, feedback, insertdate)
                     values (v_Guid, v_PayloadOrg, v_BatchId, v_CorrelId, v_SessionId, v_RequestorService, v_ResponderService, v_RequestType, v_Feedback, current_timestamp);

select priority into v_priority from fincfg.queues where name = inTableName;
insert into findata.entryqueue (id, payload, batchid, correlationid, sessionid, requestorservice, responderservice, requesttype, feedback, queuename, priority, ioidentifier ) 
                        values (v_Guid, v_PayloadTrf, v_BatchId, v_CorrelId, v_SessionId, v_RequestorService, v_ResponderService, v_RequestType, v_Feedback, inTableName, v_priority, v_IOIdentifier);


EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while processing message: %', SQLERRM;

END;
$$;


ALTER FUNCTION findata.loadqpcms(inhash character varying, inmessage text, intablename character varying) OWNER TO findata;

--
-- TOC entry 408 (class 1255 OID 62635)
-- Name: modifymessageinqueue(character varying, text, character varying, character varying, character varying, character varying, character varying, character varying, integer, integer, integer, character varying, character varying); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION modifymessageinqueue(inguid character varying, inpayload text, inbatchid character varying, incorrelid character varying, insessid character varying, inreqservice character varying, inrespservice character varying, inreqtype character varying, inpriority integer, inholdstatus integer, insequence integer, infeedback character varying, intoqueuename character varying) RETURNS void
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
  Created:             09.Aug.2013, LucianP 7698
  Description:         Updates message specific information for a message in queue, along with changing the source queue name.
  Parameters:          inGuid - message identifier
                       inPayload  - message payload
                       inBatchID  - batch identifier
                       inCorrelID  - correlation identifier
                       inReqService  - requestor service
                       inRespService   - responder service
                       inReqType  - request type
                       inPriority   - processing priority
                       inHoldstatus  - hold status 1/0
                       inSequence - routing rule sequence
                       inFeedback  - message feedback
                       inSessID - session identifier 
                       inToQueueName - destination queue name                                    
  Returns:             n/a
  Used:                FinTP/BASE/RE
***********************************************/

BEGIN

    perform findata.updatemessageinqueue(inGuid,  inPayload, inBatchID,  inCorrelID, inSessID, inReqService,  inRespService, inReqType,  inPriority,  inHoldstatus,  inSequence,  inFeedback);
    perform findata.movemessageinqueue(inGuid,  inTOQueueName,  '');  
    update findata.routedmessages set currentqueue = fincfg.getqueueid(intoqueuename) where correlationid = incorrelid;


EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while modifying message. Message is: %', SQLERRM;
       
END;
$$;


ALTER FUNCTION findata.modifymessageinqueue(inguid character varying, inpayload text, inbatchid character varying, incorrelid character varying, insessid character varying, inreqservice character varying, inrespservice character varying, inreqtype character varying, inpriority integer, inholdstatus integer, insequence integer, infeedback character varying, intoqueuename character varying) OWNER TO findata;

--
-- TOC entry 410 (class 1255 OID 62638)
-- Name: movemessageinqueue(character varying, character varying, character varying); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION movemessageinqueue(inguid character varying, intoqueuename character varying, infromqueuename character varying) RETURNS void
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
                                    09.Aug.2013, LucianP 7698
  Created:            09.Aug..2013, LucianP 7163
  Description:        Changes source queue for one given messages [virtually moving one message to other queue]
  Parameters:         inGuid - message identifier
                      inTOQueueName -  destination queue name
                      inFROMQueueName - current queue name [not used]                                      
  Returns:            n/a
  Used:               FinTP/BASE/RE
***********************************************/

BEGIN

       update findata.entryqueue set queuename = inTOQueueName, sequence = 0 where id = inGuid;

EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while moving message. Message is:%', SQLERRM;
       
END;
$$;


ALTER FUNCTION findata.movemessageinqueue(inguid character varying, intoqueuename character varying, infromqueuename character varying) OWNER TO findata;




--
-- TOC entry 412 (class 1255 OID 62640)
-- Name: readimage(character varying); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION readimage(OUT outretcursor refcursor, incorrelid character varying) RETURNS refcursor
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
  Created:         09.May.2014, DenisaN 8380
  Description:     Extracts and decodes transaction attached image 
  Parameters:      inCorrelID -  message correlation identifier
  Returns:         cursor
  Used:            FinTP/BASE/CONN
***********************************************/

BEGIN

   open outretcursor for  
            
    select encode(payload, 'escape') as result from findata.blobsqueue 
    where correlationid = inCorrelID
          and insertdate = ( select max(insertdate) from findata.blobsqueue where correlationid = inCorrelID ) 
          limit 1;

EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while processing image: %', SQLERRM;
       
END;
$$;


ALTER FUNCTION findata.readimage(OUT outretcursor refcursor, incorrelid character varying) OWNER TO findata;

--
-- TOC entry 414 (class 1255 OID 62641)
-- Name: readmessageinqueue(character varying, character varying); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION readmessageinqueue(OUT outretcursor refcursor, inguid character varying, inqueuename character varying) RETURNS refcursor
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
  Created:         20.Aug.2013, LucianP 7164
  Description:     Extract data for one given message in queue
  Parameters:      inGuid - message identifier
                   inQueueName - current queue name [not used]                                  
  Returns:         outRetCursor parameter representing cursor result set
  Used:            FinTP/BASE/RE
***********************************************/

BEGIN  

open outRetCursor for  
    select id, payload, batchid, correlationid, sessionid, requestorservice, responderservice, requesttype,	
           priority, holdstatus, sequence, feedback, ioidentifier
    from findata.entryqueue where id = inGuid and queuename = inQueueName;	
  
EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while reading queue: %', SQLERRM;
       
END;
$$;


ALTER FUNCTION findata.readmessageinqueue(OUT outretcursor refcursor, inguid character varying, inqueuename character varying) OWNER TO findata;

--
-- TOC entry 413 (class 1255 OID 62644)
-- Name: resumejobs(integer); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION resumejobs(instatus integer) RETURNS void
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
  Created:         20.May.2013, DenisaN 7164
  Description:     Marks routing jobs as new
  Parameters:      inStatus - old status
  Returns:         n/a
  Used:            FinTP/BASE/RE
***********************************************/       

BEGIN

    update  findata.routingjobs set status = 0 where status = inStatus;


EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while processing job: %', SQLERRM;
       
END;
$$;


ALTER FUNCTION findata.resumejobs(instatus integer) OWNER TO findata;

--
-- TOC entry 415 (class 1255 OID 62645)
-- Name: rollbackjob(character varying); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION rollbackjob(injobid character varying) RETURNS void
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
  Created:         20.May.2013, DenisaN 7164
  Description:     Updates status and backout for one given routing job 
  Parameters:      inJobID - routing job identifier
  Returns:         n/a
  Used:            FinTP/BASE/RE
***********************************************/       

BEGIN
   
   update routingjobs set backout = backout + 1, status = 0 where id = inJobID;


EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while moving message: %', SQLERRM;
       
END;
$$;


ALTER FUNCTION findata.rollbackjob(injobid character varying) OWNER TO findata;

--
-- TOC entry 417 (class 1255 OID 62651)
-- Name: terminatebatch(character varying, character varying, integer, character varying); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION terminatebatch(incombatchid character varying, inbatchtype character varying, instatus integer, inreason character varying) RETURNS void
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
  Created:         21.Aug.2013, LucianP
  Description:     Marks batch final status and remove temporary related data.
  Parameters:      inCombatchID - batch identifier
                   inBatchType - batch type
                   inStatus  - batch state      
                   inReason - reason of failure
  Returns:         n/a
  Used:            FinTP/BASE/RE
***********************************************/   


BEGIN

  update findata.batchjobs set status = inStatus, reason = substr(inReason, 1, 499 ), batchtype = inBatchType
          where batchid = inCombatchID;
   
  delete from findata.tempbatchjobs where batchid = inCombatchID;

EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while processing batch. Message is: %', SQLERRM;
       
END;
$$;


ALTER FUNCTION findata.terminatebatch(incombatchid character varying, inbatchtype character varying, instatus integer, inreason character varying) OWNER TO findata;

--
-- TOC entry 396 (class 1255 OID 62654)
-- Name: trg_insertroutingjob(); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION trg_insertroutingjob() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	insert into findata.routingjobs( id, status, backout, priority, routingpoint, function, userid )
                                 values( new.id, 0, 0, new.priority, new.queuename, 'F=Route', null );

    RETURN NULL; 
END;
$$;


ALTER FUNCTION findata.trg_insertroutingjob() OWNER TO findata;

--
-- TOC entry 354 (class 1255 OID 101647)
-- Name: trg_saveprocjob(); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION trg_saveprocjob() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN 
	insert into fintrack.routingjobsstmint( id, status, backout, priority, routingpoint, function, userid )
    values( old.id, old.status, old.backout, old.priority, old.routingpoint, old.function, old.userid );
    RETURN OLD; 
END;

$$;


ALTER FUNCTION findata.trg_saveprocjob() OWNER TO findata;

--
-- TOC entry 419 (class 1255 OID 62655)
-- Name: updatecorridblobsqueue(character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION updatecorridblobsqueue(inguid character varying, incorrelationid character varying, inbatchid character varying, inimageref character varying) RETURNS void
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
  Created:         08.May.2014, DenisaN 8380
  Description:     Updates correlation id for exiting images 
  Parameters:      inGuid - transaction identifier
                   inCorrelationid - trasaction correlation identifier 
                   inBatchID - batch identifier  
                   inImageref - image reference number / same as trx
  Returns:       n/a
  Used:          FinTP/DI/CONN
***********************************************/   


BEGIN


update findata.blobsqueue set batchid = inGuid, correlationid = inCorrelationid 
                      where batchid = inBatchid and imagereference = inImageref;
       
                            
EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while processing message: %', SQLERRM;
       
END;
$$;


ALTER FUNCTION findata.updatecorridblobsqueue(inguid character varying, incorrelationid character varying, inbatchid character varying, inimageref character varying) OWNER TO findata;

--
-- TOC entry 420 (class 1255 OID 62656)
-- Name: updatemessageinqueue(character varying, text, character varying, character varying, character varying, character varying, character varying, character varying, integer, integer, integer, character varying); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION updatemessageinqueue(inguid character varying, inpayload text, inbatchid character varying, incorrelid character varying, insessid character varying, inreqservice character varying, inrespservice character varying, inreqtype character varying, inpriority integer, inholdstatus integer, insequence integer, infeedback character varying) RETURNS void
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
  Created:             08.Aug.2013, LucianP 7698
  Description:         Updates message specific information for a message in queue
  Parameters:          inGuid - message identifier
                       inPayload  - message payload
                       inBatchID  - batch identifier
                       inCorrelID  - correlation identifier
                       inReqService  - requestor service
                       inRespService   - responder service
                       inReqType  - request type
                       inPriority   - processing priority
                       inHoldstatus  - hold status 1/0
                       inSequence - routing rule sequence
                       inFeedback  - message feedback
                       inSessID - session identifier                                     
  Returns:             n/a
  Used:                FinTP/BASE/RE
***********************************************/   

BEGIN

       update findata.entryqueue set  payload = inPayload, 
			              batchid = inBatchID , 
			              correlationid = inCorrelID, 
			              requestorservice = inReqService, 
			              responderservice = inRespService, 
                                      requesttype = inReqType, 
                                      priority = inPriority, 
                                      holdstatus = inHoldstatus, 
                                      sequence = inSequence, 
                                      feedback = inFeedback
       where id = inGuid;


EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while updating message. Message is: %', SQLERRM;
       
END;
$$;


ALTER FUNCTION findata.updatemessageinqueue(inguid character varying, inpayload text, inbatchid character varying, incorrelid character varying, insessid character varying, inreqservice character varying, inrespservice character varying, inreqtype character varying, inpriority integer, inholdstatus integer, insequence integer, infeedback character varying) OWNER TO findata;

--
-- TOC entry 403 (class 1255 OID 95387)
-- Name: updatemessagetonewqueue(character varying, text, character varying, character varying, character varying, character varying, character varying, character varying, integer, integer, integer, character varying, character varying); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION updatemessagetonewqueue(inguid character varying, inpayload text, inbatchid character varying, incorrelid character varying, insessid character varying, inreqservice character varying, inrespservice character varying, inreqtype character varying, inpriority integer, inholdstatus integer, insequence integer, infeedback character varying, intoqueuename character varying) RETURNS void
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
  Created:             09.Aug.2013, LucianP 7698
  Description:         Updates message specific information for a message in queue, along with changing the source queue name.
  Parameters:          inGuid - message identifier
                       inPayload  - message payload
                       inBatchID  - batch identifier
                       inCorrelID  - correlation identifier
                       inReqService  - requestor service
                       inRespService   - responder service
                       inReqType  - request type
                       inPriority   - processing priority
                       inHoldstatus  - hold status 1/0
                       inSequence - routing rule sequence
                       inFeedback  - message feedback
                       inSessID - session identifier 
                       inToQueueName - destination queue name                                    
  Returns:             n/a
  Used:                FinTP/BASE/RE
***********************************************/

BEGIN

    perform findata.updatemessageinqueue(inGuid,  inPayload, inBatchID,  inCorrelID, inSessID, inReqService,  inRespService, inReqType,  inPriority,  inHoldstatus,  inSequence,  inFeedback);
    perform findata.movemessageinqueue(inGuid,  inTOQueueName,  '');  
    update findata.routedmessages set currentqueue = fincfg.getqueueid(intoqueuename) where correlationid = incorrelid;


EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while modifying message. Message is: %', SQLERRM;
       
END;
$$;


ALTER FUNCTION findata.updatemessagetonewqueue(inguid character varying, inpayload text, inbatchid character varying, incorrelid character varying, insessid character varying, inreqservice character varying, inrespservice character varying, inreqtype character varying, inpriority integer, inholdstatus integer, insequence integer, infeedback character varying, intoqueuename character varying) OWNER TO findata;

--
-- TOC entry 399 (class 1255 OID 95368)
-- Name: updatemovemessageinqueue(character varying, text, character varying, character varying, character varying, character varying, character varying, character varying, integer, integer, integer, character varying, character varying); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION updatemovemessageinqueue(inguid character varying, inpayload text, inbatchid character varying, incorrelid character varying, insessid character varying, inreqservice character varying, inrespservice character varying, inreqtype character varying, inpriority integer, inholdstatus integer, insequence integer, infeedback character varying, intoqueuename character varying) RETURNS void
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
  Created:             08.Oct.2018, dd
  Description:         Updates message specific information for a message in queue, along with changing the source queue name.
  Parameters:          inGuid - message identifier
                       inPayload  - message payload
                       inBatchID  - batch identifier
                       inCorrelID  - correlation identifier
                       inReqService  - requestor service
                       inRespService   - responder service
                       inReqType  - request type
                       inPriority   - processing priority
                       inHoldstatus  - hold status 1/0
                       inSequence - routing rule sequence
                       inFeedback  - message feedback
                       inSessID - session identifier 
                       inToQueueName - destination queue name                                    
  Returns:             n/a
  Used:                FinTP/BASE/RE
***********************************************/


BEGIN

    perform findata.updatemessageinqueue(inGuid,  inPayload, inBatchID,  inCorrelID, inSessID, inReqService,  inRespService, inReqType,  inPriority,  inHoldstatus,  inSequence,  inFeedback);
    perform findata.movemessageinqueue(inGuid,  inTOQueueName,  '');  
    update findata.routedmessages set currentqueue = fincfg.getqueueid(intoqueuename) where correlationid = incorrelid;


EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while modifying message. Message is: %', SQLERRM;
       
END;
$$;


ALTER FUNCTION findata.updatemovemessageinqueue(inguid character varying, inpayload text, inbatchid character varying, incorrelid character varying, insessid character varying, inreqservice character varying, inrespservice character varying, inreqtype character varying, inpriority integer, inholdstatus integer, insequence integer, infeedback character varying, intoqueuename character varying) OWNER TO findata;


--
-- TOC entry 422 (class 1255 OID 62660)
-- Name: updatermack(character varying); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION updatermack(incorrelid character varying) RETURNS void
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
  Change history:   dd.mon.yyyy  --  author  --   description
  Created:          27.Mar.2013, DenisaN
  Description:      Increases number of replies  for one message 
  Parameters:       inCorrelID   - message correlation identifier
  Returns:          n/a
  Used:             FinTP/BASE/RE
***********************************************/   

BEGIN

   update  findata.routedmessages set ack=ack+1 where correlationid = inCorrelID;

EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while deleting job: %', SQLERRM;
       
END;
$$;


ALTER FUNCTION findata.updatermack(incorrelid character varying) OWNER TO findata;

--
-- TOC entry 427 (class 1255 OID 62661)
-- Name: updatermackbatch(character varying); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION updatermackbatch(inbatchid character varying) RETURNS void
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
  Change history:   dd.mon.yyyy  --  author  --   description
  Created:          28.Aug.2013, LucianP
  Description:      Sets the number of replies to 1; used for transactions in one given batch 
  Parameters:       inBatchID   - batch identifier
  Returns:          n/a
  Used:             FinTP/BASE/RE
***********************************************/   

BEGIN

      update findata.routedmessages set ack = 1
                          where correlationid in (select correlationid from findata.feedbackagg where batchid = inBatchID);

EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while processing reply. Message is: %', SQLERRM;
       
END;
$$;


ALTER FUNCTION findata.updatermackbatch(inbatchid character varying) OWNER TO findata;

--
-- TOC entry 428 (class 1255 OID 62662)
-- Name: updatermassembleresponder(character varying, character varying); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION updatermassembleresponder(inbatchid character varying, inreceiverapp character varying) RETURNS void
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
  Created:         20.May.2013, DenisaN 7164
  Description:     Updates the receiver application for one given group of transactions, given its batchid
  Parameters:      inBatchID   - batch identifier
                   inReceiverApp - app receiver service
  Returns:         n/a
  Used:            FinTP/BASE/RE
***********************************************/   

BEGIN

   update findata.routedmessages set requestorservice =   inReceiverApp  
                    where correlationid in ( select correlationid from findata.feedbackagg where batchid = inBatchid);


EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while processing message: %', SQLERRM;
       
END;
$$;


ALTER FUNCTION findata.updatermassembleresponder(inbatchid character varying, inreceiverapp character varying) OWNER TO findata;

--
-- TOC entry 429 (class 1255 OID 62663)
-- Name: updatermresponder(character varying, character varying); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION updatermresponder(incorrelid character varying, inreceiverapp character varying) RETURNS void
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
  Created:         20.May.2013, DenisaN 7164
  Description:     Updates the receiver application for one given message
  Parameters:      inCorrelId   - correlation identifier
                   inReceiverApp - app receiver service
  Returns:         n/a
  Used:            FinTP/BASE/RE
***********************************************/   

BEGIN

   update  findata.routedmessages set responderservice =  inReceiverApp  where correlationid = inCorrelId;


EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while processing message: %', SQLERRM;
       
END;
$$;


ALTER FUNCTION findata.updatermresponder(incorrelid character varying, inreceiverapp character varying) OWNER TO findata;

--
-- TOC entry 430 (class 1255 OID 62664)
-- Name: updatermuserid(character varying, integer); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION updatermuserid(incorrelationid character varying, inuserid integer) RETURNS void
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
  Created:         20.May.2013, DenisaN 7164
  Description:     Updates the user identifier for one given message 
  Parameters:      inCorrelationID   - correlation identifier
                   inUserID - user identifier
  Returns:         n/a
  Used:            FinTP/BASE/RE
***********************************************/   

BEGIN

    update findata.routedmessages set userid = inUserID, updatedate = now() where  correlationid = inCorrelationID;



EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while processing message: %', SQLERRM;
       
END;
$$;


ALTER FUNCTION findata.updatermuserid(incorrelationid character varying, inuserid integer) OWNER TO findata;

--
-- TOC entry 431 (class 1255 OID 62665)
-- Name: updatermvaluedate(character varying, character varying); Type: FUNCTION; Schema: findata; Owner: findata
--

CREATE FUNCTION updatermvaluedate(incorrelid character varying, invaluedate character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$
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
  Created:         20.May.2013, DenisaN 7164
  Description:     Updates the currency date for one given message 
  Parameters:      inCorrelID   - correlation identifier
                   inValueDate - message currency date
  Returns:       n/a
  Used:           FinTP/BASE/RE
***********************************************/   

v_tablename        varchar(35);
v_msgtype          varchar(35);

BEGIN
	select distinct storage, messagetype  into v_tablename, v_msgtype from fincfg.messagetypes where messagetype in 
		(select messagetype from findata.routedmessages where correlationid =  inCorrelID); 
	       
    if v_msgtype in ('CQ', 'PN', 'BE') then -- debit instruments  
        execute 'update findata.'||v_tablename||' set issuancedate = $1 where correlatinid = $2' using inValueDate, inCorrelID;
    else    
        execute 'update findata.'||v_tablename||' set valuedate = $1 where correlationid = $2' using inValueDate, inCorrelID;
    end if;
    
EXCEPTION
WHEN OTHERS THEN
   RAISE EXCEPTION 'Unexpected error occured while processing message: %', SQLERRM;
       
END;
$_$;


ALTER FUNCTION findata.updatermvaluedate(incorrelid character varying, invaluedate character varying) OWNER TO findata;

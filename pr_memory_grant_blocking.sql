USE [admin]
GO

/****** Object:  StoredProcedure [dbo].[memory_grant_blocking]    
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* USE [DBA]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
*/

CREATE PROCEDURE [dbo].[memory_grant_blocking] 
AS
SET NOCOUNT ON

print '';
select
    getdate() as [report_date],
    left(@@servername, 30) as [servername],
    'Memory Grant Blocking Report' as [report_name]
  ;

--declare event name
declare @event_name sysname = 'dbtk_memory_grant_blocking';

if  exists (select 1 from sys.server_event_sessions where name = @event_name)
  begin
    declare @aus_file sysname;
    select
        @aus_file = cast(value as sysname)
      from
        sys.server_event_session_fields  f
      inner join
        sys.server_event_sessions   s
      on
        f.event_session_id = s.event_session_id
      where
        f.name = 'filename'  and
        s.name = @event_name
    select
        n.value('(@timestamp)[1]', 'datetime') AS event_time,
        n.value('(data[@name="blocking_session_id"]/value)[1]'     , 'int'          ) as blocking_session_id      ,
        n.value('(data[@name="ideal_memory_kb"]/value)[1]'         , 'bigint'       ) as ideal_memory_kb          ,
        n.value('(data[@name="max_query_memory_kb"]/value)[1]'     , 'bigint'       ) as max_query_memory_kb      ,
        n.value('(data[@name="request_time"]/value)[1]'            , 'datetime'     ) as request_time             ,
        n.value('(data[@name="requested_memory_kb"]/value)[1]'     , 'bigint'       ) as requested_memory_kb      ,
        n.value('(data[@name="required_memory_kb"]/value)[1]'      , 'bigint'       ) as required_memory_kb       ,
        n.value('(data[@name="total_available_memory_kb"]/value)[1]', 'bigint'       ) as total_available_memory_kb,
        n.value('(data[@name="total_granted_memory_kb"]/value)[1]' , 'bigint'       ) as total_granted_memory_kb  ,
        n.value('(data[@name="total_max_memory_kb"]/value)[1]'     , 'bigint'       ) as total_max_memory_kb      ,
        n.value('(data[@name="wait_time_sec"]/value)[1]'           , 'int'          ) as wait_time_sec            ,
        n.value('(data[@name="dop"]/value)[1]'                     , 'int'          ) as dop                      ,
        n.value('(action[@name="username"]/value)[1]'              , 'varchar(30)' )  as username                 ,
        n.value('(action[@name="sql_text"]/value)[1]'              , 'nvarchar(2000)')as sql_text                 ,
        n.value('(action[@name="plan_handle"]/value)[1]'           , 'varbinary(64)') as plan_handle              ,
        n.value('(action[@name="database_id"]/value)[1]'           , 'int'          ) as database_id              ,
        n.value('(action[@name="database_name"]/value)[1]'         , 'varchar(100)' ) as database_name            ,
        n.value('(action[@name="client_app_name"]/value)[1]'       , 'varchar(100)' ) as client_app_name          ,
        n.value('(action[@name="client_hostname"]/value)[1]'       , 'varchar(100)' ) as client_hostname          ,
        n.value('(action[@name="is_system"]/value)[1]'             , 'bit'          ) as is_system                ,
        n.value('(action[@name="server_principal_name"]/value)[1]' , 'varchar(30)'  ) as server_principal_name    ,
        n.value('(action[@name="process_id"]/value)[1]'            , 'integer'      ) as process_id
      into
        #ee
      from (select cast(event_data as XML) as event_data
      from sys.fn_xe_file_target_read_file(@aus_file + '*.xel', NULL, NULL, NULL)) ed
      cross apply ed.event_data.nodes('event') as q(n)

    print ''; print 'Sessions blocked requesting memory: '
    select
        request_time             ,
        server_principal_name    ,
        wait_time_sec            ,
        ideal_memory_kb          ,
        requested_memory_kb      ,
        required_memory_kb       ,
        max_query_memory_kb
      from
        #ee
      ;



  end;
else
  begin
    print ''; print 'Error, no memory blocking found.';
  end;

return 0;

GO



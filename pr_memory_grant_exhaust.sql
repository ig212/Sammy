USE [admin]
GO

/****** Object:  StoredProcedure [dbo].[memory_grant_exhaust]    Script Date: 9/7/2022 4:00:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*USE [admin]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
*/



CREATE PROCEDURE [dbo].[memory_grant_exhaust]  

as
drop table if exists #mgu;
SET NOCOUNT ON 
declare @event_name sysname = 'dbtk_memory_grant_usage';

create table #mgu(
        [timestamp        ] datetime      ,
        [ideal_memory_kb  ] bigint        ,
        [granted_memory_kb] bigint        ,
        [used_memory_kb   ] bigint        ,
        [usage_percent    ] integer       ,
        [dop              ] integer       ,
        [granted_percent  ] integer       ,
        [username         ] varchar(100)  ,
        [sql_text         ] varchar(2000) ,
        [plan_handle      ] varbinary(64) ,
        [nt_username      ] varchar(100)  ,
        [is_system        ] bit           ,
        [database_name    ] varchar(100)  ,
        [process_id       ] integer
  );


if exists (select 1 from sys.server_event_sessions where name = @event_name)
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
      ;

    insert
        #mgu
      select
        [timestamp        ]  = n.event_data.value('(event/@timestamp)[1]'                              , 'datetime'      ),
        [ideal_memory_kb  ] = n.event_data.value('(event/data[@name  ="ideal_memory_kb"  ]/value)[1]' , 'bigint'        ),
        [granted_memory_kb] = n.event_data.value('(event/data[@name  ="granted_memory_kb"]/value)[1]' , 'bigint'        ),
        [used_memory_kb   ] = n.event_data.value('(event/data[@name  ="used_memory_kb"   ]/value)[1]' , 'bigint'        ),
        [usage_percent    ] = n.event_data.value('(event/data[@name  ="usage_percent"    ]/value)[1]' , 'integer'       ),
        [dop              ] = n.event_data.value('(event/data[@name  ="dop"              ]/value)[1]' , 'integer'       ),
        [granted_percent  ] = n.event_data.value('(event/data[@name  ="granted_percent"  ]/value)[1]' , 'integer'       ),
        [username         ] = n.event_data.value('(event/action[@name="username"         ]/value)[1]' , 'varchar(100)'  ),
        [sql_text         ] = n.event_data.value('(event/action[@name="sql_text"         ]/value)[1]' , 'varchar(2000)' ),
        [plan_handle      ] = n.event_data.value('(event/action[@name="plan_handle"      ]/value)[1]' , 'varbinary(64)' ),
        [nt_username      ] = n.event_data.value('(event/action[@name="nt_username"      ]/value)[1]' , 'varchar(100)'  ),
        [is_system        ] = n.event_data.value('(event/action[@name="is_system"        ]/value)[1]' , 'bit'           ),
        [database_name    ] = n.event_data.value('(event/action[@name="database_name"    ]/value)[1]' , 'varchar(100)'  ),
        [process_id       ] = n.event_data.value('(event/action[@name="process_id"       ]/value)[1]' , 'integer'       )
      from
       (select 
            cast(event_data as XML) as event_data
          from
            sys.fn_xe_file_target_read_file(@aus_file + '*.xel', NULL, NULL, NULL)  
			where cast(timestamp_utc as datetime2 ) > dateadd(DAY, -1,GETUTCDATE())--order by pf.timestamp_utc 

       ) as n

	  ;
	  END
	  

	begin 
		if exists(select * from #mgu where [ideal_memory_kb  ] >=granted_memory_kb and [usage_percent    ] =100)
				print 'Memory Exhausted!!! processes spilled over to Tempdb. Incident Ticket required!!!.'
		else 

				print 'No Processes used up all granted memory and usage, nor did they spill over to Tempdb'
	

end





GO



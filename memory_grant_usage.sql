CREATE EVENT SESSION [dbtk_resgov_memory_grant_usage] ON SERVER 
ADD EVENT sqlserver.query_memory_grant_usage(
    ACTION(package0.process_id,sqlserver.database_name,sqlserver.is_system,sqlserver.nt_username,sqlserver.plan_handle,sqlserver.sql_text,sqlserver.username)
    WHERE ([granted_memory_kb]>=(1040)))
ADD TARGET package0.event_file(SET filename=N'dbtk_resgov_memory_grant_usage',max_file_size=(200),max_rollover_files=(10))
WITH (MAX_MEMORY=4096 KB,EVENT_RETENTION_MODE=ALLOW_MULTIPLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=OFF,STARTUP_STATE=ON)
GO



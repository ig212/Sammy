CREATE EVENT SESSION [dbtk_resgov_memory_grant_blocking] ON SERVER 
ADD EVENT sqlserver.query_memory_grant_blocking(
    ACTION(package0.process_id,sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.database_id,sqlserver.database_name,sqlserver.is_system,sqlserver.plan_handle,sqlserver.server_principal_name,sqlserver.sql_text,sqlserver.username))
ADD TARGET package0.event_file(SET filename=N'memory_grant_blocking',max_file_size=(200),max_rollover_files=(9))
WITH (MAX_MEMORY=4096 KB,EVENT_RETENTION_MODE=ALLOW_MULTIPLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=OFF,STARTUP_STATE=ON)
GO



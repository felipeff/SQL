USE [master]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER   PROCEDURE [dbo].[AlertToSlack] @message_txt VARCHAR(4000)
AS
BEGIN
EXEC sp_execute_external_script @language =N'Python',
@script=N'
import json
import urllib3
import certifi
urllib3.disable_warnings()
http = urllib3.ProxyManager(proxy_url="YOUR_PROXY_URL", cert_reqs=''CERT_REQUIRED'', ca_certs=certifi.where())
http = http = urllib3.PoolManager()

def post_to_slack(message):
    slack_url = "YOUR_SLACK_WEBHOOK_URL"
    
    encoded_data = json.dumps({''text'': message, ''username'': "SQL Server", "icon_url": "https://d2.alternativeto.net/dist/icons/sql-server-management-studio_60533.png?width=200&height=200&mode=crop&upscale=false" }).encode(''utf-8'')
    response = http.request("POST", slack_url, body=encoded_data, headers={''Content-Type'': ''application/json''})
    #print(str(response.status) + str(response.data))

post_to_slack(message_txt_in)
',
@params = N'@message_txt_in varchar(4000)',
@message_txt_in = @message_txt

END	
GO



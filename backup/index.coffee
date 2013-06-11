# Backs up the ccadmin database of the active mongo instance to a Google Drive folder every day
cronJob = require('cron').CronJob
childProcess = require('child_process')

outputFolder = '/Users/raine/Google Drive/Backup/College Coding Admin/'
dbName = 'ccadmin'
crontab = '0 0 * * *'

console.log "Database: " + dbName
console.log "Backup Location: " + outputFolder
console.log "Scheduling cronjob for #{crontab}"
job = new cronJob(crontab, ->
	timestamp = (new Date()).toISOString()
	dumpcommand = childProcess.exec "mongodump --db #{dbName} --out '#{outputFolder}/dump-#{timestamp}'", (error, stdout, stderr)->
		if error
			console.log(error.stack)
			console.log('Error code: ' + error.code)
			console.log('Signal received: ' + error.signal)
			console.log('Child Process STDERR: ' + stderr)
		console.log stdout

	dumpcommand.on 'exit', (code)->
		console.log 'Child process exited with exit code ' + code
,null
,true
)

console.log 'Cronjob scheduled.'

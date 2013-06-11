# Backs up the ccadmin database of the active mongo instance to a Google Drive folder every day
cronJob = require('cron').CronJob
childProcess = require('child_process')

outputFolder = '/Users/raine/Google Drive/Backup/College Coding Admin'
dbName = 'ccadmin'
collections = ['clients', 'payments', 'sessions']
crontab = '0 0 * * *'

console.log "Database: " + dbName
console.log "Backup Location: " + outputFolder
console.log "Scheduling cronjob for #{crontab}"

job = new cronJob(crontab, ->
	console.log 'a'
	timestamp = (new Date()).toISOString()
	execWithOutput "mongodump --db #{dbName} --out '#{outputFolder}/#{timestamp}/dump'"
	for collection in collections
		execWithOutput "mongoexport --db #{dbName} --collection #{collection} --out '#{outputFolder}/#{timestamp}/export/#{collection}.json'"
,null
,true
)

# Execute a child process with output and errors hooked up to the console
execWithOutput = (command)->
	console.log 'Executing child process'
	console.log command
	process = childProcess.exec command, (error, stdout, stderr)->
		if error
			console.log(error.stack)
			console.log('Error code: ' + error.code)
			console.log('Signal received: ' + error.signal)

		#console.log('Child Process STDERR: ' + stderr)
		console.log('Child Process STDOUT:')
		console.log stdout

	process.on 'exit', (code)->
		console.log 'Child process exited with exit code ' + code


console.log 'Cronjob scheduled.'

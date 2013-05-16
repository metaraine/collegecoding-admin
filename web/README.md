# setup
npm install
bower install

# background jobs
mongod &
smog &

stylus public/style/ -w &
coffee -o ./ -cw src/ &
coffee -o public/scripts/out/ -cw public/scripts/src/ &

# start app
foreman start

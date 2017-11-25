fs = require 'fs'
path = require('path')

winston = require('winston')
require('winston-daily-rotate-file')

Sentry = require 'winston-raven-sentry'

morgan = require('morgan')
rfs = require('rotating-file-stream')

_setupWinston = ()->
  # setup the daily rotate log
  dailyRotateTransport = new (winston.transports.DailyRotateFile)(
    filename: "#{process.env.LOG_PATH}/log"
    datePattern: 'yyyy-MM-dd.'
    prepend: true
    level: process.env.LOG_LEVEL
  )
  # setup the basic transports
  transports = [
    dailyRotateTransport
  ]
  # setup the console transport for dev
  if process.env.NODE_ENV != 'production'
    transports.push new winston.transports.Console
      level: process.env.LOG_LEVEL
  # setup sentry if a dsn is provided
  if process.env.SENTRY_DSN
    transports.push new Sentry
      dsn: process.env.SENTRY_DSN
      level: 'error'
  # create the logger
  logger = new (winston.Logger)
    transports: transports
  # make the logger available as global Winston
  global['Winston'] = logger
  # finally, log that we got a logger
  Winston.silly '[Winston]: initialized'
  # return the logger
  return logger

_setupMorgan = () ->
  format = if process.env.NODE_ENV == 'production' then 'combined' else 'short'
  accessLogStream = rfs 'access.log',
    interval: '1d',
    path: process.env.LOG_PATH
  return morgan(format, {stream: accessLogStream})

module.exports = (app) ->
  # ensure the directory exists
  fs.existsSync(process.env.LOG_PATH) || fs.mkdirSync(process.env.LOG_PATH)
  # setup the winston logger
  logger = _setupWinston()
  # setup morgan and use it as express middleware
  app.use _setupMorgan()

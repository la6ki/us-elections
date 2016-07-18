dotenv = require 'dotenv'
path = require 'path'
nodemailer = require 'nodemailer'
moment = require 'moment'
files = require '../helpers/file_system'

DATE_FORMAT = 'MMMM Do YYYY, h:mm:ss a'
RECEPIENTS = 'luca.ambrogioni@gmail.com, lyubenlaskin@gmail.com'
ERROR_LOG_FILE = 'mailing_errors.log'

dotenv.config path: path.join(__dirname, "../../.env")
now = moment()
date = now.format DATE_FORMAT
writeToErrorLog = files.writeFileSync

sendMail = (type, content = '') ->
  transporter = nodemailer.createTransport
    service: 'Gmail'
    auth:
      user: process.env.REPORTS_EMAIL
      pass: process.env.REPORTS_PASS

  options =
    from: "Analysis Reports <#{process.env.REPORTS_EMAIL}>"
    to: RECEPIENTS
    subject: "2016 Election Analysis Report: #{date} (#{type})"
    text: content

  transporter.sendMail options, (err) ->
    writeToErrorLog ERROR_LOG_FILE, "#{date}\n\n#{err}\n\n\n" if err

exports.send = sendMail
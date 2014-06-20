class Status < ActiveRecord::Base
  UNPROCESSED = "unprocessed"
  IGNORED = "ignored"
  DUPLICATE = "duplicate"
  PROCESSED = "processed"
end
class Task < ApplicationRecord
  # See https://github.com/kenn/active_flag#usage
  flag :kinds, %I[home work buy event]
end

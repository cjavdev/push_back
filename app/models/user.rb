# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  f_name     :string(255)
#  l_name     :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
end

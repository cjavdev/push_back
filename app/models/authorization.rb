# == Schema Information
#
# Table name: authorizations
#
#  id         :integer          not null, primary key
#  provider   :string(255)
#  uid        :string(255)
#  user_id    :integer
#  token      :string(255)
#  secret     :string(255)
#  name       :string(255)
#  link       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Authorization < ActiveRecord::Base
  belongs_to :user

  def self.build_from_json!(data)
    Authorization.new(scrub_fb_authorization_data(data))
  end

  def self.scrub_fb_authorization_data(data)
    {
     uid: data[:id],
     token: data[:authResponse][:accessToken],
     name: data[:name],
     link: data[:link]
    }
  end
end

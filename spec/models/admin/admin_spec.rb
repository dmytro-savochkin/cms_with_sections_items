require 'spec_helper'

describe Admin do
  admin = {:name => "123", :password => "456"}
  wrong_admin = {:name => "wrong", :password => "wrong"}

  describe 'model method hash_password' do
    it 'should match right hash' do
      assert Admin.hash_password(admin[:password]) == Digest::MD5.hexdigest(admin[:password])
    end
    it 'should not match wrong hash' do
      assert Admin.hash_password(admin[:password]) != Digest::MD5.hexdigest(wrong_admin[:password])
    end
  end

end

# require File.dirname(__FILE__) + '/../../spec_helper'
# require 'cgi'
# 
# describe OmniAuth::Strategies::CAS, :type => :strategy do
#   
#   include OmniAuth::Test::StrategyTestCase
#   
#   def strategy
#     @cas_server ||= 'https://cas.example.org'
#     [OmniAuth::Strategies::CAS, {:cas_server => @cas_server}]
#   end
#   
#   describe 'GET /auth/cas' do
#     before do
#       get '/auth/cas'
#     end
#     
#     it 'should redirect to the CAS server' do
#       last_response.should be_redirect
#       return_to = CGI.escape(last_request.url + '/callback')
#       last_response.headers['Location'].should == @cas_server + '/login?service=' + return_to
#     end
#   end
#   
#   describe 'GET /auth/cas/callback without a ticket' do
#     before do
#       get '/auth/cas/callback'
#     end
#     it 'should fail' do
#       last_response.should be_redirect
#       last_response.headers['Location'].should =~ /no_ticket/
#     end
#   end
#   
#   describe 'GET /auth/cas/callback with an invalid ticket' do
#     before do
#       stub_request(:get, /^https:\/\/cas.example.org(:443)?\/serviceValidate\?([^&]+&)?ticket=9391d/).
#          to_return(:body => File.read(File.join(File.dirname(__FILE__), '..', '..', 'fixtures', 'cas_failure.xml')))
#       get '/auth/cas/callback?ticket=9391d'
#     end
#     it 'should fail' do
#       last_response.should be_redirect
#       last_response.headers['Location'].should =~ /invalid_ticket/
#     end
#   end
#   
#   describe 'GET /auth/cas/callback with a valid ticket' do
#     before do
#       stub_request(:get, /^https:\/\/cas.example.org(:443)?\/serviceValidate\?([^&]+&)?ticket=593af/).
#          to_return(:body => File.read(File.join(File.dirname(__FILE__), '..', '..', 'fixtures', 'cas_success.xml')))
#       get '/auth/cas/callback?ticket=593af'
#     end
#     
#     sets_an_auth_hash
#     sets_provider_to 'cas'
#     sets_uid_to 'psegel'
#     
#     it 'should set additional user information' do
#       extra = (last_request['auth'] || {})['extra']
#       extra.should be_kind_of(Hash)
#       extra['first-name'].should == 'Peter'
#       extra['last-name'].should == 'Segel'
#       extra['hire-date'].should == '2004-07-13'
#     end
#   
#     it 'should call through to the master app' do
#       last_response.should be_ok
#       last_response.body.should == 'true'
#     end
#   end
# end

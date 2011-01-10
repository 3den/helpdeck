require 'omniauth/enterprise'
require 'net/ldap'
require 'sasl/base'
require 'sasl'

module OmniAuth
  module Strategies
    class LDAP
      include OmniAuth::Strategy
      
      autoload :Adaptor, 'omniauth/strategies/ldap/adaptor'
      @@config   = {'name' => 'cn', 
                    'first_name' => 'givenName',
                    'last_name' => 'sn',
                    'email' => ['mail', "email", 'userPrincipalName'],
					'phone' => ['telephoneNumber', 'homePhone', 'facsimileTelephoneNumber'],
					'mobile_number' => ['mobile', 'mobileTelephoneNumber'],
					'nickname' => ['uid', 'userid', 'sAMAccountName'],
					'title' => 'title',
					'location' => {"%0, %1, %2, %3 %4" => [['address', 'postalAddress', 'homePostalAddress', 'street', 'streetAddress'], ['l'], ['st'],['co'],['postOfficeBox']]},
					'uid' => 'dn',
					'url' => ['wwwhomepage'],
					'image' => 'jpegPhoto',
					'description' => 'description'}

      # Initialize the LDAP Middleware
      #
      # @param [Rack Application] app Standard Rack middleware argument.
      # @option options [String, 'LDAP Authentication'] :title A title for the authentication form.
      def initialize(app, options = {}, &block)
        super(app, options[:name] || :ldap, options.dup, &block)
        @name_proc = (@options.delete(:name_proc) || Proc.new {|name| name})
        @adaptor = OmniAuth::Strategies::LDAP::Adaptor.new(options)
      end
      
      protected
      
      def request_phase
        if env['REQUEST_METHOD'] == 'GET'
          get_credentials
        else
          perform
        end
      end

	  def get_credentials
        OmniAuth::Form.build(options[:title] || "LDAP Authentication") do
          text_field 'Login', 'username'
          password_field 'Password', 'password'
        end.to_response
      end

      def perform
      	begin
				@ldap_user_info = {}
        (@adaptor.bind unless @adaptor.bound?) rescue puts "failed to bind with the default credentials"          
        @ldap_user_info = @adaptor.search(:filter => Net::LDAP::Filter.eq(@adaptor.uid, @name_proc.call(request.POST['username'])),:limit => 1) if @adaptor.bound?
				bind_dn = request.POST['username']
				bind_dn = @ldap_user_info[:dn].to_a.first if @ldap_user_info[:dn]
        @adaptor.bind(:bind_dn => bind_dn, :password => request.POST['password'])
        @ldap_user_info = @adaptor.search(:filter => Net::LDAP::Filter.eq(@adaptor.uid, @name_proc.call(request.POST['username'])),:limit => 1) if @ldap_user_info.empty?
    	  @user_info = self.class.map_user(@@config, @ldap_user_info)

        @env['omniauth.auth'] = auth_hash
	      @env['PATH_INFO'] = "#{OmniAuth.config.path_prefix}/#{name}/callback"
	
	      call_app!
      	rescue Exception => e
      	  fail!(:invalid_credentials, e)
      	end
      end      

      def callback_phase
      	fail!(:invalid_request)
      end
      
      def auth_hash
        OmniAuth::Utils.deep_merge(super, {
          'uid' => @user_info["uid"],
          'user_info' => @user_info,
          'extra' => @ldap_user_info
        })
      end
      
	  def self.map_user(mapper, object)
		user = {}
		mapper.each do |key, value|
		  case value
		  when String
		    user[key] = object[value.downcase.to_sym].to_s if object[value.downcase.to_sym]
		  when Array
		    value.each {|v| (user[key] = object[v.downcase.to_sym].to_s; break;) if object[v.downcase.to_sym]}
		  when Hash
		    value.map do |key1, value1|
			  pattern = key1.dup
			  value1.each_with_index do |v,i|
			    part = '';
			    v.each {|v1| (part = object[v1.downcase.to_sym].to_s; break;) if object[v1.downcase.to_sym]}
			    pattern.gsub!("%#{i}",part||'') 
			  end	
			  user[key] = pattern
		    end
		  end
		end
		user
	  end       
    end
  end
end

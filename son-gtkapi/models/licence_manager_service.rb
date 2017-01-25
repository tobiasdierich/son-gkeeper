##
## Copyright (c) 2015 SONATA-NFV [, ANY ADDITIONAL AFFILIATION]
## ALL RIGHTS RESERVED.
## 
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
## 
##     http://www.apache.org/licenses/LICENSE-2.0
## 
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
## 
## Neither the name of the SONATA-NFV [, ANY ADDITIONAL AFFILIATION]
## nor the names of its contributors may be used to endorse or promote 
## products derived from this software without specific prior written 
## permission.
## 
## This work has been performed in the framework of the SONATA project,
## funded by the European Commission under Grant number 671517 through 
## the Horizon 2020 and 5G-PPP programmes. The authors would like to 
## acknowledge the contributions of their colleagues of the SONATA 
## partner consortium (www.sonata-nfv.eu).
# encoding: utf-8
require './models/manager_service.rb'

class LicenceManagerService < ManagerService
  
  JSON_HEADERS = { 'Accept'=> 'application/json', 'Content-Type'=>'application/json'}
  LOG_MESSAGE = 'GtkApi::' + self.name
  LICENCE_TYPES_URL = '/api/v1/types/'
  LICENCES_URL = '/api/v1/licences/'
  
  def self.config(url:, logger:)
    method = LOG_MESSAGE + "#config(url=#{url}, logger=#{logger})"
    raise ArgumentError.new('LicenceManagerService can not be configured with nil url') if url.nil?
    raise ArgumentError.new('LicenceManagerService can not be configured with empty url') if url.empty?
    raise ArgumentError.new('LicenceManagerService can not be configured with nil logger') if logger.nil?
    @@url = url
    @@logger = logger
    @@logger.debug(method) {'entered'}
  end

  def self.create_type(params)
    method = LOG_MESSAGE + "#" + __method__+"(params=#{params})"
    @@logger.debug(method) {'entered'}
    begin
      licence_type = postCurb(url: @@url+LICENCE_TYPES_URL, body: params, logger: @@logger)
      @@logger.debug(method) {"licence_type=#{licence_type.body}"}
      JSON.parse licence_type.body
    rescue  => e #RestClient::Conflict
      @@logger.error(method) {"Error during processing: #{$!}"}
      @@logger.error(method) {"Backtrace:\n\t#{e.backtrace.join("\n\t")}"}
      {error: 'Licence type not created', licence_type: e.backtrace}
    end
  end
  
  def self.create_licence(params)
    method = LOG_MESSAGE + "#" + __method__+"(params=#{params})"
    @@logger.debug(method) {'entered'}
    begin
      licence = postCurb(url: @@url+LICENCES_URL, body: params, logger: @@logger)
      @@logger.debug(method) {"licence=#{licence.body}"}
      JSON.parse licence.body
    rescue  => e #RestClient::Conflict
      @@logger.error(method) {"Error during processing: #{$!}"}
      @@logger.error(method) {"Backtrace:\n\t#{e.backtrace.join("\n\t")}"}
      {error: 'Licence type not created', licence: e.backtrace}
    end
  end

  def self.find_licence_type_by_uuid(uuid)
    method = LOG_MESSAGE + "##{__method__}(#{uuid})"
    @@logger.debug(method) {'entered'}
    headers = JSON_HEADERS
    #headers[:params] = uuid
    begin
      response = getCurb(url: @@url + LICENCE_TYPES_URL + uuid + '/', headers: headers, logger: @@logger)
      parsed_response = JSON.parse response.body
      #{"status_code:": 200, "data": {"duration": 10, "status": "ACTIVE", "type": "Private", "type_uuid": "9e0dffc3-707e-41b6-81d1-79196cfe88a9"}, "description": "Type successfully retrieved", "error": ""}
      parsed_response['data']
    rescue => e
      @@logger.error(method) {"Error during processing: #{$!}"}
      @@logger.error(method) {"Backtrace:\n\t#{e.backtrace.join("\n\t")}"}
      nil 
    end
  end

  def self.find_licence_by_uuid(uuid)
    method = LOG_MESSAGE + "##{__method__}(#{uuid})"
    @@logger.debug(method) {'entered'}
    headers = JSON_HEADERS
    #headers[:params] = uuid
    begin
      response = getCurb(url: @@url + LICENCES_URL + uuid + '/', headers: headers, logger: @@logger)
      JSON.parse response.body
    rescue => e
      @@logger.error(method) {"Error during processing: #{$!}"}
      @@logger.error(method) {"Backtrace:\n\t#{e.backtrace.join("\n\t")}"}
      nil 
    end
  end
  
  def self.find_licence_types(params)
    method = LOG_MESSAGE + "#find_licence_types(#{params})"
    @@logger.debug(method) {'entered'}
    headers = JSON_HEADERS
    headers[:params] = params unless params.empty?
    @@logger.debug(method) {"headers=#{headers}"}
    begin
      response = getCurb(url: @@url + LICENCE_TYPES_URL, headers: headers, logger: @@logger) 
      @@logger.debug(method) {"response=#{response}"}
      parsed_response = JSON.parse response.body
      #{"status_code:"=>200, "data"=>{"types"=>[{"duration"=>1000, "status"=>"ACTIVE", "type"=>"Public", "type_uuid"=>"21cf0db6-f96b-4659-a463-05d5c3413141"}, {"duration"=>10, "status"=>"ACTIVE", "type"=>"Private", "type_uuid"=>"9e0dffc3-707e-41b6-81d1-79196cfe88a9"}]}, "description"=>"Types list successfully retrieved", "error"=>""}
      parsed_response['data']['types']
    rescue => e
      @@logger.error(method) {"Error during processing: #{$!}"}
      @@logger.error(method) {"Backtrace:\n\t#{e.backtrace.join("\n\t")}"}
      nil 
    end
  end
  
  def self.find_licences(params)
    method = LOG_MESSAGE + "#find_licences(#{params})"
    @@logger.debug(method) {'entered'}
    headers = JSON_HEADERS
    headers[:params] = params unless params.empty?
    @@logger.debug(method) {"headers=#{headers}"}
    begin
      response = getCurb(url: @@url + LICENCES_URL, headers: headers, logger: @@logger) 
      @@logger.debug(method) {"response=#{response}"}
      JSON.parse response.body
    rescue => e
      @@logger.error(method) {"Error during processing: #{$!}"}
      @@logger.error(method) {"Backtrace:\n\t#{e.backtrace.join("\n\t")}"}
      nil 
    end
  end

  def self.get_log
    method = LOG_MESSAGE + "#get_log()"
    @@logger.debug(method) {'entered'}

    response=getCurb(url: @@url+'/admin/logs', headers: {'Content-Type' => 'text/plain; charset=utf8', 'Location' => '/'}, logger: @@logger)
    @@logger.debug(method) {'status=' + response.response_code.to_s}
    case response.response_code
      when 200
        response.body
      else
        @@logger.error(method) {"Error during processing: #{$!}"}
        @@logger.error(method) {"Backtrace:\n\t#{e.backtrace.join("\n\t")}"}
        nil
      end
  end
  
  def self.url
    @@logger.debug(LOG_MESSAGE + "#url") {'@@url='+@@url}
    @@url
  end
end

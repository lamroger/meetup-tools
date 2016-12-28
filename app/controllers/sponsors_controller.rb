require 'rest-client'

class SponsorsController < ApplicationController
  def index
  end

  def similar
    @meetup_name = params[:url_name]

    begin
      response = RestClient.get("https://api.meetup.com/#{@meetup_name}/similar_groups", {params: {key: Rails.application.secrets.meetup_api_key}})
      @similar_groups = {}
      JSON.parse(response.body).each do |similar_group|
        urlname = similar_group['urlname']
        name = similar_group['name']
        similar_group_sponsor_response = RestClient.get("https://api.meetup.com/2/groups", {params: {group_urlname: urlname, fields: 'sponsors', key: Rails.application.secrets.meetup_api_key}})
        
        @similar_groups[name] = {
          'sponsors' => JSON.parse(similar_group_sponsor_response.body)['results'][0]['sponsors']
        }
      end
    rescue RestClient::ExceptionWithResponse => e
      Rails.logger.debug("Error with meetup api: #{@error_response}")
      @error_response = e.response
    end
  end
end

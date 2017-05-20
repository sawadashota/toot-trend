require 'net/http'
require 'json'
require 'sanitize'

module RequestMastodon
  # extend ActiveSupport::Concern

  FETCH_POSTS_LIMIT = 40
  REQUEST_LOOP_TIME = 25

  def fetch_posts(instance)
    text   = ''
    max_id = nil

    REQUEST_LOOP_TIME.times do
      res, max_id = request_mastodon(instance, max_id)
      res.each do |post|
        text << clean_text(post["content"])
      end

      res.count == FETCH_POSTS_LIMIT ? max_id = res.last["id"] : break
      sleep 5
    end

    text
  end

  def alive_instance?(instance)
    url, max_id = generate_url(instance, nil)
    content_present?(url)
  end

  private

  def request_mastodon(instance, max_id)
    url, max_id = generate_url(instance, max_id)
    json        = Net::HTTP.get(URI.parse(url))
    res         = JSON.parse(json)
    [res, max_id]
  end

  def generate_url(instance, max_id)
    url = "https://#{instance}/api/v1/timelines/public?local=true&limit=#{FETCH_POSTS_LIMIT}"
    url += "&max_id=#{max_id}" if max_id.present?
    [url, max_id]
  end

  def content_present?(url)
    begin
      json  = Net::HTTP.get(URI.parse(url))
      res   = JSON.parse(json)
      alive = res[0]['content'].present?
    rescue
      alive = false
    end

    alive
  end

  def clean_text(post)
    Sanitize.clean(post).gsub(/https?:\/\/.+?\s/, '')
  end

end

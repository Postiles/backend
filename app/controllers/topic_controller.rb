class TopicController < ApplicationController
  def get_topic
    user = auth(params) or return
    topic = find_topic(params[:topic_id]) or return

    render_ok :topic => topic
  end

  def get_topics_in_platform
    user = auth(params) or return
    platform = find_platform(params[:platform_id]) or return

    topics = platform.topics.map do |t|
      { :topic => topic }
    end

    render_ok topics
  end
end

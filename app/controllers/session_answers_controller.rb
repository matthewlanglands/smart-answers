class SessionAnswersController < ApplicationController
  def show
    @title = presenter.title
    @content_item = ContentItemRetriever.fetch(name) if presenter.finished?
    render "smart_answers/#{page_type}", formats: [:html]
  end

  def update
    add_new_response_to_session
    redirect_to session_flow_path(id: params[:id], node_name: next_node_name)
  end

private

  def presenter
    params_with_responses = params.merge({ responses: session.to_h || {} })
    @presenter ||= FlowPresenter.new(params_with_responses, smart_answer)
  end

  def name
    @name ||= params[:id].gsub(/_/, "-").to_sym
  end

  def smart_answer
    @smart_answer ||= flow_registry.find(name.to_s)
  end

  def flow_registry
    SmartAnswer::FlowRegistry.instance
  end

  def add_new_response_to_session
    session[params[:node_name]] = params[:response]
  end

  def page_type
    return :landing if params[:node_name].blank?
    return :result if presenter.finished?

    :question
  end

  def next_node_name
    presenter.current_state.current_node.to_s
  end

  def debug?
    Rails.env.development? && params[:debug]
  end
  helper_method :debug?
end

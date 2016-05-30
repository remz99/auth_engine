class StuffController < AuthEngine::ApplicationController
  before_filter :login_required, only: [:private]

  def private
  end

  def public
  end
end

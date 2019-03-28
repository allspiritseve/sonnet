# frozen_string_literal: true

module Sonnet
 class Rails < ::Rails::Engine
    config.before_configuration do
      require "sonnet/monkeypatch"
    end
  end
end

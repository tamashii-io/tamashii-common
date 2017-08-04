module Tamashii
  module AgentHint
    # Create hint constant
    ["TIME"].each do |hint|
      module_eval("#{hint} = '##__HINT__#{hint}__##'")
    end
  end
end

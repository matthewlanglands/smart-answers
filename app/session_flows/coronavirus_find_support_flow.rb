class CoronavirusFindSupportFlow
  NODES = {
    need_help_with: :feel_safe,
    feel_safe: :afford_rent_mortgage_bills,
  }.freeze

  attr_reader :node_name
  def initialize(node_name)
    @node_name = node_name.to_sym
  end

  def next_node
    NODES[node_name]
  end

  def has_node?
    NODES.keys.include?(node_name)
  end
end

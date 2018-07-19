module TheNodeModel
  extend ActiveSupport::Concern

  included do
    has_closure_tree
    attribute :parent_ancestors
    before_save :sync_parent_id
  end

  def depth_str
    (0..self.class.max_depth - self.depth).to_a.reverse.join
  end

  def sync_parent_id
    _parent_id = self.parent_ancestors&.values.to_a.compact.last
    if _parent_id
      self.parent_id = _parent_id
    end
  end

  def middle?
    parent_id.present? && depth < self.class.max_depth
  end

  module ClassMethods

    def max_depth
      self.hierarchy_class.maximum(:generations).to_i + 1
    end

  end

end

# required fields
# :parent_id

# -*- encoding : utf-8 -*-
module Blacklight::User

  # This gives us an is_blacklight_user method that can be included in
  # the containing applications models. 
  # SEE ALSO:  The /lib/blacklight/engine.rb class for how when this 
  # is injected into the hosting application through ActiveRecord::Base extend
  def self.included(base)
    if base.respond_to? :has_many
      base.send :has_many, :bookmarks, :dependent => :destroy, :as => :user
      base.send :has_many, :searches,  :dependent => :destroy, :as => :user
    end
  end

  def bookmarked_document_ids
    self.bookmarks.pluck(:document_id)
  end

  def document_is_bookmarked?(document_id)
    bookmarked_document_ids.include? document_id.to_s
  end
    
  # returns a Bookmark object if there is one for document_id, else
  # nil. 
  def existing_bookmark_for(document_id)
    self.bookmarks.where(:document_id => document_id).first
  end
end

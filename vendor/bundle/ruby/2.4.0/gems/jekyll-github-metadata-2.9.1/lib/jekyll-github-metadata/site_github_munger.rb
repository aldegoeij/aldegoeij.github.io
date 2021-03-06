require "jekyll"
require "uri"

module Jekyll
  module GitHubMetadata
    class SiteGitHubMunger
      extend Forwardable

      def_delegators :"Jekyll::GitHubMetadata", :site
      private def_delegator :"Jekyll::GitHubMetadata", :repository

      def initialize(site)
        Jekyll::GitHubMetadata.site = site
      end

      def munge!
        Jekyll::GitHubMetadata.log :debug, "Initializing..."

        # This is the good stuff.
        site.config["github"] = github_namespace

        add_title_and_description_fallbacks!
        add_url_and_baseurl_fallbacks! if should_add_url_fallbacks?
      end

      private

      def github_namespace
        case site.config["github"]
        when nil
          drop
        when Hash
          Jekyll::Utils.deep_merge_hashes(site.config["github"], drop)
        else
          site.config["github"]
        end
      end

      def drop
        @drop ||= MetadataDrop.new(GitHubMetadata.site)
      end

      # Set `site.url` and `site.baseurl` if unset.
      def add_url_and_baseurl_fallbacks!
        site.config["url"] ||= Value.new("url", proc { |_c, r| r.url_without_path })
        return unless should_set_baseurl?
        site.config["baseurl"] = Value.new("baseurl", proc { |_c, r| r.baseurl })
      end

      # Set the baseurl only if it is `nil` or `/`
      # Baseurls should never be "/". See https://bit.ly/2s1Srid
      def should_set_baseurl?
        site.config["baseurl"].nil? || site.config["baseurl"] == "/"
      end

      def add_title_and_description_fallbacks!
        site.config["title"] ||= Value.new("title", proc { |_c, r| r.name })
        site.config["description"] ||= Value.new("description", proc { |_c, r| r.tagline })
      end

      def should_add_url_fallbacks?
        Jekyll.env == "production" || Pages.page_build?
      end
    end
  end
end

Jekyll::Hooks.register :site, :after_init do |site|
  Jekyll::GitHubMetadata::SiteGitHubMunger.new(site).munge! unless Jekyll.env == "test"
end

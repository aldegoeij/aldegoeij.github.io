require "helper"

module Nokogiri
  module XML
    class TestAdditionalNamespacesInBuilderDoc < Nokogiri::TestCase
      def test_builder_namespaced_root_node_ns
        b = Nokogiri::XML::Builder.new do |x|
          x[:foo].RDF(:'xmlns:foo' => 'https://foo.io')
        end
        assert_equal 'https://foo.io', b.doc.root.namespace.href
      end
    end
  end
end

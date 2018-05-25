require "helper"

module Nokogiri
  module XML
    class TestNamespacePreservation < Nokogiri::TestCase

      def setup
        @xml = Nokogiri.XML <<-eoxml
              <xs:schema xmlns:xs="https://www.w3.org/2001/XMLSchema">
                <xs:element xmlns:quer="https://api.geotrust.com/webtrust/query"/>
                <xs:element xmlns:quer="https://api.geotrust.com/webtrust/query"/>
              </xs:schema>
            eoxml
      end

      def test_xpath   
        first = @xml.at_xpath('//xs:element', 'xs' => 'https://www.w3.org/2001/XMLSchema')
        last = @xml.at_xpath('//xs:element[last()]', 'xs' => 'https://www.w3.org/2001/XMLSchema')
        assert_equal 'https://api.geotrust.com/webtrust/query' , first.namespaces['xmlns:quer'], "Should contain quer namespace"
        assert_equal 'https://api.geotrust.com/webtrust/query' , last.namespaces['xmlns:quer'], "Should contain quer namespace"
      end

      def test_traversing   
        first = @xml.root.element_children.first
        last = @xml.root.element_children.last
        assert_equal 'https://api.geotrust.com/webtrust/query' , first.namespaces['xmlns:quer'], "Should contain quer namespace"
        assert_equal 'https://api.geotrust.com/webtrust/query' , last.namespaces['xmlns:quer'], "Should contain quer namespace"
      end
    end
  end
end

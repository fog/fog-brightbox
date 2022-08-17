require "minitest/autorun"
require "fog/brightbox"

describe Fog::Brightbox::Storage, ".escape" do
  describe "when only excluded characters are used" do
    it "escapes no letters" do
      str = ("A".."Z").to_a.join
      escaped = Fog::Brightbox::Storage.escape(str)
      assert_equal str, escaped

      str = ("a".."z").to_a.join
      escaped = Fog::Brightbox::Storage.escape(str)
      assert_equal str, escaped
    end

    it "escapes no numbers" do
      str = ("0".."9").to_a.join
      escaped = Fog::Brightbox::Storage.escape(str)
      assert_equal str, escaped
    end

    it "does not escape dashes" do
      str = "test-pattern123"
      escaped = Fog::Brightbox::Storage.escape(str)
      assert_equal str, escaped
    end

    it "does not escape dots" do
      str = "sample.demo"
      escaped = Fog::Brightbox::Storage.escape(str)
      assert_equal str, escaped
    end

    it "does not escape underscores" do
      str = "file_name"
      escaped = Fog::Brightbox::Storage.escape(str)
      assert_equal str, escaped
    end
  end

  describe "when escaped characters are included" do
    it "escapes those forward slashes" do
      str = "test/pattern/123.txt"
      escaped = Fog::Brightbox::Storage.escape(str)
      assert_equal "test%2Fpattern%2F123.txt", escaped
    end

    it "escapes those backslashes" do
      str = "test\\pattern\\123.txt"
      escaped = Fog::Brightbox::Storage.escape(str)
      assert_equal "test%5Cpattern%5C123.txt", escaped
    end
  end

  describe "when additional characters are excluded" do
    it "escapes those characters" do
      str = "test/pattern/123.txt"
      escaped = Fog::Brightbox::Storage.escape(str, "/")
      assert_equal "test/pattern/123.txt", escaped
    end
  end
end

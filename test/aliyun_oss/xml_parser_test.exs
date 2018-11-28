defmodule Aliyun.Oss.XmlParserTest do
  use ExUnit.Case
  doctest Aliyun.Oss.XmlParser

  alias Aliyun.Oss.XmlParser


  describe "parse_xml/1" do
    test "parse invalid xml" do
      assert {:error, _} = XmlParser.parse_xml("invalid xml", "root_node")
    end

    @xml """
    <?xml version="1.0" encoding="UTF-8"?>
    <ListAllMyBucketsResult>
      <Owner>
        <ID>12345</ID>
        <DisplayName>12345</DisplayName>
      </Owner>
      <Buckets>
        <Bucket>
          <CreationDate>2018-10-12T07:57:51.000Z</CreationDate>
          <ExtranetEndpoint>oss-cn-shenzhen.aliyuncs.com</ExtranetEndpoint>
          <IntranetEndpoint>oss-cn-shenzhen-internal.aliyuncs.com</IntranetEndpoint>
          <Location>oss-cn-shenzhen</Location>
          <Name>Bucket1</Name>
          <StorageClass>Standard</StorageClass>
        </Bucket>
        <Bucket>
          <CreationDate>2018-09-20T01:49:43.000Z</CreationDate>
          <ExtranetEndpoint>oss-cn-shenzhen.aliyuncs.com</ExtranetEndpoint>
          <IntranetEndpoint>oss-cn-shenzhen-internal.aliyuncs.com</IntranetEndpoint>
          <Location>oss-cn-shenzhen</Location>
          <Name>Bucket2</Name>
          <StorageClass>Standard</StorageClass>
        </Bucket>
      </Buckets>
      <Prefix></Prefix>
      <Marker></Marker>
      <MaxKeys>2</MaxKeys>
      <IsTruncated>true</IsTruncated>
      <NextMarker>Bucket2</NextMarker>
    </ListAllMyBucketsResult>
    """
    test "parse xml to map" do
      bucket1 = %{"Name" => "Bucket1", "Location" => "oss-cn-shenzhen", "StorageClass" => "Standard", "CreationDate" => "2018-10-12T07:57:51.000Z", "IntranetEndpoint" => "oss-cn-shenzhen-internal.aliyuncs.com", "ExtranetEndpoint" => "oss-cn-shenzhen.aliyuncs.com"}
      bucket2 = %{"Name" => "Bucket2", "Location" => "oss-cn-shenzhen", "StorageClass" => "Standard", "CreationDate" => "2018-09-20T01:49:43.000Z", "IntranetEndpoint" => "oss-cn-shenzhen-internal.aliyuncs.com", "ExtranetEndpoint" => "oss-cn-shenzhen.aliyuncs.com"}

      assert {:ok, %{
        "Owner" => %{"ID" => "12345", "DisplayName" => "12345"},
        "Prefix" => nil,
        "Marker" => nil,
        "MaxKeys" => 2,
        "IsTruncated" => true,
        "NextMarker" => "Bucket2",
        "Buckets" => %{ "Bucket" => [^bucket1, ^bucket2] }
      }} = XmlParser.parse_xml(@xml, "ListAllMyBucketsResult")
    end
  end
end
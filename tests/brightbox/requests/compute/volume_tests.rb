Shindo.tests("Fog::Compute[:brightbox] | volume requests", ["brightbox"]) do
  pending if Fog.mocking?
  image_id = Brightbox::Compute::TestSupport.image_id

  tests("success") do
    create_options = { image: image_id }

    tests("#create_volume(#{create_options.inspect})") do
      result = Fog::Compute[:brightbox].create_volume(create_options)
      @volume_id = result["id"]
      data_matches_schema(Brightbox::Compute::Formats::Full::VOLUME, :allow_extra_keys => true) { result }
    end

    tests("#list_volumes") do
      result = Fog::Compute[:brightbox].list_volumes
      data_matches_schema(Brightbox::Compute::Formats::Collection::VOLUMES, :allow_extra_keys => true) { result }

      test("#{@volume_id} is listed") do
        result.any? do |volume|
          volume["id"] == @volume_id
        end
      end
    end

    tests("#get_volume('#{@volume_id}')") do
      result = Fog::Compute[:brightbox].get_volume(@volume_id)
      data_matches_schema(Brightbox::Compute::Formats::Full::VOLUME, :allow_extra_keys => true) { result }
    end

    update_options = {
      name: "New name"
    }
    tests("#update_volume('#{@volume_id}', ...)") do
      result = Fog::Compute[:brightbox].update_volume(@volume_id, update_options)
      data_matches_schema(Brightbox::Compute::Formats::Full::VOLUME, :allow_extra_keys => true) { result }

      test("name has updated") { result["name"] == "New name" }
    end

    Fog::Compute[:brightbox].volumes.get(@volume_id).wait_for { ready? }

    tests("#delete_volume('#{@volume_id}')") do
      result = Fog::Compute[:brightbox].delete_volume(@volume_id)
      data_matches_schema(Brightbox::Compute::Formats::Full::VOLUME, :allow_extra_keys => true) { result }
    end
  end

  tests("failure") do
    tests("create_volume without options").raises(ArgumentError) do
      Fog::Compute[:brightbox].create_volume
    end

    tests("get_volume with invalid ID").raises(Excon::Errors::NotFound) do
      Fog::Compute[:brightbox].get_volume("vol-00000")
    end
  end
end

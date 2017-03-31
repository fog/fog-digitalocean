def collection_tests(collection, params = {}, mocks_implemented = true)
  def fqdn(params)
    @fqdn ||= params[:fqdn] ? params[:fqdn] : params[:name]
  end

  tests('success') do

    tests("#new(#{params.inspect})").succeeds do
      pending if Fog.mocking? && !mocks_implemented
      coll = collection.new(params)
      @collection_size = coll.collection.size
      true
    end

    tests("#create(#{params.inspect})").succeeds do
      pending if Fog.mocking? && !mocks_implemented
      @instance = collection.create(params)
      @instance.name.eql?(fqdn(params)) || @instance.name.eql?('@')
    end

    tests("#all").returns(@collection_size+1) do
      pending if Fog.mocking? && !mocks_implemented
      coll = collection.all
      coll.size
    end

    if !Fog.mocking? || mocks_implemented
      @identity = @instance.identity
    end

    tests("#get(#{@identity})").returns(fqdn(params)) do
      pending if Fog.mocking? && !mocks_implemented
      record = collection.get(@identity)
      record.name
    end

    tests('Enumerable') do
      pending if Fog.mocking? && !mocks_implemented

      methods = [
        'all?', 'any?', 'find',  'detect', 'collect', 'map',
        'find_index', 'flat_map', 'collect_concat', 'group_by',
        'none?', 'one?'
      ]

      # JRuby 1.7.5+ issue causes a SystemStackError: stack level too deep
      # https://github.com/jruby/jruby/issues/1265
      if RUBY_PLATFORM == "java" and JRUBY_VERSION =~ /1\.7\.[5-8]/
        methods.delete('all?')
      end

      methods.each do |enum_method|
        if collection.respond_to?(enum_method)
          tests("##{enum_method}").succeeds do
            block_called = false
            collection.send(enum_method) {|x| block_called = true }
            block_called
          end
        end
      end

      [
        'max_by','min_by'
      ].each do |enum_method|
        if collection.respond_to?(enum_method)
          tests("##{enum_method}").succeeds do
            block_called = false
            collection.send(enum_method) {|x| block_called = true; 0 }
            block_called
          end
        end

      end

    end

    if block_given?
      yield(@instance)
    end

    if !Fog.mocking? || mocks_implemented
      @instance.destroy
    end
  end

  tests('failure') do

    if !Fog.mocking? || mocks_implemented
      @identity = @identity.to_s
      @identity = @identity.gsub(/[a-zA-Z]/) { Fog::Mock.random_letters(1) }
      @identity = @identity.gsub(/\d/)       { Fog::Mock.random_numbers(1) }
      @identity
    end

    tests("#get('#{@identity}')").returns(nil) do
      pending if Fog.mocking? && !mocks_implemented
      collection.get(@identity)
    end

  end
end

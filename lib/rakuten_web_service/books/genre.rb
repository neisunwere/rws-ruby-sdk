require 'rakuten_web_service/resource'

module RakutenWebService
  module Books
    class Genre < Resource
      set_resource_name 'books_genre'

      endpoint 'https://app.rakuten.co.jp/services/api/BooksGenre/Search/20121128'

      set_parser do |response|
        current = response['current']
        if children = response['children']
          children = children.map { |child| Books::Genre.new(child['child']) }
          current.merge!('children' => children)
        end
        if parents = response['parents']
          parents = parents.map { |parent| Books::Genre.new(parent['parent']) }
          current.merge!('parents' => parents)
        end

        genre = Books::Genre.new(current)
        [genre]
      end

      attribute :booksGenreId, :booksGenreName, :genreLevel

      def self.root
        new('000')
      end

      def self.new(params)
        case params
        when String
          Genre[params] ||= self.search(:booksGenreId => params).first
        when Hash
          super
        else
          raise ArgumentError, 'Invalid parameter for initializing Books::Genre'
        end
      end

      def self.[](id)
        repository[id]
      end

      def self.[]=(id, genre)
        repository[id] = genre
      end

      def children
        @params['children'] ||= RWS::Books::Genre.search(:booksGenreId => self.id).first.children
      end

      def search(params={})
        params = params.merge(:booksGenreId => self.id)

        case self.id
        when /^001/
          RWS::Books::Book.search(params)
        when /^002/
          RWS::Books::CD.search(params)
        when /^003/
          RWS::Books::DVD.search(params)
        when /^004/
          RWS::Books::Software.search(params)
        when /^005/
          RWS::Books::ForeignBook.search(params)
        when /^006/
          RWS::Books::Game.search(params)
        when /^007/
          RWS::Books::Magazine.search(params)
        end
      end

      private
      def self.repository
        @repository ||= {}
      end
    end
  end
end

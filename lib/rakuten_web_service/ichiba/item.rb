module RakutenWebService
  module Ichiba
    class Item < Resource
      class << self
        def parse_response(response)
          response['Items'].map { |item| Item.new(item['Item']) }
        end

        def ranking(options)
          RakutenWebService::Ichiba::RankingItem.search(options)
        end
      end
      
      endpoint 'https://app.rakuten.co.jp/services/api/IchibaItem/Search/20130805'

      attribute :itemName, :catchcopy, :itemCode, :itemPrice,
        :itemCaption, :itemUrl, :affiliateUrl, :imageFlag,
        :smallImageUrls, :mediumImageUrls,
        :availability, :taxFlag, 
        :postageFlag, :creditCardFlag,
        :shopOfTheYearFlag,
        :shipOverseasFlag, :shipOverseasArea,
        :asurakuFlag, :asurakuClosingTime, :asurakuArea,
        :affiliateRate,
        :startTime, :endTime,
        :reviewCount, :reviewAverage,
        :pointRate, :pointRateStartTime, :pointRateEndTime,
        :shopName, :shopCode, :shopUrl,
        :genreId

      def genre
        Genre[self.genre_id]
      end

      def shop
        Shop.new({
          'shopName' => self.shop_name,
          'shopCode' => self.shop_code,
          'shopUrl' => self.shop_url
        })
      end
    end
  end
end

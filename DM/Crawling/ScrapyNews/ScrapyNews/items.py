import scrapy

class ScrapynewsItem(scrapy.Item):
    journal = scrapy.Field()
    date = scrapy.Field()
    title = scrapy.Field()
    url = scrapy.Field()
    content = scrapy.Field()
    summary = scrapy.Field()
    pass


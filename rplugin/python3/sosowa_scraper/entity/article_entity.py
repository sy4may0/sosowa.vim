####
# article_entity
# Sosowa article entity class.
#
# @author sy4may0
# @version 1.0
#
import unicodedata
import math

class article_entity():
    __article_data = None

    # Constructor
    #
    def __init__(self):
        self.__article_data = dict()
        self.__article_data['p_belong'] = None
        self.__article_data['id'] = None
        self.__article_data['title'] = None
        self.__article_data['author'] = None
        self.__article_data['d_upload'] = None
        self.__article_data['c_page'] = None
        self.__article_data['size'] = None
        self.__article_data['c_evaluation'] = None
        self.__article_data['c_comment'] = None
        self.__article_data['points'] = None
        self.__article_data['rate'] = None
        self.__article_data['tag'] = None
        self.__article_data['content'] = None
        self.__article_data['afterword'] = None
        self.__article_data['is_load_content'] = False

    # set_article()
    # Set article data.
    #
    # @param key : following keys.
    #     title, author, d_upload, c_page, size, 
    #     c_evalution, c_comment, points, rate, tag
    # @param value : Value for key.
    #
    def set_article(self, key, value):
        if key in self.__article_data:
            self.__article_data[key] = value
        else:
            raise KeyNotFoundExeption(key)

    # get_article()
    # Get article data.
    #
    # @param key : following keys.
    #     title, author, d_upload, c_page, size, 
    #     c_evalution, c_comment, points, rate, tag
    #
    def get_article(self, key):
        if key in self.__article_data:
            return self.__article_data[key]
        else:
            raise KeyNotFoundException(key)


    # detail_tostring()
    # shaping detail text data.
    #
    def title_tostring(self):
        result = []

        result.append(self.__article_data['id'])
        result.append('::')

        result.append(self.__article_data['title'])

        return "".join(result)

    def detail_tostring(self):
        result = []

        result.append('|AUTHOR:')
        author = self.__article_data['author']
        pad_author = self.__ljust_kana(author, 16)
        result.append(pad_author)

        result.append(" UPLOAD:")
        result.append(self.__article_data['d_upload'])

        result.append(" SIZE:")
        result.append(self.__article_data['size'].ljust(10, " "))

        result.append(" EVAL:")
        result.append(self.__article_data['c_evaluation'].ljust(10, " "))

        result.append(" COMMENT:")
        result.append(self.__article_data['c_comment'].ljust(5, " "))

        result.append(" POINT:")
        result.append(self.__article_data['points'].ljust(7, " "))

        result.append(" RATE:")
        result.append(self.__article_data['rate'].ljust(7, " "))

        return "".join(result)

    def tag_tostring(self):
        result = []
        result.append("|TAG: ")
        if self.__article_data['tag'] is not None:
            for t in self.__article_data['tag']:
                result.append(t)
                result.append(" ")
            
        return "".join(result)

    # show_content()
    # show shaping content data.
    #
    def content_array(self):
        result = []
        result.append("[TITLE]")
        result.append(self.__article_data['title'])
        result.append("[CONTENT]")
        result.extend(self.__article_data['content'])
        result.append("[AFTERWORD]")
        result.extend(self.__article_data['afterword'])
        
        return result

    
    def __ljust_kana(self, string, size, pad = " "):
        all_c = len(string)
        b2_c = self.__count_2byte(string)
        b1_c = all_c - b2_c

        space = size - (b2_c * 2 + b1_c)
        if space > 0:
            string += pad * space
        else:
            string = string[:math.floor(size/2)]

        return string

        
    def __count_2byte(self, string):
        n = 0
        for c in string:
            wide_chars = u"WFA"
            eaw = unicodedata.east_asian_width(c)
            if wide_chars.find(eaw) > -1:
                n += 1

        return n

####
# KeyNotFoundException
# This exception thrown at article data key has not found.
class KeyNotFoundException(Exception):
    def __init__(self, key):
        self.key = key
        self.message = "Article data key [" + self.key + "] is not found."

    def get_key():
        return self.key

    def get_message():
        return self.message


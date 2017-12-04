import queue
import threading

####
# sosowa_cache
# Store the sosowa page and article with cache.
# 
# @author sy4may0
# @version 1.0
class sosowa_cache():
    __lock = threading.Lock()
    __page_lock = threading.Lock()
    __instance = None

    __page_queue = None
    __page_dict = None

    # Constructor(singleton)
    # 
    def __init__(self, page_cache_size):
        if self.__page_queue is None:
            self.__page_queue = queue.Queue(page_cache_size)

        if self.__page_dict is None:
            self.__page_dict = dict()

    # instance created check.
    #
    def __new__(cls, *args, **kwargs):
        with cls.__lock:
            if cls.__instance is None:
                cls.__instance = super(sosowa_cache, cls).__new__(cls)
        return cls.__instance

    # set_page()
    # Insert sosowa page data to cache.
    # This cache is run as FIFO.
    #
    # @param page : Insert page data.
    # @param page_id : Key of page.
    #
    def set_page(self, page, page_id):
        with self.__page_lock:
            if page_id not in self.__page_dict:
                try:
                    self.__page_queue.put_nowait(page_id)
                except queue.Full:
                    tmp = self.__page_queue.get_nowait()
                    del self.__page_dict[tmp]
                    del tmp
    
                    self.__page_queue.put_nowait(page_id)
    
                self.__page_dict[page_id] = page

    # get_page()
    # Get sosowa page data.
    # If no cache hit, return None.
    #
    # @param page_id : Key of page
    def get_page(self, page_id):
        if page_id in self.__page_dict:
            return self.__page_dict[page_id]
        else:
            return None

    # clear_page_cache()
    # 
    def clear_page_cache(self):
        self.__page_queue.queue.clear()
        self.__page_dict.clear()

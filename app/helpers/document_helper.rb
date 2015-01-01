module DocumentHelper
    def self.item_info_value(resp, type, &block)
        value = nil
        info  = resp['ItemInfos'].find{|info| info['type']==type }
        value = info['value'] if info
        value = yield value if block_given? and !value.nil?
        value
    end
end

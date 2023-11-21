# Chris McLaughlin - V00912353
module FuncSet
    def |(other) # union
        self.class.new(entries + other.entries) { |x, y| cmp(x, y) }
    end
    def &(other) # intersect
        common = self.map { |x| other.find { |y| self.cmp(x, y) == 0 } }
        puts("COMMON: "+common.to_s)
        self.class.new(common) { |x, y| cmp(x, y) }
    end
end
    
class MySet
    def initialize(in_array=[], &in_cmp)
        @arr_internal = in_array
        if in_cmp
            @cmp_proc = in_cmp
        else
            @cmp_proc = nil
        end
        
        # Handle poorly written intersect method in FuncSet by filtering nils out from in_lists with mixed nils and non-nils
        if (not ((@arr_internal.all? {|x| not(x.nil?)}) or (@arr_internal.all? {|x| x.nil?}))) # If NOT (all elements != nil or all elements == nil) --> ie. if theres a mix of nills and non-nills
            # Then we need to filter out nils
            @arr_internal.select! {|element| not(element.nil?)}
        end
        # And now we're good to go

        seriesify()
    end

    def cmp(e1, e2)
        if @cmp_proc
            @cmp_proc.call(e1, e2)
        else
            e1 <=> e2
        end
    end

    def seriesify()
        @arr_internal.uniq!
        @arr_internal.sort! {|a, b| cmp(a,b)}
    end

    def to_s()
        @arr_internal.to_s
    end

    def insert(in_el)
        if in_el
            @arr_internal.append(in_el)
            seriesify()
        end
    end

    include Enumerable
    
    def each(&blk_in)
        @arr_internal.each(&blk_in)
    end

    include FuncSet
    def entries()
        @arr_internal
    end
end

# 1.6 - The map that we got for free from Enumerable is safe to use if the issues that arise from it's use are specifically handled, as with in the above code with the case of & in FuncSet, where elements can map to nil, which can cause comparison failure if not specially filtered out of the result. Because of this, care should be excercised when using map. & specifically in FuncSet should probably have been written differently, and avoided the use of map.
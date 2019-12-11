--数据初始化
datas = {
    {
        name = "苹果",
        height = 140
    },
    {
        name = "葡萄",
        height = 100
    },
    {
        name = "西瓜",
        height = 130
    },
    {
        name = "草莓",
        height = 118
    },
    {
        name = "菠萝",
        height = 190
    },
    {
        name = "香蕉",
        height = 100
    },
    {
        name = "芒果",
        height = 120
    },
    {
        name = "猕猴桃",
        height = 150
    },
    {
        name = "橘子",
        height = 180
    },
    {
        name = "哈密瓜",
        height = 200
    },
}
W = System:screenSize():width()
--初始化WaterfallView
local function initWaterfallView()

    collectionView = WaterfallView(true, true)
            :width(MeasurementType.MATCH_PARENT)
            :height(MeasurementType.MATCH_PARENT)
            :bgColor(Color(255, 255, 0, 0.5))
            :useAllSpanForLoading(true)--加载动画是否占用一行，默认不占用
            :showScrollIndicator(true)--显示滑动指示器

    --下拉刷新事件回调
    collectionView:setRefreshingCallback(
            function()
                print("开始刷新")
                System:setTimeOut(function()
                    --2秒后结束刷新
                    print("结束刷新了")
                    collectionView:stopRefreshing()
                end, 2)
            end)
    --上拉加载事件回调
    collectionView:setLoadingCallback(function()
        print("开始加载")
        System:setTimeOut(function()
            --2秒后结束加载
            print("结束加载")
            collectionView:stopLoading()
            --已加载全部
            collectionView:noMoreData()
        end, 2)

    end)
    --开始滑动的回调事件
    collectionView:setScrollBeginCallback(function()
        print("开始滑动")
    end)
    --滑动中的回调事件
    collectionView:setScrollingCallback(function()
        --print("滑动中")
    end)
    --结束滑动的回调事件
    collectionView:setScrollEndCallback(function()
        print("结束滑动")
    end)
    return collectionView
end
--初始化WaterfallLayout
local function initWaterfallLayout()

    collectionLayout = WaterfallLayout()
    collectionLayout:itemSpacing(5)--间隔大小
                    :lineSpacing(5)
                    :spanCount(2)
    return collectionLayout
end

--初始化WaterfallAdapter
local function initAdapter()

    adapter = WaterfallAdapter()

    adapter:sectionCount(function()
        return 1
    end)

    -----------------------------设置header----------------------------------
    adapter:initHeader(function(header)
        header.contentView:bgColor(Color(0, 0, 255, 0.3))
        header.textLabel = Label():setGravity(Gravity.CENTER):width(MeasurementType.MATCH_PARENT):height(MeasurementType.MATCH_PARENT):lines(0):textAlign(TextAlign.CENTER)
        header.contentView:addView(header.textLabel)
    end)

    adapter:fillHeaderData(function(header, section, row)
        header.textLabel:text('我是头布局')
    end)

    adapter:headerValid(function(section)
        return true
    end)
    adapter:heightForHeader(function(section)
        return 100
    end)
    -----------------------------设置子view个数-------------------------------
    adapter:rowCount(function(section)
        if datas == nill or #datas == 0 then
            return 0;
        else
            return #datas;
        end
    end)
    --------------------------------设置cell高-------------------------------
    ----设置对应子view的高
    adapter:heightForCell(function(section, row)
        return datas[row].height
    end)
    -------------------------------子view类型--------------------------------
    --返回当前位置子view的类型标识
    adapter:reuseId(function(section, row)
        return "CellId"
    end)
    -------------------------------创建子view--------------------------------
    adapter:initCellByReuseId("CellId", function(cell)

        cell.userView = LinearLayout(LinearType.VERTICAL)
                :setGravity(Gravity.CENTER)
        --头像
        cell.imageView = ImageView():width(50):height(50):cornerRadius(45)
                                    :priority(1):bgColor(Color(255, 0, 0, 0.5))
                                    :setGravity(Gravity.CENTER)
        cell.userView:addView(cell.imageView)
        --昵称
        cell.nameLabel = Label():fontSize(14):textColor(Color(0, 0, 0, 1))
                                :text("昵称"):setGravity(Gravity.CENTER)
                                :marginTop(5)
        cell.contentView:bgColor(Color(255, 255, 255, 1))
            :cornerRadius(5)
        cell.userView:addView(cell.nameLabel)
        cell.contentView:addView(cell.userView)
    end)
    --------------------------将子view与数据进行绑定赋值-------------------------
    adapter:fillCellDataByReuseId("CellId", function(cell, section, row)
        cell.nameLabel:text(datas[row].name)
    end)
    --cell点击事件
    adapter:selectedRowByReuseId("CellId", function(cell, section, row)
        print("点击了cell", row .. datas[row].name)
    end)
    --cell被滑出屏幕可见区域的回调
    adapter:cellDidDisappear(function(cell, section, row)
        print("cell不见了", row)
    end)
    --cell出现在屏幕可见区域的回调
    adapter:cellWillAppear(function(cell, section, row)
        print("cell出现了", row)
    end)
    --头布局header被滑出屏幕可见区域的回调
    adapter:headerDidDisappear(function()
        print("头布局header不见了")
    end)
    --头布局header出现在屏幕可见区域的回调
    adapter:headerWillAppear(function()
        print("头布局header出现了")
    end)
    return adapter
end
--初始化WaterfallView
collectionView = initWaterfallView()
--初始化WaterfallLayout
collectionLayout = initWaterfallLayout()
-- 初始化WaterfallAdapter
adapter = initAdapter()
collectionView:layout(collectionLayout)
collectionView:adapter(adapter)
window:addView(collectionView)
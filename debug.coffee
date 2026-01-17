# cache-viewer.widget/index.coffee - 完整数据查看版

command: "echo '缓存查看器'"

refreshFrequency: 5000  # 5秒刷新一次

render: () -> """
<div id="cache-viewer">
  <div class="header">
    <h3>📚 名言插件数据查看器</h3>
    <div class="controls">
      <button id="refresh-btn" title="刷新数据">🔄</button>
      <button id="collapse-btn" title="折叠/展开">📋</button>
    </div>
  </div>
  
  <div class="stats-bar" id="stats-bar">
    加载中...
  </div>
  
  <div class="data-container" id="data-container">
    <div class="loading" id="loading">正在加载数据...</div>
    
    <div class="quotes-section" id="quotes-section" style="display:none;">
      <div class="section-header">
        <h4>📖 所有名言数据 (共 <span id="quotes-count">0</span> 条)</h4>
        <input type="text" id="search-box" placeholder="搜索名言或作者..." />
      </div>
      <div class="quotes-list" id="quotes-list">
        <!-- 名言数据将在这里显示 -->
      </div>
      <div class="pagination" id="pagination">
        <button id="prev-page">⬅️ 上一页</button>
        <span id="page-info">第 1 页 / 共 1 页</span>
        <button id="next-page">下一页 ➡️</button>
      </div>
    </div>
    
    <div class="config-section" id="config-section" style="display:none;">
      <h4>⚙️ 插件配置</h4>
      <div id="config-data"></div>
    </div>
  </div>
</div>
"""

style: """
  /* 主容器 */
  #cache-viewer {
    position: fixed;
    top: 50px;
    right: 20px;
    background: rgba(20, 20, 30, 0.95);
    color: #e0e0e0;
    padding: 15px;
    border-radius: 12px;
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
    font-size: 13px;
    width: 600px;
    max-height: 80vh;
    overflow: hidden;
    z-index: 2147483647;
    border: 1px solid rgba(255, 255, 255, 0.1);
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
    display: flex;
    flex-direction: column;
  }
  
  /* 标题栏 */
  .header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 15px;
    padding-bottom: 10px;
    border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  }
  
  .header h3 {
    margin: 0;
    font-size: 14px;
    font-weight: 600;
    color: #ffffff;
  }
  
  .controls button {
    background: rgba(255, 255, 255, 0.1);
    border: none;
    color: white;
    width: 30px;
    height: 30px;
    border-radius: 6px;
    cursor: pointer;
    margin-left: 5px;
    font-size: 14px;
  }
  
  .controls button:hover {
    background: rgba(255, 255, 255, 0.2);
  }
  
  /* 统计栏 */
  .stats-bar {
    background: rgba(0, 100, 255, 0.1);
    padding: 8px 12px;
    border-radius: 6px;
    margin-bottom: 15px;
    font-size: 12px;
    color: #4da6ff;
    border: 1px solid rgba(0, 100, 255, 0.2);
  }
  
  /* 数据容器 */
  .data-container {
    flex: 1;
    overflow: hidden;
    display: flex;
    flex-direction: column;
  }
  
  /* 加载状态 */
  .loading {
    text-align: center;
    padding: 30px;
    color: rgba(255, 255, 255, 0.5);
  }
  
  /* 名言区域 */
  .quotes-section {
    flex: 1;
    display: flex;
    flex-direction: column;
    overflow: hidden;
  }
  
  .section-header {
    margin-bottom: 15px;
  }
  
  .section-header h4 {
    margin: 0 0 10px 0;
    font-size: 13px;
    color: #ffffff;
  }
  
  #search-box {
    width: 100%;
    padding: 8px 12px;
    background: rgba(255, 255, 255, 0.1);
    border: 1px solid rgba(255, 255, 255, 0.2);
    border-radius: 6px;
    color: white;
    font-size: 12px;
  }
  
  #search-box::placeholder {
    color: rgba(255, 255, 255, 0.4);
  }
  
  /* 名言列表 */
  .quotes-list {
    flex: 1;
    overflow-y: auto;
    background: rgba(0, 0, 0, 0.2);
    border-radius: 8px;
    padding: 10px;
    margin-bottom: 15px;
  }
  
  .quote-item {
    background: rgba(255, 255, 255, 0.05);
    border-left: 3px solid #007AFF;
    padding: 12px;
    margin-bottom: 10px;
    border-radius: 6px;
    transition: all 0.2s;
  }
  
  .quote-item:hover {
    background: rgba(255, 255, 255, 0.08);
    transform: translateX(2px);
  }
  
  .quote-text {
    font-size: 13px;
    line-height: 1.5;
    color: #ffffff;
    margin-bottom: 6px;
  }
  
  .quote-meta {
    display: flex;
    justify-content: space-between;
    font-size: 11px;
    color: rgba(255, 255, 255, 0.6);
  }
  
  .quote-author {
    font-style: italic;
  }
  
  .quote-category {
    background: rgba(0, 122, 255, 0.2);
    padding: 2px 6px;
    border-radius: 3px;
  }
  
  /* 分页控制 */
  .pagination {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 10px;
    background: rgba(255, 255, 255, 0.05);
    border-radius: 6px;
  }
  
  .pagination button {
    background: rgba(0, 122, 255, 0.3);
    border: none;
    color: white;
    padding: 6px 12px;
    border-radius: 4px;
    cursor: pointer;
    font-size: 11px;
  }
  
  .pagination button:hover:not(:disabled) {
    background: rgba(0, 122, 255, 0.5);
  }
  
  .pagination button:disabled {
    opacity: 0.3;
    cursor: not-allowed;
  }
  
  #page-info {
    font-size: 11px;
    color: rgba(255, 255, 255, 0.7);
  }
  
  /* 配置区域 */
  .config-section {
    background: rgba(255, 255, 255, 0.05);
    padding: 15px;
    border-radius: 8px;
    margin-top: 15px;
  }
  
  .config-section h4 {
    margin: 0 0 10px 0;
    font-size: 13px;
    color: #ffffff;
  }
  
  .config-item {
    margin-bottom: 8px;
    font-size: 12px;
  }
  
  .config-label {
    color: rgba(255, 255, 255, 0.7);
    margin-right: 10px;
  }
  
  .config-value {
    color: #4da6ff;
  }
  
  /* 滚动条样式 */
  .quotes-list::-webkit-scrollbar {
    width: 6px;
  }
  
  .quotes-list::-webkit-scrollbar-track {
    background: rgba(255, 255, 255, 0.05);
    border-radius: 3px;
  }
  
  .quotes-list::-webkit-scrollbar-thumb {
    background: rgba(255, 255, 255, 0.2);
    border-radius: 3px;
  }
  
  .quotes-list::-webkit-scrollbar-thumb:hover {
    background: rgba(255, 255, 255, 0.3);
  }
"""

afterRender: (domElement) ->
  @domElement = domElement
  @currentPage = 1
  @itemsPerPage = 20
  @filteredQuotes = []
  @allQuotes = []
  
  # 绑定事件
  $(domElement).find('#refresh-btn').on 'click', => @loadData()
  $(domElement).find('#collapse-btn').on 'click', => @toggleCollapse()
  $(domElement).find('#prev-page').on 'click', => @changePage(-1)
  $(domElement).find('#next-page').on 'click', => @changePage(1)
  $(domElement).find('#search-box').on 'input', (e) => @filterQuotes(e.target.value)
  
  # 初始加载数据
  @loadData()

loadData: ->
  # 显示加载状态
  $(@domElement).find('#loading').show()
  $(@domElement).find('#quotes-section').hide()
  $(@domElement).find('#config-section').hide()
  
  try
    # 获取缓存数据
    cachedQuotes = localStorage.getItem('cached-quotes')
    selectedCats = localStorage.getItem('selected-categories')
    autoUpdate = localStorage.getItem('auto-update-data')
    lastUpdated = localStorage.getItem('quotes-last-updated')
    
    # 处理名言数据
    if cachedQuotes
      @allQuotes = JSON.parse(cachedQuotes)
      @filteredQuotes = @allQuotes.slice()  # 初始显示所有数据
      @currentPage = 1  # 重置到第一页
      
      # 更新统计信息
      statsText = """
      数据状态：共 #{@allQuotes.length} 条名言 | 
      最后更新：#{if lastUpdated then new Date(parseInt(lastUpdated)).toLocaleString() else '从未更新'} | 
      数据来源：#{if @allQuotes.length > 0 then '缓存数据' else '无数据'}
      """
      $(@domElement).find('#stats-bar').text(statsText)
      
      # 显示数据
      @displayQuotes()
      @updatePagination()
      
      $(@domElement).find('#loading').hide()
      $(@domElement).find('#quotes-section').show()
      $(@domElement).find('#quotes-count').text(@allQuotes.length)
    else
      $(@domElement).find('#loading').html('❌ 未找到缓存数据，请先在名言插件中更新数据')
    
    # 显示配置数据
    configHtml = ''
    if selectedCats
      categories = JSON.parse(selectedCats)
      categoryNames = {
        'a': '动画', 'b': '漫画', 'c': '游戏', 'd': '文学',
        'e': '原创', 'f': '网络', 'g': '其他', 'h': '影视',
        'i': '诗词', 'j': '网易云', 'k': '哲学', 'l': '抖机灵'
      }
      categoryDisplay = categories.map((cat) -> categoryNames[cat] || cat).join(', ')
      configHtml += """
        <div class="config-item">
          <span class="config-label">选中分类：</span>
          <span class="config-value">#{categoryDisplay} (#{categories.length}个)</span>
        </div>
      """
    
    if autoUpdate
      autoUpdateValue = JSON.parse(autoUpdate)
      configHtml += """
        <div class="config-item">
          <span class="config-label">自动更新：</span>
          <span class="config-value">#{if autoUpdateValue then '开启' else '关闭'}</span>
        </div>
      """
    
    if configHtml
      $(@domElement).find('#config-data').html(configHtml)
      $(@domElement).find('#config-section').show()
    
  catch error
    $(@domElement).find('#loading').html("❌ 数据加载错误：#{error.message}")
    console.error("数据加载错误:", error)

displayQuotes: ->
  quotesList = $(@domElement).find('#quotes-list')
  quotesList.empty()
  
  if @filteredQuotes.length == 0
    quotesList.html('<div class="no-data">未找到匹配的名言数据</div>')
    return
  
  # 计算当前页的数据范围
  startIndex = (@currentPage - 1) * @itemsPerPage
  endIndex = Math.min(startIndex + @itemsPerPage, @filteredQuotes.length)
  currentQuotes = @filteredQuotes.slice(startIndex, endIndex)
  
  # 显示当前页的名言
  for quote, index in currentQuotes
    itemNumber = startIndex + index + 1
    quoteHtml = """
      <div class="quote-item" data-index="#{itemNumber}">
        <div class="quote-text">#{itemNumber}. #{@escapeHtml(quote.text)}</div>
        <div class="quote-meta">
          <span class="quote-author">作者：#{@escapeHtml(quote.author)}</span>
          <span class="quote-category">#{@escapeHtml(quote.category || '未分类')}</span>
        </div>
      </div>
    """
    quotesList.append(quoteHtml)

updatePagination: ->
  totalPages = Math.ceil(@filteredQuotes.length / @itemsPerPage)
  totalPages = Math.max(totalPages, 1)  # 至少1页
  
  $(@domElement).find('#page-info').text("第 #{@currentPage} 页 / 共 #{totalPages} 页")
  
  # 更新按钮状态
  $(@domElement).find('#prev-page').prop('disabled', @currentPage <= 1)
  $(@domElement).find('#next-page').prop('disabled', @currentPage >= totalPages)

changePage: (direction) ->
  totalPages = Math.ceil(@filteredQuotes.length / @itemsPerPage)
  newPage = @currentPage + direction
  
  if newPage >= 1 and newPage <= totalPages
    @currentPage = newPage
    @displayQuotes()
    @updatePagination()
    
    # 滚动到顶部
    $(@domElement).find('.quotes-list').scrollTop(0)

filterQuotes: (searchTerm) ->
  if not searchTerm or searchTerm.trim() == ''
    @filteredQuotes = @allQuotes.slice()
  else
    term = searchTerm.toLowerCase().trim()
    @filteredQuotes = @allQuotes.filter (quote) ->
      (quote.text && quote.text.toLowerCase().includes(term)) ||
      (quote.author && quote.author.toLowerCase().includes(term)) ||
      (quote.category && quote.category.toLowerCase().includes(term))
  
  @currentPage = 1
  @displayQuotes()
  @updatePagination()

toggleCollapse: ->
  quotesSection = $(@domElement).find('#quotes-section')
  configSection = $(@domElement).find('#config-section')
  
  if quotesSection.is(':visible')
    quotesSection.hide()
    configSection.hide()
    $(@domElement).find('#collapse-btn').text('📖')
  else
    quotesSection.show()
    configSection.show()
    $(@domElement).find('#collapse-btn').text('📋')

escapeHtml: (text) ->
  return '' unless text
  text.toString()
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#039;")

# 定期刷新数据
update: (output, domElement) ->
  # 可以在这里添加自动刷新逻辑，但当前由手动刷新按钮控制
  null

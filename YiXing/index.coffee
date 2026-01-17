# YiYan.Quote/index.coffee - 增加关于页面版

# ====== 基本配置 ========
refreshFrequency: 1000

# ====== 数据源配置 ======
DATA_SOURCES =
  'a': 'https://raw.githubusercontent.com/ymzhen/Hitokoto/refs/heads/master/sentences/a.json'
  'b': 'https://raw.githubusercontent.com/ymzhen/Hitokoto/refs/heads/master/sentences/b.json'
  'c': 'https://raw.githubusercontent.com/ymzhen/Hitokoto/refs/heads/master/sentences/c.json'
  'd': 'https://raw.githubusercontent.com/ymzhen/Hitokoto/refs/heads/master/sentences/d.json'
  'e': 'https://raw.githubusercontent.com/ymzhen/Hitokoto/refs/heads/master/sentences/e.json'
  'f': 'https://raw.githubusercontent.com/ymzhen/Hitokoto/refs/heads/master/sentences/f.json'
  'g': 'https://raw.githubusercontent.com/ymzhen/Hitokoto/refs/heads/master/sentences/g.json'
  'h': 'https://raw.githubusercontent.com/ymzhen/Hitokoto/refs/heads/master/sentences/h.json'
  'i': 'https://raw.githubusercontent.com/ymzhen/Hitokoto/refs/heads/master/sentences/i.json'
  'j': 'https://raw.githubusercontent.com/ymzhen/Hitokoto/refs/heads/master/sentences/j.json'
  'k': 'https://raw.githubusercontent.com/ymzhen/Hitokoto/refs/heads/master/sentences/k.json'
  'l': 'https://raw.githubusercontent.com/ymzhen/Hitokoto/refs/heads/master/sentences/l.json'

# ====== 默认配置 ======
DEFAULT_CONFIG =
  switchInterval: 10000     # 10秒
  showTimer: true           # 是否显示计时器
  showBackground: true      # 是否显示背景
  categories: ['b', 'c']    # 默认选择分类
  # 动画a,漫画b,游戏c,文学d,原创e,网络f,其他g,影视h,诗词i,网易j,哲学k,抖机灵l

# ====== 全局变量 ======
lastUpdate: 0
currentQuoteIndex: 0
isUpdatingData: false
config: null

# ====== 主代码 =======

render: ->
  """
  <div class="widget-container" id="widget-container">
    <div class="quote-container">
      <div class="quote-content" id="quote-content">
        <div class="quote-inner" id="quote-inner">
          <img src="YiYan.Quote/YiYan/YiYan.png" class="quote-icon" id="settings-icon-btn"></img>
          <p class="quote-text" id="quote-text">加载中...</p>
          <div class="quote-author" id="quote-author"></div>
          <div class="timer-row" id="timer-row">
            <div class="timer-info" id="timer-info"></div>
          </div>
        </div>
      </div>
    </div>
    
    <div class="config-panel" id="config-panel">
      <div class="config-tabs">
        <button class="tab-btn active" data-tab="categories">📚 分类</button>
        <button class="tab-btn" data-tab="settings">⚙️ 设置</button>
        <button class="tab-btn" data-tab="about">ℹ️ 关于</button>
      </div>
      
      <div class="tab-content active" id="tab-categories">
        <div class="status-title" id="category-status-title">
          <div class="status-message" id="config-status"></div>
        </div>
        
        <div class="categories-list">
          <div class="category-column">
            <div class="category-item"><label><input type="checkbox" class="cat-checkbox" value="a" id="cat-a">动画</label></div>
            <div class="category-item"><label><input type="checkbox" class="cat-checkbox" value="b" id="cat-b">漫画</label></div>
            <div class="category-item"><label><input type="checkbox" class="cat-checkbox" value="c" id="cat-c">游戏</label></div>
            <div class="category-item"><label><input type="checkbox" class="cat-checkbox" value="d" id="cat-d">文学</label></div>
            <div class="category-item"><label><input type="checkbox" class="cat-checkbox" value="e" id="cat-e">原创</label></div>
            <div class="category-item"><label><input type="checkbox" class="cat-checkbox" value="f" id="cat-f">网络</label></div>
          </div>
          <div class="category-column">
            <div class="category-item"><label><input type="checkbox" class="cat-checkbox" value="g" id="cat-g">其他</label></div>
            <div class="category-item"><label><input type="checkbox" class="cat-checkbox" value="h" id="cat-h">影视</label></div>
            <div class="category-item"><label><input type="checkbox" class="cat-checkbox" value="i" id="cat-i">诗词</label></div>
            <div class="category-item"><label><input type="checkbox" class="cat-checkbox" value="j" id="cat-j">网易云</label></div>
            <div class="category-item"><label><input type="checkbox" class="cat-checkbox" value="k" id="cat-k">哲学</label></div>
            <div class="category-item"><label><input type="checkbox" class="cat-checkbox" value="l" id="cat-l">抖机灵</label></div>
          </div>
        </div>
        
        <div class="category-hint">选择想要的名言分类</div>
        
        <div class="config-actions">
          <button class="btn btn-primary" id="save-btn">保存分类</button>
        </div>
      </div>
      
      <div class="tab-content" id="tab-settings">
        <div class="settings-section">
          <h4>显示设置</h4>
          <div class="display-options">
            <div class="display-option">
              <label class="setting-item-label">
                <input type="checkbox" id="show-background-checkbox">
                <span class="setting-label-text">显示背景</span>
              </label>
            </div>
            <div class="display-option">
              <label class="setting-item-label">
                <input type="checkbox" id="show-timer-checkbox">
                <span class="setting-label-text">显示计时器</span>
              </label>
            </div>
          </div>
        </div>
        
        <div class="settings-section">
          <h4>切换间隔设置</h4>
          <div class="interval-container">
            <div class="interval-options">
              <button type="button" class="interval-btn" data-interval="10000">10秒</button>
              <button type="button" class="interval-btn" data-interval="60000">1分钟</button>
              <button type="button" class="interval-btn" data-interval="1200000">20分钟</button>
              <button type="button" class="interval-btn" data-interval="3600000">1小时</button>
              <button type="button" class="interval-btn" data-interval="10800000">3小时</button>
              <button type="button" class="interval-btn" data-interval="18000000">5小时</button>
            </div>
          </div>
        </div>
        
        <div class="settings-section">
          <h4>其他设置</h4>
          <div class="other-actions">
            <button class="btn btn-secondary" id="clear-cache-btn">清除缓存数据</button>
          </div>
        </div>
        
        <div class="config-actions">
          <button class="btn btn-primary" id="save-settings-btn">保存设置</button>
          <div class="status-message" id="settings-status"></div>
        </div>
      </div>
      
      <div class="tab-content" id="tab-about">
        <div class="about-content">
          <div class="app-name">一句</div>
          <div class="app-version">Version 1.0</div>
          
          <div class="app-description">
            一款优雅的桌面名言显示插件，每日为您呈现智慧与灵感。精选海量名言警句，涵盖文学、影视、哲学、诗词等12个分类，让您的桌面充满智慧光芒。
          </div>
          
          <div class="author-info">
            <div class="author-title">作者</div>
            <div class="author-name">ZHEN巭</div>
          </div>
          
          <div class="github-info">
            <div class="github-title">开源地址</div>
            <a href="https://github.com/ymzhen/" target="_blank" class="github-link">
              https://github.com/ymzhen/
            </a>
          </div>
          
          <div class="features-list">
            <h4>核心功能</h4>
            <ul>
              <li>📚 12个精选分类，涵盖古今中外</li>
              <li>⚙️ 自定义显示效果与切换间隔</li>
              <li>🌙 优雅的毛玻璃背景效果</li>
              <li>💾 智能缓存，离线可用</li>
              <li>📱 响应式设计，适配各种屏幕</li>
            </ul>
          </div>
        </div>
      </div>
      
      <div class="close-btn" id="close-btn">×</div>
    </div>
  </div>
  """

style: """
.widget-container {
  position: fixed;
  bottom: 5%;
  left: 50%;
  transform: translateX(-50%);
  z-index: 1000;
}

/* 默认背景样式（启用时） */
.quote-content {
  position: relative;
  border-radius: 10px;
  overflow: hidden;
  min-width: 500px;
  max-width: 680px;
  transition: all 0.3s ease;
}

.quote-content.with-background {
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.12);
  box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
}

.quote-inner {
  position: relative;
  padding: 20px 30px;
  text-align: center;
  transition: all 0.3s ease;
}

.quote-inner.with-background {
  background: rgba(40, 44, 52, 0.2);
}

/* 无背景效果时的样式 */
.quote-content.no-background {
  backdrop-filter: none;
  -webkit-backdrop-filter: none;
  border: none;
  box-shadow: none;
  background: transparent;
}

.quote-inner.no-background {
  background: transparent;
}

/* 计时器行样式 */
.timer-row {
  display: flex;
  justify-content: center;
  align-items: center;
  margin-top: 15px;
  padding-top: 10px;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  transition: all 0.3s ease;
}

/* 设置图标样式 */
.quote-icon {
  height: 24px;
  opacity: 0.7;
  margin-bottom: 20px;
  cursor: pointer;
  transition: all 0.3s;
  user-select: none;
}

.quote-icon:hover {
  opacity: 0.9;
  transform: scale(1.1);
}

.quote-icon.with-background {
  filter: brightness(0) invert(1);
}

.quote-icon.no-background {
  filter: brightness(0.8);
  opacity: 0.9;
}

.quote-text {
  font-family: "Playfair Display", "Georgia", serif;
  font-size: 22px;
  line-height: 1.7;
  color: rgba(255, 255, 255, 0.95);
  margin: 0 0 16px 0;
  padding: 0 10px;
  min-height: 60px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.quote-author {
  font-family: "Helvetica Neue", "Arial", sans-serif;
  font-size: 15px;
  font-style: italic;
  color: rgba(255, 255, 255, 0.75);
  text-align: center;
  margin-bottom: 20px;
  padding: 0 20px;
  min-height: 24px;
}

.timer-info {
  font-family: "SF Mono", "Monaco", monospace;
  font-size: 13px;
  color: rgba(255, 255, 255, 0.6);
  text-align: center;
}

.timer-normal { color: rgba(255, 255, 255, 0.6); }
.timer-warning { color: rgba(255, 255, 255, 0.6); }
.timer-switching { color: rgba(255, 255, 255, 0.6); }

/* 配置面板样式 */
.config-panel {
  position: absolute;
  top: -320px;
  right: 10px;
  background: rgba(30, 30, 40, 0.95);
  backdrop-filter: blur(20px);
  border-radius: 16px;
  border: 1px solid rgba(255, 255, 255, 0.15);
  padding: 18px 20px;
  width: 320px;
  max-height: 65vh;
  overflow-y: auto;
  box-shadow: 0 15px 35px rgba(0, 0, 0, 0.3);
  z-index: 999;
  display: none;
}

.config-tabs {
  display: flex;
  margin-bottom: 15px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.tab-btn {
  flex: 1;
  padding: 8px 0;
  background: none;
  border: none;
  color: rgba(255, 255, 255, 0.7);
  font-size: 12px;
  cursor: pointer;
  transition: all 0.3s;
}

.tab-btn:hover {
  color: rgba(255, 255, 255, 0.9);
}

.tab-btn.active {
  color: #007AFF;
  border-bottom: 2px solid #007AFF;
}

.tab-content {
  display: none;
}

.tab-content.active {
  display: block;
}

.close-btn {
  position: absolute;
  top: 12px;
  right: 12px;
  font-size: 20px;
  cursor: pointer;
  opacity: 0.7;
  padding: 0 8px;
  user-select: none;
  color: white;
}

.close-btn:hover {
  opacity: 1;
}

/* 状态标题样式 - 移动到分类列表上方 */
.status-title {
  margin-bottom: 12px;
  min-height: 36px;
  display: flex;
  align-items: center;
  justify-content: center;
}

#config-status {
  font-size: 12px;
  font-weight: 500;
  color: rgba(255, 255, 255, 0.9);
  text-align: center;
  padding: 8px 12px;
  border-radius: 8px;
  transition: all 0.3s ease;
  min-height: 18px;
  width: 100%;
}

/* 分类列表样式 */
.categories-list {
  display: flex;
  gap: 10px;
  margin-bottom: 8px;
}

.category-column {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.category-item {
  padding: 6px 8px;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 8px;
  min-height: 32px;
  display: flex;
  align-items: center;
}

.category-item:hover {
  background: rgba(255, 255, 255, 0.1);
}

.category-item label {
  display: flex;
  align-items: center;
  cursor: pointer;
  font-size: 12px;
  color: rgba(255, 255, 255, 0.9);
  width: 100%;
}

.category-item input {
  margin-right: 8px;
  width: 14px;
  height: 14px;
}

/* 分类提示文字 */
.category-hint {
  font-size: 11px;
  color: rgba(255, 255, 255, 0.6);
  text-align: center;
  margin: 8px 0 15px 0;
  padding: 6px 0;
  user-select: none;
}

/* 关于页面样式 */
.about-content {
  padding: 10px 5px;
}

.app-name {
  font-size: 24px;
  font-weight: bold;
  color: rgba(255, 255, 255, 0.95);
  text-align: center;
  margin-bottom: 5px;
  font-family: "Playfair Display", "Georgia", serif;
}

.app-version {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.7);
  text-align: center;
  margin-bottom: 20px;
  font-family: "SF Mono", "Monaco", monospace;
}

.app-description {
  font-size: 13px;
  line-height: 1.6;
  color: rgba(255, 255, 255, 0.85);
  text-align: center;
  margin-bottom: 25px;
  padding: 0 5px;
}

.author-info, .github-info {
  margin-bottom: 20px;
  text-align: center;
}

.author-title, .github-title {
  font-size: 11px;
  color: rgba(255, 255, 255, 0.6);
  margin-bottom: 5px;
  text-transform: uppercase;
  letter-spacing: 1px;
}

.author-name {
  font-size: 14px;
  color: rgba(255, 255, 255, 0.9);
  font-weight: 500;
}

.github-link {
  font-size: 12px;
  color: #007AFF;
  text-decoration: none;
  word-break: break-all;
  display: inline-block;
  padding: 5px 10px;
  background: rgba(0, 122, 255, 0.1);
  border-radius: 6px;
  transition: all 0.3s;
}

.github-link:hover {
  color: #0056CC;
  background: rgba(0, 122, 255, 0.15);
  text-decoration: underline;
}

.features-list {
  margin-top: 25px;
  padding-top: 20px;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
}

.features-list h4 {
  font-size: 13px;
  font-weight: 500;
  color: rgba(255, 255, 255, 0.9);
  margin: 0 0 12px 0;
  text-align: center;
}

.features-list ul {
  list-style: none;
  padding: 0;
  margin: 0;
}

.features-list li {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.8);
  margin-bottom: 8px;
  padding-left: 5px;
  display: flex;
  align-items: center;
}

.features-list li:before {
  content: "•";
  color: #007AFF;
  font-size: 16px;
  margin-right: 8px;
}

/* 显示设置样式 - 并排布局 */
.display-options {
  display: flex;
  gap: 10px;
  margin-bottom: 10px;
}

.display-option {
  flex: 1;
  padding: 10px;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 8px;
  min-height: 32px;
  display: flex;
  align-items: center;
}

.display-option:hover {
  background: rgba(255, 255, 255, 0.1);
}

.display-option .setting-item-label {
  display: flex;
  align-items: center;
  cursor: pointer;
  font-size: 12px;
  color: rgba(255, 255, 255, 0.9);
  width: 100%;
  justify-content: center;
}

.display-option .setting-item-label input[type="checkbox"] {
  margin-right: 8px;
  width: 14px;
  height: 14px;
}

.settings-section {
  margin-bottom: 18px;
  padding-bottom: 12px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.12);
}

.settings-section:last-child {
  border-bottom: none;
}

.settings-section h4 {
  margin: 0 0 10px 0;
  font-size: 13px;
  font-weight: 500;
  color: rgba(255, 255, 255, 0.9);
}

/* 间隔设置样式 */
.interval-container {
  padding: 10px;
  background: rgba(255, 255, 255, 0.05);
  border-radius: 8px;
}

.interval-options {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
  margin: 0;
}

.interval-btn {
  padding: 5px 8px;
  background: rgba(255, 255, 255, 0.08);
  border: 1px solid rgba(255, 255, 255, 0.12);
  border-radius: 6px;
  color: rgba(255, 255, 255, 0.85);
  font-size: 11px;
  cursor: pointer;
  transition: all 0.3s;
  flex: 1;
  min-width: calc(50% - 6px);
  text-align: center;
}

.interval-btn:hover {
  background: rgba(255, 255, 255, 0.15);
}

.interval-btn.active {
  background: #007AFF;
  color: white;
  border-color: #007AFF;
}

/* 其他操作按钮样式 */
.other-actions {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.config-actions {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.btn {
  padding: 8px 12px;
  border: none;
  border-radius: 8px;
  font-size: 12px;
  font-weight: 500;
  cursor: pointer;
  user-select: none;
}

.btn-primary {
  background: #007AFF;
  color: white;
}

.btn-primary:hover {
  background: #0056CC;
}

.btn-secondary {
  background: rgba(255, 255, 255, 0.1);
  color: rgba(255, 255, 255, 0.9);
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.btn-secondary:hover {
  background: rgba(255, 255, 255, 0.15);
}

.status-message {
  padding: 6px;
  border-radius: 6px;
  font-size: 11px;
  text-align: center;
  min-height: 18px;
}

.status-success {
  background: rgba(76, 175, 80, 0.1);
  color: #4CAF50;
}

.status-error {
  background: rgba(244, 67, 54, 0.1);
  color: #F44336;
}

.loading-spinner {
  display: inline-block;
  width: 12px;
  height: 12px;
  border: 2px solid rgba(255, 255, 255, 0.3);
  border-radius: 50%;
  border-top-color: #fff;
  animation: spin 1s ease-in-out infinite;
  margin-right: 8px;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

@media (max-width: 768px) {
  .widget-container {
    bottom: 10px;
    width: 95vw;
  }
  
  .quote-content {
    min-width: auto;
    max-width: 100%;
    border-radius: 8px;
  }
  
  .quote-inner {
    padding: 20px;
  }
  
  .quote-text {
    font-size: 19px;
  }
  
  .quote-author {
    font-size: 14px;
  }
  
  .config-panel {
    width: 300px;
    max-height: 60vh;
    right: 5px;
    top: -300px;
  }
  
  .categories-list {
    flex-direction: column;
  }
  
  .display-options {
    flex-direction: column;
  }
  
  .interval-options {
    flex-direction: column;
  }
  
  .interval-btn {
    width: 100%;
    min-width: auto;
  }
  
  .other-actions {
    flex-direction: column;
  }
}
"""

# ====== 功能代码 ======

init: ->
  console.log "初始化名言插件..."
  
  # 先初始化所有变量
  @lastUpdate = 0
  @currentQuoteIndex = 0
  @isUpdatingData = false
  
  # 确保配置对象存在
  @config = DEFAULT_CONFIG
  
  # 加载用户配置（覆盖默认值）
  @loadConfig()
  
  # 初始化数据检查
  @checkInitialData()

# 安全的配置访问函数
getConfig: (key) ->
  if @config and @config[key] != undefined
    return @config[key]
  else
    return DEFAULT_CONFIG[key]

loadConfig: ->
  console.log "开始加载配置..."
  
  try
    # 创建配置对象（使用默认值作为基础）
    config = {}
    
    # 分类配置
    savedCats = localStorage.getItem('selected-categories')
    config.categories = if savedCats then JSON.parse(savedCats) else DEFAULT_CONFIG.categories
    
    # 显示设置
    showBackground = localStorage.getItem('show-background')
    config.showBackground = if showBackground then JSON.parse(showBackground) else DEFAULT_CONFIG.showBackground
    
    showTimer = localStorage.getItem('show-timer')
    config.showTimer = if showTimer then JSON.parse(showTimer) else DEFAULT_CONFIG.showTimer
    
    # 切换间隔设置
    switchInterval = localStorage.getItem('switch-interval')
    config.switchInterval = if switchInterval then parseInt(switchInterval) else DEFAULT_CONFIG.switchInterval
    
    # 更新配置对象
    @config = config
    
    console.log "配置加载完成:", @config
    
  catch error
    console.log "加载配置失败，使用默认值:", error
    @config = DEFAULT_CONFIG

saveConfig: (key, value) ->
  try
    localStorage.setItem(key, JSON.stringify(value))
    
    # 确保配置对象存在
    if not @config
      @config = DEFAULT_CONFIG
    
    # 更新内存中的配置
    @config[key] = value
      
    console.log "配置已保存: #{key} = #{value}"
    return true
  catch error
    console.log "保存配置失败:", error
    return false

checkInitialData: ->
  try
    cachedData = localStorage.getItem('cached-quotes')
    if not cachedData or cachedData.length == 0
      console.log "无缓存数据，将使用在线数据源"
      
      # 如果没有缓存数据，但用户有配置分类，尝试获取一次数据
      if @config.categories and @config.categories.length > 0
        console.log "正在初始化获取数据..."
        @updateDataFromGitHub(@config.categories, null, true)
    else
      console.log "发现缓存数据，无需初始化获取"
  catch error
    console.log "检查初始数据时出错:", error

afterRender: (domElement) ->
  console.log "afterRender 被调用"
  @domElement = domElement
  
  # 立即应用所有设置
  @applyAllSettings()
  
  # 设置图标点击事件
  $(domElement).find('#settings-icon-btn').on 'click', =>
    console.log "设置图标被点击"
    @toggleConfigPanel(domElement)
  
  $(domElement).find('#close-btn').on 'click', =>
    console.log "关闭按钮被点击"
    @toggleConfigPanel(domElement)
  
  # 分类标签页事件
  $(domElement).find('.tab-btn').on 'click', (e) =>
    tab = $(e.target).data('tab')
    @switchTab(domElement, tab)
  
  # 保存分类按钮
  $(domElement).find('#save-btn').on 'click', =>
    console.log "保存按钮被点击"
    @saveCategories(domElement)
  
  # 保存设置按钮
  $(domElement).find('#save-settings-btn').on 'click', =>
    console.log "保存设置按钮被点击"
    @saveSettings(domElement)
  
  # 清除缓存按钮
  $(domElement).find('#clear-cache-btn').on 'click', =>
    @clearCache(domElement)
  
  # 为间隔按钮添加点击事件监听
  $(domElement).find('.interval-btn').on 'click', (e) =>
    @handleIntervalButtonClick(e, domElement)
  
  # 初始化界面状态
  @initCheckboxes(domElement)
  @initSettingsUI(domElement)
  
  # 初始化状态显示（显示当前名言数量）
  @updateStatusDisplay(domElement)
  
  @updateQuote(domElement)
  @lastUpdate = Date.now()
  
  # 使用安全的配置访问
  if @getConfig('showTimer')
    @updateTimer(domElement, Date.now())

# 更新状态显示（显示当前有效名言数量）
updateStatusDisplay: (domElement) ->
  try
    cachedData = localStorage.getItem('cached-quotes')
    statusEl = $(domElement).find('#config-status')
    
    if not cachedData or cachedData.length == 0
      statusEl.text("📝 暂无缓存数据，请选择分类并保存")
      statusEl.removeClass('status-success status-error')
    else
      quotes = JSON.parse(cachedData)
      if quotes.length == 0
        statusEl.text("📝 暂无有效数据，请重新获取")
        statusEl.removeClass('status-success status-error')
      else
        statusEl.text("✅ 当前 #{quotes.length} 条有效名言")
        statusEl.addClass('status-success')
    
    console.log "状态显示已更新"
    
  catch error
    console.log "更新状态显示失败:", error
    statusEl = $(domElement).find('#config-status')
    statusEl.text("📝 状态信息加载中...")
    statusEl.removeClass('status-success status-error')

# 应用所有设置
applyAllSettings: ->
  @applyBackgroundStyle()
  @applyTimerVisibility()

# 应用计时器显示设置
applyTimerVisibility: ->
  if @domElement
    showTimer = @getConfig('showTimer')
    timerRow = $(@domElement).find('#timer-row')
    
    if showTimer
      timerRow.css('display', 'flex')
      console.log "计时器已显示"
    else
      timerRow.css('display', 'none')
      $(@domElement).find('#timer-info').text('')
      console.log "计时器已隐藏"
  else
    console.log "警告: 无法应用计时器可见性，DOM元素未初始化"

# 处理间隔按钮点击
handleIntervalButtonClick: (e, domElement) ->
  # 移除所有按钮的active类
  $(domElement).find('.interval-btn').removeClass('active')
  
  # 给点击的按钮添加active类
  $(e.target).addClass('active')
  
  # 立即显示反馈
  @showSettingsStatus(domElement, '✅ 间隔已选择', 'success')

# 保存设置函数 - 不移除自动关闭
saveSettings: (domElement) ->
  try
    # 获取所有设置值
    showBackground = $(domElement).find('#show-background-checkbox').prop('checked')
    showTimer = $(domElement).find('#show-timer-checkbox').prop('checked')
    
    # 获取切换间隔
    activeIntervalBtn = $(domElement).find('.interval-btn.active')
    if activeIntervalBtn.length > 0
      switchInterval = parseInt(activeIntervalBtn.data('interval'))
    else
      switchInterval = @getConfig('switchInterval')
    
    console.log "保存设置: 背景=#{showBackground}, 计时器=#{showTimer}, 间隔=#{switchInterval}ms"
    
    # 保存所有设置到localStorage
    @saveConfig('show-background', showBackground)
    @saveConfig('show-timer', showTimer)
    @saveConfig('switch-interval', switchInterval)
    
    # 立即重新加载配置以确保内存中的配置是最新的
    @loadConfig()
    
    # 立即应用所有设置
    @applyAllSettings()
    
    # 强制重置更新时间，立即触发名言更新
    @lastUpdate = Date.now() - switchInterval + 1000
    
    # 立即更新名言和计时器
    @updateQuote(domElement)
    @updateTimer(domElement, Date.now())
    
    # 显示成功消息
    @showSettingsStatus(domElement, '✅ 设置已保存并立即生效', 'success')
    
    console.log "设置保存完成并立即生效"
    
  catch error
    console.error "保存设置失败:", error
    @showSettingsStatus(domElement, '❌ 保存设置失败: ' + error.message, 'error')

# 修复的背景样式应用函数
applyBackgroundStyle: ->
  if @domElement
    # 使用安全的配置访问
    showBackground = @getConfig('showBackground')
    
    console.log "应用背景样式: #{showBackground}"
    
    quoteContent = $(@domElement).find('#quote-content')
    quoteInner = $(@domElement).find('#quote-inner')
    quoteIcon = $(@domElement).find('.quote-icon')
    
    if showBackground
      # 移除无背景类，添加有背景类
      quoteContent.removeClass('no-background').addClass('with-background')
      quoteInner.removeClass('no-background').addClass('with-background')
      quoteIcon.removeClass('no-background').addClass('with-background')
      console.log "背景效果已启用（两层都应用）"
    else
      # 移除有背景类，添加无背景类
      quoteContent.removeClass('with-background').addClass('no-background')
      quoteInner.removeClass('with-background').addClass('no-background')
      quoteIcon.removeClass('with-background').addClass('no-background')
      console.log "背景效果已禁用（两层都移除）"
  else
    console.log "警告: 无法应用背景样式，DOM元素未初始化"

switchTab: (domElement, tabName) ->
  # 切换标签按钮状态
  $(domElement).find('.tab-btn').removeClass('active')
  $(domElement).find(".tab-btn[data-tab='#{tabName}']").addClass('active')
  
  # 切换标签内容
  $(domElement).find('.tab-content').removeClass('active')
  $(domElement).find("#tab-#{tabName}").addClass('active')
  
  # 如果是分类标签，更新状态显示
  if tabName == 'categories'
    @updateStatusDisplay(domElement)

initSettingsUI: (domElement) ->
  console.log "初始化UI设置..."
  
  # 设置复选框状态 - 使用安全的配置访问
  $(domElement).find('#show-background-checkbox').prop('checked', @getConfig('showBackground'))
  $(domElement).find('#show-timer-checkbox').prop('checked', @getConfig('showTimer'))
  
  # 设置切换间隔按钮状态
  $(domElement).find('.interval-btn').removeClass('active')
  switchInterval = @getConfig('switchInterval')
  
  console.log "当前间隔设置: #{switchInterval}ms"
  
  # 查找匹配的间隔按钮
  intervalBtn = $(domElement).find(".interval-btn[data-interval='#{switchInterval}']")
  if intervalBtn.length > 0
    intervalBtn.addClass('active')
    console.log "找到匹配的间隔按钮: #{switchInterval}"
  else
    # 如果没有找到匹配的按钮，使用默认值（10秒）
    console.log "未找到匹配的间隔按钮，使用默认值"
    defaultBtn = $(domElement).find(".interval-btn[data-interval='10000']")
    if defaultBtn.length > 0
      defaultBtn.addClass('active')
      console.log "使用默认10秒间隔"
    else
      console.log "警告：未找到任何间隔按钮"
  
  console.log "初始化UI完成 - 切换间隔: #{switchInterval}ms"

toggleConfigPanel: (domElement) ->
  panel = $(domElement).find('#config-panel')
  if panel.css('display') == 'none'
    console.log "显示配置面板"
    panel.css('display', 'block')
    
    # 重新初始化UI以确保状态正确
    @initSettingsUI(domElement)
    
    # 更新状态显示
    @updateStatusDisplay(domElement)
    
    # 检查是否需要调整位置（确保面板完全可见）
    panelRect = panel[0].getBoundingClientRect()
    windowHeight = window.innerHeight
    
    # 如果面板底部超出窗口，向上调整
    if panelRect.bottom > windowHeight
      adjustAmount = panelRect.bottom - windowHeight + 20
      newTop = parseInt(panel.css('top')) - adjustAmount
      panel.css('top', newTop + 'px')
    
    # 如果面板顶部超出窗口，向下调整
    if panelRect.top < 0
      adjustAmount = -panelRect.top + 20
      newTop = parseInt(panel.css('top')) + adjustAmount
      panel.css('top', newTop + 'px')
    
  else
    console.log "隐藏配置面板"
    panel.css('display', 'none')
    # 重置位置
    panel.css('top', '-320px')

initCheckboxes: (domElement) ->
  categories = @getConfig('categories')
  console.log "初始化分类复选框: #{categories}"
  for cat in categories
    $(domElement).find("#cat-#{cat}").prop('checked', true)
  console.log "初始化复选框完成"

saveCategories: (domElement) ->
  if @isUpdatingData
    @showStatus(domElement, '🔄 数据正在更新中，请稍候...', 'success')
    return
  
  selectedCats = []
  checkboxes = $(domElement).find('.cat-checkbox')
  for checkbox in checkboxes
    if $(checkbox).prop('checked')
      selectedCats.push($(checkbox).val())
  
  if selectedCats.length == 0
    @showStatus(domElement, '请至少选择一个分类！', 'error')
    return
  
  try
    @saveConfig('selected-categories', selectedCats)
    
    @showStatus(domElement, '✅ 分类已保存！正在更新数据...', 'success')
    console.log "保存的分类:", selectedCats
    
    # 立即更新数据
    @showStatus(domElement, '🔄 正在从GitHub更新数据...', 'success')
    @isUpdatingData = true
    
    saveBtn = $(domElement).find('#save-btn')
    originalText = saveBtn.text()
    saveBtn.html('<span class="loading-spinner"></span>更新中...')
    saveBtn.prop('disabled', true)
    
    @updateDataFromGitHub(selectedCats, domElement)
    
  catch error
    @showStatus(domElement, '❌ 保存失败: ' + error.message, 'error')
    @isUpdatingData = false

clearCache: (domElement) ->
  try
    # 只清除缓存数据，保留配置
    localStorage.removeItem('cached-quotes')
    localStorage.removeItem('quotes-last-updated')
    
    # 更新状态显示
    @updateStatusDisplay(domElement)
    
    @showSettingsStatus(domElement, '✅ 缓存数据已清除', 'success')
    
    # 重新获取数据
    categories = @getConfig('categories')
    if categories and categories.length > 0
      setTimeout =>
        @showSettingsStatus(domElement, '🔄 正在重新获取数据...', 'success')
        @updateDataFromGitHub(categories, domElement)
      , 1000
    
    console.log "缓存数据已清除"
    
  catch error
    @showSettingsStatus(domElement, '❌ 清除缓存失败: ' + error.message, 'error')

showSettingsStatus: (domElement, message, type) ->
  statusEl = $(domElement).find('#settings-status')
  statusEl.text(message)
  statusEl.removeClass('status-success status-error')
  if message
    statusEl.addClass("status-#{type}")
  else
    statusEl.removeClass("status-success status-error")
  
  if message
    # 5秒后清除消息（不移除自动关闭面板）
    setTimeout =>
      statusEl.text('')
      statusEl.removeClass('status-success status-error')
    , 5000

showStatus: (domElement, message, type) ->
  statusEl = $(domElement).find('#config-status')
  statusEl.text(message)
  statusEl.removeClass('status-success status-error')
  if message
    statusEl.addClass("status-#{type}")
  else
    statusEl.removeClass("status-success status-error")
  
  if message
    # 5秒后清除消息，但恢复为显示名言数量
    setTimeout =>
      @updateStatusDisplay(domElement)
    , 5000

# 数据获取和更新函数
updateDataFromGitHub: (selectedCategories, domElement, isInitialLoad = false) ->
  console.log "开始从GitHub更新数据，分类:", selectedCategories
  
  allQuotes = []
  completedCount = 0
  totalCount = selectedCategories.length
  errors = []
  
  for category in selectedCategories
    url = DATA_SOURCES[category]
    console.log "获取分类 #{category} 数据: #{url}"
    
    @fetchJSONData(url).then (data) =>
      completedCount++
      console.log "分类 #{category}: 获取 #{data.length} 条数据"
      
      processedData = @processCategoryData(data, category)
      allQuotes = allQuotes.concat(processedData)
      
      progress = Math.round((completedCount / totalCount) * 100)
      
      if domElement and not isInitialLoad
        @showStatus(domElement, "🔄 更新数据中... #{progress}% (#{completedCount}/#{totalCount})", 'success')
      
      if completedCount == totalCount
        @finishDataUpdate(allQuotes, errors, domElement, isInitialLoad)
        
    .catch (error) =>
      completedCount++
      errors.push("分类 #{category}: #{error.message}")
      console.log "分类 #{category} 获取失败:", error
      
      progress = Math.round((completedCount / totalCount) * 100)
      
      if domElement and not isInitialLoad
        @showStatus(domElement, "⚠️ 部分数据获取失败... #{progress}%", 'error')
      
      if completedCount == totalCount
        @finishDataUpdate(allQuotes, errors, domElement, isInitialLoad)

fetchJSONData: (url) ->
  return new Promise (resolve, reject) =>
    fetch(url)
      .then (response) =>
        if not response.ok
          throw new Error("HTTP错误 #{response.status}")
        response.json()
      .then (data) =>
        resolve(data)
      .catch (error) =>
        reject(error)

processCategoryData: (data, category) ->
  processed = []
  
  categoryNames =
    'a': '动画'
    'b': '漫画'
    'c': '游戏'
    'd': '文学'
    'e': '原创'
    'f': '网络'
    'g': '其他'
    'h': '影视'
    'i': '诗词'
    'j': '网易云'
    'k': '哲学'
    'l': '抖机灵'
  
  categoryName = categoryNames[category] or category
  
  for item in data
    try
      text = item.hitokoto or item.text or ''
      fromWho = item.from_who or ''
      from = item.from or ''
      
      cleanedText = text.replace(/\s+/g, ' ').trim()
      
      if not cleanedText or cleanedText.length == 0
        continue
      
      author = if fromWho and fromWho.toString().trim() != ''
        fromWho.toString().trim()
      else if from and from.toString().trim() != ''
        from.toString().trim()
      else
        '佚名'
      
      author = author
        .replace(/^作者[:：]\s*/, '')
        .replace(/^[-－·•・]\s*/, '')
        .replace(/^《(.+)》$/, '$1')
        .trim()
      
      if not author or author.length == 0
        author = '佚名'
      
      processed.push
        text: cleanedText
        author: author
        category: categoryName
        
    catch error
      console.log "处理数据项时出错:", error
      continue
  
  console.log "分类 #{category}: 成功处理 #{processed.length}/#{data.length} 条数据"
  return processed

validateQuotes: (quotes) ->
  validQuotes = []
  
  for quote in quotes
    if not quote
      continue
      
    if not quote.text or typeof quote.text != 'string' or quote.text.trim().length == 0
      continue
      
    if not quote.author or typeof quote.author != 'string'
      quote.author = '佚名'
      
    quote.text = String(quote.text).trim()
    quote.author = String(quote.author).trim()
    
    validQuotes.push(quote)
  
  return validQuotes

finishDataUpdate: (allQuotes, errors, domElement, isInitialLoad = false) ->
  console.log "数据更新完成，原始获取 #{allQuotes.length} 条名言"
  
  allQuotes = @validateQuotes(allQuotes)
  console.log "数据验证后剩余 #{allQuotes.length} 条名言"
  
  if domElement and not isInitialLoad
    saveBtn = $(domElement).find('#save-btn')
    saveBtn.text('保存分类')
    saveBtn.prop('disabled', false)
  
  @isUpdatingData = false
  
  if allQuotes.length == 0
    if domElement and not isInitialLoad
      @showStatus(domElement, '❌ 数据更新失败：未获取到有效数据', 'error')
    
    return
  
  try
    localStorage.setItem('cached-quotes', JSON.stringify(allQuotes))
    localStorage.setItem('quotes-last-updated', Date.now().toString())
    console.log "数据已缓存到localStorage，名言总数:", allQuotes.length
    
    if domElement and not isInitialLoad
      successMsg = "✅ 数据更新完成！获取 #{allQuotes.length} 条有效名言"
      if errors.length > 0
        successMsg += "（#{errors.length} 个分类失败）"
      
      @showStatus(domElement, successMsg, 'success')
      
      @showRandomQuoteFromNewData(allQuotes, domElement)
      
      # 更新状态显示
      @updateStatusDisplay(domElement)
    
    # 如果是初始化加载，立即显示一条名言
    if isInitialLoad and allQuotes.length > 0
      console.log "初始化加载完成，已缓存 #{allQuotes.length} 条名言"
      
      # 更新状态显示
      if domElement
        @updateStatusDisplay(domElement)
      
  catch error
    console.error "数据保存详细错误:", error
    if domElement and not isInitialLoad
      @showStatus(domElement, '❌ 数据保存失败: ' + error.message, 'error')

showRandomQuoteFromNewData: (quotes, domElement) ->
  if quotes.length == 0
    return
  
  randomIndex = Math.floor(Math.random() * quotes.length)
  quote = quotes[randomIndex]
  
  $(domElement).find(".quote-text").css({
    "opacity": "0.6",
    "transform": "translateY(5px)"
  })
  
  $(domElement).find(".quote-author").css({
    "opacity": "0.6",
    "transform": "translateY(5px)"
  })
  
  setTimeout =>
    $(domElement).find(".quote-text")
      .text(quote.text)
      .css({
        "opacity": "1",
        "transform": "translateY(0)",
        "transition": "all 0.3s ease"
      })
    
    authorHtml = "<div class='quote-author'>#{quote.author}</div>"
    $(domElement).find(".quote-author")
      .html(authorHtml)
      .css({
        "opacity": "1",
        "transform": "translateY(0)",
        "transition": "all 0.4s ease"
      })
    
    console.log "显示新数据中的名言"
  , 150

update: (output, domElement) ->
  now = Date.now()
  
  # 使用安全的配置访问
  switchInterval = @getConfig('switchInterval')
  
  # 检查是否需要切换名言
  if @lastUpdate == 0 or (now - @lastUpdate) >= switchInterval
    @updateQuote(domElement)
    @lastUpdate = now
  
  # 只有显示计时器时才更新计时器显示
  if @getConfig('showTimer')
    @updateTimer(domElement, now)

updateQuote: (domElement) ->
  try
    # 从缓存获取数据
    cachedData = localStorage.getItem('cached-quotes')
    
    if not cachedData or cachedData.length == 0
      $(domElement).find(".quote-text").text("暂无数据，请更新")
      $(domElement).find(".quote-author").html("<div class='quote-author'></div>")
      return
      
    quotes = JSON.parse(cachedData)
    
    if quotes.length == 0
      $(domElement).find(".quote-text").text("暂无数据，请更新")
      $(domElement).find(".quote-author").html("<div class='quote-author'></div>")
      return
    
    # 随机选择一条名言
    randomIndex = Math.floor(Math.random() * quotes.length)
    quote = quotes[randomIndex]
    
    $(domElement).find(".quote-text").css({
      "opacity": "0.6",
      "transform": "translateY(5px)"
    })
    
    $(domElement).find(".quote-author").css({
      "opacity": "0.6",
      "transform": "translateY(5px)"
    })
    
    setTimeout =>
      $(domElement).find(".quote-text")
        .text(quote.text)
        .css({
          "opacity": "1",
          "transform": "translateY(0)",
          "transition": "all 0.3s ease"
        })
      
      authorHtml = "<div class='quote-author'>#{quote.author}</div>"
      $(domElement).find(".quote-author")
        .html(authorHtml)
        .css({
          "opacity": "1",
          "transform": "translateY(0)",
          "transition": "all 0.4s ease"
        })
    , 150
    
  catch error
    console.log "更新名言失败:", error.message if error.message
    $(domElement).find(".quote-text").text("加载中...")
    $(domElement).find(".quote-author").html("<div class='quote-author'></div>")

updateTimer: (domElement, now) ->
  if @lastUpdate == 0 then return
  
  # 使用安全的配置访问
  switchInterval = @getConfig('switchInterval')
  
  timePassed = now - @lastUpdate
  timeLeft = switchInterval - timePassed
  
  timerEl = $(domElement).find('#timer-info')
  
  if timeLeft > 0
    # 总是显示详细倒计时
    seconds = Math.ceil(timeLeft / 1000)
    
    colorClass = if timeLeft < 2000 then "timer-warning" else "timer-normal"
    
    if switchInterval >= 3600000
      hours = Math.floor(timeLeft / 3600000)
      minutes = Math.floor((timeLeft % 3600000) / 60000)
      displayText = "剩余: #{hours}小时#{minutes}分"
    else if switchInterval >= 60000
      minutes = Math.floor(timeLeft / 60000)
      secs = Math.floor((timeLeft % 60000) / 1000)
      displayText = "剩余: #{minutes}分#{secs}秒"
    else
      displayText = "剩余: #{seconds}秒"
    
    intervalText = @formatInterval(switchInterval)
    timerEl.html("<span class='#{colorClass}'>#{intervalText}切换 | #{displayText}</span>")
    
  else
    timerEl.html("<span class='timer-switching'>切换中...</span>")

formatInterval: (ms) ->
  if ms >= 86400000
    "#{ms / 86400000}天"
  else if ms >= 3600000
    "#{ms / 3600000}小时"
  else if ms >= 60000
    "#{ms / 60000}分钟"
  else
    "#{ms / 1000}秒"

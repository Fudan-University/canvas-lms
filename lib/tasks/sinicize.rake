# 用于 Sinicize 的 Rake task

$sinicize_tasks_loaded ||= false
unless $sinicize_tasks_loaded
  $sinicize_tasks_loaded = true

  def sinicize_folder
    File.expand_path('public/sinicize', Rails.root)
  end

  def local_cdn_folder
    File.expand_path('cdn', sinicize_folder)
  end

  def local_cdn_prefix
    '/sinicize/cdn'
  end

  namespace :sinicize do
    desc '将引用外部CDN的内容放到本地'
    task :load_cdn_to_local do
      %w(
        sinicize:load_fetch_to_local
        sinicize:load_mathjax_to_local
      ).each do |task|
        Rake::Task[task].invoke
      end
    end

    desc '将 fetch.js 的内容放到本地'
    task :load_fetch_to_local do
      puts '处理 fetch.js'
      fetch_version = '2.0.4'
      fetch_folder = File.expand_path("fetch/#{fetch_version}", local_cdn_folder)
      FileUtils.mkdir_p fetch_folder

      puts "下载 fetch.js #{fetch_version} 至 #{fetch_folder}"
      fetch_remote_path = "https://cdnjs.cloudflare.com/ajax/libs/fetch/#{fetch_version}/fetch.min.js"
      `wget -qN #{fetch_remote_path} -P #{fetch_folder}`

      target_file = File.expand_path('app/views/layouts/_head.html.erb', Rails.root)
      text = File.read target_file
      raise "没有在 #{target_file} 中找到期望的地址 #{fetch_remote_path}, 请检查" unless text.include? fetch_remote_path
      local_path = "#{local_cdn_prefix}/fetch/#{fetch_version}/fetch.min.js"
      `sed -i 's,#{fetch_remote_path},#{local_path},g' #{target_file}`
      puts "完成替换 #{target_file} 中的 fetch.js 引用"
    end

    desc '将 MathJax 的内容放到本地'
    task :load_mathjax_to_local do
      puts '处理 MathJax'
      mathjax_version = '2.7.1'
      mathjax_folder = File.expand_path('mathjax', local_cdn_folder)

      puts "下载 MathJax #{mathjax_version} 至 #{mathjax_folder} ..."
      FileUtils.mkdir_p mathjax_folder
      mathjax_archive_path = "https://github.com/mathjax/MathJax/archive/#{mathjax_version}.tar.gz"
      `wget -qNO- #{mathjax_archive_path} | tar xz -C #{mathjax_folder}`

      # 替换调用 MathJax 的设置
      # 设置的核心文件位于 public/javascripts/mathml.js
      # 修改有2处，1是修改 MathJax 的引用位置
      # 2是修改对应config，使其能正确二次引用的文件
      target_file = File.expand_path('public/javascripts/mathml.js', Rails.root)
      puts "尝试替换 #{target_file} 中的MathJax 引用"
      text = File.read target_file
      cdn_prefix = '//cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.1'
      raise "没有在 #{target_file} 中找到期望的地址 #{cdn_prefix} ，请检查" unless text.include? cdn_prefix
      lines = text.split("\n")
      config_line = lines.index('const localConfig = {')

      unless config_line
        raise "没有在 #{target_file} 中的期望位置找到设置，请检查"
      end
      lines.insert(config_line + 1, "  root: '#{local_cdn_prefix}/mathjax/MathJax-#{mathjax_version}',")
      text = lines.join("\n")
      local_prefix = "#{local_cdn_prefix}/mathjax/MathJax-#{mathjax_version}"
      text.gsub! cdn_prefix, local_prefix
      File.write(target_file, text)
      puts "完成替换 #{target_file} 中的 MathJax 应用"
    end

  end
end

# 用于 Sinicize 的 Rake task

$sinicize_tasks_loaded ||= false
unless $sinicize_tasks_loaded
  $sinicize_tasks_loaded = true

  namespace :sinicize do
    desc '将引用外部CDN的内容放到本地'
    task :load_cdn_to_local do
      ['sinicize:load_mathjax_to_local'].each do |task|
        Rake::Task[task].invoke
      end
    end

    desc '将 MathJax 的内容放到本地'
    task :load_mathjax_to_local do
      puts '处理 MathJax'
      mathjax_version = '2.7.1'
      sinicize_folder = File.expand_path('public/sinicize', Rails.root)
      mathjax_folder = File.expand_path('cdn/mathjax', sinicize_folder)

      puts "下载 MathJax #{mathjax_version} 至 #{mathjax_folder} ..."
      FileUtils.mkdir_p mathjax_folder
      mathjax_archive_path = "https://github.com/mathjax/MathJax/archive/#{mathjax_version}.tar.gz"
      `wget -qO- #{mathjax_archive_path} | tar xz -C #{mathjax_folder}`

      # 替换调用 MathJax 的设置
      # 设置的核心文件位于 public/javascripts/mathml.js
      # 修改有2处，1是修改 MathJax 的引用位置
      # 2是修改对应config，使其能正确二次引用的文件
      target_file = File.expand_path('public/javascripts/mathml.js', Rails.root)
      puts "尝试替换 #{target_file} 中的MathJax 引用"
      text = File.read target_file
      cdn_prefix = '//cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.1'
      unless text.include? cdn_prefix
        raise "没有在 #{target_file} 中找到期望的地址 #{cdn_prefix} ，请检查"
      end
      lines = text.split("\n")
      config_line = lines.index('const localConfig = {')

      unless config_line
        raise "没有在 #{target_file} 中的期望位置找到设置，请检查"
      end
      lines.insert(config_line + 1, "  root: '/sinicize/cdn/mathjax/MathJax-#{mathjax_version}',")
      text = lines.join("\n")
      local_prefix = "/sinicize/cdn/mathjax/MathJax-#{mathjax_version}"
      text.gsub! cdn_prefix, local_prefix
      File.write(target_file, text)
      puts "替换引用 #{target_file} 完成"
    end

  end
end

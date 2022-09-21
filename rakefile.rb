def get_match(file_name, regexp)
  content = File.read(file_name, encoding: "UTF-8")
  match = regexp.match(content)
  if !match
    raise 'cannot match'
  end
  return match[1]
end

def image_tag
  "localhost/emacs-cask"
end
desc 'prepare'
task :prepare do
  sh "podman build --tag #{image_tag} ."
end

desc 'test'
task :test => [:prepare] do
  melpa_version = get_match("org-tagged.el", Regexp.new('Package-Version: (.*)'))
  elisp_version = get_match("org-tagged.el", Regexp.new('\\(message "org-tagged (.*)"\\)\\)'))
  cask_version = get_match("Cask", Regexp.new('\\(package "org-tagged" "(.*)" "Table with tagged todos for org-mode."\\)'))
  if melpa_version != elisp_version or
    melpa_version != cask_version or
    elisp_version != cask_version
    puts "melpa_version: #{melpa_version}"
    puts "elisp_version: #{elisp_version}"
    puts "cask_version: #{cask_version}"
    raise 'versions inconsistent'
  else
    puts "Testing version #{cask_version}"
  end

  sh "podman run --rm -it -v$(pwd)/features:/root/features -v$(pwd)/tests:/root/tests #{image_tag} exec ecukes --verbose --debug --reporter magnars"
end

task :default => :test

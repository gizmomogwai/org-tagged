class String
  def red
    "\e[31m#{self}\e[0m"
  end

  def bold
    "\e[1m#{self}\e[22m"
  end
end

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

def run_on_project_folder
  "podman run --rm -it -v#{Dir.pwd}/features:/root/features #{image_tag}"
end

desc 'test'
task :test => [
       #:prepare
     ] do
  puts "Checking version consistency".bold
  melpa_version = get_match("org-tagged.el", Regexp.new('Package-Version: (.*)'))
  elisp_version = get_match("org-tagged.el", Regexp.new('\\(message "org-tagged (.*)"\\)\\)'))
  cask_version = get_match("Cask", Regexp.new('\\(package "org-tagged" "(.*)" "Table with tagged todos for org-mode."\\)'))
  if melpa_version != elisp_version or
    melpa_version != cask_version or
    elisp_version != cask_version
    puts "melpa_version: #{melpa_version}".red
    puts "elisp_version: #{elisp_version}".red
    puts "cask_version: #{cask_version}".red
    raise "versions inconsistent".red
  end

  puts "Running unit tests".bold
  sh "#{run_on_project_folder} exec ert-runner -L features -L . features/*-ert.el"
  puts "Running integration tests".bold
  sh "#{run_on_project_folder} exec ecukes --verbose --debug --reporter magnars"
  puts "Running byte-compile".bold
  sh "#{run_on_project_folder} eval '(byte-compile-file \"org-tagged.el\")'"
  puts "Running checkdoc".bold
  sh "#{run_on_project_folder} eval '(progn (find-file \"org-tagged.el\")(checkdoc))'"
  puts "Running package-lint".bold
  sh "#{run_on_project_folder} eval \"(progn (find-file \\\"org-tagged.el\\\")(require 'package-lint)(package-lint-current-buffer)(message (with-current-buffer \\\"*Package-Lint*\\\" (buffer-string))))\""
end

desc "Push to github"
task :push => [:test] do
  sh "git push origin main"
end

desc "Run bash in container"
task :run do
  sh "podman run --rm -it --entrypoint /usr/bin/bash #{image_tag}"
end

task :default => :test

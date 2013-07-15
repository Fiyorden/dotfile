#!/usr/bin/env ruby -w

# Updates Textmate bundles using the Github repositories

# Original version found on http://blog.bleything.net/pages/mateup
# Cloned for https://github.com/oschrenk/scripts/blob/master/mateup

ENV['LC_ALL']   = nil
ENV['LC_CTYPE'] = 'en_US.UTF-8'

github_root = 'git://github.com'
bundles = {
  'Apache' => 'textmate/apache.tmbundle',
  'Copy as RTF' => 'drnic/copy-as-rtf-tmbundle',
  'Get Bundle' => 'textmate/getbundle.tmbundle',
  'Git' => 'jcf/git-tmbundle',
  'Html5' => 'johnmuhl/html5.tmbundle',
  'JavaScript-Tools' => 'subtleGradient/javascript-tools.tmbundle',
  'Json' => 'textmate/json.tmbundle',
  'Make' => 'textmate/make.tmbundle',
  'Markdown' => 'oschrenk/markdown.tmbundle',
  'PHP' => 'textmate/php.tmbundle',
  'RDoc' => 'joshaven/RDoc.tmbundle',
  'Regexp' => 'danielvlopes/regexp-tmbundle',
  'Ruby' => 'drnic/ruby-tmbundle',
  'Uncrustify' => 'oschrenk/Uncrustify.tmbundle',
  'Yaml' => 'textmate/yaml.tmbundle',
  'Todo List' => 'ryanb/todo-list.tmbundle',
  'Textmate' => 'textmate/textmate.tmbundle',
  'Graphviz' => 'textmate/graphviz.tmbundle',
  'Shell Script' => 'textmate/shellscript.tmbundle',
  'Javascript' => 'textmate/javascript.tmbundle',
  'CSS' => 'textmate/css.tmbundle',
  'Terminal' => 'textmate/terminalmate.tmbundle',
  'SSH Config' => 'textmate/ssh-config.tmbundle',
  'Jquery' => 'kswedberg/jquery-tmbundle',
  'Ruby on rails' => 'drnic/ruby-on-rails-tmbundle',
  'YUI Compressor' => 'mattkirman/YUI-Compressor-tmbundle',
  'Formtastic' => 'grimen/formtastic_tmbundle',
  'Simple Form' => 'doabit/simple_form_tmbundle',
  'Twitter Bootstrap' => 'vigo/textmate-twitterbootstrap.tmbundle',
  'FTP SSH' => 'craigulliott/FTP-SSH.tmbundle',
  'PHP Smarty' => 'textmate/php-smarty.tmbundle'
}

# escape spaces and ampersands
def cleanup(str)
  return str.gsub(/([ &])/, '\\\\\1')
end

  dir = "#{ENV['HOME']}/Library/Application\ Support/TextMate/Bundles"
begin
  Dir.chdir dir
rescue Errno::ENOENT
  puts "Bundles directory doesn't exist... creating it!"
  puts
  
  `mkdir -p '#{dir}'`
  retry
end

Dir.entries('.').each do |e|
  next if e =~ /^\./
  next unless File.directory? e
  
  bundle_name = e.gsub(/.tmbundle$/, '')

  print "* #{bundle_name}: "

  if bundles.delete bundle_name
    puts "bundle exists, updating"
    `cd #{cleanup e}; git pull origin master; cd ..;`
    
  else
    print "don't know about this bundle.  Delete it? [y/N] "

    while answer = gets
      if answer =~ /^y/
        `rm -rf #{cleanup e}`
        puts "  * deleted"
        break
      elsif answer =~ /^(n|$)/
        break
      else
        print "Please enter 'y' or 'n': "
      end
    end
  end
end

bundles.each do |name, source|
  puts "* #{name} doesn't exist; fetching..."
  cmd = "git clone #{github_root}/#{source} #{cleanup name}.tmbundle"
  `#{cmd}`.match(/(revision \d+)/)
  puts "  * checked out #{$1}"
end

`arch -i386 osascript -e 'tell app "TextMate" to reload bundles'`
module SettingsHelper
   
  def split_str(str, len = 10)
    fragment = /.{#{len}}/
    str.split(/(\s+)/).map! { |word|
      (/\s/ === word) ? word : word.gsub(fragment, '\0<br />')
    }.join
  end
end
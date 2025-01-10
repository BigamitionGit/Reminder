#!/usr/bin/env ruby

require 'nokogiri'
require 'json'

def parse_android_strings(file_path)
    doc = File.open(file_path) { |f| Nokogiri::XML(f) }
    strings = {}
    doc.css('resources > *').each do |node|
        if node.name == 'string'
            strings[node['name']] = node.text
        elsif node.name == 'string-array'
            node.css('item').each_with_index do |item, index|
                strings["#{node['name']}_#{index}"] = item.text
            end
        end
        end
        strings
    end

def convert_string_value(value)
    value.gsub('%s', "%@").gsub('$s', '$@')
end

def create_xcstrings(ja_strings, en_strings)
    xcstrings = {
        "sourceLanguage" => "en",
        "strings" => {},
        "version" => "1.0"
    }

    (ja_strings.keys | en_strings.keys).each do |key|
        xcstrings["strings"][key] = {
            "extractionState" => "manual",
            "localizations" => {
                "en" => {
                    "stringUnit" => {
                        "state" => "translated",
                        "value" => convert_string_value(en_strings[key] || "")
                    }
                },
                "ja" => {
                    "stringUnit" => {
                        "state" => "translated",
                        "value" => convert_string_value(ja_strings[key] || "")
                    }
                }
            }
        }
    end

    xcstrings
end

# android strings.xml
input_ja_string_file = ARGV[0]
input_en_string_file = ARGV[1]
# ios ocalizable.xcstrings
output_string_file = ARGV[2]

ja_strings = parse_android_strings(input_ja_string_file)
en_strings = parse_android_strings(input_en_string_file)

# Localizable.xcstringsを生成
xcstrings = create_xcstrings(ja_strings, en_strings)

File.open(output_string_file, 'w') do |f|
    f.write(JSON.pretty_generate(xcstrings))
end

puts "Localizable.xcstrings has been generated successfully."
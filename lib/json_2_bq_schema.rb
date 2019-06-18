#Reference
# This is modified code to run on a single JSON object and create BQ Schema
# - https://gist.github.com/igrigorik/83334277835625916cd6

require 'json'
require 'date'
# References
# - https://developers.google.com/bigquery/preparing-data-for-bigquery#dataformats
# - https://developers.google.com/bigquery/docs/data#nested
#
class Json2BqSchema

def self.type(t)
  return 'FLOAT'    if t.is_a?(Float)
  return 'INTEGER'  if t.is_a?(Integer)
  if t.is_a?(String)
    timestamp = DateTime.parse(t) rescue nil
    string_or_timestamp = (timestamp == nil ? nil : /(\d{2,4}-\d{2}-\d{2,4}(\W|T)\d{2}\:\d{2})/.match(t))
    return string_or_timestamp == nil ? 'STRING' : 'TIMESTAMP'
  end
  return 'BOOLEAN'  if t.is_a?(TrueClass) || t.is_a?(FalseClass)
  return 'RECORD'   if t.is_a?(Hash)
  return type(t.first) if t.is_a?(Array)

  puts "Unknown type for #{t}, #{t.class}"
  raise Exception
end

def self.mode(e)
  if e.is_a? Array
    'REPEATED'
  else
    'NULLABLE'
  end
end

def self.traverse(target, event)
  event.each_pair do |k,v|
    desc = target.find {|e| e['name'] == k} || {}
    target << desc if desc.empty?

    desc['name'] = k

    # Note: we skip empty REPEATED fields until we encounter a non-empty one.
    # This may result in empty REPEATED declarations, which will be rejected
    # by BigQuery... You'll have to handle this on your own.
    next if v.nil? || (v.is_a?(Array) && v.first.nil?)

    desc['type'] = type(v)
    desc['mode'] = mode(v)

    if desc['type'] == 'RECORD'
      desc['fields'] ||= []
      v = [v] if desc['mode'] != 'REPEATED'

      v.each do |e|
        traverse(desc['fields'], e) unless e.nil?
      end
    end
  end
end

def self.check(target)
    target.each do |field|
      if !(field.has_key?('name') && !field['name'].nil? &&
           field.has_key?('type') && !field['type'].nil?)
  
        STDERR.puts "Warning: #{field} has an unknown type."
        field['type'] = 'STRING'
        field['mode'] = 'NULLABLE'
      end
  
      if field['fields']
        check(field['fields'])
      end
    end
  end

  def self.convert(file) 
    @fields = []

    # JSON.parse(file) do |event|
      traverse(@fields, JSON.parse(file))
    # end

    check(@fields)
    puts JSON.pretty_generate(@fields)
    # puts Yajl::Encoder.encode(@fields, :pretty => true)
  end

end

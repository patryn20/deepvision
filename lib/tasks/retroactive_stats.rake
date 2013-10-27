namespace :retroactive_stats do
  desc "Generate past stats for disk reads and writes per second."
  task disk_io_rate: :environment do
    @r = LovelyRethink.db

    previous_longterm = nil
    @r.table('longterm').map(
        lambda { |row|
          return row.pluck(row.keys().filter(
             lambda { |key|
               return key.match("^Disk\..*\.reads$").or(key.match("^Disk\..*\.writes$"))
             }
         )).merge(row.pluck("timestamp", "id", "apikey"))
        }
    ).order_by("id").run.each do |longterm|
      puts "Updating #{longterm['id']}"

      longterm['Disk.total.reads_ps'] = Longterm.calculate_disk_read_rate longterm, previous_longterm
      longterm['Disk.total.writes_ps'] = Longterm.calculate_disk_write_rate longterm, previous_longterm
      puts longterm
      @r.table('longterm').get(longterm['id']).update(longterm, {durability: 'soft'}).run

      if !previous_longterm.nil? && previous_longterm["apikey"] != longterm["apikey"]
        previous_longterm = nil
      else
        previous_longterm = longterm
      end
    end
  end

end

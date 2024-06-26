import datetime
import os
from collections import defaultdict, Counter

class ReportGenerator:

  def __init__(self):
    self.lines = []
    self.output_file_prefix = datetime.datetime.now().strftime("%Y%m%d-%H%M%S")
    self.file_path = '/var/log/sftp.log'
    self.output_file = os.path.join(f"/home/vagrant/reports/{self.output_file_prefix}_report.txt")
    self.grouped_lines = defaultdict(Counter)

  def read_file(self, file_path):
    with open(file_path, 'r') as f:
      for line in f:
        split_line = line.strip().split('|')
        # Validate lines
        if len(split_line) == 3:
          self.lines.append(split_line)        
  
  def build_lines(self):
    #for file_path in self.file_paths():
      self.read_file(self.file_path)

  def group_by_host_name(self):
    for item in self.lines:
      key = item[2]
      value = item[0]
      self.grouped_lines[key][value] += 1

  def generate_report(self):
    with open(self.output_file, 'w') as f:
      for ip_address, counter in self.grouped_lines.items():
        total_count = sum(counter.values())
        output_line = f"Ip address - {ip_address} interacted count is {total_count}\n"
        f.write(output_line)


object = ReportGenerator()
object.build_lines()
object.group_by_host_name()
print(object.generate_report())
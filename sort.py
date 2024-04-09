import os
import csv
from collections import defaultdict

# Path to the directory containing the CSV files
folder_path = "../FICHIERS/SYNAPSE/workspace/VendingMachines"

# Dictionary to store the data sorted in alphabetical order
item_data = defaultdict(list)

# To iterate through all CSV files in the directory
for file_name in os.listdir(folder_path):
    if file_name.endswith(".csv"):
        file_path = os.path.join(folder_path, file_name)
        with open(file_path, "r", newline="") as csv_file:
            csv_reader = csv.reader(csv_file)
            next(csv_reader)  # Ignorer la première ligne
            for row in csv_reader:
                if row[0] != "None":
                    item_data[row[0]].append(row[1:])  # Add the line to the information list of the corresponding item

# Sort the data of each item alphabetically
output_data = []
for item_name in sorted(item_data.keys()):
    item_info = item_data[item_name]
    # Sort the information of each item in ascending order based on the purchase price
    item_info.sort(key=lambda x: (x[0] == "Buy", int(x[1])))
    # Add all lines for each item sorted by purchase price
    output_data.extend([[item_name, row[0], row[1]] for row in item_info])

# Write the output data into a new CSV file
output_file_path = "sort.csv"
with open(output_file_path, "w", newline="") as csv_file:
    csv_writer = csv.writer(csv_file)
    csv_writer.writerow(["Item Name", "Selling Mode", "Item Price"])
    csv_writer.writerows(output_data)


# I don't know what it is, it's from so long ago, probably not very useful
def verifie(tab):
    for i in range(0,len(tab)-1):
        if tab[i+1] < tab[i]:
            return False
    return True

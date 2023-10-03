#!/bin/bash
#SBATCH --job-name=node_script
#SBATCH --output=node_script_output.log
#SBATCH --error=node_script_error.log
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --time=6:00:00  # Specify the time limit in HH:MM:SS format
#SBATCH --partition=your_partition  # Specify the partition/queue

# Get the current date and time in the format 'yyyymmddhh'
current_datetime=$(date +"%Y%m%d%H")

# Calculate the closest past hour (00, 06, 12, or 18)
current_hour=$(date +"%H")
if [ $current_hour -ge 18 ]; then
    closest_hour=18
elif [ $current_hour -ge 12 ]; then
    closest_hour=12
elif [ $current_hour -ge 06 ]; then
    closest_hour=06
else
    closest_hour=00
fi

# Combine the date and closest past hour to get the desired timestamp
desired_datetime="${current_datetime:0:8}${closest_hour}"

# Load wgrib2 module
module use /contrib/spack-stack/envs/ufswm/install/modulefiles/Core/
module load stack-intel
module load wgrib2

# Activate conda environment
source activate graphcast
cd /contrib/Sadegh.Tabas/graphcast/

# Execute the gdas utility Python script with the desired timestamp
python gdas_utility.py "$desired_datetime" "$desired_datetime" -k no

# Execute the graphcast Python script
python graphcast.py

# Print a message indicating the job is done
echo "Job completed for timestamp $desired_datetime"

#/bin/bash 

simulation=$1
reso=$2
hubble=$3

echo " " 
echo " >> CLEANING DIRECTORY! (3sec) " 
echo " " 

sleep 3 

rm constr.f grafic.inc 
rm grafic 
rm p3m*

cp /home/harre/simulations/gadget-structure-formation/$reso/$hubble/$simulation/grafic_inc_$simulation.f grafic.inc 
cp /home/harre/simulations/gadget-structure-formation/$reso/$hubble/$simulation/constraints_$simulation.f constr.f 

echo " " 
echo " >> DOING h70 PART" 
echo " " 

rm power.f grafic.f 

cp power_h70.f power.f
cp grafic_h70.f grafic.f 

module load intel/64/12.1 

make clean 
make 

cp grafic grafic_h70 

echo " " 
echo " >> DOING h100 PART" 
echo " " 

rm power.f grafic.f 

cp power_h100.f power.f
cp grafic_h100.f grafic.f 

make clean 
make 

cp grafic grafic_h100

cat /home/harre/simulations/gadget-structure-formation/$reso/$hubble/$simulation/graficIO_$simulation.out | grep "chosen" 
 
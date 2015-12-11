if(sumPower <= 0.656505) {
if(variation <= 0.570545) {
if(balance <= 0.422702) {
if(energyDiffs <= 0.298185) {
return 1;//: false (29.0/1.0)
}
if(energyDiffs > 0.298185) {
if(energyDiffs <= 0.331309) {
return 0;//true (6.0/1.0)
}
if(energyDiffs > 0.331309) {
return 1;//: false (3.0)
}
}
}
if(balance > 0.422702) {
if(balance <= 0.443866) {
if(loudVals <= 0.15625) {
return 0;//: true (6.0/1.0)
}
if(loudVals > 0.15625) {
return 1;//: false (2.0)
}
}
if(balance > 0.443866) {
return 0;//: true (12.0)
}
}
}
if(variation > 0.570545) {
return 1;//: false (63.0)
}
}
if(sumPower > 0.656505) {
return 0;//: true (79.0/2.0)
}

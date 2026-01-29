#!/usr/bin/env bash
set -euo pipefail

if [ $# -ne 1 ]; then
  echo "Usage: $0 <basename>  (e.g. glc_0001)"
  exit 1
fi
BASE=$1

# AmberTools
antechamber -i ${BASE}.sdf -fi sdf -o ${BASE}.mol2 -fo mol2 -c bcc -s 2
parmchk2 -i ${BASE}.mol2 -f mol2 -o ${BASE}.frcmod

cat > tleap_${BASE}.in <<TLEAP
source leaprc.gaff2
mol = loadmol2 ${BASE}.mol2
loadamberparams ${BASE}.frcmod
saveamberparm mol ${BASE}.prmtop ${BASE}.inpcrd
quit
TLEAP

tleap -f tleap_${BASE}.in

# prmtop -> LAMMPS data
python - <<PY
from parmed import load_file
p = load_file('${BASE}.prmtop', '${BASE}.inpcrd')
p.save('${BASE}.lmp', format='lammps')
PY

# LAMMPS 実行（テンプレート in.minimize と in.nvt_relax を用意しておくこと）
lmp -in in.minimize -var DATAFILE ${BASE}.lmp -log log.${BASE}.min
lmp -in in.nvt_relax -var DATAFILE ${BASE}.lmp -log log.${BASE}.nvt

# 簡易メタデータ出力（ログ解析は環境に合わせて調整）
python3 - <<PY
import json, re
base='${BASE}'
def extract_energy(logfile):
    e=None
    try:
        with open(logfile) as f:
            for line in f:
                if 'Total Energy' in line or 'Total energy' in line:
                    m=re.search(r'([-+]?\d+\.\d+)', line)
                    if m:
                        e=float(m.group(1))
    except FileNotFoundError:
        pass
    return e

lammps_e = extract_energy(f'log.{base}.nvt')
metadata = {
    "id": base,
    "lammps_single_point": lammps_e
}
with open(f'{base}_metadata_partial.json','w') as fo:
    json.dump(metadata, fo, indent=2)
print('Wrote', f'{base}_metadata_partial.json')
PY

echo "Pipeline for ${BASE} finished. Check logs and ${BASE}_metadata_partial.json"

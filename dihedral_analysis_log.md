### Final verification runs 2026-01-27T11:17+09:00

- **Action**: Extracted dihedral coeffs from `log.lammps` into `coeffs.txt` and ran controlled tests to isolate dihedral contributions.
- **Commands used (representative)**:
  - `sed -E 's/^[[:space:]]*dihedral_coeff/# &/I' coeffs.txt.bak > coeffs.txt`
  - `awk` / `sed` を用いて `include coeffs.txt` を `dihedral_style` の直後に挿入
  - `"/home/wnerkoga/.local/bin/lmp" -in in.dimer_glc.coeffs_only.tmp5 > lammps_coeffs_only5.log 2>&1`
  - `"/home/wnerkoga/.local/bin/lmp" -in in.dimer_glc > lammps_final_verify.log 2>&1`
- **Observed dihedral energies (c_cPE)**:
  - in.dimer_glc only (Python re-calc): **228.944961 kcal·mol⁻¹**
  - coeffs only (coeffs.txt included): **253.94479 kcal·mol⁻¹**
  - both (original input + data): **253.94479 kcal·mol⁻¹**
- **Interpretation**: Difference C − A ≈ **25.0 kcal·mol⁻¹** corresponds to the coeffs-derived contribution. When both sources are present, dihedral terms are effectively applied twice; to avoid double-counting, keep dihedral definitions in only one place.
- **Files and hashes**:
  - `in.dimer_glc`: `2c605c403626a9c3a81ea8252adbb70e4f4021aeddcd4035a447f786cc872c85`
  - `in.dimer_glc.coeffs_only.tmp5`: `fa89bc0e7d968ef38aa95130ebb3bb9fbe4862b9bb31e3a5c30d09cc76a0a905`
  - `lammps_coeffs_only5.log`: `e1080870facb70be32a13765a0a8b06504aa6d653d00a76b146cc08b62d74552`
  - `coeffs.txt`: `01f93fd6edbfe40729c9b2b753c8fc7cbd765399b368bc2f7440fbadf72750ca`
  - `lammps_final_verify.log`: `5bf17e3739768f38996615dd84a44db70ad9fc26c8520bed08b8b0089f615af4`
  - `glc_dimer_v3.data`: `3310332240c57231841b4b781d0ad76fee5e3924b2694e6baf75b8165004aa55`
- **Note**: `dihedral_write` は現在の LAMMPS ビルドでサポートされていないため一時的にコメント化して検証を行った。`dihedral_write` を使う必要がある場合は対応パッケージを有効にしたビルドが必要。

### 最終検証 2026-01-27T11:17+09:00

- **実施内容**: `log.lammps` から抽出した dihedral coeffs を `coeffs.txt` にまとめ、入力側と coeffs 側の寄与を分離するための制御実行を行った。
- **代表コマンド**:
  - `sed -E 's/^[[:space:]]*dihedral_coeff/# &/I' coeffs.txt.bak > coeffs.txt`
  - `awk` を用いて `include coeffs.txt` を `dihedral_style` の直後に挿入
  - `"/home/wnerkoga/.local/bin/lmp" -in in.dimer_glc.edit > lammps_after_uncomment.log 2>&1`
- **観測された dihedral エネルギー (c_cPE)**:
  - in.dimer_glc only (Python 再計算): **228.944961 kcal·mol⁻¹**
  - coeffs only (coeffs.txt 読込): **253.94479 kcal·mol⁻¹**
  - both (元入力 + data): **253.94479 kcal·mol⁻¹**
- **解釈**: 差分 C − A ≈ **25.0 kcal·mol⁻¹** は coeffs 側の寄与に相当する。両方を有効にすると dihedral 項が重複して適用されるため、**どちらか一方のみを有効にする**必要がある。
- **ファイルとハッシュ**:
  - `in.dimer_glc.edit`: `fa89bc0e7d968ef38aa95130ebb3bb9fbe4862b9bb31e3a5c30d09cc76a0a905`
  - `lammps_after_uncomment.log`: `a93dea207000d7c6db0cc9fc39f8b30caac6c1e2c7f7baaa09c9afbc1262d039`
  - `coeffs.txt`: `6bd5a119967bd029b1158b70cb0db81592f81ef023dbd935b49f7e6cc11bca4b`
- **備考**: `dihedral_write` は現在の LAMMPS ビルドで未サポートのためコメント化して検証を行った。将来的に `dihedral_write` を使用する場合は対応パッケージを有効にしたビルドが必要。

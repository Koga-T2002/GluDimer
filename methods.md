# Methods

## v3 Summary
- 目的: 糖二量体のポテンシャル検証と LAMMPS での挙動確認
- 手順:
  1. AmberTools で原子タイプと部分電荷を推定（antechamber）
  2. 不足パラメータを補完（parmchk2）
  3. tleap で prmtop/inpcrd を作成
  4. parmed で prmtop → LAMMPS data に変換
  5. LAMMPS で最小化、短時間緩和、必要に応じて角度スキャン
  6. AmberTools と LAMMPS のエネルギー比較、RMSD による構造安定性評価

## v3 Key Findings
- LAMMPS と AmberTools のエネルギー整合は概ね良好
- 一部 dihedral の扱いで差異が見られ、パラメータ調整で改善
- 最小化と短時間緩和で多くの候補が安定化

## v4 Evaluation Criteria
- 対象: 四糖・五糖の代表的枝分かれパターン（数十分子規模）
- 合格基準:
  - 最小化後のエネルギー収束が安定（エネルギー変化閾値を設定）
  - AmberTools と LAMMPS の単点エネルギー差が許容範囲内（例: < 5 kcal/mol）
  - 緩和後の RMSD が安定（最後 10 ps の標準偏差 < 0.2 Å を目安）
  - parmchk2 による補完パラメータが過度でない（補完項目数の閾値を設定）
- 出力フォーマット:
  - 各分子に対して prmtop/inpcrd, LAMMPS data, log.lammps, energy_curve.csv, rmsd.csv, metadata.json を保存
- 自動化要件:
  - 1分子のフルパイプラインがスクリプトで実行可能であること
  - 失敗時にログとエラーコードを残すこと

## Reproducibility Notes
- 実行環境（AmberTools, LAMMPS のバージョン）を明記すること
- 全てのコマンドと入力ファイルは methods.md に記載し、サンプルをリポジトリに置く

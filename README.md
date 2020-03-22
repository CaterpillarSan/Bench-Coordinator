# BenchmarkをDCatch-DAGに食わせるまで

## 使い方
このdirectory配下に, 以下のリポジトリをcloneしてください.


- [DCatch-DAG](https://github.com/CaterpillarSan/DCatch-DAG)
- [Benchmark](https://github.com/CaterpillarSan/Benchmark)
- [MapReduceTracer](https://github.com/CaterpillarSan/MapReduceTracer)
- [PocketRacer](https://github.com/CaterpillarSan/PocketRacer)

## コマンド集

### DCatch
1. ```make dcatch-setup```
rmiregistryの起動，ベンチマークアプリのコンパイル, 計装エンジンのコンパイルと実行を行う.

2. ```make run-bench-dcatch NODEID=1```
計装したベンチマークを1プロセス実行する.
使用するときは．tmux等の*複数窓で同時に*走らせる.
このとき`NODEID`を固有の値とする. (1, 2, 3,...などの小さい値が望ましい. 50000+NODEIDをポート番号としてそのまま使用する.)

3. ```make dcatch```
2で集計した実行ログを元にdcatchアルゴリズムを適用. 
計算結果は, `make view-graph` や `make view-thread` で可視化できるほか, 多分標準出力に色々流れているはず.

4. ```make rmi-off```
rmiregistryを終了する.


### PocketRacer
1. ```make pocket-setup```
ベンチマークアプリのコンパイル, PocketRacerメタデータライブラリのコンパイル, 計装エンジンのコンパイルと実行を行う.

2. ```make run-bench-pocketracer NODEID=1```
計装したベンチマークを1プロセス実行する.
使用するときは．tmux等の*複数窓で同時に*走らせる.
このとき`NODEID`を固有の値とする. (1, 2, 3,...などの小さい値が望ましい. 50000+NODEIDをポート番号としてそのまま使用する.)
ログはPocketRacer/log に出力される．

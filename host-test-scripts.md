# Test Host Scripts

```
wget https://speed.cloudflare.com/__down\?bytes\=10000000000000 -O /dev/null
```

```
apt install -y p7zip-full
单线程测试： 7z b -mmt1 
多线程测试： 7z b
```

### LemonBench



```
# 快速测试
$ curl -fsL https://ilemonra.in/LemonBenchIntl | bash -s fast
# 完整测试
$ curl -fsL https://ilemonra.in/LemonBenchIntl | bash -s full
```

### 秋水逸冰

#### Linux 性能测试 UnixBench

```
$ wget --no-check-certificate https://raw.githubusercontent.com/teddysun/across/master/unixbench.sh
$ bash unixbench.sh
```

#### bench.sh

```
$ curl -Lso- bench.sh | bash

$ wget --no-check-certificate https://raw.githubusercontent.com/teddysun/across/master/bench.sh
$ bash bench.sh
```

#### yet-another-bench-script

```
curl -sL yabs.sh | bash
```

### 流媒体测试

```
$ bash <(curl -L -s check.unlock.media) -M 4
# IPv6
$ bash <(curl -L -s check.unlock.media) -M 6
```

### Reference
1. [Teddysun-Across--Across the Great Wall we can reach every corner in the world](https://github.com/teddysun/across)
2. [yet-another-bench-script](https://github.com/masonr/yet-another-bench-script)
3. [LemonBench: A simple Linux Benchmark Toolkit ](https://github.com/LemonBench/LemonBench)
4. [Serverreview Benchmark Script v3 ](https://github.com/sayem314/serverreview-benchmark)
5. [91云服务器一键测试包](https://github.com/91yun/91yuntest)
6. [ZBench](https://github.com/FunctionClub/ZBench)
7. [superspeed 全国各地测速节点的一键测速脚本](https://github.com/ernisn/superspeed)
8. [Superspeed Superbench](https://github.com/oooldking/script)
9. [流媒体解锁检测](https://github.com/lmc999/RegionRestrictionCheck)

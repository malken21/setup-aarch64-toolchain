# setup-aarch64-toolchain

AArch64 Linux をターゲットとした開発ツール(as, ld 等)を GitHub Actions ランナー上で直接利用可能にする Action です。

> [!IMPORTANT]
> この Action は **AArch64 (ARM64) アーキテクチャの GitHub Actions ランナー** (`ubuntu-24.04-arm`) でのみ動作します。x86_64 ランナーでは動作しません。

## 含まれるツール
- `binutils` (as, ld, nm, objcopy, objdump, readelf, size, strip, ar, ranlib)

## 使い方

AArch64 アーキテクチャのランナー (`ubuntu-24.04-arm`) を指定して実行してください。

```yaml
jobs:
  build:
    runs-on: ubuntu-24.04-arm
    steps:
      - uses: actions/checkout@v6

      - name: Setup AArch64 Toolchain
        uses: malken21/setup-aarch64-toolchain@v1

      - name: Assemble and Link AArch64 Assembly
        run: |
          as -o main.o main.s
          ld -o main main.o
```

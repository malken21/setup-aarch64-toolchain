# setup-aarch64-toolchain

AArch64 Linux をターゲットとした開発ツール（as, ld 等）を GitHub Actions ランナー上で直接利用可能にする Action です。
Nix で構築された極小の Docker イメージをバックエンドとして使用し、ホスト環境の PATH にツールのラッパー（Shim）を自動的にセットアップします。

> [!IMPORTANT]
> この Action は **AArch64 (ARM64) アーキテクチャの GitHub Actions ランナー**（`ubuntu-24.04-arm`）でのみ動作します。x86_64 ランナーでは動作しません。


## 特徴
- **ホストからの透過的な実行**: `as` や `ld` をコンテナを意識せずに `- run:` ステップから直接呼び出せます。
- **軽量・高速**: Nix を活用した極小（Minimal）イメージを使用。
- **環境分離**: ツールは Docker コンテナ内で実行されるため、ホスト環境を汚しません。

## 含まれるツール
- `binutils` (as, ld, nm, objcopy, objdump, readelf, size, strip, ar, ranlib)

## 使い方

AArch64 アーキテクチャのランナー（`ubuntu-24.04-arm`）を指定して実行してください。

```yaml
jobs:
  build:
    runs-on: ubuntu-24.04-arm
    steps:
      - uses: actions/checkout@v6

      - name: Setup AArch64 Toolchain
        uses: malken21/setup-aarch64-toolchain@main

      - name: Compile AArch64 Assembly
        run: |
          as -o main.o main.s
          ld -o main main.o
```

## ビルド方法 (開発者向け)

### Nix を使用する場合
Nix Flakes を使用して、依存関係を最小限に抑えた極小の Docker イメージを生成します。

```bash
# x86_64 環境で AArch64 イメージをビルド（クロスコンパイル）
nix build .#packages.x86_64-linux.default

# イメージを Docker にロード
docker load < result
```

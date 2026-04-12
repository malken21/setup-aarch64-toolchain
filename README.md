# setup-aarch64-toolchain

AArch64 Linux をターゲットとした開発ツール（as, ld 等）を GitHub Actions ランナー上で直接利用可能にする Action です。
Nix で構築された極小の Docker イメージをバックエンドとして使用し、ホスト環境の PATH に自動的にツールをセットアップします。

## 特徴
- **ホスト上での直接実行**: `as` や `ld` をコンテナを意識せずに `- run:` ステップから直接呼び出せます。
- **軽量・高速**: Nix を活用した Distroless イメージを使用。
- **環境分離**: ツールは Docker コンテナ内で実行されるため、ホスト環境を汚しません。

## 含まれるツール
- `binutils` (as, ld, nm, objcopy, objdump, readelf, size, strip, ar, ranlib)

## 使い方

```yaml
- name: Setup AArch64 Toolchain
  uses: malken21/setup-aarch64-toolchain@main

- name: Compile AArch64 Assembly
  run: |
    as -o main.o main.s
    ld -o main main.o
```

## ビルド方法 (開発者向け)

### Nix を使用する場合
Nix Flakes を使用して、OS を含まない極小の Docker イメージを生成します。

```bash
# x86_64 環境で AArch64 イメージをビルド（クロスコンパイル）
nix build .#packages.x86_64-linux.default

# イメージを Docker にロード
docker load < result
```

## Fakebakka

フェイクニュースを共有するためのiOSアプリ「Fakebakka」です。
Fakebakkaでは、フェイクニュースをユーザーが作成し、共有し、リアクションすることができます。
当プロジェクトはSwiftの独学を行いながら開発しています。

## コードの実行方法

Xcodeのプロジェクトなので、Xcodeでフォルダ`fakebakka`を開くことでプロジェクトを生成し実行することができます。

## 問題点

- ログアウト後の画面において、navbarとtabbarの境界線が消えない問題
- データをアップロードの際にパフォーマンスの低下する問題
- Djangoで作成した外部APIの呼び出しを行うことができていない問題

## 要件定義

- Firebaseの使用
- ログイン画面
- 登録画面
- パスワード再設定画面
- 投稿画面
- ホーム画面
- 詳細画面
- プロフィール画面
- プロフィール閲覧機能
- goodとbad機能の設置
- navbarとtabbarの設置
- 各種リンク
- 共有機能の設置
- ローディング画面
- 報告機能
- 退会機能

## 外部設計

- 色合いは黒と白をベース
- ボタンを押した際のアニメーション
- エラー発生時はポップアップの表示

## 内部設計

- FirebaseをDBとして利用する
- ユーザーの作成からその他データの格納までを行う
- Djangoを使用した外部APIの呼び出しにて外部へのデータ送受信を行う

## アップデート予定

- 0.0v 2022年05月20日現在
- 1.0v 外部APIの呼び出しの実装
  - APIのホーム画面の設定
  - navbarとtabbarの境界線の削除
  - 細かい修正
  - Googleアカウントログインの設置

## 公式サイト

[公式サイト](公式リンク)

## 公式アカウント

[公式アカウント](公式アカウント)
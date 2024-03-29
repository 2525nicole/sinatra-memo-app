これは[FJORD BOOT CAMP](https://bootcamp.fjord.jp/)の提出物として作成したメモアプリです📝

課題名: Sinatra を使ってWebアプリケーションの基本を理解する

# sinatra_memo_app

## 説明
このアプリを使えばいつでもメモを登録、確認、削除することができます。

登録済みのメモの内容編集も可能です✏️

## 利用手順

1. このリポジトリをクローンする

`$ git clone git@github.com:2525nicole/sinatra-memo-app.git`

2. リポジトリに入る

`$ cd sinatra-memo-app`

3. Gemをインストールする

`$ bundle install`

4. メモの保存先になるデータベースを準備する

- PostgreSQLを起動し、データベース`memo_app`を作成する

```
create database memo_app;
```

- データベース`memo_app`に`memos`テーブルを作成する

```
CREATE TABLE memos (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY (id)
);
```

5. `app.rb`を実行する

`$ ruby app.rb`

6. ブラウザで以下にアクセスする

`http://localhost:4567/memos`

### メモを登録する

[トップページ](http://localhost:4567/memos)で「メモを登録する」を押下し、タイトルと本文を入力する

[![Image from Gyazo](https://i.gyazo.com/550c1d3a83943f2e76ad43db71bb1e9a.gif)](https://gyazo.com/550c1d3a83943f2e76ad43db71bb1e9a)


### メモの内容を確認する

[トップページ](http://localhost:4567/memos)でメモのタイトルを押下する

[![Image from Gyazo](https://i.gyazo.com/2a7b91fa96773281dc8f4015bd720a03.gif)](https://gyazo.com/2a7b91fa96773281dc8f4015bd720a03)


### メモの内容を編集する

メモの内容確認画面で「メモを編集する」を押下し、編集する

[![Image from Gyazo](https://i.gyazo.com/d5c9aa99d12b00e7ec9d6eac2d6e7173.gif)](https://gyazo.com/d5c9aa99d12b00e7ec9d6eac2d6e7173)


### メモを削除する

メモの内容確認画面で「メモを編集する」を押下し、編集する

[![Image from Gyazo](https://i.gyazo.com/aabae616adcb7e1719dc123aed6f2d3f.gif)](https://gyazo.com/aabae616adcb7e1719dc123aed6f2d3f)

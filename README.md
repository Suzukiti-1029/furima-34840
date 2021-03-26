# テーブル設計

## usersテーブル

| Column             | Type    | Option                |
| ------------------ | ------- | --------------------- |
| nickname           | string  | NOT NULL              |
| email              | string  | NOT NULL, unique:true |
| encrypted_password | string  | NOT NULL              |
| first_name         | string  | NOT NULL              |
| last_name          | string  | NOT NULL              |
| first_name_detail  | string  | NOT NULL              |
| last_name_detail   | string  | NOT NULL              |
| birthday           | date    | NOT NULL              |

### Association

- has_many :items
- has_many :histories

## itemsテーブル

| Column         | Type       | Option            |
| -------------- | ---------- | ----------------- |
| name           | string     | NOT NULL          |
| describe       | text       | NOT NULL          |
| category_id    | integer    | NOT NULL          |
| situation_id   | integer    | NOT NULL          |
| fare_option_id | integer    | NOT NULL          |
| prefecture_id  | integer    | NOT NULL          |
| need_days_id   | integer    | NOT NULL          |
| fee            | integer    | NOT NULL          |
| user           | references | foreign_key: true |

**※ imageカラムはActiveStorageで実装**

### Association

- belongs_to :user
- has_one :histories

- belongs_to :category
- belongs_to :situation
- belongs_to :fare_option
- belongs_to :prefecture
- belongs_to :need_days

## historiesテーブル

| Column        | Type       | Option            |
| ------------- | ---------- | ----------------- |
| user          | references | foreign_key: true |
| item          | references | foreign_key: true |

### Association

- belongs_to :user
- belongs_to :history

## residencesテーブル

| Column        | Type       | Option            |
| ------------- | ---------- | ----------------- |
| area_number   | string     | NOT NULL          |
| prefecture_id | integer    | NOT NULL          |
| city          | string     | NOT NULL          |
| address       | string     | NOT NULL          |
| building      | string     |                   |
| phone_number  | string     | NOT NULL          |

### Association

- belongs_to :prefecture


# ActiveHash

## categoryモデル(クラス)

{id: , name: }

1. --
2. レディース
3. メンズ
4. ベビー・キッズ
5. インテリア・住まい・小物
6. 本・音楽・ゲーム
7. おもちゃ・ホビー・グッズ
8. 家電・スマホ・カメラ
9. スポーツ・レジャー
10. ハンドメイド
11. その他

### Association

- has_many :items(category_id)

## situationモデル(クラス)

{id: , name: }

1. --
2. 新品、未使用
3. 未使用に近い
4. 目立った傷や汚れなし
5. やや傷や汚れあり
6. 傷や汚れあり
7. 全体的に状態が悪い

### Association

- has_many :items(situation_id)

## fare_optionモデル(クラス)

{id: , name: }

1. --
2. 着払い(購入者負担)
3. 送料込み(出品者負担)

### Association

- has_many :items(fare_option_id)

## prefectureモデル(クラス)

{id: , name: }

1. --
2. 北海道

....
48. 沖縄県

### Association

- has_many :items(leave_area_id)
- has_many :purchases(prefecture_id)

## need_daysモデル(クラス)

{id: , name: }

1. --
2. 1~2日で発送
3. 2~3日で発送
4. 4~7日で発送

### Association

- has_many :items(need_days_id)

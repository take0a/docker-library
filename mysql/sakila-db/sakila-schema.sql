-- Sakila Sample Database Schema
-- Version 1.5

-- Copyright (c) 2006, 2024, Oracle and/or its affiliates.

-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions are
-- met:

-- * Redistributions of source code must retain the above copyright notice,
--   this list of conditions and the following disclaimer.
-- * Redistributions in binary form must reproduce the above copyright
--   notice, this list of conditions and the following disclaimer in the
--   documentation and/or other materials provided with the distribution.
-- * Neither the name of Oracle nor the names of its contributors may be used
--   to endorse or promote products derived from this software without
--   specific prior written permission.

-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
-- IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
-- THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
-- PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
-- CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
-- EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
-- PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
-- PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
-- LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
-- NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
-- SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

SET NAMES utf8mb4;
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

DROP SCHEMA IF EXISTS sakila;
CREATE SCHEMA sakila;
USE sakila;

--
-- Table structure for table `actor`
--

CREATE TABLE actor (
  actor_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'テーブル内の各俳優を一意に識別するために使用される代理主キー。',
  first_name VARCHAR(45) NOT NULL COMMENT '俳優の名。',
  last_name VARCHAR(45) NOT NULL COMMENT '俳優の姓。',
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '行が作成された日時または最後に更新された日時。',
  PRIMARY KEY  (actor_id),
  KEY idx_actor_last_name (last_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='actor テーブルには、すべての俳優の情報がリストされます。\nactor テーブルは、film_actor テーブルによって film テーブルに結合されています。';

--
-- Table structure for table `address`
--

CREATE TABLE address (
  address_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'テーブル内の各住所を一意に識別するために使用される代理主キー。',
  address VARCHAR(50) NOT NULL COMMENT '住所の 1 行目。',
  address2 VARCHAR(50) DEFAULT NULL COMMENT '住所の 2 行目（オプション）。',
  district VARCHAR(20) NOT NULL COMMENT '住所の地域。州、県、都道府県など。',
  city_id SMALLINT UNSIGNED NOT NULL COMMENT 'city テーブルを指す外部キー。',
  postal_code VARCHAR(10) DEFAULT NULL COMMENT '住所の郵便番号（該当する場合）。',
  phone VARCHAR(20) NOT NULL COMMENT '住所の電話番号。',
  -- Add GEOMETRY column for MySQL 5.7.5 and higher
  -- Also include SRID attribute for MySQL 8.0.3 and higher
  /*!50705 location GEOMETRY */ /*!80003 SRID 0 */ /*!50705 NOT NULL,*/
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '行が作成または最後に更新された日時。',
  PRIMARY KEY  (address_id),
  KEY idx_fk_city_id (city_id),
  /*!50705 SPATIAL KEY `idx_location` (location),*/
  CONSTRAINT `fk_address_city` FOREIGN KEY (city_id) REFERENCES city (city_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='address テーブルには、顧客、スタッフ、店舗の住所情報が格納されます。\naddress テーブルの主キーは、顧客、スタッフ、店舗の各テーブルでは外部キーとして表示されます。';

--
-- Table structure for table `category`
--

CREATE TABLE category (
  category_id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'テーブル内の各カテゴリを一意に識別するために使用される代理主キー。',
  name VARCHAR(25) NOT NULL COMMENT 'カテゴリ名。',
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '行が作成された日時、または最後に更新された日時。',
  PRIMARY KEY  (category_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4  COMMENT='category テーブルは、映画に割り当てられるカテゴリをリストします。\ncategory テーブルは、film_category テーブルを介して film テーブルに結合されます。';

--
-- Table structure for table `city`
--

CREATE TABLE city (
  city_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'テーブル内の各都市を一意に識別するために使用される代理主キー。',
  city VARCHAR(50) NOT NULL COMMENT '都市名。',
  country_id SMALLINT UNSIGNED NOT NULL COMMENT '都市が属する国を識別する外部キー。',
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '行が作成または最後に更新された日時。',
  PRIMARY KEY  (city_id),
  KEY idx_fk_country_id (country_id),
  CONSTRAINT `fk_city_country` FOREIGN KEY (country_id) REFERENCES country (country_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='city テーブルには都市のリストが格納されています。\ncity テーブルは address テーブル内の外部キーによって参照され、country テーブルも外部キーによって参照されます。';

--
-- Table structure for table `country`
--

CREATE TABLE country (
  country_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'テーブル内の各国を一意に識別するために使用される代理主キー。',
  country VARCHAR(50) NOT NULL COMMENT '国名。',
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '行が作成された日時、または最後に更新された日時。',
  PRIMARY KEY  (country_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='country テーブルには国のリストが格納されます。\ncountry テーブルは、city テーブルの外部キーによって参照されます。';

--
-- Table structure for table `customer`
--

CREATE TABLE customer (
  customer_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'テーブル内の各顧客を一意に識別するために使用される代理主キー。',
  store_id TINYINT UNSIGNED NOT NULL COMMENT ' 顧客の「ホームストア」を識別する外部キー。顧客はこのストアからのみレンタルできるわけではなく、通常このストアで買い物をします。',
  first_name VARCHAR(45) NOT NULL COMMENT '顧客の名。',
  last_name VARCHAR(45) NOT NULL COMMENT '顧客の姓。',
  email VARCHAR(50) DEFAULT NULL COMMENT '顧客のメールアドレス。',
  address_id SMALLINT UNSIGNED NOT NULL COMMENT 'address テーブル内の顧客の住所を識別する外部キー。',
  active BOOLEAN NOT NULL DEFAULT TRUE COMMENT '顧客がアクティブな顧客かどうかを示します。これを FALSE に設定することで、顧客を完全に削除する代わりに使用できます。ほとんどのクエリには WHERE active = TRUE 句が必要です。',
  create_date DATETIME NOT NULL COMMENT '顧客がシステムに追加された日付。この日付は、INSERT 中にトリガーを使用して自動的に設定されます。',
  last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '行が作成された日時、または最後に更新された日時。',
  PRIMARY KEY  (customer_id),
  KEY idx_fk_store_id (store_id),
  KEY idx_fk_address_id (address_id),
  KEY idx_last_name (last_name),
  CONSTRAINT fk_customer_address FOREIGN KEY (address_id) REFERENCES address (address_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_customer_store FOREIGN KEY (store_id) REFERENCES store (store_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='customer テーブルには、すべての顧客のリストが格納されます。\ncustomer テーブルは、payment テーブルと rental テーブルから参照され、外部キーを使用して address テーブルと store テーブルを参照します。';

--
-- Table structure for table `film`
--

CREATE TABLE film (
  film_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'テーブル内の各映画を一意に識別するために使用される代理主キー。',
  title VARCHAR(128) NOT NULL COMMENT '映画のタイトル。',
  description TEXT DEFAULT NULL COMMENT '映画の短い説明またはあらすじ。',
  release_year YEAR DEFAULT NULL COMMENT '映画の公開年。',
  language_id TINYINT UNSIGNED NOT NULL COMMENT 'language テーブルを指す外部キー。映画の言語を識別します。',
  original_language_id TINYINT UNSIGNED DEFAULT NULL COMMENT 'language テーブルを指す外部キー。映画の元の言語を識別します。映画が新しい言語に吹き替えられた場合に使用されます。',
  rental_duration TINYINT UNSIGNED NOT NULL DEFAULT 3 COMMENT 'レンタル期間（日数）。',
  rental_rate DECIMAL(4,2) NOT NULL DEFAULT 4.99 COMMENT 'rental_duration 列で指定された期間の映画のレンタル料金。',
  length SMALLINT UNSIGNED DEFAULT NULL COMMENT '映画の上映時間（分）。',
  replacement_cost DECIMAL(5,2) NOT NULL DEFAULT 19.99 COMMENT '映画が返却されなかった、または破損した状態で返却された場合に顧客に請求される金額。',
  rating ENUM('G','PG','PG-13','R','NC-17') DEFAULT 'G' COMMENT '映画に割り当てられたレーティング。G、PG、PG-13、R、NC-17 のいずれかになります。',
  special_features SET('Trailers','Commentaries','Deleted Scenes','Behind the Scenes') DEFAULT NULL COMMENT 'DVD に収録されている一般的な特典映像の一覧。予告編、コメンタリー、削除シーン、舞台裏映像など、0 個以上の項目になります。',
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '行が作成された日時または最後に更新された日時。',
  PRIMARY KEY  (film_id),
  KEY idx_title (title),
  KEY idx_fk_language_id (language_id),
  KEY idx_fk_original_language_id (original_language_id),
  CONSTRAINT fk_film_language FOREIGN KEY (language_id) REFERENCES language (language_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_film_language_original FOREIGN KEY (original_language_id) REFERENCES language (language_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='film テーブルは、店舗に在庫がある可能性のあるすべての映画のリストです。各映画の実際の在庫数は inventory テーブルに保持されます。\nfilm テーブルは language テーブルを参照し、film_category、film_actor、inventory テーブルから参照されます。';

--
-- Table structure for table `film_actor`
--

CREATE TABLE film_actor (
  actor_id SMALLINT UNSIGNED NOT NULL COMMENT '俳優を識別する外部キー。',
  film_id SMALLINT UNSIGNED NOT NULL COMMENT '映画を識別する外部キー。',
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '行が作成された日時または最後に更新された日時。',
  PRIMARY KEY  (actor_id,film_id),
  KEY idx_fk_film_id (`film_id`),
  CONSTRAINT fk_film_actor_actor FOREIGN KEY (actor_id) REFERENCES actor (actor_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_film_actor_film FOREIGN KEY (film_id) REFERENCES film (film_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='film_actor テーブルは、映画と俳優間の多対多の関係をサポートするために使用されます。特定の映画に出演する俳優ごとに、film_actor テーブルに俳優と映画をリストする行が1つずつ存在します。\nfilm_actor テーブルは、外部キーを使用して映画テーブルと俳優テーブルを参照します。';

--
-- Table structure for table `film_category`
--

CREATE TABLE film_category (
  film_id SMALLINT UNSIGNED NOT NULL COMMENT '映画を識別する外部キー。',
  category_id TINYINT UNSIGNED NOT NULL COMMENT 'カテゴリを識別する外部キー。',
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '行が作成された日時または最後に更新された日時。',
  PRIMARY KEY (film_id, category_id),
  CONSTRAINT fk_film_category_film FOREIGN KEY (film_id) REFERENCES film (film_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_film_category_category FOREIGN KEY (category_id) REFERENCES category (category_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='film_category テーブルは、映画とカテゴリ間の多対多関係をサポートするために使用されます。映画に適用されるカテゴリごとに、film_category テーブルにカテゴリと映画をリストする行が1つずつ作成されます。\nfilm_category テーブルは、外部キーを使用して映画テーブルとカテゴリテーブルを参照します。';

--
-- Table structure for table `film_text`
-- 
-- InnoDB added FULLTEXT support in 5.6.10. If you use an
-- earlier version, then consider upgrading (recommended) or 
-- changing InnoDB to MyISAM as the film_text engine
--

-- Use InnoDB for film_text as of 5.6.10, MyISAM prior to 5.6.10.
SET @old_default_storage_engine = @@default_storage_engine;
SET @@default_storage_engine = 'MyISAM';
/*!50610 SET @@default_storage_engine = 'InnoDB'*/;

CREATE TABLE film_text (
  film_id SMALLINT UNSIGNED NOT NULL COMMENT 'テーブル内の各映画を一意に識別するために使用される代理主キー。',
  title VARCHAR(255) NOT NULL COMMENT '映画のタイトル。',
  description TEXT COMMENT '映画の短い説明またはあらすじ。',
  PRIMARY KEY  (film_id),
  FULLTEXT KEY idx_title_description (title,description)
) DEFAULT CHARSET=utf8mb4 COMMENT='film_text テーブルには、film テーブルの film_id、title、description の各カラムが含まれます。このテーブルの内容は、film テーブルの INSERT、UPDATE、および DELETE 操作に対するトリガーによって、film テーブルと同期されています (セクション 5.5「トリガー」を参照)。\nfilm_textテーブルの内容を直接変更しないでください。すべての変更はfilmテーブルに対して行う必要があります。';

SET @@default_storage_engine = @old_default_storage_engine;

--
-- Triggers for loading film_text from film
--

DELIMITER ;;
CREATE TRIGGER `ins_film` AFTER INSERT ON `film` FOR EACH ROW BEGIN
    INSERT INTO film_text (film_id, title, description)
        VALUES (new.film_id, new.title, new.description);
  END;;


CREATE TRIGGER `upd_film` AFTER UPDATE ON `film` FOR EACH ROW BEGIN
    IF (old.title != new.title) OR (old.description != new.description) OR (old.film_id != new.film_id)
    THEN
        UPDATE film_text
            SET title=new.title,
                description=new.description,
                film_id=new.film_id
        WHERE film_id=old.film_id;
    END IF;
  END;;


CREATE TRIGGER `del_film` AFTER DELETE ON `film` FOR EACH ROW BEGIN
    DELETE FROM film_text WHERE film_id = old.film_id;
  END;;

DELIMITER ;

--
-- Table structure for table `inventory`
--

CREATE TABLE inventory (
  inventory_id MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '在庫内の各商品を一意に識別するために使用される代理主キー。',
  film_id SMALLINT UNSIGNED NOT NULL COMMENT 'この商品が表す映画を指す外部キー。',
  store_id TINYINT UNSIGNED NOT NULL COMMENT 'この商品を在庫している店舗を指す外部キー。',
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '行が作成または最後に更新された日時。',
  PRIMARY KEY  (inventory_id),
  KEY idx_fk_film_id (film_id),
  KEY idx_store_id_film_id (store_id,film_id),
  CONSTRAINT fk_inventory_store FOREIGN KEY (store_id) REFERENCES store (store_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_inventory_film FOREIGN KEY (film_id) REFERENCES film (film_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='inventory テーブルには、特定の店舗にある特定の映画のコピーごとに1行ずつ格納されます。\ninventory テーブルは、外部キーを使用して film テーブルと store テーブルを参照し、rental テーブルからも参照されます。';

--
-- Table structure for table `language`
--

CREATE TABLE language (
  language_id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '各言語を一意に識別するために使用される代理主キー。',
  name CHAR(20) NOT NULL COMMENT '言語の英語名。',
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '行が作成された日時、または最後に更新された日時。',
  PRIMARY KEY (language_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='language テーブルは、映画の language 値と original language 値に指定可能な言語をリストアップした参照テーブルです。\nlanguage テーブルは film テーブルから参照されます。';

--
-- Table structure for table `payment`
--

CREATE TABLE payment (
  payment_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '各支払いを一意に識別するために使用される代理主キー。',
  customer_id SMALLINT UNSIGNED NOT NULL COMMENT '支払いが適用される残高を持つ顧客。これは、customer テーブルへの外部キー参照です。',
  staff_id TINYINT UNSIGNED NOT NULL COMMENT '支払いを処理したスタッフ。これは、staff テーブルへの外部キー参照です。',
  rental_id INT DEFAULT NULL COMMENT '支払いが適用されるレンタル。一部の支払いは未払い料金であり、レンタルに直接関連していない可能性があるため、これはオプションです。',
  amount DECIMAL(5,2) NOT NULL COMMENT '支払い金額。',
  payment_date DATETIME NOT NULL COMMENT '支払いが処理された日付。',
  last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '行が作成された日時または最後に更新された日時。',
  PRIMARY KEY  (payment_id),
  KEY idx_fk_staff_id (staff_id),
  KEY idx_fk_customer_id (customer_id),
  CONSTRAINT fk_payment_rental FOREIGN KEY (rental_id) REFERENCES rental (rental_id) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT fk_payment_customer FOREIGN KEY (customer_id) REFERENCES customer (customer_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_payment_staff FOREIGN KEY (staff_id) REFERENCES staff (staff_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='payment テーブルには、顧客による各支払いが記録され、金額や支払われるレンタル料金（該当する場合）などの情報が含まれます。\npayment テーブルは、customer テーブル、rental テーブル、および staff テーブルを参照します。';


--
-- Table structure for table `rental`
--

CREATE TABLE rental (
  rental_id INT NOT NULL AUTO_INCREMENT COMMENT 'レンタルを一意に識別する代理主キー。',
  rental_date DATETIME NOT NULL COMMENT '品目がレンタルされた日時。',
  inventory_id MEDIUMINT UNSIGNED NOT NULL COMMENT 'レンタル対象の品目。',
  customer_id SMALLINT UNSIGNED NOT NULL COMMENT '品目をレンタルした顧客。',
  return_date DATETIME DEFAULT NULL COMMENT '品目が返却された日時。',
  staff_id TINYINT UNSIGNED NOT NULL COMMENT 'レンタルを処理したスタッフ。',
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '行が作成または最後に更新された日時。',
  PRIMARY KEY (rental_id),
  UNIQUE KEY  (rental_date,inventory_id,customer_id),
  KEY idx_fk_inventory_id (inventory_id),
  KEY idx_fk_customer_id (customer_id),
  KEY idx_fk_staff_id (staff_id),
  CONSTRAINT fk_rental_staff FOREIGN KEY (staff_id) REFERENCES staff (staff_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_rental_inventory FOREIGN KEY (inventory_id) REFERENCES inventory (inventory_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_rental_customer FOREIGN KEY (customer_id) REFERENCES customer (customer_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='rental テーブルには、各在庫品目のレンタルごとに1行ずつ、誰がどの品目をレンタルしたか、いつレンタルされたか、いつ返却されたかに関する情報が含まれます。\nrental テーブルは、inventory テーブル、customer テーブル、staff テーブルを参照し、payment テーブルからも参照されます。';

--
-- Table structure for table `staff`
--

CREATE TABLE staff (
  staff_id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'スタッフを一意に識別する代理主キー。',
  first_name VARCHAR(45) NOT NULL COMMENT 'スタッフの名。',
  last_name VARCHAR(45) NOT NULL COMMENT 'スタッフの姓。',
  address_id SMALLINT UNSIGNED NOT NULL COMMENT 'address テーブル内のスタッフの住所への外部キー。',
  picture BLOB DEFAULT NULL COMMENT '従業員の写真を含む BLOB。',
  email VARCHAR(50) DEFAULT NULL COMMENT 'スタッフのメールアドレス。',
  store_id TINYINT UNSIGNED NOT NULL COMMENT 'スタッフの「所属店舗」。従業員は他の店舗で働くこともできますが、通常は上記の店舗に配属されます。',
  active BOOLEAN NOT NULL DEFAULT TRUE COMMENT '従業員が現在在籍しているかどうか。従業員が退職した場合、その従業員の行はこのテーブルから削除されず、この列は FALSE に設定されます。',
  username VARCHAR(16) NOT NULL COMMENT 'スタッフがレンタルシステムにアクセスするために使用するユーザー名。',
  password VARCHAR(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'スタッフがレンタルシステムにアクセスするために使用するパスワード。パスワードはSHA2()関数を使用してハッシュとして保存する必要があります。',
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '行が作成または最後に更新された日時。',
  PRIMARY KEY  (staff_id),
  KEY idx_fk_store_id (store_id),
  KEY idx_fk_address_id (address_id),
  CONSTRAINT fk_staff_store FOREIGN KEY (store_id) REFERENCES store (store_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_staff_address FOREIGN KEY (address_id) REFERENCES address (address_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='staff テーブルには、メールアドレス、ログイン情報、写真などの情報を含む全スタッフがリストされます。\nstaff テーブルは、外部キーを使用して store テーブルと address テーブルを参照し、rental テーブル、payment テーブル、store テーブルからも参照されます。';

--
-- Table structure for table `store`
--

CREATE TABLE store (
  store_id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '店舗を一意に識別する代理主キー。',
  manager_staff_id TINYINT UNSIGNED NOT NULL COMMENT 'この店舗のマネージャーを識別する外部キー。',
  address_id SMALLINT UNSIGNED NOT NULL COMMENT 'この店舗の住所を識別する外部キー。',
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '行が作成された日時または最後に更新された日時。',
  PRIMARY KEY  (store_id),
  UNIQUE KEY idx_unique_manager (manager_staff_id),
  KEY idx_fk_address_id (address_id),
  CONSTRAINT fk_store_staff FOREIGN KEY (manager_staff_id) REFERENCES staff (staff_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_store_address FOREIGN KEY (address_id) REFERENCES address (address_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='store テーブルには、システム内のすべての店舗がリストされます。すべての在庫は特定の店舗に割り当てられ、スタッフと顧客には「ホームストア」が割り当てられます。\nstore テーブルは、外部キーを使用して staff テーブルと address テーブルを参照し、staff テーブル、customer テーブル、inventory テーブルからも参照されます。';

--
-- View structure for view `customer_list`
--

CREATE VIEW customer_list
AS
SELECT cu.customer_id AS ID, CONCAT(cu.first_name, _utf8mb4' ', cu.last_name) AS name, a.address AS address, a.postal_code AS `zip code`,
	a.phone AS phone, city.city AS city, country.country AS country, IF(cu.active, _utf8mb4'active',_utf8mb4'') AS notes, cu.store_id AS SID
FROM customer AS cu JOIN address AS a ON cu.address_id = a.address_id JOIN city ON a.city_id = city.city_id
	JOIN country ON city.country_id = country.country_id;

--
-- View structure for view `film_list`
--

CREATE VIEW film_list
AS
SELECT film.film_id AS FID, film.title AS title, film.description AS description, category.name AS category, film.rental_rate AS price,
	film.length AS length, film.rating AS rating, GROUP_CONCAT(CONCAT(actor.first_name, _utf8mb4' ', actor.last_name) SEPARATOR ', ') AS actors
FROM film LEFT JOIN film_category ON film_category.film_id = film.film_id
LEFT JOIN category ON category.category_id = film_category.category_id LEFT
JOIN film_actor ON film.film_id = film_actor.film_id LEFT JOIN actor ON
  film_actor.actor_id = actor.actor_id
GROUP BY film.film_id, category.name;

--
-- View structure for view `nicer_but_slower_film_list`
--

CREATE VIEW nicer_but_slower_film_list
AS
SELECT film.film_id AS FID, film.title AS title, film.description AS description, category.name AS category, film.rental_rate AS price,
	film.length AS length, film.rating AS rating, GROUP_CONCAT(CONCAT(CONCAT(UCASE(SUBSTR(actor.first_name,1,1)),
	LCASE(SUBSTR(actor.first_name,2,LENGTH(actor.first_name))),_utf8mb4' ',CONCAT(UCASE(SUBSTR(actor.last_name,1,1)),
	LCASE(SUBSTR(actor.last_name,2,LENGTH(actor.last_name)))))) SEPARATOR ', ') AS actors
FROM film LEFT JOIN film_category ON film_category.film_id = film.film_id
LEFT JOIN category ON category.category_id = film_category.category_id LEFT
JOIN film_actor ON film.film_id = film_actor.film_id LEFT JOIN actor ON
  film_actor.actor_id = actor.actor_id
GROUP BY film.film_id, category.name;

--
-- View structure for view `staff_list`
--

CREATE VIEW staff_list
AS
SELECT s.staff_id AS ID, CONCAT(s.first_name, _utf8mb4' ', s.last_name) AS name, a.address AS address, a.postal_code AS `zip code`, a.phone AS phone,
	city.city AS city, country.country AS country, s.store_id AS SID
FROM staff AS s JOIN address AS a ON s.address_id = a.address_id JOIN city ON a.city_id = city.city_id
	JOIN country ON city.country_id = country.country_id;

--
-- View structure for view `sales_by_store`
--

CREATE VIEW sales_by_store
AS
SELECT
CONCAT(c.city, _utf8mb4',', cy.country) AS store
, CONCAT(m.first_name, _utf8mb4' ', m.last_name) AS manager
, SUM(p.amount) AS total_sales
FROM payment AS p
INNER JOIN rental AS r ON p.rental_id = r.rental_id
INNER JOIN inventory AS i ON r.inventory_id = i.inventory_id
INNER JOIN store AS s ON i.store_id = s.store_id
INNER JOIN address AS a ON s.address_id = a.address_id
INNER JOIN city AS c ON a.city_id = c.city_id
INNER JOIN country AS cy ON c.country_id = cy.country_id
INNER JOIN staff AS m ON s.manager_staff_id = m.staff_id
GROUP BY s.store_id
ORDER BY cy.country, c.city;

--
-- View structure for view `sales_by_film_category`
--
-- Note that total sales will add up to >100% because
-- some titles belong to more than 1 category
--

CREATE VIEW sales_by_film_category
AS
SELECT
c.name AS category
, SUM(p.amount) AS total_sales
FROM payment AS p
INNER JOIN rental AS r ON p.rental_id = r.rental_id
INNER JOIN inventory AS i ON r.inventory_id = i.inventory_id
INNER JOIN film AS f ON i.film_id = f.film_id
INNER JOIN film_category AS fc ON f.film_id = fc.film_id
INNER JOIN category AS c ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY total_sales DESC;

--
-- View structure for view `actor_info`
--

CREATE DEFINER=CURRENT_USER SQL SECURITY INVOKER VIEW actor_info
AS
SELECT
a.actor_id,
a.first_name,
a.last_name,
GROUP_CONCAT(DISTINCT CONCAT(c.name, ': ',
		(SELECT GROUP_CONCAT(f.title ORDER BY f.title SEPARATOR ', ')
                    FROM sakila.film f
                    INNER JOIN sakila.film_category fc
                      ON f.film_id = fc.film_id
                    INNER JOIN sakila.film_actor fa
                      ON f.film_id = fa.film_id
                    WHERE fc.category_id = c.category_id
                    AND fa.actor_id = a.actor_id
                 )
             )
             ORDER BY c.name SEPARATOR '; ')
AS film_info
FROM sakila.actor a
LEFT JOIN sakila.film_actor fa
  ON a.actor_id = fa.actor_id
LEFT JOIN sakila.film_category fc
  ON fa.film_id = fc.film_id
LEFT JOIN sakila.category c
  ON fc.category_id = c.category_id
GROUP BY a.actor_id, a.first_name, a.last_name;

--
-- Procedure structure for procedure `rewards_report`
--

DELIMITER //

CREATE PROCEDURE rewards_report (
    IN min_monthly_purchases TINYINT UNSIGNED
    , IN min_dollar_amount_purchased DECIMAL(10,2)
    , OUT count_rewardees INT
)
LANGUAGE SQL
NOT DETERMINISTIC
READS SQL DATA
SQL SECURITY DEFINER
COMMENT 'Provides a customizable report on best customers'
proc: BEGIN

    DECLARE last_month_start DATE;
    DECLARE last_month_end DATE;

    /* Some sanity checks... */
    IF min_monthly_purchases = 0 THEN
        SELECT 'Minimum monthly purchases parameter must be > 0';
        LEAVE proc;
    END IF;
    IF min_dollar_amount_purchased = 0.00 THEN
        SELECT 'Minimum monthly dollar amount purchased parameter must be > $0.00';
        LEAVE proc;
    END IF;

    /* Determine start and end time periods */
    SET last_month_start = DATE_SUB(CURRENT_DATE(), INTERVAL 1 MONTH);
    SET last_month_start = STR_TO_DATE(CONCAT(YEAR(last_month_start),'-',MONTH(last_month_start),'-01'),'%Y-%m-%d');
    SET last_month_end = LAST_DAY(last_month_start);

    /*
        Create a temporary storage area for
        Customer IDs.
    */
    CREATE TEMPORARY TABLE tmpCustomer (customer_id SMALLINT UNSIGNED NOT NULL PRIMARY KEY);

    /*
        Find all customers meeting the
        monthly purchase requirements
    */
    INSERT INTO tmpCustomer (customer_id)
    SELECT p.customer_id
    FROM payment AS p
    WHERE DATE(p.payment_date) BETWEEN last_month_start AND last_month_end
    GROUP BY customer_id
    HAVING SUM(p.amount) > min_dollar_amount_purchased
    AND COUNT(customer_id) > min_monthly_purchases;

    /* Populate OUT parameter with count of found customers */
    SELECT COUNT(*) FROM tmpCustomer INTO count_rewardees;

    /*
        Output ALL customer information of matching rewardees.
        Customize output as needed.
    */
    SELECT c.*
    FROM tmpCustomer AS t
    INNER JOIN customer AS c ON t.customer_id = c.customer_id;

    /* Clean up */
    DROP TABLE tmpCustomer;
END //

DELIMITER ;

DELIMITER $$

CREATE FUNCTION get_customer_balance(p_customer_id INT, p_effective_date DATETIME) RETURNS DECIMAL(5,2)
    DETERMINISTIC
    READS SQL DATA
BEGIN

       #OK, WE NEED TO CALCULATE THE CURRENT BALANCE GIVEN A CUSTOMER_ID AND A DATE
       #THAT WE WANT THE BALANCE TO BE EFFECTIVE FOR. THE BALANCE IS:
       #   1) RENTAL FEES FOR ALL PREVIOUS RENTALS
       #   2) ONE DOLLAR FOR EVERY DAY THE PREVIOUS RENTALS ARE OVERDUE
       #   3) IF A FILM IS MORE THAN RENTAL_DURATION * 2 OVERDUE, CHARGE THE REPLACEMENT_COST
       #   4) SUBTRACT ALL PAYMENTS MADE BEFORE THE DATE SPECIFIED

  DECLARE v_rentfees DECIMAL(5,2); #FEES PAID TO RENT THE VIDEOS INITIALLY
  DECLARE v_overfees INTEGER;      #LATE FEES FOR PRIOR RENTALS
  DECLARE v_payments DECIMAL(5,2); #SUM OF PAYMENTS MADE PREVIOUSLY

  SELECT IFNULL(SUM(film.rental_rate),0) INTO v_rentfees
    FROM film, inventory, rental
    WHERE film.film_id = inventory.film_id
      AND inventory.inventory_id = rental.inventory_id
      AND rental.rental_date <= p_effective_date
      AND rental.customer_id = p_customer_id;

  SELECT IFNULL(SUM(IF((TO_DAYS(rental.return_date) - TO_DAYS(rental.rental_date)) > film.rental_duration,
        ((TO_DAYS(rental.return_date) - TO_DAYS(rental.rental_date)) - film.rental_duration),0)),0) INTO v_overfees
    FROM rental, inventory, film
    WHERE film.film_id = inventory.film_id
      AND inventory.inventory_id = rental.inventory_id
      AND rental.rental_date <= p_effective_date
      AND rental.customer_id = p_customer_id;


  SELECT IFNULL(SUM(payment.amount),0) INTO v_payments
    FROM payment

    WHERE payment.payment_date <= p_effective_date
    AND payment.customer_id = p_customer_id;

  RETURN v_rentfees + v_overfees - v_payments;
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE film_in_stock(IN p_film_id INT, IN p_store_id INT, OUT p_film_count INT)
READS SQL DATA
BEGIN
     SELECT inventory_id
     FROM inventory
     WHERE film_id = p_film_id
     AND store_id = p_store_id
     AND inventory_in_stock(inventory_id);

     SELECT COUNT(*)
     FROM inventory
     WHERE film_id = p_film_id
     AND store_id = p_store_id
     AND inventory_in_stock(inventory_id)
     INTO p_film_count;
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE film_not_in_stock(IN p_film_id INT, IN p_store_id INT, OUT p_film_count INT)
READS SQL DATA
BEGIN
     SELECT inventory_id
     FROM inventory
     WHERE film_id = p_film_id
     AND store_id = p_store_id
     AND NOT inventory_in_stock(inventory_id);

     SELECT COUNT(*)
     FROM inventory
     WHERE film_id = p_film_id
     AND store_id = p_store_id
     AND NOT inventory_in_stock(inventory_id)
     INTO p_film_count;
END $$

DELIMITER ;

DELIMITER $$

CREATE FUNCTION inventory_held_by_customer(p_inventory_id INT) RETURNS INT
READS SQL DATA
BEGIN
  DECLARE v_customer_id INT;
  DECLARE EXIT HANDLER FOR NOT FOUND RETURN NULL;

  SELECT customer_id INTO v_customer_id
  FROM rental
  WHERE return_date IS NULL
  AND inventory_id = p_inventory_id;

  RETURN v_customer_id;
END $$

DELIMITER ;

DELIMITER $$

CREATE FUNCTION inventory_in_stock(p_inventory_id INT) RETURNS BOOLEAN
READS SQL DATA
BEGIN
    DECLARE v_rentals INT;
    DECLARE v_out     INT;

    #AN ITEM IS IN-STOCK IF THERE ARE EITHER NO ROWS IN THE rental TABLE
    #FOR THE ITEM OR ALL ROWS HAVE return_date POPULATED

    SELECT COUNT(*) INTO v_rentals
    FROM rental
    WHERE inventory_id = p_inventory_id;

    IF v_rentals = 0 THEN
      RETURN TRUE;
    END IF;

    SELECT COUNT(rental_id) INTO v_out
    FROM inventory LEFT JOIN rental USING(inventory_id)
    WHERE inventory.inventory_id = p_inventory_id
    AND rental.return_date IS NULL;

    IF v_out > 0 THEN
      RETURN FALSE;
    ELSE
      RETURN TRUE;
    END IF;
END $$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;



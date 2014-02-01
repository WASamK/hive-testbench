set hive.enforce.bucketing=true;
set hive.exec.dynamic.partition.mode=nonstrict;
set hive.exec.max.dynamic.partitions=4096;
set hive.exec.max.dynamic.partitions.pernode=4096;
set mapred.job.reduce.input.buffer.percent=0.0;

create database if not exists ${DB};
use ${DB};

drop table if exists inventory;

create table inventory
(
    inv_date_sk         int,
    inv_item_sk          int,
    inv_warehouse_sk		int,
    inv_quantity_on_hand	int
)
partitioned by (inv_date string)
stored as ${FILE};

insert overwrite table inventory partition (inv_date)
from (select
	i.inv_date_sk,
	i.inv_item_sk,
	i.inv_warehouse_sk,
	i.inv_quantity_on_hand,
	d.d_date as inv_date
  from ${SOURCE}.inventory i
  left outer join ${SOURCE}.date_dim d
  on (d.d_date_sk = i.inv_date_sk);

-- 每日增量比对
SELECT  concat(left(Date,4),'-',substring(Date,5,2),'-',right(Date,2)) AS Date
       ,BrandId
       ,TableName
       ,MysqlCnt
       ,HiveCnt
       ,CKCnt
       ,(MysqlCnt-HiveCnt)                                             AS HiveDiff
       ,(MysqlCnt-CKCnt)                                               AS CKDiff
FROM
(
	SELECT  Date
	       ,BrandId
	       ,TableName
	       ,SUM(case WHEN Origin = 1 THEN Cnt else 0 end) AS MysqlCnt
	       ,SUM(case WHEN Origin = 2 THEN Cnt else 0 end) AS HiveCnt
	       ,SUM(case WHEN Origin = 3 THEN Cnt else 0 end) AS CKCnt
	FROM `ezp-bigdata`.bd_dq_check_rowcount
	WHERE Type = 3
	GROUP BY  Date
	         ,BrandId
	         ,TableName
)t
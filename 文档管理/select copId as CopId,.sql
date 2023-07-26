select copId                                                 as CopId,
       brandId                                               as BrandId,
       shopId                                                as ShopId,
       saleDate                                              as SaleDate,
       prodId                                                as ProdId,
       sum(saleSaleQty)                                      as SaleChannelNum,
       sum(saleSaleMoney)                                    as SaleChannelAmount,
       sum(serviceSaleQty)                                   as ServiceChannelNum,
       sum(serviceSaleMoney)                                 as ServiceChannelAmount,
       0                                                     as AllChannelNum,
       0                                                     as AllChannelAmount,
       sum(saleSaleQtyR)                                     as SaleChannelNumRef,
       sum(saleSaleMoneyR)                                   as SaleChannelAmountRef,
       sum(serviceSaleQtyR)                                  as ServiceChannelNumRef,
       sum(serviceSaleMoneyR)                                as ServiceChannelAmountRef,
       0                                                     as AllChannelNumRef,
       0                                                     as AllChannelAmountRef,
       date_format(current_timestamp, 'yyyy-MM-dd HH:mm:ss') as LastModifiedDate from (SELECT a.copid                                                                    as copId,
       a.brandid                                                                  as brandId,
       a.saledate                                                                 as saleDate,
       if(isnotnull(b.prodid), b.prodid, 0)                                       as prodId,
       if(isnotnull(a.shopid), a.shopid,
          if(isnotnull(a.servicechannel), a.servicechannel, 0))                   as shopId,
       if(isnotnull(a.shopid) and a.ordertype = 'S', sum(a.saleqty), 0)           as saleSaleQty,
       if(isnotnull(a.shopid) and a.ordertype = 'R', sum(a.saleqty), 0)           as saleSaleQtyR,
       if(isnotnull(a.shopid) and a.ordertype = 'S', sum(a.salemoney), 0)         as saleSaleMoney,
       if(isnotnull(a.shopid) and a.ordertype = 'R', sum(a.salemoney), 0)         as saleSaleMoneyR,
       if(isnotnull(a.servicechannel) and a.ordertype = 'S', sum(a.saleqty), 0)   as serviceSaleQty,
       if(isnotnull(a.servicechannel) and a.ordertype = 'R', sum(a.saleqty), 0)   as serviceSaleQtyR,
       if(isnotnull(a.servicechannel) and a.ordertype = 'S', sum(a.salemoney), 0) as serviceSaleMoney,
       if(isnotnull(a.servicechannel) and a.ordertype = 'R', sum(a.salemoney), 0) as serviceSaleMoneyR
FROM (
         SELECT copid,
                brandid,
                cast(to_date(saledate) as string) as saledate,
                shopid,
                servicechannel,
                ordertype,
                salemoney,
                saleqty,
                prodcode
         FROM product.crm_sal_vip_sale_prod
         WHERE dt = 20230628
           and brandidpartition = 625
           AND orderType in ('S', 'R')
           AND prodcode is not null
           and prodcode != 'null'
           AND unix_timestamp(lastmodifieddate) < unix_timestamp('2023-06-28 23:59:59')
           AND unix_timestamp(lastmodifieddate) >= unix_timestamp('2023-06-28 00:00:00')
     ) a
         LEFT JOIN (SELECT brandid, skuno, prodid
                    from product.rtl_prod_detail
                    where dt = 20230628
                      and brandidpartition = 625
                      AND skuno IS NOT NULL
                      and skuno != 'null'
                    group by brandid, skuno, prodid
) b  ON a.brandid = b.brandid AND a.prodcode = b.skuno
group by a.copid,
         a.brandid,
         a.saledate,
         a.ordertype,
         b.prodid,
         a.shopid,
         a.servicechannel
    grouping sets (
    ( a.copid,
         a.brandid,
         a.saledate,
         a.ordertype,
         b.prodid,
         a.shopid),
    ( a.copid,
         a.brandid,
         a.saledate,
         a.ordertype,
         b.prodid,
         a.servicechannel)))as goods_temp 
         where prodId > 0
group by copId,
         brandId,
         saleDate,
         prodId,
         shopId
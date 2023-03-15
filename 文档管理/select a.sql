select a.SellDay,
    a.SellShopId,
    a.SellMoney,
    b.Id,
    b.Birthday,
    b.ServiceChannel,
    b.serviceSaler
from (
        SELECT *
        FROM `crm_coupon_consume_dtl`
        where BrandId = 429
            and DATE_FORMAT(SellTime, '%Y%m') = 202210
    ) a
    left join crm_vip_info b on a.BrandId = b.BrandId
    and a.VipId = b.Id
    and MONTH(a.SellTime) = Month(b.Birthday)
where b.Birthday != ''
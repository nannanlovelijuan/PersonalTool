select sum(
        ShareTotalAmount + InviteTotalAmount + ValetTotalAmount
    ) as `PayedCommissionAmount`,
    sum(
        DevInviteTotalAmount + DevShareTotalAmount + DevValetTotalAmount
    ) as `DevPayedCommissionAmount`
from (SELECT fxOrder.Id,fxOrder.ProvideId,fxOrder.IsPayed,fxOrder.RtSuccess,fxOrder.CommissionStatus,fxOrder.RefundId,fxOrder.OrderId,
if(fxOrder.ProvideId <= 0 and ((fxOrder.IsPayed>0 and fxOrder.CommissionStatus = 10) or fxOrder.CommissionStatus = 30),1,0) as OrderCount,
if(fxOrder.ProvideId <=0  and (fxOrder.CommissionStatus = 15 or fxOrder.CommissionStatus = 35),1,0) as RefundCount,
if(fxOrder.ProvideId >0 and ((fxOrder.IsPayed >0 and fxOrder.CommissionStatus = 10 ) or fxOrder.CommissionStatus = 30),1,0) as DevOrderCount,
if(fxOrder.ProvideId >0 and (fxOrder.CommissionStatus = 15 or fxOrder.CommissionStatus = 35),1,0) as DevRefundCount,
if(fxOrder.ProvideId <= 0 and ((fxOrder.IsPayed>0 and fxOrder.CommissionStatus = 10) or fxOrder.CommissionStatus = 30),fxOrder.PopulationId,0) as OpenOrderPersonId,
if(fxOrder.ProvideId >0 and ((fxOrder.IsPayed >0 and fxOrder.CommissionStatus = 10) or fxOrder.CommissionStatus = 30),1,0) as DevOpenOrderPersonId,
sumIf(fxOrderDtl.Commission,fxOrder.ProvideId >0 and (fxOrder.CommissionStatus = 30 or fxOrder.CommissionStatus = 35) and fxOrder.RelationType not in(0,3,5)) as DevInviteTotalAmount,
sumIf(fxOrderDtl.Commission,fxOrder.ProvideId >0 and (fxOrder.CommissionStatus = 10 or fxOrder.CommissionStatus = 15) and fxOrder.RelationType not in(0,3,5)) as DevInviteWaitAmount,
sumIf(fxOrderDtl.RealPayAmount,fxOrder.ProvideId >0 and ((fxOrder.IsPayed >0 and fxOrder.CommissionStatus = 10) or fxOrder.CommissionStatus = 30 or fxOrder.CommissionStatus = 35)) as DevSaleAmount,
sumIf(fxOrderDtl.Commission,fxOrder.ProvideId >0 and (fxOrder.CommissionStatus = 30 or fxOrder.CommissionStatus = 35) and fxOrder.RelationType  in(0,3)) as DevShareTotalAmount,
sumIf(fxOrderDtl.Commission,fxOrder.ProvideId >0 and (fxOrder.CommissionStatus = 10 or fxOrder.CommissionStatus = 15) and fxOrder.RelationType  in(0,3)) as DevShareWaitAmount,
sumIf(fxOrderDtl.Commission,fxOrder.ProvideId >0 and (fxOrder.CommissionStatus = 30 or fxOrder.CommissionStatus = 35) and fxOrder.RelationType  =5) as DevValetTotalAmount,
sumIf(fxOrderDtl.Commission,fxOrder.ProvideId >0 and (fxOrder.CommissionStatus = 10 or fxOrder.CommissionStatus = 15) and fxOrder.RelationType  =5) as DevValetWaitAmount,
sumIf(fxOrderDtl.Commission,fxOrder.ProvideId <=0 and (fxOrder.CommissionStatus = 30 or fxOrder.CommissionStatus = 35) and fxOrder.RelationType  not in(0,3,5)) as InviteTotalAmount,
sumIf(fxOrderDtl.Commission,fxOrder.ProvideId <=0 and (fxOrder.CommissionStatus = 10 or fxOrder.CommissionStatus = 15) and fxOrder.RelationType  not in(0,3,5)) as InviteWaitAmount,
sumIf(fxOrderDtl.RealPayAmount,fxOrder.ProvideId <=0 and ((fxOrder.IsPayed >0 and fxOrder.CommissionStatus = 10) or fxOrder.CommissionStatus = 30 or fxOrder.CommissionStatus = 15 or fxOrder.CommissionStatus = 35)) as SaleAmount,
sumIf(fxOrderDtl.Commission,fxOrder.ProvideId <=0 and (fxOrder.CommissionStatus = 30 or fxOrder.CommissionStatus = 35) and fxOrder.RelationType  in(0,3)) as ShareTotalAmount,
sumIf(fxOrderDtl.Commission,fxOrder.ProvideId <=0 and (fxOrder.CommissionStatus = 10 or fxOrder.CommissionStatus = 15) and fxOrder.RelationType  in(0,3)) as ShareWaitAmount,
sumIf(fxOrderDtl.Commission,fxOrder.ProvideId <=0 and (fxOrder.CommissionStatus = 30 or fxOrder.CommissionStatus = 35) and fxOrder.RelationType  =5) as ValetTotalAmount,
sumIf(fxOrderDtl.Commission,fxOrder.ProvideId <=0 and (fxOrder.CommissionStatus = 10 or fxOrder.CommissionStatus = 15) and fxOrder.RelationType  =5) as ValetWaitAmount,
sumIf(fxOrderDtl.RealPayAmount,fxOrder.ProvideId <=0 and ((fxOrder.IsPayed >0 and fxOrder.CommissionStatus = 10) or fxOrder.CommissionStatus = 30)) as AddSaleAmount,
sumIf(fxOrderDtl.RealPayAmount,fxOrder.ProvideId >0 and ((fxOrder.IsPayed >0 and fxOrder.CommissionStatus = 10) or fxOrder.CommissionStatus = 30)) as AddDevSaleAmount,
sumIf(fxOrderDtl.RealPayAmount,fxOrder.ProvideId <=0 and ((fxOrder.RtSuccess ='true' and fxOrder.CommissionStatus = 15) or fxOrder.CommissionStatus = 35)) as DedSaleAmount,
sumIf(fxOrderDtl.RealPayAmount,fxOrder.ProvideId >0 and ((fxOrder.RtSuccess ='true' and fxOrder.CommissionStatus = 15) or fxOrder.CommissionStatus = 35)) as DedDevSaleAmount,
sumIf(fxOrderDtl.RealPayAmount,fxOrder.ProvideId <=0 and ( fxOrder.CommissionStatus = 15 or fxOrder.CommissionStatus = 35 or fxOrder.CommissionStatus = 1)) as ApplyRtAmount,
sumIf(fxOrderDtl.RealPayAmount,fxOrder.ProvideId >0 and ( fxOrder.CommissionStatus = 15 or fxOrder.CommissionStatus = 35 or fxOrder.CommissionStatus = 1)) as DevApplyRtAmount,
sumIf(fxOrderDtl.RealPayAmount,fxOrder.ProvideId <=0 and ((fxOrder.RtSuccess ='true' and fxOrder.CommissionStatus = 15) or fxOrder.CommissionStatus = 35)) as SuccessRtAmount,
sumIf(fxOrderDtl.RealPayAmount,fxOrder.ProvideId >0 and ((fxOrder.RtSuccess ='true' and fxOrder.CommissionStatus = 15) or fxOrder.CommissionStatus = 35)) as DevSuccessRtAmount,
if(fxOrder.ProvideId <= 0 and ((fxOrder.IsPayed>0 and fxOrder.CommissionStatus = 10) or fxOrder.CommissionStatus = 30),1,0) as AddOrderCount,
if(fxOrder.ProvideId > 0 and ((fxOrder.IsPayed>0 and fxOrder.CommissionStatus = 10) or fxOrder.CommissionStatus = 30),1,0) as DevAddOrderCount,
if(fxOrder.ProvideId <= 0 and ((fxOrder.RtSuccess ='true' and fxOrder.CommissionStatus = 10) or (fxOrder.RtSuccess ='true' and fxOrder.CommissionStatus = 30)),-1,0) as DedOrderCount,
if(fxOrder.ProvideId > 0 and ((fxOrder.RtSuccess ='true' and fxOrder.CommissionStatus = 10) or fxOrder.CommissionStatus = 30),-1,0) as DedDevOrderCount,
if(fxOrder.ProvideId <= 0 and ( fxOrder.CommissionStatus = 15 or fxOrder.CommissionStatus = 35 or fxOrder.CommissionStatus = 1),1,0) as ApplyRtCount,
if(fxOrder.ProvideId > 0 and ( fxOrder.CommissionStatus = 15 or fxOrder.CommissionStatus = 35 or fxOrder.CommissionStatus = 1),1,0) as DevApplyRtCount,
if(fxOrder.ProvideId <= 0 and ((fxOrder.RtSuccess ='true' and fxOrder.CommissionStatus = 15) or fxOrder.CommissionStatus = 35),1,0) as SuccessRtCount,
if(fxOrder.ProvideId > 0 and ((fxOrder.RtSuccess ='true' and fxOrder.CommissionStatus = 15) or fxOrder.CommissionStatus = 35),1,0) as DevSuccessRtCount,
if(fxOrder.ProvideId <= 0 and ((fxOrder.RefundId >0 and fxOrder.CommissionStatus = 15) or (fxOrder.RefundId >0 and fxOrder.CommissionStatus = 35) or (fxOrder.RefundId >0 and fxOrder.CommissionStatus = 1)),1,0) as ApplyOrderRefCount,
if(fxOrder.ProvideId <= 0 and ((fxOrder.RtAgree= 'true' and fxOrder.RefundId >0 and fxOrder.CommissionStatus = 15) or (fxOrder.RefundId >0 and fxOrder.CommissionStatus = 35)),1,0) as AgreeOrderRefCount,
if(fxOrder.ProvideId <= 0 and ((fxOrder.RtSuccess= 'true' and fxOrder.RefundId >0 and fxOrder.CommissionStatus = 15) or (fxOrder.RefundId >0 and fxOrder.CommissionStatus = 35)),1,0) as SucessOrderRefCount,
sumIf(fxOrderDtl.RealPayAmount,fxOrder.ProvideId <=0 and ((fxOrder.RefundId >0 and fxOrder.CommissionStatus = 15) or (fxOrder.RefundId >0 and fxOrder.CommissionStatus = 35) or (fxOrder.RefundId >0 and fxOrder.CommissionStatus = 1))) as ApplyOrderRefAmount,
sumIf(fxOrderDtl.RealPayAmount,fxOrder.ProvideId <=0 and ((fxOrder.RtAgree= 'true' and fxOrder.RefundId >0 and fxOrder.CommissionStatus = 15) or (fxOrder.RefundId >0 and fxOrder.CommissionStatus = 35))) as AgreeOrderRefAmount,
sumIf(fxOrderDtl.RealPayAmount,fxOrder.ProvideId <=0 and ((fxOrder.RtSuccess= 'true' and fxOrder.RefundId >0 and fxOrder.CommissionStatus = 15) or (fxOrder.RefundId >0 and fxOrder.CommissionStatus = 35))) as SucessOrderRefAmount,
if(fxOrder.ProvideId > 0 and ((fxOrder.RefundId >0 and fxOrder.CommissionStatus = 15) or (fxOrder.RefundId >0 and fxOrder.CommissionStatus = 35) or (fxOrder.RefundId >0 and fxOrder.CommissionStatus = 1)),1,0) as ApplyDevOrderRefCount,
if(fxOrder.ProvideId > 0 and ((fxOrder.RtAgree= 'true' and fxOrder.RefundId >0 and fxOrder.CommissionStatus = 15) or (fxOrder.RefundId >0 and fxOrder.CommissionStatus = 35)),1,0) as AgreeDevOrderRefCount,
if(fxOrder.ProvideId > 0 and ((fxOrder.RtSuccess= 'true' and fxOrder.RefundId >0 and fxOrder.CommissionStatus = 15) or (fxOrder.RefundId >0 and fxOrder.CommissionStatus = 35)),1,0) as SucessDevOrderRefCount,
sumIf(fxOrderDtl.RealPayAmount,fxOrder.ProvideId >0 and ((fxOrder.RefundId >0 and fxOrder.CommissionStatus = 15) or (fxOrder.RefundId >0 and fxOrder.CommissionStatus = 35) or (fxOrder.RefundId >0 and fxOrder.CommissionStatus = 1))) as ApplyDevOrderRefAmount,
sumIf(fxOrderDtl.RealPayAmount,fxOrder.ProvideId >0 and ((fxOrder.RtAgree= 'true' and fxOrder.RefundId >0 and fxOrder.CommissionStatus = 15) or (fxOrder.RefundId >0 and fxOrder.CommissionStatus = 35))) as AgreeDevOrderRefAmount,
sumIf(fxOrderDtl.RealPayAmount,fxOrder.ProvideId >0 and ((fxOrder.RtSuccess= 'true' and fxOrder.RefundId >0 and fxOrder.CommissionStatus = 15) or (fxOrder.RefundId >0 and fxOrder.CommissionStatus = 35))) as SucessDevOrderRefAmount,

if(fxOrder.ProvideId <= 0 and ((fxOrder.RefundId <=0 and fxOrder.CommissionStatus = 15) or (fxOrder.RefundId <=0 and fxOrder.CommissionStatus = 35) or (fxOrder.RefundId <=0 and fxOrder.CommissionStatus = 1)),1,0) as ApplyOrderRtCount,
if(fxOrder.ProvideId <= 0 and ((fxOrder.RtAgree= 'true' and fxOrder.RefundId <=0 and fxOrder.CommissionStatus = 15) or (fxOrder.RefundId <=0 and fxOrder.CommissionStatus = 35)),1,0) as AgreeOrderRtCount,
if(fxOrder.ProvideId <= 0 and ((fxOrder.RtSuccess = 'true' and fxOrder.RefundId <=0 and fxOrder.CommissionStatus = 15) or (fxOrder.RefundId <=0 and fxOrder.CommissionStatus = 35)),1,0) as SucessOrderRtCount,
sumIf(fxOrderDtl.RealPayAmount,fxOrder.ProvideId <=0 and ((fxOrder.RefundId <=0 and fxOrder.CommissionStatus = 15) or (fxOrder.RefundId <=0 and fxOrder.CommissionStatus = 35) or (fxOrder.RefundId <=0 and fxOrder.CommissionStatus = 1))) as ApplyOrderRtAmount,
sumIf(fxOrderDtl.RealPayAmount,fxOrder.ProvideId <=0 and ((fxOrder.RtAgree= 'true' and fxOrder.RefundId <=0 and fxOrder.CommissionStatus = 15) or (fxOrder.RefundId <=0 and fxOrder.CommissionStatus = 35) )) as AgreeOrderRtAmount,
sumIf(fxOrderDtl.RealPayAmount,fxOrder.ProvideId <=0 and ((fxOrder.RtSuccess= 'true' and fxOrder.RefundId <=0 and fxOrder.CommissionStatus = 15) or (fxOrder.RefundId <=0 and fxOrder.CommissionStatus = 35) )) as SucessOrderRtAmount,

if(fxOrder.ProvideId > 0 and ((fxOrder.RefundId <=0 and fxOrder.CommissionStatus = 15) or (fxOrder.RefundId <=0 and fxOrder.CommissionStatus = 35) or (fxOrder.RefundId <=0 and fxOrder.CommissionStatus = 1)),1,0) as ApplyDevOrderRtCount,
if(fxOrder.ProvideId > 0 and ((fxOrder.RtAgree= 'true' and fxOrder.RefundId <=0 and fxOrder.CommissionStatus = 15) or (fxOrder.RefundId <=0 and fxOrder.CommissionStatus = 35)),1,0) as AgreeDevOrderRtCount,
if(fxOrder.ProvideId > 0 and ((fxOrder.RtSuccess = 'true' and fxOrder.RefundId <=0 and fxOrder.CommissionStatus = 15) or (fxOrder.RefundId <=0 and fxOrder.CommissionStatus = 35)),1,0) as SucessDevOrderRtCount,
sumIf(fxOrderDtl.RealPayAmount,fxOrder.ProvideId >0 and ((fxOrder.RefundId <=0 and fxOrder.CommissionStatus = 15) or (fxOrder.RefundId <=0 and fxOrder.CommissionStatus = 35) or (fxOrder.RefundId <=0 and fxOrder.CommissionStatus = 1))) as ApplyDevOrderRtAmount,
sumIf(fxOrderDtl.RealPayAmount,fxOrder.ProvideId >0 and ((fxOrder.RtAgree= 'true' and fxOrder.RefundId <=0 and fxOrder.CommissionStatus = 15) or (fxOrder.RefundId <=0 and fxOrder.CommissionStatus = 35) )) as AgreeDevOrderRtAmount,
sumIf(fxOrderDtl.RealPayAmount,fxOrder.ProvideId >0 and ((fxOrder.RtSuccess= 'true' and fxOrder.RefundId <=0 and fxOrder.CommissionStatus = 15) or (fxOrder.RefundId <=0 and fxOrder.CommissionStatus = 35) )) as SucessDevOrderRtAmount
FROM (
        SELECT *
        FROM ods_mall_fx_order_commssion_all final
        WHERE BrandId = 493
    and PopulationId = 3195
    and LastModifiedDateNew >= '2023-06-27'
    and LastModifiedDateNew <= '2023-06-27'
    and FxShopId = 21217251
    and PopulationType = 0
    and OpType <> 'DELETE'
    ) as fxOrder 
    -- 需要区分是退款或者退货退款
    global LEFT JOIN (select * from ods_mall_fx_order_commssion_dtl_all final where BrandId = 493)  as fxOrderDtl on fxOrder.Id = fxOrderDtl.OcId
    group by fxOrder.ProvideId,fxOrder.IsPayed,fxOrder.RtSuccess,fxOrder.CommissionStatus,
    fxOrder.RefundId,fxOrder.OrderId,fxOrder.RtAgree,fxOrder.RtSuccess,fxOrder.Id,fxOrder.PopulationId) 
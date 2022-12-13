Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 276EA64AF1A
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 06:09:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234552AbiLMFJy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 00:09:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234553AbiLMFJS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 00:09:18 -0500
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D0342DF3;
        Mon, 12 Dec 2022 21:06:57 -0800 (PST)
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BD1Gqq6007353;
        Tue, 13 Dec 2022 05:06:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=CY/L6Q14CVcMoBaDDOyW5+NCgtmfrhFQpRm9frGPgUY=;
 b=j9RUvVM0jcZQP+h1n4BdJx5ccx8E5DdJHpfdoqrWwf/kvz8rM5SEmI9uukCcFgUiRZbI
 EcmCjntd2c+m1wpoFa3so8JCOY8K+zIHBtR9LFykNTeIUUibmJ/MK6pYKpJOBb+vSDcW
 S1dz7oiGkgtA7EVQODC1UjTwSXlKTcvTzidoxHjejUi7uPbrQbjopaKDX8GN1koT1BN4
 0Dt5/UMvRihvF0/fF8Xv74WZ1FV11/AlAxr91v3LnKvK3P8Rva0PQyzp+qTl+Hek2ydx
 rqc8N+R3oW9zPhsDnxTCcMtWgq+R8qK/18IYtXPo/mUy1nowFvRdtVjWN+CZeAz85VQs ew== 
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3me83sht9f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 05:06:49 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA04.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 2BD56m4P015691
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 05:06:48 GMT
Received: from [10.50.38.23] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 12 Dec
 2022 21:06:43 -0800
Message-ID: <a2b09076-a008-f19b-80e7-2b6ed845083e@quicinc.com>
Date:   Tue, 13 Dec 2022 10:36:40 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Subject: Re: [PATCH v2 06/13] arm64: dts: qcom: sc8280xp: Fix the base
 addresses of LLCC banks
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        <andersson@kernel.org>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <bp@alien8.de>,
        <tony.luck@intel.com>
CC:     <konrad.dybcio@linaro.org>, <linux-arm-msm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <james.morse@arm.com>,
        <mchehab@kernel.org>, <rric@kernel.org>,
        <linux-edac@vger.kernel.org>, <quic_ppareek@quicinc.com>,
        <luca.weiss@fairphone.com>, <stable@vger.kernel.org>
References: <20221212123311.146261-1-manivannan.sadhasivam@linaro.org>
 <20221212123311.146261-7-manivannan.sadhasivam@linaro.org>
From:   Sai Prakash Ranjan <quic_saipraka@quicinc.com>
In-Reply-To: <20221212123311.146261-7-manivannan.sadhasivam@linaro.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: iJZVJ9zd3vBV5ZfIsFrJ-R36VYGfW12h
X-Proofpoint-ORIG-GUID: iJZVJ9zd3vBV5ZfIsFrJ-R36VYGfW12h
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-13_02,2022-12-12_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 clxscore=1015 spamscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212130046
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/12/2022 6:03 PM, Manivannan Sadhasivam wrote:
> The LLCC block has several banks each with a different base address
> and holes in between. So it is not a correct approach to cover these
> banks with a single offset/size. Instead, the individual bank's base
> address needs to be specified in devicetree with the exact size.
> 
> Also, let's get rid of reg-names property as it is not needed anymore.
> The driver is expected to parse the reg field based on index to get the
> addresses of each LLCC banks.
> 
> Cc: <stable@vger.kernel.org> # 6.0
> Fixes: 152d1faf1e2f ("arm64: dts: qcom: add SC8280XP platform")
> Reported-by: Parikshit Pareek <quic_ppareek@quicinc.com>
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
>   arch/arm64/boot/dts/qcom/sc8280xp.dtsi | 7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
> index 109c9d2b684d..f8731cbccce9 100644
> --- a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
> @@ -1856,8 +1856,11 @@ opp-6 {
>   
>   		system-cache-controller@9200000 {
>   			compatible = "qcom,sc8280xp-llcc";
> -			reg = <0 0x09200000 0 0x58000>, <0 0x09600000 0 0x58000>;
> -			reg-names = "llcc_base", "llcc_broadcast_base";
> +			reg = <0 0x09200000 0 0x58000>, <0 0x09280000 0 0x58000>,
> +			      <0 0x09300000 0 0x58000>, <0 0x09380000 0 0x58000>,
> +			      <0 0x09400000 0 0x58000>, <0 0x09480000 0 0x58000>,
> +			      <0 0x09500000 0 0x58000>, <0 0x09580000 0 0x58000>,
> +			      <0 0x09600000 0 0x58000>;
>   			interrupts = <GIC_SPI 582 IRQ_TYPE_LEVEL_HIGH>;
>   		};
>   

Reviewed-by: Sai Prakash Ranjan <quic_saipraka@quicinc.com>

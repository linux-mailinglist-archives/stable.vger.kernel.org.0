Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F55664AF1F
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 06:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234583AbiLMFKo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 00:10:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234556AbiLMFJ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 00:09:57 -0500
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E4421F9DB;
        Mon, 12 Dec 2022 21:07:35 -0800 (PST)
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BD29oJS026869;
        Tue, 13 Dec 2022 05:07:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=4KGjHULggThQEhMxyB30DdYQb38RRZI8+s1t32b/6x0=;
 b=CF2ftM7QKYQEVHGAwdOiIQXc7O/wKiTtqgi2szGPnzEaracEPBCaKTnQ9z/ls8THGFCf
 PwLUJjuYaavtXNS7o1hx3CeIqt32LAFzoCCEVU8qT3qLML6+VuwC/Gu1RXyw5Hg6iiP5
 W3pL1umEe3b6aMAFHTUV4wJODVrVQP6yft7NwazYfZ9vO/Phzbi0RGaGKmuiM/gHc8Jw
 lH+rOOOe8HGCul8FLXeLDa8wq4wqizygLzYBPo7991k17yA+VVSxeWywYZxCRvG2s5zM
 rEdV1ujBp7vw1ZGDN4YJ7N5CVOqyegHxy38q+wiCDNGX0ZBwT3dce+2Q2afc/irW1jQq VA== 
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3megc5rfhx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 05:07:27 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 2BD57QEx009000
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 05:07:26 GMT
Received: from [10.50.38.23] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 12 Dec
 2022 21:07:21 -0800
Message-ID: <7446550c-8782-e8a7-826f-287967a8cb25@quicinc.com>
Date:   Tue, 13 Dec 2022 10:37:18 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Subject: Re: [PATCH v2 07/13] arm64: dts: qcom: sm8150: Fix the base addresses
 of LLCC banks
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
 <20221212123311.146261-8-manivannan.sadhasivam@linaro.org>
From:   Sai Prakash Ranjan <quic_saipraka@quicinc.com>
In-Reply-To: <20221212123311.146261-8-manivannan.sadhasivam@linaro.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: HYTYsPm8TXb4RyqrRfY__puwSrj24XAl
X-Proofpoint-GUID: HYTYsPm8TXb4RyqrRfY__puwSrj24XAl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-13_01,2022-12-12_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 priorityscore=1501
 impostorscore=0 clxscore=1015 bulkscore=0 lowpriorityscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212130045
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
> Cc: <stable@vger.kernel.org> # 5.11
> Fixes: bb1f7cf68a2d ("arm64: dts: qcom: sm8150: Add LLC support for sm8150")
> Reported-by: Parikshit Pareek <quic_ppareek@quicinc.com>
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
>   arch/arm64/boot/dts/qcom/sm8150.dtsi | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sm8150.dtsi b/arch/arm64/boot/dts/qcom/sm8150.dtsi
> index a0c57fb798d3..958655bf5b1a 100644
> --- a/arch/arm64/boot/dts/qcom/sm8150.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sm8150.dtsi
> @@ -1762,8 +1762,9 @@ mmss_noc: interconnect@1740000 {
>   
>   		system-cache-controller@9200000 {
>   			compatible = "qcom,sm8150-llcc";
> -			reg = <0 0x09200000 0 0x200000>, <0 0x09600000 0 0x50000>;
> -			reg-names = "llcc_base", "llcc_broadcast_base";
> +			reg = <0 0x09200000 0 0x50000>, <0 0x09280000 0 0x50000>,
> +			      <0 0x09300000 0 0x50000>, <0 0x09380000 0 0x50000>,
> +			      <0 0x09600000 0 0x50000>;
>   			interrupts = <GIC_SPI 582 IRQ_TYPE_LEVEL_HIGH>;
>   		};
>   

Reviewed-by: Sai Prakash Ranjan <quic_saipraka@quicinc.com>

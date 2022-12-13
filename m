Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3740E64AF2E
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 06:12:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234697AbiLMFMW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 00:12:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234515AbiLMFLP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 00:11:15 -0500
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF9961FFA6;
        Mon, 12 Dec 2022 21:09:09 -0800 (PST)
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BD4SvRY024800;
        Tue, 13 Dec 2022 05:08:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=np0D6Uq2NQvTYj7BmkBS1KO7RXVElvnOg8OEij8CeSs=;
 b=YknAUS+KxfzjtVDe4vGV+zs5lvKtMoUG5E2Fqn/pBBQUXfDKIvEFHF2XAHhjy7QFuL6y
 Y2qjgCf0kSGUtc/g6rsvdqdv4J6cNJxYqSSNuDi9tj1QCKOoseHjZy2dw9KezdeN33sC
 KszmyDXOCqY5IY0Xz4gW2T1xAOKuZTSxAwf+bA5eC7KYaQ9gRfqzuW5eaAyZkHlIdpGy
 9CmfkuPSZuHCe4nf6kttnqu8w83DhTSp/aUNbSLatlvma/y4k1HniO5NdW9IunR8SEjU
 41A+p3UWFI2lff9HY20bcinI4tdTLPSlaNRZHFLCtWMGDcLfZqUpI/jj6yaLui30xy7H oQ== 
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3mcjb96bsq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 05:08:58 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 2BD58sKl029857
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 05:08:54 GMT
Received: from [10.50.38.23] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 12 Dec
 2022 21:08:49 -0800
Message-ID: <967b48db-f44b-939b-08a3-b8f9250a8605@quicinc.com>
Date:   Tue, 13 Dec 2022 10:38:46 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Subject: Re: [PATCH v2 10/13] arm64: dts: qcom: sm8450: Fix the base addresses
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
 <20221212123311.146261-11-manivannan.sadhasivam@linaro.org>
From:   Sai Prakash Ranjan <quic_saipraka@quicinc.com>
In-Reply-To: <20221212123311.146261-11-manivannan.sadhasivam@linaro.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: VI9qQNGP3c0WrUdDxmtUxmcFXkfA_I2U
X-Proofpoint-ORIG-GUID: VI9qQNGP3c0WrUdDxmtUxmcFXkfA_I2U
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-13_02,2022-12-12_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 impostorscore=0 spamscore=0 mlxlogscore=999
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212130047
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
> Cc: <stable@vger.kernel.org> # 5.18
> Fixes: 1dc3e50eb680 ("arm64: dts: qcom: sm8450: Add LLCC/system-cache-controller node")
> Reported-by: Parikshit Pareek <quic_ppareek@quicinc.com>
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
>   arch/arm64/boot/dts/qcom/sm8450.dtsi | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sm8450.dtsi b/arch/arm64/boot/dts/qcom/sm8450.dtsi
> index 570475040d95..30685857021a 100644
> --- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
> @@ -3640,8 +3640,9 @@ gem_noc: interconnect@19100000 {
>   
>   		system-cache-controller@19200000 {
>   			compatible = "qcom,sm8450-llcc";
> -			reg = <0 0x19200000 0 0x580000>, <0 0x19a00000 0 0x80000>;
> -			reg-names = "llcc_base", "llcc_broadcast_base";
> +			reg = <0 0x19200000 0 0x80000>, <0 0x19600000 0 0x80000>,
> +			      <0 0x19300000 0 0x80000>, <0 0x19700000 0 0x80000>,
> +			      <0 0x19a00000 0 0x80000>;
>   			interrupts = <GIC_SPI 266 IRQ_TYPE_LEVEL_HIGH>;
>   		};
>   

Reviewed-by: Sai Prakash Ranjan <quic_saipraka@quicinc.com>

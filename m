Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB125A6AFA
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 19:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbiH3Rjj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 13:39:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232297AbiH3Riu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 13:38:50 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C68CF23D0;
        Tue, 30 Aug 2022 10:36:10 -0700 (PDT)
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27UFx294005591;
        Tue, 30 Aug 2022 17:34:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=F+JHeRN8PToozitBrhdv/oNgrBd/V/BN8qJ5YgZ6y3A=;
 b=Q6aVkRA3hwQE7Dx4uV30w0WB0adFEdbn0/BIURgSZjy6fFOK/PMuDjqRYp3zml7h7lzY
 HuM51aBFO2aCbT1d3bheglCJIrM6bkDYqDlfwJ3PCoIid5kqFuRb7CEJNLybd8w7vZ6x
 o2d+cs/TrvcT4oyRRlDdjl5dbjhi2urRZ+WKJ/OuMu6iv6A1zbE0QSOAS2T/IsBGMdyG
 1j7isLrrj9fL/7WDKRMja3Wru1hS/0vtVTOnZlGxiYfyI/wb53uCwvLq4R8SaqycjrFk
 QKKFeA6c7cEHlejyk/71m6KLYspVoLW0nj5IptNWKpKFHc9U39Lb6InA0s4wkNTgIf3X Ug== 
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3j9m2t0m8y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Aug 2022 17:34:00 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 27UHXxOg005519
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Aug 2022 17:33:59 GMT
Received: from [10.110.39.132] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Tue, 30 Aug
 2022 10:33:58 -0700
Message-ID: <a437b91a-281d-56b3-41bf-15d9593ece74@quicinc.com>
Date:   Tue, 30 Aug 2022 10:33:58 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH 1/3] slimbus: qcom-ngd: use correct error in message of
 pdr_add_lookup() failure
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-arm-msm@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>
CC:     <stable@vger.kernel.org>
References: <20220830121359.634344-1-krzysztof.kozlowski@linaro.org>
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <20220830121359.634344-1-krzysztof.kozlowski@linaro.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: kCyURfhdLxmWT3BuVaOOtQftpVhRUuqZ
X-Proofpoint-ORIG-GUID: kCyURfhdLxmWT3BuVaOOtQftpVhRUuqZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-30_10,2022-08-30_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 adultscore=0 mlxlogscore=963 bulkscore=0 suspectscore=0
 mlxscore=0 clxscore=1011 spamscore=0 malwarescore=0 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208300081
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/30/2022 5:13 AM, Krzysztof Kozlowski wrote:
> Use cprrect error code, instead of previous 'ret' value, when printing

s/cprrect/correct/

> error from pdr_add_lookup() failure.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: e1ae85e1830e ("slimbus: qcom-ngd-ctrl: add Protection Domain Restart Support")
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> ---
>   drivers/slimbus/qcom-ngd-ctrl.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/slimbus/qcom-ngd-ctrl.c b/drivers/slimbus/qcom-ngd-ctrl.c
> index 0aa8408464ad..6fe6abb86061 100644
> --- a/drivers/slimbus/qcom-ngd-ctrl.c
> +++ b/drivers/slimbus/qcom-ngd-ctrl.c
> @@ -1581,6 +1581,7 @@ static int qcom_slim_ngd_ctrl_probe(struct platform_device *pdev)
>   
>   	pds = pdr_add_lookup(ctrl->pdr, "avs/audio", "msm/adsp/audio_pd");
>   	if (IS_ERR(pds) && PTR_ERR(pds) != -EALREADY) {
> +		ret = PTR_ERR(pds);
>   		dev_err(dev, "pdr add lookup failed: %d\n", ret);
>   		return PTR_ERR(pds);

return ret?

>   	}


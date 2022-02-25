Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5F04C4478
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 13:19:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237033AbiBYMTk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 07:19:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235824AbiBYMTj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 07:19:39 -0500
Received: from alexa-out-sd-02.qualcomm.com (alexa-out-sd-02.qualcomm.com [199.106.114.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B96E8233E79;
        Fri, 25 Feb 2022 04:19:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1645791547; x=1677327547;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=lxyF5APYXOxvPtBabNLVVucsJh4r1OscvMnbZd7vZPQ=;
  b=IBKuMMF7zFc2tjzU48HryQhsSLbqPqOObopuAPs9M2mantH0FrXahmCf
   pAge7X9HE2Tl3WU4M2RG7Q3uudkBoW/rXqbXz4aJhVnzk9GnP0EugMD2m
   ucIy74eDe+dZpxPXsdi7T2One6gqrwsJy5mZxj3f//KN6dogN0Xui/57P
   8=;
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 25 Feb 2022 04:19:07 -0800
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg03-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 04:18:59 -0800
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Fri, 25 Feb 2022 04:18:58 -0800
Received: from [10.50.14.147] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.15; Fri, 25 Feb
 2022 04:18:55 -0800
Subject: Re: [PATCH] arm64: dts: qcom: ipq8074: fix the sleep clock frequency
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
CC:     <agross@kernel.org>, <robh+dt@kernel.org>, <varada@codeaurora.org>,
        <mraghava@codeaurora.org>, <linux-arm-msm@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, <quic_srichara@quicinc.com>
References: <1644581655-11568-1-git-send-email-quic_kathirav@quicinc.com>
 <YhfjLNHCZeK4hYKa@builder.lan>
From:   Kathiravan Thirumoorthy <quic_kathirav@quicinc.com>
Message-ID: <848671a3-dcf0-9968-f3fd-a3c5b9902ccf@quicinc.com>
Date:   Fri, 25 Feb 2022 17:48:51 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YhfjLNHCZeK4hYKa@builder.lan>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2/25/2022 1:27 AM, Bjorn Andersson wrote:
> On Fri 11 Feb 06:14 CST 2022, Kathiravan T wrote:
>
>> Sleep clock frequency should be 32768Hz. Lets fix it.
>>
>> Cc: stable@vger.kernel.org
>> Fixes: 41dac73e243d ("arm64: dts: Add ipq8074 SoC and HK01 board support")
>> Link: https://lore.kernel.org/all/e2a447f8-6024-0369-f698-2027b6edcf9e@codeaurora.org/
>> Signed-off-by: Kathiravan T <quic_kathirav@quicinc.com>
> Can you please confirm this? The documentation for GCC says that the
> incoming sleep clock is 32000Hz.
>
> Regards,
> Bjorn

Bjorn,

I checked the internal documents and it is derived from the PMIC as 
32.7645KHz. I rounded off it to 32768Hz. Looks like GCC documentation is 
not up-to-date.

All these information is available in the link 
https://lore.kernel.org/all/e2a447f8-6024-0369-f698-2027b6edcf9e@codeaurora.org/

Please let me know if you need any further information.

Thanks,

Kathiravan T.

>> ---
>>   arch/arm64/boot/dts/qcom/ipq8074.dtsi | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/boot/dts/qcom/ipq8074.dtsi b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
>> index 26ba7ce9222c..b6287355ad08 100644
>> --- a/arch/arm64/boot/dts/qcom/ipq8074.dtsi
>> +++ b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
>> @@ -13,7 +13,7 @@
>>   	clocks {
>>   		sleep_clk: sleep_clk {
>>   			compatible = "fixed-clock";
>> -			clock-frequency = <32000>;
>> +			clock-frequency = <32768>;
>>   			#clock-cells = <0>;
>>   		};
>>   
>> -- 
>> 2.7.4
>>

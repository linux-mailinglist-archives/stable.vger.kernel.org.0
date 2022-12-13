Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8C064BC40
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 19:45:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236565AbiLMSpF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 13:45:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236463AbiLMSpE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 13:45:04 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EC1924BD9
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 10:45:02 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id p8so6381701lfu.11
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 10:45:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bygeSP9QP2A1yajktVRv5LzfJbJ7Y6WvovdOKDRW6v0=;
        b=Uvsvk954VnxphPn733h3hsPRnAmgAkqycQjyDC68v8titNmhi0c4TcSQC+iKRfLdTz
         GLrYPgho4bP8gNq4w5cIcZ761nIVsMOVXnnd0lLVzhAFM18GHhDcILEwp6YbwLRmiaoh
         rPUj2t+MT6iatl3yDEXGcuMZuqRmHg9watQyh7lRr6YvAQghDH0w/5IzOe08WrK5F8LF
         /1HjlNW3RpwmdjAO7GkaDLIP6LmL+756SC2EFtDptAl/plrDUMuWWv1KzBsjDv2VhKDR
         9X5QGb6dLvIP3ikfeknuR749lippsbg60rqoP71M31HAIihTbXgbc73F6oco6WnfwrUP
         DvIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bygeSP9QP2A1yajktVRv5LzfJbJ7Y6WvovdOKDRW6v0=;
        b=JUFgC9rQTmAJHYlkgCVHQgvqKDJy69FordkZfGs7NSz42c3fZF0uGBzkvjFOU7RWjY
         HvaDHnvh/8pQgRa9yfS9zlxDllpB0r2lfA70N+yEn+vr2To9sXQt9qhVhgJ7FPS/V9mn
         l3/MavevhT49bK1pHpE9GnTwvYxBd+/sUteBfAUAAIW7H6BC78sprAQV+eAP8xaMVqZC
         eNajKcW/jftvaEG+XakbSnK58HUACME22r3ouUFgGp+MkoFOkKBX8+Rt9ThqI5X9lrrS
         QHdmvSqdCP7QApc/KhocIbb29ZLeCiju9RiPfLr6G4hWk0YhHhbZLWZLSmBTdKATeppT
         K9iw==
X-Gm-Message-State: ANoB5pnE6whE+yUXCslc+DkU4OMdIIS9bhS/+mR5nLfELT6H5lie2F/f
        qWROnA9yAQCfgucNxxqjb6qM4Q==
X-Google-Smtp-Source: AA0mqf7QW2ia6f84MUwzjabJ7cgINJPulUlCcn9ZzZtmNZw30bmNNqAeULkTUmGVsY7PAa8mztCGxQ==
X-Received: by 2002:ac2:4c33:0:b0:4b5:26f3:2247 with SMTP id u19-20020ac24c33000000b004b526f32247mr4974508lfq.69.1670957100561;
        Tue, 13 Dec 2022 10:45:00 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id m5-20020a056512114500b004b57db96aabsm474853lfg.52.2022.12.13.10.44.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Dec 2022 10:45:00 -0800 (PST)
Message-ID: <1fb6adb5-dafe-3399-ba6e-b4b074973f1c@linaro.org>
Date:   Tue, 13 Dec 2022 19:44:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 12/13] qcom: llcc/edac: Fix the base address used for
 accessing LLCC banks
Content-Language: en-US
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     andersson@kernel.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, bp@alien8.de,
        tony.luck@intel.com, quic_saipraka@quicinc.com,
        konrad.dybcio@linaro.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, james.morse@arm.com,
        mchehab@kernel.org, rric@kernel.org, linux-edac@vger.kernel.org,
        quic_ppareek@quicinc.com, luca.weiss@fairphone.com,
        stable@vger.kernel.org
References: <20221212123311.146261-1-manivannan.sadhasivam@linaro.org>
 <20221212123311.146261-13-manivannan.sadhasivam@linaro.org>
 <ccd54883-d369-8387-881a-b5ac7a377c97@linaro.org>
 <20221213174406.GH4862@thinkpad>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221213174406.GH4862@thinkpad>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 13/12/2022 18:44, Manivannan Sadhasivam wrote:
> On Tue, Dec 13, 2022 at 05:37:37PM +0100, Krzysztof Kozlowski wrote:
>> On 12/12/2022 13:33, Manivannan Sadhasivam wrote:
>>> The Qualcomm LLCC/EDAC drivers were using a fixed register stride for
>>> accessing the (Control and Status Registers) CSRs of each LLCC bank.
>>> This stride only works for some SoCs like SDM845 for which driver
>>> support was initially added.
>>>
>>> But the later SoCs use different register stride that vary between the
>>> banks with holes in-between. So it is not possible to use a single register
>>> stride for accessing the CSRs of each bank. By doing so could result in a
>>> crash.
>>>
>>> For fixing this issue, let's obtain the base address of each LLCC bank from
>>> devicetree and get rid of the fixed stride. This also means, we no longer
>>> need to rely on reg-names property and get the base addresses using index.
>>>
>>> First index is LLCC bank 0 and last index is LLCC broadcast. If the SoC
>>> supports more than one bank, then those needs to be defined in devicetree
>>> for index from 1..N-1.
>>>
>>> Cc: <stable@vger.kernel.org> # 4.20
>>> Fixes: a3134fb09e0b ("drivers: soc: Add LLCC driver")
>>> Fixes: 27450653f1db ("drivers: edac: Add EDAC driver support for QCOM SoCs")
>>
>> Your previous patches in the series had incorrect CC-stable/Fixes tags,
>> thus I have doubts also here.
>>
> 
> Sorry I do not agree with you. I wanted to backport binding, dts and driver
> patches to possible LTS kernels together and that's why I tagged stable list.
> 
> Either all goes to stable or none. If your question is more towards what if one
> goes before the other, then in that case I may need to specify the dependency
> of commits but that will look messy. I took the gamble because, the driver is
> already broken in stable kernels.

I understand the intention. Assuming SDM845 was working, by backporting
it you affect all stable users while fixing other SoCs. Therefore the
patch would be worth backports only if other users with SDM845 were not
affected.

> 
>>> Reported-by: Parikshit Pareek <quic_ppareek@quicinc.com>
>>> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
>>> ---
>>>  drivers/edac/qcom_edac.c           | 14 +++---
>>>  drivers/soc/qcom/llcc-qcom.c       | 72 +++++++++++++++++-------------
>>>  include/linux/soc/qcom/llcc-qcom.h |  6 +--
>>>  3 files changed, 48 insertions(+), 44 deletions(-)
>>>
>>> diff --git a/drivers/edac/qcom_edac.c b/drivers/edac/qcom_edac.c
>>> index 97a27e42dd61..5be93577fc03 100644
>>> --- a/drivers/edac/qcom_edac.c
>>> +++ b/drivers/edac/qcom_edac.c
>>> @@ -213,7 +213,7 @@ dump_syn_reg_values(struct llcc_drv_data *drv, u32 bank, int err_type)
>>>  
>>>  	for (i = 0; i < reg_data.reg_cnt; i++) {
>>>  		synd_reg = reg_data.synd_reg + (i * 4);
>>> -		ret = regmap_read(drv->regmap, drv->offsets[bank] + synd_reg,
>>> +		ret = regmap_read(drv->regmaps[bank], synd_reg,
>>>  				  &synd_val);
>>>  		if (ret)
>>>  			goto clear;
>>> @@ -222,8 +222,7 @@ dump_syn_reg_values(struct llcc_drv_data *drv, u32 bank, int err_type)
>>>  			    reg_data.name, i, synd_val);
>>>  	}
>>>  
>>> -	ret = regmap_read(drv->regmap,
>>> -			  drv->offsets[bank] + reg_data.count_status_reg,
>>> +	ret = regmap_read(drv->regmaps[bank], reg_data.count_status_reg,
>>>  			  &err_cnt);
>>>  	if (ret)
>>>  		goto clear;
>>> @@ -233,8 +232,7 @@ dump_syn_reg_values(struct llcc_drv_data *drv, u32 bank, int err_type)
>>>  	edac_printk(KERN_CRIT, EDAC_LLCC, "%s: Error count: 0x%4x\n",
>>>  		    reg_data.name, err_cnt);
>>>  
>>> -	ret = regmap_read(drv->regmap,
>>> -			  drv->offsets[bank] + reg_data.ways_status_reg,
>>> +	ret = regmap_read(drv->regmaps[bank], reg_data.ways_status_reg,
>>>  			  &err_ways);
>>>  	if (ret)
>>>  		goto clear;
>>> @@ -296,8 +294,7 @@ llcc_ecc_irq_handler(int irq, void *edev_ctl)
>>>  
>>>  	/* Iterate over the banks and look for Tag RAM or Data RAM errors */
>>>  	for (i = 0; i < drv->num_banks; i++) {
>>> -		ret = regmap_read(drv->regmap,
>>> -				  drv->offsets[i] + DRP_INTERRUPT_STATUS,
>>> +		ret = regmap_read(drv->regmaps[i], DRP_INTERRUPT_STATUS,
>>>  				  &drp_error);
>>>  
>>>  		if (!ret && (drp_error & SB_ECC_ERROR)) {
>>> @@ -312,8 +309,7 @@ llcc_ecc_irq_handler(int irq, void *edev_ctl)
>>>  		if (!ret)
>>>  			irq_rc = IRQ_HANDLED;
>>>  
>>> -		ret = regmap_read(drv->regmap,
>>> -				  drv->offsets[i] + TRP_INTERRUPT_0_STATUS,
>>> +		ret = regmap_read(drv->regmaps[i], TRP_INTERRUPT_0_STATUS,
>>>  				  &trp_error);
>>>  
>>>  		if (!ret && (trp_error & SB_ECC_ERROR)) {
>>> diff --git a/drivers/soc/qcom/llcc-qcom.c b/drivers/soc/qcom/llcc-qcom.c
>>> index 23ce2f78c4ed..a29f22dad7fa 100644
>>> --- a/drivers/soc/qcom/llcc-qcom.c
>>> +++ b/drivers/soc/qcom/llcc-qcom.c
>>> @@ -62,8 +62,6 @@
>>>  #define LLCC_TRP_WRSC_CACHEABLE_EN    0x21f2c
>>>  #define LLCC_TRP_ALGO_CFG8	      0x21f30
>>>  
>>> -#define BANK_OFFSET_STRIDE	      0x80000
>>> -
>>>  #define LLCC_VERSION_2_0_0_0          0x02000000
>>>  #define LLCC_VERSION_2_1_0_0          0x02010000
>>>  #define LLCC_VERSION_4_1_0_0          0x04010000
>>> @@ -898,8 +896,8 @@ static int qcom_llcc_remove(struct platform_device *pdev)
>>>  	return 0;
>>>  }
>>>  
>>> -static struct regmap *qcom_llcc_init_mmio(struct platform_device *pdev,
>>> -		const char *name)
>>> +static struct regmap *qcom_llcc_init_mmio(struct platform_device *pdev, u8 index,
>>> +					  const char *name)
>>>  {
>>>  	void __iomem *base;
>>>  	struct regmap_config llcc_regmap_config = {
>>> @@ -909,7 +907,7 @@ static struct regmap *qcom_llcc_init_mmio(struct platform_device *pdev,
>>>  		.fast_io = true,
>>>  	};
>>>  
>>> -	base = devm_platform_ioremap_resource_byname(pdev, name);
>>> +	base = devm_platform_ioremap_resource(pdev, index);
>>>  	if (IS_ERR(base))
>>>  		return ERR_CAST(base);
>>>  
>>> @@ -927,6 +925,7 @@ static int qcom_llcc_probe(struct platform_device *pdev)
>>>  	const struct llcc_slice_config *llcc_cfg;
>>>  	u32 sz;
>>>  	u32 version;
>>> +	struct regmap *regmap;
>>>  
>>>  	drv_data = devm_kzalloc(dev, sizeof(*drv_data), GFP_KERNEL);
>>>  	if (!drv_data) {
>>> @@ -934,21 +933,51 @@ static int qcom_llcc_probe(struct platform_device *pdev)
>>>  		goto err;
>>>  	}
>>>  
>>> -	drv_data->regmap = qcom_llcc_init_mmio(pdev, "llcc_base");
>>> -	if (IS_ERR(drv_data->regmap)) {
>>> -		ret = PTR_ERR(drv_data->regmap);
>>> +	/* Initialize the first LLCC bank regmap */
>>> +	regmap = qcom_llcc_init_mmio(pdev, i, "llcc0_base");
>>
>> What is the value of "i" here? Looks like not initialized in my next.
>>
> 
> Yes, this was a mistake and been reported by kernel bot. It will be fixed in
> next version.
> 
>>> +	if (IS_ERR(regmap)) {
>>> +		ret = PTR_ERR(regmap);
>>>  		goto err;
>>>  	}
>>>  
>>> -	drv_data->bcast_regmap =
>>> -		qcom_llcc_init_mmio(pdev, "llcc_broadcast_base");
>>> +	cfg = of_device_get_match_data(&pdev->dev);
>>> +
>>> +	ret = regmap_read(regmap, cfg->reg_offset[LLCC_COMMON_STATUS0], &num_banks);
>>> +	if (ret)
>>> +		goto err;
>>> +
>>> +	num_banks &= LLCC_LB_CNT_MASK;
>>> +	num_banks >>= LLCC_LB_CNT_SHIFT;
>>> +	drv_data->num_banks = num_banks;
>>> +
>>> +	drv_data->regmaps = devm_kcalloc(dev, num_banks, sizeof(*drv_data->regmaps), GFP_KERNEL);
>>> +	if (!drv_data->regmaps) {
>>> +		ret = -ENOMEM;
>>> +		goto err;
>>> +	}
>>> +
>>> +	drv_data->regmaps[0] = regmap;
>>> +
>>> +	/* Initialize rest of LLCC bank regmaps */
>>> +	for (i = 1; i < num_banks; i++) {
>>> +		char *base = kasprintf(GFP_KERNEL, "llcc%d_base", i);
>>> +
>>> +		drv_data->regmaps[i] = qcom_llcc_init_mmio(pdev, i, base);
>>> +		if (IS_ERR(drv_data->regmaps[i])) {
>>> +			ret = PTR_ERR(drv_data->regmaps[i]);
>>> +			kfree(base);
>>> +			goto err;
>>
>> This looks like the ABI break so:
>> 1. Existing users are broken,
> 
> I fixed the dts for all affected SoCs, then who are all other existing users?

In the case of the bindings and DTS the other users are:
All DTS in the wild (out-of-tree customers, forks), all other operating
systems (BSD), firmware and bootloaders.

In the case of the driver we talk about all out of tree DTS, which you
did not fix. Kernel must work with old or any other DTB which conforms
to the ABI (bindings). You cannot change ABI to work around that...

> 
>> 2. It cannot be backported.
>>
> 
> This is a bug fix and clearly needs to be backported along with the dts
> changes. For this purpose only I have tagged both dts and driver patches for
> backporting. Am I missing anything here?

You cannot backport ABI break for Linux. We assume ABI should not be
broken for current/future releases, but this we sometimes ignore. There
are reasons. However for the past and stable releases - it's a no go...
unless it never, never worked.

What you can do, is to have patch which does not break ABI for working
platforms (SDM845?). Such patch can be backported.


Best regards,
Krzysztof


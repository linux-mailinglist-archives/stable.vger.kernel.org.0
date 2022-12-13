Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BCFF64B9E8
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 17:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236101AbiLMQhu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 11:37:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235748AbiLMQhq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 11:37:46 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E99AE7D
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 08:37:41 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id p8so5792979lfu.11
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 08:37:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nJmveI1EzFl25JXztlXglydAsBVD2/XMHE9l8DsRTlI=;
        b=RwfR8zRK3MYbnTCcPhz9yIDCQ+2mSc3EosT6pv8VINmlPnelyXuB3zzjsZCLOzbmdj
         zQEoWfxn5oJ/0qilJJyM2bmOUZ3FwIAIZwy87zhvxqsYtWPUtS1MPZtINZBiP4D53OLt
         mIDfHdNhaP/L9L1GmCtFB9OjOsxS36Oa/RMo4gMyb/e/qqEAVlyZHt0yPsa8jVr83ZmV
         nEom8nMb/BRW+RMnYUREFZNqwmjRt5EaNhqzUKmJzG/asYWmgCftJ8rBO7z1fa0pMwON
         7ryV79mIi4eaVAuyhOeMQHUz2Hb4lWCrSWemqtZ5EyPzQTDeizAQ60pD2kPgtv0V+QAy
         jB/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nJmveI1EzFl25JXztlXglydAsBVD2/XMHE9l8DsRTlI=;
        b=dlS8D5Jr2L81WsC8e4pO0rNc45GA+8Tfe4J/pLzDZvzztCj+FZ0jQwpcPbI5qWIMC/
         0FMnZNLuBfI3+LT1q1K6Q8CbUACm5LHyAT2u92UP+8BmMvcDumseMSgel4Z+ZAnKYL31
         iGW2PvH1HxOTeDW3/+NaGrDBTwM37uo04n+1IFuByPHXQjINsF2ucEHNfygLhaathix5
         0ajxTaGAEUzuKNsPHuSzvMTYp1t4i8Ia7iQnsJrQBLn2Dl/YN/1H/wUF4yVGqUGj6UGl
         9h3W8Z83FXuHl4QFJ6djTsX1IEGxxRs5vo0meUEmbrWA9e2y9JAobL5AJbRUvDyntCwV
         GWZw==
X-Gm-Message-State: ANoB5pkxTg9qqgkbUNw0Wx6olSCqKbBiqQMO2mEJzqPXkIOGynoav2w/
        ut0hRM3s6dOa4+lBpheRmO7jcg==
X-Google-Smtp-Source: AA0mqf7i8LayARuRsNz6h637Yw0zJPKmGUypgttUongRBvXjonAe9Yw00qOWx/PhwmNAU4jDKCYZEQ==
X-Received: by 2002:ac2:443c:0:b0:4b5:5bc1:678c with SMTP id w28-20020ac2443c000000b004b55bc1678cmr5371281lfl.21.1670949459476;
        Tue, 13 Dec 2022 08:37:39 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id a15-20020ac25e6f000000b00494942bec60sm434479lfr.17.2022.12.13.08.37.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Dec 2022 08:37:39 -0800 (PST)
Message-ID: <ccd54883-d369-8387-881a-b5ac7a377c97@linaro.org>
Date:   Tue, 13 Dec 2022 17:37:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 12/13] qcom: llcc/edac: Fix the base address used for
 accessing LLCC banks
Content-Language: en-US
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        andersson@kernel.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, bp@alien8.de,
        tony.luck@intel.com
Cc:     quic_saipraka@quicinc.com, konrad.dybcio@linaro.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        james.morse@arm.com, mchehab@kernel.org, rric@kernel.org,
        linux-edac@vger.kernel.org, quic_ppareek@quicinc.com,
        luca.weiss@fairphone.com, stable@vger.kernel.org
References: <20221212123311.146261-1-manivannan.sadhasivam@linaro.org>
 <20221212123311.146261-13-manivannan.sadhasivam@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221212123311.146261-13-manivannan.sadhasivam@linaro.org>
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

On 12/12/2022 13:33, Manivannan Sadhasivam wrote:
> The Qualcomm LLCC/EDAC drivers were using a fixed register stride for
> accessing the (Control and Status Registers) CSRs of each LLCC bank.
> This stride only works for some SoCs like SDM845 for which driver
> support was initially added.
> 
> But the later SoCs use different register stride that vary between the
> banks with holes in-between. So it is not possible to use a single register
> stride for accessing the CSRs of each bank. By doing so could result in a
> crash.
> 
> For fixing this issue, let's obtain the base address of each LLCC bank from
> devicetree and get rid of the fixed stride. This also means, we no longer
> need to rely on reg-names property and get the base addresses using index.
> 
> First index is LLCC bank 0 and last index is LLCC broadcast. If the SoC
> supports more than one bank, then those needs to be defined in devicetree
> for index from 1..N-1.
> 
> Cc: <stable@vger.kernel.org> # 4.20
> Fixes: a3134fb09e0b ("drivers: soc: Add LLCC driver")
> Fixes: 27450653f1db ("drivers: edac: Add EDAC driver support for QCOM SoCs")

Your previous patches in the series had incorrect CC-stable/Fixes tags,
thus I have doubts also here.

Can you confirm, that this patch alone (alone! Without DTS patches) when
backported to v4.20, still works perfectly fine for sdm845?

> Reported-by: Parikshit Pareek <quic_ppareek@quicinc.com>
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
>  drivers/edac/qcom_edac.c           | 14 +++---
>  drivers/soc/qcom/llcc-qcom.c       | 72 +++++++++++++++++-------------
>  include/linux/soc/qcom/llcc-qcom.h |  6 +--
>  3 files changed, 48 insertions(+), 44 deletions(-)
> 
> diff --git a/drivers/edac/qcom_edac.c b/drivers/edac/qcom_edac.c
> index 97a27e42dd61..5be93577fc03 100644
> --- a/drivers/edac/qcom_edac.c
> +++ b/drivers/edac/qcom_edac.c
> @@ -213,7 +213,7 @@ dump_syn_reg_values(struct llcc_drv_data *drv, u32 bank, int err_type)
>  
>  	for (i = 0; i < reg_data.reg_cnt; i++) {
>  		synd_reg = reg_data.synd_reg + (i * 4);
> -		ret = regmap_read(drv->regmap, drv->offsets[bank] + synd_reg,
> +		ret = regmap_read(drv->regmaps[bank], synd_reg,
>  				  &synd_val);
>  		if (ret)
>  			goto clear;
> @@ -222,8 +222,7 @@ dump_syn_reg_values(struct llcc_drv_data *drv, u32 bank, int err_type)
>  			    reg_data.name, i, synd_val);
>  	}
>  
> -	ret = regmap_read(drv->regmap,
> -			  drv->offsets[bank] + reg_data.count_status_reg,
> +	ret = regmap_read(drv->regmaps[bank], reg_data.count_status_reg,
>  			  &err_cnt);
>  	if (ret)
>  		goto clear;
> @@ -233,8 +232,7 @@ dump_syn_reg_values(struct llcc_drv_data *drv, u32 bank, int err_type)
>  	edac_printk(KERN_CRIT, EDAC_LLCC, "%s: Error count: 0x%4x\n",
>  		    reg_data.name, err_cnt);
>  
> -	ret = regmap_read(drv->regmap,
> -			  drv->offsets[bank] + reg_data.ways_status_reg,
> +	ret = regmap_read(drv->regmaps[bank], reg_data.ways_status_reg,
>  			  &err_ways);
>  	if (ret)
>  		goto clear;
> @@ -296,8 +294,7 @@ llcc_ecc_irq_handler(int irq, void *edev_ctl)
>  
>  	/* Iterate over the banks and look for Tag RAM or Data RAM errors */
>  	for (i = 0; i < drv->num_banks; i++) {
> -		ret = regmap_read(drv->regmap,
> -				  drv->offsets[i] + DRP_INTERRUPT_STATUS,
> +		ret = regmap_read(drv->regmaps[i], DRP_INTERRUPT_STATUS,
>  				  &drp_error);
>  
>  		if (!ret && (drp_error & SB_ECC_ERROR)) {
> @@ -312,8 +309,7 @@ llcc_ecc_irq_handler(int irq, void *edev_ctl)
>  		if (!ret)
>  			irq_rc = IRQ_HANDLED;
>  
> -		ret = regmap_read(drv->regmap,
> -				  drv->offsets[i] + TRP_INTERRUPT_0_STATUS,
> +		ret = regmap_read(drv->regmaps[i], TRP_INTERRUPT_0_STATUS,
>  				  &trp_error);
>  
>  		if (!ret && (trp_error & SB_ECC_ERROR)) {
> diff --git a/drivers/soc/qcom/llcc-qcom.c b/drivers/soc/qcom/llcc-qcom.c
> index 23ce2f78c4ed..a29f22dad7fa 100644
> --- a/drivers/soc/qcom/llcc-qcom.c
> +++ b/drivers/soc/qcom/llcc-qcom.c
> @@ -62,8 +62,6 @@
>  #define LLCC_TRP_WRSC_CACHEABLE_EN    0x21f2c
>  #define LLCC_TRP_ALGO_CFG8	      0x21f30
>  
> -#define BANK_OFFSET_STRIDE	      0x80000
> -
>  #define LLCC_VERSION_2_0_0_0          0x02000000
>  #define LLCC_VERSION_2_1_0_0          0x02010000
>  #define LLCC_VERSION_4_1_0_0          0x04010000
> @@ -898,8 +896,8 @@ static int qcom_llcc_remove(struct platform_device *pdev)
>  	return 0;
>  }
>  
> -static struct regmap *qcom_llcc_init_mmio(struct platform_device *pdev,
> -		const char *name)
> +static struct regmap *qcom_llcc_init_mmio(struct platform_device *pdev, u8 index,
> +					  const char *name)
>  {
>  	void __iomem *base;
>  	struct regmap_config llcc_regmap_config = {
> @@ -909,7 +907,7 @@ static struct regmap *qcom_llcc_init_mmio(struct platform_device *pdev,
>  		.fast_io = true,
>  	};
>  
> -	base = devm_platform_ioremap_resource_byname(pdev, name);
> +	base = devm_platform_ioremap_resource(pdev, index);
>  	if (IS_ERR(base))
>  		return ERR_CAST(base);
>  
> @@ -927,6 +925,7 @@ static int qcom_llcc_probe(struct platform_device *pdev)
>  	const struct llcc_slice_config *llcc_cfg;
>  	u32 sz;
>  	u32 version;
> +	struct regmap *regmap;
>  
>  	drv_data = devm_kzalloc(dev, sizeof(*drv_data), GFP_KERNEL);
>  	if (!drv_data) {
> @@ -934,21 +933,51 @@ static int qcom_llcc_probe(struct platform_device *pdev)
>  		goto err;
>  	}
>  
> -	drv_data->regmap = qcom_llcc_init_mmio(pdev, "llcc_base");
> -	if (IS_ERR(drv_data->regmap)) {
> -		ret = PTR_ERR(drv_data->regmap);
> +	/* Initialize the first LLCC bank regmap */
> +	regmap = qcom_llcc_init_mmio(pdev, i, "llcc0_base");

What is the value of "i" here? Looks like not initialized in my next.

> +	if (IS_ERR(regmap)) {
> +		ret = PTR_ERR(regmap);
>  		goto err;
>  	}
>  
> -	drv_data->bcast_regmap =
> -		qcom_llcc_init_mmio(pdev, "llcc_broadcast_base");
> +	cfg = of_device_get_match_data(&pdev->dev);
> +
> +	ret = regmap_read(regmap, cfg->reg_offset[LLCC_COMMON_STATUS0], &num_banks);
> +	if (ret)
> +		goto err;
> +
> +	num_banks &= LLCC_LB_CNT_MASK;
> +	num_banks >>= LLCC_LB_CNT_SHIFT;
> +	drv_data->num_banks = num_banks;
> +
> +	drv_data->regmaps = devm_kcalloc(dev, num_banks, sizeof(*drv_data->regmaps), GFP_KERNEL);
> +	if (!drv_data->regmaps) {
> +		ret = -ENOMEM;
> +		goto err;
> +	}
> +
> +	drv_data->regmaps[0] = regmap;
> +
> +	/* Initialize rest of LLCC bank regmaps */
> +	for (i = 1; i < num_banks; i++) {
> +		char *base = kasprintf(GFP_KERNEL, "llcc%d_base", i);
> +
> +		drv_data->regmaps[i] = qcom_llcc_init_mmio(pdev, i, base);
> +		if (IS_ERR(drv_data->regmaps[i])) {
> +			ret = PTR_ERR(drv_data->regmaps[i]);
> +			kfree(base);
> +			goto err;

This looks like the ABI break so:
1. Existing users are broken,
2. It cannot be backported.


> +		}
> +
> +		kfree(base);
> +	}
> +

Best regards,
Krzysztof


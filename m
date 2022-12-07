Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE796645C06
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 15:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbiLGOHL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Dec 2022 09:07:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230283AbiLGOGf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Dec 2022 09:06:35 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BE0763DE
        for <stable@vger.kernel.org>; Wed,  7 Dec 2022 06:06:26 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id v13-20020a17090a6b0d00b00219c3be9830so1733698pjj.4
        for <stable@vger.kernel.org>; Wed, 07 Dec 2022 06:06:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rZZ+QM1R3JQroiVfh8VlTCzZhA5RV6/2+12KVAmHsxk=;
        b=QSad23HRE1YyJnW35CON5SbD+UmTc5ox7hcu4zwyR5Hp/5oxntOHNTDSoj3U2GfybP
         9BLoTOn+geKrOMHj13SmGtIZyn4pdqeghKkTCepJbmHSh810XD1k2T4ZebivpE8J1UKp
         WKTPZmBOyrdDAO9fn9OVptU/XWOb/+8wFY+GknMap6HdatNe3tKo97j0Wc98iKbo4LAz
         oFrse5sFi/YyotkENvxQELzHidQjidhHVRAPY2W6q3OXieCllRhoYBXSelbgbCuuGG96
         SIMe2isPdGaSOeuUyb2jUB6NiFfyPbhpAfAOcmd94yfbiQBLDDXq+kWS6Lz+ipxK+GFa
         IKYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rZZ+QM1R3JQroiVfh8VlTCzZhA5RV6/2+12KVAmHsxk=;
        b=XQ1y1WG/OV3lg3dfhMQ1cMuf4jgsWlVfRlzH10COTFiFRsaJOE0vDDARxy3Hj658gH
         Pg9oV2l56L8reyNZSIfsnMXLgb8Qe30eWrYn7H4Mt1DbOoiq512ORfmiskean92e7wSC
         7uVFEwBXg0nKsMNt7iBjzx9xquiRrAA0rfq5jhdxE5Ptn9PZAg6RtJnc5C/Q7WqMQRC0
         OD/i8KL3Tr2s7CKYRpoxlSQdkSu4Vlb/FMm+w/0ykNVyAiz0NNWFRYW0CVY9F9WzTsQU
         Ulf9TKduR/Dm7bMQyR4ZtAlXJnjiSMnd7lsvb0u5A/hHJ5TsEk76GHqiKM+OowlzqR0V
         kZXQ==
X-Gm-Message-State: ANoB5pkzjirhsEBGwlWgm4J+TgSUF2RdYJv5l6wuQLBFdr/IEFMvNx/1
        Mwiyu44QRLtNfBSzulSc1jSs
X-Google-Smtp-Source: AA0mqf60Ed271Trt9KBsA+UHPVieNuY+xz/SdSq8Uem3PNqiELt2wIslP8k5F6HxqOQK6vS66L4spQ==
X-Received: by 2002:a17:903:41ca:b0:189:78d9:fe2e with SMTP id u10-20020a17090341ca00b0018978d9fe2emr54045472ple.96.1670421985450;
        Wed, 07 Dec 2022 06:06:25 -0800 (PST)
Received: from thinkpad ([117.216.123.5])
        by smtp.gmail.com with ESMTPSA id fv3-20020a17090b0e8300b00217090ece49sm1253367pjb.31.2022.12.07.06.06.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 06:06:24 -0800 (PST)
Date:   Wed, 7 Dec 2022 19:36:15 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     andersson@kernel.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, bp@alien8.de,
        tony.luck@intel.com
Cc:     quic_saipraka@quicinc.com, konrad.dybcio@linaro.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        james.morse@arm.com, mchehab@kernel.org, rric@kernel.org,
        linux-edac@vger.kernel.org, quic_ppareek@quicinc.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 12/12] llcc/edac: Fix the base address used for accessing
 LLCC banks
Message-ID: <20221207140615.GA315152@thinkpad>
References: <20221207135922.314827-1-manivannan.sadhasivam@linaro.org>
 <20221207135922.314827-13-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221207135922.314827-13-manivannan.sadhasivam@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 07, 2022 at 07:29:21PM +0530, Manivannan Sadhasivam wrote:
> The LLCC driver has been using a fixed register offset stride for accessing
> the CSRs of each LLCC bank. This offset only works for some SoCs like
> SDM845 for which driver support was initially added.
> 
> But the later SoCs use different register stride that vary between the
> banks with holes in-between. So it is not possible to use a single register
> stride for accessing the CSRs of each bank.
> 
> Hence, obtain the base address of each LLCC bank from devicetree and get
> rid of the fixed stride.
> 
> Cc: <stable@vger.kernel.org> # 4.20
> Fixes: a3134fb09e0b ("drivers: soc: Add LLCC driver")
> Fixes: 27450653f1db ("drivers: edac: Add EDAC driver support for QCOM SoCs")
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

Please ignore this patch as this is a duplicate that got sneaked in. I will
remove it in next version.

Thanks,
Mani

> ---
>  drivers/edac/qcom_edac.c           | 14 +++----
>  drivers/soc/qcom/llcc-qcom.c       | 64 ++++++++++++++++++------------
>  include/linux/soc/qcom/llcc-qcom.h |  4 +-
>  3 files changed, 44 insertions(+), 38 deletions(-)
> 
> diff --git a/drivers/edac/qcom_edac.c b/drivers/edac/qcom_edac.c
> index 97a27e42dd61..70bd39a91b89 100644
> --- a/drivers/edac/qcom_edac.c
> +++ b/drivers/edac/qcom_edac.c
> @@ -213,7 +213,7 @@ dump_syn_reg_values(struct llcc_drv_data *drv, u32 bank, int err_type)
>  
>  	for (i = 0; i < reg_data.reg_cnt; i++) {
>  		synd_reg = reg_data.synd_reg + (i * 4);
> -		ret = regmap_read(drv->regmap, drv->offsets[bank] + synd_reg,
> +		ret = regmap_read(drv->regmap[bank], synd_reg,
>  				  &synd_val);
>  		if (ret)
>  			goto clear;
> @@ -222,8 +222,7 @@ dump_syn_reg_values(struct llcc_drv_data *drv, u32 bank, int err_type)
>  			    reg_data.name, i, synd_val);
>  	}
>  
> -	ret = regmap_read(drv->regmap,
> -			  drv->offsets[bank] + reg_data.count_status_reg,
> +	ret = regmap_read(drv->regmap[bank], reg_data.count_status_reg,
>  			  &err_cnt);
>  	if (ret)
>  		goto clear;
> @@ -233,8 +232,7 @@ dump_syn_reg_values(struct llcc_drv_data *drv, u32 bank, int err_type)
>  	edac_printk(KERN_CRIT, EDAC_LLCC, "%s: Error count: 0x%4x\n",
>  		    reg_data.name, err_cnt);
>  
> -	ret = regmap_read(drv->regmap,
> -			  drv->offsets[bank] + reg_data.ways_status_reg,
> +	ret = regmap_read(drv->regmap[bank], reg_data.ways_status_reg,
>  			  &err_ways);
>  	if (ret)
>  		goto clear;
> @@ -296,8 +294,7 @@ llcc_ecc_irq_handler(int irq, void *edev_ctl)
>  
>  	/* Iterate over the banks and look for Tag RAM or Data RAM errors */
>  	for (i = 0; i < drv->num_banks; i++) {
> -		ret = regmap_read(drv->regmap,
> -				  drv->offsets[i] + DRP_INTERRUPT_STATUS,
> +		ret = regmap_read(drv->regmap[i], DRP_INTERRUPT_STATUS,
>  				  &drp_error);
>  
>  		if (!ret && (drp_error & SB_ECC_ERROR)) {
> @@ -312,8 +309,7 @@ llcc_ecc_irq_handler(int irq, void *edev_ctl)
>  		if (!ret)
>  			irq_rc = IRQ_HANDLED;
>  
> -		ret = regmap_read(drv->regmap,
> -				  drv->offsets[i] + TRP_INTERRUPT_0_STATUS,
> +		ret = regmap_read(drv->regmap[i], TRP_INTERRUPT_0_STATUS,
>  				  &trp_error);
>  
>  		if (!ret && (trp_error & SB_ECC_ERROR)) {
> diff --git a/drivers/soc/qcom/llcc-qcom.c b/drivers/soc/qcom/llcc-qcom.c
> index 23ce2f78c4ed..7264ac9993e0 100644
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
> @@ -927,6 +925,7 @@ static int qcom_llcc_probe(struct platform_device *pdev)
>  	const struct llcc_slice_config *llcc_cfg;
>  	u32 sz;
>  	u32 version;
> +	struct regmap *regmap;
>  
>  	drv_data = devm_kzalloc(dev, sizeof(*drv_data), GFP_KERNEL);
>  	if (!drv_data) {
> @@ -934,12 +933,46 @@ static int qcom_llcc_probe(struct platform_device *pdev)
>  		goto err;
>  	}
>  
> -	drv_data->regmap = qcom_llcc_init_mmio(pdev, "llcc_base");
> -	if (IS_ERR(drv_data->regmap)) {
> -		ret = PTR_ERR(drv_data->regmap);
> +	/* Initialize the first LLCC bank regmap */
> +	regmap = qcom_llcc_init_mmio(pdev, "llcc0_base");
> +	if (IS_ERR(regmap)) {
> +		ret = PTR_ERR(regmap);
> +		goto err;
> +	}
> +
> +	cfg = of_device_get_match_data(&pdev->dev);
> +
> +	ret = regmap_read(regmap, cfg->reg_offset[LLCC_COMMON_STATUS0],
> +			  &num_banks);
> +	if (ret)
> +		goto err;
> +
> +	num_banks &= LLCC_LB_CNT_MASK;
> +	num_banks >>= LLCC_LB_CNT_SHIFT;
> +	drv_data->num_banks = num_banks;
> +
> +	drv_data->regmap = devm_kcalloc(dev, num_banks, sizeof(*drv_data->regmap), GFP_KERNEL);
> +	if (!drv_data->regmap) {
> +		ret = -ENOMEM;
>  		goto err;
>  	}
>  
> +	drv_data->regmap[0] = regmap;
> +
> +	/* Initialize rest of LLCC bank regmaps */
> +	for (i = 1; i < num_banks; i++) {
> +		char *base = kasprintf(GFP_KERNEL, "llcc%d_base", i);
> +
> +		drv_data->regmap[i] = qcom_llcc_init_mmio(pdev, base);
> +		if (IS_ERR(drv_data->regmap[i])) {
> +			ret = PTR_ERR(drv_data->regmap[i]);
> +			kfree(base);
> +			goto err;
> +		}
> +
> +		kfree(base);
> +	}
> +
>  	drv_data->bcast_regmap =
>  		qcom_llcc_init_mmio(pdev, "llcc_broadcast_base");
>  	if (IS_ERR(drv_data->bcast_regmap)) {
> @@ -947,8 +980,6 @@ static int qcom_llcc_probe(struct platform_device *pdev)
>  		goto err;
>  	}
>  
> -	cfg = of_device_get_match_data(&pdev->dev);
> -
>  	/* Extract version of the IP */
>  	ret = regmap_read(drv_data->bcast_regmap, cfg->reg_offset[LLCC_COMMON_HW_INFO],
>  			  &version);
> @@ -957,15 +988,6 @@ static int qcom_llcc_probe(struct platform_device *pdev)
>  
>  	drv_data->version = version;
>  
> -	ret = regmap_read(drv_data->regmap, cfg->reg_offset[LLCC_COMMON_STATUS0],
> -			  &num_banks);
> -	if (ret)
> -		goto err;
> -
> -	num_banks &= LLCC_LB_CNT_MASK;
> -	num_banks >>= LLCC_LB_CNT_SHIFT;
> -	drv_data->num_banks = num_banks;
> -
>  	llcc_cfg = cfg->sct_data;
>  	sz = cfg->size;
>  
> @@ -973,16 +995,6 @@ static int qcom_llcc_probe(struct platform_device *pdev)
>  		if (llcc_cfg[i].slice_id > drv_data->max_slices)
>  			drv_data->max_slices = llcc_cfg[i].slice_id;
>  
> -	drv_data->offsets = devm_kcalloc(dev, num_banks, sizeof(u32),
> -							GFP_KERNEL);
> -	if (!drv_data->offsets) {
> -		ret = -ENOMEM;
> -		goto err;
> -	}
> -
> -	for (i = 0; i < num_banks; i++)
> -		drv_data->offsets[i] = i * BANK_OFFSET_STRIDE;
> -
>  	drv_data->bitmap = devm_bitmap_zalloc(dev, drv_data->max_slices,
>  					      GFP_KERNEL);
>  	if (!drv_data->bitmap) {
> diff --git a/include/linux/soc/qcom/llcc-qcom.h b/include/linux/soc/qcom/llcc-qcom.h
> index ad1fd718169d..4b8bf585f9ba 100644
> --- a/include/linux/soc/qcom/llcc-qcom.h
> +++ b/include/linux/soc/qcom/llcc-qcom.h
> @@ -129,12 +129,11 @@ struct llcc_edac_reg_offset {
>   * @max_slices: max slices as read from device tree
>   * @num_banks: Number of llcc banks
>   * @bitmap: Bit map to track the active slice ids
> - * @offsets: Pointer to the bank offsets array
>   * @ecc_irq: interrupt for llcc cache error detection and reporting
>   * @version: Indicates the LLCC version
>   */
>  struct llcc_drv_data {
> -	struct regmap *regmap;
> +	struct regmap **regmap;
>  	struct regmap *bcast_regmap;
>  	const struct llcc_slice_config *cfg;
>  	const struct llcc_edac_reg_offset *edac_reg_offset;
> @@ -143,7 +142,6 @@ struct llcc_drv_data {
>  	u32 max_slices;
>  	u32 num_banks;
>  	unsigned long *bitmap;
> -	u32 *offsets;
>  	int ecc_irq;
>  	u32 version;
>  };
> -- 
> 2.25.1
> 

-- 
மணிவண்ணன் சதாசிவம்

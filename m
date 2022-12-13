Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD88E64BB44
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 18:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236124AbiLMRoQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 12:44:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235907AbiLMRoQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 12:44:16 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8C3A312
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 09:44:14 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id d82so2698707pfd.11
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 09:44:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/pTb3bmFNJAoW4OTXZevQvKRa3GaR4zJvxJl+2o4gSw=;
        b=SUw8T6MW5blOavkLjRFKUF3uKeaFGj4ARONjFQcL4evy+zxbGwoN3MWQz12plsh43w
         FrDGn9ctk+kuo4SstmBtIGEpXML/KUPJOXQmzFaE72RlddSRdh3tOABkrzRxggnDmz8P
         SZUalZbNB1BU0NeTwPieXc9+kRGVnAVIL05btz/KjXByzbPt83PiAmrETlioiFVce+tn
         VcnbRJ/0xOzfN4LzZN/8XGB7hjgVUOoPDJ2VjXgme5nv2Ws3KRjk3JDjEOi5NlZHZUUr
         923oIzW55rT88uYom7Uj9b/344zhtAhcuWrnTN9JJvZcvBmUn1eyTpX+MDmXf9l0wa7l
         6IpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/pTb3bmFNJAoW4OTXZevQvKRa3GaR4zJvxJl+2o4gSw=;
        b=ld/Fisj9XpXcd0WEnCutCzzmjBetGP3nj97WIR9ugHGIHwwLX2en9lasOT3V+LBcxT
         XFFXkPXPyIY9NuBj9mN080AfWSaIOXmfVLY5qMomgoCw5blXxVGNiK9WufRttxs6ad25
         CQsHzw7k60mA6Tl0mmzf3FpekuaeabADLlSuAjZgbu/mRPEgZ+lVU6+L0sBbO3lnau+G
         XBq8QuAeZ+XIPSNQFcxSg4yi0dxka1SLW4Irue/iT7OdBeuqddI8TwM/1xIgpXEnYAGd
         sOJ1ufDqJd6FwdOi6hNxnu1f6mytC/+S65hOiKfv2bQ6yfSrmJ/sk4zBS7a4e7Abx4sk
         onFQ==
X-Gm-Message-State: ANoB5pmgNaY8bjUUmP6lKvrmTUMVQceL4D1/VVCN59Sc8WxRxLW6KvJ5
        vssbLAotr29lr5THV2tP3Eh9
X-Google-Smtp-Source: AA0mqf54qJPb7YmooDC3RdnMvRXNS/ebqWefbj6rMHkzZfj0B3BtOhiWuI6WORqIQeiqmO1v20bQzA==
X-Received: by 2002:a62:1488:0:b0:56b:b890:6ccd with SMTP id 130-20020a621488000000b0056bb8906ccdmr20416983pfu.4.1670953454385;
        Tue, 13 Dec 2022 09:44:14 -0800 (PST)
Received: from thinkpad ([27.111.75.5])
        by smtp.gmail.com with ESMTPSA id g28-20020aa79ddc000000b00573769811d6sm7936930pfq.44.2022.12.13.09.44.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 09:44:13 -0800 (PST)
Date:   Tue, 13 Dec 2022 23:14:06 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     andersson@kernel.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, bp@alien8.de,
        tony.luck@intel.com, quic_saipraka@quicinc.com,
        konrad.dybcio@linaro.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, james.morse@arm.com,
        mchehab@kernel.org, rric@kernel.org, linux-edac@vger.kernel.org,
        quic_ppareek@quicinc.com, luca.weiss@fairphone.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 12/13] qcom: llcc/edac: Fix the base address used for
 accessing LLCC banks
Message-ID: <20221213174406.GH4862@thinkpad>
References: <20221212123311.146261-1-manivannan.sadhasivam@linaro.org>
 <20221212123311.146261-13-manivannan.sadhasivam@linaro.org>
 <ccd54883-d369-8387-881a-b5ac7a377c97@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ccd54883-d369-8387-881a-b5ac7a377c97@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 13, 2022 at 05:37:37PM +0100, Krzysztof Kozlowski wrote:
> On 12/12/2022 13:33, Manivannan Sadhasivam wrote:
> > The Qualcomm LLCC/EDAC drivers were using a fixed register stride for
> > accessing the (Control and Status Registers) CSRs of each LLCC bank.
> > This stride only works for some SoCs like SDM845 for which driver
> > support was initially added.
> > 
> > But the later SoCs use different register stride that vary between the
> > banks with holes in-between. So it is not possible to use a single register
> > stride for accessing the CSRs of each bank. By doing so could result in a
> > crash.
> > 
> > For fixing this issue, let's obtain the base address of each LLCC bank from
> > devicetree and get rid of the fixed stride. This also means, we no longer
> > need to rely on reg-names property and get the base addresses using index.
> > 
> > First index is LLCC bank 0 and last index is LLCC broadcast. If the SoC
> > supports more than one bank, then those needs to be defined in devicetree
> > for index from 1..N-1.
> > 
> > Cc: <stable@vger.kernel.org> # 4.20
> > Fixes: a3134fb09e0b ("drivers: soc: Add LLCC driver")
> > Fixes: 27450653f1db ("drivers: edac: Add EDAC driver support for QCOM SoCs")
> 
> Your previous patches in the series had incorrect CC-stable/Fixes tags,
> thus I have doubts also here.
> 

Sorry I do not agree with you. I wanted to backport binding, dts and driver
patches to possible LTS kernels together and that's why I tagged stable list.

Either all goes to stable or none. If your question is more towards what if one
goes before the other, then in that case I may need to specify the dependency
of commits but that will look messy. I took the gamble because, the driver is
already broken in stable kernels.

> Can you confirm, that this patch alone (alone! Without DTS patches) when
> backported to v4.20, still works perfectly fine for sdm845?
> 

It won't and that's why I also tagged dts patches for backporting.

> > Reported-by: Parikshit Pareek <quic_ppareek@quicinc.com>
> > Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> > ---
> >  drivers/edac/qcom_edac.c           | 14 +++---
> >  drivers/soc/qcom/llcc-qcom.c       | 72 +++++++++++++++++-------------
> >  include/linux/soc/qcom/llcc-qcom.h |  6 +--
> >  3 files changed, 48 insertions(+), 44 deletions(-)
> > 
> > diff --git a/drivers/edac/qcom_edac.c b/drivers/edac/qcom_edac.c
> > index 97a27e42dd61..5be93577fc03 100644
> > --- a/drivers/edac/qcom_edac.c
> > +++ b/drivers/edac/qcom_edac.c
> > @@ -213,7 +213,7 @@ dump_syn_reg_values(struct llcc_drv_data *drv, u32 bank, int err_type)
> >  
> >  	for (i = 0; i < reg_data.reg_cnt; i++) {
> >  		synd_reg = reg_data.synd_reg + (i * 4);
> > -		ret = regmap_read(drv->regmap, drv->offsets[bank] + synd_reg,
> > +		ret = regmap_read(drv->regmaps[bank], synd_reg,
> >  				  &synd_val);
> >  		if (ret)
> >  			goto clear;
> > @@ -222,8 +222,7 @@ dump_syn_reg_values(struct llcc_drv_data *drv, u32 bank, int err_type)
> >  			    reg_data.name, i, synd_val);
> >  	}
> >  
> > -	ret = regmap_read(drv->regmap,
> > -			  drv->offsets[bank] + reg_data.count_status_reg,
> > +	ret = regmap_read(drv->regmaps[bank], reg_data.count_status_reg,
> >  			  &err_cnt);
> >  	if (ret)
> >  		goto clear;
> > @@ -233,8 +232,7 @@ dump_syn_reg_values(struct llcc_drv_data *drv, u32 bank, int err_type)
> >  	edac_printk(KERN_CRIT, EDAC_LLCC, "%s: Error count: 0x%4x\n",
> >  		    reg_data.name, err_cnt);
> >  
> > -	ret = regmap_read(drv->regmap,
> > -			  drv->offsets[bank] + reg_data.ways_status_reg,
> > +	ret = regmap_read(drv->regmaps[bank], reg_data.ways_status_reg,
> >  			  &err_ways);
> >  	if (ret)
> >  		goto clear;
> > @@ -296,8 +294,7 @@ llcc_ecc_irq_handler(int irq, void *edev_ctl)
> >  
> >  	/* Iterate over the banks and look for Tag RAM or Data RAM errors */
> >  	for (i = 0; i < drv->num_banks; i++) {
> > -		ret = regmap_read(drv->regmap,
> > -				  drv->offsets[i] + DRP_INTERRUPT_STATUS,
> > +		ret = regmap_read(drv->regmaps[i], DRP_INTERRUPT_STATUS,
> >  				  &drp_error);
> >  
> >  		if (!ret && (drp_error & SB_ECC_ERROR)) {
> > @@ -312,8 +309,7 @@ llcc_ecc_irq_handler(int irq, void *edev_ctl)
> >  		if (!ret)
> >  			irq_rc = IRQ_HANDLED;
> >  
> > -		ret = regmap_read(drv->regmap,
> > -				  drv->offsets[i] + TRP_INTERRUPT_0_STATUS,
> > +		ret = regmap_read(drv->regmaps[i], TRP_INTERRUPT_0_STATUS,
> >  				  &trp_error);
> >  
> >  		if (!ret && (trp_error & SB_ECC_ERROR)) {
> > diff --git a/drivers/soc/qcom/llcc-qcom.c b/drivers/soc/qcom/llcc-qcom.c
> > index 23ce2f78c4ed..a29f22dad7fa 100644
> > --- a/drivers/soc/qcom/llcc-qcom.c
> > +++ b/drivers/soc/qcom/llcc-qcom.c
> > @@ -62,8 +62,6 @@
> >  #define LLCC_TRP_WRSC_CACHEABLE_EN    0x21f2c
> >  #define LLCC_TRP_ALGO_CFG8	      0x21f30
> >  
> > -#define BANK_OFFSET_STRIDE	      0x80000
> > -
> >  #define LLCC_VERSION_2_0_0_0          0x02000000
> >  #define LLCC_VERSION_2_1_0_0          0x02010000
> >  #define LLCC_VERSION_4_1_0_0          0x04010000
> > @@ -898,8 +896,8 @@ static int qcom_llcc_remove(struct platform_device *pdev)
> >  	return 0;
> >  }
> >  
> > -static struct regmap *qcom_llcc_init_mmio(struct platform_device *pdev,
> > -		const char *name)
> > +static struct regmap *qcom_llcc_init_mmio(struct platform_device *pdev, u8 index,
> > +					  const char *name)
> >  {
> >  	void __iomem *base;
> >  	struct regmap_config llcc_regmap_config = {
> > @@ -909,7 +907,7 @@ static struct regmap *qcom_llcc_init_mmio(struct platform_device *pdev,
> >  		.fast_io = true,
> >  	};
> >  
> > -	base = devm_platform_ioremap_resource_byname(pdev, name);
> > +	base = devm_platform_ioremap_resource(pdev, index);
> >  	if (IS_ERR(base))
> >  		return ERR_CAST(base);
> >  
> > @@ -927,6 +925,7 @@ static int qcom_llcc_probe(struct platform_device *pdev)
> >  	const struct llcc_slice_config *llcc_cfg;
> >  	u32 sz;
> >  	u32 version;
> > +	struct regmap *regmap;
> >  
> >  	drv_data = devm_kzalloc(dev, sizeof(*drv_data), GFP_KERNEL);
> >  	if (!drv_data) {
> > @@ -934,21 +933,51 @@ static int qcom_llcc_probe(struct platform_device *pdev)
> >  		goto err;
> >  	}
> >  
> > -	drv_data->regmap = qcom_llcc_init_mmio(pdev, "llcc_base");
> > -	if (IS_ERR(drv_data->regmap)) {
> > -		ret = PTR_ERR(drv_data->regmap);
> > +	/* Initialize the first LLCC bank regmap */
> > +	regmap = qcom_llcc_init_mmio(pdev, i, "llcc0_base");
> 
> What is the value of "i" here? Looks like not initialized in my next.
> 

Yes, this was a mistake and been reported by kernel bot. It will be fixed in
next version.

> > +	if (IS_ERR(regmap)) {
> > +		ret = PTR_ERR(regmap);
> >  		goto err;
> >  	}
> >  
> > -	drv_data->bcast_regmap =
> > -		qcom_llcc_init_mmio(pdev, "llcc_broadcast_base");
> > +	cfg = of_device_get_match_data(&pdev->dev);
> > +
> > +	ret = regmap_read(regmap, cfg->reg_offset[LLCC_COMMON_STATUS0], &num_banks);
> > +	if (ret)
> > +		goto err;
> > +
> > +	num_banks &= LLCC_LB_CNT_MASK;
> > +	num_banks >>= LLCC_LB_CNT_SHIFT;
> > +	drv_data->num_banks = num_banks;
> > +
> > +	drv_data->regmaps = devm_kcalloc(dev, num_banks, sizeof(*drv_data->regmaps), GFP_KERNEL);
> > +	if (!drv_data->regmaps) {
> > +		ret = -ENOMEM;
> > +		goto err;
> > +	}
> > +
> > +	drv_data->regmaps[0] = regmap;
> > +
> > +	/* Initialize rest of LLCC bank regmaps */
> > +	for (i = 1; i < num_banks; i++) {
> > +		char *base = kasprintf(GFP_KERNEL, "llcc%d_base", i);
> > +
> > +		drv_data->regmaps[i] = qcom_llcc_init_mmio(pdev, i, base);
> > +		if (IS_ERR(drv_data->regmaps[i])) {
> > +			ret = PTR_ERR(drv_data->regmaps[i]);
> > +			kfree(base);
> > +			goto err;
> 
> This looks like the ABI break so:
> 1. Existing users are broken,

I fixed the dts for all affected SoCs, then who are all other existing users?

> 2. It cannot be backported.
> 

This is a bug fix and clearly needs to be backported along with the dts
changes. For this purpose only I have tagged both dts and driver patches for
backporting. Am I missing anything here?

Thanks,
Mani

> 
> > +		}
> > +
> > +		kfree(base);
> > +	}
> > +
> 
> Best regards,
> Krzysztof
> 

-- 
மணிவண்ணன் சதாசிவம்

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53DF565060F
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 02:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbiLSBIj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 20:08:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbiLSBIh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 20:08:37 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 671E325E2;
        Sun, 18 Dec 2022 17:08:36 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id v23so2301777pju.3;
        Sun, 18 Dec 2022 17:08:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oNQym15hFeePc271jN5x/s3ttoUPzSsmqJO+mYyGs2c=;
        b=mJyqKvjSWN6U0UOX6lzZX11PUXILt5IBML15yVFjaEDScHWNsYHhzwWS7iv7gE6Ptc
         3iSAHxSbngL/IaxtNxZ27AZqJ+D/bLYi7i2nSnfsPV0BFYHJCgseUgPtWgXteG/KBchY
         I3Tl8LeWNY0e7fPAGsZQ8I0Z6mIpDwyi+EAmdgcjjHUV7/sEfXIT92/jFH6DP3VKlis5
         kuFUOLh6zMCIU/mTNDPbkksMTFWQ7Vu7WUwf6UwCFuvYCDAQEDCShfYBc8NyJ7edEzlS
         jz1XbPHBPFcghT9dhfYV+f1bShr0GT3OoYoCiLmcbWFrzOMy+Qzeo27MUEvNDqyzIvgW
         JVNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oNQym15hFeePc271jN5x/s3ttoUPzSsmqJO+mYyGs2c=;
        b=WlhaHcrHdpm7HeSnOYAuirPbWbsG6YWcYzAjoBZEeP7m05X1YSCDA+w1KDT5PapMQS
         C5PZtyHlHtcgDZhrBbIuqQuqW3x/Ju0O2MPBOXXVJhbCveTk+VUf/dP6GYRuH5DajHdp
         rqpH0Ym0/iGN0OVSlYEDXnLoIZQ+DMpXYe8GOI3Tx33XY+CwBogXHjYPULz5YjZ+djfF
         ZQznpa4cXJg1w3Qxg6Ly09ZWDusZMjoIFumdvu7h28QaRSJIcOcWvbag6edRuIo8bEqQ
         hCdW0gATvWve+MB1g9L6KrNQGn8NNNcbEnR8c1euobNt/NNtjRb03EosvFFFBxnKEHKg
         wTNw==
X-Gm-Message-State: ANoB5pmbVXaGwPMfs3UAz9aN5WzaiFDMWyEVkNFZbKcKl7bOFSdwcznm
        caKcyKkXxoaSZ9xzh4xLaGyIu/ydEOo=
X-Google-Smtp-Source: AA0mqf69oYKAMTHviaKsAUBaFhPrAJZ/RcZBJF7+x7zCUfB3QQl2ZlFtXdFGWCWtZssvMX3DVnv5WQ==
X-Received: by 2002:a17:902:d192:b0:189:c19a:2cd9 with SMTP id m18-20020a170902d19200b00189c19a2cd9mr34438031plb.25.1671412115754;
        Sun, 18 Dec 2022 17:08:35 -0800 (PST)
Received: from cyhuang-hp-elitebook-840-g3.rt ([2402:7500:568:adee:c012:1ba9:3520:947a])
        by smtp.gmail.com with ESMTPSA id h9-20020a170902f7c900b00189ec622d23sm5708941plw.100.2022.12.18.17.08.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 18 Dec 2022 17:08:35 -0800 (PST)
Date:   Mon, 19 Dec 2022 09:08:26 +0800
From:   ChiYuan Huang <u0084500@gmail.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        ChiYuan Huang <cy_huang@richtek.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Mark Brown <broonie@kernel.org>, djrscally@gmail.com,
        hdegoede@redhat.com, markgross@kernel.org, lgirdwood@gmail.com,
        mcoquelin.stm32@gmail.com, alexandre.torgue@foss.st.com,
        platform-driver-x86@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 6.1 81/85] regulator: core: Use different devices
 for resource allocation and DT lookup
Message-ID: <20221219010819.GA7596@cyhuang-hp-elitebook-840-g3.rt>
References: <20221218160142.925394-1-sashal@kernel.org>
 <20221218160142.925394-81-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221218160142.925394-81-sashal@kernel.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 18, 2022 at 11:01:38AM -0500, Sasha Levin wrote:
Hi,
  Thanks, but there's one more case not considered.
  It may cause a unexpected regulator shutdown by regulator core.

  Here's the discussion link that reported from Marek Szyprowski.
  https://lore.kernel.org/lkml/dd329b51-f11a-2af6-9549-c8a014fd5a71@samsung.com/

  I have post a patch to fix it.
  You may need to cherry-pick the below patch also.
  0debed5b117d ("regulator: core: Fix resolve supply lookup issue")

Best regards,
ChiYuan.
> From: ChiYuan Huang <cy_huang@richtek.com>
> 
> [ Upstream commit 8f3cbcd6b440032ebc7f7d48a1689dcc70a4eb98 ]
> 
> Following by the below discussion, there's the potential UAF issue
> between regulator and mfd.
> https://lore.kernel.org/all/20221128143601.1698148-1-yangyingliang@huawei.com/
> 
> >From the analysis of Yingliang
> 
> CPU A				|CPU B
> mt6370_probe()			|
>   devm_mfd_add_devices()	|
> 				|mt6370_regulator_probe()
> 				|  regulator_register()
> 				|    //allocate init_data and add it to devres
> 				|    regulator_of_get_init_data()
> i2c_unregister_device()		|
>   device_del()			|
>     devres_release_all()	|
>       // init_data is freed	|
>       release_nodes()		|
> 				|  // using init_data causes UAF
> 				|  regulator_register()
> 
> It's common to use mfd core to create child device for the regulator.
> In order to do the DT lookup for init data, the child that registered
> the regulator would pass its parent as the parameter. And this causes
> init data resource allocated to its parent, not itself. The issue happen
> when parent device is going to release and regulator core is still doing
> some operation of init data constraint for the regulator of child device.
> 
> To fix it, this patch expand 'regulator_register' API to use the
> different devices for init data allocation and DT lookup.
> 
> Reported-by: Yang Yingliang <yangyingliang@huawei.com>
> Signed-off-by: ChiYuan Huang <cy_huang@richtek.com>
> Link: https://lore.kernel.org/r/1670311341-32664-1-git-send-email-u0084500@gmail.com
> Signed-off-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/platform/x86/intel/int3472/clk_and_regulator.c | 3 ++-
>  drivers/regulator/core.c                               | 8 ++++----
>  drivers/regulator/devres.c                             | 2 +-
>  drivers/regulator/of_regulator.c                       | 2 +-
>  drivers/regulator/stm32-vrefbuf.c                      | 2 +-
>  include/linux/regulator/driver.h                       | 3 ++-
>  6 files changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/platform/x86/intel/int3472/clk_and_regulator.c b/drivers/platform/x86/intel/int3472/clk_and_regulator.c
> index 1cf958983e86..b2342b3d78c7 100644
> --- a/drivers/platform/x86/intel/int3472/clk_and_regulator.c
> +++ b/drivers/platform/x86/intel/int3472/clk_and_regulator.c
> @@ -185,7 +185,8 @@ int skl_int3472_register_regulator(struct int3472_discrete_device *int3472,
>  	cfg.init_data = &init_data;
>  	cfg.ena_gpiod = int3472->regulator.gpio;
>  
> -	int3472->regulator.rdev = regulator_register(&int3472->regulator.rdesc,
> +	int3472->regulator.rdev = regulator_register(int3472->dev,
> +						     &int3472->regulator.rdesc,
>  						     &cfg);
>  	if (IS_ERR(int3472->regulator.rdev)) {
>  		ret = PTR_ERR(int3472->regulator.rdev);
> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
> index 1cfac32121c0..10df84c2c288 100644
> --- a/drivers/regulator/core.c
> +++ b/drivers/regulator/core.c
> @@ -5402,6 +5402,7 @@ static struct regulator_coupler generic_regulator_coupler = {
>  
>  /**
>   * regulator_register - register regulator
> + * @dev: the device that drive the regulator
>   * @regulator_desc: regulator to register
>   * @cfg: runtime configuration for regulator
>   *
> @@ -5410,7 +5411,8 @@ static struct regulator_coupler generic_regulator_coupler = {
>   * or an ERR_PTR() on error.
>   */
>  struct regulator_dev *
> -regulator_register(const struct regulator_desc *regulator_desc,
> +regulator_register(struct device *dev,
> +		   const struct regulator_desc *regulator_desc,
>  		   const struct regulator_config *cfg)
>  {
>  	const struct regulator_init_data *init_data;
> @@ -5419,7 +5421,6 @@ regulator_register(const struct regulator_desc *regulator_desc,
>  	struct regulator_dev *rdev;
>  	bool dangling_cfg_gpiod = false;
>  	bool dangling_of_gpiod = false;
> -	struct device *dev;
>  	int ret, i;
>  	bool resolved_early = false;
>  
> @@ -5432,8 +5433,7 @@ regulator_register(const struct regulator_desc *regulator_desc,
>  		goto rinse;
>  	}
>  
> -	dev = cfg->dev;
> -	WARN_ON(!dev);
> +	WARN_ON(!dev || !cfg->dev);
>  
>  	if (regulator_desc->name == NULL || regulator_desc->ops == NULL) {
>  		ret = -EINVAL;
> diff --git a/drivers/regulator/devres.c b/drivers/regulator/devres.c
> index 3265e75e97ab..5c7ff9b3e8a7 100644
> --- a/drivers/regulator/devres.c
> +++ b/drivers/regulator/devres.c
> @@ -385,7 +385,7 @@ struct regulator_dev *devm_regulator_register(struct device *dev,
>  	if (!ptr)
>  		return ERR_PTR(-ENOMEM);
>  
> -	rdev = regulator_register(regulator_desc, config);
> +	rdev = regulator_register(dev, regulator_desc, config);
>  	if (!IS_ERR(rdev)) {
>  		*ptr = rdev;
>  		devres_add(dev, ptr);
> diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
> index 0aff1c2886b5..cd726d4e8fbf 100644
> --- a/drivers/regulator/of_regulator.c
> +++ b/drivers/regulator/of_regulator.c
> @@ -505,7 +505,7 @@ struct regulator_init_data *regulator_of_get_init_data(struct device *dev,
>  	struct device_node *child;
>  	struct regulator_init_data *init_data = NULL;
>  
> -	child = regulator_of_get_init_node(dev, desc);
> +	child = regulator_of_get_init_node(config->dev, desc);
>  	if (!child)
>  		return NULL;
>  
> diff --git a/drivers/regulator/stm32-vrefbuf.c b/drivers/regulator/stm32-vrefbuf.c
> index 30ea3bc8ca19..7a454b7b6eab 100644
> --- a/drivers/regulator/stm32-vrefbuf.c
> +++ b/drivers/regulator/stm32-vrefbuf.c
> @@ -210,7 +210,7 @@ static int stm32_vrefbuf_probe(struct platform_device *pdev)
>  						      pdev->dev.of_node,
>  						      &stm32_vrefbuf_regu);
>  
> -	rdev = regulator_register(&stm32_vrefbuf_regu, &config);
> +	rdev = regulator_register(&pdev->dev, &stm32_vrefbuf_regu, &config);
>  	if (IS_ERR(rdev)) {
>  		ret = PTR_ERR(rdev);
>  		dev_err(&pdev->dev, "register failed with error %d\n", ret);
> diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
> index f9a7461e72b8..d3b4a3d4514a 100644
> --- a/include/linux/regulator/driver.h
> +++ b/include/linux/regulator/driver.h
> @@ -687,7 +687,8 @@ static inline int regulator_err2notif(int err)
>  
>  
>  struct regulator_dev *
> -regulator_register(const struct regulator_desc *regulator_desc,
> +regulator_register(struct device *dev,
> +		   const struct regulator_desc *regulator_desc,
>  		   const struct regulator_config *config);
>  struct regulator_dev *
>  devm_regulator_register(struct device *dev,
> -- 
> 2.35.1
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C699602E65
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 16:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbiJRO0a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Oct 2022 10:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbiJRO03 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Oct 2022 10:26:29 -0400
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03A719AFB6;
        Tue, 18 Oct 2022 07:26:29 -0700 (PDT)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-1322fa1cf6fso16984598fac.6;
        Tue, 18 Oct 2022 07:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jJB9ivUqw3F+dMYrKLA2kwqlgOk9VKugArobXTWH0xM=;
        b=L7Jnyc2vNK5H0lbnIYCoMnh2Ayt17o/YaKYgom65gGlLoYBMY+m3BZHaZkdILOw69b
         axjCooFq80igazhwWKQcegfs5v4Zh2BozBPLB4yBTU/77PT53mZmBIO801dl2FhMVr1z
         omb59hrEJEHA/5V4/e5T27e0kqJXnLGXQqioQu9yfUlZ05kJazPzW4G3yIlZ12KwsyZK
         LE1zjYsLGDtGSGrWnfEqesXN9BVAf25LI15CdG6IbvUV95pJZFWFNAiejXE+i/qzySMW
         FvY30ZdJoWrPCsmVSMhP+BoWxzkoUV1uhHmMWJPkrwwiKlayUDfYVnn4Wt81pB1ho87V
         /KQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jJB9ivUqw3F+dMYrKLA2kwqlgOk9VKugArobXTWH0xM=;
        b=ww7gTPLZZ3BSql5huwNLxEkR70vS7fNhE1Efrxh2CNfZyJMz742KduUd+hapRWck7E
         nccBIgGleATLHrv/v3A5YX8E/lsEPeAZwwgBUzN/iVo1wpUVvGX6gAWAS2v7cLTs6GUU
         TZ51dZ/+Ls3bAKOnfLz5eQD7BMRnfkg27bxAHjX+bCOZ4j493D/DVykVDFoZJr+YLS7Z
         iMtjm2c73qf6UwgTFgiWQ/kU5IZP8OtbTMIAGLepxCXH2XpxmuijNdQwtia5XG4rKh11
         pv4pGOcjdBn/hmONuqPbsKiPVz7yT0c24AdQeY8p77nvrsNg/TYDn+MaioWQwEBTsB6l
         iT/g==
X-Gm-Message-State: ACrzQf2G2Fc+ZkzYxZ9dtw0afJp++pUKJCvidypjfsV+8oepAsr6gnAk
        yAHeCc4K1gOdmwxYhL5iDQ8=
X-Google-Smtp-Source: AMsMyM687VtwhmvJxsI0F4ocYwDeCWuGUtCIdxOONuH0brQ9jluRqc8MEXTf9MzlCQMW6ndhpayNdw==
X-Received: by 2002:a05:6870:2189:b0:132:b270:2107 with SMTP id l9-20020a056870218900b00132b2702107mr1661427oae.55.1666103188199;
        Tue, 18 Oct 2022 07:26:28 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 23-20020aca2117000000b00354efb5be11sm5533568oiz.15.2022.10.18.07.26.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 07:26:27 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 18 Oct 2022 07:26:26 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Brian Norris <briannorris@chromium.org>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        Faiz Abbas <faiz_abbas@ti.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Haibo Chen <haibo.chen@nxp.com>,
        Al Cooper <alcooperx@gmail.com>, linux-mmc@vger.kernel.org,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        linux-arm-kernel@lists.infradead.org,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/5] mmc: sdhci-of-arasan: Fix SDHCI_RESET_ALL for CQHCI
Message-ID: <20221018142626.GA2096645@roeck-us.net>
References: <20221018035724.2061127-1-briannorris@chromium.org>
 <20221017205610.1.I29f6a2189e84e35ad89c1833793dca9e36c64297@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221017205610.1.I29f6a2189e84e35ad89c1833793dca9e36c64297@changeid>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 17, 2022 at 08:57:20PM -0700, Brian Norris wrote:
> SDHCI_RESET_ALL resets will reset the hardware CQE state, but we aren't
> tracking that properly in software. When out of sync, we may trigger
> various timeouts.
> 
> It's not typical to perform resets while CQE is enabled, but one
> particular case I hit commonly enough: mmc_suspend() -> mmc_power_off().
> Typically we will eventually deactivate CQE (cqhci_suspend() ->
> cqhci_deactivate()), but that's not guaranteed -- in particular, if
> we perform a partial (e.g., interrupted) system suspend.
> 
> The same bug was already found and fixed for two other drivers, in v5.7
> and v5.9:
> 
> 5cf583f1fb9c mmc: sdhci-msm: Deactivate CQE during SDHC reset
> df57d73276b8 mmc: sdhci-pci: Fix SDHCI_RESET_ALL for CQHCI for Intel GLK-based controllers
> 
> The latter is especially prescient, saying "other drivers using CQHCI
> might benefit from a similar change, if they also have CQHCI reset by
> SDHCI_RESET_ALL."
> 
> So like these other patches, deactivate CQHCI when resetting the
> controller. Also, move around the DT/caps handling, because
> sdhci_setup_host() performs resets before we've initialized CQHCI. This
> is the pattern followed in other SDHCI/CQHCI drivers.
> 
> Fixes: 84362d79f436 ("mmc: sdhci-of-arasan: Add CQHCI support for arasan,sdhci-5.1")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Brian Norris <briannorris@chromium.org>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

> ---
> 
>  drivers/mmc/host/sdhci-of-arasan.c | 17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/mmc/host/sdhci-of-arasan.c b/drivers/mmc/host/sdhci-of-arasan.c
> index 3997cad1f793..1988a703781a 100644
> --- a/drivers/mmc/host/sdhci-of-arasan.c
> +++ b/drivers/mmc/host/sdhci-of-arasan.c
> @@ -366,6 +366,10 @@ static void sdhci_arasan_reset(struct sdhci_host *host, u8 mask)
>  	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
>  	struct sdhci_arasan_data *sdhci_arasan = sdhci_pltfm_priv(pltfm_host);
>  
> +	if ((host->mmc->caps2 & MMC_CAP2_CQE) && (mask & SDHCI_RESET_ALL) &&
> +	    sdhci_arasan->has_cqe)
> +		cqhci_deactivate(host->mmc);
> +
>  	sdhci_reset(host, mask);
>  
>  	if (sdhci_arasan->quirks & SDHCI_ARASAN_QUIRK_FORCE_CDTEST) {
> @@ -1521,7 +1525,8 @@ static int sdhci_arasan_register_sdclk(struct sdhci_arasan_data *sdhci_arasan,
>  	return 0;
>  }
>  
> -static int sdhci_arasan_add_host(struct sdhci_arasan_data *sdhci_arasan)
> +static int sdhci_arasan_add_host(struct sdhci_arasan_data *sdhci_arasan,
> +				 struct device_node *np)
>  {
>  	struct sdhci_host *host = sdhci_arasan->host;
>  	struct cqhci_host *cq_host;
> @@ -1549,6 +1554,10 @@ static int sdhci_arasan_add_host(struct sdhci_arasan_data *sdhci_arasan)
>  	if (dma64)
>  		cq_host->caps |= CQHCI_TASK_DESC_SZ_128;
>  
> +	host->mmc->caps2 |= MMC_CAP2_CQE;
> +	if (!of_property_read_bool(np, "disable-cqe-dcmd"))
> +		host->mmc->caps2 |= MMC_CAP2_CQE_DCMD;
> +
>  	ret = cqhci_init(cq_host, host->mmc, dma64);
>  	if (ret)
>  		goto cleanup;
> @@ -1705,13 +1714,9 @@ static int sdhci_arasan_probe(struct platform_device *pdev)
>  		host->mmc_host_ops.start_signal_voltage_switch =
>  					sdhci_arasan_voltage_switch;
>  		sdhci_arasan->has_cqe = true;
> -		host->mmc->caps2 |= MMC_CAP2_CQE;
> -
> -		if (!of_property_read_bool(np, "disable-cqe-dcmd"))
> -			host->mmc->caps2 |= MMC_CAP2_CQE_DCMD;
>  	}
>  
> -	ret = sdhci_arasan_add_host(sdhci_arasan);
> +	ret = sdhci_arasan_add_host(sdhci_arasan, np);
>  	if (ret)
>  		goto err_add_host;
>  
> -- 
> 2.38.0.413.g74048e4d9e-goog
> 

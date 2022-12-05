Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB5C642A16
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 15:07:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbiLEOHV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 09:07:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbiLEOHU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 09:07:20 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1C841A3AD
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 06:07:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670249239; x=1701785239;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=02d1BeLyUhPvNYvZlfBCGKwQB09t52TLW4grx5K5WTQ=;
  b=jhU+J0s79+AL6ODIcxVuf5AYUd96wUfdNZLZH7A0xPHK9OvGvM6ax7cG
   5wYjLxsKzk9iZ8LZTioa1TscEFnx7GLvv+xJ9xtwHlTQDQRQxTVQ7UWqd
   9/k6KBRKbbZVNl2uy03AN+OWlFoeeAR/CB246MFXTwB034DV7M7wrM091
   tT+iHd1UUHw4XveYuCMRegHect2U7OD3Vvvj08D3CwVK7eFqDHT4ruet9
   l4sMel82L+hHDGqBjwBfRM8lUY+NADKLx+NtXRznWxfHC1lrepYO4nFzt
   CdnjbkR+C8deN4SF58GtsyfII3InIwBMYq9XUgCxt4FEe2XRo1q9UbA9v
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10551"; a="402627982"
X-IronPort-AV: E=Sophos;i="5.96,219,1665471600"; 
   d="scan'208";a="402627982"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2022 06:07:18 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10551"; a="770356385"
X-IronPort-AV: E=Sophos;i="5.96,219,1665471600"; 
   d="scan'208";a="770356385"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.55.104])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2022 06:07:17 -0800
Message-ID: <95463a7a-c439-1e6b-dc8d-55a986bc0c11@intel.com>
Date:   Mon, 5 Dec 2022 16:07:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.5.1
Subject: Re: FAILED: patch "[PATCH] mmc: sdhci: Fix voltage switch delay"
 failed to apply to 5.4-stable tree
Content-Language: en-US
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, ulf.hansson@linaro.org
References: <1670065118709@kroah.com>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <1670065118709@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/12/22 12:58, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> Possible dependencies:
> 
> c981cdfb9925 ("mmc: sdhci: Fix voltage switch delay")
> fa0910107a9f ("mmc: sdhci: use FIELD_GET for preset value bit masks")

Yes please cherry-pick fa0910107a9f then c981cdfb9925

Ditto for 4.19 and 4.14 too please.

> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From c981cdfb9925f64a364f13c2b4f98f877308a408 Mon Sep 17 00:00:00 2001
> From: Adrian Hunter <adrian.hunter@intel.com>
> Date: Mon, 28 Nov 2022 15:32:56 +0200
> Subject: [PATCH] mmc: sdhci: Fix voltage switch delay
> 
> Commit 20b92a30b561 ("mmc: sdhci: update signal voltage switch code")
> removed voltage switch delays from sdhci because mmc core had been
> enhanced to support them. However that assumed that sdhci_set_ios()
> did a single clock change, which it did not, and so the delays in mmc
> core, which should have come after the first clock change, were not
> effective.
> 
> Fix by avoiding re-configuring UHS and preset settings when the clock
> is turning on and the settings have not changed. That then also avoids
> the associated clock changes, so that then sdhci_set_ios() does a single
> clock change when voltage switching, and the mmc core delays become
> effective.
> 
> To do that has meant keeping track of driver strength (host->drv_type),
> and cases of reinitialization (host->reinit_uhs).
> 
> Note also, the 'turning_on_clk' restriction should not be necessary
> but is done to minimize the impact of the change on stable kernels.
> 
> Fixes: 20b92a30b561 ("mmc: sdhci: update signal voltage switch code")
> Cc: stable@vger.kernel.org
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> Link: https://lore.kernel.org/r/20221128133259.38305-2-adrian.hunter@intel.com
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> 
> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> index fef03de85b99..c7ad32a75b57 100644
> --- a/drivers/mmc/host/sdhci.c
> +++ b/drivers/mmc/host/sdhci.c
> @@ -373,6 +373,7 @@ static void sdhci_init(struct sdhci_host *host, int soft)
>  	if (soft) {
>  		/* force clock reconfiguration */
>  		host->clock = 0;
> +		host->reinit_uhs = true;
>  		mmc->ops->set_ios(mmc, &mmc->ios);
>  	}
>  }
> @@ -2293,11 +2294,46 @@ void sdhci_set_uhs_signaling(struct sdhci_host *host, unsigned timing)
>  }
>  EXPORT_SYMBOL_GPL(sdhci_set_uhs_signaling);
>  
> +static bool sdhci_timing_has_preset(unsigned char timing)
> +{
> +	switch (timing) {
> +	case MMC_TIMING_UHS_SDR12:
> +	case MMC_TIMING_UHS_SDR25:
> +	case MMC_TIMING_UHS_SDR50:
> +	case MMC_TIMING_UHS_SDR104:
> +	case MMC_TIMING_UHS_DDR50:
> +	case MMC_TIMING_MMC_DDR52:
> +		return true;
> +	};
> +	return false;
> +}
> +
> +static bool sdhci_preset_needed(struct sdhci_host *host, unsigned char timing)
> +{
> +	return !(host->quirks2 & SDHCI_QUIRK2_PRESET_VALUE_BROKEN) &&
> +	       sdhci_timing_has_preset(timing);
> +}
> +
> +static bool sdhci_presetable_values_change(struct sdhci_host *host, struct mmc_ios *ios)
> +{
> +	/*
> +	 * Preset Values are: Driver Strength, Clock Generator and SDCLK/RCLK
> +	 * Frequency. Check if preset values need to be enabled, or the Driver
> +	 * Strength needs updating. Note, clock changes are handled separately.
> +	 */
> +	return !host->preset_enabled &&
> +	       (sdhci_preset_needed(host, ios->timing) || host->drv_type != ios->drv_type);
> +}
> +
>  void sdhci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
>  {
>  	struct sdhci_host *host = mmc_priv(mmc);
> +	bool reinit_uhs = host->reinit_uhs;
> +	bool turning_on_clk = false;
>  	u8 ctrl;
>  
> +	host->reinit_uhs = false;
> +
>  	if (ios->power_mode == MMC_POWER_UNDEFINED)
>  		return;
>  
> @@ -2323,6 +2359,8 @@ void sdhci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
>  		sdhci_enable_preset_value(host, false);
>  
>  	if (!ios->clock || ios->clock != host->clock) {
> +		turning_on_clk = ios->clock && !host->clock;
> +
>  		host->ops->set_clock(host, ios->clock);
>  		host->clock = ios->clock;
>  
> @@ -2349,6 +2387,17 @@ void sdhci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
>  
>  	host->ops->set_bus_width(host, ios->bus_width);
>  
> +	/*
> +	 * Special case to avoid multiple clock changes during voltage
> +	 * switching.
> +	 */
> +	if (!reinit_uhs &&
> +	    turning_on_clk &&
> +	    host->timing == ios->timing &&
> +	    host->version >= SDHCI_SPEC_300 &&
> +	    !sdhci_presetable_values_change(host, ios))
> +		return;
> +
>  	ctrl = sdhci_readb(host, SDHCI_HOST_CONTROL);
>  
>  	if (!(host->quirks & SDHCI_QUIRK_NO_HISPD_BIT)) {
> @@ -2392,6 +2441,7 @@ void sdhci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
>  			}
>  
>  			sdhci_writew(host, ctrl_2, SDHCI_HOST_CONTROL2);
> +			host->drv_type = ios->drv_type;
>  		} else {
>  			/*
>  			 * According to SDHC Spec v3.00, if the Preset Value
> @@ -2419,19 +2469,14 @@ void sdhci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
>  		host->ops->set_uhs_signaling(host, ios->timing);
>  		host->timing = ios->timing;
>  
> -		if (!(host->quirks2 & SDHCI_QUIRK2_PRESET_VALUE_BROKEN) &&
> -				((ios->timing == MMC_TIMING_UHS_SDR12) ||
> -				 (ios->timing == MMC_TIMING_UHS_SDR25) ||
> -				 (ios->timing == MMC_TIMING_UHS_SDR50) ||
> -				 (ios->timing == MMC_TIMING_UHS_SDR104) ||
> -				 (ios->timing == MMC_TIMING_UHS_DDR50) ||
> -				 (ios->timing == MMC_TIMING_MMC_DDR52))) {
> +		if (sdhci_preset_needed(host, ios->timing)) {
>  			u16 preset;
>  
>  			sdhci_enable_preset_value(host, true);
>  			preset = sdhci_get_preset_value(host);
>  			ios->drv_type = FIELD_GET(SDHCI_PRESET_DRV_MASK,
>  						  preset);
> +			host->drv_type = ios->drv_type;
>  		}
>  
>  		/* Re-enable SD Clock */
> @@ -3768,6 +3813,7 @@ int sdhci_resume_host(struct sdhci_host *host)
>  		sdhci_init(host, 0);
>  		host->pwr = 0;
>  		host->clock = 0;
> +		host->reinit_uhs = true;
>  		mmc->ops->set_ios(mmc, &mmc->ios);
>  	} else {
>  		sdhci_init(host, (mmc->pm_flags & MMC_PM_KEEP_POWER));
> @@ -3830,6 +3876,7 @@ int sdhci_runtime_resume_host(struct sdhci_host *host, int soft_reset)
>  		/* Force clock and power re-program */
>  		host->pwr = 0;
>  		host->clock = 0;
> +		host->reinit_uhs = true;
>  		mmc->ops->start_signal_voltage_switch(mmc, &mmc->ios);
>  		mmc->ops->set_ios(mmc, &mmc->ios);
>  
> diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
> index d750c464bd1e..87a3aaa07438 100644
> --- a/drivers/mmc/host/sdhci.h
> +++ b/drivers/mmc/host/sdhci.h
> @@ -524,6 +524,8 @@ struct sdhci_host {
>  
>  	unsigned int clock;	/* Current clock (MHz) */
>  	u8 pwr;			/* Current voltage */
> +	u8 drv_type;		/* Current UHS-I driver type */
> +	bool reinit_uhs;	/* Force UHS-related re-initialization */
>  
>  	bool runtime_suspended;	/* Host is runtime suspended */
>  	bool bus_on;		/* Bus power prevents runtime suspend */
> 


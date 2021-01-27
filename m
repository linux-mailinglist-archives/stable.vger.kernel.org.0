Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9083063A7
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 20:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbhA0TBd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 14:01:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231776AbhA0TB2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jan 2021 14:01:28 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE594C061756
        for <stable@vger.kernel.org>; Wed, 27 Jan 2021 11:00:48 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id v19so2195940pgj.12
        for <stable@vger.kernel.org>; Wed, 27 Jan 2021 11:00:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=COxofTr0kJgJ0XrTolT3iIHzQatztoojR6wHC+Fzy74=;
        b=fAEyChm6iRnVQn8MSzpwlHcYJVpgFidFFtuGRvFiIMb4hbXkSaewAhYjNVWmVkSTDm
         NE8p0RbxFsvC/DMHSSNM2F/CpybpBihBHF/aJnya5uuIEIEtJY7DDrBxmR0LHHkWj2Fa
         SbrOzL71GL+X6gl4/k2SmPr+jQ/yoBn/l69Ed+UmZABqOfyEwuj9kRkg7fWPygO5I62j
         CxQxw39JsWFyUJybP3ez6HVSVB2ZPVBx7Uzo8MYZ2zBCiX0Af43rHAm8kFIq+P3Orky9
         Kjs2eeExdXLTMRD1ZbYoIJw1VbNUrJjjlZ/OCLIiCTWGTR5bxUl47FqQrpiKN//HqIiN
         n/FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=COxofTr0kJgJ0XrTolT3iIHzQatztoojR6wHC+Fzy74=;
        b=nCa5l8pGDU1ENGF3PXXdXFE9icyD441WHFYNASBYbwCeTULqg/CLzGc1q7v05wSg1e
         e81TkDlDj3/CkfGYp3ceObLUiqeEvR0iaqIYI5eD1Gf7xWQaZG370ba667FGjp5Yt93R
         IsOGyyfF6hOlri6hT3S5r374tS0L0qA/1pfYW/7Z1PK653euu8vvYSQYLYkfyFrPoRj4
         WYfBswCrIV5ToJwdeiuBXYZz9meOZIhXAixQWCO3k0C0D4nwJ8QXZZgRx+PBQkR4505G
         jiO7UTSvIwCWwwHVHjyfsoEZfXTaxzXflEPxhz7US2actBCWU5/mj4BGxdPkUYwLwJwY
         zgkA==
X-Gm-Message-State: AOAM533sHdDk9gbOYbXeKv21+zv0awAN3VeitME+hRlFXg3CXZkcyoVL
        M/WH59fxmg/6Kd0nisZZTWA3dg==
X-Google-Smtp-Source: ABdhPJyYU5QypQEJbdegyIzU0caaY5lQIq1bBnjC5+47zOqziEX95F2dX+L8ujg6Ft/zHLgZGrPPgg==
X-Received: by 2002:a63:2d3:: with SMTP id 202mr12522670pgc.438.1611774048289;
        Wed, 27 Jan 2021 11:00:48 -0800 (PST)
Received: from xps15 (S0106889e681aac74.cg.shawcable.net. [68.147.0.187])
        by smtp.gmail.com with ESMTPSA id c5sm2738594pjo.4.2021.01.27.11.00.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 11:00:47 -0800 (PST)
Date:   Wed, 27 Jan 2021 12:00:45 -0700
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        coresight@lists.linaro.org, anshuman.khandual@arm.com,
        stable@vger.kernel.org, Mike Leach <mike.leach@linaro.org>,
        Leo Yan <leo.yan@linaro.org>
Subject: Re: [PATCH v3] coresight: etm4x: Handle accesses to TRCSTALLCTLR
Message-ID: <20210127190045.GA1165637@xps15>
References: <20210127184617.3684379-1-suzuki.poulose@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210127184617.3684379-1-suzuki.poulose@arm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 27, 2021 at 06:46:17PM +0000, Suzuki K Poulose wrote:
> TRCSTALLCTLR register is only implemented if
> 
>    TRCIDR3.STALLCTL == 0b1
> 
> Make sure the driver touches the register only it is implemented.
> 
> Cc: stable@vger.kernel.org
> Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
> Cc: Mike Leach <mike.leach@linaro.org>
> Cc: Leo Yan <leo.yan@linaro.org>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
> Changes since v2:
>  - Ignore STALLCTL for sysfs mode
> ---
>  drivers/hwtracing/coresight/coresight-etm4x-core.c  | 9 ++++++---
>  drivers/hwtracing/coresight/coresight-etm4x-sysfs.c | 2 +-
>  2 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
> index 473ab7480a36..5017d33ba4f5 100644
> --- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
> +++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
> @@ -306,7 +306,8 @@ static int etm4_enable_hw(struct etmv4_drvdata *drvdata)
>  	etm4x_relaxed_write32(csa, 0x0, TRCAUXCTLR);
>  	etm4x_relaxed_write32(csa, config->eventctrl0, TRCEVENTCTL0R);
>  	etm4x_relaxed_write32(csa, config->eventctrl1, TRCEVENTCTL1R);
> -	etm4x_relaxed_write32(csa, config->stall_ctrl, TRCSTALLCTLR);
> +	if (drvdata->stallctl)
> +		etm4x_relaxed_write32(csa, config->stall_ctrl, TRCSTALLCTLR);
>  	etm4x_relaxed_write32(csa, config->ts_ctrl, TRCTSCTLR);
>  	etm4x_relaxed_write32(csa, config->syncfreq, TRCSYNCPR);
>  	etm4x_relaxed_write32(csa, config->ccctlr, TRCCCCTLR);
> @@ -1463,7 +1464,8 @@ static int etm4_cpu_save(struct etmv4_drvdata *drvdata)
>  	state->trcauxctlr = etm4x_read32(csa, TRCAUXCTLR);
>  	state->trceventctl0r = etm4x_read32(csa, TRCEVENTCTL0R);
>  	state->trceventctl1r = etm4x_read32(csa, TRCEVENTCTL1R);
> -	state->trcstallctlr = etm4x_read32(csa, TRCSTALLCTLR);
> +	if (drvdata->stallctl)
> +		state->trcstallctlr = etm4x_read32(csa, TRCSTALLCTLR);
>  	state->trctsctlr = etm4x_read32(csa, TRCTSCTLR);
>  	state->trcsyncpr = etm4x_read32(csa, TRCSYNCPR);
>  	state->trcccctlr = etm4x_read32(csa, TRCCCCTLR);
> @@ -1575,7 +1577,8 @@ static void etm4_cpu_restore(struct etmv4_drvdata *drvdata)
>  	etm4x_relaxed_write32(csa, state->trcauxctlr, TRCAUXCTLR);
>  	etm4x_relaxed_write32(csa, state->trceventctl0r, TRCEVENTCTL0R);
>  	etm4x_relaxed_write32(csa, state->trceventctl1r, TRCEVENTCTL1R);
> -	etm4x_relaxed_write32(csa, state->trcstallctlr, TRCSTALLCTLR);
> +	if (drvdata->stallctl)
> +		etm4x_relaxed_write32(csa, state->trcstallctlr, TRCSTALLCTLR);
>  	etm4x_relaxed_write32(csa, state->trctsctlr, TRCTSCTLR);
>  	etm4x_relaxed_write32(csa, state->trcsyncpr, TRCSYNCPR);
>  	etm4x_relaxed_write32(csa, state->trcccctlr, TRCCCCTLR);
> diff --git a/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c b/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c
> index b646d53a3133..0995a10790f4 100644
> --- a/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c
> +++ b/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c
> @@ -389,7 +389,7 @@ static ssize_t mode_store(struct device *dev,
>  		config->eventctrl1 &= ~BIT(12);
>  
>  	/* bit[8], Instruction stall bit */
> -	if (config->mode & ETM_MODE_ISTALL_EN)
> +	if ((config->mode & ETM_MODE_ISTALL_EN) && (drvdata->stallctl == true))

I have applied this patch.

>  		config->stall_ctrl |= BIT(8);
>  	else
>  		config->stall_ctrl &= ~BIT(8);
> -- 
> 2.24.1
> 

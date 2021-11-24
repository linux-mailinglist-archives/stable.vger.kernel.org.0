Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2916245CF7D
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 22:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231494AbhKXV6Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 16:58:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbhKXV6X (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 16:58:23 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A294C061574;
        Wed, 24 Nov 2021 13:55:13 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id k37-20020a05600c1ca500b00330cb84834fso6683303wms.2;
        Wed, 24 Nov 2021 13:55:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=wmXH53yFDJgEeKWTmhbyiZXLlf0B+f3sCaNuOIgBN3M=;
        b=jFKpZUm0pYWaGVCa1ZbMPQiNDFxJG0mH38T3CflvhB02RFiabBloS7AJKKjtn6IGCs
         V8z6+W8UyTnL4lcfiiMzEOqsbaAhXzlQDwhzE+T+BXq+kIubyX7Zsncc2KbVuflDJN6m
         T+Aiafp2/1ynO5fT5GUG2wfTbPpkEozcvjEhHPyI04J+dDbtRwHNjyczUKLr+QiAObro
         XG5WJvjoZ8tqFvSh7tloLJSp2w5xuRtsuk52UYSM8byHoCePVYnk9A9ZuunD0l+3y/tr
         bAqdjX0zecznmUksINBBVDTu2pK8KyyGhEuNaFEXv/dHGUtjOzYufisPs60Wa2xO+Y4y
         JcNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=wmXH53yFDJgEeKWTmhbyiZXLlf0B+f3sCaNuOIgBN3M=;
        b=a0SXjbpLSI1G2G2Of95ReWRw/Y2X5ORUVilY5Cg3GG465+oC+ax4hh4wKDDGS8lMXL
         DfAzqjtyOLo6C1orQuwXoW8kxJ8uzhDr/v5pR9LAqj2x2f7RHOgB74fw340RP0jZ6jGC
         MNwtWvcYv2ogMAkx2GBQ5/rrkbQrHOo9sD+Cybn9M8phlPgxg3C9dRSYL3CZuLTI6pfA
         8dtXe1Q0dn+pEnsLO8Oqm5EcHGqNgi4SBtss1Nqa1Mu4VA0hzTOVVLhHinYMySy9Da7w
         PCfIrc0I0KpO5RnQ8wRQRG+LItp/8xILenb241GzqKA81qLThNHQ4vHJXjMKb4nqCroy
         xwlQ==
X-Gm-Message-State: AOAM530p8UQR0jo8TSvLBfTIvsyf4QDoIpSpHTPPjpBxI7WnluDcINYX
        JRKjVh0vNjLgHDErzbjopq/y4bSFDwd52Q==
X-Google-Smtp-Source: ABdhPJxDVyZEY2AUGA+BWwZH6pLvt1tN5avq1QH5Jzl35eTDTqLQ1+JNH+eMgxnPd7hK8rHzUEuyxA==
X-Received: by 2002:a05:600c:1f0e:: with SMTP id bd14mr273096wmb.3.1637790911750;
        Wed, 24 Nov 2021 13:55:11 -0800 (PST)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id q26sm983076wrc.39.2021.11.24.13.55.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 13:55:11 -0800 (PST)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Wed, 24 Nov 2021 22:55:10 +0100
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Bard Liao <bard.liao@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 028/154] ASoC: Intel: sof_sdw: add missing quirk for
 Dell SKU 0A45
Message-ID: <YZ60vklYVessSxeU@eldamar.lan>
References: <20211124115702.361983534@linuxfoundation.org>
 <20211124115703.278367629@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211124115703.278367629@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Wed, Nov 24, 2021 at 12:57:04PM +0100, Greg Kroah-Hartman wrote:
> From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> 
> [ Upstream commit 64ba6d2ce72ffde70dc5a1794917bf1573203716 ]
> 
> This device is based on SDCA codecs but with a single amplifier
> instead of two.
> 
> BugLink: https://github.com/thesofproject/linux/issues/3161
> Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> Reviewed-by: Rander Wang <rander.wang@intel.com>
> Reviewed-by: Bard Liao <bard.liao@intel.com>
> Link: https://lore.kernel.org/r/20211004213512.220836-6-pierre-louis.bossart@linux.intel.com
> Signed-off-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  sound/soc/intel/boards/sof_sdw.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
> index 25548555d8d79..d9b864856be19 100644
> --- a/sound/soc/intel/boards/sof_sdw.c
> +++ b/sound/soc/intel/boards/sof_sdw.c
> @@ -187,6 +187,16 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
>  					SOF_RT715_DAI_ID_FIX |
>  					SOF_SDW_FOUR_SPK),
>  	},
> +	{
> +		.callback = sof_sdw_quirk_cb,
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc"),
> +			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "0A45")
> +		},
> +		.driver_data = (void *)(SOF_SDW_TGL_HDMI |
> +					RT711_JD2 |
> +					SOF_RT715_DAI_ID_FIX),
> +	},
>  	/* AlderLake devices */
>  	{
>  		.callback = sof_sdw_quirk_cb,

This one causes a build failure:

sound/soc/intel/boards/sof_sdw.c:197:41: error: ‘RT711_JD2’ undeclared here (not in a function)
  197 |                                         RT711_JD2 |
      |                                         ^~~~~~~~~
  CC      lib/mpi/mpicoder.o
make[7]: *** [scripts/Makefile.build:280: sound/soc/intel/boards/sof_sdw.o] Error 1
make[6]: *** [scripts/Makefile.build:497: sound/soc/intel/boards] Error 2
make[5]: *** [scripts/Makefile.build:497: sound/soc/intel] Error 2
make[4]: *** [scripts/Makefile.build:497: sound/soc] Error 2
make[3]: *** [Makefile:1822: sound] Error 2

We do not have for instance 8e6c00f1fdea ("ASoC: Intel: sof_sdw: include
rt711.h for RT711 JD mode") for stable series. 

Regards,
Salvatore

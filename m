Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC383570733
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 17:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbiGKPgR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 11:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230292AbiGKPgQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 11:36:16 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FE3573905
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 08:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657553776; x=1689089776;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=jpIixOohS7p57R2nbHdcBIV9FfF/hN1F+MF75dx/5lk=;
  b=bG5qfLjC23hcgRMnQDj/G1tyWzZGK7sxuMnF3mxXehONE6Mk9TaeB9+0
   zquIkIheSaXN1FHmgp72upsXC0En+4hkmyjcu9RFojUbE/ylLvbeiINZc
   uKTniX1dllagUAADTjeiHKOAlzy7/VB+IKFkkrV6QAQqjVPG7OvDXoerH
   aVDnwFQIzTuQvWSVzB/0h/6huihw/CFb38MHr9gGe4faqSiMMXQoiwSFZ
   BVLOl5A9ZKXsy+YjS2145uIB08t8KwAXovtkVQXRYPxoSzbmjYUCybTNi
   Cc48J+3ocLEiEGem/gWqzH+GoINrrzulAZHsGEdN88UCzT3UmJDee/Dp4
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10405"; a="264474764"
X-IronPort-AV: E=Sophos;i="5.92,263,1650956400"; 
   d="scan'208";a="264474764"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 08:36:15 -0700
X-IronPort-AV: E=Sophos;i="5.92,263,1650956400"; 
   d="scan'208";a="921826934"
Received: from jbeecha-mobl.amr.corp.intel.com (HELO [10.209.161.159]) ([10.209.161.159])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 08:36:15 -0700
Message-ID: <427a34f7-5170-ca9e-f9b3-2dec0db82eac@linux.intel.com>
Date:   Mon, 11 Jul 2022 10:36:14 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.10.0
Subject: Re: FAILED: patch "[PATCH] ASoC: SOF: Intel: disable IMR boot when
 resuming from ACPI S4" failed to apply to 5.18-stable tree
Content-Language: en-US
To:     gregkh@linuxfoundation.org, broonie@kernel.org,
        peter.ujfalusi@linux.intel.com, ranjani.sridharan@linux.intel.com
Cc:     stable@vger.kernel.org
References: <16575231593075@kroah.com>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
In-Reply-To: <16575231593075@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 7/11/22 02:05, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.18-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Indeed, there's a dependency on

2a68ff846164 ("ASoC: SOF: Intel: hda: Revisit IMR boot sequence")

as well as the definitions added in the same patchset.

7a5974e035a6 ("ASoC: SOF: pm: add definitions for S4 and S5 states
")
6639990dbb25 ("ASoC: SOF: pm: add explicit behavior for ACPI S1 and S2
")

will send the backport shortly.

> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From 391153522d186f19a008d824bb3a05950351ce6c Mon Sep 17 00:00:00 2001
> From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> Date: Thu, 16 Jun 2022 15:18:18 -0500
> Subject: [PATCH] ASoC: SOF: Intel: disable IMR boot when resuming from ACPI S4
>  and S5 states
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> The IMR was assumed to be preserved when suspending to S4 and S5
> states, but community reports invalidate that assumption, the hardware
> seems to be powered off and the IMR memory content cleared.
> 
> Make sure regular boot with firmware download is used for S4 and S5.
> 
> BugLink: https://github.com/thesofproject/sof/issues/5892
> Fixes: 5fb5f51185126 ("ASoC: SOF: Intel: hda-loader: add IMR restore support")
> Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
> Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
> Link: https://lore.kernel.org/r/20220616201818.130802-4-pierre-louis.bossart@linux.intel.com
> Signed-off-by: Mark Brown <broonie@kernel.org>
> 
> diff --git a/sound/soc/sof/intel/hda-loader.c b/sound/soc/sof/intel/hda-loader.c
> index d3ec5996a9a3..145d483bd129 100644
> --- a/sound/soc/sof/intel/hda-loader.c
> +++ b/sound/soc/sof/intel/hda-loader.c
> @@ -389,7 +389,8 @@ int hda_dsp_cl_boot_firmware(struct snd_sof_dev *sdev)
>  	struct snd_dma_buffer dmab;
>  	int ret, ret1, i;
>  
> -	if (hda->imrboot_supported && !sdev->first_boot) {
> +	if (sdev->system_suspend_target < SOF_SUSPEND_S4 &&
> +	    hda->imrboot_supported && !sdev->first_boot) {
>  		dev_dbg(sdev->dev, "IMR restore supported, booting from IMR directly\n");
>  		hda->boot_iteration = 0;
>  		ret = hda_dsp_boot_imr(sdev);
> 

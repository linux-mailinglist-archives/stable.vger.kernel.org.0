Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9856E1315A8
	for <lists+stable@lfdr.de>; Mon,  6 Jan 2020 17:06:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbgAFQGl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jan 2020 11:06:41 -0500
Received: from mga17.intel.com ([192.55.52.151]:29919 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726477AbgAFQGl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Jan 2020 11:06:41 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jan 2020 08:06:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,403,1571727600"; 
   d="scan'208";a="216866400"
Received: from cwpinto-mobl.amr.corp.intel.com (HELO [10.252.199.187]) ([10.252.199.187])
  by fmsmga007.fm.intel.com with ESMTP; 06 Jan 2020 08:06:39 -0800
Subject: Re: [alsa-devel] [PATCH] ASoC: Intel: bytcht_es8316: Fix Irbis NB41
 netbook quirk
To:     Hans de Goede <hdegoede@redhat.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Jie Yang <yang.jie@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Cc:     alsa-devel@alsa-project.org, stable@vger.kernel.org,
        russianneuromancer@ya.ru
References: <20200106113903.279394-1-hdegoede@redhat.com>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Message-ID: <920b8e1a-e01c-08b4-500a-9983a21fccab@linux.intel.com>
Date:   Mon, 6 Jan 2020 08:23:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200106113903.279394-1-hdegoede@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 1/6/20 5:39 AM, Hans de Goede wrote:
> When a quirk for the Irbis NB41 netbook was added, to override the defaults
> for this device, I forgot to add/keep the BYT_CHT_ES8316_SSP0 part of the
> defaults, completely breaking audio on this netbook.
> 
> This commit adds the BYT_CHT_ES8316_SSP0 flag to the Irbis NB41 netbook
> quirk, making audio work again.
> 
> Cc: stable@vger.kernel.org
> Cc: russianneuromancer@ya.ru
> Fixes: aa2ba991c420 ("ASoC: Intel: bytcht_es8316: Add quirk for Irbis NB41 netbook")
> Reported-and-tested-by: russianneuromancer@ya.ru
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

> ---
>   sound/soc/intel/boards/bytcht_es8316.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/sound/soc/intel/boards/bytcht_es8316.c b/sound/soc/intel/boards/bytcht_es8316.c
> index 46612331f5ea..54e97455d7f6 100644
> --- a/sound/soc/intel/boards/bytcht_es8316.c
> +++ b/sound/soc/intel/boards/bytcht_es8316.c
> @@ -442,7 +442,8 @@ static const struct dmi_system_id byt_cht_es8316_quirk_table[] = {
>   			DMI_MATCH(DMI_SYS_VENDOR, "IRBIS"),
>   			DMI_MATCH(DMI_PRODUCT_NAME, "NB41"),
>   		},
> -		.driver_data = (void *)(BYT_CHT_ES8316_INTMIC_IN2_MAP
> +		.driver_data = (void *)(BYT_CHT_ES8316_SSP0
> +					| BYT_CHT_ES8316_INTMIC_IN2_MAP
>   					| BYT_CHT_ES8316_JD_INVERTED),
>   	},
>   	{	/* Teclast X98 Plus II */
> 

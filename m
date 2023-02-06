Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF81E68C2C4
	for <lists+stable@lfdr.de>; Mon,  6 Feb 2023 17:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231747AbjBFQOw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Feb 2023 11:14:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231806AbjBFQO0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Feb 2023 11:14:26 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8224233F2;
        Mon,  6 Feb 2023 08:13:53 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id hr39so6058911ejc.7;
        Mon, 06 Feb 2023 08:13:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UQhD+ec2S4mTIIShs1xDAIKPLHsrAFWTAMbPN/6PoOw=;
        b=hteaMnhFOJbc8CndpRptV/Ms+XKvBO4I50GOJmBTL87yFfpTGLA1h12TN6P7vG/FPe
         IXTQh/ocFI8rwTXe3DosuNB3y/ofQIkzkwIXQPzNhcBW+FCfwAKHGtuPyI0991DHiv6O
         ngOnR+hsjeGDOOIxfBJ0YDo41f0FYMu3tDfIgxSM5SaVu/y0ssZ+xv/yfcOtbyVU6xaC
         SqqigjB2kRRP1w9jmML7bjl67n6MLzMAF5WnsBFBuG7T2fzEsSClBvya44Cx4bQcv4+M
         pJLBpM4jeoebjoUf3s4GgheXa8lw6VnwnFX9q8PmiKgFMy5uJFi7z6KTlXG3pDQa0tFJ
         S14A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UQhD+ec2S4mTIIShs1xDAIKPLHsrAFWTAMbPN/6PoOw=;
        b=1D5y5tXLevADL6FeP495xoabbXVdaCZPrjhpulBptIddozyPFLP2lUFgNZQTtbvhkY
         Rcbhg3EptBMpR3R0/RWBKczDiabKmcZ9gydDft31Tr0IA25ubRgtJSwufngIUIBbxn2w
         tlhgQo/2qa67kpDr5yJZebq5cmgDoZT/dkmYEOpFG7slBzdbA+HlZcUFc0FZm07tPZC0
         +68k50B2ezGGe178fTOayDgaLyxEXVt+1a1/CINOHWwkAaxmgNvHRaLa5oq5GPu3SSES
         XT24qhxrBu3Cr8w4GT+zwdb24iGxxKbfq9P7u81Qb3UpMRoWhW3+ptsgea0dPkPVxaNz
         0nqQ==
X-Gm-Message-State: AO0yUKWrfuQ4EKB/s0zmQiqrrSJrkCFqLEvBVzuST7oRHsoGEoVRUDRI
        v10yqVIMIzloaegW6qKp0VTlpXjr+CE=
X-Google-Smtp-Source: AK7set8fItB/W1HY35jwETzdb3QBT+5VAzdNuNpH6HL5FJIgi4X1448jfeIMf4sldaCWbPl6LShOGQ==
X-Received: by 2002:a17:906:9610:b0:878:5e84:e1d6 with SMTP id s16-20020a170906961000b008785e84e1d6mr24104248ejx.75.1675700031712;
        Mon, 06 Feb 2023 08:13:51 -0800 (PST)
Received: from jernej-laptop.localnet (82-149-19-102.dynamic.telemach.net. [82.149.19.102])
        by smtp.gmail.com with ESMTPSA id d4-20020a1709063ec400b0087bd2ebe474sm5571368ejj.208.2023.02.06.08.13.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Feb 2023 08:13:51 -0800 (PST)
From:   Jernej =?utf-8?B?xaBrcmFiZWM=?= <jernej.skrabec@gmail.com>
To:     stable-commits@vger.kernel.org, yuancan@huawei.com,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc:     Chen-Yu Tsai <wens@csie.org>, Samuel Holland <samuel@sholland.org>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>
Subject: Re: Patch "bus: sunxi-rsb: Fix error handling in sunxi_rsb_init()" has been
 added to the 5.10-stable tree
Date:   Mon, 06 Feb 2023 17:13:49 +0100
Message-ID: <12145054.O9o76ZdvQC@jernej-laptop>
In-Reply-To: <20230206134506.1652464-1-sashal@kernel.org>
References: <20230206134506.1652464-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha!

Dne ponedeljek, 06. februar 2023 ob 14:45:06 CET je Sasha Levin napisal(a):
> This is a note to let you know that I've just added the patch titled
> 
>     bus: sunxi-rsb: Fix error handling in sunxi_rsb_init()
> 
> to the 5.10-stable tree which can be found at:
>    
> http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=sum
> mary
> 
> The filename of the patch is:
>      bus-sunxi-rsb-fix-error-handling-in-sunxi_rsb_init.patch
> and it can be found in the queue-5.10 subdirectory.
> 
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.
> 
> 
> 
> commit ad954fdfb62b7541a93ce1a12da025a8f698d8a8
> Author: Yuan Can <yuancan@huawei.com>
> Date:   Wed Nov 23 09:42:00 2022 +0000
> 
>     bus: sunxi-rsb: Fix error handling in sunxi_rsb_init()
> 
>     [ Upstream commit f71eaf2708be7831428eacae7db25d8ec6b8b4c5 ]
> 
>     The sunxi_rsb_init() returns the platform_driver_register() directly
>     without checking its return value, if platform_driver_register() failed,
> the sunxi_rsb_bus is not unregistered.
>     Fix by unregister sunxi_rsb_bus when platform_driver_register() failed.
> 
>     Fixes: d787dcdb9c8f ("bus: sunxi-rsb: Add driver for Allwinner Reduced
> Serial Bus") Signed-off-by: Yuan Can <yuancan@huawei.com>
>     Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
>     Link:
> https://lore.kernel.org/r/20221123094200.12036-1-yuancan@huawei.com
> Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
>     Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> diff --git a/drivers/bus/sunxi-rsb.c b/drivers/bus/sunxi-rsb.c
> index f8c29b888e6b..98cbb18f17fa 100644
> --- a/drivers/bus/sunxi-rsb.c
> +++ b/drivers/bus/sunxi-rsb.c
> @@ -781,7 +781,13 @@ static int __init sunxi_rsb_init(void)
>  		return ret;
>  	}
> 
> -	return platform_driver_register(&sunxi_rsb_driver);
> +	ret = platform_driver_register(&sunxi_rsb_driver);
> +	if (ret) {
> +		bus_unregister(&sunxi_rsb_bus);
> +		return ret;
> +	}
> +
> +	return 0;
>  }
>  module_init(sunxi_rsb_init);
> 
> diff --git a/sound/soc/intel/boards/bytcr_rt5651.c
> b/sound/soc/intel/boards/bytcr_rt5651.c index bf8b87d45cb0..2c76f0abeeca
> 100644
> --- a/sound/soc/intel/boards/bytcr_rt5651.c
> +++ b/sound/soc/intel/boards/bytcr_rt5651.c
> @@ -918,7 +918,6 @@ static int snd_byt_rt5651_mc_probe(struct
> platform_device *pdev) if (adev) {
>  		snprintf(byt_rt5651_codec_name, 
sizeof(byt_rt5651_codec_name),
>  			 "i2c-%s", acpi_dev_name(adev));
> -		put_device(&adev->dev);
>  		byt_rt5651_dais[dai_index].codecs->name = 
byt_rt5651_codec_name;
>  	} else {
>  		dev_err(&pdev->dev, "Error cannot find '%s' dev\n", 
mach->id);
> @@ -927,6 +926,7 @@ static int snd_byt_rt5651_mc_probe(struct
> platform_device *pdev)
> 
>  	codec_dev = bus_find_device_by_name(&i2c_bus_type, NULL,
>  					    
byt_rt5651_codec_name);
> +	acpi_dev_put(adev);
>  	if (!codec_dev)
>  		return -EPROBE_DEFER;

Above bytcr_rt5651.c changes are unrelated to original commit. Did you merge 
two commits by mistake?

Best regards,
Jernej





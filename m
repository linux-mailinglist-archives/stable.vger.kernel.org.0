Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42983148583
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 13:58:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387437AbgAXM6i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 07:58:38 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:58532 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387393AbgAXM6i (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jan 2020 07:58:38 -0500
Received: from [IPv6:2a00:5f00:102:0:8b5:67ff:fe5d:5a19] (unknown [IPv6:2a00:5f00:102:0:8b5:67ff:fe5d:5a19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: gtucker)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 570E8294B1B;
        Fri, 24 Jan 2020 12:58:35 +0000 (GMT)
Subject: Re: stable-rc/linux-4.19.y bisection: baseline.login on
 sun8i-h3-libretech-all-h3-cc
To:     Linus Walleij <linus.walleij@linaro.org>
References: <5e2ad951.1c69fb81.6d762.dd8e@mx.google.com>
Cc:     khilman@baylibre.com, tomeu.vizoso@collabora.com,
        mgalka@collabora.com, enric.balletbo@collabora.com,
        broonie@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From:   Guillaume Tucker <guillaume.tucker@collabora.com>
Message-ID: <0ed4668a-fb29-fca8-558e-385ef118d432@collabora.com>
Date:   Fri, 24 Jan 2020 12:58:32 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <5e2ad951.1c69fb81.6d762.dd8e@mx.google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Linus,

Please see the bisection report below about a boot failure, it
looks legit as this commit was made today:


commit 5f9277249f9b126f815e23c3078cff3b69ce2715
Author:     Linus Walleij <linus.walleij@linaro.org>
AuthorDate: Mon Oct 1 22:43:46 2018 +0200
Commit:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CommitDate: Fri Jan 24 10:27:24 2020 +0100

    regulator: fixed: Default enable high on DT regulators
    
    [ Upstream commit 28be5f15df2ee6882b0a122693159c96a28203c7 ]


KernelCI bisection reports are not publicly sent at the moment
while we're trialing some new bisection features.

Thanks,
Guillaume

On 24/01/2020 11:47, kernelci.org bot wrote:
> * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
> * This automated bisection report was sent to you on the basis  *
> * that you may be involved with the breaking commit it has      *
> * found.  No manual investigation has been done to verify it,   *
> * and the root cause of the problem may be somewhere else.      *
> *                                                               *
> * If you do send a fix, please include this trailer:            *
> *   Reported-by: "kernelci.org bot" <bot@kernelci.org>          *
> *                                                               *
> * Hope this helps!                                              *
> * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
> 
> stable-rc/linux-4.19.y bisection: baseline.login on sun8i-h3-libretech-all-h3-cc
> 
> Summary:
>   Start:      be6fe2fc68d0 Linux 4.19.99-rc1
>   Plain log:  https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.98-640-gbe6fe2fc68d0/arm/sunxi_defconfig/gcc-8/lab-baylibre/baseline-sun8i-h3-libretech-all-h3-cc.txt
>   HTML log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.98-640-gbe6fe2fc68d0/arm/sunxi_defconfig/gcc-8/lab-baylibre/baseline-sun8i-h3-libretech-all-h3-cc.html
>   Result:     250d67d6bc05 regulator: fixed: Default enable high on DT regulators
> 
> Checks:
>   revert:     PASS
>   verify:     PASS
> 
> Parameters:
>   Tree:       stable-rc
>   URL:        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>   Branch:     linux-4.19.y
>   Target:     sun8i-h3-libretech-all-h3-cc
>   CPU arch:   arm
>   Lab:        lab-baylibre
>   Compiler:   gcc-8
>   Config:     sunxi_defconfig
>   Test case:  baseline.login
> 
> Breaking commit found:
> 
> -------------------------------------------------------------------------------
> commit 250d67d6bc0597c0c0de47b3ea32dc6d4e3f9322
> Author: Linus Walleij <linus.walleij@linaro.org>
> Date:   Mon Oct 1 22:43:46 2018 +0200
> 
>     regulator: fixed: Default enable high on DT regulators
>     
>     [ Upstream commit 28be5f15df2ee6882b0a122693159c96a28203c7 ]
>     
>     commit efdfeb079cc3
>     ("regulator: fixed: Convert to use GPIO descriptor only")
>     switched to use gpiod_get() to look up the regulator from the
>     gpiolib core whether that is device tree or boardfile.
>     
>     This meant that we activate the code in
>     a603a2b8d86e ("gpio: of: Add special quirk to parse regulator flags")
>     which means the descriptors coming from the device tree already
>     have the right inversion and open drain semantics set up from
>     the gpiolib core.
>     
>     As the fixed regulator was inspected again we got the
>     inverted inversion and things broke.
>     
>     Fix it by ignoring the config in the device tree for now: the
>     later patches in the series will push all inversion handling
>     over to the gpiolib core and set it up properly in the
>     boardfiles for legacy devices, but I did not finish that
>     for this kernel cycle.
>     
>     Fixes: commit efdfeb079cc3 ("regulator: fixed: Convert to use GPIO descriptor only")
>     Reported-by: Leonard Crestez <leonard.crestez@nxp.com>
>     Reported-by: Fabio Estevam <festevam@gmail.com>
>     Reported-by: John Stultz <john.stultz@linaro.org>
>     Reported-by: Anders Roxell <anders.roxell@linaro.org>
>     Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>     Tested-by: John Stultz <john.stultz@linaro.org>
>     Signed-off-by: Mark Brown <broonie@kernel.org>
>     Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
> index 988a7472c2ab..d68ff65a5adc 100644
> --- a/drivers/regulator/fixed.c
> +++ b/drivers/regulator/fixed.c
> @@ -84,9 +84,14 @@ of_get_fixed_voltage_config(struct device *dev,
>  
>  	of_property_read_u32(np, "startup-delay-us", &config->startup_delay);
>  
> -	config->enable_high = of_property_read_bool(np, "enable-active-high");
> -	config->gpio_is_open_drain = of_property_read_bool(np,
> -							   "gpio-open-drain");
> +	/*
> +	 * FIXME: we pulled active low/high and open drain handling into
> +	 * gpiolib so it will be handled there. Delete this in the second
> +	 * step when we also remove the custom inversion handling for all
> +	 * legacy boardfiles.
> +	 */
> +	config->enable_high = 1;
> +	config->gpio_is_open_drain = 0;
>  
>  	if (of_find_property(np, "vin-supply", NULL))
>  		config->input_supply = "vin";
> -------------------------------------------------------------------------------
> 
> 
> Git bisection log:
> 
> -------------------------------------------------------------------------------
> git bisect start
> # good: [d183c8e2647a7d45202c14a33631f6c09020f8ac] Linux 4.19.98
> git bisect good d183c8e2647a7d45202c14a33631f6c09020f8ac
> # bad: [be6fe2fc68d0d7571c06b5fc11d2282a6544ec0f] Linux 4.19.99-rc1
> git bisect bad be6fe2fc68d0d7571c06b5fc11d2282a6544ec0f
> # bad: [62715658388c5d59c35c4f7fdcffbc8e8772f39e] ARM: dts: ls1021: Fix SGMII PCS link remaining down after PHY disconnect
> git bisect bad 62715658388c5d59c35c4f7fdcffbc8e8772f39e
> # bad: [2d2f9b317958a34ebecf731ac7510c649a2ab33c] driver core: Do not resume suppliers under device_links_write_lock()
> git bisect bad 2d2f9b317958a34ebecf731ac7510c649a2ab33c
> # bad: [83ab4275fc5a25992200a394c692542ad8584276] mailbox: ti-msgmgr: Off by one in ti_msgmgr_of_xlate()
> git bisect bad 83ab4275fc5a25992200a394c692542ad8584276
> # good: [864d924463eb890af4ea92cbb4108ebcba42bd6c] usb: gadget: fsl_udc_core: check allocation return value and cleanup on failure
> git bisect good 864d924463eb890af4ea92cbb4108ebcba42bd6c
> # bad: [51ee3169bec81a0f48bdb0a7402bfa1d863d6006] mlxsw: reg: QEEC: Add minimum shaper fields
> git bisect bad 51ee3169bec81a0f48bdb0a7402bfa1d863d6006
> # bad: [bf4a2476e727c5a302c40a0e66e1702c2c135b7c] pwm: lpss: Release runtime-pm reference from the driver's remove callback
> git bisect bad bf4a2476e727c5a302c40a0e66e1702c2c135b7c
> # bad: [d54e7094b7bd73384d64cc328a0c979522e3cb67] of: Fix property name in of_node_get_device_type
> git bisect bad d54e7094b7bd73384d64cc328a0c979522e3cb67
> # bad: [250d67d6bc0597c0c0de47b3ea32dc6d4e3f9322] regulator: fixed: Default enable high on DT regulators
> git bisect bad 250d67d6bc0597c0c0de47b3ea32dc6d4e3f9322
> # good: [9b2060c15a1b2524fb4ac3f3cc2cf5dcbc293955] cfg80211: regulatory: make initialization more robust
> git bisect good 9b2060c15a1b2524fb4ac3f3cc2cf5dcbc293955
> # first bad commit: [250d67d6bc0597c0c0de47b3ea32dc6d4e3f9322] regulator: fixed: Default enable high on DT regulators
> -------------------------------------------------------------------------------
> 


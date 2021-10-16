Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A632430562
	for <lists+stable@lfdr.de>; Sun, 17 Oct 2021 00:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233464AbhJPW0O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Oct 2021 18:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236606AbhJPW0K (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 16 Oct 2021 18:26:10 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D3BCC061767
        for <stable@vger.kernel.org>; Sat, 16 Oct 2021 15:24:00 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id b189-20020a1c1bc6000000b0030da052dd4fso5058900wmb.3
        for <stable@vger.kernel.org>; Sat, 16 Oct 2021 15:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BqbX/wOwlUQGVZxjSyS1aiwJt03MkC15YQIT8Xq1qPI=;
        b=Vi5in+qPCWcYwZt0+DU0yyOxtYcml4HWBFOXO3+j2piaNB1BbtatiVB0u2uwvT2FD/
         Emduaij2cKTKSANLgZSKY5Ui5oKh9iMzsWmZeQjY2tddPoynROuld4H0tGdIqSMluuwQ
         ojYbMv5G7M3aXryljgjbzMbM1aG1wQZtgj7JsY6ozzw74ohPdiYwOAuSaq2brkKXgH3u
         GWwvwgTjB2IKxiRxW0F2AGQFSs9m+eXhsg/kML3tZ5nYDX3CmtQWmHmw4o1gEpUqVK/4
         qs0GN3QwEf2Z0O87xOFqWZ2GbiJEHCW+9P2c4WqFsgMSEju0S7bGhudC4YPjvogU/4tr
         cbBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BqbX/wOwlUQGVZxjSyS1aiwJt03MkC15YQIT8Xq1qPI=;
        b=ZqFTLGWVtB55661o9TVEyaB95bwXnIVxjzVWBcHSUwwiFOVNguLzfKGlhdl6sOhGgn
         TA3GNpHJJtIWayv2oLplPEjp6uhGcs6lKvYDIlfc0BGzcB/DvZUw+dD3W/H+kx5ZYRVI
         IzI+xK3QuPcdJJybSwTryy/PNQI6QnkWIVGWzPC825RhRgS83lm4kLmbXOHMxd8oMfF0
         Fat6+g28LD8CzZgL+3lLvueBhtU9HNYDbIO/bhJQIQRriKpujjbVpZYh+r2qa+jn+pkX
         rBdXHCSxugf3O0zlaWtUOIKKhPyLB+h0fuwiRxsaG5ZRBXf6lmQLRGLkiGj7PJVI23bp
         Ye0g==
X-Gm-Message-State: AOAM533SON84q49FQg3i7e+zPlvr3G/AVKI/dzxA2D2hGgjC3Ps8dNmX
        k91xds2Uziol5p62xo5UiEXQ988BKozanmEP
X-Google-Smtp-Source: ABdhPJySJtsAMFRmVhcDqy0W9uv1rkUuCq3gLR2Y9MaVHJElaJG9FWJJ/pDKVCMIR8jNeuEQZMV1Vw==
X-Received: by 2002:a05:600c:896:: with SMTP id l22mr21122832wmp.92.1634423038800;
        Sat, 16 Oct 2021 15:23:58 -0700 (PDT)
Received: from ?IPv6:2a01:e34:ed2f:f020:f04d:f65f:efd5:698? ([2a01:e34:ed2f:f020:f04d:f65f:efd5:698])
        by smtp.googlemail.com with ESMTPSA id y191sm16229441wmc.36.2021.10.16.15.23.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Oct 2021 15:23:58 -0700 (PDT)
Subject: Re: [PATCH] thermal: imx: Fix temperature measurements on i.MX6 after
 alarm
To:     =?UTF-8?B?TWljaGFsIFZva8OhxI0=?= <michal.vokac@ysoft.com>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        linux-pm@vger.kernel.org, Shawn Guo <shawnguo@kernel.org>
Cc:     Amit Kucheria <amitk@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?Q?Petr_Bene=c5=a1?= <petr.benes@ysoft.com>,
        petrben@gmail.com, stable@vger.kernel.org
References: <20211008081137.1948848-1-michal.vokac@ysoft.com>
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
Message-ID: <df545947-2f5b-a355-859d-7f61eab14dcb@linaro.org>
Date:   Sun, 17 Oct 2021 00:23:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211008081137.1948848-1-michal.vokac@ysoft.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08/10/2021 10:11, Michal Vokáč wrote:
> From: Petr Beneš <petr.benes@ysoft.com>
> 
> SoC temperature readout may not work after thermal alarm fires interrupt.
> This harms userspace as well as CPU cooling device.
> 
> Two issues with the logic involved. First, there is no protection against
> concurent measurements, hence one can switch the sensor off while
> the other one tries to read temperature later. Second, the interrupt path
> usually fails. At the end the sensor is powered off and thermal IRQ is
> disabled. One has to reenable the thermal zone by the sysfs interface.
> 
> Most of troubles come from commit d92ed2c9d3ff ("thermal: imx: Use
> driver's local data to decide whether to run a measurement")

Are these troubles observed and reproduced ? Or is it your understanding
from reading the code ?

get_temp() and tz enable/disable are protected against races in the core
code via the tz mutex

> It uses data->irq_enabled as the "local data". Indeed, its value is
> related to the state of the sensor loosely under normal operation and,
> frankly, gets unleashed when the thermal interrupt arrives.
> 
> Current patch adds the "local data" (new member sensor_on in
> imx_thermal_data) and sets its value in controlled manner.>
> Fixes: d92ed2c9d3ff ("thermal: imx: Use driver's local data to decide whether to run a measurement")
> Cc: petrben@gmail.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Petr Beneš <petr.benes@ysoft.com>
> Signed-off-by: Michal Vokáč <michal.vokac@ysoft.com>
> ---
>  drivers/thermal/imx_thermal.c | 30 ++++++++++++++++++++++++++----
>  1 file changed, 26 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/thermal/imx_thermal.c b/drivers/thermal/imx_thermal.c
> index 2c7473d86a59..df5658e21828 100644
> --- a/drivers/thermal/imx_thermal.c
> +++ b/drivers/thermal/imx_thermal.c
> @@ -209,6 +209,8 @@ struct imx_thermal_data {
>  	struct clk *thermal_clk;
>  	const struct thermal_soc_data *socdata;
>  	const char *temp_grade;
> +	struct mutex sensor_lock;
> +	bool sensor_on;
>  };
>  
>  static void imx_set_panic_temp(struct imx_thermal_data *data,
> @@ -252,11 +254,12 @@ static int imx_get_temp(struct thermal_zone_device *tz, int *temp)
>  	const struct thermal_soc_data *soc_data = data->socdata;
>  	struct regmap *map = data->tempmon;
>  	unsigned int n_meas;
> -	bool wait, run_measurement;
> +	bool wait;
>  	u32 val;
>  
> -	run_measurement = !data->irq_enabled;
> -	if (!run_measurement) {
> +	mutex_lock(&data->sensor_lock);
> +
> +	if (data->sensor_on) {
>  		/* Check if a measurement is currently in progress */
>  		regmap_read(map, soc_data->temp_data, &val);
>  		wait = !(val & soc_data->temp_valid_mask);
> @@ -283,13 +286,15 @@ static int imx_get_temp(struct thermal_zone_device *tz, int *temp)
>  
>  	regmap_read(map, soc_data->temp_data, &val);
>  
> -	if (run_measurement) {
> +	if (!data->sensor_on) {
>  		regmap_write(map, soc_data->sensor_ctrl + REG_CLR,
>  			     soc_data->measure_temp_mask);
>  		regmap_write(map, soc_data->sensor_ctrl + REG_SET,
>  			     soc_data->power_down_mask);
>  	}
>  
> +	mutex_unlock(&data->sensor_lock);
> +
>  	if ((val & soc_data->temp_valid_mask) == 0) {
>  		dev_dbg(&tz->device, "temp measurement never finished\n");
>  		return -EAGAIN;
> @@ -339,20 +344,26 @@ static int imx_change_mode(struct thermal_zone_device *tz,
>  	const struct thermal_soc_data *soc_data = data->socdata;
>  
>  	if (mode == THERMAL_DEVICE_ENABLED) {
> +		mutex_lock(&data->sensor_lock);
>  		regmap_write(map, soc_data->sensor_ctrl + REG_CLR,
>  			     soc_data->power_down_mask);
>  		regmap_write(map, soc_data->sensor_ctrl + REG_SET,
>  			     soc_data->measure_temp_mask);
> +		data->sensor_on = true;
> +		mutex_unlock(&data->sensor_lock);
>  
>  		if (!data->irq_enabled) {
>  			data->irq_enabled = true;
>  			enable_irq(data->irq);
>  		}
>  	} else {
> +		mutex_lock(&data->sensor_lock);
>  		regmap_write(map, soc_data->sensor_ctrl + REG_CLR,
>  			     soc_data->measure_temp_mask);
>  		regmap_write(map, soc_data->sensor_ctrl + REG_SET,
>  			     soc_data->power_down_mask);
> +		data->sensor_on = false;
> +		mutex_unlock(&data->sensor_lock);
>  
>  		if (data->irq_enabled) {
>  			disable_irq(data->irq);
> @@ -728,6 +739,8 @@ static int imx_thermal_probe(struct platform_device *pdev)
>  	}
>  
>  	/* Make sure sensor is in known good state for measurements */
> +	mutex_init(&data->sensor_lock);
> +	mutex_lock(&data->sensor_lock);
>  	regmap_write(map, data->socdata->sensor_ctrl + REG_CLR,
>  		     data->socdata->power_down_mask);
>  	regmap_write(map, data->socdata->sensor_ctrl + REG_CLR,
> @@ -739,6 +752,8 @@ static int imx_thermal_probe(struct platform_device *pdev)
>  			IMX6_MISC0_REFTOP_SELBIASOFF);
>  	regmap_write(map, data->socdata->sensor_ctrl + REG_SET,
>  		     data->socdata->power_down_mask);
> +	data->sensor_on = false;
> +	mutex_unlock(&data->sensor_lock);
>  
>  	ret = imx_thermal_register_legacy_cooling(data);
>  	if (ret)
> @@ -796,10 +811,13 @@ static int imx_thermal_probe(struct platform_device *pdev)
>  	if (data->socdata->version == TEMPMON_IMX6SX)
>  		imx_set_panic_temp(data, data->temp_critical);
>  
> +	mutex_lock(&data->sensor_lock);
>  	regmap_write(map, data->socdata->sensor_ctrl + REG_CLR,
>  		     data->socdata->power_down_mask);
>  	regmap_write(map, data->socdata->sensor_ctrl + REG_SET,
>  		     data->socdata->measure_temp_mask);
> +	data->sensor_on = true;
> +	mutex_unlock(&data->sensor_lock);
>  
>  	data->irq_enabled = true;
>  	ret = thermal_zone_device_enable(data->tz);
> @@ -832,8 +850,12 @@ static int imx_thermal_remove(struct platform_device *pdev)
>  	struct regmap *map = data->tempmon;
>  
>  	/* Disable measurements */
> +	mutex_lock(&data->sensor_lock);
>  	regmap_write(map, data->socdata->sensor_ctrl + REG_SET,
>  		     data->socdata->power_down_mask);
> +	data->sensor_on = false;
> +	mutex_unlock(&data->sensor_lock);
> +
>  	if (!IS_ERR(data->thermal_clk))
>  		clk_disable_unprepare(data->thermal_clk);
>  
> 


-- 
<http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

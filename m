Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6F3943125A
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 10:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbhJRIqH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 04:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbhJRIqG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Oct 2021 04:46:06 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA203C06161C
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 01:43:55 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id e12so39887777wra.4
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 01:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9JaIx8VpWvuUdA6UzYtoFnNy3De6CwfZcUSCPIca5YM=;
        b=kh157huEHS8uKAqERN+t0jBIFXD5TSWZkL/0sV8/zdSKbW+3jx/odYTuVvRWTNgObP
         qIp882UtDITS84UZMJTv9uCqB5NttEoyn1w189L4jnBZc1VpZOeleSoDVt6lbk4+OqG/
         OBQaJYfWg9+AcrkFgdLnbxbKozmMkoM2vySWjcDVhQPwOaPZQnXKZHSDjbd02T9AbV3H
         qW9eB/6/3Zl+Qi/HUko3NqN/ps5K+dnK6+HJBVWF/6XzvbQ/R/ioQU807ExcN3hqOOac
         JR0KYfN9kTHJSCV15JoeNEcxn60+8AWVUzcLsfDp4+OLhWyyJLcot22jPpu5o0jewFkw
         jsgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9JaIx8VpWvuUdA6UzYtoFnNy3De6CwfZcUSCPIca5YM=;
        b=PXPTRVAUy2sjoy54DfYywR5O5WPz2a/P/nil4PwdclTOCNNuoceUtrDXco1fJnOtdZ
         5IIqf+XVnTEVwhcRyJ7bh6zUnVEh9dM5UcCvp+opyPMp4X4HQivbBkazKikQ6II4cc60
         3Xzqnw2e/b3hHVJUNJ0AkSXa5vIcTq+P6sA0hB+S1IJ8VlV4Uqn7ZLUpVwVxXprMqXFG
         4TzuUcPO5PdhNNOYO+53w89HkQu/8O9PtOQk4Y8a2gFr70VeaxQwYzvmsVaXK+knClAR
         bCqE+gxcMd80GN6t4t2PjA8QCOmJ3O4evnNGM4oimuyVjUeFbP6Z9MVEco4b3SpQMolq
         94Iw==
X-Gm-Message-State: AOAM532MtAxnRVj/X6aTNYqFum9gG4DAP7BDrsGmqdyDN23A47KWJOpn
        PphK2fKSo6qmnMvFYpw4BYTooR7f3rkHFQ==
X-Google-Smtp-Source: ABdhPJyU244LBOF2amsKcmIsmelahkg/l5NsfP9e1YAnXWhrN4nWWLoGfwU4PI1Rcb8o+trhq5Yf1A==
X-Received: by 2002:a5d:4a0c:: with SMTP id m12mr34451489wrq.27.1634546634268;
        Mon, 18 Oct 2021 01:43:54 -0700 (PDT)
Received: from ?IPv6:2a01:e34:ed2f:f020:b2b3:1133:5bdb:b2f2? ([2a01:e34:ed2f:f020:b2b3:1133:5bdb:b2f2])
        by smtp.googlemail.com with ESMTPSA id c3sm10667002wrw.66.2021.10.18.01.43.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 01:43:53 -0700 (PDT)
Subject: Re: [PATCH] thermal: imx: Fix temperature measurements on i.MX6 after
 alarm
To:     Petr Benes <petrben@gmail.com>
Cc:     =?UTF-8?B?TWljaGFsIFZva8OhxI0=?= <michal.vokac@ysoft.com>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        linux-pm@vger.kernel.org, Shawn Guo <shawnguo@kernel.org>,
        Amit Kucheria <amitk@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?Q?Petr_Bene=c5=a1?= <petr.benes@ysoft.com>,
        stable@vger.kernel.org
References: <20211008081137.1948848-1-michal.vokac@ysoft.com>
 <df545947-2f5b-a355-859d-7f61eab14dcb@linaro.org>
 <CAPwXO5Z0OkmXuy=e6JDjFwqJMqOC4FDjs3uiwdZcJSxy5SPtVw@mail.gmail.com>
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
Message-ID: <fd9096f7-210c-6c06-be08-5c66e2e636ae@linaro.org>
Date:   Mon, 18 Oct 2021 10:43:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CAPwXO5Z0OkmXuy=e6JDjFwqJMqOC4FDjs3uiwdZcJSxy5SPtVw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 18/10/2021 10:36, Petr Benes wrote:
> On Sun, 17 Oct 2021 at 00:23, Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
>>
>> On 08/10/2021 10:11, Michal Vokáč wrote:
>>> From: Petr Beneš <petr.benes@ysoft.com>
>>>
>>> SoC temperature readout may not work after thermal alarm fires interrupt.
>>> This harms userspace as well as CPU cooling device.
>>>
>>> Two issues with the logic involved. First, there is no protection against
>>> concurent measurements, hence one can switch the sensor off while
>>> the other one tries to read temperature later. Second, the interrupt path
>>> usually fails. At the end the sensor is powered off and thermal IRQ is
>>> disabled. One has to reenable the thermal zone by the sysfs interface.
>>>
>>> Most of troubles come from commit d92ed2c9d3ff ("thermal: imx: Use
>>> driver's local data to decide whether to run a measurement")
>>
>> Are these troubles observed and reproduced ? Or is it your understanding
>> from reading the code ?
> 
> Yes, it is observed. We are using:
> CONFIG_CPU_THERMAL=y
> CONFIG_CPU_FREQ_THERMAL=y
> If the SoC temperature oscillates  around the passive trip point, it is not
> possible to read out /sys/class/thermal/thermal_zone0/temp after
> a while (minutes). For reproduction either heat the device up a bit or set
> the passive trip point lower.

Ok, I have an i.MX7 here to resurrect. I'll give a try.


>> get_temp() and tz enable/disable are protected against races in the core
>> code via the tz mutex
> 
> imx_get_temp() itself doesn't handle concurrent invocations properly, despite
> it may seem it does. The sensor is switched on/off without control.
> That is a flaw in imx_get_temp().
> No evidence the core locking is wrong.
> 
> data->irq_enabled is set to false in imx_thermal_alarm_irq() each time
> the interrupt arrives. imx_get_temp() does wrong decision based
> on the value later.
> 
>>
>>> It uses data->irq_enabled as the "local data". Indeed, its value is
>>> related to the state of the sensor loosely under normal operation and,
>>> frankly, gets unleashed when the thermal interrupt arrives.
>>>
>>> Current patch adds the "local data" (new member sensor_on in
>>> imx_thermal_data) and sets its value in controlled manner.>
>>> Fixes: d92ed2c9d3ff ("thermal: imx: Use driver's local data to decide whether to run a measurement")
>>> Cc: petrben@gmail.com
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Petr Beneš <petr.benes@ysoft.com>
>>> Signed-off-by: Michal Vokáč <michal.vokac@ysoft.com>
>>> ---
>>>  drivers/thermal/imx_thermal.c | 30 ++++++++++++++++++++++++++----
>>>  1 file changed, 26 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/thermal/imx_thermal.c b/drivers/thermal/imx_thermal.c
>>> index 2c7473d86a59..df5658e21828 100644
>>> --- a/drivers/thermal/imx_thermal.c
>>> +++ b/drivers/thermal/imx_thermal.c
>>> @@ -209,6 +209,8 @@ struct imx_thermal_data {
>>>       struct clk *thermal_clk;
>>>       const struct thermal_soc_data *socdata;
>>>       const char *temp_grade;
>>> +     struct mutex sensor_lock;
>>> +     bool sensor_on;
>>>  };
>>>
>>>  static void imx_set_panic_temp(struct imx_thermal_data *data,
>>> @@ -252,11 +254,12 @@ static int imx_get_temp(struct thermal_zone_device *tz, int *temp)
>>>       const struct thermal_soc_data *soc_data = data->socdata;
>>>       struct regmap *map = data->tempmon;
>>>       unsigned int n_meas;
>>> -     bool wait, run_measurement;
>>> +     bool wait;
>>>       u32 val;
>>>
>>> -     run_measurement = !data->irq_enabled;
>>> -     if (!run_measurement) {
>>> +     mutex_lock(&data->sensor_lock);
>>> +
>>> +     if (data->sensor_on) {
>>>               /* Check if a measurement is currently in progress */
>>>               regmap_read(map, soc_data->temp_data, &val);
>>>               wait = !(val & soc_data->temp_valid_mask);
>>> @@ -283,13 +286,15 @@ static int imx_get_temp(struct thermal_zone_device *tz, int *temp)
>>>
>>>       regmap_read(map, soc_data->temp_data, &val);
>>>
>>> -     if (run_measurement) {
>>> +     if (!data->sensor_on) {
>>>               regmap_write(map, soc_data->sensor_ctrl + REG_CLR,
>>>                            soc_data->measure_temp_mask);
>>>               regmap_write(map, soc_data->sensor_ctrl + REG_SET,
>>>                            soc_data->power_down_mask);
>>>       }
>>>
>>> +     mutex_unlock(&data->sensor_lock);
>>> +
>>>       if ((val & soc_data->temp_valid_mask) == 0) {
>>>               dev_dbg(&tz->device, "temp measurement never finished\n");
>>>               return -EAGAIN;
>>> @@ -339,20 +344,26 @@ static int imx_change_mode(struct thermal_zone_device *tz,
>>>       const struct thermal_soc_data *soc_data = data->socdata;
>>>
>>>       if (mode == THERMAL_DEVICE_ENABLED) {
>>> +             mutex_lock(&data->sensor_lock);
>>>               regmap_write(map, soc_data->sensor_ctrl + REG_CLR,
>>>                            soc_data->power_down_mask);
>>>               regmap_write(map, soc_data->sensor_ctrl + REG_SET,
>>>                            soc_data->measure_temp_mask);
>>> +             data->sensor_on = true;
>>> +             mutex_unlock(&data->sensor_lock);
>>>
>>>               if (!data->irq_enabled) {
>>>                       data->irq_enabled = true;
>>>                       enable_irq(data->irq);
>>>               }
>>>       } else {
>>> +             mutex_lock(&data->sensor_lock);
>>>               regmap_write(map, soc_data->sensor_ctrl + REG_CLR,
>>>                            soc_data->measure_temp_mask);
>>>               regmap_write(map, soc_data->sensor_ctrl + REG_SET,
>>>                            soc_data->power_down_mask);
>>> +             data->sensor_on = false;
>>> +             mutex_unlock(&data->sensor_lock);
>>>
>>>               if (data->irq_enabled) {
>>>                       disable_irq(data->irq);
>>> @@ -728,6 +739,8 @@ static int imx_thermal_probe(struct platform_device *pdev)
>>>       }
>>>
>>>       /* Make sure sensor is in known good state for measurements */
>>> +     mutex_init(&data->sensor_lock);
>>> +     mutex_lock(&data->sensor_lock);
>>>       regmap_write(map, data->socdata->sensor_ctrl + REG_CLR,
>>>                    data->socdata->power_down_mask);
>>>       regmap_write(map, data->socdata->sensor_ctrl + REG_CLR,
>>> @@ -739,6 +752,8 @@ static int imx_thermal_probe(struct platform_device *pdev)
>>>                       IMX6_MISC0_REFTOP_SELBIASOFF);
>>>       regmap_write(map, data->socdata->sensor_ctrl + REG_SET,
>>>                    data->socdata->power_down_mask);
>>> +     data->sensor_on = false;
>>> +     mutex_unlock(&data->sensor_lock);
>>>
>>>       ret = imx_thermal_register_legacy_cooling(data);
>>>       if (ret)
>>> @@ -796,10 +811,13 @@ static int imx_thermal_probe(struct platform_device *pdev)
>>>       if (data->socdata->version == TEMPMON_IMX6SX)
>>>               imx_set_panic_temp(data, data->temp_critical);
>>>
>>> +     mutex_lock(&data->sensor_lock);
>>>       regmap_write(map, data->socdata->sensor_ctrl + REG_CLR,
>>>                    data->socdata->power_down_mask);
>>>       regmap_write(map, data->socdata->sensor_ctrl + REG_SET,
>>>                    data->socdata->measure_temp_mask);
>>> +     data->sensor_on = true;
>>> +     mutex_unlock(&data->sensor_lock);
>>>
>>>       data->irq_enabled = true;
>>>       ret = thermal_zone_device_enable(data->tz);
>>> @@ -832,8 +850,12 @@ static int imx_thermal_remove(struct platform_device *pdev)
>>>       struct regmap *map = data->tempmon;
>>>
>>>       /* Disable measurements */
>>> +     mutex_lock(&data->sensor_lock);
>>>       regmap_write(map, data->socdata->sensor_ctrl + REG_SET,
>>>                    data->socdata->power_down_mask);
>>> +     data->sensor_on = false;
>>> +     mutex_unlock(&data->sensor_lock);
>>> +
>>>       if (!IS_ERR(data->thermal_clk))
>>>               clk_disable_unprepare(data->thermal_clk);
>>>
>>>
>>
>>
>> --
>> <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs
>>
>> Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
>> <http://twitter.com/#!/linaroorg> Twitter |
>> <http://www.linaro.org/linaro-blog/> Blog


-- 
<http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

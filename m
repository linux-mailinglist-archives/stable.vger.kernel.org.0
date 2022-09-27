Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5E0C5EBD64
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 10:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbiI0Ieg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 04:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231256AbiI0IeF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 04:34:05 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E355B5150
        for <stable@vger.kernel.org>; Tue, 27 Sep 2022 01:34:03 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id t14so13809291wrx.8
        for <stable@vger.kernel.org>; Tue, 27 Sep 2022 01:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=Wblt6hLF9bmZyY1xDVXY8pdC3K0ygNsNvIqaUDgmAkk=;
        b=k5uZMHyyZZmc2Xqpu8euyz3vL78JbusbBDZDc5AcSSNoVW3Yhi4GLppmbrPIQV4jDS
         K1rJ8qnO5OiV2uvl8oIzLv2fhJmZdlT/ef1xU8f6+LNomSj4XdnpJN0hEvQ7uODlwx+g
         n70sLpGzU/p2GGxzt+RczSwYIy4OZ/Zvphtv1DznsTdqZ5Wt6FQBdcPbSCG34yCAoFs6
         hLEpbRrkN2VQXC98z0N+uyk6Iq9doz2CAe3ioOSt7nSpx6fMGiM+XEEE7I+pQxba61pA
         x6NRaj0dyvoF6+peUn+bqEAAsLJHdNA3EzEoml5bGCYpAY1APrJXwU2T4SJiMeDAXm5Z
         /Epw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Wblt6hLF9bmZyY1xDVXY8pdC3K0ygNsNvIqaUDgmAkk=;
        b=o1QWhznlcO8w6gRwVju/UUXTxPzftv+1wlE36n3h2dnkttSH34y7g2JF3zS/HjLd88
         sI+TE4fdupXU2W74YaIsNotuNblamBVNpShSLhYNV1b7UvPEnJwfW2kACTM3/TWjGbm8
         PgIwWliJD6VOOstZQ/eBjEX+Q2k+2GbpxP7tik8ftmO0CMN72+6SNZFTxlI75VfEMtDj
         1oQeSRptpGMOygDQqTmC8rGD2RnmIlO0AZmXXTZn2dLB9/FT1R9oo+kxe2XNsXMh1OYu
         Rc6JcpYbYw0gYk5lhJWBEA7utmc/xPxDz98aRwGf/LFuxXMV/aJJlHA5Lb89yUKeRLwn
         CY/A==
X-Gm-Message-State: ACrzQf05VLNMej99RHRtE0pJ2OVlBkltqaSRnZG/k1D1Qb+tMH13EtdO
        bhvGhgTg688fz/Z3dyu5dScang==
X-Google-Smtp-Source: AMsMyM6RttDAp/0iAh9Rj9RVW67dy+WEPWz+sYwSPYhKnTfO1uSdnEFAlOW1e0GfroFJ2d11LfowhA==
X-Received: by 2002:a5d:61d1:0:b0:22c:c284:a886 with SMTP id q17-20020a5d61d1000000b0022cc284a886mr323562wrv.30.1664267641820;
        Tue, 27 Sep 2022 01:34:01 -0700 (PDT)
Received: from [192.168.10.46] (146725694.box.freepro.com. [130.180.211.218])
        by smtp.googlemail.com with ESMTPSA id t126-20020a1c4684000000b003b505d26776sm13136638wma.5.2022.09.27.01.34.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Sep 2022 01:34:01 -0700 (PDT)
Message-ID: <bf7ab516-3d18-6a5a-95f2-71f918b54cf1@linaro.org>
Date:   Tue, 27 Sep 2022 10:34:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v3 RESEND] thermal: qoriq: Only enable sites that actually
 exist
Content-Language: en-US
To:     Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        "Rafael J. Wysocki" <rafael@kernel.org>, linux-pm@vger.kernel.org
Cc:     Amit Kucheria <amitk@kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        linux-kernel@vger.kernel.org, kernel@puri.sm,
        stable@vger.kernel.org
References: <7115709.31r3eYUQgx@pliszka>
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
In-Reply-To: <7115709.31r3eYUQgx@pliszka>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hi Sebastian,

On 27/09/2022 08:15, Sebastian Krzyszkowiak wrote:
> On i.MX8MQ, enabling monitoring sites that aren't connected to anything
> can cause unwanted side effects on some units. This seems to happen
> once some of these sites report out-of-range readings and results in
> sensor misbehavior, such as thermal zone readings getting stuck or even
> suddenly reporting an impossibly high value, triggering emergency
> shutdowns.
> 
> The datasheet lists all non-existent sites as "reserved" and doesn't
> make any guarantees about being able to enable them at all, so let's
> not do that. Instead, iterate over sensor DT nodes and only enable
> monitoring sites that are specified there prior to registering their
> thermal zones. This still fixes the issue with bogus data being
> reported on the first reading, but doesn't introduce problems that
> come with reading from non-existent sites.

Can you have a look at these patches:

https://git.kernel.org/pub/scm/linux/kernel/git/thermal/linux.git/commit/?h=thermal/linux-next&id=ab2266ecaa3254811f9f83992cf53fdfe3c62c86

and

https://git.kernel.org/pub/scm/linux/kernel/git/thermal/linux.git/commit/?h=thermal/linux-next&id=7be4288625df54887b444991d743c6e1af21e27a

Thanks
   -- Daniel

> Fixes: 45038e03d633 ("thermal: qoriq: Enable all sensors before registering them")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
> ---
> Resent <20220321170852.654094-1-sebastian.krzyszkowiak@puri.sm>
> v3: add cc: stable
> v2: augment the commit message with details on what the patch is doing
> ---
>   drivers/thermal/qoriq_thermal.c | 63 ++++++++++++++++++++++-----------
>   1 file changed, 43 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/thermal/qoriq_thermal.c b/drivers/thermal/qoriq_thermal.c
> index 73049f9bea25..ef0848849ee2 100644
> --- a/drivers/thermal/qoriq_thermal.c
> +++ b/drivers/thermal/qoriq_thermal.c
> @@ -32,7 +32,6 @@
>   #define TMR_DISABLE	0x0
>   #define TMR_ME		0x80000000
>   #define TMR_ALPF	0x0c000000
> -#define TMR_MSITE_ALL	GENMASK(15, 0)
>   
>   #define REGS_TMTMIR	0x008	/* Temperature measurement interval Register */
>   #define TMTMIR_DEFAULT	0x0000000f
> @@ -129,33 +128,51 @@ static const struct thermal_zone_of_device_ops tmu_tz_ops = {
>   static int qoriq_tmu_register_tmu_zone(struct device *dev,
>   				       struct qoriq_tmu_data *qdata)
>   {
> -	int id;
> +	int ret = 0;
> +	struct device_node *np, *child, *sensor_np;
>   
> -	if (qdata->ver == TMU_VER1) {
> -		regmap_write(qdata->regmap, REGS_TMR,
> -			     TMR_MSITE_ALL | TMR_ME | TMR_ALPF);
> -	} else {
> -		regmap_write(qdata->regmap, REGS_V2_TMSR, TMR_MSITE_ALL);
> -		regmap_write(qdata->regmap, REGS_TMR, TMR_ME | TMR_ALPF_V2);
> -	}
> +	np = of_find_node_by_name(NULL, "thermal-zones");
> +	if (!np)
> +		return -ENODEV;
> +
> +	sensor_np = of_node_get(dev->of_node);
>   
> -	for (id = 0; id < SITES_MAX; id++) {
> +	for_each_available_child_of_node(np, child) {
>   		struct thermal_zone_device *tzd;
> -		struct qoriq_sensor *sensor = &qdata->sensor[id];
> -		int ret;
> +		struct qoriq_sensor *sensor;
> +		int id, site;
> +
> +		ret = thermal_zone_of_get_sensor_id(child, sensor_np, &id);
> +
> +		if (ret < 0) {
> +			dev_err(dev, "failed to get valid sensor id: %d\n", ret);
> +			of_node_put(child);
> +			break;
> +		}
>   
> +		sensor = &qdata->sensor[id];
>   		sensor->id = id;
>   
> +		/* Enable monitoring */
> +		if (qdata->ver == TMU_VER1) {
> +			site = 0x1 << (15 - id);
> +			regmap_update_bits(qdata->regmap, REGS_TMR,
> +					   site | TMR_ME | TMR_ALPF,
> +					   site | TMR_ME | TMR_ALPF);
> +		} else {
> +			site = 0x1 << id;
> +			regmap_update_bits(qdata->regmap, REGS_V2_TMSR, site, site);
> +			regmap_write(qdata->regmap, REGS_TMR, TMR_ME | TMR_ALPF_V2);
> +		}
> +
>   		tzd = devm_thermal_zone_of_sensor_register(dev, id,
>   							   sensor,
>   							   &tmu_tz_ops);
> -		ret = PTR_ERR_OR_ZERO(tzd);
> -		if (ret) {
> -			if (ret == -ENODEV)
> -				continue;
> -
> -			regmap_write(qdata->regmap, REGS_TMR, TMR_DISABLE);
> -			return ret;
> +		if (IS_ERR(tzd)) {
> +			ret = PTR_ERR(tzd);
> +			dev_err(dev, "failed to register thermal zone: %d\n", ret);
> +			of_node_put(child);
> +			break;
>   		}
>   
>   		if (devm_thermal_add_hwmon_sysfs(tzd))
> @@ -164,7 +181,13 @@ static int qoriq_tmu_register_tmu_zone(struct device *dev,
>   
>   	}
>   
> -	return 0;
> +	of_node_put(sensor_np);
> +	of_node_put(np);
> +
> +	if (ret)
> +		regmap_write(qdata->regmap, REGS_TMR, TMR_DISABLE);
> +
> +	return ret;
>   }
>   
>   static int qoriq_tmu_calibration(struct device *dev,


-- 
<http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

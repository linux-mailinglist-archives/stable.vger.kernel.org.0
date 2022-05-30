Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94E065384DE
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 17:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239533AbiE3P1X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 11:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241543AbiE3P1A (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 11:27:00 -0400
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 606601DA08F;
        Mon, 30 May 2022 07:29:39 -0700 (PDT)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-e93bbb54f9so14489713fac.12;
        Mon, 30 May 2022 07:29:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Ek1zhecwOf7J3Spdw9zlYjdJXq9BwxbOrVFP+eor5pw=;
        b=QKxobhHKedlsvzz4b6NO450+GC/pVOjg0raSYbvShshZ/7yJlud0RVH3sk5dBP6R20
         KbAvFj5lL42vZoP3B9RU1MehIaADneJeVvcJ3Tyrs4uLbab0UXC+GbLfdWmAuo68p+iB
         i8EcLcdFwuMh1KliSMT4aSIDjjDwczmArj/tILL7ZMuxdIPTSRFphnwpVQxKVF0KQ4Bx
         4niSKF+91xwMBv3IBsh87ZodCBCE0Yv9M2Bvy/QfAY4QjP8nBvgiWv+eGg1HqpGL0IOi
         Cet1Zurlb/5pB80qbbRqGIoohk0/NSRFdedt5+ezVVDyg+6OZxbKBl6k8hNwWpGACWJm
         AlSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Ek1zhecwOf7J3Spdw9zlYjdJXq9BwxbOrVFP+eor5pw=;
        b=PqVUgQMSWWvBWqdLzVJ+H3OJ18ftKxPX8kYtNyEJPNIA54G6mjWmzs1Se4Kfb049lR
         S665EoHV31h8VJvjmviWfnulSpuaS02ElKgeFiLJSR+/mNfXe4mljPyDwhPGF3RwF9u3
         +aoPRXalTjhRVG9KCcus3RlvKWtZ+U4ELpwnQ/M84jgR3zi4SzN112AF9pg3nSwWZSRo
         B/odxTGy7TxBYPiwn1ziOFhn79EhS7FTmxKgvyIYV8oSMabOGJFYjv4WGQGVJzmttJvx
         tSgwvkPqzMfR4fm/5I+pcBh8iCdJptt5B43JI7KRVJrjaW6OnE8W1rXHxC+4LPTrLK9M
         Vqig==
X-Gm-Message-State: AOAM5304MMXtTy2Sq89aZxXpGChL1OSslGZqtyq/DrTrFe8V08JR0fHU
        02K/lu0P9KniLVP/rz9sQ+qSx939cuI=
X-Google-Smtp-Source: ABdhPJzIGdzFTGto01heed5GuCFbm8+gYav3h0YyyJ1hks+MIg/VHui6z+Bkntx1ZrPBZL1emu/i+Q==
X-Received: by 2002:a05:6870:33a9:b0:f2:c44c:d054 with SMTP id w41-20020a05687033a900b000f2c44cd054mr10722530oae.70.1653920977093;
        Mon, 30 May 2022 07:29:37 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q30-20020a056830441e00b0060b6a3a5eefsm3129315otv.36.2022.05.30.07.29.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 May 2022 07:29:36 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <333a76e6-6be6-a885-d0c0-2e6f06a10d66@roeck-us.net>
Date:   Mon, 30 May 2022 07:29:35 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH AUTOSEL 5.10 71/76] hwmon: Make chip parameter for
 with_info API mandatory
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     jdelvare@suse.com, corbet@lwn.net, linux-hwmon@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20220530134406.1934928-1-sashal@kernel.org>
 <20220530134406.1934928-71-sashal@kernel.org>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20220530134406.1934928-71-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/30/22 06:44, Sasha Levin wrote:
> From: Guenter Roeck <linux@roeck-us.net>
> 
> [ Upstream commit ddaefa209c4ac791c1262e97c9b2d0440c8ef1d5 ]
> 
> Various attempts were made recently to "convert" the old
> hwmon_device_register() API to devm_hwmon_device_register_with_info()
> by just changing the function name without actually converting the
> driver. Prevent this from happening by making the 'chip' parameter of
> devm_hwmon_device_register_with_info() mandatory.
> 
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Please drop.

> ---
>   Documentation/hwmon/hwmon-kernel-api.rst |  2 +-
>   drivers/hwmon/hwmon.c                    | 16 +++++++---------
>   2 files changed, 8 insertions(+), 10 deletions(-)
> 
> diff --git a/Documentation/hwmon/hwmon-kernel-api.rst b/Documentation/hwmon/hwmon-kernel-api.rst
> index c41eb6108103..23f27fe78e37 100644
> --- a/Documentation/hwmon/hwmon-kernel-api.rst
> +++ b/Documentation/hwmon/hwmon-kernel-api.rst
> @@ -72,7 +72,7 @@ hwmon_device_register_with_info is the most comprehensive and preferred means
>   to register a hardware monitoring device. It creates the standard sysfs
>   attributes in the hardware monitoring core, letting the driver focus on reading
>   from and writing to the chip instead of having to bother with sysfs attributes.
> -The parent device parameter cannot be NULL with non-NULL chip info. Its
> +The parent device parameter as well as the chip parameter must not be NULL. Its
>   parameters are described in more detail below.
>   
>   devm_hwmon_device_register_with_info is similar to
> diff --git a/drivers/hwmon/hwmon.c b/drivers/hwmon/hwmon.c
> index d649fea82999..2c17407aadb7 100644
> --- a/drivers/hwmon/hwmon.c
> +++ b/drivers/hwmon/hwmon.c
> @@ -818,11 +818,12 @@ EXPORT_SYMBOL_GPL(hwmon_device_register_with_groups);
>   
>   /**
>    * hwmon_device_register_with_info - register w/ hwmon
> - * @dev: the parent device
> - * @name: hwmon name attribute
> - * @drvdata: driver data to attach to created device
> - * @chip: pointer to hwmon chip information
> + * @dev: the parent device (mandatory)
> + * @name: hwmon name attribute (mandatory)
> + * @drvdata: driver data to attach to created device (optional)
> + * @chip: pointer to hwmon chip information (mandatory)
>    * @extra_groups: pointer to list of additional non-standard attribute groups
> + *	(optional)
>    *
>    * hwmon_device_unregister() must be called when the device is no
>    * longer needed.
> @@ -835,13 +836,10 @@ hwmon_device_register_with_info(struct device *dev, const char *name,
>   				const struct hwmon_chip_info *chip,
>   				const struct attribute_group **extra_groups)
>   {
> -	if (!name)
> -		return ERR_PTR(-EINVAL);
> -
> -	if (chip && (!chip->ops || !chip->ops->is_visible || !chip->info))
> +	if (!dev || !name || !chip)
>   		return ERR_PTR(-EINVAL);
>   
> -	if (chip && !dev)
> +	if (!chip->ops || !chip->ops->is_visible || !chip->info)
>   		return ERR_PTR(-EINVAL);
>   
>   	return __hwmon_device_register(dev, name, drvdata, chip, extra_groups);


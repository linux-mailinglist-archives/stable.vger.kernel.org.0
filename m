Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE8E95384E8
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 17:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239384AbiE3P16 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 11:27:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232177AbiE3P1I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 11:27:08 -0400
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29BB61DAE58;
        Mon, 30 May 2022 07:29:53 -0700 (PDT)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-f2cd424b9cso14529191fac.7;
        Mon, 30 May 2022 07:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=iwvW/HUlxK27ANHP+B5t/wvOGVQFTrLuINyXeF8Fnsc=;
        b=SbsEyMSC+Zc2RYMEL3E5M3A2HZZwF18iQH7DN4e1yTpOz82C9lW1G5ka9g8aIxWulU
         lLgyodZaJmoAB7TjoXNJR8XidkP3pdn1pXBLvTwEEcNmlLu1e32M2yOCguFqG80Rmz2k
         XxI4VWdmklZQv6wDzFJ1LWoO1vXr3QTH/ul2dg0NzPW2RCfrur9R9iUAHS1NDbhKFAqI
         NQTo5zSLsZj2VsNSX/v2bnVDcy9FItEMeny4xMa0RA02L9OG6yKusd9zFH4Kmh6WlqdE
         JVTCBknfXFErlK7s+ZXTNulP7x+rRVRA+0t4H0BvzWqGhhhtls9mCx/A1t1VPstBF5Ui
         5qzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=iwvW/HUlxK27ANHP+B5t/wvOGVQFTrLuINyXeF8Fnsc=;
        b=eguQAgVzdB2eS7Wamb+O9t+xJDJJt32RyvNExhiTq93AjrIudiXp6RGw+f/0IifD8i
         76IkaIoyMj86cRyJ2Km50/fpsKsKTaBbzmjT91/daBghtaMefElPRgaaJrcAYxOM12+p
         KXNDqp04S84ROsNAxWvgKZBkq1jwmyS7jqAXCHLiwo4L5blR+1dFju47JLu1bj80JASY
         Cbrw1SqRs0JKdRzTliepzsI0bDzi2r9t+W7flKshmvw3TP3hUhnv7bAW5TsAsAOHK3cO
         Rxiwg0ASFqoLeGiqChjsGzs0fWbIxJ1UxnxKBKAdoPvwdsHuJEZUYEI68nDRDhiVWGJP
         CBGQ==
X-Gm-Message-State: AOAM530fQtIzH0/qyLM5u0uroWkvTrHo1hA3n928OosjS7ekCOAgxDK4
        2KZ8HRuEmPPowvUu0cObUjM=
X-Google-Smtp-Source: ABdhPJzgwljlXzcHj2r8yeRw/yi+GoCSaZiBQTBAwY0m1H36Kn1ELRD5lms3iszOshTrdd8YP9JUhw==
X-Received: by 2002:a05:6870:c8a9:b0:f2:87f0:6707 with SMTP id er41-20020a056870c8a900b000f287f06707mr10512381oab.97.1653920990559;
        Mon, 30 May 2022 07:29:50 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d22-20020a05683025d600b0060603221236sm5105666otu.6.2022.05.30.07.29.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 May 2022 07:29:49 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <612c066d-6bc6-2b9b-5211-6dbfd88a7899@roeck-us.net>
Date:   Mon, 30 May 2022 07:29:47 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH AUTOSEL 5.15 102/109] hwmon: Make chip parameter for
 with_info API mandatory
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     jdelvare@suse.com, corbet@lwn.net, linux-hwmon@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20220530133825.1933431-1-sashal@kernel.org>
 <20220530133825.1933431-102-sashal@kernel.org>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20220530133825.1933431-102-sashal@kernel.org>
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

On 5/30/22 06:38, Sasha Levin wrote:
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
> index 3ae961986fc3..55237a5fc49a 100644
> --- a/drivers/hwmon/hwmon.c
> +++ b/drivers/hwmon/hwmon.c
> @@ -854,11 +854,12 @@ EXPORT_SYMBOL_GPL(hwmon_device_register_with_groups);
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
> @@ -871,13 +872,10 @@ hwmon_device_register_with_info(struct device *dev, const char *name,
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


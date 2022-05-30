Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E83EA5384D1
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 17:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240164AbiE3PZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 11:25:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241878AbiE3PZC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 11:25:02 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3E7C55225;
        Mon, 30 May 2022 07:27:52 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id h188so7683953oia.2;
        Mon, 30 May 2022 07:27:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9wvQDhybWLUOMxPFqDNFSEGeFfgr3pZojJ9yak42Waw=;
        b=JEv/WBkuHQHN8pa452dG/n3IRLZ7lWUGeodl1TW/UZRVETlgjd8rBqttAmvlu9d+XL
         A9Mng09/s9drgJd5LeZKos1WLcbOU6q0R25fXZgd7kWDHW0bNk0wixj2Ub6vFixxG22C
         mpI9sGO842zwlX9bVFvrzjyJE9j9JONw6Ay7VecyZFZitXh7u2MAj/eNKVXhoXMSEwcy
         yFvbltkXGhw8DfzxvDoPg+L8hy3Q/3lrOAVWKzr0CrPcJ1qFIeSOLN+e0xEe0pKvKWuG
         8zjHaVSjBBNkMu0cHq2EVi56nauUA1B3BCdH4YcebZcSOfT+o3LHYiQOpETszpf9Es7X
         3Ybw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9wvQDhybWLUOMxPFqDNFSEGeFfgr3pZojJ9yak42Waw=;
        b=olPP1Oh76clxsbFSXM+lJ/mCy0MJuZpUy+Yjh4SpgEV+fpAfCnqss6IOOrZZgvMOSW
         wjC2k0V+SOOVxZRFEXVoWUT216xvxw1VjUfbjPQUGAZCgKqeBCKS0exTO9VQPoj4v2Zv
         yKlm/feVZF3J0cLviawRinfd7iin85FRZHhzXE0s/8FlafI2kt0O3wK1GaTy9vo4Cc6d
         e1zTZ+U/er2w1FTAK3cGJxUU2osJmZKM1+kT9DRD7AHUxUJprvaR2+ZmInY3PnJTi3fP
         n/CS/I5tkjMamdKVU4CZWi1pdQ+JsyECe2ljn4NRFztrUjmLRCHldMJD9WruA3KwVJUt
         8COw==
X-Gm-Message-State: AOAM533P93n/3yB+wL6FAYe5DPLbJ4pm1hO3difVQZRMYzSR4Ub3NIoG
        yS/PiKScZLTRz3P9+Tj8YM17XmD22PE=
X-Google-Smtp-Source: ABdhPJxwIaS5FV+0qb01fejjuAKFjdN+l1GnG20Xy47Q95h4Jz9FE5cv1glYL6dnurGYWw2Tf5ma3Q==
X-Received: by 2002:a05:6808:d47:b0:32b:8579:8568 with SMTP id w7-20020a0568080d4700b0032b85798568mr9875413oik.7.1653920872166;
        Mon, 30 May 2022 07:27:52 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a11-20020a9d724b000000b0060603221260sm5110728otk.48.2022.05.30.07.27.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 May 2022 07:27:51 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <dddc2b53-62eb-fda7-4425-afdd179a7037@roeck-us.net>
Date:   Mon, 30 May 2022 07:27:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH AUTOSEL 5.17 128/135] hwmon: Make chip parameter for
 with_info API mandatory
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     jdelvare@suse.com, corbet@lwn.net, linux-hwmon@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20220530133133.1931716-1-sashal@kernel.org>
 <20220530133133.1931716-128-sashal@kernel.org>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20220530133133.1931716-128-sashal@kernel.org>
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

On 5/30/22 06:31, Sasha Levin wrote:
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

This patch should not be backported. It is only relevant for new
kernel releases, and may have adverse affect if applied to older
kernels.

Guenter

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


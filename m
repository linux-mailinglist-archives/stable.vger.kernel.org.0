Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A9415384F2
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 17:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236530AbiE3PbQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 11:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240922AbiE3P0k (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 11:26:40 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FDB71D870C;
        Mon, 30 May 2022 07:29:20 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id h9-20020a056830400900b0060b03bfe792so7752182ots.12;
        Mon, 30 May 2022 07:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6SRs6BADyrsPSpT6/zp75/O1zXuT6qo/GVIivSdlPrk=;
        b=HC1pdH4T3wmwccr0NaLhryGOq2t3yr0Prb7zlh5qycWi1XrAJ/DzMOuHYkwKtjjzS1
         PnGf65umOlfcYq9KxHdTEnplYc4VWf36xXgKLFYLQNQyv++3eRRbfzGhxtqzqgD+2Fll
         aNvmtDrFh5YAsaJ0m9gbpSiCTZCTVR2/GBbGNBOoViNitHgDpstNF77/YWwjRckgbosg
         r6aSuzgCRd+djVxzWbr6b1B2wLIhLouHXzjIH5Zs9D8LZBbgkpkFh7HYBOdDXHkwoYWc
         GD3DioaBfuOb1SaiEnuNtQv/27SYVvp1hiwvQ/I1xf3WsouQFJys14Nd/M9egUUfAhVW
         IppA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6SRs6BADyrsPSpT6/zp75/O1zXuT6qo/GVIivSdlPrk=;
        b=HgaHC6SpPvNvv0TPvHCimfFldS45icXkidEbt9kotPCnTc7PQ2iX+cd1dR6psf2Fbk
         9JpRbF+LjVLz/5ksnSF5gXPT9OXEOe75Hevtxt8Lm+NUmmi016OR/tKMg6/Y7hFqYBeb
         XIDWtolhu7YFqH6ZdNQK2JZcNAi024dNZnTWNDKxHZ8hHnMrxa2zPplgJr4flsFzN9nt
         WIJxMZEiZtBnGmup5sQClurqhHTe2D6gD+HxVxIAT6romYxDmlbrqV4kDntuX5a71Dkr
         zylgQ9jLTXf1InAkSNFE7wrAxyFnJ0m1ljU/OXq8cc3sk3dlzuBbGEHJDDmEUY3UNlZE
         oZMg==
X-Gm-Message-State: AOAM531ltvTLrKAeMDw8SMgBi2t5NoA8k1gX5sNeydH44xdcjOGqpp5N
        e3447yMXQycueJCu3huwXSCdwpHenpw=
X-Google-Smtp-Source: ABdhPJzNQW57aCQ9vm4kBdmiJZM6Jwr8g61/hPF9I2F5N4DPTRB3ZZy5swfMxF0tVMVbs9+Sr/rm9A==
X-Received: by 2002:a9d:410e:0:b0:60b:875:7ec3 with SMTP id o14-20020a9d410e000000b0060b08757ec3mr16528218ote.181.1653920957825;
        Mon, 30 May 2022 07:29:17 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id lx6-20020a0568704b8600b000f3347daaa6sm1240868oab.9.2022.05.30.07.29.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 May 2022 07:29:17 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <c162e89e-5c1a-af11-c98b-205f57adac51@roeck-us.net>
Date:   Mon, 30 May 2022 07:29:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH AUTOSEL 5.4 52/55] hwmon: Make chip parameter for
 with_info API mandatory
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     jdelvare@suse.com, corbet@lwn.net, linux-hwmon@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20220530134701.1935933-1-sashal@kernel.org>
 <20220530134701.1935933-52-sashal@kernel.org>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20220530134701.1935933-52-sashal@kernel.org>
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

On 5/30/22 06:46, Sasha Levin wrote:
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
> index a2175394cd25..c73b93b9bb87 100644
> --- a/drivers/hwmon/hwmon.c
> +++ b/drivers/hwmon/hwmon.c
> @@ -715,11 +715,12 @@ EXPORT_SYMBOL_GPL(hwmon_device_register_with_groups);
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
> @@ -732,13 +733,10 @@ hwmon_device_register_with_info(struct device *dev, const char *name,
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


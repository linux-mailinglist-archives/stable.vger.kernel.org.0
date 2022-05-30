Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E92EA5384E3
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 17:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240188AbiE3P1i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 11:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238904AbiE3P10 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 11:27:26 -0400
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B514E113B7D;
        Mon, 30 May 2022 07:30:08 -0700 (PDT)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-f2cbceefb8so14506633fac.11;
        Mon, 30 May 2022 07:30:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=d7xW7gHOA/Y7RTTX4uM7hk1m15c3AIRNklX4XQ0oC4U=;
        b=OT4+PeUEJve3QGWc9WPtczXM4nxLHQsyR4uwKvRvvseWwxDhDJGxq9WEzb/G9LRVIQ
         pejIatrMU64IqrP2nC9sTOLLPIuxDUrOSKa+9mRa9SUK1kV72Av5TQ9Xfx0yw4+PaTLj
         /9/Gc2NpZIhW0aPJoAibqogyJNXne+7BTRNz7Haot9RCUPXOzrY+X6BrziO7bATBPJwX
         kPr2MWrWla/O4Fo2ltaKdq0IPRcnjd3usIGtzs6hApyF9euAJnkcXCu+5CeiQBEgFwBl
         LFX/d2ZRWMSaUzaXHmDJIzF22t76kU1g2IjgeFfKs44eSqsF1oAl8BEAFFb86S3WwnYa
         yQvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=d7xW7gHOA/Y7RTTX4uM7hk1m15c3AIRNklX4XQ0oC4U=;
        b=t4gaTmsjZfRuQ38YOUhHXlHq1si3GjJx4UaxS3JgzmM/PyOFFq0k9HxvPZv5NXDNd9
         nD/I/zUrA+5s5j8dQi8d9apZ6WEAFJM0EhIG1pQYaSWJzeigz8xruTTEC+KNEOe/4NPf
         KexPifLoQmn2Bh5MT4u3YIaIj6WrLjtAJuB/kZgzMXlaIHmLILK3G7iwF67QmFPfl9b0
         zJs+FkQy3dBBqjgWsLP75nbLfqFanbY1cPbH1VQOa05DlaaGHsDqqe+wA7mpD4brOM/k
         a1OH94lUgdlW0Z26PfTfiVZphyPDMV76FnL/yil4xK4pyM88YxK2ETwNZFHjwEQJHn4R
         xXhw==
X-Gm-Message-State: AOAM532DzcvsHfeQtMbCoCn51uJ1M08i5JBvIIOoLuzNaq/V1xPmMRv/
        Jw10ee1OGwfYtdOJwPrhd3E=
X-Google-Smtp-Source: ABdhPJxqgg/hLCoWMSbiN8n6CeKDRA9RCRTXUiZTobg7fQPkuq8MKFzwPVOQMsuIR6NT3y94lrsmGQ==
X-Received: by 2002:a05:6870:5b8e:b0:f2:33ed:7bf2 with SMTP id em14-20020a0568705b8e00b000f233ed7bf2mr10281502oab.15.1653921006557;
        Mon, 30 May 2022 07:30:06 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y26-20020a9d461a000000b0060603221255sm5089194ote.37.2022.05.30.07.30.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 May 2022 07:30:05 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <4be7c74e-e54a-c284-adef-7a0f1f8d21bb@roeck-us.net>
Date:   Mon, 30 May 2022 07:30:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH AUTOSEL 5.18 151/159] hwmon: Make chip parameter for
 with_info API mandatory
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     jdelvare@suse.com, corbet@lwn.net, linux-hwmon@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20220530132425.1929512-1-sashal@kernel.org>
 <20220530132425.1929512-151-sashal@kernel.org>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20220530132425.1929512-151-sashal@kernel.org>
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

On 5/30/22 06:24, Sasha Levin wrote:
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
> index 989e2c8496dd..187212988b6c 100644
> --- a/drivers/hwmon/hwmon.c
> +++ b/drivers/hwmon/hwmon.c
> @@ -886,11 +886,12 @@ EXPORT_SYMBOL_GPL(hwmon_device_register_with_groups);
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
> @@ -903,13 +904,10 @@ hwmon_device_register_with_info(struct device *dev, const char *name,
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


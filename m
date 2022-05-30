Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3405E5384D6
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 17:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238862AbiE3P0h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 11:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237351AbiE3P0W (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 11:26:22 -0400
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D79971D6874;
        Mon, 30 May 2022 07:29:04 -0700 (PDT)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-f3381207a5so3277098fac.4;
        Mon, 30 May 2022 07:29:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2lSFMu8AJJfPdS/W3hc2k3KRIjU8ajJuQgUb4Pw7x3c=;
        b=jfCfOBiLP2/kdAxxXz19geBf1/+HDXTbktRFPNXRpM9VC1++dGWSaCPy+tlNqLB749
         t8+8xQW8zWsBCAeu2gWLJdrWgHHi5fK0bxs8LvBaDnez87dP182GMlMxt/5meXkmkDR1
         yvp4UzCcXsQoa6oefVlGml6/a7JWH7M1EajTARfLs4hb8Wx5oGbd0pk/ZrxcLkUvCSIU
         3aWsZw245xNQayCszTzb/A68QFWgPqQDlxMJadkG8n26qt6cIDxmidWhHH+nxWwNQHFh
         20tGJ9y8v422Xqr6M5/Y8f3YAJtN9Xp75PfznlnCD086dzDLM9IhpP9JMwrILGWZF8hY
         qvhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2lSFMu8AJJfPdS/W3hc2k3KRIjU8ajJuQgUb4Pw7x3c=;
        b=pEJ7PZ1nfcc2o+xatGC3X14+mNmKDXr1VS6F+p91d6bLWSvET+TJqlnla0JLNZmC/+
         02inmluTGFatOQXcV+RMfPxVMErzY8cgXvzmYcCxjd/iRFCWMsqSg4vBTSgmwvkOOa8T
         CC2cq8MrTbmT0SNW9Nkxc4iuNRacwQsX+lAhhgvetZPmw894pO8F/8CguPQWmXdc54j+
         S8qUehOXAgXNcMKnE6/E/Z3x6p0QCMprINMuR3jRbv7mdzxxnyQYz4tA13mCy0IjV5Uw
         rPSveYooaO8S/SFL5On/cUbB3NxXzT9MQjb2Qxr++g8ni16UDTmAf0vDeFGFQxmdYaTc
         R3Aw==
X-Gm-Message-State: AOAM5310cmEWJWYoellZrn0OdxfST5APR/REjmMSklAbp0yGOIFSBWOH
        TDsXYjJAnGYRWQUlc4OmY2XaCxB3bR0=
X-Google-Smtp-Source: ABdhPJyd9gRPscqAGiRz33kt/0FE05apM8fmY2p6n2/+2zu3Ubrq6ca8+bLG4dRT3CTyxzXG40Y5Eg==
X-Received: by 2002:a05:6870:a11c:b0:f2:cd6e:6555 with SMTP id m28-20020a056870a11c00b000f2cd6e6555mr10237914oae.71.1653920943151;
        Mon, 30 May 2022 07:29:03 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b1-20020a9d7541000000b006061debeed4sm4928024otl.69.2022.05.30.07.29.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 May 2022 07:29:02 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <aa75985e-ad75-4c71-40d8-e7d23c686f58@roeck-us.net>
Date:   Mon, 30 May 2022 07:29:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH AUTOSEL 4.19 36/38] hwmon: Make chip parameter for
 with_info API mandatory
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     jdelvare@suse.com, corbet@lwn.net, linux-hwmon@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20220530134924.1936816-1-sashal@kernel.org>
 <20220530134924.1936816-36-sashal@kernel.org>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20220530134924.1936816-36-sashal@kernel.org>
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

On 5/30/22 06:49, Sasha Levin wrote:
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

Guenter

> ---
>   Documentation/hwmon/hwmon-kernel-api.txt |  2 +-
>   drivers/hwmon/hwmon.c                    | 16 +++++++---------
>   2 files changed, 8 insertions(+), 10 deletions(-)
> 
> diff --git a/Documentation/hwmon/hwmon-kernel-api.txt b/Documentation/hwmon/hwmon-kernel-api.txt
> index eb7a78aebb38..4981df157b04 100644
> --- a/Documentation/hwmon/hwmon-kernel-api.txt
> +++ b/Documentation/hwmon/hwmon-kernel-api.txt
> @@ -71,7 +71,7 @@ hwmon_device_register_with_info is the most comprehensive and preferred means
>   to register a hardware monitoring device. It creates the standard sysfs
>   attributes in the hardware monitoring core, letting the driver focus on reading
>   from and writing to the chip instead of having to bother with sysfs attributes.
> -The parent device parameter cannot be NULL with non-NULL chip info. Its
> +The parent device parameter as well as the chip parameter must not be NULL. Its
>   parameters are described in more detail below.
>   
>   devm_hwmon_device_register_with_info is similar to
> diff --git a/drivers/hwmon/hwmon.c b/drivers/hwmon/hwmon.c
> index c4051a3e63c2..fb82d8ee0dd6 100644
> --- a/drivers/hwmon/hwmon.c
> +++ b/drivers/hwmon/hwmon.c
> @@ -695,11 +695,12 @@ EXPORT_SYMBOL_GPL(hwmon_device_register_with_groups);
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
> @@ -712,13 +713,10 @@ hwmon_device_register_with_info(struct device *dev, const char *name,
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


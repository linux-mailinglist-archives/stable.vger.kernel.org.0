Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27540560D05
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 01:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbiF2XPq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 19:15:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiF2XPn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 19:15:43 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 612052018F;
        Wed, 29 Jun 2022 16:15:42 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id 128so16427979pfv.12;
        Wed, 29 Jun 2022 16:15:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jVotzPpytA8mFUbLq0btjJ8pR9eOolx6C7Tp6rdwLQ4=;
        b=eUvUoQ/sEyPdN2seynm4Rsh9zhG7yyKWM/KREv+BgTlN0goc7pZ3I8DRPHpcaXw9Dh
         wNM1YzdKZC7lGe8yXMPMVdzCS5VYmVA2ffp6YyuJsCi2xyqcmNJVwEdL+ubUu50tVBHy
         LaVnIJBI/61IVoQ72FwSPzKdSgiqddB55ol2oX1Jjn3akAonD+i8ifVJdyKlXkiAwamP
         Otv1HXN31xqjbnyRpDXqKhh8+EkDtSm4AXHgG04eqa5wXGZDxw4Jgw5/aYRFKEuQWGAa
         PbCaCvSmajL/WhP46LDVLjoFI82+2m8TOv2ViX+whNjdEmPgm9bsgLok0ut0ZaFBS1vB
         CyxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jVotzPpytA8mFUbLq0btjJ8pR9eOolx6C7Tp6rdwLQ4=;
        b=EFZO+KWmWEXkQdI5XyBmla+S0CeTNzA3bOmzDQr9ij8hW+ZBdzXlEunsUJiTWZNpzc
         dKZj59pjF/KWejySUXYKRpq2R85nbHgsFUzygSL1pV0VsaZTgCoC7g2fwuqJ3IyNkAVv
         MSgnxQLNvsg9KGqzm7p21zkGo8q/3gFUFqI4/BrY0YKPSluWj71J8sjroyxGA6u46bjD
         AK99ibrZMl2+4HQ2Da6Cwjp+vKys+fUqlFVyb0zEZPzDt62OpToHYenuNLI1gkdQ/xoI
         fupYlB1SuUn6FK2ijy6qraWazDuP5W61eOLLEMYWT5gbziKFKpYpZ4RBctgaIRXjmhtV
         Xlyg==
X-Gm-Message-State: AJIora8FPngwI3BYmGlVY3ZSpoJZm1mZxvG7E6JlCQDECaoAhGxxmooG
        mWDfReILMV9MfqT7Gsvlgd4=
X-Google-Smtp-Source: AGRyM1sBdAFjyOiQCPHkiIXF9rOdtSEiGuZBBTzNgwUK16indtQ1Dd6aKt+jyEA5TWsEFgovGo29Gw==
X-Received: by 2002:a63:6d8b:0:b0:40d:a35:13ed with SMTP id i133-20020a636d8b000000b0040d0a3513edmr5030000pgc.615.1656544541837;
        Wed, 29 Jun 2022 16:15:41 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w185-20020a6262c2000000b0052523f7050bsm12049363pfb.118.2022.06.29.16.15.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jun 2022 16:15:40 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <d4a85598-af50-541a-9632-8d0343e8082d@roeck-us.net>
Date:   Wed, 29 Jun 2022 16:15:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 4.19 v1 1/2] hwmon: Introduce
 hwmon_device_register_for_thermal
Content-Language: en-US
To:     Will McVicker <willmcvicker@google.com>, stable@vger.kernel.org,
        Jean Delvare <jdelvare@suse.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc:     kernel-team@android.com, linux-hwmon@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        "Rafael J . Wysocki" <rafael@kernel.org>
References: <20220629225843.332453-1-willmcvicker@google.com>
 <20220629225843.332453-2-willmcvicker@google.com>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20220629225843.332453-2-willmcvicker@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/29/22 15:58, Will McVicker wrote:
> From: Guenter Roeck <linux@roeck-us.net>
> 
> [ upstream commit e5d21072054fbadf41cd56062a3a14e447e8c22b ]
> 
> The thermal subsystem registers a hwmon driver without providing
> chip or sysfs group information. This is for legacy reasons and
> would be difficult to change. At the same time, we want to enforce
> that chip information is provided when registering a hwmon device
> using hwmon_device_register_with_info(). To enable this, introduce
> a special API for use only by the thermal subsystem.
> 
> Acked-by: Rafael J . Wysocki <rafael@kernel.org>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

NACK. The patch introducing the problem needs to be reverted.

Guenter

> ---
>   drivers/hwmon/hwmon.c | 25 +++++++++++++++++++++++++
>   include/linux/hwmon.h |  3 +++
>   2 files changed, 28 insertions(+)
> 
> diff --git a/drivers/hwmon/hwmon.c b/drivers/hwmon/hwmon.c
> index c4051a3e63c2..412a5e39fc14 100644
> --- a/drivers/hwmon/hwmon.c
> +++ b/drivers/hwmon/hwmon.c
> @@ -725,6 +725,31 @@ hwmon_device_register_with_info(struct device *dev, const char *name,
>   }
>   EXPORT_SYMBOL_GPL(hwmon_device_register_with_info);
>   
> +/**
> + * hwmon_device_register_for_thermal - register hwmon device for thermal subsystem
> + * @dev: the parent device
> + * @name: hwmon name attribute
> + * @drvdata: driver data to attach to created device
> + *
> + * The use of this function is restricted. It is provided for legacy reasons
> + * and must only be called from the thermal subsystem.
> + *
> + * hwmon_device_unregister() must be called when the device is no
> + * longer needed.
> + *
> + * Returns the pointer to the new device.
> + */
> +struct device *
> +hwmon_device_register_for_thermal(struct device *dev, const char *name,
> +				  void *drvdata)
> +{
> +	if (!name || !dev)
> +		return ERR_PTR(-EINVAL);
> +
> +	return __hwmon_device_register(dev, name, drvdata, NULL, NULL);
> +}
> +EXPORT_SYMBOL_GPL(hwmon_device_register_for_thermal);
> +
>   /**
>    * hwmon_device_register - register w/ hwmon
>    * @dev: the device to register
> diff --git a/include/linux/hwmon.h b/include/linux/hwmon.h
> index 8fde789f2eff..5ff3db6eb9f1 100644
> --- a/include/linux/hwmon.h
> +++ b/include/linux/hwmon.h
> @@ -390,6 +390,9 @@ hwmon_device_register_with_info(struct device *dev,
>   				const struct hwmon_chip_info *info,
>   				const struct attribute_group **extra_groups);
>   struct device *
> +hwmon_device_register_for_thermal(struct device *dev, const char *name,
> +				  void *drvdata);
> +struct device *
>   devm_hwmon_device_register_with_info(struct device *dev,
>   				const char *name, void *drvdata,
>   				const struct hwmon_chip_info *info,


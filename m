Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9200D560D0E
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 01:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231299AbiF2XQG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 19:16:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231368AbiF2XQE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 19:16:04 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 830B1205ED;
        Wed, 29 Jun 2022 16:16:03 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 9so16742689pgd.7;
        Wed, 29 Jun 2022 16:16:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SQnYFQjwJYIEl+xmVMG7GmVkiL0GKXz8sy8vI6h9xQc=;
        b=YDPaDYorwDjwK+0Q/6znQtITXkqfOtztjKmoi9lNknBahqketSXhJZDq6D/N7cp8yd
         0aSTc0kt+hMY8m9ZJDOve6twZwKixSM3+7Zc+3ZZMbeoaOb3XcYpfOzxubgPEI0FlFXR
         8OsCqzm+MgGqyuEw9OW/xn2kkdbiMzbhTCnBrxPpfkpmV0BYUDnil0+duqdNikk2blFy
         ILaIX5r6GSmhew+h4mGomqoS/MlGl8S8VDiwcgUYeStYnnvxH6wZtCtwW8WV8vdbMQH5
         l9guUUGOxtKSAnpqW3XHVNuPhlMpmePJhjX3kzzWC6LdsVO6gU15gjpvzTu8Nd2Iv1y8
         a9fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SQnYFQjwJYIEl+xmVMG7GmVkiL0GKXz8sy8vI6h9xQc=;
        b=BjagAlAAaXekmtQRqkxWLf2gj9eVQ71+tvvxm5+dr/5VnFcYdsFzeuGYq8RI/KyN2M
         Qgc++rODSSZiv3rjbAWcUV5O5TUYAKOSJ9JLpiyOlujcR98gqTevoISNGCZm7jShLhMC
         PB5s6kfcNA2ufaA3kt/IgP10Aivls5k47r1MFcv4TDo/YuO9f6rmVH3NYZvB+JxW+IdX
         OMqEwLj0FhshUBb0QlrAOBC7mrWP1MHmwsv+ybqSS/vdy9ldSSt0445NYm42IEy69OZt
         64tc+kaQPOxVZ2CuMgIGPXzOpWGdEBveL9kaNSbSw4CrHOVm43mHRmkZvBdO6ZrGLk98
         B9Aw==
X-Gm-Message-State: AJIora+ctPAnejXSZKWh3XhgTqKd2bYhd8b1s+1+hU5CFQHBfLMW1Hc+
        naj44PwCeAeMGnfYHfcwV0E=
X-Google-Smtp-Source: AGRyM1ueImHrcmSExyeyqq2h9H/NNcRlLErU/YQNxbCWQQ6QahsDQrX0zPVsPNDM5Ueg+lOaZem4aA==
X-Received: by 2002:a63:1a0f:0:b0:3fe:4da7:1a38 with SMTP id a15-20020a631a0f000000b003fe4da71a38mr4931274pga.332.1656544562657;
        Wed, 29 Jun 2022 16:16:02 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t4-20020a17090340c400b001616723b8ddsm11858838pld.45.2022.06.29.16.16.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jun 2022 16:16:01 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <7d4c685f-c791-071b-7677-b4fd2d0cf119@roeck-us.net>
Date:   Wed, 29 Jun 2022 16:16:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 4.19 v1 2/2] thermal/drivers/thermal_hwmon: Use
 hwmon_device_register_for_thermal()
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
 <20220629225843.332453-3-willmcvicker@google.com>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20220629225843.332453-3-willmcvicker@google.com>
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
> [ upstream commit 87743bcf08072b3e1952a0bf5524b2833e667b4c ]
> 
> The thermal subsystem registers a hwmon device without providing chip
> information or sysfs attribute groups. While undesirable, it would be
> difficult to change. On the other side, it abuses the
> hwmon_device_register_with_info API by not providing that information.
> Use new API specifically created for the thermal subsystem instead to
> let us enforce the 'chip' parameter for other callers of
> hwmon_device_register_with_info().
> 
> Acked-by: Rafael J . Wysocki <rafael@kernel.org>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

NACK. Same reason as 1/2.

Guenter

> ---
>   drivers/thermal/thermal_hwmon.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/thermal/thermal_hwmon.c b/drivers/thermal/thermal_hwmon.c
> index dd5d8ee37928..b3b229421936 100644
> --- a/drivers/thermal/thermal_hwmon.c
> +++ b/drivers/thermal/thermal_hwmon.c
> @@ -147,8 +147,8 @@ int thermal_add_hwmon_sysfs(struct thermal_zone_device *tz)
>   	INIT_LIST_HEAD(&hwmon->tz_list);
>   	strlcpy(hwmon->type, tz->type, THERMAL_NAME_LENGTH);
>   	strreplace(hwmon->type, '-', '_');
> -	hwmon->device = hwmon_device_register_with_info(&tz->device, hwmon->type,
> -							hwmon, NULL, NULL);
> +	hwmon->device = hwmon_device_register_for_thermal(&tz->device,
> +							  hwmon->type, hwmon);
>   	if (IS_ERR(hwmon->device)) {
>   		result = PTR_ERR(hwmon->device);
>   		goto free_mem;


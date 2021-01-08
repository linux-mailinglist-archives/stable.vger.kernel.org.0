Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02DCE2EED61
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 07:18:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725869AbhAHGR4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jan 2021 01:17:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725308AbhAHGR4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jan 2021 01:17:56 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31C2FC0612F5;
        Thu,  7 Jan 2021 22:17:16 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id q25so8729569otn.10;
        Thu, 07 Jan 2021 22:17:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6GtY05zckC6inb8HBnvZbuHdivtA7WltyD46dC10wMk=;
        b=ouYHYqmT8GVfRVDrhK3uDRCVjfopAViCTlj3rbk3C7vhg2DYNl06VecinCTp4Kj+If
         Rhw93knor3YlrB/Cc6C9NFl3t5++4VXOcPfBw/RpiscGlLX8UzvXszi/e0GU78naYmCt
         SkGusCsMyQ+mEdUcuttz5q/JathQibzYE6Sgwhj4oKJqloxlGfG/erE/WINFYiFL8Wq+
         C5IJ7ibKGElSc+JJ/YfhyYt2HMSqqQtGlKz3Q344CPSuZ5YQJ3YzboNuB/Kr1Mi0D+o1
         LKgTEzFS9LbAdLRaP8+vByoMg4dSikWZDlcItIpzYpKhjBOAcdG1kM8xrAGl9cQa8NUV
         SWDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=6GtY05zckC6inb8HBnvZbuHdivtA7WltyD46dC10wMk=;
        b=afka5JKrFmXbYPMxuC9aKV5ZK4vnvx38d8apeoJelRW8yx1sbwbn26gSEw/TcvDdC5
         HIar8DhFrvIlfHs4OISlAiquhlJM6M7KD/cVKippOqzCQMEBrbcLQLKq+jSK+y01ZfY4
         vMasy/pHnyAciMQWzV8rpMFyr0yeK5u6WB1sTj1+KfKR5lItT3yGk+/zPgloCfZNrIDf
         S18Res7wG4mmkJBZIHmpkE4bw2B8Jf+e8LUOPPFKBL0RswgPwBV0a/jsYk1D7ibatPEB
         rmYnwA2e6tlP6F5ykMEz6qnRUGyz+GXzpTmWsqhq4R1VrWGVIOxmlK9COBWXHKpjlLNR
         6S+A==
X-Gm-Message-State: AOAM5324PZMxgY6lMFfEfSBVmH695yxg1VTB5aEpJ3faNvQvTFahFq4R
        yP7sB3o+LwH0nnB3kf7Imxm9THhBF6U=
X-Google-Smtp-Source: ABdhPJxIeU6SNfTsVXeSwJWEYCpM44MV8Qq7CIwT251r3YsPOYTCavd1htceU8c8JOtu6RmNgQSNtA==
X-Received: by 2002:a9d:7745:: with SMTP id t5mr1617862otl.104.1610086635294;
        Thu, 07 Jan 2021 22:17:15 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z14sm1601673otk.70.2021.01.07.22.17.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Jan 2021 22:17:14 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH] hwmon: (amd_energy) fix allocation of hwmon_channel_info
 config
To:     "Chatradhi, Naveen Krishna" <NaveenKrishna.Chatradhi@amd.com>,
        David Arcari <darcari@redhat.com>,
        "linux-hwmon@vger.kernel.org" <linux-hwmon@vger.kernel.org>
Cc:     Jean Delvare <jdelvare@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20210107144707.6927-1-darcari@redhat.com>
 <DM6PR12MB4388220A9F55F5DDC984B91FE8AE0@DM6PR12MB4388.namprd12.prod.outlook.com>
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <aac56718-c757-6bfd-7932-b18cf7d4254d@roeck-us.net>
Date:   Thu, 7 Jan 2021 22:17:12 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <DM6PR12MB4388220A9F55F5DDC984B91FE8AE0@DM6PR12MB4388.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/7/21 9:49 PM, Chatradhi, Naveen Krishna wrote:
> [AMD Official Use Only - Approved for External Use]
> 
> Hi David,
> 
> Thank you for noticing and submitting a fix. You may use
> Signed-off-by: Naveen Krishna Chatradhi <nchatrad@amd.com>
> 

No, because you are not in the approval path (you did not send the patch
to me). Reviewed-by: or Acked-by: would be more appropriate.

Genter

> Regards,
> Naveenk
> 
> -----Original Message-----
> From: David Arcari <darcari@redhat.com> 
> Sent: Thursday, January 7, 2021 8:17 PM
> To: linux-hwmon@vger.kernel.org
> Cc: David Arcari <darcari@redhat.com>; Chatradhi, Naveen Krishna <NaveenKrishna.Chatradhi@amd.com>; Jean Delvare <jdelvare@suse.com>; Guenter Roeck <linux@roeck-us.net>; linux-kernel@vger.kernel.org; stable@vger.kernel.org
> Subject: [PATCH] hwmon: (amd_energy) fix allocation of hwmon_channel_info config
> 
> [CAUTION: External Email]
> 
> hwmon, specifically hwmon_num_channel_attrs, expects the config array in the hwmon_channel_info structure to be terminated by a zero entry.  amd_energy does not honor this convention.  As result, a KASAN warning is possible.  Fix this by adding an additional entry and setting it to zero.
> 
> Fixes: 8abee9566b7e ("hwmon: Add amd_energy driver to report energy counters")
> 
> Signed-off-by: David Arcari <darcari@redhat.com>
> Cc: Naveen Krishna Chatradhi <nchatrad@amd.com>
> [naveenk:] Signed-off-by: Naveen Krishna Chatradhi <nchatrad@amd.com>
> Cc: Jean Delvare <jdelvare@suse.com>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: linux-kernel@vger.kernel.org
> Cc: stable@vger.kernel.org
> ---
>  drivers/hwmon/amd_energy.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/hwmon/amd_energy.c b/drivers/hwmon/amd_energy.c index 9b306448b7a0..822c2e74b98d 100644
> --- a/drivers/hwmon/amd_energy.c
> +++ b/drivers/hwmon/amd_energy.c
> @@ -222,7 +222,7 @@ static int amd_create_sensor(struct device *dev,
>          */
>         cpus = num_present_cpus() / num_siblings;
> 
> -       s_config = devm_kcalloc(dev, cpus + sockets,
> +       s_config = devm_kcalloc(dev, cpus + sockets + 1,
>                                 sizeof(u32), GFP_KERNEL);
>         if (!s_config)
>                 return -ENOMEM;
> @@ -254,6 +254,7 @@ static int amd_create_sensor(struct device *dev,
>                         scnprintf(label_l[i], 10, "Esocket%u", (i - cpus));
>         }
> 
> +       s_config[i] = 0;
>         return 0;
>  }
> 
> --
> 2.18.1
> 


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A482274D08
	for <lists+stable@lfdr.de>; Wed, 23 Sep 2020 01:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgIVXDS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 19:03:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbgIVXDS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Sep 2020 19:03:18 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85FE0C0613D0
        for <stable@vger.kernel.org>; Tue, 22 Sep 2020 16:03:18 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id u126so22867999oif.13
        for <stable@vger.kernel.org>; Tue, 22 Sep 2020 16:03:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=j7SkZDfC2KmUJU0iZY35f0jqKt3MsVACF2CocO4OH+Y=;
        b=LG0cqv5G917FUuXaPKLLH3lMM9K2B21Io9jX7P0YwznHNftVVt+DNwADL+kWrCHqTt
         y730Lsdc8UNPGy1Ra65kxTonNEeQli51B3RJmmnkY1h7Gx+7RmhWgCI4VcALp3YBJC7W
         1XMSJDcrGiGD1TrJHVo/ogSdC4qp4oBeocPIQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j7SkZDfC2KmUJU0iZY35f0jqKt3MsVACF2CocO4OH+Y=;
        b=ggcAvBNgkeyhWfyy5bJfOVhrw4aR77ZEbWwa6NtAyyWX6dibxlMKOoucjWl0uwn+OG
         +tC3Dr+0WYdgEB7f3WaYFE4kbfDHfRgNqdd4J4TUX8STltp6sZLkE8bMVEtvhPkJA7dF
         cuKX1EKqXWJCAAeyKPrYvgvcsUU+IVUfHhK21GusT8HosObgNZwroCsFBq3pmRqZX3FO
         bX0WRBnSVkR6eeTFx3TXZ/dAeR3RO7mKhrYwiRFQGpIWKM505+9+wW6faSLFLfyBWyW2
         63z+O4FBViEssFAVUw4EZGmvpP1/pdFfCYAnCUdaN826ZOLAeurTXTRAAEazNfbhVBYD
         /qBQ==
X-Gm-Message-State: AOAM531b/EswI7WOiVGYmAvBgVLE9tH6Iobmq+JzMbJJSOzh1rn6AJuy
        EdbKtK+1lfNzWIYic3tiIwf8Gg==
X-Google-Smtp-Source: ABdhPJxSQWfEh5NxtWq0suCxJI4s7oxPr1qqJkjYtNThV5ywEhpVxXaOjibP7aUW9tQm7ShuZ7o3gA==
X-Received: by 2002:aca:4a4d:: with SMTP id x74mr3820223oia.6.1600815797731;
        Tue, 22 Sep 2020 16:03:17 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id x21sm7833048oie.49.2020.09.22.16.03.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2020 16:03:17 -0700 (PDT)
Subject: Re: [PATCH v3 1/4] Revert "usbip: Implement a match function to fix
 usbip"
To:     "M. Vefa Bicakci" <m.v.b@runbox.com>, linux-usb@vger.kernel.org
Cc:     stable@vger.kernel.org, Bastien Nocera <hadess@hadess.net>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        syzkaller@googlegroups.com, Shuah Khan <skhan@linuxfoundation.org>
References: <20200922110703.720960-1-m.v.b@runbox.com>
 <20200922110703.720960-2-m.v.b@runbox.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <a1f72e70-6eb2-743b-fc5b-f7e09ec466ce@linuxfoundation.org>
Date:   Tue, 22 Sep 2020 17:03:15 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200922110703.720960-2-m.v.b@runbox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/22/20 5:07 AM, M. Vefa Bicakci wrote:
> This commit reverts commit 7a2f2974f265 ("usbip: Implement a match
> function to fix usbip").
> 
> In summary, commit d5643d2249b2 ("USB: Fix device driver race")
> inadvertently broke usbip functionality, which I resolved in an incorrect
> manner by introducing a match function to usbip, usbip_match(), that
> unconditionally returns true.
> 
> However, the usbip_match function, as is, causes usbip to take over
> virtual devices used by syzkaller for USB fuzzing, which is a regression
> reported by Andrey Konovalov.
> 
> Furthermore, in conjunction with the fix of another bug, handled by another
> patch titled "usbcore/driver: Fix specific driver selection" in this patch
> set, the usbip_match function causes unexpected USB subsystem behaviour
> when the usbip_host driver is loaded. The unexpected behaviour can be
> qualified as follows:
> - If commit 41160802ab8e ("USB: Simplify USB ID table match") is included
>    in the kernel, then all USB devices are bound to the usbip_host
>    driver, which appears to the user as if all USB devices were
>    disconnected.
> - If the same commit (41160802ab8e) is not in the kernel (as is the case
>    with v5.8.10) then all USB devices are re-probed and re-bound to their
>    original device drivers, which appears to the user as a disconnection
>    and re-connection of USB devices.
> 
> Please note that this commit will make usbip non-operational again,
> until yet another patch in this patch set is merged, titled
> "usbcore/driver: Accommodate usbip".
> 
> Reported-by: Andrey Konovalov <andreyknvl@google.com>
> Link: https://lore.kernel.org/linux-usb/CAAeHK+zOrHnxjRFs=OE8T=O9208B9HP_oo8RZpyVOZ9AJ54pAA@mail.gmail.com/
> Cc: <stable@vger.kernel.org> # 5.8: 41160802ab8e: USB: Simplify USB ID table match
> Cc: <stable@vger.kernel.org> # 5.8
> Cc: Bastien Nocera <hadess@hadess.net>
> Cc: Valentina Manea <valentina.manea.m@gmail.com>
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: <syzkaller@googlegroups.com>
> Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>
> 
> ---
> v3: New patch in the patch set.
> 
>      Note for stable tree maintainers: I have marked the following commit
>      as a dependency of this patch, because that commit resolves a bug that
>      the next commit in this patch set uncovers, where if a driver does
>      not have an id_table, then its match function is not considered for
>      execution at all.
>        commit 41160802ab8e ("USB: Simplify USB ID table match")
> ---
>   drivers/usb/usbip/stub_dev.c | 6 ------
>   1 file changed, 6 deletions(-)
> 
> diff --git a/drivers/usb/usbip/stub_dev.c b/drivers/usb/usbip/stub_dev.c
> index 9d7d642022d1..2305d425e6c9 100644
> --- a/drivers/usb/usbip/stub_dev.c
> +++ b/drivers/usb/usbip/stub_dev.c
> @@ -461,11 +461,6 @@ static void stub_disconnect(struct usb_device *udev)
>   	return;
>   }
>   
> -static bool usbip_match(struct usb_device *udev)
> -{
> -	return true;
> -}
> -
>   #ifdef CONFIG_PM
>   
>   /* These functions need usb_port_suspend and usb_port_resume,
> @@ -491,7 +486,6 @@ struct usb_device_driver stub_driver = {
>   	.name		= "usbip-host",
>   	.probe		= stub_probe,
>   	.disconnect	= stub_disconnect,
> -	.match		= usbip_match,
>   #ifdef CONFIG_PM
>   	.suspend	= stub_suspend,
>   	.resume		= stub_resume,
> 

Thank you for finding a solution that works for usbip

Acked-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah

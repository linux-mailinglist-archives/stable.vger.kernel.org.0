Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7163D605506
	for <lists+stable@lfdr.de>; Thu, 20 Oct 2022 03:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231477AbiJTBbz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 21:31:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231435AbiJTBbs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 21:31:48 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3AF61AC1E4;
        Wed, 19 Oct 2022 18:31:08 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id j188so21276877oih.4;
        Wed, 19 Oct 2022 18:31:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=RJO+SrFx8b82JC/t8YfOKfOIRkKpUnK8IXg5Ia+QCu4=;
        b=Ewl56HdxecrV5goNLmTNhw+GD0PPcgoLRLGdLCZsDOFBMqgELBsczmNEZcHYZwiBHo
         OZImzR13Z4S8IEhBcjCTxguiPhWn3W3JSa0m5fQ8Mz4nYNszNSfGIAQNMUKgCxqiSmE8
         6VqyaFIIahs1NZ7uXSm7SXN04UE7Qqj7KoIjkM+wmHjpo2peWwtnOpLxMUvWdPRRjjWz
         GguI93fAap4Uk6geXpMSsJBTVFO/ARauMDOx0buujbw2T2qUTu94Pidro3sQK96W0Crc
         FolL+HOHg1gzZ12s9yOXuBmv6JUKg7AgauTCInoZHOz0aChKEjqp5PasTAvD9JClcaGB
         K4lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RJO+SrFx8b82JC/t8YfOKfOIRkKpUnK8IXg5Ia+QCu4=;
        b=TGjnG2MlXeRWDDI4Raj+MBvyDByouYYG5VIsbgiolDWtB28Wy4neBzif3WNd3Ft9tj
         aih8iBeR5rrn7vq4aa+q4E+1Xx8y7ot75Dxb24iAwQya4D1qpWAGldVuxwNETjgVhquu
         ozB0JsvSnN59wfwfUMXW4PR/+NTBDg+5nYv/pjXmapBkJQ3QS66Kw/AyKbedugat92IY
         SQ9cmVzb7W7r64oFMHUkA6k02y2dY0KFtLCTV0r90eghvxKfsdhVtXOL0xOBOyOTF4c5
         vf7AMUVYQgvC0n8Teb+2POj4YS2mR7BvUfcbXZdQDPV+fxTVj5qwxYR+5CvBRpa5m/+M
         iQ+w==
X-Gm-Message-State: ACrzQf1QgBOb0NM1XqfzZBbJJgdXEJZK1SvWuTGIFBEw5nfJqeY2IlRR
        o2CLUu05eDoUeQsclKnCBFXDNYs5oT4=
X-Google-Smtp-Source: AMsMyM7hFeQMBAUH756PTYS2NRHkZq9yDIbQ5P/FNAuhHwiEH5Ej0tGLEpqZXgspuurQmt2W/LSGJA==
X-Received: by 2002:a05:6870:73cc:b0:13a:e524:6438 with SMTP id a12-20020a05687073cc00b0013ae5246438mr1588846oan.120.1666228812403;
        Wed, 19 Oct 2022 18:20:12 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a130-20020acab188000000b00354978180d8sm7310422oif.22.2022.10.19.18.20.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Oct 2022 18:20:10 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <af9c4bfd-d3fb-1c7a-fb38-0d8bbd507449@roeck-us.net>
Date:   Wed, 19 Oct 2022 18:20:08 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH] firmware: coreboot: Register bus in module init
Content-Language: en-US
To:     Brian Norris <briannorris@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Benson Leung <bleung@chromium.org>,
        chrome-platform@lists.linux.dev, linux-kernel@vger.kernel.org,
        Samuel Holland <samuel@sholland.org>,
        Julius Werner <jwerner@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>, stable@vger.kernel.org
References: <20221019180934.1.If29e167d8a4771b0bf4a39c89c6946ed764817b9@changeid>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20221019180934.1.If29e167d8a4771b0bf4a39c89c6946ed764817b9@changeid>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/19/22 18:10, Brian Norris wrote:
> The coreboot_table driver registers a coreboot bus while probing a
> "coreboot_table" device representing the coreboot table memory region.
> Probing this device (i.e., registering the bus) is a dependency for the
> module_init() functions of any driver for this bus (e.g.,
> memconsole-coreboot.c / memconsole_driver_init()).
> 
> With synchronous probe, this dependency works OK, as the link order in
> the Makefile ensures coreboot_table_driver_init() (and thus,
> coreboot_table_probe()) completes before a coreboot device driver tries
> to add itself to the bus.
> 
> With asynchronous probe, however, coreboot_table_probe() may race with
> memconsole_driver_init(), and so we're liable to hit one of these two:
> 
> 1. coreboot_driver_register() eventually hits "[...] the bus was not
>     initialized.", and the memconsole driver fails to register; or
> 2. coreboot_driver_register() gets past #1, but still races with
>     bus_register() and hits some other undefined/crashing behavior (e.g.,
>     in driver_find() [1])
> 
> We can resolve this by registering the bus in our initcall, and only
> deferring "device" work (scanning the coreboot memory region and
> creating sub-devices) to probe().
> 
> [1] Example failure, using 'driver_async_probe=*' kernel command line:
> 
> [    0.114217] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000010
> ...
> [    0.114307] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 6.1.0-rc1 #63
> [    0.114316] Hardware name: Google Scarlet (DT)
> ...
> [    0.114488] Call trace:
> [    0.114494]  _raw_spin_lock+0x34/0x60
> [    0.114502]  kset_find_obj+0x28/0x84
> [    0.114511]  driver_find+0x30/0x50
> [    0.114520]  driver_register+0x64/0x10c
> [    0.114528]  coreboot_driver_register+0x30/0x3c
> [    0.114540]  memconsole_driver_init+0x24/0x30
> [    0.114550]  do_one_initcall+0x154/0x2e0
> [    0.114560]  do_initcall_level+0x134/0x160
> [    0.114571]  do_initcalls+0x60/0xa0
> [    0.114579]  do_basic_setup+0x28/0x34
> [    0.114588]  kernel_init_freeable+0xf8/0x150
> [    0.114596]  kernel_init+0x2c/0x12c
> [    0.114607]  ret_from_fork+0x10/0x20
> [    0.114624] Code: 5280002b 1100054a b900092a f9800011 (885ffc01)
> [    0.114631] ---[ end trace 0000000000000000 ]---
> 
> Fixes: b81e3140e412 ("firmware: coreboot: Make bus registration symmetric")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Brian Norris <briannorris@chromium.org>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

> ---
> Currently, get_maintainers.pl tells me Greg should pick this up. But I
> CC the chrome-platform list too, since it seems reasonable for Google
> folks (probably ChromeOS folks are most active here?) to maintain
> Google/Chrome drivers.
> 
> Let me know if y'all would like this official, and I'll push out a
> MAINTAINERS patch.
> 

I think that would be a good idea.

Guenter

>   drivers/firmware/google/coreboot_table.c | 37 +++++++++++++++++++-----
>   1 file changed, 29 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/firmware/google/coreboot_table.c b/drivers/firmware/google/coreboot_table.c
> index c52bcaa9def6..9ca21feb9d45 100644
> --- a/drivers/firmware/google/coreboot_table.c
> +++ b/drivers/firmware/google/coreboot_table.c
> @@ -149,12 +149,8 @@ static int coreboot_table_probe(struct platform_device *pdev)
>   	if (!ptr)
>   		return -ENOMEM;
>   
> -	ret = bus_register(&coreboot_bus_type);
> -	if (!ret) {
> -		ret = coreboot_table_populate(dev, ptr);
> -		if (ret)
> -			bus_unregister(&coreboot_bus_type);
> -	}
> +	ret = coreboot_table_populate(dev, ptr);
> +
>   	memunmap(ptr);
>   
>   	return ret;
> @@ -169,7 +165,6 @@ static int __cb_dev_unregister(struct device *dev, void *dummy)
>   static int coreboot_table_remove(struct platform_device *pdev)
>   {
>   	bus_for_each_dev(&coreboot_bus_type, NULL, NULL, __cb_dev_unregister);
> -	bus_unregister(&coreboot_bus_type);
>   	return 0;
>   }
>   
> @@ -199,6 +194,32 @@ static struct platform_driver coreboot_table_driver = {
>   		.of_match_table = of_match_ptr(coreboot_of_match),
>   	},
>   };
> -module_platform_driver(coreboot_table_driver);
> +
> +static int __init coreboot_table_driver_init(void)
> +{
> +	int ret;
> +
> +	ret = bus_register(&coreboot_bus_type);
> +	if (ret)
> +		return ret;
> +
> +	ret = platform_driver_register(&coreboot_table_driver);
> +	if (ret) {
> +		bus_unregister(&coreboot_bus_type);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static void __exit coreboot_table_driver_exit(void)
> +{
> +	platform_driver_unregister(&coreboot_table_driver);
> +	bus_unregister(&coreboot_bus_type);
> +}
> +
> +module_init(coreboot_table_driver_init);
> +module_exit(coreboot_table_driver_exit);
> +
>   MODULE_AUTHOR("Google, Inc.");
>   MODULE_LICENSE("GPL");


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8837E1D8D7A
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 04:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgESCKu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 22:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbgESCKt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 May 2020 22:10:49 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C768C061A0C;
        Mon, 18 May 2020 19:10:49 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id b190so5824149pfg.6;
        Mon, 18 May 2020 19:10:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/WqhZ2ArTvl/+4wLm03uSDFBZMyOw/yWp5w3V45gXt4=;
        b=ttEHfE0Z+oav/aDu4XFAKXS5/gdOJP9xiJ7YFz0hDfWlpLUQSyR8qFFYEh6W486l9J
         JMlrcVuLRe5y/3rqb87DDXjjzdCObMtDjKmjkkleudN9KMuviqsNhUX+tmY9KsafgAI8
         /f5C8nNQqWGl8T9oYfCTq7APNiPdeLmMSKHzQF/EPriq48e1KKKBNlrPr2gxOamV50Ya
         wxdEUbAKnXRO9in9QbE5sIO8McXsak6cfuDyleWj2kS5fxlk24Kqfc1ttbXYiEyt4q23
         fwmfIac7oq0eq2zermkzt1JufSUqxuUYW/gf7uNkSeEBjXvOOslPzWvGh/sg2KcxbWxp
         2XiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=/WqhZ2ArTvl/+4wLm03uSDFBZMyOw/yWp5w3V45gXt4=;
        b=kqj6Q9mKjyG9iLOZIDeiSfWogso2ZxBHRZctqXs5OLWaD3d1S7jWooXjxRq38xF1s7
         AQN6u+ZC3mrw20Sx/vuyl1b9h+K91rs+25YOdmUdBrBJ+r4+f/XyVCFnfn9mn7GspF3T
         Tdg50Awt1Xvt/WIku0h+VhBXv9pOZ2wtq4ijJLTlSY/iQpEaaueqes3OUJtHa7RwUkR4
         KLg1hvlAGC8DW0qFus0icTu4XkXbMTyBoiZju/VufAzCP6xD30/A/fcUvYzgSSiu2MHu
         L3BE/72s8pytFnvqF2gPVzBwBB1Klh49TTwd3yAul8k0lxF36koUYIsLbYFa5YA0ZMqx
         N+Bw==
X-Gm-Message-State: AOAM532d6xhkX+R9IW0lQKGEqI/2u+h1QayEiqs1Ykzc9t8jluDRQISC
        ZJ3XMfbz16BV4Y1bxqQMrt/pK6Wq
X-Google-Smtp-Source: ABdhPJy/iRfVmayw/IC/aOXFhupP58C0lVxC7F0I273aeMjhW7jJU9CBbVn2tVz60Iwxipe4WUOHLQ==
X-Received: by 2002:a62:1d48:: with SMTP id d69mr7890405pfd.27.1589854248319;
        Mon, 18 May 2020 19:10:48 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a6sm2352770pfa.111.2020.05.18.19.10.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2020 19:10:47 -0700 (PDT)
Subject: Re: [PATCH 5.6 000/194] 5.6.14-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20200518173531.455604187@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <433eae0c-e84b-5694-a953-11f3843cfa24@roeck-us.net>
Date:   Mon, 18 May 2020 19:10:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/18/20 10:34 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.6.14 release.
> There are 194 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 May 2020 17:32:42 +0000.
> Anything received after that time might be too late.
> 

Quick feedback:

You also need to pull in commit 92db978f0d68 ("net: ethernet: ti: Remove TI_CPTS_MOD workaround")
which fixes commit b6d49cab44b5 ("net: Make PTP-specific drivers depend on PTP_1588_CLOCK").
This is necessary to avoid compile errors.

Guenter

---
Building arm:omap2plus_defconfig ... failed
--------------
Error log:
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/cpsw.o: in function `cpsw_ndo_stop':
drivers/net/ethernet/ti/cpsw.c:886: undefined reference to `cpts_unregister'
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/cpsw.o: in function `cpsw_remove':
drivers/net/ethernet/ti/cpsw.c:1741: undefined reference to `cpts_release'
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/cpsw.o: in function `cpsw_rx_handler':
drivers/net/ethernet/ti/cpsw.c:437: undefined reference to `cpts_rx_timestamp'
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/cpsw.o: in function `cpsw_ndo_open':
drivers/net/ethernet/ti/cpsw.c:840: undefined reference to `cpts_register'
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/cpsw.o: in function `cpsw_probe':
drivers/net/ethernet/ti/cpsw.c:1716: undefined reference to `cpts_release'
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/cpsw.o:(.debug_addr+0x34): undefined reference to `cpts_release'
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/cpsw.o:(.debug_addr+0x194): undefined reference to `cpts_unregister'
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/cpsw.o:(.debug_addr+0x350): undefined reference to `cpts_rx_timestamp'
arm-linkkkkkkkkkkkkkkux-gnueabi-ld: drivers/net/ethernet/ti/cpsw.o:(.debug_addr+0xb20): undefined reference to `cpts_register'
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/cpsw_priv.o: in function `cpsw_tx_handler':
drivers/net/ethernet/ti/cpsw_priv.c:68: undefined reference to `cpts_tx_timestamp'
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/cpsw_priv.o: in function `cpsw_init_common':
drivers/net/ethernet/ti/cpsw_priv.c:525: undefined reference to `cpts_create'
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/cpsw_priv.o:(.debug_addr+0xa38): undefined reference to `cpts_tx_timestamp'
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/cpsw_priv.o:(.debug_addr+0xc90): undefined reference to `cpts_create'
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/cpsw_new.o: in function `cpsw_ndo_stop':
drivers/net/ethernet/ti/cpsw_new.c:814: undefined reference to `cpts_unregister'
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/cpsw_new.o: in function `cpsw_remove':
drivers/net/ethernet/ti/cpsw_new.c:2028: undefined reference to `cpts_release'
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/cpsw_new.o: in function `cpsw_rx_handler':
drivers/net/ethernet/ti/cpsw_new.c:379: undefined reference to `cpts_rx_timestamp'
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/cpsw_new.o: in function `cpsw_probe':
drivers/net/ethernet/ti/cpsw_new.c:2004: undefined reference to `cpts_release'
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/cpsw_new.o: in function `cpsw_ndo_open':
drivers/net/ethernet/ti/cpsw_new.c:874: undefined reference to `cpts_register'
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/cpsw_new.o:(.debug_addr+0x38): undefined reference to `cpts_release'
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/cpsw_new.o:(.debug_addr+0x158): undefined reference to `cpts_unregister'
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/cpsw_new.o:(.debug_addr+0x2c4): undefined reference to `cpts_rx_timestamp'
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/cpsw_new.o:(.debug_addr+0xa60): undefined reference to `cpts_register'
make[1]: *** [vmlinux] Error 1
make: *** [sub-make] Error 2
--------------

Building arm:keystone_defconfig ... failed
--------------
Error log:
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/netcp_ethss.o: in function `gbe_rxtstamp':
drivers/net/ethernet/ti/netcp_ethss.c:2595: undefined reference to `cpts_rx_timestamp'
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/netcp_ethss.o: in function `gbe_probe':
drivers/net/ethernet/ti/netcp_ethss.c:3719: undefined reference to `cpts_create'
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/netcp_ethss.o: in function `gbe_remove':
drivers/net/ethernet/ti/netcp_ethss.c:3812: undefined reference to `cpts_release'
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/netcp_ethss.o: in function `gbe_unregister_cpts':
drivers/net/ethernet/ti/netcp_ethss.c:2731: undefined reference to `cpts_unregister'
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/netcp_ethss.o: in function `gbe_register_cpts':
drivers/net/ethernet/ti/netcp_ethss.c:2714: undefined reference to `cpts_register'
make[1]: *** [vmlinux] Error 1
make: *** [sub-make] Error 2

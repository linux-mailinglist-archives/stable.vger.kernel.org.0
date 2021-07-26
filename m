Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 989933D6530
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 19:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237168AbhGZQ2r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 12:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243453AbhGZQ16 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Jul 2021 12:27:58 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05995C04E19A
        for <stable@vger.kernel.org>; Mon, 26 Jul 2021 09:52:10 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id 21so11622693oin.8
        for <stable@vger.kernel.org>; Mon, 26 Jul 2021 09:52:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=He3coKcw9GzSTcMc1/bucGcJlXbu6D86uDxA4sIXTEc=;
        b=Aga2CfgcrsI2ptK5p+3lzsmok8uc/2D1LU+v+37wTg2APCXg80MMRwJXs48eomAKXg
         klVOfsV70Big9+NM0nsnOzf5xj1dI52bR40zkaH8iJ+Hvs5mErxmzTBdedpqxE2b4q74
         DYnDykU92rP1GWt+SKYUzRoZo+lMg4Pu+GOJeBVkoB4P83TgOYsqiCjCCskwnDquWQrQ
         k2uK1woyQCQZ+OdSThqOyqyKdCsin3lf+bdWIqotN70/QgzYOjg0QD5xTcZc6UxJWtvI
         ZMUfcVHo1KVatBJILvMQNmisMY8kxN+QkibVMp11Fg7ZTW4cAnWw/m0+y1txyiKjHS4a
         jMtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=He3coKcw9GzSTcMc1/bucGcJlXbu6D86uDxA4sIXTEc=;
        b=NjIrUaQXqHRPwtPNTDdg20CbjgX/T55mTsllb4FxSdq4CKqdJ/M9w5cvK0iuHbZ9kx
         GaF75enFcpDNyKcrS6+P9VBvXfIay3IR/TanIM1XHHFYUeZssQ7F7ODgmJ+EI+JMu167
         JluhrR5ns7o9cXkDhgJD+g3EOCdeX8q1LWnSdSEJgDQXkHWVltRXQwf4+d8PqFq/ZkkJ
         zUW//gkiuyAKTHqVXRLWS72lCb7wacsS3V+ky9qc2zfesMfEydxCs/YOx2a84fhfPqDJ
         qjadClq2M9YEItyJu1Y/lME/AIPRVlr5S0SzfWvRA7rcI/jZNGv5lqPqEwij9fJWS7rW
         v2fg==
X-Gm-Message-State: AOAM531SJ9eqiipu+Y2iIS2tRu91wO1wg2hRgpwZrqSgO4UQ2rW6toOk
        ODGlSafGNsXYFWVOuapvpdYBwg==
X-Google-Smtp-Source: ABdhPJyHVd1rwMfCft9myOBIWxxgq/TxveHPsluE/X2xIO39doksbipLA2KpmNOphgmIh7vb1CnvdQ==
X-Received: by 2002:aca:31d8:: with SMTP id x207mr17423875oix.144.1627318329449;
        Mon, 26 Jul 2021 09:52:09 -0700 (PDT)
Received: from [192.168.17.50] ([189.219.72.83])
        by smtp.gmail.com with ESMTPSA id m2sm82120otr.46.2021.07.26.09.52.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jul 2021 09:52:08 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/167] 5.10.54-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210726153839.371771838@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <19e027f2-c751-9bc6-52f4-e0c560c1a909@linaro.org>
Date:   Mon, 26 Jul 2021 11:52:07 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 7/26/21 10:37 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.54 release.
> There are 167 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Jul 2021 15:38:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.54-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Build regressions detected across plenty of architectures and configurations:

   /builds/linux/net/core/dev.c:5877:51: error: use of undeclared identifier 'TC_SKB_EXT'
                           struct tc_skb_ext *skb_ext = skb_ext_find(skb, TC_SKB_EXT);
                                                                          ^
   /builds/linux/net/core/dev.c:5878:47: error: use of undeclared identifier 'TC_SKB_EXT'
                           struct tc_skb_ext *p_ext = skb_ext_find(p, TC_SKB_EXT);
                                                                      ^
   /builds/linux/net/core/dev.c:5882:19: error: incomplete definition of type 'struct tc_skb_ext'
                                   diffs |= p_ext->chain ^ skb_ext->chain;
                                            ~~~~~^
   /builds/linux/net/core/dev.c:5877:11: note: forward declaration of 'struct tc_skb_ext'
                           struct tc_skb_ext *skb_ext = skb_ext_find(skb, TC_SKB_EXT);
                                  ^
   /builds/linux/net/core/dev.c:5882:36: error: incomplete definition of type 'struct tc_skb_ext'
                                   diffs |= p_ext->chain ^ skb_ext->chain;
                                                           ~~~~~~~^
   /builds/linux/net/core/dev.c:5877:11: note: forward declaration of 'struct tc_skb_ext'
                           struct tc_skb_ext *skb_ext = skb_ext_find(skb, TC_SKB_EXT);
                                  ^
   4 errors generated.
   make[3]: *** [/builds/linux/scripts/Makefile.build:280: net/core/dev.o] Error 1
   make[3]: Target '__build' not remade because of errors.
   make[2]: *** [/builds/linux/scripts/Makefile.build:497: net/core] Error 2

As with 5.13, it failed everywhere for the same reason. Fails on defconfig and bunch others, with GCC/Clang, and across many architectures.

Greetings!

Daniel Díaz
daniel.diaz@linaro.org

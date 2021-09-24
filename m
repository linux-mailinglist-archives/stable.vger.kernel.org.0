Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5ED84176A4
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 16:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346324AbhIXONk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 10:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345810AbhIXONj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Sep 2021 10:13:39 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8E07C061571
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 07:12:06 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id s69so14525237oie.13
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 07:12:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QHWU83P2QW9GhJYRT+OrwRkJXHizJLTmhkuqfEE3CsM=;
        b=g6y8kcoqbXZIS2JO8xh24fL0VeGvNnPeeP0PRi0kYvqZuxr1iDhs9N51MVKlWlYzcD
         XZkgT/OGS40r5UypvCP16WA80+0Xy3vdptTJy8VR1cEyY8Jteo6lCyqme57I3byTINxs
         6Tim5L6AF7KBaFgLslotAWEsIs9m4r9GNCAu4t3NCPiILiP+8SHJZ7oxEfYfaZr1bPJU
         k1oTmdn/NsEjCwIzpecIupZeAsOV8DwQHjs0F6tUdEEPaUUhIdjUzqkhvIlwPoPi8X8s
         IA94SmnIovNnGXVN4sBBsK6tZyoFmnkbv7l7Zztbo+OI9qyCylRnizW+HFqCV4uQmh/p
         HCNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QHWU83P2QW9GhJYRT+OrwRkJXHizJLTmhkuqfEE3CsM=;
        b=7sxST3ii5nucZJF/pYPD0x1I/m4ysSzIG/193gF+HPMB2GnQifZMwUZ/BtPc76Zg+S
         +oKxMyI5VGvdcMTqnv7uy2VvSMqnPwMbe6PiILkVFqO3HsyMZZaB7Q4IcoFmgQKAxmPn
         ob1n5lHKJB7HmZWW1ZzHKM36lLhBIu9IRN+w7+rpAt5EEH4xSa/xHFMGNoLPqdjl4qAH
         PR6QiqBxmTMz4vlNKPNZatUSSdTOHO3rusElgwW0YWZRn3iGHsSOp1JsJcGvvR6vcLHi
         w7RQi5xHw9ef2xwCYQbBgqWFDDPUoEJxn5Bf6izH0gerrs5wm74/22mzv2PvMimvwf0g
         gSPQ==
X-Gm-Message-State: AOAM532OUq2qK1D1vMIyG6Xh/t304JhsNheqeUQign30mAr826HB3w8k
        MNM1fqbTcczxR8CPWH06Sj7E2Q==
X-Google-Smtp-Source: ABdhPJxmoqc2Pndb75bFtMtyDU52IEzmImh5nLyoThNL7QCJ5wvd3GaD1Zon2Op1UqXaB049PzVRyQ==
X-Received: by 2002:aca:5bd4:: with SMTP id p203mr1599204oib.34.1632492726203;
        Fri, 24 Sep 2021 07:12:06 -0700 (PDT)
Received: from [192.168.17.16] ([189.219.73.83])
        by smtp.gmail.com with ESMTPSA id bk40sm2140964oib.8.2021.09.24.07.12.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Sep 2021 07:12:05 -0700 (PDT)
Subject: Re: [PATCH 5.10 00/63] 5.10.69-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     shuah@kernel.org, f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
References: <20210924124334.228235870@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <c7a38a76-18b0-efaa-efed-f73e53e58277@linaro.org>
Date:   Fri, 24 Sep 2021 09:12:04 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210924124334.228235870@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 9/24/21 7:44 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.69 release.
> There are 63 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 26 Sep 2021 12:43:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.69-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Regressions detected.

While building Perf for arm, arm64, i386 and x86, all with GCC 11, the following error was encountered:

   util/dso.c: In function 'dso__build_id_equal':
   util/dso.c:1345:26: error: implicit declaration of function 'memchr_inv'; did you mean 'memchr'? [-Werror=implicit-function-declaration]
    1345 |                         !memchr_inv(&dso->bid.data[bid->size], 0,
         |                          ^~~~~~~~~~
         |                          memchr
   cc1: all warnings being treated as errors
   make[4]: *** [/builds/linux/tools/build/Makefile.build:96: /home/tuxbuild/.cache/tuxmake/builds/current/util/dso.o] Error 1

To reproduce this build locally (for instance):
   tuxmake \
     --target-arch=x86_64 \
     --kconfig=defconfig \
     --kconfig-add=https://raw.githubusercontent.com/Linaro/meta-lkft/sumo/recipes-kernel/linux/files/lkft.config \
     --kconfig-add=https://raw.githubusercontent.com/Linaro/meta-lkft/sumo/recipes-kernel/linux/files/lkft-crypto.config \
     --kconfig-add=https://raw.githubusercontent.com/Linaro/meta-lkft/sumo/recipes-kernel/linux/files/distro-overrides.config \
     --kconfig-add=https://raw.githubusercontent.com/Linaro/meta-lkft/sumo/recipes-kernel/linux/files/systemd.config \
     --kconfig-add=https://raw.githubusercontent.com/Linaro/meta-lkft/sumo/recipes-kernel/linux/files/virtio.config \
     --kconfig-add=CONFIG_IGB=y \
     --kconfig-add=CONFIG_UNWINDER_FRAME_POINTER=y \
     --kconfig-add=CONFIG_FTRACE_SYSCALLS=y \
     --toolchain=gcc-11 \
     --runtime=podman \
     perf

Greetings!

Daniel Díaz
daniel.diaz@linaro.org

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 077603030A4
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 00:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731932AbhAYX4S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 18:56:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731738AbhAYTot (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jan 2021 14:44:49 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F159CC061573
        for <stable@vger.kernel.org>; Mon, 25 Jan 2021 11:44:05 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id w124so16044930oia.6
        for <stable@vger.kernel.org>; Mon, 25 Jan 2021 11:44:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4LOgS3Tl2OgGzM16/a2EHEUkaq5mzG8xZay7d7qs3K4=;
        b=MMyjieg972wImvHqf6jMv96D0tW3Zp1XpJThWfiGqGO6cDo4b7fbuo7hYfjywmEBCp
         z5WoLu4wiDnya9qgIuDvhiHvv1kkfdaZmCKtRbH6QMeJJj0OF732rjckqukloB9ukmSC
         GumjlL81O4whjWsPQcz2UWPP0sqm7mxKrc1uRPXLy/0j7lI4noMCNRC11hlGjH3RyCmy
         3rQfT51k360Byu3ev140/doLf+p9Yz6XfCyJuX0ncexj2mOowgqVnijY0olRFWyfdY8C
         ybZpVRuQidQO8b3rAIeinteF5rxrGQgLecqmVxE8Fje6WTR/CTUMAERcbhr1a8B6y7mE
         ns6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4LOgS3Tl2OgGzM16/a2EHEUkaq5mzG8xZay7d7qs3K4=;
        b=gs7fsxs3qfnsZSRjL7aHS5WuLSP2oyaGrT4Y41rKrqDeCJgtrPhs+Ig91asS8M8VHV
         cmBJMAY6mfziolPRnSqEyZYV6HPAr/JR2Rj4/XZFLcrRleG93x9JLAclHdx4pJxBNJ+A
         iQo/7oR1Cb85cGNDCrIUSEnpVfRVGRB5tjVZUW7Kr/YuI1YRemlvCc2f3pI+DKDWnmHO
         EMOzXZUnWdsP70f1V1dVU0KLx9bUzApbP18xzaePWUtsLqTbo+63Zh68otFX/lMAs8rh
         EiWyncvHIFQnozYu5OFlPGAtguL0jiqCVF4dWVS46Vd/8qzggHMq/4mYoGbxRCqwSOXa
         9fow==
X-Gm-Message-State: AOAM533OZ/bpYQQjYLq/XyNcXiWOO87XmanIGC8Waw6gb6SuCgI1H9g6
        mfniBTBBK6/vmvUBjJ6jJ8jLTw==
X-Google-Smtp-Source: ABdhPJxw8MvsLzxsJHlbB5NEQ66freuhA82HcyoI+f7DGFFvdQx8XZlUEP8x26ivt4VksVPwDJG8IQ==
X-Received: by 2002:a05:6808:69a:: with SMTP id k26mr1092485oig.115.1611603845385;
        Mon, 25 Jan 2021 11:44:05 -0800 (PST)
Received: from [192.168.17.50] (CableLink-189-219-73-147.Hosts.InterCable.net. [189.219.73.147])
        by smtp.gmail.com with ESMTPSA id g14sm3182044oon.23.2021.01.25.11.44.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jan 2021 11:44:04 -0800 (PST)
Subject: Re: [PATCH 5.4 00/86] 5.4.93-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net
References: <20210125183201.024962206@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Message-ID: <dec01147-3526-59d8-d7a2-5d23d42c5671@linaro.org>
Date:   Mon, 25 Jan 2021 13:44:03 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210125183201.024962206@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 1/25/21 12:38 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.93 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 27 Jan 2021 18:31:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.93-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Sanity results from Linaro’s test farm.
Regressions detected.

Summary
------------------------------------------------------------------------

kernel: 5.4.93-rc1
git repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
git branch: linux-5.4.y
git commit: 3deaa28e41d9780b3b462686a676fa1d21f55ad3
git describe: v5.4.92-87-g3deaa28e41d9
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y-sanity/build/v5.4.92-87-g3deaa28e41d9

Regressions (compared to build v5.4.92)
------------------------------------------------------------------------

x86_64:
   build:
     * clang-10-allnoconfig
     * clang-10-tinyconfig
     * gcc-8-allnoconfig
     * gcc-8-tinyconfig
     * gcc-9-allnoconfig
     * gcc-9-tinyconfig
     * gcc-10-allnoconfig
     * gcc-10-tinyconfig

riscv:
   build:
     * clang-10-defconfig
     * clang-11-defconfig
     * gcc-8-defconfig
     * gcc-9-defconfig
     * gcc-10-defconfig

i386:
   build:
     * gcc-8-allnoconfig
     * gcc-8-tinyconfig
     * gcc-9-allnoconfig
     * gcc-9-tinyconfig
     * gcc-10-allnoconfig
     * gcc-10-tinyconfig


No fixes (compared to build v5.4.92)

Ran 665 total tests in the following environments and test suites.

Environments
--------------
- arc
- arm
- arm64
- i386
- juno-r2
- mips
- parisc
- powerpc
- riscv
- s390
- sh
- sparc
- x15
- x86
- x86_64

Test Suites
-----------
* build
* linux-log-parser
* ltp-smoketest-tests


i386 and x86_64 errors as reported on 5.10. Additionally, RISC-V errors look like this:

   make --silent --keep-going --jobs=8 O=/home/tuxbuild/.cache/tuxmake/builds/1/tmp ARCH=riscv CROSS_COMPILE=riscv64-linux-gnu- 'CC=sccache riscv64-linux-gnu-gcc' 'HOSTCC=sccache gcc'
   Error: /builds/1nZcZgrKHH9C31BJVZOjOhHXH0s/arch/riscv/boot/dts/sifive/hifive-unleashed-a00.dts:88.27-28 syntax error
   FATAL ERROR: Unable to parse input tree
   make[3]: *** [scripts/Makefile.lib:285: arch/riscv/boot/dts/sifive/hifive-unleashed-a00.dtb] Error 1
   make[3]: Target '__build' not remade because of errors.
   make[2]: *** [/builds/1nZcZgrKHH9C31BJVZOjOhHXH0s/scripts/Makefile.build:496: arch/riscv/boot/dts/sifive] Error 2
   make[2]: Target '__build' not remade because of errors.
   make[1]: *** [/builds/1nZcZgrKHH9C31BJVZOjOhHXH0s/Makefile:1272: dtbs] Error 2

We'll try to get more info.

Greetings!

Daniel Díaz
daniel.diaz@linaro.org

-- 
Linaro LKFT
https://lkft.linaro.org

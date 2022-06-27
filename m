Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C15955C754
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236234AbiF0Sjp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 14:39:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240213AbiF0SjR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 14:39:17 -0400
Received: from mail-oo1-xc41.google.com (mail-oo1-xc41.google.com [IPv6:2607:f8b0:4864:20::c41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 508DEB9A
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 11:38:54 -0700 (PDT)
Received: by mail-oo1-xc41.google.com with SMTP id j2-20020a4ab1c2000000b00425813b407bso1907702ooo.10
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 11:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=JuE4G4k+9s7zTgtnSqan6CD/Xhbwm1NdftTu21F3DUk=;
        b=BtPk1oNY5b8hNQkJwLR6f223yM1TvEDeHwmHOQ7/JVtemgJckWyuHnoO2gq11dCJtc
         ceuGvJj5vEkhN/sQLmcfo/UjHM/u4KsiKe9c/ZldXfhFxPjih7CXIDn1gu/mep8MX4mq
         WWHY+GoWAvyaGpmY/suh/p5cpR32CZ1hXgMpkbohvZFvXBGn6dyiJlUIMKsMxpsBm2Ml
         zvGS6B6O9dEzZnGpDcrJrK5GPok9UMicYAhsBPltmFiB9IbbBJhYSa919qB0Oeucs0KJ
         xnk5ZR7bbft/pjWjvsGxEsRWF+fTOUHnpCewhJjHEQq3DZFgMJ184Q+NB67E6Dl6i7mG
         /1WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JuE4G4k+9s7zTgtnSqan6CD/Xhbwm1NdftTu21F3DUk=;
        b=FODM1ZXdOPGT4QratIYJBbxvizkQDg/RAVjBePPeAs8x4Oy/DLjUHdxUPgnXwIAwm+
         7pKfqSBZKWFe5nWfS6k4RWeFOu+3OQk239yU6gVFY7rFfBZ2Lo9OpCANpsuQehr9gQhc
         yazmFXCUSJT6y9sfBy8OYUbqKnChDGvgU+fJH6QmrQiNx6IhATW7wk6hfwisvQrgJ7ez
         i1o8hhYQ1gAdedJAb1/vQdHz68aInE4PQsDzc8GYuiXBZXxeUFwPX5LZuQUVjd6y3UPc
         syMUazWT4nSLHGKI+2eLkn6Bav40ZZxRXHV7h/E1qJkxC4BX734NjAfub2jbIUr+cXJQ
         D/0w==
X-Gm-Message-State: AJIora86AhX6IFDvC3ooo5/Nr7pLg4m3T0ReDfbM0sphAqTe14dmgPPJ
        uBDCg6DIXbaoavm1pllN9MeE4A==
X-Google-Smtp-Source: AGRyM1vZA5i0T8xVD9xQcRnUGH3VaeevgvCndiQPhHTtyiM6hRm8leQj653lw7xV4j3JUv6iQqcutA==
X-Received: by 2002:a4a:49d0:0:b0:425:708a:224 with SMTP id z199-20020a4a49d0000000b00425708a0224mr6462805ooa.18.1656355133640;
        Mon, 27 Jun 2022 11:38:53 -0700 (PDT)
Received: from [192.168.17.16] ([189.219.74.211])
        by smtp.gmail.com with ESMTPSA id i1-20020a4addc1000000b0041b768b58basm6309261oov.22.2022.06.27.11.38.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jun 2022 11:38:53 -0700 (PDT)
Message-ID: <24080846-a369-9333-589c-ad88d775bc04@linaro.org>
Date:   Mon, 27 Jun 2022 13:38:51 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 5.15 000/135] 5.15.51-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220627111938.151743692@linuxfoundation.org>
From:   =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20220627111938.151743692@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On 27/06/22 06:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.51 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Jun 2022 11:19:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.51-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Results from Linaro's test farm.
The following new warnings have been found while building ixp4xx_defconfig for Arm combinations with GCC:

   WARNING: modpost: vmlinux.o(___ksymtab_gpl+ixp4xx_irq_init+0x0): Section mismatch in reference from the variable __ksymtab_ixp4xx_irq_init to the function .init.text:ixp4xx_irq_init()
   The symbol ixp4xx_irq_init is exported and annotated __init
   Fix this by removing the __init annotation of ixp4xx_irq_init or drop the export.

   WARNING: modpost: vmlinux.o(___ksymtab_gpl+ixp4xx_timer_setup+0x0): Section mismatch in reference from the variable __ksymtab_ixp4xx_timer_setup to the function .init.text:ixp4xx_timer_setup()
   The symbol ixp4xx_timer_setup is exported and annotated __init
   Fix this by removing the __init annotation of ixp4xx_timer_setup or drop the export.


## Build
* kernel: 5.15.51-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 2c21dc5c2cb635c1b549c0f3eb0ff3d3744be11a
* git describe: v5.15.50-136-g2c21dc5c2cb6
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.50-136-g2c21dc5c2cb6

## No test regressions (compared to v5.15.48-116-g18a33c8dabb8)

## Metric Regressions (compared to v5.15.48-116-g18a33c8dabb8)
* arm, build
   - gcc-8-ixp4xx_defconfig-warnings
   - gcc-9-ixp4xx_defconfig-warnings
   - gcc-10-ixp4xx_defconfig-warnings
   - gcc-11-ixp4xx_defconfig-warnings

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## No test fixes (compared to v5.15.48-116-g18a33c8dabb8)

## No metric fixes (compared to v5.15.48-116-g18a33c8dabb8)

## Test result summary
total: 122583, pass: 109673, fail: 286, skip: 12014, xfail: 610

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 314 total, 314 passed, 0 failed
* arm64: 58 total, 58 passed, 0 failed
* i386: 52 total, 49 passed, 3 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 54 total, 54 passed, 0 failed
* riscv: 22 total, 22 passed, 0 failed
* s390: 21 total, 21 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 56 total, 55 passed, 1 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kunit
* kvm-unit-tests
* libgpiod
* libhugetlbfs
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-cpuhotplug
* ltp-crypto
* ltp-cve
* ltp-dio
* ltp-fcntl-locktests
* ltp-filecaps
* ltp-fs
* ltp-fs_bind
* ltp-fs_perms_simple
* ltp-fsx
* ltp-hugetlb
* ltp-io
* ltp-ipc
* ltp-math
* ltp-mm
* ltp-nptl
* ltp-open-posix-tests
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* packetdrill
* perf
* rcutorture
* ssuite
* v4l2-compliance
* vdso


Greetings!

Daniel Díaz
daniel.diaz@linaro.org

-- 
Linaro LKFT
https://lkft.linaro.org

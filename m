Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7402B6376FA
	for <lists+stable@lfdr.de>; Thu, 24 Nov 2022 11:58:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbiKXK6i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Nov 2022 05:58:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbiKXK6h (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Nov 2022 05:58:37 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 219B98FB3C
        for <stable@vger.kernel.org>; Thu, 24 Nov 2022 02:58:35 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id 1so1418904ybl.7
        for <stable@vger.kernel.org>; Thu, 24 Nov 2022 02:58:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=J5m6eyHzz2oRZEkKjayRaecyR0qfC3veWChX/45qfes=;
        b=GCIqEQjFhyfcl83v0Db6+sSfKLEhtsWmPjcBa26fzAaG2Y2wfVZixl2y0UZ3eP72J7
         LGx8rVTwMHhvUXINudqjAdK5NtEaV9dSIOlnsI7gHvNvnZvpep2kxaeF7zp/LMx9ByK3
         pIM6UymQJ1MoGfjvEF3oiQmHB4wO4km1ql3lj75eVd9fzQdG3Ccr5CNsDUouHUhO1zMR
         faNKS9sp4uke/r7d7IzGp/LPbsVcHode7Aq0SbiL+0ojjEKY7yK6FM3YfkjQLL3OTtso
         9cn8Qqaw0jNnhoUtfRfnJZ7UZX1znh4s8JtZ7SzLLGy1XbsCQswxmsua+E4KRxb+LA9T
         kLGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J5m6eyHzz2oRZEkKjayRaecyR0qfC3veWChX/45qfes=;
        b=S1v/7Rx/mUhnW+XoY0cuMOaHj8yPlHbmBqdulbarOW9iDihGZLTWSX3sBQ/Ic5S9bn
         eJ3Q3Qat+h5qRGfVHrvqi2p4Uwwi4ezFgi5eCdUW7za62RSnoMaHNyy6LpcoVcYnKKZX
         CNq9aZiCLDTtQK45rSDEm2rqAwpm2RpIEWlogziBXPkOH5AO2FLBNnmvZJz0IKYoE7aM
         WAfMeMlnyMm3IYhR8bhZ4V+t1+FxqmxmKKXNP7piLHp232ZDjup8/qRoawnKKaUrz8HP
         /DKPUzLZMb3QAAzJ6qJ6vqlI90kvMGp3sC/tdgpL/dCnDEMgc2a0szJRBKl9L2iPpB0H
         CIbQ==
X-Gm-Message-State: ANoB5pnBghyfqvyrHho4Afx+hW22iwSxbdxRDSl1TsILuF04o61BQKZ+
        zRq7dqyM33Mq9MWnTJM45pDGZ4iO63SOWEaVcvoWsg==
X-Google-Smtp-Source: AA0mqf4cPx7Sj4K0bJ43/k/1zEvIHJVUzijbK9lWTUZL7Qu/PshqEmOWRPHZp77ZYr6WBbEpC9USXVGvHAY5UB2CPYM=
X-Received: by 2002:a25:ed05:0:b0:6c4:8a9:e4d2 with SMTP id
 k5-20020a25ed05000000b006c408a9e4d2mr31354116ybh.164.1669287514140; Thu, 24
 Nov 2022 02:58:34 -0800 (PST)
MIME-Version: 1.0
References: <20221123084551.864610302@linuxfoundation.org>
In-Reply-To: <20221123084551.864610302@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 24 Nov 2022 16:28:22 +0530
Message-ID: <CA+G9fYtNrjqVQdDhJngENrwqYO1rHod0cEGZmhWBZx5F4gwBhw@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/114] 4.19.267-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 23 Nov 2022 at 14:33, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.267 release.
> There are 114 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 25 Nov 2022 08:45:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.267-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.19.267-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: f65c47c3f3362b712468c9b15657d9311e998240
* git describe: v4.19.266-115-gf65c47c3f336
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19.266-115-gf65c47c3f336

## Test Regressions (compared to v4.19.266)

## Metric Regressions (compared to v4.19.266)

## Test Fixes (compared to v4.19.266)

## Metric Fixes (compared to v4.19.266)

## Test result summary
total: 83846, pass: 73027, fail: 1316, skip: 8899, xfail: 604

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 323 total, 318 passed, 5 failed
* arm64: 59 total, 58 passed, 1 failed
* i386: 29 total, 28 passed, 1 failed
* mips: 46 total, 46 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 63 total, 63 passed, 0 failed
* s390: 15 total, 15 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 53 total, 52 passed, 1 failed

## Test suites summary
* boot
* fwts
* kselftest-android
* kselftest-arm64
* kselftest-arm64/arm64.btitest.bti_c_func
* kselftest-arm64/arm64.btitest.bti_j_func
* kselftest-arm64/arm64.btitest.bti_jc_func
* kselftest-arm64/arm64.btitest.bti_none_func
* kselftest-arm64/arm64.btitest.nohint_func
* kselftest-arm64/arm64.btitest.paciasp_func
* kselftest-arm64/arm64.nobtitest.bti_c_func
* kselftest-arm64/arm64.nobtitest.bti_j_func
* kselftest-arm64/arm64.nobtitest.bti_jc_func
* kselftest-arm64/arm64.nobtitest.bti_none_func
* kselftest-arm64/arm64.nobtitest.nohint_func
* kselftest-arm64/arm64.nobtitest.paciasp_func
* kselftest-breakpoints
* kselftest-drivers-dma-buf
* kselftest-efivarfs
* kselftest-gpio
* kselftest-intel_pstate
* kselftest-kvm
* kselftest-lib
* kselftest-net
* kselftest-net-forwarding
* kselftest-net-mptcp
* kselftest-netfilter
* kselftest-openat2
* kselftest-seccomp
* kselftest-timens
* kunit
* kvm-unit-tests
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
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org

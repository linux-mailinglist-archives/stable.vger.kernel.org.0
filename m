Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3BF6373BF
	for <lists+stable@lfdr.de>; Thu, 24 Nov 2022 09:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbiKXITT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Nov 2022 03:19:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbiKXITE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Nov 2022 03:19:04 -0500
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B692323174
        for <stable@vger.kernel.org>; Thu, 24 Nov 2022 00:18:30 -0800 (PST)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-381662c78a9so8784207b3.7
        for <stable@vger.kernel.org>; Thu, 24 Nov 2022 00:18:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RJnk7b9Prwvkwj/6ULA/7qfo5vqHNlDVoa8M96eq0eQ=;
        b=n3PoVsyZhgRpnzeV7UQzEq0CdyoVE3lF5brAlfiK2qO8+DaqmThvItsJY2p8xVlxov
         1u7UO8e1RfW+3tqYxN8DnlmmNT73xua9Mr9IIWpyRbKTwfolqZ54uN3KXIf6CJTK7AYo
         yzLPpTSuPrIJgPId5WNP5PGhFWnykhTJU/Cy3CcuQr6tecOKCLhZ+/1wSEui9TzeumEF
         WrM0fH2UmIPGqsixU2TmXnQFPXXEi3EhnhMWnTgDm5bLpp+HAb+6SHU9tYKKaC0P/LpL
         jitptmKODttfclsu/SHc1qeNfY+duIE+Hl3AlCE16evlxADlFiQKJgQvDRQoFQKGfq1c
         XchQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RJnk7b9Prwvkwj/6ULA/7qfo5vqHNlDVoa8M96eq0eQ=;
        b=RhvokgnnBkahJ++/bWkjeyuWUDWnItEWgukljlVZM+XQhp9ECGVKPH4ovo58rSUZB3
         ahSBdAizLFPA7FR4f9QFJNlL02LbojiWlzArZ07znHLUbpsB1a1kGpkAUc6mMkLlC0t1
         FnRc6f6i7tDF/6w3h1VGbCAK2dHEeWUMHfqobZLO4op5ZgWhXQF9lJOtXzlVnEJ0Uofz
         9gP2m57jEmWVET/AexJ85wmf1yU8iUB6lCNRMEzmgfHAh78TNUf1iOfJn89VbCySftZ5
         FE7JJSmKTQL44/KJibsb4iF62yAB6V5fRaTybUYF7q5TnotqHSPyjMWEXcpZNOSgTuGs
         iHcg==
X-Gm-Message-State: ANoB5pmER6wlArbjE++GjM7QKz49GNlDqRNrCOLvX+LkDJtoQRsKUzBz
        WE/m/rCu8BSWif3UaxUohlvIv9w+E5ap9UWnqiEVsg==
X-Google-Smtp-Source: AA0mqf7+S35yAAykhkjxvI00othj3Ijb20THmCFaveDKjg8fWbQOz6iX08zhG+h7ET2QD/QEqpuiXZXzWzajRXwz/7k=
X-Received: by 2002:a0d:df8b:0:b0:39b:b038:1edd with SMTP id
 i133-20020a0ddf8b000000b0039bb0381eddmr11999608ywe.311.1669277909670; Thu, 24
 Nov 2022 00:18:29 -0800 (PST)
MIME-Version: 1.0
References: <20221123084625.457073469@linuxfoundation.org>
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 24 Nov 2022 13:48:18 +0530
Message-ID: <CA+G9fYt1PhHTfGcN9Rf7883Gz9RvGOicbgoqHNLGym8Vdoet9g@mail.gmail.com>
Subject: Re: [PATCH 6.0 000/314] 6.0.10-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 23 Nov 2022 at 15:09, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.0.10 release.
> There are 314 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 25 Nov 2022 08:45:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.10-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
As others reported arm: allmodconfig build failed due to

rtc: cmos: fix build on non-ACPI platforms
[ Upstream commit db4e955ae333567dea02822624106c0b96a2f84f ]

Build error:
drivers/rtc/rtc-cmos.c:1347:13: error: 'rtc_wake_setup' defined but
not used [-Werror=unused-function]
 1347 | static void rtc_wake_setup(struct device *dev)
      |             ^~~~~~~~~~~~~~
cc1: all warnings being treated as errors


## Build
* kernel: 6.0.10-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.0.y
* git commit: dcf677c9377c88653b9cbbfc7e59e70f7a2af096
* git describe: v6.0.9-315-gdcf677c9377c
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.0.y/build/v6.0.9-315-gdcf677c9377c

## Test Regressions (compared to v6.0.9)

## Metric Regressions (compared to v6.0.9)

## Test Fixes (compared to v6.0.9)

## Metric Fixes (compared to v6.0.9)

## Test result summary
total: 148325, pass: 129685, fail: 3631, skip: 14746, xfail: 263

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 147 total, 144 passed, 3 failed
* arm64: 45 total, 45 passed, 0 failed
* i386: 35 total, 34 passed, 1 failed
* mips: 27 total, 26 passed, 1 failed
* parisc: 6 total, 6 passed, 0 failed
* powerpc: 34 total, 30 passed, 4 failed
* riscv: 12 total, 12 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 38 total, 38 passed, 0 failed

## Test suites summary
* boot
* fwts
* igt-gpu-tools
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
* perf
* perf/Zstd-perf.data-compression
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org

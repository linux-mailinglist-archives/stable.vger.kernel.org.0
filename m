Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 758575FED00
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 13:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbiJNLLa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 07:11:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbiJNLLL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 07:11:11 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50E6C1C6BCF
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 04:10:54 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id a26so9755694ejc.4
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 04:10:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jA2k3rXBvK05Xc5xQ70nSVKTJWLB6o1bG7Nug9Ic1QU=;
        b=aZAknoaMg6llHAWrj45ff1KJooCYDIxMVsTI46yzXFxyOo5svejngWEIEfO5E0X/n8
         ccFNb2yEF8AitFbSm9HN4cCQOeUlyXXyAMhOlcwlExvi+jKT38DnGinBhiHr4umqLr2y
         A2nMTDlpyINGeJ6IF4XjqC5gMfMNB8m3YD8Ifde0XjbbdLclfuOYOtxEO8PwSfqcu1Nj
         zG2TITIfOY4H1AQFzZ3G0W6QYd2wMqInVN7aPQCEqqV5o7M7Vm6eWyo9xZhalNFTBG2w
         qO3havh8OHbxXk2lcrIlct1WjgVWBaA36Bvt9VL/43CPH1d12X4RmE0uWC5CeBMtlJad
         nYBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jA2k3rXBvK05Xc5xQ70nSVKTJWLB6o1bG7Nug9Ic1QU=;
        b=2/HPmKkrwQG7M1guYweD+S+nAGfFiJ/lwDFYu8Gv4MZBoT4l2KV8keic/7UjkzzRIq
         MSypO98ZgGx+PsoPyEGrBWwcstFtwn0hKKA02Z48hvlgvGs+WkIDv3OBA2o+XmZ63xWR
         kdc5udZDLkbunSek44UqWVlSgCm4d3hiCG9QoL47ZlyowzbvsdWvQ1Dd1hxlMUeRFTKL
         O5pspU/xpg23/nmHzAcE+w4QfiROt5VVBVW0UTIFG6A6rTaf6ZCua8BgyMMJChCuy9Nm
         lSFn7W6PLBZ9+ZLBnn9oSLgCEppOiecwHn0Mchzi26swCssH47c9ld2YGfS1l0K2Zcox
         qJRA==
X-Gm-Message-State: ACrzQf1EM13uYKzY1L9ycZPDRZfZRzfNI6+GPjO4yN2Lvi7iqUzKbARK
        p889SbbP65Tx10WgMCheZ8rZyyimf6o6aE6MrjW7fQ==
X-Google-Smtp-Source: AMsMyM5jG4zkbFI2r1a5hOVbyMjbFUGiGRqBt7fb80qGG3veRqru4Vyu1dHIfEpRir2KZ4b0rf2Kg+zg5k33dTssqO4=
X-Received: by 2002:a17:906:fe46:b0:73d:939a:ec99 with SMTP id
 wz6-20020a170906fe4600b0073d939aec99mr3200877ejb.169.1665745852271; Fri, 14
 Oct 2022 04:10:52 -0700 (PDT)
MIME-Version: 1.0
References: <20221013175147.337501757@linuxfoundation.org>
In-Reply-To: <20221013175147.337501757@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 14 Oct 2022 16:40:40 +0530
Message-ID: <CA+G9fYsPit74KY8TSjGaSn2hVDQA3Dcb25XKO+qkZJ=Dr8Z7Zw@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/54] 5.10.148-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 13 Oct 2022 at 23:25, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.148 release.
> There are 54 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 15 Oct 2022 17:51:33 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.148-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.148-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 4ff6e9bba3ff6321ee46a6d40266296a615fe9b9
* git describe: v5.10.147-55-g4ff6e9bba3ff
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.147-55-g4ff6e9bba3ff

## No Test Regressions (compared to v5.10.147)

## No Metric Regressions (compared to v5.10.147)

## No Test Fixes (compared to v5.10.147)

## No Metric Fixes (compared to v5.10.147)

## No Test result summary

total: 107457, pass: 92929, fail: 1326, skip: 12843, xfail: 359

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 332 total, 332 passed, 0 failed
* arm64: 65 total, 63 passed, 2 failed
* i386: 55 total, 53 passed, 2 failed
* mips: 56 total, 56 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 60 total, 55 passed, 5 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 24 total, 24 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 58 total, 56 passed, 2 failed

## Test suites summary
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
* kselftest-capabilities
* kselftest-drivers-dma-buf
* kselftest-efivarfs
* kselftest-filesystems
* kselftest-filesystems-binderfs
* kselftest-firmware
* kselftest-fpu
* kselftest-futex
* kselftest-gpio
* kselftest-intel_pstate
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-kexec
* kselftest-kvm
* kselftest-lib
* kselftest-livepatch
* kselftest-membarrier
* kselftest-memfd
* kselftest-memory-hotplug
* kselftest-mincore
* kselftest-mount
* kselftest-mqueue
* kselftest-net
* kselftest-net-forwarding
* kselftest-netfilter
* kselftest-nsfs
* kselftest-openat2
* kselftest-pid_namespace
* kselftest-pidfd
* kselftest-proc
* kselftest-pstore
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
* kselftest-tc-testing
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-vm
* kselftest-x86
* kselftest-zram
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
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* packetdrill
* perf
* perf/Zstd-perf.data-compression
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org

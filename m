Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B596D6113CD
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 15:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbiJ1N7h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 09:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbiJ1N7f (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 09:59:35 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CF57DED0
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 06:59:30 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id b2so13150505eja.6
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 06:59:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/j4KNY3Cpj+Qz4OFiap93LGzI1p/jZ7ybjuUkUOSPEc=;
        b=ZktXx0jvy5QhL1G8VvWKf1j9HMqe3X4LdUrVl4SRL2yw84rL2vGYF5xhtxxAd8lfmy
         IuSVwHf1/w/VHm0M9ME8ibGBy3PHksiS4FSD/cgkgsO0c4tJtpSaX4+5EMzWXdKLwplb
         SLEErRRnfeEDQC/AhRS25gM5FE1uyaK0mL2uPdiq6cHld0c7VEzIkVUDYguizp7blds6
         16eV16XTR/3y9hdg1QBHL0XKLmXxjYLQ3bkaCLoTlFkCB0G+rZw6Z0U3FCVeQgIwJo1k
         i9syvxDbuPH0uN/7AShM9pjs88zMFMCNjGIvWPW+TwG5IXypa4SG7mh0hs/wkFXV8r8g
         bSiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/j4KNY3Cpj+Qz4OFiap93LGzI1p/jZ7ybjuUkUOSPEc=;
        b=MJNXYKoP5SVm2ife7YOXI8mPpppQLJgAPvqiGdCV2c68obOpqicw4YVcIKgRAYBYlK
         rTOSehpQAtD1VGjP4ffMym3TUf9gD6wuKFiejm4KHZmOE45c8/UtKZKgkofHnQhq/LAg
         VOp+c+dK+YxOacnQLzPYhmdSRibU3AiQHa1Sn023AIpGpx4IqGpyiE3kciwY3k2vJc2I
         GBvUgyl2+WbrUTfcw3XrlaqjjN5AixlZ/s+wL62+zJ5l6sb4OlQXVhmWiyyR0zuNb0me
         geTzx3HFhuRRSWFqB25GkHuWkD9QLbhQWYcMDfPic6BjK785RKcSsZJK0jewem2Sxaxd
         0i7A==
X-Gm-Message-State: ACrzQf1mnf4ptXbMcZeXrz9Sj/X1sp+KPzwji7YRdCWeRsHAxsrTDPcC
        H4uai+02p7MxsGVCw+AqtFX10HuepBO9R4jBvc43lWXhtW9Ibg==
X-Google-Smtp-Source: AMsMyM7JEA8ztZkfbNdRvC5yd2JXs404ngmsQdOZG7k/gCs39rfcBwBtTB/6XeS4yEpDT/SFMePO+0ktClmWudQnz80=
X-Received: by 2002:a17:906:fe45:b0:788:15a5:7495 with SMTP id
 wz5-20020a170906fe4500b0078815a57495mr47769390ejb.633.1666965567762; Fri, 28
 Oct 2022 06:59:27 -0700 (PDT)
MIME-Version: 1.0
References: <20221027165054.270676357@linuxfoundation.org>
In-Reply-To: <20221027165054.270676357@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 28 Oct 2022 19:29:15 +0530
Message-ID: <CA+G9fYtBxc_xrvkQUw20m095=Ax8cTKbjjui3Gq68JGW_yyv2w@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/79] 5.10.151-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
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

On Thu, 27 Oct 2022 at 22:35, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.151 release.
> There are 79 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 29 Oct 2022 16:50:35 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.151-rc1.gz
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
* kernel: 5.10.151-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: aa25703d0a7c8d3158e3753b710a730892d32a13
* git describe: v5.10.150-80-gaa25703d0a7c
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.150-80-gaa25703d0a7c

## No Test Regressions (compared to v5.10.149-391-gb4f4370de958)

## No Metric Regressions (compared to v5.10.149-391-gb4f4370de958)

## No Test Fixes (compared to v5.10.149-391-gb4f4370de958)

## No Metric Fixes (compared to v5.10.149-391-gb4f4370de958)


## Test result summary
total: 132473, pass: 112534, fail: 2525, skip: 17013, xfail: 401

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 143 total, 142 passed, 1 failed
* arm64: 43 total, 41 passed, 2 failed
* i386: 35 total, 33 passed, 2 failed
* mips: 23 total, 23 passed, 0 failed
* parisc: 5 total, 5 passed, 0 failed
* powerpc: 25 total, 21 passed, 4 failed
* riscv: 10 total, 10 passed, 0 failed
* s390: 10 total, 10 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 36 total, 34 passed, 2 failed

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
* kselftest-net-mptcp
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
* ltp-smoke
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

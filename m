Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB5A56113DC
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 16:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbiJ1OB4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 10:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbiJ1OBz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 10:01:55 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BDF7173FDA
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 07:01:51 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id v27so8049824eda.1
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 07:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BqeNWIlBRkMmK1mslOPps+q6bAFky+VJHL/6+iGrBtw=;
        b=qNMH5a1M+Yusizq5vVYKCJkc7615P73mvw7J3+JaYW9TJtpTCQNjAhHCQuhmoWn29U
         6wf7kRfCsuHxjkf1sBu71O6h40lAn3piFnLNgdIHl9vL5L1NVPWC0QIQbmqw2azPrSDq
         o70wM7InpV82lDGuQ5C4fKS9C+RS37XtnMKCYPOX3/h+OR7q0vc9orr1YWSd7r9A+SbK
         ub/BmNgPOSHFmA3DY6obZOEX+p2WRbXKk8UijaG7o+BKlReq3dRWHW1aP5qq5eor50ac
         +q4smWoHnA5dhY1NL962a12T9QNxCHEixkd3CBEvEh7/LgvjVFSsGpCwYvi34+TG3djQ
         +kUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BqeNWIlBRkMmK1mslOPps+q6bAFky+VJHL/6+iGrBtw=;
        b=u7WeGdnEPKoUlm+xGL7vpWDEC53In2P7CfUxcFctuS1pfbSYIfZQNkNf/m3eN9CY/P
         rm6Zq1KKLCBf03brTMQlCPdLWApZeOXNYSYeC/u0hvmlhMcWkwcX8ydZ3rlG8EOX9bAf
         r2nCl0Iv5aKSq/Yf1MOsVwkoS2b7gE6aLoH4I3pMXpvc1pnaFK6JSTK7C1iMKLHALqDe
         WDCDdIECr3lokEEfeWoLwN9yGd2QLN7jz1N+wbGcy2xxRuZ6BXtDtpNtRR0hwobQWHOZ
         rl7A1bCjx4Ghze4t2IXFXOYscLSmUGBUh9JBAVuQhQZ6ZVdwv/z5pXnky1JldCepJ+UB
         dgDA==
X-Gm-Message-State: ACrzQf0IIffN5G6mgaZJVyH5D1poDA+wKfnHxlV4Ql77TO5F2KbTBmvz
        auZPx41cWY1HXp+Uz/Of8P2ltqUifwov4xQL/Ol5Fg==
X-Google-Smtp-Source: AMsMyM51gqVjvddmfdrHA2Awi7ragYxdhTfpa1HK2izQMpQaT3xyPp8hoWc+aCUM2WWSktiGTWBV194dhzRc8s8qhZM=
X-Received: by 2002:aa7:d996:0:b0:461:88b8:c581 with SMTP id
 u22-20020aa7d996000000b0046188b8c581mr30465868eds.111.1666965710354; Fri, 28
 Oct 2022 07:01:50 -0700 (PDT)
MIME-Version: 1.0
References: <20221027165049.817124510@linuxfoundation.org>
In-Reply-To: <20221027165049.817124510@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 28 Oct 2022 19:31:38 +0530
Message-ID: <CA+G9fYsvTNAFG5qMcoq_6PtexE3mW_0KKLi-FAMcsD+naskziA@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/53] 5.4.221-rc1 review
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
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 27 Oct 2022 at 22:38, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.221 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 29 Oct 2022 16:50:35 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.221-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.4.221-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: f98a212520a532dcf91de4a5784c6b29b0da8874
* git describe: v5.4.220-54-gf98a212520a5
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.220-54-gf98a212520a5

## No Test Regressions (compared to v5.4.219-256-gf49f12b65484)

## No Metric Regressions (compared to v5.4.219-256-gf49f12b65484)

## No Test Fixes (compared to v5.4.219-256-gf49f12b65484)

## No Metric Fixes (compared to v5.4.219-256-gf49f12b65484)

## Test result summary
total: 117476, pass: 99333, fail: 2165, skip: 15484, xfail: 494

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 334 total, 334 passed, 0 failed
* arm64: 64 total, 59 passed, 5 failed
* i386: 31 total, 29 passed, 2 failed
* mips: 56 total, 56 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 63 total, 63 passed, 0 failed
* riscv: 27 total, 26 passed, 1 failed
* s390: 15 total, 15 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 57 total, 55 passed, 2 failed

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

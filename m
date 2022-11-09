Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6E2622B92
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 13:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbiKIMb6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 07:31:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbiKIMbu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 07:31:50 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A1A02497A
        for <stable@vger.kernel.org>; Wed,  9 Nov 2022 04:31:49 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id j130so20789114ybj.9
        for <stable@vger.kernel.org>; Wed, 09 Nov 2022 04:31:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iBC82BkZBsCUgADC2E0SC+W37JMGP5amatij69xACMo=;
        b=bY7ZLJzytwpVOV1+fucTCu4HgzV/EG5N5wXc2/VUbRTzSlJBucO5XYmcqXhosxb29l
         a91d0BgRwjC93KlLL55zIvh2QLbzTrGoTYvB9kbQ2JuGIg6bKILsW8EMtZGWlYNAizgE
         wlkZ6UD23QTHBjpa3rsM+Wm3BofB1guq6T4xJ0mqnIblKZTRhAUDBn1N2sL0pDeinv9n
         dk14zZx54A18U+K2mieoKxSkgGBFZGWTQ4DX7d3/qtVeiuY+1TKebWwIkhNAH8WfZHNg
         rDjtIQWAUCMShqsPSjIgmG7pUNG0uQDXfJ4uD7pBQNFQk6G/MlmTMYVDMR1k8a2v4ncB
         Avcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iBC82BkZBsCUgADC2E0SC+W37JMGP5amatij69xACMo=;
        b=1dI14CnSpT5FFaAjrcl6ipDSIxkMVCfsYUOb+LkSb5I88ggeM17qgFat9zAsOpHRl+
         VjPL9vGjlgSga9iU1Vo/2siBbHzUFrfqrZ8NdhhxCvJZ27FzWqZgBv9yj0eekiZTaquy
         1Z6xU18/qzOcfGQmIkGsWGZbcKdCaBpmQ3K/If8VPhrL+ETnSesx/CUjVR4n139HPd/f
         OQ6MzmsJ29FNnLMcW1BtjvRO3Y4ysBT5Cfq+qWyfsMRvT0+nK/ByAcoJyFNUZxIM/x5f
         /u9ykPTsPjgbidnI851OA3rPOXMZX/jWn4Nc6L77jXfGHxow9/TSQATvK4u57HP7BZ5C
         zbQA==
X-Gm-Message-State: ACrzQf3+XhMxxmGt3Eew+5Zpy0hUHdUHU/rSRsrdhIeNV1/Mw3nWKuZe
        RJE+vC7V3QTUYEaDbgtkGa8NXr3xo/cKFfnYjeNN0w==
X-Google-Smtp-Source: AMsMyM5YPnwjmr20I1VTvC2kAhC6XAmOskCHD4Es/yZYbOFeQRspsxGwZR2Z6hWwr+HzxeHWdeVFBUNnWrT5z6iVRes=
X-Received: by 2002:a05:6902:722:b0:6ca:260e:cc5 with SMTP id
 l2-20020a056902072200b006ca260e0cc5mr61345317ybt.336.1667997108534; Wed, 09
 Nov 2022 04:31:48 -0800 (PST)
MIME-Version: 1.0
References: <20221108133326.715586431@linuxfoundation.org>
In-Reply-To: <20221108133326.715586431@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 9 Nov 2022 18:01:37 +0530
Message-ID: <CA+G9fYts=xTAh7m=vjY=PA9Q1YBzUcU3oG4Rx0axOJEfSsYUwg@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/30] 4.9.333-rc1 review
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

On Tue, 8 Nov 2022 at 19:11, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.333 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.333-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.9.333-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.9.y
* git commit: 2f583ceb0e8087ea02cfa74537a54532dd9b3d0c
* git describe: v4.9.332-31-g2f583ceb0e80
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.332-31-g2f583ceb0e80

## Test Regressions (compared to v4.9.332-20-g6ba04d5b05d0)

## Metric Regressions (compared to v4.9.332-20-g6ba04d5b05d0)

## Test Fixes (compared to v4.9.332-20-g6ba04d5b05d0)

## Metric Fixes (compared to v4.9.332-20-g6ba04d5b05d0)

## Test result summary
total: 102350, pass: 85472, fail: 1553, skip: 14404, xfail: 921

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 280 total, 277 passed, 3 failed
* arm64: 51 total, 46 passed, 5 failed
* i386: 29 total, 28 passed, 1 failed
* mips: 41 total, 40 passed, 1 failed
* parisc: 12 total, 0 passed, 12 failed
* powerpc: 45 total, 19 passed, 26 failed
* s390: 15 total, 11 passed, 4 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 48 total, 47 passed, 1 failed

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
* kselftest-net-forwarding
* kselftest-netfilter
* kselftest-nsfs
* kselftest-openat2
* kselftest-pid_namespace
* kselftest-pidfd
* kselftest-proc
* kselftest-pstore
* kselftest-ptrace
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-splice
* kselftest-static_keys
* kselftest-sync
* kselftest-sysctl
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

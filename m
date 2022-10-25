Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C78D60CBF4
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 14:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231819AbiJYMgi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 08:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231717AbiJYMgg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 08:36:36 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2FCC1870BA
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 05:36:34 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id t25so6564454ejb.8
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 05:36:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ol9n+qgRK/l0WRpGFyEUUPFnrxGcuYMacI9A4JuPh2g=;
        b=SdwfwgQb6baYe64zZvlvGGRV8MfiPARW31CQ4snonbH+y8tGU0TVqjth3tP6nAUyjZ
         0Q4JhS+9TaGxJPYAHYMqrFVFL7huT9ehCidHys3TopnW3q5sR3jxCCWlZmkAePg4LUpD
         OHMtXgJFf0iSSjS62ZqWmIxUS7pQO54x58QGxni76QnfqvNR9X9+qUSUpABzRm2Cxt/C
         xP7WuwrFOVNxgno/9Kk5G5HCbeSiIfoXVrREU4d+7b1UnN9ttM93JFSTJF7wnFAMsyB7
         uCBYOgGeeRiVOy54V5xGYSi52U8Leqhxzf5aL+pAktaUEw0dxn15sqM1YDOL0BREwDru
         wnBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ol9n+qgRK/l0WRpGFyEUUPFnrxGcuYMacI9A4JuPh2g=;
        b=szRWq1hP11RZJJv1XQzoJrL086O6bRb6M2fuCX1Umh3Y2UFWwcMLytNgTrJ+zS0E1u
         mXAxacH9LN0mhfH4PzqAKfEg0O6Y97BydYX/OaVXpWQacIZCVkXg4g8af+OPAAid1rGu
         iC1Yka+I/bd5+j4dWDFEOwe2GPqkUYbM800F57uK09kvd1d3UdBZLq5KfIJGA+P77LgD
         YCLpmsyKxrTf6OsNn3g5wAxZV4FI7pNB5lFqfgeWGgR6URBatVfgrjr54nB8s8NuCaQk
         Z6BG6ETZyqYoL1pFchM8Rit8HXxDpGRwEPlFGoEcGsA+VqDaGz6lgzhpfMCq4R6joUif
         MuTQ==
X-Gm-Message-State: ACrzQf00FeDsTqOE+BGTVMs3NnWE5fH1euq6VEUL97lOTni2d7N0/UCc
        zAxsPzuwQ98yxhdD4KNNTTog8AoQCGfqJa2Spenp/A==
X-Google-Smtp-Source: AMsMyM5z9l9Itl/W2zKX9c2YSaeZPq/c9e0hcRGj9OMx043R8I2iKdGwYU6OfVN2Zlv6SutMFEHOSN2D14HrJgTdCHE=
X-Received: by 2002:a17:907:d02:b0:7a3:de36:b67 with SMTP id
 gn2-20020a1709070d0200b007a3de360b67mr12281609ejc.451.1666701392968; Tue, 25
 Oct 2022 05:36:32 -0700 (PDT)
MIME-Version: 1.0
References: <20221024113044.976326639@linuxfoundation.org>
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 25 Oct 2022 18:06:21 +0530
Message-ID: <CA+G9fYvsn7mjXu5vxbxRB3R6JQ8W3KLto3C46FxyyMyRqThoWg@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/530] 5.15.75-rc1 review
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
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 24 Oct 2022 at 18:04, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.75 release.
> There are 530 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 26 Oct 2022 11:29:24 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.75-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.15.75-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 98108584d3851344414a5397dcff2c6f0a6cf9dd
* git describe: v5.15.74-531-g98108584d385
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.74-531-g98108584d385

## No Test Regressions (compared to v5.15.74)

## NoMetric Regressions (compared to v5.15.74)

## No Test Fixes (compared to v5.15.74)

## No Metric Fixes (compared to v5.15.74)

## Test result summary
total: 141307, pass: 122086, fail: 2098, skip: 16644, xfail: 479

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 339 total, 336 passed, 3 failed
* arm64: 72 total, 69 passed, 2 failed, 1 skipped
* i386: 61 total, 54 passed, 6 failed, 1 skipped
* mips: 62 total, 59 passed, 3 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 68 total, 65 passed, 3 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 30 total, 27 passed, 3 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x86_64: 65 total, 63 passed, 2 failed

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
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
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

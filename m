Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 583164E8104
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 14:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbiCZNVT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Mar 2022 09:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbiCZNVT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Mar 2022 09:21:19 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8DD927D56A
        for <stable@vger.kernel.org>; Sat, 26 Mar 2022 06:19:42 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-2e592e700acso107918717b3.5
        for <stable@vger.kernel.org>; Sat, 26 Mar 2022 06:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LOn0SHRlHo02gncDrl59S1dr+DNNk8n9Ukb6X7Tce34=;
        b=mLAw9y152mcqkhdhECgDrMiRSeOaY4IHM333JxWDuI4QmJC8b07B/K7yrleyg9y7x2
         3TaFUhS0vxanM4D9iza4oe6zy69ZCM9ES1T3jv74Y1jiIdOlHeJFfbySjDQHjBUDGa/8
         bmkQ0RRVyEz0yaswGB40xGZSmTI39Cy8zQXi+JXU73mHrWWXAJctjn/9Dva2+fcmMNoL
         lO4jOvHhfn+dhByO5w2HGgwKPtAOsjiXZ/mVA6eIbma7yoBrH2YFvsS2zsEpA4TZWIMC
         wLCRYUH+qHW+vgoc+rum3RgYQ10cBl4vSuhpCIgCQgu8m2DWi36KIXCOiuIEdLNq8bxL
         4zOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LOn0SHRlHo02gncDrl59S1dr+DNNk8n9Ukb6X7Tce34=;
        b=qcu6qhU8kNEeeROUZzLkOQ/4JTDh+JUBb7sBgtvtA3gjaZrLygOy+xgisNiY6EWxqw
         uisJnO22Lr3AFC8BjufcHZNhLWJ+AB40pfzjWZslLHuYoMTwgzwLsilC6lW9zkrWiygD
         8cgRmacWm0XewAYWwxuegnPiusLmoH0nElnU+s0qVxHHMgKwBxR5zB6Q6UNRC1oFAWnE
         9dxOU5O9ppnt/ZDF4UxncyQK7NkXMEEtHgS9xl0fPtrkrQkiLGtosjqMuJK84WcflhAb
         4ugY4G2cLHOSsniRUsCcXopYCA+9WsmsZqD3rGX2vOzh+4Cbd9v0xr72KNVClq9dPnvp
         Pmyg==
X-Gm-Message-State: AOAM531dUeRGpxA9oA95GZtJV9jzTkWauC78UXhKJpKdgVsdJVXBUMub
        5sMFAZo00oM+6IEtL3LTHyvxhJQ12ZCkCQeC6Yukrw==
X-Google-Smtp-Source: ABdhPJxkMMlUaEP2BRa7xc9/2f3+YcfDl0CCOlbg1vPurUVjxq9omVSeO0RkYfzQSRd+AwXGid2EcWGc5JqAxfoAacE=
X-Received: by 2002:a81:7812:0:b0:2d0:8c2c:5159 with SMTP id
 t18-20020a817812000000b002d08c2c5159mr15945310ywc.120.1648300781878; Sat, 26
 Mar 2022 06:19:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220325150418.585286754@linuxfoundation.org>
In-Reply-To: <20220325150418.585286754@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 26 Mar 2022 18:49:30 +0530
Message-ID: <CA+G9fYsxs27qu6p951sWpoWRkJhFFEA4ATSSyEJz5gZJ=ciiww@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/29] 5.4.188-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 25 Mar 2022 at 20:38, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.188 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 27 Mar 2022 15:04:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.188-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.4.188-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.4.y
* git commit: f7f6eb6ea69d3487f62c6e27e7855e0818d2a704
* git describe: v5.4.187-30-gf7f6eb6ea69d
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
87-30-gf7f6eb6ea69d

## Test Regressions (compared to v5.4.185-44-ge52a2b0f299b)
No test regressions found.

## Metric Regressions (compared to v5.4.185-44-ge52a2b0f299b)
No metric regressions found.

## Test Fixes (compared to v5.4.185-44-ge52a2b0f299b)
No test fixes found.

## Metric Fixes (compared to v5.4.185-44-ge52a2b0f299b)
No metric fixes found.

## Test result summary
total: 92013, pass: 75700, fail: 1205, skip: 13623, xfail: 1485

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 290 total, 290 passed, 0 failed
* arm64: 40 total, 34 passed, 6 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 20 total, 20 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 60 total, 54 passed, 6 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 40 total, 40 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-android
* kselftest-arm64
* kselftest-bpf
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-drivers
* kselftest-efivarfs
* kselftest-filesystems
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
* kvm-unit-tests
* libgpiod
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-open-posix-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* network-basic-tests
* packetdrill
* perf
* perf/Zstd-perf.data-compression
* rcutorture
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org

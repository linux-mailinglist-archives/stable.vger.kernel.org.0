Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B991610E03
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 11:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbiJ1J7T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 05:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230455AbiJ1J65 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 05:58:57 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B573A02D9
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 02:58:31 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id y69so7125482ede.5
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 02:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bYKEr5auoSxhUbnKh8GP4BOEfllJvo3KF+zVmGdF7Sg=;
        b=MYSQFwayXDSAWGx5ivuAAd2NOXYDyguhrniWK4AYwyWyL1vd1HtVJ9Qpp2pJAITSGL
         DOBXEv8YeEPfDU7pDQGkEY5XdXoD5Z0L8woRrmece4n9jzK9b+qrtvW8WOlEGhS59Hxo
         8/jgT35zbZsHzZRsj0uoYJBtb6l4TeA1WJMJwLPiBo6IAqrjV8O3JY1gFyNYRCKN6qUV
         6ec4T3ooSS5SWkAGyrtweqSI6qWn2xCG35nf3kiB9aJL7RG1+PY9BwITKUwFW1wjgnuQ
         zKHNX7YKTWypdPAyk40wZZE7BEt+LbBPx5olFd1J6bZDQv42wnsnV+0vji/Pd28IP80o
         +dwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bYKEr5auoSxhUbnKh8GP4BOEfllJvo3KF+zVmGdF7Sg=;
        b=h0NCgBAW3OXp7v4wLgINqN9x1wH6gwgIGzQ6Y0GaRxCeCcQ21JwNEa9PfCX6hd7IV7
         6E7uIZy7JFrtPGB5gnVBouFzaVzKGSfj9D+trMmQltaPeniJZr9N6Jw0glMVHWJC8+N1
         2VmiqQcus3KU790IQwzgArByPMIix0EZoRBf4ksT+VJXTJObjR2joRhAc8LS4cP6va+T
         bo84pdIAGvcHBi0NKLLWTJO3cp75Nww03ZCKeBMZknPW6ZlQ/WZi9Hecg2Hgwaczhm40
         01ewh6DZonQpXYXFENiv351Amuu+i6jXKjmgXjQepvHorRqPwyfEnFt/pTo6rcoFRGWE
         ipPg==
X-Gm-Message-State: ACrzQf1FJTBCMruKa+Kqjc7D/pku2irC5TeGsDzJ5R8JwzUbJ5CV8iTN
        S8Mk/OSS7tq3odAIrqnf7byMPAnYdxoz0ZpUKH6yig==
X-Google-Smtp-Source: AMsMyM7oS354NzcDqLUqBnEZXnmJ0HPJ4ER/xskF3RgNgH6aSe4k9cFHaGQOmkmK/I9k0BcYqXil4mFtIwD1g3d3m14=
X-Received: by 2002:a05:6402:3c5:b0:45b:55d8:21ff with SMTP id
 t5-20020a05640203c500b0045b55d821ffmr50594337edw.253.1666951109615; Fri, 28
 Oct 2022 02:58:29 -0700 (PDT)
MIME-Version: 1.0
References: <20221027165054.917467648@linuxfoundation.org>
In-Reply-To: <20221027165054.917467648@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 28 Oct 2022 15:28:17 +0530
Message-ID: <CA+G9fYtYAVEL0wk_FxGLfgTPB7pX0NskPao57036Y9p31hHi1w@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/79] 5.15.76-rc1 review
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

On Thu, 27 Oct 2022 at 22:32, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.76 release.
> There are 79 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 29 Oct 2022 16:50:35 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.76-rc1.gz
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

NOTE:
As other reported arm64 allmodconfig builds failed [1].
[1] https://builds.tuxbuild.com/2GjYlZaXK7ZwRlerOgTwH1deWP9/

## Build
* kernel: 5.15.76-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 5ea1b40eb20832f02b922538e861382e148832e5
* git describe: v5.15.75-80-g5ea1b40eb208
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.75-80-g5ea1b40eb208

## No Test Regressions (compared to v5.15.74-531-g98108584d385)

## No Metric Regressions (compared to v5.15.74-531-g98108584d385)

## No Test Fixes (compared to v5.15.74-531-g98108584d385)

## No Metric Fixes (compared to v5.15.74-531-g98108584d385)

## Test result summary
total: 149983, pass: 126822, fail: 3787, skip: 18858, xfail: 516

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 140 total, 139 passed, 1 failed
* arm64: 46 total, 44 passed, 2 failed
* i386: 36 total, 34 passed, 2 failed
* mips: 26 total, 26 passed, 0 failed
* parisc: 6 total, 6 passed, 0 failed
* powerpc: 30 total, 30 passed, 0 failed
* riscv: 9 total, 9 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 5 total, 5 passed, 0 failed
* x86_64: 38 total, 36 passed, 2 failed

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

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACFF45270DA
	for <lists+stable@lfdr.de>; Sat, 14 May 2022 13:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbiENLoh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 May 2022 07:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbiENLog (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 May 2022 07:44:36 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F22A827FFF
        for <stable@vger.kernel.org>; Sat, 14 May 2022 04:44:34 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id o130so3951168ybc.8
        for <stable@vger.kernel.org>; Sat, 14 May 2022 04:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dNEkfG6LvyngZSgl6703Rl9pZqlATkCldUNWFnhLMy0=;
        b=cfVmzcxdfvgRXSNfu7TjLPXygCT6b5hT5jhbvyUbV16kFFQhrsAgztafzbb4ku2S7h
         mroX4kGr2n7+lTXd5WjgntbkHYWc+S5/wRBOiml0S5zR3M4QwunMuhke9vMRhrxuJpqn
         SwlSgZqhjbTGsNkB+45kcLEMBJOXPccyyed1tLuvZ2IbYszf9bHcfOruBC7rrNLeduk9
         3JsRXLojC5TzwzOzdK8qUClsq5yTPrDDnftCMeqhpjlgOwMWx5nFTirMfhhlexgOmzsX
         oTn+Cw70GgYmtjpxpymk+zy0a86p1SGv/IG2NHrILllNQiq6JYeb1AqmOjJ8YMZGnJZF
         r6LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dNEkfG6LvyngZSgl6703Rl9pZqlATkCldUNWFnhLMy0=;
        b=FIgGSZwmfgzAAVFGozQ84X3ZIpTuDSu8t/ATrQWe+p7mFhnxxNpTHhAt95/vUJPZ1b
         kqFV69ayniP7v7sXf4cZUH5OkuEoAo/UaJYyM7JdKHmdMJy14VoOrqYrVsauSgtwalYr
         Yniv8aTK1bxaoIUsT1KM2EUVWouYk3LkJeU+kwWIKGLZncCFeIZx5+ITie/is+mSJuLe
         +KX4fImppXZT9zcu04Lb9CeIrfrPOVIl/UpaBwWlB77+AWAYKroSMuDbsCc77FKDuITd
         luiIjOjp1v0bYWndLEp3izLgvBSCf7nP9sNN3f78WCQ2Q0vWxVNDe5CsVxprS6FAzRDu
         H1Qw==
X-Gm-Message-State: AOAM533lP0BOKL55/Oo/afoMHejmPHVsHehkCPlIMlXVULOIMdosi670
        hjjVbgHpVyJlnQ4x2MqkqXdekhiN74xbp4RAF5wzvA==
X-Google-Smtp-Source: ABdhPJzqUOZA3OKpvMVCrkuFks0hEqoG/T+UdJ9mzfZ41MQG2fCreRAwk6kOOzIkZm97FBGTSYz7xSTADsbqY9mepiY=
X-Received: by 2002:a25:4aca:0:b0:64d:66b2:192b with SMTP id
 x193-20020a254aca000000b0064d66b2192bmr2388170yba.603.1652528674084; Sat, 14
 May 2022 04:44:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220513142228.303546319@linuxfoundation.org>
In-Reply-To: <20220513142228.303546319@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 14 May 2022 17:14:23 +0530
Message-ID: <CA+G9fYstukmUA8aSMcYXwAemDaEqc_fCnEc+UmanfE0GtD0B0g@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/10] 5.10.116-rc1 review
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

On Fri, 13 May 2022 at 19:58, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.116 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 15 May 2022 14:22:19 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.116-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.116-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.10.y
* git commit: b770d46f20165770243c4893df110518daee01fc
* git describe: v5.10.115-11-gb770d46f2016
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.115-11-gb770d46f2016

## Test Regressions (compared to v5.10.114-71-gb2286cf7a697)
No test regressions found.

## Metric Regressions (compared to v5.10.114-71-gb2286cf7a697)
No metric regressions found.

## Test Fixes (compared to v5.10.114-71-gb2286cf7a697)
No test fixes found.

## Metric Fixes (compared to v5.10.114-71-gb2286cf7a697)
No metric fixes found.

## Test result summary
total: 98763, pass: 83124, fail: 917, skip: 13635, xfail: 1087

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 291 total, 291 passed, 0 failed
* arm64: 41 total, 41 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 40 total, 40 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 37 total, 37 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 51 total, 51 passed, 0 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 21 total, 21 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 41 total, 41 passed, 0 failed

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
* kunit
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

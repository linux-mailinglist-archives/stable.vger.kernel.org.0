Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC906A184F
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 09:54:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbjBXIyl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Feb 2023 03:54:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjBXIyf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Feb 2023 03:54:35 -0500
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FA0A7A88
        for <stable@vger.kernel.org>; Fri, 24 Feb 2023 00:54:34 -0800 (PST)
Received: by mail-vs1-xe2a.google.com with SMTP id d7so14731148vsj.2
        for <stable@vger.kernel.org>; Fri, 24 Feb 2023 00:54:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sEfzPXb8YxsNwYdshNnWQ30snb3BfxoVn1m1qqjbb6M=;
        b=tb/t4KsW8JqSHi611kiR10Ctc/9wpGoM+GHONN1kX5fUBmDUlV9y7ROjBL/9MU43LX
         vBQCLgp5LA6d88JB2fcAAbdYhSJEPzr6ytpVfzagqGsDd6FbqK4ZM0j2O+aOHAgbBcpr
         T4ji0bbXMv6OBUpk1Grfrr5HkPka1xUrOc3BdmOgh+v/1XHSz1SNdlMTfkabGV9dY9pS
         a/zaBiAD6uhE7UVEAyebSpDHa1cNmb9RpSLO91RNsklqOZGVWMxHiSOQZJbT0Nyt29gG
         VtDGZmjZ/Q+Z0Oh4YvSPpt+ZX54E4FjJXBQwXCLl9+H9PPNA9JkCqoTuWbbwTcrIFN/e
         fP6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sEfzPXb8YxsNwYdshNnWQ30snb3BfxoVn1m1qqjbb6M=;
        b=IB2toIaMIcoiKN6IlajdBdVVfPaysKXrgF2M0R5DI/NUyWsDuRjd8z9kiZVtjRfi5V
         2x3PpwR8+ILpyVaEBWIKub0PD7VV6yAALGXG8Tm9p8ru4Xh7JCUNoN/ziNsIEZf2wJn+
         yOrrQQYVGkvkNXL89jUXem4AmTrx7nqM3tpHtfoWspMUOuHnsj4pZ72E+uUPt2pUQtyz
         OQveRmK2Ox5GWUCoxxLw18LZm8oQM0jie2f9iIEwY1Ws+qk3n3lp5e74y/zBzpotnW6Y
         6vn0qY5HLnyz2YKdFjZ4Az/6uuXGxuXxd9qK7PXXeHySjzwjG+DhZMSfR3ggxyUf55qG
         FY7Q==
X-Gm-Message-State: AO0yUKX17TJgG/blIFCTEJ9fB5hdJFJ4YfhVbktxcWSrstUyw98dgMVE
        C67USwKAVVe4Tt9Ffa6+e9Qnej/D86RM8QPubxPPLg==
X-Google-Smtp-Source: AK7set9fFkBXCIMkaZh4Vw/kF2quvU7mD09yH3AxWxZCFMIIqYj8WFL85LbA4gZaKyeAu+ilzpcIfNrZe5N2vfuAnr4=
X-Received: by 2002:a67:fbd2:0:b0:411:fff6:3cc4 with SMTP id
 o18-20020a67fbd2000000b00411fff63cc4mr1999815vsr.3.1677228872941; Fri, 24 Feb
 2023 00:54:32 -0800 (PST)
MIME-Version: 1.0
References: <20230223141545.280864003@linuxfoundation.org>
In-Reply-To: <20230223141545.280864003@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 24 Feb 2023 14:24:21 +0530
Message-ID: <CA+G9fYvCEzv=XF=SMoru58r2+1+8t+OSKf9Uwhrx2jD0gKk5ew@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/47] 6.1.14-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 23 Feb 2023 at 19:46, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.14 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.14-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.1.14-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: 342b7f3b3ae56d997a28ceec3321ebca5b73c30b
* git describe: v6.1.13-48-g342b7f3b3ae5
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.1=
3-48-g342b7f3b3ae5

## Test Regressions (compared to v6.1.13)

## Metric Regressions (compared to v6.1.13)

## Test Fixes (compared to v6.1.13)

## Metric Fixes (compared to v6.1.13)

## Test result summary
total: 163767, pass: 144832, fail: 4537, skip: 14355, xfail: 43

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 149 total, 146 passed, 3 failed
* arm64: 51 total, 48 passed, 3 failed
* i386: 39 total, 36 passed, 3 failed
* mips: 30 total, 28 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 38 total, 32 passed, 6 failed
* riscv: 16 total, 13 passed, 3 failed
* s390: 16 total, 14 passed, 2 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 44 total, 42 passed, 2 failed

## Test suites summary
* boot
* fwts
* igt-gpu-tools
* kselftest-android
* kselftest-arm64
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
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org

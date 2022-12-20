Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A17AC651B03
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 07:58:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232465AbiLTG6N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Dec 2022 01:58:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233213AbiLTG6M (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Dec 2022 01:58:12 -0500
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1815F2BF9
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 22:58:11 -0800 (PST)
Received: by mail-vs1-xe2d.google.com with SMTP id 3so10956171vsq.7
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 22:58:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6MavG/BSQqfihoP4/TEaeDzAmuIP/BPU7laq0dLUyiQ=;
        b=GsBIWFnT67ZXpkQFI41zO7pdeNulIK0cVZLpWDYskvgqyrQdpmlEdzr2EKpEtXwSj3
         gZqRHTZwWTQbhlCkmIhEmVdLUEtkhNcdvFOBsph1AMsAE773QmNpBLAUY/QE4+u1gYUb
         T96CUBgYX58tl0FY64tMUEWU58vkayPCkgP6vsI1kgoFzZlsgFlhhkZZywdeYv53Wq/Y
         MWyVNxU3jsdI67qhujEhlerm6M4/V0Vhbk+gzclM2FKthDTLBn/godyJJcEP5V+Tcn69
         YPkKUfgxjeaA0oHkn2D3jjfPLmHHfTGX/TDaz8WlB+m7Y/HfXEwYcLgw63XsoQmyo1XG
         LVOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6MavG/BSQqfihoP4/TEaeDzAmuIP/BPU7laq0dLUyiQ=;
        b=1+IQao9C7636UvBjMgLQlgeMu3jNC4tZv5Cf01gKHJPO0uB24n5QGjAEI3Yhl+pQ14
         pkTtG17juIu1sqKERMJZztFCeuH+K8Mn6nPrI0e8TkYYYosUQ8YwHxyJw0CrB+SuVSEz
         NILP6dIKONsulx9Pijztf8E0gBCrOkhnaV51VLP/jLW8i4pFoWrQ8RA1xhtidLkZkwp6
         pXtI5hDnmjkVSv0dbPZ7XO10ulsKck+EFah0IanXXAh3aoug749PLtxZm6UqRjLbN0Sz
         zNBlfw5Jl8QpxVxsUNNYrPAtdtNN4S5b5UWAJFyW9VJlVyZnfGNz20QVyB7FWjzwuPjy
         DxtQ==
X-Gm-Message-State: ANoB5plpk7JdeXxLWLtlSIiZTc4+zTY02N7b8bEMqTxhI9ZZX2tVxYiK
        chfjzaVPog9bAJ/6uJ+BPBGm0l9IeKCnvcGHP5D6k6kK4UTBarqv
X-Google-Smtp-Source: AA0mqf60OEcAqwDC44GHkHjuifLu/BTy8qOiOSkp6A3Th2X7AaA7e/B5gMVBtzfUeCtjXgGkusTs4hIXFPxTNRnwWA8=
X-Received: by 2002:a05:6102:3ca1:b0:3b5:d38:9d4 with SMTP id
 c33-20020a0561023ca100b003b50d3809d4mr3899571vsv.9.1671519490093; Mon, 19 Dec
 2022 22:58:10 -0800 (PST)
MIME-Version: 1.0
References: <20221219182940.701087296@linuxfoundation.org>
In-Reply-To: <20221219182940.701087296@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 20 Dec 2022 12:27:59 +0530
Message-ID: <CA+G9fYvCfYJF_7XXt+JGb+yZsjM21bmWQd4yO44gKqp7stfP1A@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/18] 5.10.161-rc1 review
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
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 20 Dec 2022 at 00:58, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.161 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.161-rc1.gz
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
* kernel: 5.10.161-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: bc32b2c55e20a98b04c9ccb34c50e4fbd7f2b8cd
* git describe: v5.10.160-19-gbc32b2c55e20
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.160-19-gbc32b2c55e20

## Test Regressions (compared to v5.10.160)

## Metric Regressions (compared to v5.10.160)

## Test Fixes (compared to v5.10.160)

## Metric Fixes (compared to v5.10.160)

## Test result summary
total: 120764, pass: 105386, fail: 2229, skip: 12725, xfail: 424

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 147 total, 146 passed, 1 failed
* arm64: 45 total, 43 passed, 2 failed
* i386: 35 total, 33 passed, 2 failed
* mips: 27 total, 24 passed, 3 failed
* parisc: 6 total, 6 passed, 0 failed
* powerpc: 28 total, 23 passed, 5 failed
* riscv: 12 total, 12 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 38 total, 36 passed, 2 failed

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

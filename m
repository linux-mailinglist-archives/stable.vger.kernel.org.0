Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17BCD6D61C3
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 15:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234023AbjDDNBa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 09:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234502AbjDDNB3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 09:01:29 -0400
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E70EC173B
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 06:01:27 -0700 (PDT)
Received: by mail-ua1-x933.google.com with SMTP id m5so23147772uae.11
        for <stable@vger.kernel.org>; Tue, 04 Apr 2023 06:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680613287;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AKuT2jdlAG+SgHXtPwT8kZwDya2VIJf4E3a+udNrV1U=;
        b=UVu37TzURWNtOLler24i+dYYA6JmTJHIBsMzMcAxh+2FFaw06F+PKN4gICXbWGrAhT
         aYUR7CT0QjUMik+CvKtNvuLcV0JIFV1Esdb35EIU5bXYVOEiZAT/sRHCJDqwjPHLRZk1
         gnb3FKzHoB3mvBEmHXANFTaRalrPYLFOeWe/tRkoVUjaKKdURnI/Sfoywtj+qiumn6JQ
         5b5cx0l6AtytMhl9cPSSd6Wm4wAjP6Ef2sHeZh7r0qXIv80fWcPmIN7wLRCxVpMJTg0D
         1gJCfA5e6b6pSYKdy0UOvzG0EzCjbhyDsRqZCZw276sCXYdVHYG6x7t+OEVqQCiM14N9
         LG9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680613287;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AKuT2jdlAG+SgHXtPwT8kZwDya2VIJf4E3a+udNrV1U=;
        b=DNKEd939U9J8U0ZlI2UNttuTLJPG60v76CdmrxibffwLtF4K1K7WRSGeHX1WNW5oA1
         fRB07FfLb5YVAnpPFS+7UzoOFcldUFzkPQVDPGS+Ou9X/ILaH21Zhcw/wLJqmtg8XWdc
         BHhbVpkYVZ4jzwQML0AQ98z+Rx/ipkXf5zaqUPj0L/8ZvVA9kjUtfMCfUHvQBd9arGqb
         XN8+XZkVxJwU4cgUzWGOP+wFOL9DHh32mrfgi+qi4Cx1whoyZG57GD3qByr9nFRthJPw
         PY5RtgoYZrvOje3IUymVucsmvYYf2Xp9NfUIJMWoJe1V9t+I/qeHYdVxtR1aS8l+UD+T
         7uhw==
X-Gm-Message-State: AAQBX9eeStNXyl6pHUaTKZFIuMpLNt6ixpmihtz6Y9d0ChChwD5VGFi2
        PhLQVPimXQYeczxtv1Gdf9LO63Ep0qbiI79vgYN4Ig==
X-Google-Smtp-Source: AKy350ZpaUQox2idaCi2bd7ek2lLeGMJEmRBZJpd+DvuzTfp0Jexh82Kfp6VQxs8ZCtJIMUzcUlSwJtwx2rOxZoLa9g=
X-Received: by 2002:a1f:90c9:0:b0:43c:6ef1:7116 with SMTP id
 s192-20020a1f90c9000000b0043c6ef17116mr2183840vkd.0.1680613286831; Tue, 04
 Apr 2023 06:01:26 -0700 (PDT)
MIME-Version: 1.0
References: <20230403140415.090615502@linuxfoundation.org>
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 4 Apr 2023 18:31:15 +0530
Message-ID: <CA+G9fYsjKH8SqfNwaa0grQjaB2KbaJCTmMAzuxdLLKiK_qA5Zg@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/181] 6.1.23-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 3 Apr 2023 at 20:05, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.23 release.
> There are 181 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.23-rc1.gz
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
* kernel: 6.1.23-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: 01cd0041b7a5a573cba99332d1c30a82999d7fc1
* git describe: v6.1.22-182-g01cd0041b7a5
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.2=
2-182-g01cd0041b7a5

## Test Regressions (compared to v6.1.22)

## Metric Regressions (compared to v6.1.22)

## Test Fixes (compared to v6.1.22)

## Metric Fixes (compared to v6.1.22)

## Test result summary
total: 168890, pass: 147321, fail: 4018, skip: 17196, xfail: 355

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 149 total, 148 passed, 1 failed
* arm64: 52 total, 51 passed, 1 failed
* i386: 39 total, 36 passed, 3 failed
* mips: 30 total, 28 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 38 total, 36 passed, 2 failed
* riscv: 16 total, 15 passed, 1 failed
* s390: 16 total, 16 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 44 total, 44 passed, 0 failed

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
* kselftest-ftrace
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
* perf
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org

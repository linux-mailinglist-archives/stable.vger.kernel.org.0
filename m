Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 837825270D8
	for <lists+stable@lfdr.de>; Sat, 14 May 2022 13:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231912AbiENLli (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 May 2022 07:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232194AbiENLlg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 May 2022 07:41:36 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DADD328711
        for <stable@vger.kernel.org>; Sat, 14 May 2022 04:41:34 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id r1so19476991ybo.7
        for <stable@vger.kernel.org>; Sat, 14 May 2022 04:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EHv05KE27l43NQcjrxgJ54w04GGkyw/BUuX/axpIOeY=;
        b=WaF8eWEYqU/YlLHAL2wcgO/2Q7bylXcdzC9VcyXq+uqekDHlIniUbvheruczDZi427
         sgaWijwlTKCyqMCs8Mol4aIdh4aD1zf4k5DXaX0JjOb4J4QFQFq1jt5WRO7FMZwJ/rj3
         Zm2vLrJT2CTzFo8LsaxYcP3mPu3XQ1ixOVhpvlOYcctdbkiI0a6rrOSN4we+aozN05kD
         BAEH+sIEtXz3I/PxD/0c+np+tdGKPX69Adzoz+s4jPAhQRMB1Jw4n9VfVHVeneoOxEa3
         Zq5rbTtTozvZYpMOqgp9jA94epg2lNhSGNg/UILJjTcYkLVOAFj2dkDe/Q0I1F6aIcsL
         2L1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EHv05KE27l43NQcjrxgJ54w04GGkyw/BUuX/axpIOeY=;
        b=g++azYzHe1txjysAabt15KSqEAtAJMtRm53wsR2z3XSQtN7zIOC1wrHsysX2I2pntu
         7/A6H/Ipl92+QmI0O5ZwXXps+KAKMPXBCtf77jyQy21EQOjt9VFvEO7Uo4/7aVPHp1qa
         H4DJaKrgamJPwj6XPF8sRTI9sIlvclDzBHdVpSg7YW5NFG+vKWkGTKLuQNhyAhU/1lq6
         wL3ivvOSIY1v5gemgMLjDyIO74cBm3H9V6XjL6LKeYarJUgYf1c+r3HWTXGy6xIekgwg
         zWQgF3bC+cb0gRj4ijS2u0/ydXtvQQXRiVZ8U5AsW5WwF3nqj66nJMT8A+kS4f/I6dbj
         rUAw==
X-Gm-Message-State: AOAM5330C0GJXSlr/uIXcq+Vgem7IgVgiy352A6a34WTwnBt9kxMo+5L
        0XubYu7qgFT2GHMe4zC3kesIG5FFj8ffa+rh7zemjg==
X-Google-Smtp-Source: ABdhPJx5wtMC+gCyqidE4aFSQaBJiqoHajbJbiQvZu51DxrgpGiFWmDQhS2fbLjqwYZ/p5DZRs27kgykWMj8/EnGaUY=
X-Received: by 2002:a25:ab72:0:b0:64b:9be4:d8b9 with SMTP id
 u105-20020a25ab72000000b0064b9be4d8b9mr6326612ybi.128.1652528493979; Sat, 14
 May 2022 04:41:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220513142229.874949670@linuxfoundation.org>
In-Reply-To: <20220513142229.874949670@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 14 May 2022 17:11:22 +0530
Message-ID: <CA+G9fYtXiDq9Q7scTdNRHazo0vKy8BRGF5Qg58Dz3=N6w=cJsQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/21] 5.15.40-rc1 review
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
> This is the start of the stable review cycle for the 5.15.40 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 15 May 2022 14:22:19 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.40-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.15.40-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 13b089c28632ad5a051bdbb1951ee189f96b01fd
* git describe: v5.15.39-22-g13b089c28632
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.39-22-g13b089c28632

## Test Regressions (compared to v5.15.38-136-g60041d098524)
No test regressions found.

## Metric Regressions (compared to v5.15.38-136-g60041d098524)
No metric regressions found.

## Test Fixes (compared to v5.15.38-136-g60041d098524)
No test fixes found.

## Metric Fixes (compared to v5.15.38-136-g60041d098524)
No metric fixes found.

## Test result summary
total: 110223, pass: 92720, fail: 1126, skip: 15100, xfail: 1277

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 296 total, 293 passed, 3 failed
* arm64: 47 total, 47 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 45 total, 41 passed, 4 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 41 total, 38 passed, 3 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 59 total, 56 passed, 3 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 26 total, 23 passed, 3 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 47 total, 47 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-
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
* rcutorture
* ssuite
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFF486CD885
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 13:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbjC2LdZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 07:33:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbjC2LdY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 07:33:24 -0400
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F146F4213
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 04:33:21 -0700 (PDT)
Received: by mail-vs1-xe31.google.com with SMTP id g17so12984250vst.10
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 04:33:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680089600;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SF/7j55UEdwdSXvasixqoGihgaHirKQA0NtfPSsjePs=;
        b=pCNX3/Yu/50sQOqRr5BINMneZYH3wyRUQLPOOvlPqgFajfFcGtClNdcsP3GYhnzJjg
         2Hkz0Su1o5TgIiSVRAsp0Pch484EKaUpcbyZKhwJ6b2RjkPqlFKSp/jGdL/oY29wy5u8
         eRFp5IvtPO2sW3cycxELkaBypLN46x3Q5aCaUCcSZEC13qo2Pszg3asI7Hwc7sMhMV8n
         tgPjAmawprHvFMbQ/pdgBNbwcftuw6BObXno3lpYdZT+XaCrByOFM3HjcIJ4iESlEnPF
         QjgJ0fnPoRcPOKoAgeceonM/kLtD+m3UB5ugdLTcL/5VzjOQvVYVcrO5Ux0S7t04G3CG
         yeIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680089600;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SF/7j55UEdwdSXvasixqoGihgaHirKQA0NtfPSsjePs=;
        b=crPj99s2hT0PHoTk49+aOjQBYoGG5CraY4npO323gslRbl4CC3pg09rzL1ZkWCN/6s
         r12+xjxiS2PsdtS4cWfan8qXW8nDQplVZFwgT/fUdmj/tzEBrfjMjMHTlZ/o3rt/xF+0
         pE5tJ534UfyA/PPi/g+8fe1a0N+pKV42yY+DI0wZOJF9zdTATcOpZxgWUBALigSx58My
         +DLdvva1o7teD68LbnFmywaWqt7nQciTnxlPVE1DPz1J2wN+3cRBM5tznr3VEFUsDvkI
         phvERG2ycch/vny28ZjZsjEnn85cvoP+jj3iHU4HHp/5iEmrYCGI8pbfyhCT0gcXmsFM
         v/2g==
X-Gm-Message-State: AAQBX9czWBXiVM4R+eaOkULxj9ABS4PIJj7bgHJv4aCLMNfI5B4NKOhh
        oUzNbEWE/BM3uQqR5CWT/stHSt2GJYInm1XrRxbbOg==
X-Google-Smtp-Source: AKy350bBhGHrs3ynZf0/Rz9pwcG7/7XtjGgmO9YzmKGO2m5PM4IVco6Z3jyYmBnFCd6noLy27PmaLSsAWNXecFevUxU=
X-Received: by 2002:a67:e01e:0:b0:425:d4de:718a with SMTP id
 c30-20020a67e01e000000b00425d4de718amr10384367vsl.1.1680089600529; Wed, 29
 Mar 2023 04:33:20 -0700 (PDT)
MIME-Version: 1.0
References: <20230328142617.205414124@linuxfoundation.org>
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 29 Mar 2023 17:03:09 +0530
Message-ID: <CA+G9fYv6nfabJATopiXEOY-wMGXVTggzHsmHHUu5_k7y0kD4bg@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/224] 6.1.22-rc1 review
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

On Tue, 28 Mar 2023 at 20:26, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.22 release.
> There are 224 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 30 Mar 2023 14:25:33 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.22-rc1.gz
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
* kernel: 6.1.22-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: e6bbee2ba76fd6c97025903e3b04b1461f02e8af
* git describe: v6.1.21-225-ge6bbee2ba76f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.2=
1-225-ge6bbee2ba76f

## Test Regressions (compared to v6.1.21)

## Metric Regressions (compared to v6.1.21)

## Test Fixes (compared to v6.1.21)

## Metric Fixes (compared to v6.1.21)

## Test result summary
total: 164164, pass: 145146, fail: 4467, skip: 14236, xfail: 315

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 149 total, 148 passed, 1 failed
* arm64: 51 total, 50 passed, 1 failed
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

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E29C465E6F8
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 09:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbjAEIlR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 03:41:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231411AbjAEIlQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 03:41:16 -0500
Received: from mail-vs1-xe2b.google.com (mail-vs1-xe2b.google.com [IPv6:2607:f8b0:4864:20::e2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BEA14D71D
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 00:41:15 -0800 (PST)
Received: by mail-vs1-xe2b.google.com with SMTP id o63so32636628vsc.10
        for <stable@vger.kernel.org>; Thu, 05 Jan 2023 00:41:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s7EF7J2WZpfKazjyV98h3tJ1tiVmr4oXFl0Z5U1WS7s=;
        b=USfWMRzD2f63j1sPoU+QPaMM6y8sZ5UFNjIxkcbU/+eek27cMDMO8EMBUXy4O0KQqL
         R2G7VcqsLNLTq8dNmjiR37hw8wwUofHeulyxZf22971DM+kp5skfzpshFPBYJkEjuV5H
         as2jlCXldALjy5Eh3I0R+FWwSuRHHYtpdAyn60Kc0Nlf0VCMp4YYjtvuC3yDTUg3JvLA
         RUPUCFoS2vqCEdw4Kt2l7xK2LQTxdYQd/0c68cl7vw1MKgpZ61D4SC/wfjT3bCet1NN7
         t8hmMwxKrPVFXSnYhXPGtvplcKHLAjW4KrI016q+o4NGND/yUe2sWOG8yR/r3Z70oat9
         varA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s7EF7J2WZpfKazjyV98h3tJ1tiVmr4oXFl0Z5U1WS7s=;
        b=W4DDHBBUOw/tf6oviK0l2teGnJI2z4Wfey/UrJ3guBAVGFDlo+ouAu5uLNKl2zr/pG
         nJM/CJOIuZhH4kDx7HG0xlJ7t69woH/MPGDIowkmNRQUqVMhkhe5wzBYoo5m96WeVEpt
         b2lsGW+QT+nJDsTTIwuRl8PEoRZfmOgcGONVL0k6YWnbhS4CMky3G0RbT5Uwvs5jUJJr
         nJBkV4/5+sYns/EWeYbZ2QBWqN1XWqEZAL/1OBwzi4kLLtx3wj9l/A/0FcU+prAKfCQ5
         i/dt1sDRAT4tX5vNfSsxdhKQ4kTLd/aLsO/0iMjUBxPVzl+4Kcv2jHlVJzzAMsoAvTSX
         ucig==
X-Gm-Message-State: AFqh2kr9bFKxnui3jwH5jZ3QTV8cvHjZPDC98Cj0PoEij3j/3Ganzl2S
        PkVWpC/8CIis0TpijizxQyxU2+mW4hIA+JAyTgHqQw==
X-Google-Smtp-Source: AMrXdXvt5RYDU663A2qRGuoh9PQAlTJedylst5ELfF2aOqDdHUTCZt5SM7zduqwJtIlK4J4W8pWXOnFy3CnBktCS0/U=
X-Received: by 2002:a67:ec94:0:b0:3b5:32d0:edcc with SMTP id
 h20-20020a67ec94000000b003b532d0edccmr5744829vsp.24.1672908074156; Thu, 05
 Jan 2023 00:41:14 -0800 (PST)
MIME-Version: 1.0
References: <20230104160511.905925875@linuxfoundation.org>
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 5 Jan 2023 14:11:02 +0530
Message-ID: <CA+G9fYvHrPjyPd8XX2j4=o=QOSnOiSSdinqdDV=ipCYnME_GFA@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/207] 6.1.4-rc1 review
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

On Wed, 4 Jan 2023 at 21:38, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.4 release.
> There are 207 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 06 Jan 2023 16:04:29 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.4-rc1.gz
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
* kernel: 6.1.4-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: a31425cbf493ef8bc7f7ce775a1028b1e0612f32
* git describe: v6.1.3-208-ga31425cbf493
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.3=
-208-ga31425cbf493

## Test Regressions (compared to v6.1.3)

## Metric Regressions (compared to v6.1.3)

## Test Fixes (compared to v6.1.3)

## Metric Fixes (compared to v6.1.3)

## Test result summary
total: 182377, pass: 153035, fail: 5009, skip: 24307, xfail: 26

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 151 total, 148 passed, 3 failed
* arm64: 51 total, 50 passed, 1 failed
* i386: 39 total, 36 passed, 3 failed
* mips: 30 total, 28 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 38 total, 32 passed, 6 failed
* riscv: 16 total, 15 passed, 1 failed
* s390: 16 total, 13 passed, 3 failed
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
* ltp-np++
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

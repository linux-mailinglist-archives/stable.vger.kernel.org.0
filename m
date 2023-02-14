Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6B3695BAB
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 09:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbjBNIAF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 03:00:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231877AbjBNIAC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 03:00:02 -0500
Received: from mail-vs1-xe2f.google.com (mail-vs1-xe2f.google.com [IPv6:2607:f8b0:4864:20::e2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E6DC40C1
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 23:59:50 -0800 (PST)
Received: by mail-vs1-xe2f.google.com with SMTP id h10so5616656vsu.11
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 23:59:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bv+N2/xSkgr/ii3ytw3heKzApyv0t3+1Ez3QG35FCHw=;
        b=xf4xQJtzdT7H1lhDk2wmSblzT/mmEEE5iL+kzx/ABsoM0M0DhhWQQF7z/Z0/7FtwMY
         pHQ5TFvv8PpP971t03M1dQnUTwez2Fd7F04flyu5MgkxixWhgZF3kbrXfOedWMNXgIZR
         0wk/XRZvQAkAn8vxe7rjlETPPVposHIkPWzK640EiF5T4AC2HA47DJFu5PBXt4trRPbG
         p9oqIIYHKD40xBnGtaknlNIx8thBjtQ1ZUFeajjtQmYagww07uOe136xANcq9zYo+sez
         CimtaxG8rFBUpZy3IiXF6WtrUv/dmL/k5QmOX8iOwFxpzVfalhOlN3ckoqm6qoORllmc
         CJqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bv+N2/xSkgr/ii3ytw3heKzApyv0t3+1Ez3QG35FCHw=;
        b=cDW+UIYGhrcPV9jWGsLRsT2Y8pJNWYfnX2v8VjK/MoDdTw3cY6iAGtU5T5awd6mpZq
         AiVam7SrMGohjahzTZ8Bn5V7ls3ceN2uDjE9Bi7aMYbFT5jJbg6qmCB88SDoQzPmLUU6
         06EftMPnsriZ/9QLn1U7tOFZjsnMVG5sbANiBc8E5K/S8XLoRfL5Jyn+nEtZjdz/UUAw
         wj1osZpCs5+QTBN5UX3t4bY3WaTCPr+2JuIQeLX2GpwTDX010Avd5AWvrTWYg2CdpOhR
         BUvqIr1i0IjJ68yxfSKWdjXDukpUggeH847MRAZCQ6J5lyzZjnvdb57e4fNaTd9KhJE4
         x2cA==
X-Gm-Message-State: AO0yUKWImRBV5tR4VtJ9FGyKXEvEpZrOrPp0p5nsDhyWMdcjz2adfk2N
        eSPAByfv2pgV5fUiFY57U74+OQlCMfGkVygWyYG/Wblj6EZmob69
X-Google-Smtp-Source: AK7set8eGuA9xzahNKv3/oCKsVNJxacuekfA/3ODRGh4Z8v6ZM+6ilkEorcRKlim/zT/8cnk5/dL771oyCsm4oVScLU=
X-Received: by 2002:a67:e953:0:b0:3f2:edef:718f with SMTP id
 p19-20020a67e953000000b003f2edef718fmr199778vso.28.1676361589322; Mon, 13 Feb
 2023 23:59:49 -0800 (PST)
MIME-Version: 1.0
References: <20230213144742.219399167@linuxfoundation.org>
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 14 Feb 2023 13:29:38 +0530
Message-ID: <CA+G9fYvJy-2b7O2SdEWPge9rMX=6tDVmv=ja1-+DGwrY9vZG1w@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/114] 6.1.12-rc1 review
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

On Mon, 13 Feb 2023 at 20:22, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.12 release.
> There are 114 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 15 Feb 2023 14:46:51 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.12-rc1.gz
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
* kernel: 6.1.12-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: 9012d1ebd3236e1d741ab4264f1d14e276c2e29f
* git describe: v6.1.11-115-g9012d1ebd323
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.1=
1-115-g9012d1ebd323

## Test Regressions (compared to v6.1.11)

## Metric Regressions (compared to v6.1.11)

## Test Fixes (compared to v6.1.11)

## Metric Fixes (compared to v6.1.11)

## Test result summary
total: 164976, pass: 145889, fail: 4799, skip: 14262, xfail: 26

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 145 total, 144 passed, 1 failed
* arm64: 47 total, 47 passed, 0 failed
* i386: 35 total, 34 passed, 1 failed
* mips: 26 total, 26 passed, 0 failed
* parisc: 6 total, 6 passed, 0 failed
* powerpc: 34 total, 30 passed, 4 failed
* riscv: 12 total, 12 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 40 total, 40 passed, 0 failed

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
* ltp-controllerllers
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

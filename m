Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3257E6CD8B0
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 13:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbjC2LoP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 07:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbjC2LoO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 07:44:14 -0400
Received: from mail-ua1-x935.google.com (mail-ua1-x935.google.com [IPv6:2607:f8b0:4864:20::935])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB8E64694
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 04:44:10 -0700 (PDT)
Received: by mail-ua1-x935.google.com with SMTP id h34so11115665uag.4
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 04:44:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680090249;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8BilmQkDuMQ2EpADhWFfuJAgpwFsD1GzcUMwdIRNZ0g=;
        b=t0tlJNAO/A+S9eHssQU1jbunoyVTkO4g2T0M0oANMxTCC1EX5V7UzIuaO+KSAVRS7G
         WChVbHEkBYaTTSAQm9PiWXVETs+CgwmqKfqFV5EnyCkun/8fIqlQjNWZEaKmCBgaPxvC
         M1GFRNUIX9fr57ktTp7bwDYaOcZitqKQYcZQqjlJtEoAawjrqYE90tmRnczSAklVd2qp
         dqcrlg5/bjFcCZhpyjrzYsJ7JR8YrfgiJAULp6/wGqexzIBKIrjmqbKFUoe2+xf7OMfB
         Oh32V4x7xloDEfIIFlJdw8KrRBkezKMooQ6xncyZbtF6zK3nAu+ZB7xUszWrfxsrj4sh
         c2zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680090249;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8BilmQkDuMQ2EpADhWFfuJAgpwFsD1GzcUMwdIRNZ0g=;
        b=KwM+0XAPy9J6BLip4x6BiEK5HAjAH+4eP/ayXCHeNNo/G97ayMxkg9f+qC8l0Ml8t5
         XhM3q8bluVhchus9Et6PSxqnzDD4iXUe+psgTf4gb5YQIYnoKWGwwBTChBKapSyRyyRn
         XnkTmWfz+8ls41876510KETs4PanXic/ZZR13UsS5Cu1UFiwuwQM88f728WLY7N5dWMI
         ixIKr/0ZSgw5XL+WZE0HzwVCBPIQiS0dR7A9M4BaRoQh2orgordajiZt19+AompNVb3M
         Tm4SezA+ecP95e94Iq2x3TTr5XAYbiZmxuoHaGTgGHZE+pfoVAXU1oHW0dt2JtimnZEm
         Ww0A==
X-Gm-Message-State: AAQBX9c0YRsk9xts4G63KZNv1aBcIVu3qeqBLQDVP6jv4rIAwT8BCkKv
        G/vOAwc8V5ZTskRJxbNzyEOfhRY04rA6+e187TxPNQ==
X-Google-Smtp-Source: AKy350YeKHwTpRdF6re6sdTt94p3AXD7UOWJNT8qtmyLRbAUljzBZBkCDeEGsYCsoxv4cMHHiK6C4Ay9CyH4E1LMaG4=
X-Received: by 2002:a1f:2fd8:0:b0:40c:4d1:b550 with SMTP id
 v207-20020a1f2fd8000000b0040c04d1b550mr10458113vkv.0.1680090249496; Wed, 29
 Mar 2023 04:44:09 -0700 (PDT)
MIME-Version: 1.0
References: <20230328142619.643313678@linuxfoundation.org>
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 29 Mar 2023 17:13:58 +0530
Message-ID: <CA+G9fYuypzL7H=xiVM8y8b5k1etL+79weW7DbBo_Mo=Nu597wg@mail.gmail.com>
Subject: Re: [PATCH 6.2 000/240] 6.2.9-rc1 review
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

On Tue, 28 Mar 2023 at 20:15, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.2.9 release.
> There are 240 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 30 Mar 2023 14:25:33 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.2.9-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.2.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.2.9-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.2.y
* git commit: 09974c3d7666f083563e3ebe423483b41766a78f
* git describe: v6.2.8-241-g09974c3d7666
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.2.y/build/v6.2.8=
-241-g09974c3d7666

## Test Regressions (compared to v6.2.8)

## Metric Regressions (compared to v6.2.8)

## Test Fixes (compared to v6.2.8)

## Metric Fixes (compared to v6.2.8)

## Test result summary
total: 200280, pass: 169003, fail: 4527, skip: 26456, xfail: 294

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 145 total, 142 passed, 3 failed
* arm64: 54 total, 53 passed, 1 failed
* i386: 41 total, 38 passed, 3 failed
* mips: 30 total, 28 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 38 total, 36 passed, 2 failed
* riscv: 26 total, 25 passed, 1 failed
* s390: 16 total, 16 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 7 passed, 1 failed
* x86_64: 46 total, 46 passed, 0 failed

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
* kselftest-exec
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
* kselftest-user_events
* kselftest-vDSO
* kselftest-vm
* kselftest-watchdog
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

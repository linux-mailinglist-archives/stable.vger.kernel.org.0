Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60E9C6EDFEB
	for <lists+stable@lfdr.de>; Tue, 25 Apr 2023 12:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233373AbjDYKCj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Apr 2023 06:02:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233255AbjDYKCh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Apr 2023 06:02:37 -0400
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FB343C0A
        for <stable@vger.kernel.org>; Tue, 25 Apr 2023 03:02:35 -0700 (PDT)
Received: by mail-vs1-xe36.google.com with SMTP id ada2fe7eead31-42ff08ab61dso1473663137.1
        for <stable@vger.kernel.org>; Tue, 25 Apr 2023 03:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1682416954; x=1685008954;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4I8ZpTXDhnTU+I/OGMe28Zi/nzoodj8x4VothnTu734=;
        b=L2xt4mUIZBwWG9sZOzScV5NHIMzd6RylX3DbeChtET8QaesfSEyZ3si7LGB5SwBT/m
         jUbSdZTbbSuXnWc3H7B58H3mflaz40uMQTND17EaIZ22n4o6oTQdKhaG3Vxqwg0qMBq9
         IvH9clkTvggGvWeKMyfIKofqnNK+8A7oupZwK2OYT4WImHR50ox/V+kYyqRHjMH25iOM
         dUCcz3EMKedd8bLZr3CA8Ji/ZwUn8a4n5k1p4K2pwmFmQ2tCeK/qrlFobtttiAvvx/w3
         Di8qZ7S07aMC4Gxz0u6nLOJoOtwtEE7x09aPSZulV3cTIBTYjnCVXBdx3yV2XMSfEeh4
         oMiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682416954; x=1685008954;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4I8ZpTXDhnTU+I/OGMe28Zi/nzoodj8x4VothnTu734=;
        b=O4LJJvX90X4GCqATm56pgksqZECzzpf3J1kHezvUOhoFTEjL01Ao5252qUhkQGweTX
         CNh5/nsd0eGo9GqIen3hHphiV6UTYghJuQmtCa5jDXCxxYECxWxJa2sqcL0Mxj3WvNa6
         Tjd8sv5GaZ4Z2+Yl15plSK6m8JDdZQtlow+tsT14/sKUHT2G3qLyaEgh4OqEaW/hpfhf
         6+JU3t2eQK5FNW7s5Jk/hluNBHwA92WEfMAWmoF2cyglxf1CFqgL/uk7am366dwuTe5f
         XVQXh5x9hjBgQZwxv+KBm+4Zg3Nj9VRt2Q1bGPPJZQeNs0MwnnK2o2hV1wPqrWTOag70
         AtOQ==
X-Gm-Message-State: AAQBX9eQboGLJc3DUV0HTUST7xTf1vJJff+JUn2msOmIWA4hEikvPjcO
        +lhnutJ9DBDPuX8ddouYrWwAtw2b9HwKFMArPlL+kQ==
X-Google-Smtp-Source: AKy350YphjRlr8Iu62yiLbOu9z8TiXpcMaX616ReKseBzJNtO6yiIVrQmQZ+Ur6KoyRoJ/22fu98MmL3LcK/6xnhTRY=
X-Received: by 2002:a67:f616:0:b0:426:20a8:a5b0 with SMTP id
 k22-20020a67f616000000b0042620a8a5b0mr7405718vso.13.1682416954309; Tue, 25
 Apr 2023 03:02:34 -0700 (PDT)
MIME-Version: 1.0
References: <20230424131121.155649464@linuxfoundation.org>
In-Reply-To: <20230424131121.155649464@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 25 Apr 2023 11:02:23 +0100
Message-ID: <CA+G9fYstB_fROK9LHYuQ8dc2ArieGGAW_x69eEX-eAi5xMeE3Q@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/29] 4.19.282-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        Mark Rutland <mark.rutland@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 24 Apr 2023 at 14:39, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.282 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 26 Apr 2023 13:11:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.282-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

FYI, This is not a show stopper but worth reporting.

NOTE:
Following kernel warning notices on stable rc  4.19.282-rc1 from the
previous releases 4.19.279-rc1 noticed on arm64, i386 and x86_64. After
this kernel warning the system is still stable and up and running.

This kernel is built with kselftest ftrace merge configs with all
required Kconfigs.

[    0.000000] Linux version 4.19.279-rc1 (tuxmake@tuxmake) (gcc
version 11.3.0 (Debian 11.3.0-11)) #1 SMP @1679324856
...
[    0.145911] ftrace: allocating 48590 entries in 190 pages
...

[    2.880223] WARNING: CPU: 0 PID: 0 at
include/trace/events/lock.h:13 lock_acquire+0x142/0x150
[    2.881454] WARNING: CPU: 1 PID: 0 at
include/trace/events/lock.h:58 lock_release+0x1af/0x280
[    2.881190] Modules linked in:
[    2.882221] Modules linked in:
[    2.881190] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.19.279-rc1 #1
[    2.882221] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 4.19.279-rc1 #1
[    2.881190] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.5 11/26/2020
[    2.881190] RIP: 0010:lock_acquire+0x142/0x150
[    2.882221] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.5 11/26/2020
[    2.882221] RIP: 0010:lock_release+0x1af/0x280
[    2.881190] Code: 59 48 85 c0 75 cf 45 89 cb 65 ff 0d 78 bd 23 6c
e9 24 ff ff ff 44 89 5d cc e8 9a 13 02 00 44 8b 5d cc 84 c0 0f 85 26
ff ff ff <0f> 0b e9 1f ff ff ff 0f 1f 80 00 00 00 00 8b 05 8a dc 90 01
85 c0
[    2.881190] RSP: 0000:ffffffff95603d50 EFLAGS: 00010046
[    2.882221] Code: ea 4c 89 e6 e8 42 80 02 01 48 8b 03 48 85 c0 75
e5 65 ff 0d 83 bf 23 6c e9 b1 fe ff ff e8 a9 15 02 00 84 c0 0f 85 bb
fe ff ff <0f> 0b e9 b4 fe ff ff e8 95 5e 41 00 85 c0 0f 84 52 ff ff ff
8b 35
[    2.882221] RSP: 0000:ffffbacc8193bda0 EFLAGS: 00010046
[    2.881190] RAX: 0000000000000000 RBX: 0000000000000046 RCX: 00000000000=
00002
[    2.881190] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff956=
7fe08
[    2.882221] RAX: 0000000000000000 RBX: 0000000000000046 RCX: 00000000000=
00100
[    2.882221] RDX: ffffffff93db7bab RSI: 0000000000000001 RDI: ffffffff956=
7fe08
[    2.881190] RBP: ffffffff95603d90 R08: 0000000000000001 R09: 00000000000=
00000
[    2.881190] R10: 0000000000000000 R11: 0000000000000001 R12: ffffffff956=
7fe08
[    2.882221] RBP: ffffbacc8193bde8 R08: 00000000483c81c9 R09: 00000000000=
80000
[    2.882221] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff956=
7fe08
[    2.881190] R13: 0000000000000000 R14: 0000000000000000 R15: 00000000000=
00002
[    2.881190] FS:  0000000000000000(0000) GS:ffff8f2da7800000(0000)
knlGS:0000000000000000
[    2.882221] R13: ffffffff93db7bab R14: ffffffff956f3f20 R15: 00000000000=
00001
[    2.882221] FS:  0000000000000000(0000) GS:ffff8f2da7880000(0000)
knlGS:0000000000000000
[    2.881190] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    2.881190] CR2: 0000000000000000 CR3: 00000002f621e001 CR4: 00000000003=
606f0
[    2.882221] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    2.882221] CR2: 0000000000000000 CR3: 00000002f621e001 CR4: 00000000003=
606e0
[    2.881190] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[    2.881190] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
[    2.882221] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[    2.882221] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
[    2.881190] Call Trace:
[    2.882221] Call Trace:
[    2.882221]  ktime_get+0x58/0x110
[    2.881190]  ktime_get+0x43/0x110
[    2.882221]  ? sched_clock_tick+0x6b/0x90
[    2.881190]  ? sched_clock_tick+0x6b/0x90
[    2.882221]  sched_clock_tick+0x6b/0x90
[    2.881190]  sched_clock_tick+0x6b/0x90
[    2.882221]  sched_clock_idle_wakeup_event+0x22/0x50
[    2.881190]  sched_clock_idle_wakeup_event+0x22/0x50
[    2.882221]  cpuidle_enter_state+0xd6/0x2e0
[    2.881190]  cpuidle_enter_state+0xd6/0x2e0
[    2.882221]  cpuidle_enter+0x17/0x20
[    2.881190]  cpuidle_enter+0x17/0x20
[    2.882221]  call_cpuidle+0x23/0x40
[    2.881190]  call_cpuidle+0x23/0x40
[    2.882221]  do_idle+0x1b9/0x240
[    2.881190]  do_idle+0x1b9/0x240
[    2.882221]  cpu_startup_entry+0x73/0x80
[    2.881190]  cpu_startup_entry+0x73/0x80
[    2.882221]  start_secondary+0x19e/0x1f0
[    2.881190]  rest_init+0x143/0x147
[    2.882221]  secondary_startup_64+0xa4/0xb0
[    2.881190]  start_kernel+0x487/0x4a9
[    2.882221] irq event stamp: 33604
[    2.881190]  x86_64_start_reservations+0x24/0x26
[    2.882221] hardirqs last  enabled at (33603): [<ffffffff93e23771>]
tick_nohz_idle_enter+0x61/0xa0
[    2.882221] hardirqs last disabled at (33604): [<ffffffff93db8d22>]
do_idle+0x72/0x240
[    2.881190]  x86_64_start_kernel+0x87/0x8b
[    2.882221] softirqs last  enabled at (33594): [<ffffffff94e002b6>]
__do_softirq+0x2b6/0x356
[    2.882221] softirqs last disabled at (33579): [<ffffffff93d83a1b>]
irq_exit+0xab/0xe0
[    2.881190]  secondary_startup_64+0xa4/0xb0
[    2.882221] ---[ end trace 257e6b641850f405 ]---
[    2.881190] irq event stamp: 51806
[    3.190254] thermal LNXTHERM:00: registered as thermal_zone0
[    2.881190] hardirqs last  enabled at (51805): [<ffffffff94b356ad>]
poll_idle+0x2d/0xa6
[    2.881190] hardirqs last disabled at (51806): [<ffffffff93db7bed>]
sched_clock_idle_wakeup_event+0x1d/0x50
[    2.881190] softirqs last  enabled at (51790): [<ffffffff93d82d21>]
_local_bh_enable+0x21/0x40
[    2.881190] softirqs last disabled at (51789): [<ffffffff93d83948>]
irq_enter+0x48/0x70
[    3.195448] ACPI: Thermal Zone [TZ00] (28 C)
[    2.881190] ---[ end trace 257e6b641850f406 ]---

Logs:
 - https://lkft.validation.linaro.org/scheduler/job/6373184#L889

History:
-------
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4=
.19.279-173-g8ca3c8d28616/testrun/16488263/suite/log-parser-boot/test/check=
-kernel-warning-ef0018e98767c447e2908013dcfcfeefa0f9b58524308b22e25e3958891=
408e5/history/

 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4=
.19.278-37-gc1beffa09ae6/testrun/15764758/suite/log-parser-boot/test/check-=
kernel-warning-ef0018e98767c447e2908013dcfcfeefa0f9b58524308b22e25e39588914=
08e5/log

 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4=
.19.279-173-g8ca3c8d28616/testrun/16487659/suite/log-parser-boot/test/check=
-kernel-warning-ef0018e98767c447e2908013dcfcfeefa0f9b58524308b22e25e3958891=
408e5/details/

 - https://storage.tuxsuite.com/public/linaro/lkft/builds/2OsIodn7l10ciOlEt=
qVm8nzAJyc/config

## Build
* kernel: 4.19.282-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: 8ca3c8d286160dca3bb13ae97a4a7a2d2fd4ad01
* git describe: v4.19.279-173-g8ca3c8d28616
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.279-173-g8ca3c8d28616

## Test Regressions (compared to v4.19.279-143-gcc0a9b81697f)

## Metric Regressions (compared to v4.19.279-143-gcc0a9b81697f)

## Test Fixes (compared to v4.19.279-143-gcc0a9b81697f)

## Metric Fixes (compared to v4.19.279-143-gcc0a9b81697f)

## Test result summary
total: 96887, pass: 72120, fail: 3496, skip: 21094, xfail: 177

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 108 total, 107 passed, 1 failed
* arm64: 34 total, 33 passed, 1 failed
* i386: 20 total, 19 passed, 1 failed
* mips: 22 total, 22 passed, 0 failed
* parisc: 6 total, 6 passed, 0 failed
* powerpc: 24 total, 24 passed, 0 failed
* s390: 6 total, 6 passed, 0 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 28 total, 27 passed, 1 failed

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
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org

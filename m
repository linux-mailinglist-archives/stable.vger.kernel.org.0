Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB0C2427C68
	for <lists+stable@lfdr.de>; Sat,  9 Oct 2021 19:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbhJIRnx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Oct 2021 13:43:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbhJIRnx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Oct 2021 13:43:53 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 988C3C061570
        for <stable@vger.kernel.org>; Sat,  9 Oct 2021 10:41:55 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id z20so48742518edc.13
        for <stable@vger.kernel.org>; Sat, 09 Oct 2021 10:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zqlcc2akw3mpTZ/8gJoDb++5yRRSnZEj8kCTG+LuqIo=;
        b=snPST1BUxGiHaqvrVC+K9m8n8dshaIPh2RO7HbyJ7//KUesrDuepxjw1G98ivRtBQH
         34QWjcnWGP1DNbIXdYIljv9VNe3gNOeAxIuW8phB1qIjTbdmQr2GYt+jmT2pK1dU5reU
         Vgny4XmuhWtRIA4sv+0nCrSQdgVGqRsKSvTj8W6VwC1ZqkIo1EpcGdMj8iK44p/XGS2q
         8NS/7maNCVWojw4o2RhWr7UyipAFQsR05x0Cci5SuftP3px2yiD1X+E4kNhUTrNpBBDj
         9ac7HCaEk0DHku/d6ZwGGZzTCfQSh4uyQ31f7Kdym0nn11pTo6y1vR7x8QcpWKZ6FY3J
         87Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zqlcc2akw3mpTZ/8gJoDb++5yRRSnZEj8kCTG+LuqIo=;
        b=tKM0GSUxBR00vAnvkIQ7fKSrTZQgo5lheEt/h1OHNr53T7ISFLJZ8IWtjv3DUhSs/V
         PeeZ8q5nomFoLIhGh3fTcJPWKwAHf15k26ht0ue7pOCJQ+JgbqEFAAx/QwhUvNfALnRd
         BgEhMLRkoX11Qn3snF6GaDsLfARa9PZ0zEYcCs8AGBVSI0/E+qh3Na46Z8BTdmO4Ghq8
         zYrxpy6cGUHOVuv3Hz4wjpvudXB65ARSZ72IO6vXST6CZRkicMJHh8b1/esaZPF2GDiV
         erSFEshegEHZdUBvVAoUfWxVQKCphCPpdegSgmkHxPPnAF5SneL1huSKY61/ekPL7X6f
         y0gw==
X-Gm-Message-State: AOAM532BgCzSF4dozT+dNwMaJzdINoHHffTTBbmzxF05Ug+w9BkNaILh
        /VU3/On65uuyl0Hpbrm4FaVxNxOWx3AC1rd6mbIvNQ==
X-Google-Smtp-Source: ABdhPJy3Prrh4QPTCFqgzKo1nvkwFnHMo6vmLjE61NlIvE6jhuzO/25dG26h3MbkU/OkISyFXmm74GcB/lHcByD5apo=
X-Received: by 2002:a17:906:7016:: with SMTP id n22mr12786760ejj.567.1633801313782;
 Sat, 09 Oct 2021 10:41:53 -0700 (PDT)
MIME-Version: 1.0
References: <20211008112714.601107695@linuxfoundation.org>
In-Reply-To: <20211008112714.601107695@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sat, 9 Oct 2021 23:11:42 +0530
Message-ID: <CA+G9fYvOK+5qPEU7RMfD1O5O3EwTfThoh3Le9Rx8GDhY3nY1Ww@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/12] 4.19.210-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        LTP List <ltp@lists.linux.it>,
        Richard Palethorpe <rpalethorpe@suse.com>,
        Cyril Hrubis <chrubis@suse.cz>, Li Wang <liwang@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 8 Oct 2021 at 17:00, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.210 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 10 Oct 2021 11:27:07 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.210-rc1.gz
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

NOTE:
LTP version upgrade to LTP 20210927.
The new case "cfs_bandwidth01" found the following warning.
Since it is a new test case that found this warning can not be considered a=
s
regression.
This warning is only seen on stable rc 4.19
but not found on 4.14, 5.4, 5.10 and 5.14.

Test output log:
----------------
cfs_bandwidth01.c:57: TINFO: Set 'worker1/cpu.max' =3D '3000 10000'
cfs_bandwidth01.c:57: TINFO: Set 'worker2/cpu.max' =3D '2000 10000'
cfs_bandwidth01.c:57: TINFO: Set 'worker3/cpu.max' =3D '3000 10000'
cfs_bandwidth01.c:118: TPASS: Scheduled bandwidth constrained workers
cfs_bandwidth01.c:57: TINFO: Set 'level2/cpu.max' =3D '5000 10000'
cfs_bandwidth01.c:130: TPASS: Workers exited
cfs_bandwidth01.c:118: TPASS: Scheduled bandwidth constrained workers
cfs_bandwidth01.c:57: TINFO: Set 'level2/cpu.max' =3D '5000 10000'
cfs_bandwidth01.c:130: TPASS: Workers exited
cfs_bandwidth01.c:118: TPASS: Scheduled bandwidth constrained work[
56.624213] ------------[ cut here ]------------
[   56.629421] rq->tmp_alone_branch !=3D &rq->leaf_cfs_rq_list
[   56.629439] WARNING: CPU: 2 PID: 0 at kernel/sched/fair.c:375
unthrottle_cfs_rq+0x1f7/0x220
[   56.643189] Modules linked in: x86_pkg_temp_thermal
[   56.648073] CPU: 2 PID: 0 Comm: swapper/2 Not tainted 4.19.210-rc1 #1
[   56.654515] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.2 05/23/2018
[   56.661908] RIP: 0010:unthrottle_cfs_rq+0x1f7/0x220
[   56.666779] Code: 87 b7 00 0f 0b e9 8a fe ff ff 80 3d c5 a5 7a 01
00 0f 85 4d ff ff ff 48 c7 c7 d0 1f 94 87 c6 05 b1 a5 7a 01 01 e8 26
87 b7 00 <0f> 0b 48 85 db 0f 84 70 ff ff ff e9 2a ff ff ff 31 db 80 3d
93 a5
[   56.685515] RSP: 0018:ffff945e2f903e48 EFLAGS: 00010086
[   56.690731] RAX: 0000000000000000 RBX: ffff945de35b0e00 RCX: 00000000000=
00000
[   56.697855] RDX: 0000000000000000 RSI: ffffffff87fb8c8d RDI: ffffffff87f=
b908d
[   56.704979] RBP: ffff945e2f903e70 R08: 0000000d2f6066af R09: ffff945e2f9=
03de0
[   56.712102] R10: 0000000000000000 R11: ffffffff87fb886d R12: ffff945e2df=
6b800
[   56.719228] R13: ffff945e2f89fbc0 R14: 0000000000000001 R15: 00000000000=
00001
[   56.726353] FS:  0000000000000000(0000) GS:ffff945e2f900000(0000)
knlGS:0000000000000000
[   56.734429] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   56.740165] CR2: 00000000006333e8 CR3: 000000014a20a003 CR4: 00000000003=
606e0
[   56.747290] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[   56.754412] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
[   56.761536] Call Trace:
[   56.763980]  <IRQ>
[   56.765992]  distribute_cfs_runtime+0xd1/0x120
[   56.770428]  sched_cfs_period_timer+0xbb/0x210
[   56.774868]  __hrtimer_run_queues+0x131/0x2b0
[   56.779216]  ? sched_cfs_slack_timer+0xc0/0xc0
[   56.783656]  hrtimer_interrupt+0xfe/0x290
[   56.787667]  ? tick_irq_enter+0xab/0xd0
[   56.791499]  smp_apic_timer_interrupt+0x73/0x140
[   56.796117]  apic_timer_interrupt+0xf/0x20
[   56.800206]  </IRQ>
[   56.802306] RIP: 0010:cpuidle_enter_state+0x119/0x2c0
[   56.807349] Code: 77 ff 80 7d c7 00 74 12 9c 58 f6 c4 02 0f 85 8e
01 00 00 31 ff e8 c7 1d 7d ff e8 22 85 82 ff fb 48 ba cf f7 53 e3 a5
9b c4 20 <4c> 2b 7d c8 4c 89 f8 49 c1 ff 3f 48 f7 ea b8 ff ff ff 7f 48
c1 fa
[   56.826086] RSP: 0018:ffffa81440cfbe50 EFLAGS: 00000286 ORIG_RAX:
ffffffffffffff13
[   56.833642] RAX: ffffa81440cfbe90 RBX: ffff945e2e2ee800 RCX: 00000000000=
0001f
[   56.840780] RDX: 20c49ba5e353f7cf RSI: ffffffff86e286f7 RDI: ffffffff86e=
2850e
[   56.847908] RBP: ffffa81440cfbe90 R08: 0000000d2f10ca02 R09: 00000000fff=
fffff
[   56.855031] R10: 000000000000024a R11: ffff945e2f91ed08 R12: 00000000000=
00001
[   56.862156] R13: ffffffff87cca620 R14: ffffffff87cca680 R15: 0000000d2f1=
0ca02
[   56.869279]  ? cpuidle_enter+0x17/0x20
[   56.873024]  ? cpuidle_enter_state+0x10e/0x2c0
[   56.877461]  cpuidle_enter+0x17/0x20
[   56.881029]  call_cpuidle+0x23/0x40
[   56.884515]  do_idle+0x1b9/0x240
[   56.887740]  cpu_startup_entry+0x73/0x80
[   56.891654]  start_secondary+0x197/0x1e0
[   56.895574]  secondary_startup_64+0xa4/0xb0
[   56.899751] ---[ end trace 20fd56519aa6c3c8 ]---
ers
cfs_bandwidth01.c:57: TINFO: Set 'level2/cpu.max' =3D '5000 10000'
cfs_bandwidth01.c:130: TPASS: Workers exited
cfs_bandwidth01.c:118: TPASS: Scheduled bandwidth constrained workers
cfs_bandwidth01.c:57: TINFO: Set 'level2/cpu.max' =3D '5000 10000'
cfs_bandwidth01.c:130: TPASS: Workers exited
cfs_bandwidth01.c:118: TPASS: Scheduled bandwidth constrained workers
cfs_bandwidth01.c:57: TINFO: Set 'level2/cpu.max' =3D '5000 10000'
cfs_bandwidth01.c:130: TPASS: Workers exited
tst_test.c:1401: TFAIL: Kernel is now tainted.

HINT: You _MAY_ be missing kernel fixes, see:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D39f23ce07b93
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3Db34cb07dde7c
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3Dfe61468b2cbc
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D5ab297bab984
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D6d4d22468dae
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3Dfdaba61ef8a2

URL:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.209-13-g0cf6c1babdb5/testrun/6034624/suite/linux-log-parser/test/check-ker=
nel-warning-3690612/log

## Build
* kernel: 4.19.210-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: 0cf6c1babdb51acc917475373133f5d05d584d35
* git describe: v4.19.209-13-g0cf6c1babdb5
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.209-13-g0cf6c1babdb5

## No regressions (compared to v4.19.209-13-g1c111a02b49d)

## No fixes (compared to v4.19.209-13-g1c111a02b49d)

## Test result summary
total: 80521, pass: 65633, fail: 663, skip: 12565, xfail: 1660

## Build Summary
* arm: 258 total, 258 passed, 0 failed
* arm64: 74 total, 74 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 35 total, 35 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 58 total, 58 passed, 0 failed
* s390: 24 total, 24 passed, 0 failed
* sparc: 24 total, 24 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 42 total, 42 passed, 0 failed

## Test suites summary
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
* kvm-unit-tests
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

--
Linaro LKFT
https://lkft.linaro.org

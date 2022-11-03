Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27E63617AB2
	for <lists+stable@lfdr.de>; Thu,  3 Nov 2022 11:18:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbiKCKSs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Nov 2022 06:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbiKCKSr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Nov 2022 06:18:47 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D882065FE
        for <stable@vger.kernel.org>; Thu,  3 Nov 2022 03:18:45 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id f5so3906295ejc.5
        for <stable@vger.kernel.org>; Thu, 03 Nov 2022 03:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AG4E+DIBCMnjapiY88COoJafm5Not7vc7TuLyyzyLHQ=;
        b=lj6hyEbtBxSnCng4KWa93jxymV+o/vabOwA7XUE1hjiwWVJAq59h4BZq94vK6X/k81
         rYX2Lv1aF8RWKUx2bZVjYfur0BKuR52qwlLPv1KbA7Y8ifL2JYGvBZ0PMldj3VdxFX5H
         91JY/TgnIJSKzZ9VLCpsreO+s/ZLvnW/ttWY1XoRUIIpx249EdhdYVf2K13OuzW5p9p9
         GazUHV243Fl1HfzxWCOQ4gf/SClzaR1HeqPKFNeu1sF+TnAgE1zTEE2oO2DMCD3Fl8C5
         a4lqL5LCvcLEq4uk4SXNdvns56jnfZHhMIywF4PQNkRcEeon1QDDxHfNIuz/ucKWWYbd
         Pn2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AG4E+DIBCMnjapiY88COoJafm5Not7vc7TuLyyzyLHQ=;
        b=13dnZhnaFPumHxJ6l2d1/6y7+cWBk4OSmSNiCOBRpPoPF8chfaj5Ls4jStqmdjQYU1
         Q9Ufz5xXCLEI6RV8yGjOIGb1Fa3G+clpVnxYzCpyPK7Se7bWauwL/exMDXRYBaWJq4mk
         bkqGQFTdRUMIIXAvkVcYflOxhsnz6oTQrmco+o+jaYgE96zRM8z1OZkKFgfPekjT0Irm
         937E7KRBr3YrcOQ3Uiv3+cS/+B14J41NmNnKE9cKI8Jcy+hdi5tZO6ilv1xSy4SVK/zP
         f0oKeZF6Nl9pZdjmiEtFewR8fT8702XbPEblHXJ33/XOUrXD2z2IJnnF6AKV8IefdCVV
         XyFg==
X-Gm-Message-State: ACrzQf0s/zymc2zWbXOQpeJbzjlImuEgmE4xbjyQnRt5YFgUBqBqSAeN
        Je/8OETC4kcrczwLIbCDFNq/+YjmwsO/Am9creVSAw==
X-Google-Smtp-Source: AMsMyM4qZzxhJTTWh1i9RgeANyKPlPdqqrTsKFhC3rqFiWN/Q/cPsIS5y6PUQTXpZgSirwwO93Xx/J/1smpkgJZ+VTM=
X-Received: by 2002:a17:906:fe45:b0:788:15a5:7495 with SMTP id
 wz5-20020a170906fe4500b0078815a57495mr28416943ejb.633.1667470724076; Thu, 03
 Nov 2022 03:18:44 -0700 (PDT)
MIME-Version: 1.0
References: <20221102022052.895556444@linuxfoundation.org>
In-Reply-To: <20221102022052.895556444@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 3 Nov 2022 15:48:32 +0530
Message-ID: <CA+G9fYvdCbMc4zcOEow68CkcMXQz3bye8h48AH2uUwkNctAjOg@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/78] 4.19.264-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        LTP List <ltp@lists.linux.it>,
        Richard Palethorpe <rpalethorpe@suse.com>,
        Cyril Hrubis <chrubis@suse.cz>, Li Wang <liwang@redhat.com>
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

On Wed, 2 Nov 2022 at 08:58, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.264 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 04 Nov 2022 02:20:38 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.264-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
Results from Linaro=E2=80=99s test farm.
No regressions on arm, x86_64, and i386.

Regression on arm64 Juno-r2.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Following kernel panic noticed while running LTP controllers test cases
on arm64 Juno device.

Since this crash was noticed for the first time, I am re-running tests
multiple times
to check reproducibility.

Crash log:
    [ 1952.270907] Kernel panic - not syncing: stack-protector: Kernel
stack is corrupted in: cpu_suspend+0xe4/0x100
    [ 1952.283623] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 4.19.264-rc1 #=
1
    [ 1952.292846] Hardware name: ARM Juno development board (r2) (DT)
    ...
    /opt/ltp/testcases/bin/cgroup_fj_stress.sh: line 155: 263607
Killed                  cgroup_fj_proc
    /opt/ltp/testcases/bin/cgroup_fj_stress.sh: line 155: 263610
Killed                  cgroup_fj_proc
    /opt/ltp/testcases/bin/cgroup_fj_stress.sh: line 155: 263613
Killed                  cg[ 1952.568781] Call trace:
    [ 1952.571231]  dump_backtrace+0x0/0x190
    [ 1952.574896]  show_stack+0x28/0x34
    [ 1952.578215]  dump_stack+0xb0/0xf8
    [ 1952.581533]  panic+0x134/0x2a4
    [ 1952.584590]  print_tainted+0x0/0xbc
    [ 1952.588080]  cpu_suspend+0xe4/0x100
    [ 1952.591572]  set_next_entity+0x9c/0x680
    [ 1952.595411]  0x1000
    [ 1952.597515] SMP: stopping secondary CPUs
    [ 1952.601605] Kernel Offset: disabled
    [ 1952.605095] CPU features: 0x30,24006004
    [ 1952.608932] Memory Limit: none
    [ 1952.611998] ---[ end Kernel panic - not syncing:
stack-protector: Kernel stack is corrupted in: cpu_suspend+0xe4/0x100
]---
    [1] https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/bui=
ld/v4.19.263-79-g0b4109336122/testrun/12819498/suite/log-parser-test/test/c=
heck-kernel-panic/log
    [2] https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/bui=
ld/v4.19.263-79-g0b4109336122/testrun/12819498/suite/log-parser-test/tests/

    metadata:
      git_ref: linux-4.19.y
      git_repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-=
rc
      git_sha: 0b4109336122dd3dfbb07964274c085c54f57b92
      git_describe: v4.19.263-79-g0b4109336122
      kernel_version: 4.19.264-rc1
      kernel-config:
https://builds.tuxbuild.com/2GyM098gpfPdt953z6Er1WVtalJ/config
      build-url:
https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/pipelines/6=
83032116
      artifact-location: https://builds.tuxbuild.com/2GyM098gpfPdt953z6Er1W=
VtalJ
      toolchain: gcc-11

NOTE:
-----
While running newly added LTP sched cfs_bandwidth01 test case we have been
getting the following kernel warning from a couple of months on all devices=
.

    tst_test.c:1524: TINFO: Timeout per run is 0h 05m 00s
    cfs_bandwidth01.c:54: TINFO: Set 'worker1/cpu.max' =3D '3000 10000'
    cfs_bandwidth01.c:54: TINFO: Set 'worker2/cpu.max' =3D '2000 10000'
    cfs_bandwidth01.c:54: TINFO: Set 'worker3/cpu.max' =3D '3000 10000'
    cfs_bandwidth01.c:117: TPASS: Scheduled bandwidth constrained workers
    cfs_bandwidth01.c:54: TINFO: Set 'level2/cpu.max' =3D '5000 10000'
    ------------[ cut here ]------------
    [   57.048506] rq->tmp_alone_branch !=3D &rq->leaf_cfs_rq_list
    [   57.048525] WARNING: CPU: 2 PID: 3250 at
kernel/sched/fair.c:375 enqueue_task_fair+0x55f/0x5e0
    [   57.062526] Modules linked in: x86_pkg_temp_thermal
    [   57.067399] CPU: 2 PID: 3250 Comm: cfs_bandwidth01 Not tainted
4.19.264-rc1 #1
    [   57.074619] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F,
BIOS 2.5 11/26/2020
    [   57.082012] RIP: 0010:enqueue_task_fair+0x55f/0x5e0
    [   57.086889] Code: e8 96 b6 5a 01 e9 49 fb ff ff 80 3d ed 25 7e
02 00 0f 85 4e fc ff ff 48 c7 c7 80 34 68 90 c6 05 d9 25 7e 02 01 e8
71 c6 30 01 <0f> 0b e9 34 fc ff ff 49 8d bf b8 09 00 00 e8 ee ee 22 00
49 8b 9f
    [   57.105628] RSP: 0018:ffff88840a2f7978 EFLAGS: 00010082
    [   57.110851] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
0000000000000000
    [   57.117976] RDX: 000000000000002d RSI: ffffffff9191404d RDI:
ffffed108145ef21
    [   57.125101] RBP: ffff88840a2f79b0 R08: 0000000000000001 R09:
fffffbfff23228a5
    [   57.132223] R10: ffffffff9191452c R11: 0000000000000346 R12:
ffff888428832e80
    [   57.139348] R13: ffff888428832e00 R14: 0000000000000001 R15:
ffff888428832e00
    [   57.146474] FS:  00007f2ff1555740(0000)
GS:ffff888428900000(0000) knlGS:0000000000000000
    [   57.154558] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    [   57.160295] CR2: 00007f2ff1585990 CR3: 000000040ae98004 CR4:
00000000003606e0
    [   57.167421] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
    [   57.174553] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
    [   57.181685] Call Trace:
    [   57.184132]  ? remove_entity_load_avg+0x12a/0x140
    [   57.188837]  activate_task+0x90/0x130
    [   57.192501]  ttwu_do_activate+0x64/0xd0
    [   57.196333]  try_to_wake_up+0x3d5/0x730
    [   57.200172]  ? set_cpus_allowed_ptr+0x20/0x20
    [   57.204531]  ? plist_del+0xcc/0x120
    [   57.208023]  ? kasan_check_write+0x14/0x20
    [   57.212121]  wake_up_q+0x50/0x90
    [   57.215348]  futex_wake+0x2a5/0x2d0
    [   57.218840]  ? mark_wake_futex+0xc0/0xc0
    [   57.222766]  ? __schedule+0x440/0xdf0
    [   57.226430]  ? io_schedule_timeout+0xc0/0xc0
    [   57.230695]  do_futex+0xb53/0x11b0
    [   57.234101]  ? do_nanosleep+0x1f7/0x300
    [   57.237939]  ? schedule_timeout_idle+0x40/0x40
    [   57.242378]  ? __vfs_write+0x354/0x3d0
    [   57.246129]  ? futex_exit_release+0x120/0x120
    [   57.250481]  ? hrtimer_init+0xac/0x170
    [   57.254226]  ? hrtimer_nanosleep+0x17d/0x320
    [   57.258498]  ? ktime_get_coarse_real_ts64+0x50/0x70
    [   57.263377]  ? __audit_syscall_entry+0x1a6/0x1e0
    [   57.267995]  __x64_sys_futex+0x12d/0x260
    [   57.271914]  ? __ia32_compat_sys_futex+0x260/0x260
    [   57.276706]  ? __audit_syscall_exit+0x366/0x410
    [   57.281238]  ? trace_hardirqs_off_caller+0x33/0xf0
    [   57.286022]  do_syscall_64+0x6d/0x170
    [   57.289681]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
    [   57.294731] RIP: 0033:0x7f2ff165cf2d
    [   57.298304] Code: 5b 41 5c c3 66 0f 1f 84 00 00 00 00 00 f3 0f
1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c
24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d c3 ae 0e 00 f7 d8 64
89 01 48
    [   57.317047] RSP: 002b:00007ffc68c732d8 EFLAGS: 00000202
ORIG_RAX: 00000000000000ca
    [   57.324604] RAX: ffffffffffffffda RBX: 0000000000000000 RCX:
00007f2ff165cf2d
    [   57.331729] RDX: 000000007fffffff RSI: 0000000000000001 RDI:
00007f2ff179101c
    [   57.338852] RBP: 0000000000000000 R08: 00007ffc68c72c70 R09:
0000000000000000
    [   57.345979] R10: 0000000000000000 R11: 0000000000000202 R12:
0000000000000000
    [   57.353110] R13: 0000000000000009 R14: 0000000000002710 R15:
00007f2ff1794000
    [   57.360235] ---[ end trace d653d2b9595e14a0 ]---
    ...
    tst_test.c:1564: TFAIL: Kernel is now tainted.
    HINT: You _MAY_ be missing kernel fixes:
    https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?id=3D39f23ce07b93
    https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?id=3Db34cb07dde7c
    https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?id=3Dfe61468b2cbc
    https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?id=3D5ab297bab984
    https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?id=3D6d4d22468dae
    https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?id=3Dfdaba61ef8a2
    Summary:
    passed   10
    failed   1

    https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v=
4.19.263-79-g0b4109336122/testrun/12814380/suite/log-parser-test/tests/
    https://lkft.validation.linaro.org/scheduler/job/5796548#L1728
    https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v=
4.19.263-79-g0b4109336122/testrun/12814380/suite/ltp-sched/test/cfs_bandwid=
th01/history/

## Build
* kernel: 4.19.264-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: 0b4109336122dd3dfbb07964274c085c54f57b92
* git describe: v4.19.263-79-g0b4109336122
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.263-79-g0b4109336122

## No Test Regressions (compared to v4.19.263)

## No Metric Regressions (compared to v4.19.263)

## No Test Fixes (compared to v4.19.263)

## No Metric Fixes (compared to v4.19.263)

## Test result summary
total: 123866, pass: 103614, fail: 2130, skip: 17181, xfail: 941

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 323 total, 318 passed, 5 failed
* arm64: 61 total, 60 passed, 1 failed
* i386: 29 total, 28 passed, 1 failed
* mips: 46 total, 46 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 63 total, 63 passed, 0 failed
* s390: 15 total, 15 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 55 total, 54 passed, 1 failed

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
* kselftest-breakpoints
* kselftest-capabilities
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
* ltp-open-posix-tests
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* packetdrill
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org

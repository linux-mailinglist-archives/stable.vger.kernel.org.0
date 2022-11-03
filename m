Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD2AF6177A8
	for <lists+stable@lfdr.de>; Thu,  3 Nov 2022 08:27:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbiKCH1W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Nov 2022 03:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbiKCH1V (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Nov 2022 03:27:21 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6206C2619
        for <stable@vger.kernel.org>; Thu,  3 Nov 2022 00:27:20 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id sc25so2837941ejc.12
        for <stable@vger.kernel.org>; Thu, 03 Nov 2022 00:27:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ss2WJtlIw0ZS+QIn2jOb+g9SLpZq/UP89l+IYvxw//Q=;
        b=XeEaXUkRKO1qyrA0Cn6xb4Nv3nDo/uKP1qwSFrT/kyZe0Sc1vJ2Yr5ovvyqN1yFmQ4
         ZzhgO1kn0QQH9+o4oFuKJ10YmN4WPzj5naR2s1KbKc9gc348nByWDKpieuyzFcZ4ACqb
         Kw7n9+M1JQFXe+gqZ3TZ2oVpTSLp2r0NN/lSdLXko74yCN+KXkrjpQGDzt2P1mzdQD58
         xV3oQvxAtRzarZeCwd4jQyLtMmX6tZOP+bWVkufHWybuDzhCSZwCzynUbV++yPCDW7CQ
         yKsc7cn372/KC1b/fH38t2IcBc7dGNSTqJk2xpNrwZufk2mr/Idcas+ywzxnVlg0v8AR
         ce9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ss2WJtlIw0ZS+QIn2jOb+g9SLpZq/UP89l+IYvxw//Q=;
        b=WhjA790PMjFmn/mNnwvBZ/KxCzHAmi3cVBbnjeGVh1Ake1NWOAhbfK0eULCS1wr0hq
         f7TsQPi+Ets+K3xPea1T3dfPihb7/ih47UoyB4MvsVQaSsOr9FjtU5L5r1B2I3XiML2X
         aGPV5M7O5L4yIk5SvEIoXY5Z5DJ7PD+MbHEnCLpEzf/3d3IIODuEmCCzmID6jLpDATLw
         sf9Xar3jYAvo14zguOvg3F1FG78xDBKTAk6+UoxaVqeX5yJDxoB2xntObApVH5XBdxZ4
         Cqbs68BzRMGrY3Fco33F7UGjOI2Bnd2klABgZlbvVtsFiAQ4bYQPHEIbJQzp4cpO4PWM
         sBlQ==
X-Gm-Message-State: ACrzQf3S+3w19MFpFk5xKtWmnUJE4VIMhnJmzqBkKeSNULtlna3UuAa2
        HB8jYtsb/QhHBuHDA+JkltxNt+4QhIunq03lFOcIyZMdU6ATGg==
X-Google-Smtp-Source: AMsMyM5fwZ6Ab/hUw8w7DuQC94GdTZ83TiwRScgdPfZlQNhcXp32asxrMwpMbLQolYIrkpMjuGoTYWvllY+rzuj6yUE=
X-Received: by 2002:a17:907:7b93:b0:770:1d4f:4de9 with SMTP id
 ne19-20020a1709077b9300b007701d4f4de9mr28111469ejc.201.1667460438726; Thu, 03
 Nov 2022 00:27:18 -0700 (PDT)
MIME-Version: 1.0
References: <20221102022055.039689234@linuxfoundation.org>
In-Reply-To: <20221102022055.039689234@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 3 Nov 2022 12:57:07 +0530
Message-ID: <CA+G9fYuWi1GXg0Zj=utpoUpMiN_HWtW9Y1p8QUkXb98r1Gnz1Q@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/91] 5.10.153-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
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

On Wed, 2 Nov 2022 at 08:42, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.153 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 04 Nov 2022 02:20:38 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.153-rc1.gz
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

NOTE:
1)
Build failures: Perf on arm64/i386/x86 on 5.4/5.10/5.15, not on arm32.
perf build started to pass on stable-rc 6.0 and mainline and next
master branches.

Build error:
util/annotate.c: In function 'symbol__disassemble_bpf':
util/annotate.c:1739:9: error: too few arguments to function
'init_disassemble_info'
 1739 |         init_disassemble_info(&info, s,
      |         ^~~~~~~~~~~~~~~~~~~~~
In file included from util/annotate.c:1692:
/usr/include/dis-asm.h:472:13: note: declared here
  472 | extern void init_disassemble_info (struct disassemble_info
*dinfo, void *stream,
      |             ^~~~~~~~~~~~~~~~~~~~~
make[4]: *** [/    tools/build/Makefile.build:97:
/home/tuxbuild/.cache/tuxmake/builds/1/build/util/annotate.o] Error 1

Build log link,
https://builds.tuxbuild.com/2GyMi25XnyDaaKJ170L0VWShkT9/

2)
Following kernel warning always noticed on x86_64 with list of
kselftest merge configs enabled.

This is not a regression this warning has been occuring from the day
we have enabled
kselfest runs on stable-rc 5.10.

[    0.256413] RETBleed: Mitigation: untrained return thunk
[    0.257416] Spectre V2 : mitigation: Enabling conditional Indirect
Branch Prediction Barrier
[    0.258415] Speculative Store Bypass: Mitigation: Speculative Store
Bypass disabled via prctl and seccomp
[    0.269751] ------------[ cut here ]------------
[    0.270425] missing return thunk:
lkdtm_rodata_do_nothing+0x0/0x10-lkdtm_rodata_do_nothing+0x5/0x10: e9
00 00 00 00
[    0.270447] WARNING: CPU: 0 PID: 0 at
arch/x86/kernel/alternative.c:712 apply_returns+0x1ca/0x1f0
[    0.272414] Modules linked in:
[    0.273419] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.10.153-rc1 #1
[    0.274416] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 1.12.0-1 04/01/2014
[    0.275417] RIP: 0010:apply_returns+0x1ca/0x1f0
[    0.276416] Code: 05 02 00 0f 85 0d ff ff ff 4d 89 e0 b9 05 00 00
00 4c 89 fa 4c 89 e6 48 c7 c7 30 f3 e4 ae c6 05 f7 1f 05 02 01 e8 0b
64 08 01 <0f> 0b e9 e5 fe ff ff c7 45 c1 cc cc cc cc c7 44 10 fc cc cc
cc cc
[    0.277414] RSP: 0000:ffffffffaf203d98 EFLAGS: 00010282
[    0.278414] RAX: 0000000000000000 RBX: ffffffffaf7941f8 RCX: 00000000000=
00000
[    0.279414] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffffad6=
4d062
[    0.280414] RBP: ffffffffaf203e60 R08: 0000000000000001 R09: 00000000000=
00001
[    0.281413] R10: ffffffffaf2998e0 R11: ffffffffaf2998e0 R12: ffffffffaea=
f8c60
[    0.282414] R13: ffffffffaf7b2f18 R14: cccccccccccccccc R15: ffffffffaea=
f8c65
[    0.283416] FS:  0000000000000000(0000) GS:ffff8a53fbc00000(0000)
knlGS:0000000000000000
[    0.284416] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.285414] CR2: ffff8a53fffff000 CR3: 0000000021e26000 CR4: 00000000003=
506f0
[    0.286415] Call Trace:
[    0.286787]  ? apply_retpolines+0x5e/0x2a0
[    0.287421]  ? _cond_resched+0x1a/0x60
[    0.287987]  alternative_instructions+0x7d/0x13f
[    0.288416]  check_bugs+0xeed/0xf2e
[    0.289418]  start_kernel+0x515/0x54c
[    0.289968]  x86_64_start_reservations+0x24/0x2a
[    0.290415]  x86_64_start_kernel+0x9d/0xa5
[    0.291417]  secondary_startup_64_no_verify+0xc2/0xcb
[    0.292174] irq event stamp: 1709
[    0.292418] hardirqs last  enabled at (1721): [<ffffffffad64d062>]
console_unlock+0x502/0x5e0
[    0.293415] hardirqs last disabled at (1732): [<ffffffffad64cfbd>]
console_unlock+0x45d/0x5e0
[    0.294417] softirqs last  enabled at (1742): [<ffffffffad5cee36>]
irq_enter_rcu+0x76/0x80
[    0.295415] softirqs last disabled at (1753): [<ffffffffad5cee1b>]
irq_enter_rcu+0x5b/0x80
[    0.296418] ---[ end trace 665160b92b6d6ceb ]---

https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.152-92-g2f6e4754098c/testrun/12812412/suite/log-parser-boot/tests/
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.152-92-g2f6e4754098c/testrun/12812412/suite/log-parser-boot/test/check-ker=
nel-exception/log

## Build
* kernel: 5.10.153-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 2f6e4754098c797c9befbb1c13ea97e89dbd665f
* git describe: v5.10.152-92-g2f6e4754098c
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.152-92-g2f6e4754098c

## No Test Regressions (compared to v5.10.152)

## No Metric Regressions (compared to v5.10.152)

## No Test Fixes (compared to v5.10.152)

## No Metric Fixes (compared to v5.10.152)

## Test result summary
total: 148664, pass: 125743, fail: 3265, skip: 19222, xfail: 434

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 149 total, 148 passed, 1 failed
* arm64: 47 total, 45 passed, 2 failed
* i386: 37 total, 35 passed, 2 failed
* mips: 27 total, 27 passed, 0 failed
* parisc: 6 total, 6 passed, 0 failed
* powerpc: 28 total, 23 passed, 5 failed
* riscv: 12 total, 12 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 40 total, 38 passed, 2 failed

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

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23E961BD7F3
	for <lists+stable@lfdr.de>; Wed, 29 Apr 2020 11:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbgD2JIq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Apr 2020 05:08:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726426AbgD2JIp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Apr 2020 05:08:45 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 840D4C03C1AD
        for <stable@vger.kernel.org>; Wed, 29 Apr 2020 02:08:43 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id 188so998369lfa.10
        for <stable@vger.kernel.org>; Wed, 29 Apr 2020 02:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=V11kStv5/sKOZniMa+ze+SUzqT6DVb9H+g1pL00yaUk=;
        b=XDpFa1RSD9u6wC3i4ZcA9szmxLOuT94wDHGtf3/yzSF5RZ/rEC8VBZOZhky0IGpri7
         b0y3hZ5mFEoO6S7pbPCYOQ7SmI5mMuJAX7K9Y61tapHDE6LIDWDx8BpERs1IUWsXHAM7
         tbI5j0j83O4c0LNC5kXiX9hAykpBQqpXSRAWdZcxiiXpEKbURhSeFPE9B3P6qDIP846r
         SngGdBK4OXpEWvxWrDoPNHIEMtosdPeRxDJ1RuZasDUaC4oc/sIetbLHruCuTHsO6TEF
         MUNVF0KLPCE6e49glPou7BdZkU+KzbntxJagGSq2lksom2zhwlw1pVUj9yDFqiqEAjFA
         NEhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=V11kStv5/sKOZniMa+ze+SUzqT6DVb9H+g1pL00yaUk=;
        b=aZl+NafNxCI80+fvYj3B2MCJeUQ8+wT0h1UfqoIwlphLHt8YpOm3oDSPu/T5PpGP8D
         s9MP4uHZKX61P1zxLLXo/XqRn1W8TOyyUYvSlBYg0xNIthWfPVXBuyiOg29oJQQDLUH8
         gO+a2unAx+xQlOM8if9X/S+uZtCZd2L/1ahcrCtHqK32XU9R+qcPPbmL7MJ0NDuK2yqc
         NF83TfGvB5iSpQ/fI/vN4CdaGT3fN+iok1hS0+C8SWRTOhN8o06u6YZm1UiokdUrNYT/
         v9ezqTp9/Qc0vejCL9wBSm29tG1JB/UZ0EBut0ecl2+IjUWQT/NQFbX1mRe9zY1KCSuS
         /PAg==
X-Gm-Message-State: AGi0PuYelFtc0cCQNxD/QOvh1pSGbNgB6kr/1Yk77Z2a6fZogusrE1+b
        /dHyX0cCtaS7tyDvqI4gLeF7GiFRkqd9PiTnVFx7Iw==
X-Google-Smtp-Source: APiQypJv/Tp1lBcOXhhb+2NGeACn6HicX0m6hmE9QgyxVLLWuDZmBypD6sXv0Hr7/SDVZMLzv427pAylEhS5qjbb+T8=
X-Received: by 2002:a19:c64b:: with SMTP id w72mr21803767lff.82.1588151321517;
 Wed, 29 Apr 2020 02:08:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200428182225.451225420@linuxfoundation.org>
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 29 Apr 2020 14:38:29 +0530
Message-ID: <CA+G9fYvPhDsaHKJSGfxWLUPmrf_mRx7S3_RdXWmRzbg25SRRoQ@mail.gmail.com>
Subject: Re: [PATCH 5.6 000/167] 5.6.8-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Andrei Vagin <avagin@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "X.f. Ren" <xiaofeng.ren@nxp.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Marc Zyngier <maz@kernel.org>,
        Kuldeep Singh <kuldeep.singh@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 28 Apr 2020 at 23:57, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.6.8 release.
> There are 167 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 30 Apr 2020 18:20:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.6.8-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

NOTE:
This kernel panic seems to be platform specific.
However, I am sharing a few kernel panic logs here.
While running LTP cve[1] and  libhugetlbfs[2] test suite on nxp ls2088
device the kernel panic noticed with different kernel dump
and unfortunately it is not easily reproducible.
At this point it is unclear whether this problem
started happening from this stable rc review or not.
Because a different type of kernel panic noticed on Linus 's  mainline tree
(5.7.0-rc2) version kernel while running LTP containers tests.

[   49.677646] SError Interrupt on CPU5, code 0xbf000002 -- SError
[   49.677648] CPU: 5 PID: 0 Comm: swapper/5 Not tainted
5.7.0-rc2-00243-g5ef58e290782 #1
[   49.677649] Hardware name: Freescale Layerscape 2088A RDB Board (DT)
[   49.677650] pstate: 40000085 (nZcv daIf -PAN -UAO)
[   49.677651] pc : slabinfo_write+0x2a0/0x4fc
[   49.677652] lr : get_partial_node.isra.0.part.0+0x4c/0x338


steps to reproduce: (Not always reproducible)
# cd /opt/ltp
# ./runltp -f cve

# cd  /opt/libhugetlbfs/tests/
# ./run_tests.py -b 64

[ 1469.013456] Internal error: synchronous external abort: 96000210
[#1] PREEMPT SMP
[ 1469.020934] Modules linked in: algif_hash rfkill caam_jr
caamhash_desc caamalg_desc rng_core caam error crct10dif_ce lm90
ina2xx qoriq_thermal fuse
[ 1469.034154] CPU: 5 PID: 0 Comm: swapper/5 Not tainted
5.6.8-rc1-00164-g86cfba65ced0 #1
[ 1469.042063] Hardware name: Freescale Layerscape 2088A RDB Board (DT)
[ 1469.048409] pstate: 80000005 (Nzcv daif -PAN -UAO)
[ 1469.053196] pc : cgroup_free+0xc/0x60
[ 1469.056851] lr : __put_task_struct+0x34/0x1b0
[ 1469.061198] sp : ffff80001002be00
[ 1469.064504] x29: ffff80001002be00 x28: 0000000000000000
[ 1469.069809] x27: ffffcdb8d17f3140 x26: 0000000000000000
[ 1469.075113] x25: ffff80001002bec0 x24: ffff0082fe3b7b50
[ 1469.080417] x23: ffff0082ee5fd400 x22: 000000000000000a
[ 1469.085721] x21: ffff0082ee5fd400 x20: ffffcdb8d17f32c0
[ 1469.091024] x19: ffff0082edda1c00 x18: 0000000000000000
[ 1469.096328] x17: 0000000000000000 x16: 0000000000000000
[ 1469.101631] x15: 0000000000000000 x14: 00000000000001ec
[ 1469.106934] x13: 0000000000000000 x12: 0000000000000000
[ 1469.112238] x11: 0000000000000002 x10: 0000000000000000
[ 1469.117541] x9 : 0000000000000000 x8 : ffff0082c8340900
[ 1469.122845] x7 : 0000000044042000 x6 : 0000000000210d00
[ 1469.128150] x5 : ffff0082edda1c28 x4 : 0000000000000000
[ 1469.133454] x3 : 0000000000000000 x2 : 0000000000000001
[ 1469.138757] x1 : 0000000000000001 x0 : ffff0082edda1c00
[ 1469.144061] Call trace:
[ 1469.146498]  cgroup_free+0xc/0x60
[ 1469.149804]  __put_task_struct+0x34/0x1b0
[ 1469.153806]  delayed_put_task_struct+0x44/0x90
[ 1469.158242]  rcu_core+0x2ac/0x488
[ 1469.161549]  rcu_core_si+0xc/0x18
[ 1469.164856]  efi_header_end+0x120/0x23c
[ 1469.168685]  irq_exit+0xb8/0xd8
[ 1469.171818]  __handle_domain_irq+0x64/0xb8
[ 1469.175907]  gic_handle_irq+0x5c/0x148
[ 1469.179647]  el1_irq+0xb8/0x180
[ 1469.182780]  cpuidle_enter_state+0x88/0x2f0
[ 1469.186954]  cpuidle_enter+0x34/0x48
[ 1469.190521]  call_cpuidle+0x18/0x38
[ 1469.194000]  do_idle+0x1e8/0x280
[ 1469.197219]  cpu_startup_entry+0x24/0x40
[ 1469.201134]  secondary_start_kernel+0x154/0x190
[ 1469.205659] Code: 97fd4ce5 a9be7bfd 910003fd a90153f3 (f943ec14)
[ 1469.211752] ---[ end trace 69fc7de7c9d4a349 ]---
[ 1469.216361] Kernel panic - not syncing: Fatal exception in interrupt
[ 1469.222708] SMP: stopping secondary CPUs
[ 1469.226627] Kernel Offset: 0x4db8bfe00000 from 0xffff800010000000
[ 1469.232711] PHYS_OFFSET: 0xfffffc1f00000000
[ 1469.236886] CPU features: 0x10002,21806008
[ 1469.240972] Memory Limit: none
[ 1469.244021] ---[ end Kernel panic - not syncing: Fatal exception in
interrupt ]---

libhugetlbfs test run caused kernel panic,

[   43.809972] Internal error: synchronous external abort: 96000210
[#1] PREEMPT SMP
[   43.817451] Modules linked in: rfkill caam_jr caamhash_desc
caamalg_desc rng_core caam error crct10dif_ce lm90 ina2xx
qoriq_thermal fuse
[   43.829716] CPU: 2 PID: 1097 Comm: mmap-gettest Not tainted
5.6.8-rc1-00168-g853ae83af7cc #1
[   43.838146] Hardware name: Freescale Layerscape 2088A RDB Board (DT)
[   43.844493] pstate: 60000085 (nZCv daIf -PAN -UAO)
[   43.849281] pc : ktime_get_update_offsets_now+0x78/0xf8
[   43.854498] lr : ktime_get_update_offsets_now+0x58/0xf8
[   43.859714] sp : ffff800010013e90
[   43.863020] x29: ffff800010013e90 x28: ffff0082fe36ea38
[   43.868323] x27: 0000000a1faeb368 x26: 0000000000002e66
[   43.873627] x25: ffff0082fe36e98c x24: ffffac25d1c00f00
[   43.878931] x23: 0000000000000001 x22: ffffffffc4653600
[   43.884234] x21: ffff0082fe36ea78 x20: ffff0082fe36eab8
[   43.889538] x19: ffff0082fe36ea38 x18: 0000000000000000
[   43.894842] x17: 0000000000000000 x16: 0000000000000000
[   43.900146] x15: 0000000000000000 x14: 0000000000000000
[   43.905450] x13: 0000000000000000 x12: 0000000000000000
[   43.910754] x11: 0000000000000000 x10: 0000000000000040
[   43.916058] x9 : ffffac25d19f2250 x8 : ffffac25d19f2248
[   43.921361] x7 : ffff0082ee000288 x6 : 0000000000000000
[   43.926664] x5 : ffff545d2cd84000 x4 : 000b5f2e9a47be6c
[   43.931969] x3 : 0000000027fffac2 x2 : 0000000000000003
[   43.937272] x1 : 000af6b237f94080 x0 : 0000000000000018
[   43.942576] Call trace:
[   43.945015]  ktime_get_update_offsets_now+0x78/0xf8
[   43.949885]  hrtimer_interrupt+0x7c/0x240
[   43.953887]  arch_timer_handler_phys+0x30/0x40
[   43.958324]  handle_percpu_devid_irq+0x80/0x140
[   43.962846]  generic_handle_irq+0x24/0x38
[   43.966846]  __handle_domain_irq+0x60/0xb8
[   43.970935]  gic_handle_irq+0x5c/0x148
[   43.974009] SError Interrupt on CPU0, code 0xbf000002 -- SError
[   43.974011] CPU: 0 PID: 0 Comm: swapper/0 Not tainted
5.6.8-rc1-00168-g853ae83af7cc #1
[   43.974012] Hardware name: Freescale Layerscape 2088A RDB Board (DT)
[   43.974013] pstate: 80000085 (Nzcv daIf -PAN -UAO)
[   43.974014] pc : _raw_spin_unlock_irqrestore+0x34/0x40
[   43.974015] lr : timekeeping_advance+0x374/0x550
[   43.974015] sp : ffff800010003e70
[   43.974016] x29: ffff800010003e70 x28: 0000000000000000
[   43.974018] x27: 003b9aca00000000 x26: ffff800010004000
[   43.974020] x25: 003b9aca00000000 x24: 0000000000011628
[   43.974021] x23: ffffac25d19e2fc0 x22: 003d090000000000
[   43.974023] x21: 0000000000000000 x20: ffffac25d1c00f00
[   43.974025] x19: ffffac25d1c01070 x18: 0000000000000000
[   43.974026] x17: 0000000000000000 x16: 0000000000000000
[   43.974028] x15: 0000000000000000 x14: 003d090000000000
[   43.974030] x13: 00003d08f8004540 x12: 0000000007ffbac0
[   43.974031] x11: 00003d08f8004540 x10: 00000000000186a0
[   43.974033] x9 : 0000000000000000 x8 : 0000000000000008
[   43.974034] x7 : 0000000000000000 x6 : ffffac25d1c01060
[   43.974036] x5 : 0000000a02ffee00 x4 : 0000000000000000
[   43.974038] x3 : 0000000000000000 x2 : 0000000000000000
[   43.974040] x1 : ffffac25d19e2fc0 x0 : 0000000100000201
[   43.974042] Kernel panic - not syncing: Asynchronous SError Interrupt
[   44.098603]  el0_irq_naked+0x4c/0x54
[   44.102171] Code: b9406700 8a020084 b9400322 9b030484 (b940f701)
[   44.108258] ---[ end trace e237e948351682ae ]---
[   44.112873] SMP: stopping secondary CPUs
[   44.112874] Kernel Offset: 0x2c25c0000000 from 0xffff800010000000
[   44.112875] PHYS_OFFSET: 0xffffce7680000000
[   44.112875] CPU features: 0x10002,21806008
[   44.112876] Memory Limit: none

LTP test suite
[1] https://github.com/linux-test-project/ltp

libhugetlbfs test repo link
[2] https://github.com/libhugetlbfs/libhugetlbfs

full test run:
https://qa-reports.linaro.org/lkft/linux-stable-rc-5.6-oe/build/v5.6.7-164-=
g86cfba65ced0/testrun/14378/log

Build details and kernel config:
https://qa-reports.linaro.org/lkft/linux-stable-rc-5.6-oe/build/v5.6.7-164-=
g86cfba65ced0/testrun/14378/
https://qa-reports.linaro.org/lkft/linux-stable-rc-5.6-oe/build/v5.6.7-168-=
g853ae83af7cc/testrun/14736/log
https://qa-reports.linaro.org/lkft/linux-stable-rc-5.6-oe/build/v5.6.7-168-=
g853ae83af7cc/testrun/14736

kernel config:
https://builds.tuxbuild.com/nYYJB1EJpavHsEQt6aGP1w/kernel.config

kernel panic log on Linus 's mainline (5.7.0-rc2) kernel
https://qa-reports.linaro.org/lkft/linux-mainline-oe/build/v5.7-rc2-243-g5e=
f58e290782/testrun/14053/log

Summary
------------------------------------------------------------------------

kernel: 5.6.8-rc1
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git
git branch: linux-5.6.y
git commit: 853ae83af7cc63bd4dc0a44370e4f0b3c9fa57f9
git describe: v5.6.7-168-g853ae83af7cc6
Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-5.6-oe/bui=
ld/v5.6.7-168-g853ae83af7cc6


No regressions (compared to build v5.6.7)

No fixes (compared to build v5.6.7)


Ran 36070 total tests in the following environments and test suites.

Environments
--------------
- dragonboard-410c
- hi6220-hikey
- i386
- juno-r2
- juno-r2-compat
- juno-r2-kasan
- nxp-ls2088
- qemu_arm
- qemu_arm64
- qemu_i386
- qemu_x86_64
- x15
- x86
- x86-kasan

Test Suites
-----------
* build
* install-android-platform-tools-r2600
* kselftest
* kselftest/drivers
* kselftest/filesystems
* libgpiod
* linux-log-parser
* perf
* network-basic-tests
* kselftest/net
* kselftest/networking
* libhugetlbfs
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-cpuhotplug-tests
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
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* spectre-meltdown-checker-test
* v4l2-compliance
* kselftest-vsyscall-mode-native
* kselftest-vsyscall-mode-native/drivers
* kselftest-vsyscall-mode-native/filesystems
* kselftest-vsyscall-mode-native/net
* kselftest-vsyscall-mode-native/networking
* kselftest-vsyscall-mode-none
* kselftest-vsyscall-mode-none/drivers
* kselftest-vsyscall-mode-none/filesystems
* kselftest-vsyscall-mode-none/net
* kselftest-vsyscall-mode-none/networking

--=20
Linaro LKFT
https://lkft.linaro.org

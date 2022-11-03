Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EAAE6179B0
	for <lists+stable@lfdr.de>; Thu,  3 Nov 2022 10:19:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbiKCJTn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Nov 2022 05:19:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231496AbiKCJTJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Nov 2022 05:19:09 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3AB662D4
        for <stable@vger.kernel.org>; Thu,  3 Nov 2022 02:18:41 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id y14so3494353ejd.9
        for <stable@vger.kernel.org>; Thu, 03 Nov 2022 02:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hfthu7wwUmex8DJIB+pTNplsVVtjTJoQuyozKG+VWE8=;
        b=hYGleEES/k1vzPy1N0s0Vj9Sn/zCoOce3aIbaKqXoZHt9ylcTMBiKEmh0igaGvVJU8
         9u6eygKksvPBuWQoh7CK+Jh7gzHthyxUYdi+xaO64vfNIi0Np+6wf1+KXbhMnHLgOuuA
         iydnle9usGoktUBhFi5m1Lsp1p2SgR5TwmDmzQryZv7WX44oD0JFLqRuzZ5OF4QlNGFn
         L7KWMhgnSsxOV8CEe7F0FVP7zWgPwK1vnwsiQjsOFblsDBNsMqy3W/EbgX0ZZ5BJmXe+
         mG/nZLzVK2x/lrIKXxteFnicsyfgrgZ63ZT3KvBk6P08XjcTSmt4lnVj5NfZb6B/PUSZ
         HOaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hfthu7wwUmex8DJIB+pTNplsVVtjTJoQuyozKG+VWE8=;
        b=qv9V4hccDJZvvAdpKHzQLQnCm/h2iq0nBj5YBu0/Oa7fRr1Yi6wRfdiErgbbm7ELzU
         GyeudNV/k8UUvn+ATa8gppy+POvHXX+Lrsqh3XY1HbcI8Bt31DOvTPGjOECtPsKfFcbv
         IqNw/If15DiSMMnfXhuDGbCncvG+fH8D9jDfCAas9mNS16Mrzc0drOeniYwDRe2G68Lo
         g9gl8zelJ/ZBI8ChTlvHnShL7JaKXqCah0v6dOq1YXfCo/7LrWnQWWOG0LmFnSnWotuq
         FXu0b3SiDzOdaXg4wg8sOgmAzX42VSjI0H27apBk3SAjbKn+ULYb4mFizcp8ApfEFfSh
         rXsw==
X-Gm-Message-State: ACrzQf2MLQrFdA6xXwDSD6NJQLOM9xZDNLnzvpOXB6ql7UXx/EZvtqoG
        OpaNJIZxo0hMR3tqG8LJJpt7+MeLdSDqS3RQVHCgnA==
X-Google-Smtp-Source: AMsMyM4KYM3rvWxuoT72rwGdXrlDZmuRq1+zR3dRZfx1z1/6kWnMVS1p0yV/0V63NkewkL6rah0oenBFLGUhQAWpSWg=
X-Received: by 2002:a17:907:6e1b:b0:78e:15a3:5be6 with SMTP id
 sd27-20020a1709076e1b00b0078e15a35be6mr27983570ejc.750.1667467119938; Thu, 03
 Nov 2022 02:18:39 -0700 (PDT)
MIME-Version: 1.0
References: <20221102022051.821538553@linuxfoundation.org>
In-Reply-To: <20221102022051.821538553@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 3 Nov 2022 14:48:28 +0530
Message-ID: <CA+G9fYtd1fsbhH7XNuiiY2TZ5PG2xoSH9cHMcWg8KH_q8uZ+Mg@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/64] 5.4.223-rc1 review
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
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2 Nov 2022 at 08:51, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.223 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 04 Nov 2022 02:20:38 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.223-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
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
 [1] https://builds.tuxbuild.com/2GyMi25XnyDaaKJ170L0VWShkT9/


2)
While running selftests: net: pmtu.sh tests on arm32 x15 device
the following kernel warning got noticed.
This is not a regression. The reported warning started when we started
testing kselftests net.

[  462.965664] ------------[ cut here ]------------
[  462.970478] WARNING: CPU: 1 PID: 0 at kernel/softirq.c:169
__local_bh_enable_ip+0x114/0x18c
[  462.978948] IRQs not enabled as expected
[  462.982898] Modules linked in: sit bridge stp llc act_csum
libcrc32c act_pedit cls_flower sch_prio ip_tables x_tables veth tun
cfg80211 bluetooth snd_soc_simple_card snd_soc_simple_card_utils
snd_soc_core ac97_bus snd_pcm_dmaengine snd_pcm snd_timer snd
soundcore fuse [last unloaded: test_blackhole_dev]
[  463.009975] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.4.223-rc1 #1
[  463.016361] Hardware name: Generic DRA74X (Flattened Device Tree)
[  463.022485] Backtrace:
[  463.024955] [<c131482c>] (dump_backtrace) from [<c1314bdc>]
(show_stack+0x20/0x24)
[  463.032566]  r7:ffffffff r6:00000000 r5:60070113 r4:c1fd8b44
[  463.038257] [<c1314bbc>] (show_stack) from [<c132b588>]
(dump_stack+0xe0/0x10c)
[  463.045605] [<c132b4a8>] (dump_stack) from [<c03578f0>] (__warn+0xe0/0x1=
1c)
[  463.052603]  r9:00000009 r8:c0360490 r7:000000a9 r6:00000009
r5:c0360490 r4:c1989b9c
[  463.060388] [<c0357810>] (__warn) from [<c1315d70>]
(warn_slowpath_fmt+0x8c/0xa8)
[  463.067909]  r7:000000a9 r6:c1989b9c r5:c1989c88 r4:ee1fe000
[  463.073598] [<c1315ce8>] (warn_slowpath_fmt) from [<c0360490>]
(__local_bh_enable_ip+0x114/0x18c)
[  463.082516]  r9:e8cb74f4 r8:ee1ffc30 r7:e76ddb80 r6:ee1ffc98
r5:c124a9f4 r4:00000201
[  463.090302] [<c036037c>] (__local_bh_enable_ip) from [<c13349c8>]
(_raw_spin_unlock_bh+0x40/0x44)
[  463.099219]  r7:e76ddb80 r6:ee1ffc98 r5:eeb8c600 r4:c124a9f4
[  463.104912] [<c1334988>] (_raw_spin_unlock_bh) from [<c124a9f4>]
(icmp6_dst_alloc+0xfc/0x1b8)
[  463.113478]  r5:eeb8c600 r4:e8cb7480
[  463.117077] [<c124a8f8>] (icmp6_dst_alloc) from [<c1266fc0>]
(mld_sendpack+0x26c/0x7b4)
[  463.125122]  r9:ee1ffc60 r8:c1267fd8 r7:e6a1c400 r6:e690f810
r5:e76ddb80 r4:ec773180
[  463.132904] [<c1266d54>] (mld_sendpack) from [<c1267fd8>]
(mld_ifc_timer_expire+0x1f0/0x49c)
[  463.141385]  r10:00000101 r9:00000001 r8:e68e57e0 r7:e6a1c46c
r6:00000000 r5:ec773180
[  463.149252]  r4:00000000
[  463.151804] [<c1267de8>] (mld_ifc_timer_expire) from [<c0401f88>]
(call_timer_fn+0xe0/0x3e8)
[  463.160283]  r10:00000101 r9:c1267de8 r8:c1e086e8 r7:c1fe147c
r6:e6a1c46c r5:ee1fe000
[  463.168152]  r4:ee1ffd8c
[  463.170703] [<c0401ea8>] (call_timer_fn) from [<c0402738>]
(__run_timers.part.0+0x1cc/0x238)
[  463.179183]  r10:c1267de8 r9:00000000 r8:00003fa6 r7:00000000
r6:ee1ffde4 r5:eeb83880
[  463.187049]  r4:e6a1c46c
[  463.189599] [<c040256c>] (__run_timers.part.0) from [<c04027ec>]
(run_timer_softirq+0x48/0x78)
[  463.198254]  r10:ee1fe000 r9:00000282 r8:c1e086e8 r7:c1fe0fa4
r6:00000001 r5:00000002
[  463.206121]  r4:c1e05900
[  463.208673] [<c04027a4>] (run_timer_softirq) from [<c0302e48>]
(__do_softirq+0x1e8/0x5c4)
[  463.216889]  r5:00000002 r4:c1e03084
[  463.220487] [<c0302c60>] (__do_softirq) from [<c03606f0>]
(irq_exit+0x154/0x1a8)
[  463.227919]  r10:00000000 r9:fa213000 r8:ee03c400 r7:00000001
r6:00000000 r5:00000000
[  463.235785]  r4:ffffe000
[  463.238336] [<c036059c>] (irq_exit) from [<c03de4ec>]
(__handle_domain_irq+0x80/0xd0)
[  463.246204]  r5:00000000 r4:c1dc4408
[  463.249802] [<c03de46c>] (__handle_domain_irq) from [<c0302758>]
(gic_handle_irq+0x68/0xac)
[  463.258193]  r9:fa213000 r8:fa21200c r7:ee1fff28 r6:c1ea4560
r5:fa212000 r4:c1e09228
[  463.265976] [<c03026f0>] (gic_handle_irq) from [<c0301af0>]
(__irq_svc+0x70/0x98)
[  463.273496] Exception stack(0xee1fff28 to 0xee1fff70)
[  463.278577] ff20:                   00000001 00000006 00000000
ee1f2c40 00000001 ee1fe000
[  463.286797] ff40: c1e086e8 c1e08730 00000000 ee1fe000 00000000
ee1fff84 00000000 ee1fff78
[  463.295013] ff60: c03cd670 c030b2c8 20070013 ffffffff
[  463.300091]  r9:ee1fe000 r8:00000000 r7:ee1fff5c r6:ffffffff
r5:20070013 r4:c030b2c8
[  463.307878] [<c030b294>] (arch_cpu_idle) from [<c039cc38>]
(do_idle+0x25c/0x2f4)
[  463.315311] [<c039c9dc>] (do_idle) from [<c039d0e0>]
(cpu_startup_entry+0x28/0x30)
[  463.322919]  r10:00000000 r9:412fc0f2 r8:8020406a r7:c2017650
r6:10c0387d r5:00000001
[  463.330786]  r4:0000008c
[  463.333338] [<c039d0b8>] (cpu_startup_entry) from [<c0312e58>]
(secondary_start_kernel+0x18c/0x1b0)
[  463.342432] [<c0312ccc>] (secondary_start_kernel) from [<803032cc>]
(0x803032cc)
[  463.349863]  r5:00000051 r4:ae1ec06a
[  463.353520] irq event stamp: 644488
[  463.357067] hardirqs last  enabled at (644498): [<c03dbb84>]
console_unlock+0x4d0/0x6ac
[  463.365114] hardirqs last disabled at (644505): [<c03db798>]
console_unlock+0xe4/0x6ac
[  463.373131] softirqs last  enabled at (644380): [<c035f7c8>]
_local_bh_enable+0x34/0x6c
[  463.381215] softirqs last disabled at (644381): [<c03606f0>]
irq_exit+0x154/0x1a8
[  463.388768] ---[ end trace 7d3ddd65f6dff4cc ]---

 [2] https://lkft.validation.linaro.org/scheduler/job/5798725#L4600
 [3] https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v=
5.4.222-65-g01e7d36eb536/testrun/12814333/suite/log-parser-test/tests/
 [4] https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v=
5.4.222-65-g01e7d36eb536/testrun/12814333/suite/log-parser-test/test/check-=
kernel-warning-70ee64c3ae1e2e977858cae153f4e3976e17673c73d98e38878fb6ae7520=
dd4e/history/

## Build
* kernel: 5.4.223-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: 01e7d36eb536773debcbd1ff966edcf6f39851f6
* git describe: v5.4.222-65-g01e7d36eb536
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
22-65-g01e7d36eb536

## No Test Regressions (compared to v5.4.222)

## No Metric Regressions (compared to v5.4.222)

## No Test Fixes (compared to v5.4.222)

## No Metric Fixes (compared to v5.4.222)

## Test result summary
total: 126679, pass: 107102, fail: 2174, skip: 16900, xfail: 503

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 334 total, 334 passed, 0 failed
* arm64: 64 total, 59 passed, 5 failed
* i386: 31 total, 29 passed, 2 failed
* mips: 56 total, 56 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 63 total, 63 passed, 0 failed
* riscv: 27 total, 26 passed, 1 failed
* s390: 15 total, 15 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 57 total, 55 passed, 2 failed

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

> -------------
> Pseudo-Shortlog of commits:
>
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Linux 5.4.223-rc1
>
> Biju Das <biju.das.jz@bp.renesas.com>
>     can: rcar_canfd: rcar_canfd_handle_global_receive(): fix IRQ storm on=
 global FIFO receive
>
> Vladimir Oltean <vladimir.oltean@nxp.com>
>     net: enetc: survive memory pressure without crashing
>
> Tariq Toukan <tariqt@nvidia.com>
>     net/mlx5: Fix possible use-after-free in async command interface
>
> Hyong Youb Kim <hyonkim@cisco.com>
>     net/mlx5e: Do not increment ESN when updating IPsec ESN state
>
> Nicolas Dichtel <nicolas.dichtel@6wind.com>
>     nh: fix scope used to find saddr when adding non gw nh
>
> Yang Yingliang <yangyingliang@huawei.com>
>     net: ehea: fix possible memory leak in ehea_register_port()
>
> Aaron Conole <aconole@redhat.com>
>     openvswitch: switch from WARN to pr_warn
>
> Takashi Iwai <tiwai@suse.de>
>     ALSA: aoa: Fix I2S device accounting
>
> Yang Yingliang <yangyingliang@huawei.com>
>     ALSA: aoa: i2sbus: fix possible memory leak in i2sbus_add_dev()
>
> Sudeep Holla <sudeep.holla@arm.com>
>     PM: domains: Fix handling of unavailable/disabled idle states
>
> Yang Yingliang <yangyingliang@huawei.com>
>     net: ksz884x: fix missing pci_disable_device() on error in pcidev_ini=
t()
>
> Slawomir Laba <slawomirx.laba@intel.com>
>     i40e: Fix flow-type by setting GL_HASH_INSET registers
>
> Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
>     i40e: Fix VF hang when reset is triggered on another VF
>
> Slawomir Laba <slawomirx.laba@intel.com>
>     i40e: Fix ethtool rx-flow-hash setting for X722
>
> Hans Verkuil <hverkuil-cisco@xs4all.nl>
>     media: videodev2.h: V4L2_DV_BT_BLANKING_HEIGHT should check 'interlac=
ed'
>
> Hans Verkuil <hverkuil-cisco@xs4all.nl>
>     media: v4l2-dv-timings: add sanity checks for blanking values
>
> Hans Verkuil <hverkuil-cisco@xs4all.nl>
>     media: vivid: dev->bitmap_cap wasn't freed in all cases
>
> Hans Verkuil <hverkuil-cisco@xs4all.nl>
>     media: vivid: s_fbuf: add more sanity checks
>
> Mario Limonciello <mario.limonciello@amd.com>
>     PM: hibernate: Allow hybrid sleep to work with s2idle
>
> Dongliang Mu <dzm91@hust.edu.cn>
>     can: mscan: mpc5xxx: mpc5xxx_can_probe(): add missing put_clock() in =
error path
>
> Neal Cardwell <ncardwell@google.com>
>     tcp: fix indefinite deferral of RTO with SACK reneging
>
> Zhang Changzhong <zhangchangzhong@huawei.com>
>     net: lantiq_etop: don't free skb when returning NETDEV_TX_BUSY
>
> Zhengchao Shao <shaozhengchao@huawei.com>
>     net: fix UAF issue in nfqnl_nf_hook_drop() when ops_init() failed
>
> Eric Dumazet <edumazet@google.com>
>     kcm: annotate data-races around kcm->rx_wait
>
> Eric Dumazet <edumazet@google.com>
>     kcm: annotate data-races around kcm->rx_psock
>
> Raju Rangoju <Raju.Rangoju@amd.com>
>     amd-xgbe: add the bit rate quirk for Molex cables
>
> Raju Rangoju <Raju.Rangoju@amd.com>
>     amd-xgbe: fix the SFP compliance codes check for DAC cables
>
> Chen Zhongjin <chenzhongjin@huawei.com>
>     x86/unwind/orc: Fix unreliable stack dump with gcov
>
> Yang Yingliang <yangyingliang@huawei.com>
>     net: netsec: fix error handling in netsec_register_mdio()
>
> Xin Long <lucien.xin@gmail.com>
>     tipc: fix a null-ptr-deref in tipc_topsrv_accept
>
> Yang Yingliang <yangyingliang@huawei.com>
>     ALSA: ac97: fix possible memory leak in snd_ac97_dev_register()
>
> Randy Dunlap <rdunlap@infradead.org>
>     arc: iounmap() arg is volatile
>
> Nathan Huckleberry <nhuck@google.com>
>     drm/msm: Fix return type of mdp4_lvds_connector_mode_valid
>
> Alexander Stein <alexander.stein@ew.tq-group.com>
>     media: v4l2: Fix v4l2_i2c_subdev_set_name function documentation
>
> Wei Yongjun <weiyongjun1@huawei.com>
>     net: ieee802154: fix error return code in dgram_bind()
>
> Rik van Riel <riel@surriel.com>
>     mm,hugetlb: take hugetlb_lock before decrementing h->resv_huge_pages
>
> Chen Zhou <chenzhou10@huawei.com>
>     cgroup-v1: add disabled controller check in cgroup1_parse_param()
>
> M. Vefa Bicakci <m.v.b@runbox.com>
>     xen/gntdev: Prevent leaking grants
>
> Jan Beulich <jbeulich@suse.com>
>     Xen/gntdev: don't ignore kernel unmapping error
>
> Chandan Babu R <chandan.babu@oracle.com>
>     xfs: force the log after remapping a synchronous-writes file
>
> Chandan Babu R <chandan.babu@oracle.com>
>     xfs: clear XFS_DQ_FREEING if we can't lock the dquot buffer to flush
>
> Chandan Babu R <chandan.babu@oracle.com>
>     xfs: finish dfops on every insert range shift iteration
>
> Heiko Carstens <hca@linux.ibm.com>
>     s390/pci: add missing EX_TABLE entries to __pcistg_mio_inuser()/__pci=
lg_mio_inuser()
>
> Heiko Carstens <hca@linux.ibm.com>
>     s390/futex: add missing EX_TABLE entry to __futex_atomic_op()
>
> Adrian Hunter <adrian.hunter@intel.com>
>     perf auxtrace: Fix address filter symbol name match for modules
>
> Christian A. Ehrhardt <lk@c--e.de>
>     kernfs: fix use-after-free in __kernfs_remove
>
> Matthew Ma <mahongwei@zeku.com>
>     mmc: core: Fix kernel panic when remove non-standard SDIO card
>
> Johan Hovold <johan+linaro@kernel.org>
>     drm/msm/hdmi: fix memory corruption with too many bridges
>
> Johan Hovold <johan+linaro@kernel.org>
>     drm/msm/dsi: fix memory corruption with too many bridges
>
> Miquel Raynal <miquel.raynal@bootlin.com>
>     mac802154: Fix LQI recording
>
> Hyunwoo Kim <imv4bel@gmail.com>
>     fbdev: smscufx: Fix several use-after-free bugs
>
> Shreeya Patel <shreeya.patel@collabora.com>
>     iio: light: tsl2583: Fix module unloading
>
> Matti Vaittinen <mazziesaccount@gmail.com>
>     tools: iio: iio_utils: fix digit calculation
>
> Mathias Nyman <mathias.nyman@linux.intel.com>
>     xhci: Remove device endpoints from bandwidth list when freeing the de=
vice
>
> Tony O'Brien <tony.obrien@alliedtelesis.co.nz>
>     mtd: rawnand: marvell: Use correct logic for nand-keep-config
>
> Jens Glathe <jens.glathe@oldschoolsolutions.biz>
>     usb: xhci: add XHCI_SPURIOUS_SUCCESS to ASM1042 despite being a V0.96=
 controller
>
> Justin Chen <justinpopo6@gmail.com>
>     usb: bdc: change state when port disconnected
>
> Thinh Nguyen <Thinh.Nguyen@synopsys.com>
>     usb: dwc3: gadget: Don't set IMI for no_interrupt
>
> Thinh Nguyen <Thinh.Nguyen@synopsys.com>
>     usb: dwc3: gadget: Stop processing more requests on IMI
>
> Hannu Hartikainen <hannu@hrtk.in>
>     USB: add RESET_RESUME quirk for NVIDIA Jetson devices in RCM
>
> Jason A. Donenfeld <Jason@zx2c4.com>
>     ALSA: au88x0: use explicitly signed char
>
> Steven Rostedt (Google) <rostedt@goodmis.org>
>     ALSA: Use del_timer_sync() before freeing timer
>
> Anssi Hannula <anssi.hannula@bitwise.fi>
>     can: kvaser_usb: Fix possible completions during init_completion
>
> Yang Yingliang <yangyingliang@huawei.com>
>     can: j1939: transport: j1939_session_skb_drop_old(): spin_unlock_irqr=
estore() before kfree_skb()
>
>
> -------------
>
> Diffstat:
>
>  Makefile                                           |   4 +-
>  arch/arc/include/asm/io.h                          |   2 +-
>  arch/arc/mm/ioremap.c                              |   2 +-
>  arch/s390/include/asm/futex.h                      |   3 +-
>  arch/s390/pci/pci_mmio.c                           |   8 +-
>  arch/x86/kernel/unwind_orc.c                       |   2 +-
>  drivers/base/power/domain.c                        |   4 +
>  .../gpu/drm/msm/disp/mdp4/mdp4_lvds_connector.c    |   5 +-
>  drivers/gpu/drm/msm/dsi/dsi.c                      |   6 ++
>  drivers/gpu/drm/msm/hdmi/hdmi.c                    |   5 ++
>  drivers/iio/light/tsl2583.c                        |   2 +-
>  drivers/media/platform/vivid/vivid-core.c          |  22 +++++
>  drivers/media/platform/vivid/vivid-core.h          |   2 +
>  drivers/media/platform/vivid/vivid-vid-cap.c       |  27 ++++--
>  drivers/media/v4l2-core/v4l2-dv-timings.c          |  14 +++
>  drivers/mmc/core/sdio_bus.c                        |   3 +-
>  drivers/mtd/nand/raw/marvell_nand.c                |   2 +-
>  drivers/net/can/mscan/mpc5xxx_can.c                |   8 +-
>  drivers/net/can/rcar/rcar_canfd.c                  |   6 +-
>  drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c  |   4 +-
>  drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c   |   4 +-
>  drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c        |  17 ++--
>  drivers/net/ethernet/freescale/enetc/enetc.c       |   5 ++
>  drivers/net/ethernet/ibm/ehea/ehea_main.c          |   1 +
>  drivers/net/ethernet/intel/i40e/i40e_ethtool.c     | 100 ++++++++++++---=
------
>  drivers/net/ethernet/intel/i40e/i40e_type.h        |   4 +
>  drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |  43 ++++++---
>  drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h |   1 +
>  drivers/net/ethernet/lantiq_etop.c                 |   1 -
>  drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |  10 +--
>  .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c   |   3 -
>  drivers/net/ethernet/micrel/ksz884x.c              |   2 +-
>  drivers/net/ethernet/socionext/netsec.c            |   2 +
>  drivers/usb/core/quirks.c                          |   9 ++
>  drivers/usb/dwc3/gadget.c                          |   8 +-
>  drivers/usb/gadget/udc/bdc/bdc_udc.c               |   1 +
>  drivers/usb/host/xhci-mem.c                        |  20 +++--
>  drivers/usb/host/xhci-pci.c                        |   8 +-
>  drivers/video/fbdev/smscufx.c                      |  55 ++++++------
>  drivers/xen/gntdev.c                               |  30 +++++--
>  fs/kernfs/dir.c                                    |   5 +-
>  fs/xfs/xfs_bmap_util.c                             |   2 +-
>  fs/xfs/xfs_file.c                                  |  17 +++-
>  fs/xfs/xfs_qm.c                                    |   1 +
>  include/linux/mlx5/driver.h                        |   2 +-
>  include/media/v4l2-common.h                        |   3 +-
>  include/uapi/linux/videodev2.h                     |   3 +-
>  kernel/cgroup/cgroup-v1.c                          |   3 +
>  kernel/power/hibernate.c                           |   2 +-
>  mm/hugetlb.c                                       |   2 +-
>  net/can/j1939/transport.c                          |   4 +-
>  net/core/net_namespace.c                           |   7 ++
>  net/ieee802154/socket.c                            |   4 +-
>  net/ipv4/nexthop.c                                 |   2 +-
>  net/ipv4/tcp_input.c                               |   3 +-
>  net/kcm/kcmsock.c                                  |  23 +++--
>  net/mac802154/rx.c                                 |   5 +-
>  net/openvswitch/datapath.c                         |   3 +-
>  net/tipc/topsrv.c                                  |  16 +++-
>  sound/aoa/soundbus/i2sbus/core.c                   |   7 +-
>  sound/pci/ac97/ac97_codec.c                        |   1 +
>  sound/pci/au88x0/au88x0.h                          |   6 +-
>  sound/pci/au88x0/au88x0_core.c                     |   2 +-
>  sound/synth/emux/emux.c                            |   7 +-
>  tools/iio/iio_utils.c                              |   4 +
>  tools/perf/util/auxtrace.c                         |  10 ++-
>  66 files changed, 423 insertions(+), 176 deletions(-)
>
>
* vdso

--
Linaro LKFT
https://lkft.linaro.org

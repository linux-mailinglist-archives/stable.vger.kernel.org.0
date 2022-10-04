Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 116D75F3CE2
	for <lists+stable@lfdr.de>; Tue,  4 Oct 2022 08:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbiJDGsX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Oct 2022 02:48:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiJDGsV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Oct 2022 02:48:21 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A36662CE2B
        for <stable@vger.kernel.org>; Mon,  3 Oct 2022 23:48:19 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id s30so13832323eds.1
        for <stable@vger.kernel.org>; Mon, 03 Oct 2022 23:48:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=ErVzbdt95MBXIe8ExTbFDB+LyHdNohDb30HaWfu5gmU=;
        b=RPUl4yL2UNwNgrSxjC/6ziJcekXCtoERTIvUY+ii/fc+ECua3GMC8YdH7GtHm78sk1
         qak7IppSVq/hQ0ElhEvv5U2/tiuDTehwlOEgpMpU1wXG8JV6kHyNoJtVglXnYxxWAZDb
         nXXm7tzRJ4emAzSoQA7PGsPwTTVD+i3QPDhpBHyqXYJUWdx3t/AZ+Q6y0p1ZdiCkvgEn
         nt6G3M7VhDiuZWALXpyPGkodX8R7EmgVkwMQyvT6DW3xnE2lErs5ILGMw9hP/vTDImgu
         UIsraaQTBpf68PUTXwVzDJv6naF1zdAn7QiiS8eiMan5gI6L5Uf5Boa5oY06TWuZIk3X
         wo2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=ErVzbdt95MBXIe8ExTbFDB+LyHdNohDb30HaWfu5gmU=;
        b=6Cr6SDn77p5QMU5NgMggzdRHmn6yomtlv8XcGc/X2px2ELp0xRYP+j7InBfcuuIEm0
         8yIwT9UQhcnavcqn77a/4Ya6oJ9X3G2PYYX1RqGfhLKwx8Yf1FR7agHV4+12qEqn0cZs
         0WNR5Crl0Mg5mthoIKBXXbHciguUpPMwnn4Pf8rG7LIybRwgx3hS/EN8PhtNUi2/Zwme
         9BdE5TlRZlXKh2Z9eQaa9FdoUPc59QJr5NIyPoE6X9BZvU03xCCCkdw0rgc66tmvFLrw
         VT3/VOD5PSRqwSBBXV4V5ck3VnjhE7vOPYJirZA3Fjs4LprOwNpjAJkzZ+1nUOc2jIL7
         xWiQ==
X-Gm-Message-State: ACrzQf1UzSFO4oD3fuUn7zfhshRusw4MuXv6qiIigabCN6Y+b37dRmdX
        QBPxwiN2/+qeI9Z9j+rOrvNh6/uRKG3Ln1RYxG+Bng==
X-Google-Smtp-Source: AMsMyM6SzmmzaeKOJ5MqV1EAEMQq1m93Loc0uTndGbavKXEGX4CpRks/XKcBOUJPcNnap+kyPTTQm7T/NVbOT3OpCdg=
X-Received: by 2002:a05:6402:2989:b0:44e:90d0:b9ff with SMTP id
 eq9-20020a056402298900b0044e90d0b9ffmr21839639edb.110.1664866097955; Mon, 03
 Oct 2022 23:48:17 -0700 (PDT)
MIME-Version: 1.0
References: <20221003070724.490989164@linuxfoundation.org>
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 4 Oct 2022 12:18:05 +0530
Message-ID: <CA+G9fYvxTQ52SDLnF2-7Kynuy0NcojXuikC8L5BaTZWBsCMv2g@mail.gmail.com>
Subject: Re: [PATCH 5.19 000/101] 5.19.13-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, Feng Tang <feng.tang@intel.com>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Waiman Long <longman@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 3 Oct 2022 at 12:43, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.19.13 release.
> There are 101 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 05 Oct 2022 07:07:06 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.13-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
1) Build warning
2) Boot warning on qemu-arm64 with KASAN and Kunit test
   Suspecting one of the recently commits causing this warning and
   need to bisect to confirm the commit id.
    mm/slab_common: fix possible double free of kmem_cache
[ Upstream commit d71608a877362becdc94191f190902fac1e64d35 ]


1) Following build warning found on few arm configs which do not set Kconfig
# CONFIG_ELF_CORE is not set

- powerpc: tqm8xx_defconfig
- arm: keystone_defconfig and omap1_defconfig
- mips: ar7_defconfig
fs/coredump.c:835:12: warning: 'dump_emit_page' defined but not used
[-Wunused-function]
  835 | static int dump_emit_page(struct coredump_params *cprm, struct
page *page)
      |            ^~~~~~~~~~~~~~

2) Following kernel boot warning noticed on qemu-arm64 with KASAN and
KUNIT enabled [1]

     [  177.651182] ------------[ cut here ]------------
     [  177.652217] kmem_cache_destroy test: Slab cache still has
objects when called from test_exit+0x28/0x40
     [  177.654849] WARNING: CPU: 0 PID: 1 at mm/slab_common.c:520
kmem_cache_destroy+0x1e8/0x20c
     [  177.666237] Modules linked in:
     [  177.667325] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G    B
       5.19.13-rc1 #1
     [  177.668666] Hardware name: linux,dummy-virt (DT)
     [  177.669783] pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT
-SSBS BTYPE=--)
     [  177.671120] pc : kmem_cache_destroy+0x1e8/0x20c
     [  177.672217] lr : kmem_cache_destroy+0x1e8/0x20c
     [  177.673302] sp : ffff8000080876f0
     [  177.674013] x29: ffff8000080876f0 x28: ffffb5ed1da56f38 x27:
ffffb5ed1a87b480
     [  177.676478] x26: ffff800008087aa0 x25: ffff800008087ac8 x24:
ffff00000c73b480
     [  177.678215] x23: 000000004c800000 x22: ffffb5ed1eca3000 x21:
ffffb5ed1da381f0
     [  177.679873] x20: fdecb5ed18ea3a78 x19: ffff00000759be00 x18:
00000000ffffffff
     [  177.681540] x17: 0000000000000000 x16: 0000000000000000 x15:
0000000000000000
     [  177.683139] x14: 0000000000000000 x13: 206d6f7266206465 x12:
ffff700001010e63
     [  177.684776] x11: 1ffff00001010e62 x10: ffff700001010e62 x9 :
ffffb5ed18b89514
     [  177.686554] x8 : ffff800008087317 x7 : 0000000000000001 x6 :
0000000000000001
     [  177.688238] x5 : ffffb5ed1d893000 x4 : dfff800000000000 x3 :
ffffb5ed18b89520
     [  177.689912] x2 : 0000000000000000 x1 : 0000000000000000 x0 :
ffff000007150000
     [  177.691598] Call trace:
     [  177.692165]  kmem_cache_destroy+0x1e8/0x20c
     [  177.693196]  test_exit+0x28/0x40
     [  177.694158]  kunit_catch_run_case+0x5c/0x120
     [  177.695177]  kunit_try_catch_run+0x144/0x26c
     [  177.696211]  kunit_run_case_catch_errors+0x158/0x1e0
     [  177.697353]  kunit_run_tests+0x374/0x750
     [  177.698333]  __kunit_test_suites_init+0x74/0xa0
     [  177.699386]  kunit_run_all_tests+0x160/0x380
     [  177.700428]  kernel_init_freeable+0x32c/0x388
     [  177.701497]  kernel_init+0x2c/0x150
     [  177.702347]  ret_from_fork+0x10/0x20
     [  177.703308] ---[ end trace 0000000000000000 ]---

[1] https://tuxapi.tuxsuite.com/v1/groups/linaro/projects/lkft/tests/2FcCyacq1SusUcnAfamULqzkdUA

---
mm/slab_common: fix possible double free of kmem_cache
[ Upstream commit d71608a877362becdc94191f190902fac1e64d35 ]

When doing slub_debug test, kfence's 'test_memcache_typesafe_by_rcu'
kunit test case cause a use-after-free error:

  BUG: KASAN: use-after-free in kobject_del+0x14/0x30
  Read of size 8 at addr ffff888007679090 by task kunit_try_catch/261

  CPU: 1 PID: 261 Comm: kunit_try_catch Tainted: G    B            N
6.0.0-rc5-next-20220916 #17
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1
04/01/2014
  Call Trace:
   <TASK>
   dump_stack_lvl+0x34/0x48
   print_address_description.constprop.0+0x87/0x2a5
   print_report+0x103/0x1ed
   kasan_report+0xb7/0x140
   kobject_del+0x14/0x30
   kmem_cache_destroy+0x130/0x170
   test_exit+0x1a/0x30
   kunit_try_run_case+0xad/0xc0
   kunit_generic_run_threadfn_adapter+0x26/0x50
   kthread+0x17b/0x1b0
   </TASK>

The cause is inside kmem_cache_destroy():

kmem_cache_destroy
    acquire lock/mutex
    shutdown_cache
schedule_work(kmem_cache_release) (if RCU flag set)
    release lock/mutex
    kmem_cache_release (if RCU flag not set)

In some certain timing, the scheduled work could be run before
the next RCU flag checking, which can then get a wrong value
and lead to double kmem_cache_release().

Fix it by caching the RCU flag inside protected area, just like 'refcnt'

Fixes: 0495e337b703 ("mm/slab_common: Deleting kobject in
kmem_cache_destroy() without holding slab_mutex/cpu_hotplug_lock")
Signed-off-by: Feng Tang <feng.tang@intel.com>
Reviewed-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Reviewed-by: Waiman Long <longman@redhat.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>


## Build
* kernel: 5.19.13-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.19.y
* git commit: 0d49bf6408c47f815c7e056a006617d5431b1bed
* git describe: v5.19.12-102-g0d49bf6408c4
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.19.y/build/v5.19.12-102-g0d49bf6408c4

## No Test Regressions (compared to v5.19.12)

## No Metric Regressions (compared to v5.19.12)

## No Test Fixes (compared to v5.19.12)

## No Metric Fixes (compared to v5.19.12)

## Test result summary
total: 119604, pass: 105318, fail: 1117, skip: 12815, xfail: 354

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 339 total, 336 passed, 3 failed
* arm64: 73 total, 70 passed, 3 failed
* i386: 62 total, 55 passed, 7 failed
* mips: 62 total, 59 passed, 3 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 75 total, 66 passed, 9 failed
* riscv: 32 total, 27 passed, 5 failed
* s390: 26 total, 24 passed, 2 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x86_64: 66 total, 63 passed, 3 failed

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

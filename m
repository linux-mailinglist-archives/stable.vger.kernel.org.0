Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF9860589E
	for <lists+stable@lfdr.de>; Thu, 20 Oct 2022 09:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbiJTHcE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 03:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbiJTHcD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 03:32:03 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 299EE168E44
        for <stable@vger.kernel.org>; Thu, 20 Oct 2022 00:31:56 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id r17so45256015eja.7
        for <stable@vger.kernel.org>; Thu, 20 Oct 2022 00:31:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xDBncgAiJTKyAKFyfrX2xb6cbJy4HaRcylIbeozYuwc=;
        b=aMBXdI5GRTpVOYf8k4ynIpfnGkiswcTFnU6hGkpMRB4zDxjffVzibq4CWDQmmjn0WO
         Rc67HtQ0AtvU4p/bgZ9vmXrGrcTXowZan8bMbNe8Ob3Ntziv9EFhJ6KA75MozpzcWTFq
         41PhdwnCsV9dU0nmToC5tBVLG4OZWO1lT8fZKTcP/xMMjDs6WvQT0c9V47aqtyIvVGTz
         sKzQYb5LNZpfHLNrEK+Gs/pevK0xnmTU7D1vpzkdTNUFAN8rNJ76GiywQg6+L8q5Ui/8
         824YSdaxkH5gtDaFpgsJzXG7EANS6xnCtT2xajHBFBDot9KNOkYWxfY++drXG6J455G5
         SJKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xDBncgAiJTKyAKFyfrX2xb6cbJy4HaRcylIbeozYuwc=;
        b=6Lscmt9OApHBgBP2Y82Wp/VvV6XRuUNoK3BpprE7pgU0W3pngPZaUrtUB8in3VCl6i
         Ba8Za/mckp9rIZPqWjcWHx8uQ/Rn+kXLabFzQ5ee0Aerqc02K4J/spxdEbaD+DWTHjg7
         e4tIYJ1rIxqlatIQAB3Pjcxh2+jdKH/pPqLinCMWimDTkcSKlkXcf08mWjC8xv/FHk2t
         IkCyUxkFzvbh4k5en84ByJv5Qps1mP00+GBNIq7wekIxDF3TM9nV91AciOwz6sI75ymY
         AG7qarUAzLVjmkbtad9pb+HLzBaFhcWA9CaK2vF+rUdZr2bI+j7vXq7koOQuYg5iWxQ5
         avqg==
X-Gm-Message-State: ACrzQf3aeEoKFnKmhR9HGXa6muxFY4zyuu5qV/9rmKPzYJKLoWpyEjIN
        nITIMRH+xC65WBbYcyqzyvcLws42q64nUfwS1gwcdw==
X-Google-Smtp-Source: AMsMyM5DCABZytCEh0gWJYVKJHqRYPJCfoW2zBmcuVrqxq2bU/qtMxYdVzlaiX+EPwGYWdux2a5oEnjDlQJBZCL9qzI=
X-Received: by 2002:a17:906:fe45:b0:788:15a5:7495 with SMTP id
 wz5-20020a170906fe4500b0078815a57495mr9974595ejb.633.1666251113791; Thu, 20
 Oct 2022 00:31:53 -0700 (PDT)
MIME-Version: 1.0
References: <20221019083249.951566199@linuxfoundation.org>
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 20 Oct 2022 13:01:41 +0530
Message-ID: <CA+G9fYuGbryDXyQSPR7yfht7stD2S=cXez6zxhNJENGbEETWeQ@mail.gmail.com>
Subject: Re: [PATCH 6.0 000/862] 6.0.3-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 19 Oct 2022 at 14:08, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.0.3 release.
> There are 862 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 21 Oct 2022 08:30:19 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.3-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

A list of kernel warning / BUGs/ oops / invalid opcode are coming from
mainline kernel.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
Following kernel warning noticed on arm64 Qcom db410c device while
booting with kselftest merge configs. This is reported on mainline [1] & [2].

[   29.638854] qcom-camss: probe of 1b0ac00.camss failed with error -17
[   29.772896] ------------[ cut here ]------------
[   29.773376] list_add corruption. prev->next should be next
(ffff000004771300), but was 0000000000000000. (prev=ffff000010c13e00).
[   29.777423] WARNING: CPU: 1 PID: 283 at lib/list_debug.c:30
__list_add_valid+0xdc/0x110
[   29.784013] NET: Registered PF_QIPCRTR protocol family
[   29.788398] Modules linked in: qrtr(+) rtc_pm8xxx(+) qcom_pon(+)
qcom_spmi_vadc(+) qcom_vadc_common qcom_q6v5_mss(+) qcom_pil_info
qcom_q6v5 qcom_sysmon qcom_camss qcom_common videobuf2_dma_sg
qcom_glink_smem qmi_helpers venus_core(+) v4l2_fwnode qcom_stats
gpu_sched v4l2_async v4l2_mem2mem drm_dp_aux_bus qnoc_msm8916 qcom_rng
mdt_loader videobuf2_memops videobuf2_v4l2 drm_display_helper
i2c_qcom_cci videobuf2_common icc_smd_rpm display_connector
drm_kms_helper rmtfs_mem socinfo fuse drm
[   29.823494] CPU: 1 PID: 283 Comm: systemd-udevd Not tainted 6.0.2 #1
[   29.844890] Hardware name: Qualcomm Technologies, Inc. APQ 8016 SBC (DT)
[   29.851234] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[   29.857919] pc : __list_add_valid+0xdc/0x110
[   29.864544] lr : __list_add_valid+0xdc/0x110

ref:
[1 ] https://lore.kernel.org/all/CA+G9fYuB1-qmObe3L0A0oUDXXaWa=-UxOEGtEWWJ-=_wc791Uw@mail.gmail.com/
[2] https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.0.y/build/v6.0.2/testrun/12505842/suite/log-parser-test/test/check-kernel-exception/log


Following warning noticed on arm64 Qcom db845c device while booting with the
Kselftest merge configs enabled.

[   20.438279] ============================================
[   20.443648] WARNING: possible recursive locking detected
[   20.449018] 6.0.2 #1 Not tainted
[   20.452283] --------------------------------------------
[   20.457649] kworker/u16:1/11 is trying to acquire lock:
[   20.462927] cfg80211: Loading compiled-in X.509 certificates for
regulatory database
[   20.470748] ffff6ca7c8e428f8 (&irq_desc_lock_class){-.-.}-{2:2},
at: __irq_get_desc_lock+0x64/0xac
[   20.479825]
[   20.479825] but task is already holding lock:
[   20.485717] ffff6ca7cb75c0f8 (&irq_desc_lock_class){-.-.}-{2:2},
at: __irq_get_desc_lock+0x64/0xac
[   20.494777]
[   20.494777] other info that might help us debug this:
[   20.501372]  Possible unsafe locking scenario:
[   20.501372]
[   20.507351]        CPU0
[   20.509834]        ----
[   20.512314]   lock(&irq_desc_lock_class);
[   20.516374]   lock(&irq_desc_lock_class);
[   20.520448]
[   20.520448]  *** DEADLOCK ***

[3] https://lore.kernel.org/all/CA+G9fYui6--jhN1CFH6fXNK81sHNYgosTs2hyybFqPxFRvndpg@mail.gmail.com/


The following invalid opcode found while running selftests: memfd:
run_hugetlbfs_test.sh on i386 with kselftest configs enabled [4] & [5].

# selftests: memfd: run_hugetlbfs_test.sh
[   75.841946] run_hugetlbfs_t (1296): drop_caches: 3
[   75.890473] invalid opcode: 0000 [#1] PREEMPT SMP
[   75.895185] CPU: 1 PID: 1300 Comm: memfd_test Tainted: G
     N 6.0.3-rc1 #1
[   75.903185] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.5 11/26/2020
[   75.910576] EIP: hugetlb_file_setup.cold+0x0/0x33
[   75.915312] Code: b8 ea ff ff ff e9 52 8e 26 ff 0f 0b c7 04 24 70
75 63 d6 e8 a7 4a ff ff b8 ea ff ff ff e9 57 97 26 ff 0f 0b 0f 0b 0f
0b 0f 0b <0f> 0b 64 a1 58 b8 bd d6 c6 05 bd c0 a6 d6 01 8b 90 ec 03 00
00 05
[   75.934053] EAX: c5360dd0 EBX: 00000000 ECX: 00000020 EDX: 00000000
[   75.940311] ESI: 80000004 EDI: 00000005 EBP: c5405ea0 ESP: c5405e80
[   75.946620] DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068 EFLAGS: 00010212
[   75.953399] CR0: 80050033 CR2: 00000000 CR3: 06405000 CR4: 003506d0
[   75.959665] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   75.965920] DR6: fffe0ff0 DR7: 00000400
[   75.969753] Call Trace:
[   75.972199]  __ia32_sys_memfd_create+0x196/0x220
[   75.976816]  __do_fast_syscall_32+0x77/0xd0
[   75.981008]  do_fast_syscall_32+0x32/0x70
[   75.985023]  do_SYSENTER_32+0x15/0x20
[   75.988680]  entry_SYSENTER_32+0x98/0xf6
[   75.992605] EIP: 0xb7f31549
[   75.995399] Code: 03 74 c0 01 10 05 03 74 b8 01 10 06 03 74 b4 01
10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 51 52 55 89 e5 0f
34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d 76 00 58 b8 77 00 00 00 cd 80 90
8d 76
[   76.014144] EAX: ffffffda EBX: 0804b486 ECX: 80000004 EDX: 080493de
[   76.020410] ESI: b7d10220 EDI: b7e068f0 EBP: bffad738 ESP: bffad6cc
[   76.026668] DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 00000296
[   76.033455] Modules linked in: x86_pkg_temp_thermal fuse configfs
[last unloaded: test_strscpy(N)]
[   76.042444] ---[ end trace 0000000000000000 ]---
[   76.047070] EIP: hugetlb_file_setup.cold+0x0/0x33
[   76.051777] Code: b8 ea ff ff ff e9 52 8e 26 ff 0f 0b c7 04 24 70
75 63 d6 e8 a7 4a ff ff b8 ea ff ff ff e9 57 97 26 ff 0f 0b 0f 0b 0f
0b 0f 0b <0f> 0b 64 a1 58 b8 bd d6 c6 05 bd c0 a6 d6 01 8b 90 ec 03 00
00 05
[   76.070550] EAX: c5360dd0 EBX: 00000000 ECX: 00000020 EDX: 00000000
[   76.076841] ESI: 80000004 EDI: 00000005 EBP: c5405ea0 ESP: c5405e80
[   76.083133] DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068 EFLAGS: 00010212
[   76.089945] CR0: 80050033 CR2: 00000000 CR3: 06405000 CR4: 003506d0
[   76.096211] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   76.102483] DR6: fffe0ff0 DR7: 00000400
# ./run_hugetlbfs_test.sh: line 60:  1300 Segmentation fault
./memfd_test hugetlbfs
# opening: ./mnt/memfd
# fuse: DONE
ok 3 selftests: memfd: run_hugetlbfs_test.sh

[4] https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.0.y/build/v6.0-916-g844297340351/testrun/12536148/suite/log-parser-test/tests/
[5] https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.0.y/build/v6.0-916-g844297340351/testrun/12536148/suite/log-parser-test/test/check-kernel-invalid-opcode/log


While running perf test cases on qemu_x86_64 this kernel BUG noticed [6].

unsupp  '/usr/libexec/perf-core/tests/attr/test-record-branch-filter-ind_call'
running '/usr/libexec/perf-core/tests/attr/test-record-group'
[  204.124863] BUG: kernel NULL pointer dereference, address: 0000000000000198
[  204.125878] #PF: supervisor read access in kernel mode
[  204.126482] #PF: error_code(0x0000) - not-present page
[  204.127127] PGD 0 P4D 0
[  204.127435] Oops: 0000 [#1] PREEMPT SMP NOPTI
[  204.127939] CPU: 3 PID: 574 Comm: perf-exec Not tainted 6.0.3-rc1 #1
[  204.128711] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 1.12.0-1 04/01/2014
[  204.129619] RIP: 0010:x86_pmu_enable_event+0x43/0x130

[6] https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.0.y/build/v6.0-916-g844297340351/testrun/12536939/suite/log-parser-test/test/check-kernel-bug/log

Following kernel crash log noticed while running selftests: net: pmtu.sh on
x15 device [7] with kselftest merge configs enabled.

# selftests: net: pmtu.sh
...
# TEST: IPv4 over vxlan6: PMTU exceptions                             [ OK ]
[  169.299682] 8<--- cut here ---
[  169.302764] Unable to handle kernel paging request at virtual
address 2c86c000
[  169.310089] [2c86c000] *pgd=00000000
[  169.313720] Internal error: Oops: 5 [#1] SMP ARM
[  169.318359] Modules linked in: act_csum act_pedit cls_flower
sch_prio ip_tables x_tables veth tun cfg80211 bluetooth
snd_soc_simple_card snd_soc_simple_card_utils etnaviv gpu_sched
onboard_usb_hub snd_soc_davinci_mcasp snd_soc_ti_udma snd_soc_ti_edma
snd_soc_ti_sdma snd_soc_core ac97_bus snd_pcm_dmaengine snd_pcm
snd_timer snd soundcore display_connector fuse [last unloaded:
test_blackhole_dev]
[  169.353576] CPU: 0 PID: 295 Comm: rngd Not tainted 6.0.3-rc1 #1
[  169.359527] Hardware name: Generic DRA74X (Flattened Device Tree)
[  169.365631] PC is at percpu_counter_add_batch+0x28/0xc4

[7] https://lore.kernel.org/all/CA+G9fYvepPVpDn5AP6bwDukpx7h++avMPEUARuHyvJqWwQ84uQ@mail.gmail.com/T/#u

## Build
* kernel: 6.0.3-rc1
* git: ['https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc',
'https://gitlab.com/mrchapp/linux']
* git branch: linux-6.0.y
* git commit: 84429734035197a6ab8e79c852d5e4e6ed744703
* git describe: v6.0-916-g844297340351
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.0.y/build/v6.0-916-g844297340351

## No Test Regressions (compared to v6.0.2)

## No Metric Regressions (compared to v6.0.2)

## No Test Fixes (compared to v6.0.2)

## No Metric Fixes (compared to v6.0.2)

## Test result summary
total: 131365, pass: 113062, fail: 4832, skip: 13064, xfail: 407

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 311 total, 307 passed, 4 failed
* arm64: 64 total, 64 passed, 0 failed
* i386: 55 total, 55 passed, 0 failed
* mips: 56 total, 55 passed, 1 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 69 total, 63 passed, 6 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 21 total, 21 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 58 total, 58 passed, 0 failed

## Test suites summary
* /
* fwts
* igt-gpu-tools
* kself0009test-sync
* kself[
* kselft[
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
* ltp-at
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
* ltp-ip
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

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACEF4D5F73
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 11:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239804AbiCKK1f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Mar 2022 05:27:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236749AbiCKK1f (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Mar 2022 05:27:35 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C360B7560A
        for <stable@vger.kernel.org>; Fri, 11 Mar 2022 02:26:31 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id z30so16304400ybi.2
        for <stable@vger.kernel.org>; Fri, 11 Mar 2022 02:26:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=H8XdOIjhEBVBtYM19xrN0/Jeg2YN1zi6ncYoMB8TK6I=;
        b=g3BDUA3YRUbB4GhwoN+slHSSCdnPAmSdoIbF0co4/GCmv5Po01qmF4Ppoty50bqkvN
         m1F652f6t8CnVqIkshI98p5kITAWTzXvzDxdRX5XLNmHif3Peow5PVmgaB4lelqk39cg
         iiIvbLrbuHPdk0bRUCk2TBI/VotMjTiIhFDjlg7btiaiAT+z1/AHnsoKJdH26j+PcRzp
         qMAq1XTTlumfNM+Yude7IjuVj7EYi8yU4Jh6IVg96BuZA2LRtnktMLjx9/X7AbcZPz4R
         pdyY8vMOScSoBwuGgBu8/uPSZ8rzZqLEXMvOoEnFVdBA5eFuXXZn+5twJA0IZC2x8cjZ
         syUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=H8XdOIjhEBVBtYM19xrN0/Jeg2YN1zi6ncYoMB8TK6I=;
        b=Ey84/3EdXU5r3FIwfvVxzJnKHlT8l+08MLtouYWpqexhF+Lkg/4MN4nnOl7nCbIEmR
         FiyJH93ezom6F8bAqnYKa76QHK8o7c79PSKtwntWLyMZO/kKU6EE34ExNpYfrMbwYBgz
         b+4AMRgo7ejEgWh9gbLVhqjilXau5xDQQLqbKKZlCT//CSj75OlnbXW9o3z0FFcQhOYh
         F5zOE8RFxWBGE8DAfE2zx7AaP8mfjLHuaKmRLkIL6IL8iABqWk0bfcn2ZQjrMzpbzxts
         8LYE0Y6clnXdb0TtoyYNMbnZKVeVV6FrGumVEXcQBRnbS6MwmzusKks8rwauLv1hoCqE
         Sh3Q==
X-Gm-Message-State: AOAM531Z+wCcpaa2fz4qYd8Au77dBVRjMD7FDfeIeoIxRU/mLp7HwMfc
        XVizNrZC6O54kjHtwo7oTi2NSXJXnbp0YEbCzj1H3A==
X-Google-Smtp-Source: ABdhPJw5h9L0QdMK5g2+2AO15wqxTQHD937yG/rMQ+lYyTlFNqlH8FOvrpfP5PAOBABc956jySGWK7/Jg520AHVn4NE=
X-Received: by 2002:a25:f505:0:b0:624:f6f9:7bf3 with SMTP id
 a5-20020a25f505000000b00624f6f97bf3mr7133067ybe.465.1646994390982; Fri, 11
 Mar 2022 02:26:30 -0800 (PST)
MIME-Version: 1.0
References: <20220310140812.983088611@linuxfoundation.org>
In-Reply-To: <20220310140812.983088611@linuxfoundation.org>
From:   Anders Roxell <anders.roxell@linaro.org>
Date:   Fri, 11 Mar 2022 11:26:20 +0100
Message-ID: <CADYN=9K=QZ81nTZk7fCEb1Chh8y6H1ZOtTW8AJ-VvnTqhmO2RQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/58] 5.15.28-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com, Arnd Bergmann <arnd@arndb.de>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 10 Mar 2022 at 15:29, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.28 release.
> There are 58 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 12 Mar 2022 14:07:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.28-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Results from Linaro=E2=80=99s test farm.
No test regressions on arm64, arm, x86_64, and i386.

But we found following kernel crash [1] on rpi-4 while running LTP controll=
ers
tests we are in process to reproduce and bisect the issue.


cgroup_fj_stress_cpuset_4_4_one 1 TINFO: Subsystem cpuset is mounted
at /sys/fs/cgroup/cpuset
cgroup_fj_stress_cpuset_4_4_one 1 TINFO: Creating subgroups ...
[  311.726342] Unhandled fault at 0xffff800014cfba10
[  311.731137] Mem abort info:
[  311.733968]   ESR =3D 0x96000070
[  311.737065]   EC =3D 0x25: DABT (current EL), IL =3D 32 bits
[  311.742454]   SET =3D 0, FnV =3D 0
[  311.745549]   EA =3D 0, S1PTW =3D 0
[  311.748733]   FSC =3D 0x30: TLB conflict abort
[  311.753062] Data abort info:
[  311.755979]   ISV =3D 0, ISS =3D 0x00000070
[  311.759866]   CM =3D 0, WnR =3D 1
[  311.762872] swapper pgtable: 4k pages, 48-bit VAs, pgdp=3D0000000001e940=
00
[  311.769673] [ffff800014cfba10] pgd=3D10000000fbfff003,
p4d=3D10000000fbfff003, pud=3D10000000fbffe003, pmd=3D100000004c6ee003,
pte=3D0068000049a2b703
[  311.782405] Internal error: TLB conflict abort: 96000070 [#1] PREEMPT SM=
P
[  311.789294] Modules linked in: btrfs blake2b_generic libcrc32c xor
xor_neon zstd_compress raid6_pq brcmfmac brcmutil xhci_pci
xhci_pci_renesas snd_soc_hdmi_codec raspberrypi_cpufreq hci_uart btqca
btbcm cfg80211 bluetooth bcm2711_thermal reset_raspberrypi
clk_raspberrypi vc4 iproc_rng200 raspberrypi_hwmon rng_core cec rfkill
drm_kms_helper pwm_bcm2835 i2c_bcm2835 drm pcie_brcmstb crct10dif_ce
fuse
[  311.825153] CPU: 0 PID: 8326 Comm: cgroup_fj_stres Not tainted 5.15.28-r=
c2 #1
[  311.832396] Hardware name: Raspberry Pi 4 Model B (DT)
[  311.837608] pstate: 200003c5 (nzCv DAIF -PAN -UAO -TCO -DIT -SSBS BTYPE=
=3D--)
[  311.844675] pc : el1h_64_sync+0x0/0x7c
[  311.848485] lr : charge_memcg+0xa0/0xe0
[  311.852384] sp : ffff800014cfba10
[  311.855742] x29: ffff800014cfbb60 x28: ffff000041dfcd80 x27: 00000000000=
00002
[  311.862995] x26: ffff000040d24068 x25: ffff000040d24000 x24: 000000000a2=
ee000
[  311.870246] x23: ffff000040d24000 x22: ffff000042a05300 x21: 00000000000=
00001
[  311.877497] x20: fffffc00017942c0 x19: ffff0000401aa000 x18: 00000000000=
00000
[  311.884745] x17: 00000001506d3517 x16: 000000000a2eef60 x15: 000000000a2=
eefc0
[  311.891994] x14: 0000000000000000 x13: 0000000000000031 x12: 00000000000=
00000
[  311.899244] x11: 0054434552524f43 x10: 5f594c5849534f50 x9 : ffff8000082=
f75ac
[  311.906494] x8 : 0000000000000000 x7 : 0054434552524f43 x6 : 00000000000=
00000
[  311.913743] x5 : 0000000000000001 x4 : 0000000000000001 x3 : 00000000000=
778d4
[  311.920992] x2 : ffff800009ea06f0 x1 : 0000000000077859 x0 : ffff8000ed9=
06000
[  311.928242] Call trace:
[  311.930718]  el1h_64_sync+0x0/0x7c
[  311.934170]  __mem_cgroup_charge+0x44/0x8c
[  311.938326]  wp_page_copy+0xcc/0x890
[  311.941955]  do_wp_page+0xa0/0x470
[  311.945405]  __handle_mm_fault+0x694/0xf90
[  311.949561]  handle_mm_fault+0x100/0x2a4
[  311.953540]  do_page_fault+0x178/0x4a0
[  311.957349]  do_mem_abort+0x4c/0xc0
[  311.960891]  el0_da+0x3c/0x90
[  311.963904]  el0t_64_sync_handler+0xe8/0x130
[  311.968239]  el0t_64_sync+0x1a0/0x1a4
[  311.971960] Code: d503201f 910003e0 9449917e 140003c9 (a90007e0)
[  311.978146] ---[ end trace 973edfaca15d48cf ]---
[  423.848645] audit: type=3D1701 audit(1618432859.639:3):
auid=3D4294967295 uid=3D993 gid=3D990 ses=3D4294967295 pid=3D247
comm=3D\"systemd-network\" exe=3D\"/lib/systemd/systemd-networkd\" sig=3D6
res=3D1

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>


## Build
* kernel: 5.15.28-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.15.y
* git commit: 733316a3fd593d01eef349f96da2ba8f870f6245
* git describe: v5.15.27-59-g733316a3fd59
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.27-59-g733316a3fd59

## Test Regressions (compared to v5.15.27-41-g5ad72e40dcac)
No test regressions found.


## Metric Regressions (compared to v5.15.27-41-g5ad72e40dcac)
No metric regressions found.

## Test Fixes (compared to v5.15.27-41-g5ad72e40dcac)
No test fixes found.

## Metric Fixes (compared to v5.15.27-41-g5ad72e40dcac)
No metric fixes found.

## Test result summary
total: 111202, pass: 94014, fail: 1081, skip: 14902, xfail: 1205

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 296 total, 293 passed, 3 failed
* arm64: 47 total, 47 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 45 total, 41 passed, 4 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 41 total, 37 passed, 4 failed
* parisc: 14 total, 14 passed, 0 failed
* powerpc: 65 total, 50 passed, 15 failed
* riscv: 32 total, 27 passed, 5 failed
* s390: 26 total, 23 passed, 3 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 47 total, 47 passed, 0 failed

## Test suites summary
* fwts
* igt-gpu-tools
* kselftest-
* kselftest-android
* kselftest-arm64
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
* kselftest-lkdtm
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
* kunit
* kvm-unit-tests
* libgpiod
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
* vdso

--
Linaro LKFT
https://lkft.linaro.org

[1] https://lkft.validation.linaro.org/scheduler/job/4698750#L7563

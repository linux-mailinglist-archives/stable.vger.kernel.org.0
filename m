Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B739C36B624
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 17:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233829AbhDZPvh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 11:51:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234043AbhDZPvg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Apr 2021 11:51:36 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B23C1C061756
        for <stable@vger.kernel.org>; Mon, 26 Apr 2021 08:50:53 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id 82-20020a1c01550000b0290142562ff7c9so1212667wmb.3
        for <stable@vger.kernel.org>; Mon, 26 Apr 2021 08:50:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Km0Bq3R/N9AvpuGgnL/lFxl1gODZc8gkQbufpXgHC40=;
        b=UAOKvU2edQ0PDVaBHwkHuGVVd1/daI6nsmLcPnEw6ZTP/+mpzBuE0NxPLstzTLXmYD
         Z0SCNsYVgLvtLfsknWx1a3xotrBLJ3ECy/ekSggNWxJrQ38vjfa/6GYLJBn8nT6ncKk2
         fBEHhPNvnTqepiMDZKaT7tAiB5Nj5rgoVxdwU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Km0Bq3R/N9AvpuGgnL/lFxl1gODZc8gkQbufpXgHC40=;
        b=K8xhLvCh56gx5jwy1uWd7fV4N2T/mEL/zbuJmK58TBWJKzznP+yrMtK2otsknz/3E/
         jAhZ0YmwNhIzgb2A3MT5LjBoAU7POdOH55hR8IDS+lqdhz+80e3EbefC1CwjZZ/qGrk5
         WFXRiKMBEI+EnKNe1DDEddA5Cj5MkFtZvekHufZGJsDycvP87Xnh+PMgN34+/Gp0/LMg
         v8MW1PxTeDF24Eh+Kll+ERlM+Op9ZnTDH8A4k3zHmyIUUcH5QPPhbY/p3kZvEgSwKRJS
         5fQ3k6h1BEq+32t/2v/kng097CC/nPQHOG0tPJesClwysAdqhaD5ptTAnv1qRmu+Qlwt
         E+Jw==
X-Gm-Message-State: AOAM532hUXx7r0b1U5dFwPDFHBBqVu6R8CGOJx+b4m7FHzLJtDGtIi5p
        MvtqAlG7il1ovdinazhywx8oeMR01JxhPQjf6pIwlQ==
X-Google-Smtp-Source: ABdhPJw2mvlc0/hKS3ChwH5XWhI/jZ7bos1kmxCGnZU332X2p5qVA0IMaz67QPNCucCwgzf5zdJOnBmbY2TEdpabSK8=
X-Received: by 2002:a05:600c:2148:: with SMTP id v8mr21360151wml.167.1619452252389;
 Mon, 26 Apr 2021 08:50:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210426072818.777662399@linuxfoundation.org>
In-Reply-To: <20210426072818.777662399@linuxfoundation.org>
From:   Patrick Mccormick <pmccormick@digitalocean.com>
Date:   Mon, 26 Apr 2021 08:50:42 -0700
Message-ID: <CAAjnzAn54_SOW2WDdh6Ji=n0q73iqMscUfmtoiHjzjZUBfW7sg@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/36] 5.10.33-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We ran tests on this kernel version:

Linux version 5.10.33-rc1-1-generic
(root@9eabe40e-b732-44f1-4800-0b445d85332c) (gcc (Ubuntu
7.3.0-27ubuntu1~18.04) 7.3.0, GNU ld (GNU Binutils for Ubuntu) 2.30)
#0964102fc SMP Mon Apr 26 07:21:26 UTC 2021

With this hardware:

model name      : Intel(R) Xeon(R) Gold 6248 CPU @ 2.50GHz

And there were no failures.

Specific tests ran:

1..40
ok 1 ltp.py:LTP.test_nptl
ok 2 ltp.py:LTP.test_math
ok 3 ltp.py:LTP.test_dio
ok 4 ltp.py:LTP.test_io
ok 5 ltp.py:LTP.test_power_management_tests
ok 6 ltp.py:LTP.test_can
ok 7 ltp.py:LTP.test_input
ok 8 ltp.py:LTP.test_hugetlb
ok 9 ltp.py:LTP.test_ipc
ok 10 ltp.py:LTP.test_uevent
ok 11 ltp.py:LTP.test_smoketest
ok 12 ltp.py:LTP.test_containers
ok 13 ltp.py:LTP.test_filecaps
ok 14 ltp.py:LTP.test_sched
ok 15 ltp.py:LTP.test_hyperthreading
ok 16 ltp.py:LTP.test_cap_bounds
ok 17 /home/ci-hypervisor/.local/lib/python3.6/site-packages/fathom/tests/kpatch.sh
ok 18 perf.py:PerfNonPriv.test_perf_help
ok 19 perf.py:PerfNonPriv.test_perf_version
ok 20 perf.py:PerfNonPriv.test_perf_list
ok 21 perf.py:PerfPriv.test_perf_record
ok 22 perf.py:PerfPriv.test_perf_cmd_kallsyms
ok 23 perf.py:PerfPriv.test_perf_cmd_annotate
ok 24 perf.py:PerfPriv.test_perf_cmd_evlist
ok 25 perf.py:PerfPriv.test_perf_cmd_script
ok 26 perf.py:PerfPriv.test_perf_stat
ok 27 perf.py:PerfPriv.test_perf_bench
ok 28 kselftest.py:kselftest.test_sysctl
ok 29 kselftest.py:kselftest.test_size
ok 30 kselftest.py:kselftest.test_sync
ok 31 kselftest.py:kselftest.test_capabilities
ok 32 kselftest.py:kselftest.test_x86
ok 33 kselftest.py:kselftest.test_pidfd
ok 34 kselftest.py:kselftest.test_membarrier
ok 35 kselftest.py:kselftest.test_sigaltstack
ok 36 kselftest.py:kselftest.test_tmpfs
ok 37 kselftest.py:kselftest.test_user
ok 38 kselftest.py:kselftest.test_sched
ok 39 kselftest.py:kselftest.test_timens
ok 40 kselftest.py:kselftest.test_timers

Tested-By: Patrick McCormick <pmccormick@digitalocean.com>

On Mon, Apr 26, 2021 at 12:44 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.33 release.
> There are 36 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 28 Apr 2021 07:28:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.33-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------
> Pseudo-Shortlog of commits:
>
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Linux 5.10.33-rc1
>
> Mike Galbraith <efault@gmx.de>
>     x86/crash: Fix crash_setup_memmap_entries() out-of-bounds access
>
> John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
>     ia64: tools: remove duplicate definition of ia64_mf() on ia64
>
> Randy Dunlap <rdunlap@infradead.org>
>     ia64: fix discontig.c section mismatches
>
> Randy Dunlap <rdunlap@infradead.org>
>     csky: change a Kconfig symbol name to fix e1000 build error
>
> Arnd Bergmann <arnd@arndb.de>
>     kasan: fix hwasan build for gcc
>
> Wan Jiabing <wanjiabing@vivo.com>
>     cavium/liquidio: Fix duplicate argument
>
> Michael Brown <mbrown@fensystems.co.uk>
>     xen-netback: Check for hotplug-status existence before watching
>
> Jisheng Zhang <Jisheng.Zhang@synaptics.com>
>     arm64: kprobes: Restore local irqflag if kprobes is cancelled
>
> Vasily Gorbik <gor@linux.ibm.com>
>     s390/entry: save the caller of psw_idle
>
> Dinghao Liu <dinghao.liu@zju.edu.cn>
>     dmaengine: tegra20: Fix runtime PM imbalance on error
>
> Phillip Potter <phil@philpotter.co.uk>
>     net: geneve: check skb is large enough for IPv4/IPv6 header
>
> Tony Lindgren <tony@atomide.com>
>     ARM: dts: Fix swapped mmc order for omap3
>
> Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>     dmaengine: xilinx: dpdma: Fix race condition in done IRQ
>
> Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>     dmaengine: xilinx: dpdma: Fix descriptor issuing on video group
>
> Shawn Guo <shawn.guo@linaro.org>
>     soc: qcom: geni: shield geni_icc_get() for ACPI boot
>
> Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
>     HID: wacom: Assign boolean values to a bool variable
>
> Douglas Gilbert <dgilbert@interlog.com>
>     HID cp2112: fix support for multiple gpiochips
>
> Jia-Ju Bai <baijiaju1990@gmail.com>
>     HID: alps: fix error return code in alps_input_configured()
>
> Shou-Chieh Hsu <shouchieh@chromium.org>
>     HID: google: add don USB id
>
> Zhen Lei <thunder.leizhen@huawei.com>
>     perf map: Fix error return code in maps__clone()
>
> Leo Yan <leo.yan@linaro.org>
>     perf auxtrace: Fix potential NULL pointer dereference
>
> Jim Mattson <jmattson@google.com>
>     perf/x86/kvm: Fix Broadwell Xeon stepping in isolation_ucodes[]
>
> Kan Liang <kan.liang@linux.intel.com>
>     perf/x86/intel/uncore: Remove uncore extra PCI dev HSWEP_PCI_PCU_3
>
> Ali Saidi <alisaidi@amazon.com>
>     locking/qrwlock: Fix ordering in queued_write_lock_slowpath()
>
> Daniel Borkmann <daniel@iogearbox.net>
>     bpf: Tighten speculative pointer arithmetic mask
>
> Daniel Borkmann <daniel@iogearbox.net>
>     bpf: Refactor and streamline bounds check into helper
>
> Andrei Matei <andreimatei1@gmail.com>
>     bpf: Allow variable-offset stack access
>
> Yonghong Song <yhs@fb.com>
>     bpf: Permits pointers on stack for helper calls
>
> Andre Przywara <andre.przywara@arm.com>
>     arm64: dts: allwinner: Revert SD card CD GPIO for Pine64-LTS
>
> Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>     pinctrl: core: Show pin numbers for the controllers with base = 0
>
> Christoph Hellwig <hch@lst.de>
>     block: return -EBUSY when there are open partitions in blkdev_reread_part
>
> Yuanyuan Zhong <yzhong@purestorage.com>
>     pinctrl: lewisburg: Update number of pins in community
>
> Eli Cohen <elic@nvidia.com>
>     vdpa/mlx5: Set err = -ENOMEM in case dma_map_sg_attrs fails
>
> James Bottomley <James.Bottomley@HansenPartnership.com>
>     KEYS: trusted: Fix TPM reservation for seal/unseal
>
> Tony Lindgren <tony@atomide.com>
>     gpio: omap: Save and restore sysconfig
>
> Xie Yongji <xieyongji@bytedance.com>
>     vhost-vdpa: protect concurrent access to vhost device iotlb
>
>
> -------------
>
> Diffstat:
>
>  Makefile                                           |   4 +-
>  arch/arm/boot/dts/omap3.dtsi                       |   3 +
>  .../boot/dts/allwinner/sun50i-a64-pine64-lts.dts   |   2 +-
>  arch/arm64/kernel/probes/kprobes.c                 |   6 +-
>  arch/csky/Kconfig                                  |   2 +-
>  arch/csky/include/asm/page.h                       |   2 +-
>  arch/ia64/mm/discontig.c                           |   6 +-
>  arch/s390/kernel/entry.S                           |   1 +
>  arch/x86/events/intel/core.c                       |   2 +-
>  arch/x86/events/intel/uncore_snbep.c               |  61 +-
>  arch/x86/kernel/crash.c                            |   2 +-
>  block/ioctl.c                                      |   2 +
>  drivers/dma/tegra20-apb-dma.c                      |   4 +-
>  drivers/dma/xilinx/xilinx_dpdma.c                  |  31 +-
>  drivers/gpio/gpio-omap.c                           |   9 +
>  drivers/hid/hid-alps.c                             |   1 +
>  drivers/hid/hid-cp2112.c                           |  22 +-
>  drivers/hid/hid-google-hammer.c                    |   2 +
>  drivers/hid/hid-ids.h                              |   1 +
>  drivers/hid/wacom_wac.c                            |   2 +-
>  drivers/net/ethernet/cavium/liquidio/cn66xx_regs.h |   2 +-
>  drivers/net/geneve.c                               |   6 +
>  drivers/net/xen-netback/xenbus.c                   |  12 +-
>  drivers/pinctrl/core.c                             |  14 +-
>  drivers/pinctrl/intel/pinctrl-lewisburg.c          |   6 +-
>  drivers/soc/qcom/qcom-geni-se.c                    |   3 +
>  drivers/vdpa/mlx5/core/mr.c                        |   4 +-
>  drivers/vhost/vdpa.c                               |   6 +-
>  include/linux/bpf.h                                |   5 +
>  include/linux/bpf_verifier.h                       |   3 +-
>  include/linux/platform_data/gpio-omap.h            |   3 +
>  kernel/bpf/verifier.c                              | 774 ++++++++++++++++-----
>  kernel/locking/qrwlock.c                           |   7 +-
>  scripts/Makefile.kasan                             |  12 +-
>  security/keys/trusted-keys/trusted_tpm2.c          |   2 +-
>  tools/arch/ia64/include/asm/barrier.h              |   3 -
>  tools/perf/util/auxtrace.c                         |   2 +-
>  tools/perf/util/map.c                              |   7 +-
>  38 files changed, 742 insertions(+), 294 deletions(-)
>
>

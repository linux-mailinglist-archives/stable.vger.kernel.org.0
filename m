Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43E75373E16
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 17:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232449AbhEEPFv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 11:05:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232314AbhEEPFv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 11:05:51 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95000C061574
        for <stable@vger.kernel.org>; Wed,  5 May 2021 08:04:53 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id l14so2219366wrx.5
        for <stable@vger.kernel.org>; Wed, 05 May 2021 08:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=b/gil3b43S0ieNeCXFukeYwtCaimOAfyDmk3mmNDt0k=;
        b=bjHYDPdDuzWQHlg+gwdWCvNYIcKuaKHDpCoK3vQMlHqAZHYHMHoGDYyUJTXfxBDXBd
         MX+NHRiWy6WvujnWj4pasnGESsYPm0bDgfN9CiLrLMebG6tChEiCVa/5USe/Da18z2op
         ROVRddmY2OyVSvu9fdoQ9BcoECUksdT5mNL0c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=b/gil3b43S0ieNeCXFukeYwtCaimOAfyDmk3mmNDt0k=;
        b=E0Q0MTLykWEqAzxdoUou8d5++UyCut/tC2haD6gFqqaquutuc0X8ST1lh5N0STvAW1
         M2jMXsw3jKPv/5PVNlHX975Tk/Yr61FCzkr4v+dLAN/+1Vhb/bIKVWU2c9Y7IUr6XjUl
         jrsks8ToLHcf74hICscCTKyrTozCvroUCvZCFi1/Of9B9Tj6oFPvouKxYtFV3i+GpJjY
         B1Ymb8CL3HcXhSPZ8gaYOGsIlT2AiVzrzHKcmbynjXMzcDh54O3qXiRybThs0JEfytPg
         jsLvtCJbXmkjFamrN0nHgI3uHdDPK1v0XQWgv4OeNHbPyhYKs1qCZuVkgjqAltcltGwl
         VGlw==
X-Gm-Message-State: AOAM5317go5kHrSTkSS+HAyID+DTEdqBbS33Sf0yKpFSjH/r29eI51gl
        /BFLWBzEkcYlSOTFSWRkbOkLNGCL8hgc21fk56l6Cw==
X-Google-Smtp-Source: ABdhPJxnlQCKii39Jo4Wg0qd3SgH36GR20wLA7iJ/Rg/SSmlwak5bkVAGxUwG7vzfvWKu/nRVI2xEwr7uKFAQ8j53F4=
X-Received: by 2002:adf:ec4f:: with SMTP id w15mr39384123wrn.122.1620227092266;
 Wed, 05 May 2021 08:04:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210505112326.195493232@linuxfoundation.org>
In-Reply-To: <20210505112326.195493232@linuxfoundation.org>
From:   Patrick Mccormick <pmccormick@digitalocean.com>
Date:   Wed, 5 May 2021 08:04:40 -0700
Message-ID: <CAAjnzA=jBAzXjJUFR_U8yO877OcZicQYrazfgMKexzBMREuabQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/29] 5.10.35-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We ran tests on this kernel version:

Linux version 5.10.35-rc1-1-generic
(root@00b11507-3b5c-42b4-5c09-e1112ad49d4d) (gcc (Ubuntu
7.3.0-27ubuntu1~18.04) 7.3.0, GNU ld (GNU Binutils for Ubuntu) 2.30)
#4bf26f3b5 SMP Wed May 5 11:52:21 UTC 2021

With this hardware:

model name      : Intel(R) Xeon(R) Gold 6248 CPU @ 2.50GHz

And everything passed!


Specific tests ran:

1..47
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
ok 17 /home/ci-hypervisor/.local/lib/python3.6/site-packages/fathom/tests/k=
patch.sh
ok 18 perf.py:Perf.test_help
ok 19 perf.py:Perf.test_version
ok 20 perf.py:Perf.test_list
ok 21 perf.py:Perf.test_record
ok 22 perf.py:Perf.test_mem_record
ok 23 perf.py:Perf.test_kmem_record
ok 24 perf.py:Perf.test_ftrace
ok 25 perf.py:Perf.test_trace
ok 26 perf.py:Perf.test_kallsyms
ok 27 perf.py:Perf.test_annotate
ok 28 perf.py:Perf.test_evlist
ok 29 perf.py:Perf.test_script
ok 30 perf.py:Perf.test_stat
ok 31 perf.py:Perf.test_bench_sched
ok 32 perf.py:Perf.test_bench_mem
ok 33 perf.py:Perf.test_bench_numa
ok 34 perf.py:Perf.test_bench_futex
ok 35 kselftest.py:Kselftest.test_sysctl
ok 36 kselftest.py:Kselftest.test_size
ok 37 kselftest.py:Kselftest.test_sync
ok 38 kselftest.py:Kselftest.test_capabilities
ok 39 kselftest.py:Kselftest.test_x86
ok 40 kselftest.py:Kselftest.test_pidfd
ok 41 kselftest.py:Kselftest.test_membarrier
ok 42 kselftest.py:Kselftest.test_sigaltstack
ok 43 kselftest.py:Kselftest.test_tmpfs
ok 44 kselftest.py:Kselftest.test_user
ok 45 kselftest.py:Kselftest.test_sched
ok 46 kselftest.py:Kselftest.test_timens
ok 47 kselftest.py:Kselftest.test_timers

Tested-By: Patrick McCormick <pmccormick@digitalocean.com>

On Wed, May 5, 2021 at 5:09 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.35 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 07 May 2021 11:23:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.35-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
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
>     Linux 5.10.35-rc1
>
> Ondrej Mosnacek <omosnace@redhat.com>
>     perf/core: Fix unconditional security_locked_down() call
>
> Mark Pearson <markpearson@lenovo.com>
>     platform/x86: thinkpad_acpi: Correct thermal sensor allocation
>
> Shengjiu Wang <shengjiu.wang@nxp.com>
>     ASoC: ak5558: Add MODULE_DEVICE_TABLE
>
> Shengjiu Wang <shengjiu.wang@nxp.com>
>     ASoC: ak4458: Add MODULE_DEVICE_TABLE
>
> Chris Chiu <chris.chiu@canonical.com>
>     USB: Add reset-resume quirk for WD19's Realtek Hub
>
> Kai-Heng Feng <kai.heng.feng@canonical.com>
>     USB: Add LPM quirk for Lenovo ThinkPad USB-C Dock Gen2 Ethernet
>
> Takashi Iwai <tiwai@suse.de>
>     ALSA: usb-audio: Add MIDI quirk for Vox ToneLab EX
>
> Miklos Szeredi <mszeredi@redhat.com>
>     ovl: allow upperdir inside lowerdir
>
> Micka=C3=ABl Sala=C3=BCn <mic@linux.microsoft.com>
>     ovl: fix leaked dentry
>
> Jianxiong Gao <jxgao@google.com>
>     nvme-pci: set min_align_mask
>
> Jianxiong Gao <jxgao@google.com>
>     swiotlb: respect min_align_mask
>
> Jianxiong Gao <jxgao@google.com>
>     swiotlb: don't modify orig_addr in swiotlb_tbl_sync_single
>
> Jianxiong Gao <jxgao@google.com>
>     swiotlb: refactor swiotlb_tbl_map_single
>
> Jianxiong Gao <jxgao@google.com>
>     swiotlb: clean up swiotlb_tbl_unmap_single
>
> Jianxiong Gao <jxgao@google.com>
>     swiotlb: factor out a nr_slots helper
>
> Jianxiong Gao <jxgao@google.com>
>     swiotlb: factor out an io_tlb_offset helper
>
> Jianxiong Gao <jxgao@google.com>
>     swiotlb: add a IO_TLB_SIZE define
>
> Jianxiong Gao <jxgao@google.com>
>     driver core: add a min_align_mask field to struct device_dma_paramete=
rs
>
> Vasily Averin <vvs@virtuozzo.com>
>     tools/cgroup/slabinfo.py: updated to work on current kernel
>
> Thomas Richter <tmricht@linux.ibm.com>
>     perf ftrace: Fix access to pid in array when setting a pid filter
>
> Serge E. Hallyn <serge@hallyn.com>
>     capabilities: require CAP_SETFCAP to map uid 0
>
> Zhen Lei <thunder.leizhen@huawei.com>
>     perf data: Fix error return code in perf_data__create_dir()
>
> Bjorn Andersson <bjorn.andersson@linaro.org>
>     net: qrtr: Avoid potential use after free in MHI send
>
> Daniel Borkmann <daniel@iogearbox.net>
>     bpf: Fix leakage of uninitialized bpf stack under speculation
>
> Daniel Borkmann <daniel@iogearbox.net>
>     bpf: Fix masking negation logic upon negative dst register
>
> Nick Lowe <nick.lowe@gmail.com>
>     igb: Enable RSS for Intel I211 Ethernet Controller
>
> Phillip Potter <phil@philpotter.co.uk>
>     net: usb: ax88179_178a: initialize local variables before use
>
> Jonathon Reinhart <jonathon.reinhart@gmail.com>
>     netfilter: conntrack: Make global sysctls readonly in non-init netns
>
> Romain Naour <romain.naour@gmail.com>
>     mips: Do not include hi and lo in clobber list for R6
>
>
> -------------
>
> Diffstat:
>
>  Makefile                                  |   4 +-
>  arch/mips/include/asm/vdso/gettimeofday.h |  26 ++-
>  drivers/net/ethernet/intel/igb/igb_main.c |   3 +-
>  drivers/net/usb/ax88179_178a.c            |   6 +-
>  drivers/nvme/host/pci.c                   |   1 +
>  drivers/platform/x86/thinkpad_acpi.c      |  31 ++--
>  drivers/usb/core/quirks.c                 |   4 +
>  fs/overlayfs/namei.c                      |   1 +
>  fs/overlayfs/super.c                      |  12 +-
>  include/linux/bpf_verifier.h              |   5 +-
>  include/linux/device.h                    |   1 +
>  include/linux/dma-mapping.h               |  16 ++
>  include/linux/swiotlb.h                   |   1 +
>  include/linux/user_namespace.h            |   3 +
>  include/uapi/linux/capability.h           |   3 +-
>  kernel/bpf/verifier.c                     |  33 ++--
>  kernel/dma/swiotlb.c                      | 259 +++++++++++++++++-------=
------
>  kernel/events/core.c                      |  12 +-
>  kernel/user_namespace.c                   |  65 +++++++-
>  net/netfilter/nf_conntrack_standalone.c   |  10 +-
>  net/qrtr/mhi.c                            |   8 +-
>  sound/soc/codecs/ak4458.c                 |   1 +
>  sound/soc/codecs/ak5558.c                 |   1 +
>  sound/usb/quirks-table.h                  |  10 ++
>  tools/cgroup/memcg_slabinfo.py            |   8 +-
>  tools/perf/builtin-ftrace.c               |   2 +-
>  tools/perf/util/data.c                    |   5 +-
>  27 files changed, 347 insertions(+), 184 deletions(-)
>
>

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D99C93628DD
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 21:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239934AbhDPTtb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 15:49:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239187AbhDPTtb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Apr 2021 15:49:31 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3573C061574
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 12:49:04 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id x7so27730215wrw.10
        for <stable@vger.kernel.org>; Fri, 16 Apr 2021 12:49:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=NRwBpvwCUueE/ZIeq+Wh8et/RGQeyhiBzLDSN3yq4yA=;
        b=WF0LqbnNYa2+9yEwZ5UY3yr/hfc56TEDGfYoYyMGG+W2HUvrvHv6vavoeKdsfB/a6w
         ksnitxv0sIg3pBiY4Ik+qJUY0f33WKdXq/aXzhpkXH1pnCN4GmNat13wZqvlEeVuFY0L
         86Pz/Enwk9WYWZePB39fZL7LoNVJ1queq0NAA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=NRwBpvwCUueE/ZIeq+Wh8et/RGQeyhiBzLDSN3yq4yA=;
        b=TUoUP7B8IGF5hN6aeEJh4ZWfSoLVRO0er24riDLWiBDiXHCkVuKHzsfoHLF6BL+sC6
         Kl/7ii1EqxTThwcAMD3oF+ebyXzPx98iFKH6hrSp/Iz0CKgGD7oswwaDhzC8hXsWqvDG
         K+Za0kLICvyGrUa+MmbukgM8pSFvmcxc6YDey6dT77KIVbG8wO7N5z3KLNsbCYe46qi4
         QSaFx7voRW7I0gQLpkkxCVbjLzWnAzR7bqxknMub/oPEjmofNj5aK5i1v/Uqnn9nphFu
         /hx9EYhYhkiWujkzIOc3p0QgTF4Cg7ueS9ZImmh2CP58xP1S6xP/Neo2lod8/YLZR0a7
         8UNw==
X-Gm-Message-State: AOAM531uA9L3cyd/zWAnN0CHLtDFHbRmpY6giptUNFrrr0n+Lqf3Hxpj
        cLmczrB3URPRe8ZvQLJj5ex+q33nfwgN6sdWWYKbXvGbaqWCIw==
X-Google-Smtp-Source: ABdhPJwe0SQzL+j4rAJGTs0zryrgPCNV4pBvYIt9fNWQfq7zY7hPsWFgMdSShoN3L0uV60bmpQhyNYh4ntyXXMmDXR8=
X-Received: by 2002:a5d:4083:: with SMTP id o3mr775960wrp.397.1618602543443;
 Fri, 16 Apr 2021 12:49:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210415144413.165663182@linuxfoundation.org>
In-Reply-To: <20210415144413.165663182@linuxfoundation.org>
From:   Patrick Mccormick <pmccormick@digitalocean.com>
Date:   Fri, 16 Apr 2021 12:48:51 -0700
Message-ID: <CAAjnzAneHpZiZt_YiCx-4LfOk2OdVHzuJ6Hrfs3NScCK0f03ZA@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/25] 5.10.31-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We tested on this kernel:

commit 32f5704a0a4f7dcc8aa74a49dbcce359d758f6d5 (HEAD ->
rc/linux-5.10.y, stable_rc/linux-5.10.y)
Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Thu Apr 15 16:44:09 2021 +0200

    Linux 5.10.31-rc1

And all tests pass.

Specific tests ran:

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
ok 17 kpatch.sh
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

On Thu, Apr 15, 2021 at 8:06 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.31 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 17 Apr 2021 14:44:01 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.31-rc1.gz
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
>     Linux 5.10.31-rc1
>
> Juergen Gross <jgross@suse.com>
>     xen/events: fix setting irq affinity
>
> Russell King <rmk+kernel@armlinux.org.uk>
>     net: sfp: cope with SFPs that set both LOS normal and LOS inverted
>
> Russell King <rmk+kernel@armlinux.org.uk>
>     net: sfp: relax bitrate-derived mode check
>
> Arnaldo Carvalho de Melo <acme@redhat.com>
>     perf map: Tighten snprintf() string precision to pass gcc check on some 32-bit arches
>
> Florian Westphal <fw@strlen.de>
>     netfilter: x_tables: fix compat match/target pad out-of-bound write
>
> Pavel Begunkov <asml.silence@gmail.com>
>     block: don't ignore REQ_NOWAIT for direct IO
>
> Zihao Yu <yuzihao@ict.ac.cn>
>     riscv,entry: fix misaligned base for excp_vect_table
>
> Jens Axboe <axboe@kernel.dk>
>     io_uring: don't mark S_ISBLK async work as unbounded
>
> Damien Le Moal <damien.lemoal@wdc.com>
>     null_blk: fix command timeout completion handling
>
> Matthew Wilcox (Oracle) <willy@infradead.org>
>     idr test suite: Create anchor before launching throbber
>
> Matthew Wilcox (Oracle) <willy@infradead.org>
>     idr test suite: Take RCU read lock in idr_find_test_1
>
> Matthew Wilcox (Oracle) <willy@infradead.org>
>     radix tree test suite: Register the main thread with the RCU library
>
> Yufen Yu <yuyufen@huawei.com>
>     block: only update parent bi_status when bio fail
>
> Matthew Wilcox (Oracle) <willy@infradead.org>
>     radix tree test suite: Fix compilation
>
> Matthew Wilcox (Oracle) <willy@infradead.org>
>     XArray: Fix splitting to non-zero orders
>
> Mikko Perttunen <mperttunen@nvidia.com>
>     gpu: host1x: Use different lock classes for each client
>
> Dmitry Osipenko <digetx@gmail.com>
>     drm/tegra: dc: Don't set PLL clock to 0Hz
>
> Stefan Raspl <raspl@linux.ibm.com>
>     tools/kvm_stat: Add restart delay
>
> Steven Rostedt (VMware) <rostedt@goodmis.org>
>     ftrace: Check if pages were allocated before calling free_pages()
>
> Bob Peterson <rpeterso@redhat.com>
>     gfs2: report "already frozen/thawed" errors
>
> Arnd Bergmann <arnd@arndb.de>
>     drm/imx: imx-ldb: fix out of bounds array access warning
>
> Suzuki K Poulose <suzuki.poulose@arm.com>
>     KVM: arm64: Disable guest access to trace filter controls
>
> Suzuki K Poulose <suzuki.poulose@arm.com>
>     KVM: arm64: Hide system instruction access to Trace registers
>
> Andrew Price <anprice@redhat.com>
>     gfs2: Flag a withdraw if init_threads() fails
>
> Jia-Ju Bai <baijiaju1990@gmail.com>
>     interconnect: core: fix error return code of icc_link_destroy()
>
>
> -------------
>
> Diffstat:
>
>  Makefile                                        |  4 +--
>  arch/arm64/include/asm/kvm_arm.h                |  1 +
>  arch/arm64/kernel/cpufeature.c                  |  1 -
>  arch/arm64/kvm/debug.c                          |  2 ++
>  arch/riscv/kernel/entry.S                       |  1 +
>  block/bio.c                                     |  2 +-
>  drivers/block/null_blk.h                        |  1 +
>  drivers/block/null_blk_main.c                   | 26 ++++++++++++++----
>  drivers/gpu/drm/imx/imx-ldb.c                   | 10 +++++++
>  drivers/gpu/drm/tegra/dc.c                      | 10 +++----
>  drivers/gpu/host1x/bus.c                        | 10 ++++---
>  drivers/interconnect/core.c                     |  2 ++
>  drivers/net/phy/sfp-bus.c                       | 11 ++++----
>  drivers/net/phy/sfp.c                           | 36 +++++++++++++++----------
>  drivers/xen/events/events_base.c                |  4 +--
>  fs/block_dev.c                                  |  4 +++
>  fs/gfs2/super.c                                 | 14 ++++++----
>  fs/io_uring.c                                   |  2 +-
>  include/linux/host1x.h                          |  9 ++++++-
>  kernel/trace/ftrace.c                           |  9 ++++---
>  lib/test_xarray.c                               | 26 +++++++++---------
>  lib/xarray.c                                    |  4 +--
>  net/ipv4/netfilter/arp_tables.c                 |  2 ++
>  net/ipv4/netfilter/ip_tables.c                  |  2 ++
>  net/ipv6/netfilter/ip6_tables.c                 |  2 ++
>  net/netfilter/x_tables.c                        | 10 ++-----
>  tools/kvm/kvm_stat/kvm_stat.service             |  1 +
>  tools/perf/util/map.c                           |  7 +++--
>  tools/testing/radix-tree/idr-test.c             | 10 +++++--
>  tools/testing/radix-tree/linux/compiler_types.h |  0
>  tools/testing/radix-tree/multiorder.c           |  2 ++
>  tools/testing/radix-tree/xarray.c               |  2 ++
>  32 files changed, 149 insertions(+), 78 deletions(-)
>
>

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EED01373A91
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 14:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233770AbhEEML3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 08:11:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:51300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233657AbhEEMKL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 08:10:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22CD9613FB;
        Wed,  5 May 2021 12:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620216552;
        bh=MDXnc+RXAKztqWKQfFhz3dnwMdgRHv4N00NyxbCZnI4=;
        h=From:To:Cc:Subject:Date:From;
        b=GWjwK9cFC8OE6PYpALWYBfYwBzeX28NScy+cmZMxit151+pwg4wnEgNsLE2zuQkf2
         dSGjxuyfkO5v2nF2MBdLZRt3QgqE3dwuqHHV7x8gLPYJLIqp5/PaBiuDIBi5/ln0iQ
         BwgONZXp6Sm2DyD95Bz14LeMXYLoBYiXnRcE+S2Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.11 00/31] 5.11.19-rc1 review
Date:   Wed,  5 May 2021 14:05:49 +0200
Message-Id: <20210505112326.672439569@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.19-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.11.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.11.19-rc1
X-KernelTest-Deadline: 2021-05-07T11:23+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.11.19 release.
There are 31 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 07 May 2021 11:23:16 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.19-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.11.19-rc1

Ondrej Mosnacek <omosnace@redhat.com>
    perf/core: Fix unconditional security_locked_down() call

Mark Pearson <markpearson@lenovo.com>
    platform/x86: thinkpad_acpi: Correct thermal sensor allocation

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: ak5558: Add MODULE_DEVICE_TABLE

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: ak4458: Add MODULE_DEVICE_TABLE

Chris Chiu <chris.chiu@canonical.com>
    USB: Add reset-resume quirk for WD19's Realtek Hub

Kai-Heng Feng <kai.heng.feng@canonical.com>
    USB: Add LPM quirk for Lenovo ThinkPad USB-C Dock Gen2 Ethernet

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix implicit sync clearance at stopping stream

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Add MIDI quirk for Vox ToneLab EX

Miklos Szeredi <mszeredi@redhat.com>
    ovl: allow upperdir inside lowerdir

Mickaël Salaün <mic@linux.microsoft.com>
    ovl: fix leaked dentry

Jianxiong Gao <jxgao@google.com>
    nvme-pci: set min_align_mask

Jianxiong Gao <jxgao@google.com>
    swiotlb: respect min_align_mask

Jianxiong Gao <jxgao@google.com>
    swiotlb: don't modify orig_addr in swiotlb_tbl_sync_single

Jianxiong Gao <jxgao@google.com>
    swiotlb: refactor swiotlb_tbl_map_single

Jianxiong Gao <jxgao@google.com>
    swiotlb: clean up swiotlb_tbl_unmap_single

Jianxiong Gao <jxgao@google.com>
    swiotlb: factor out a nr_slots helper

Jianxiong Gao <jxgao@google.com>
    swiotlb: factor out an io_tlb_offset helper

Jianxiong Gao <jxgao@google.com>
    swiotlb: add a IO_TLB_SIZE define

Jianxiong Gao <jxgao@google.com>
    driver core: add a min_align_mask field to struct device_dma_parameters

Vasily Averin <vvs@virtuozzo.com>
    tools/cgroup/slabinfo.py: updated to work on current kernel

Thomas Richter <tmricht@linux.ibm.com>
    perf ftrace: Fix access to pid in array when setting a pid filter

Serge E. Hallyn <serge@hallyn.com>
    capabilities: require CAP_SETFCAP to map uid 0

Zhen Lei <thunder.leizhen@huawei.com>
    perf data: Fix error return code in perf_data__create_dir()

Bjorn Andersson <bjorn.andersson@linaro.org>
    net: qrtr: Avoid potential use after free in MHI send

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix leakage of uninitialized bpf stack under speculation

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix masking negation logic upon negative dst register

Nick Lowe <nick.lowe@gmail.com>
    igb: Enable RSS for Intel I211 Ethernet Controller

Imre Deak <imre.deak@intel.com>
    drm/i915: Disable runtime power management during shutdown

Phillip Potter <phil@philpotter.co.uk>
    net: usb: ax88179_178a: initialize local variables before use

Jonathon Reinhart <jonathon.reinhart@gmail.com>
    netfilter: conntrack: Make global sysctls readonly in non-init netns

Romain Naour <romain.naour@gmail.com>
    mips: Do not include hi and lo in clobber list for R6


-------------

Diffstat:

 Makefile                                  |   4 +-
 arch/mips/include/asm/vdso/gettimeofday.h |  26 ++-
 drivers/gpu/drm/i915/i915_drv.c           |  10 ++
 drivers/net/ethernet/intel/igb/igb_main.c |   3 +-
 drivers/net/usb/ax88179_178a.c            |   6 +-
 drivers/nvme/host/pci.c                   |   1 +
 drivers/platform/x86/thinkpad_acpi.c      |  31 ++--
 drivers/usb/core/quirks.c                 |   4 +
 fs/overlayfs/namei.c                      |   1 +
 fs/overlayfs/super.c                      |  12 +-
 include/linux/bpf_verifier.h              |   5 +-
 include/linux/device.h                    |   1 +
 include/linux/dma-mapping.h               |  16 ++
 include/linux/swiotlb.h                   |   1 +
 include/linux/user_namespace.h            |   3 +
 include/uapi/linux/capability.h           |   3 +-
 kernel/bpf/verifier.c                     |  33 ++--
 kernel/dma/swiotlb.c                      | 259 +++++++++++++++++-------------
 kernel/events/core.c                      |  12 +-
 kernel/user_namespace.c                   |  65 +++++++-
 net/netfilter/nf_conntrack_standalone.c   |  10 +-
 net/qrtr/mhi.c                            |   8 +-
 sound/soc/codecs/ak4458.c                 |   1 +
 sound/soc/codecs/ak5558.c                 |   1 +
 sound/usb/endpoint.c                      |   8 +-
 sound/usb/quirks-table.h                  |  10 ++
 tools/cgroup/memcg_slabinfo.py            |   8 +-
 tools/perf/builtin-ftrace.c               |   2 +-
 tools/perf/util/data.c                    |   5 +-
 29 files changed, 361 insertions(+), 188 deletions(-)



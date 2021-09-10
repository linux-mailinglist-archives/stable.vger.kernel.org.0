Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60C4B406C2F
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 14:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234041AbhIJMhg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 08:37:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:51508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234577AbhIJMgW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Sep 2021 08:36:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBCD661260;
        Fri, 10 Sep 2021 12:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631277309;
        bh=UBiXbtpLRqIchTlRMj1HDcx+PZASNmtKMbChUQmOxYo=;
        h=From:To:Cc:Subject:Date:From;
        b=e2eGr+Zt0B+AIb2yuyNSpROxK7iyrBvBGxDKG4V3rRaq6HjLO0uA8fjcQgLBsuFuI
         KqhdCFOYkR1ZfEfEFiZ1xmwBN1wjU+4Mq87dHiPnpNOFHt+EKd06f8GcOV/YdDllDx
         oZepBbS5p80HI6VranuTwfi3l4kuwv3SOgq4mbhg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.4 00/37] 5.4.145-rc1 review
Date:   Fri, 10 Sep 2021 14:30:03 +0200
Message-Id: <20210910122917.149278545@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.145-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.145-rc1
X-KernelTest-Deadline: 2021-09-12T12:29+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.145 release.
There are 37 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 12 Sep 2021 12:29:07 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.145-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.145-rc1

Marek Behún <kabel@kernel.org>
    PCI: Call Max Payload Size-related fixup quirks early

Paul Gortmaker <paul.gortmaker@windriver.com>
    x86/reboot: Limit Dell Optiplex 990 quirk to early BIOS versions

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: fix unsafe memory usage in xhci tracing

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: mtu3: fix the wrong HS mult value

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: mtu3: use @mult for HS isoc or intr

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    usb: host: xhci-rcar: Don't reload firmware after the completion

Alexander Tsoy <alexander@tsoy.me>
    ALSA: usb-audio: Add registration quirk for JBL Quantum 800

Qu Wenruo <wqu@suse.com>
    Revert "btrfs: compression: don't try to compress if we don't have enough pages"

Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
    x86/events/amd/iommu: Fix invalid Perf result due to IOMMU PMC power-gating

Hayes Wang <hayeswang@realtek.com>
    Revert "r8169: avoid link-up interrupt issue on RTL8106e if user enables ASPM"

Muchun Song <songmuchun@bytedance.com>
    mm/page_alloc: speed up the iteration of max_order

Esben Haabendal <esben@geanix.com>
    net: ll_temac: Remove left-over debug message

Fangrui Song <maskray@google.com>
    powerpc/boot: Delete unneeded .globl _zimage_start

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    ipv4/icmp: l3mdev: Perform icmp error route lookup on source device routing table (v2)

Tom Rix <trix@redhat.com>
    USB: serial: mos7720: improve OOM-handling in read_mos_reg()

Liu Jian <liujian56@huawei.com>
    igmp: Add ip_mc_list lock in ip_check_mc_rcu

Pavel Skripkin <paskripkin@gmail.com>
    media: stkwebcam: fix memory leak in stk_camera_probe

Vineet Gupta <vgupta@synopsys.com>
    ARC: wireup clone3 syscall

Zubin Mithra <zsm@chromium.org>
    ALSA: pcm: fix divide error in snd_pcm_lib_ioctl

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Workaround for conflicting SSID on ASUS ROG Strix G17

Ben Dooks <ben-linux@fluff.org>
    ARM: 8918/2: only build return_address() if needed

Christoph Hellwig <hch@lst.de>
    cryptoloop: add a deprecation warning

Kim Phillips <kim.phillips@amd.com>
    perf/x86/amd/power: Assign pmu.module

Kim Phillips <kim.phillips@amd.com>
    perf/x86/amd/ibs: Work around erratum #1197

Xiaoyao Li <xiaoyao.li@intel.com>
    perf/x86/intel/pt: Fix mask of num_address_ranges

Shai Malin <smalin@marvell.com>
    qede: Fix memset corruption

Harini Katakam <harini.katakam@xilinx.com>
    net: macb: Add a NULL check on desc_ptp

Shai Malin <smalin@marvell.com>
    qed: Fix the VF msix vectors flow

Sai Krishna Potthuri <lakshmi.sai.krishna.potthuri@xilinx.com>
    reset: reset-zynqmp: Fixed the argument data type

Krzysztof Hałasa <khalasa@piap.pl>
    gpu: ipu-v3: Fix i.MX IPU-v3 offset calculations for (semi)planar U/V formats

Randy Dunlap <rdunlap@infradead.org>
    xtensa: fix kconfig unmet dependency warning for HAVE_FUTEX_CMPXCHG

Peter Zijlstra <peterz@infradead.org>
    kthread: Fix PF_KTHREAD vs to_kthread() race

Eric Biggers <ebiggers@google.com>
    ubifs: report correct st_size for encrypted symlinks

Eric Biggers <ebiggers@google.com>
    f2fs: report correct st_size for encrypted symlinks

Eric Biggers <ebiggers@google.com>
    ext4: report correct st_size for encrypted symlinks

Eric Biggers <ebiggers@google.com>
    fscrypt: add fscrypt_symlink_getattr() for computing st_size

Theodore Ts'o <tytso@mit.edu>
    ext4: fix race writing to an inline_data file while its xattrs are changing


-------------

Diffstat:

 Makefile                                     |  4 +--
 arch/arc/Kconfig                             |  1 +
 arch/arc/include/asm/syscalls.h              |  1 +
 arch/arc/include/uapi/asm/unistd.h           |  1 +
 arch/arc/kernel/entry.S                      | 12 +++++++
 arch/arc/kernel/process.c                    |  7 ++--
 arch/arc/kernel/sys.c                        |  1 +
 arch/arm/kernel/Makefile                     |  6 +++-
 arch/arm/kernel/return_address.c             |  4 ---
 arch/powerpc/boot/crt0.S                     |  3 --
 arch/x86/events/amd/ibs.c                    |  8 +++++
 arch/x86/events/amd/iommu.c                  | 47 ++++++++++++++-----------
 arch/x86/events/amd/power.c                  |  1 +
 arch/x86/events/intel/pt.c                   |  2 +-
 arch/x86/kernel/reboot.c                     |  3 +-
 arch/xtensa/Kconfig                          |  2 +-
 drivers/block/Kconfig                        |  4 +--
 drivers/block/cryptoloop.c                   |  2 ++
 drivers/gpu/ipu-v3/ipu-cpmem.c               | 30 ++++++++--------
 drivers/media/usb/stkwebcam/stk-webcam.c     |  6 ++--
 drivers/net/ethernet/cadence/macb_ptp.c      | 11 +++++-
 drivers/net/ethernet/qlogic/qed/qed_main.c   |  7 +++-
 drivers/net/ethernet/qlogic/qede/qede_main.c |  2 +-
 drivers/net/ethernet/realtek/r8169_main.c    |  1 +
 drivers/net/ethernet/xilinx/ll_temac_main.c  |  4 +--
 drivers/pci/quirks.c                         | 12 +++----
 drivers/reset/reset-zynqmp.c                 |  3 +-
 drivers/usb/host/xhci-debugfs.c              |  6 ++--
 drivers/usb/host/xhci-rcar.c                 |  7 ++++
 drivers/usb/host/xhci-trace.h                |  8 ++---
 drivers/usb/host/xhci.h                      | 52 +++++++++++++++-------------
 drivers/usb/mtu3/mtu3_gadget.c               |  6 ++--
 drivers/usb/serial/mos7720.c                 |  4 ++-
 fs/btrfs/inode.c                             |  2 +-
 fs/crypto/hooks.c                            | 44 +++++++++++++++++++++++
 fs/ext4/inline.c                             |  6 ++++
 fs/ext4/symlink.c                            | 11 +++++-
 fs/f2fs/namei.c                              | 11 +++++-
 fs/ubifs/file.c                              | 12 ++++++-
 include/linux/fscrypt.h                      |  7 ++++
 kernel/kthread.c                             | 43 +++++++++++++++--------
 kernel/sched/fair.c                          |  2 +-
 mm/page_alloc.c                              |  8 ++---
 net/ipv4/icmp.c                              | 23 ++++++++++--
 net/ipv4/igmp.c                              |  2 ++
 sound/core/pcm_lib.c                         |  2 +-
 sound/pci/hda/patch_realtek.c                | 10 ++++++
 sound/usb/quirks.c                           |  1 +
 48 files changed, 321 insertions(+), 131 deletions(-)



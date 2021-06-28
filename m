Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22F923B6181
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234738AbhF1OgK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:36:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:37300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234935AbhF1Oe0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:34:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A71E660C3E;
        Mon, 28 Jun 2021 14:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890606;
        bh=1WkX+jL0mRz6UlbzR+m0Wf9JwVVpuBfYtuDUsVW06HA=;
        h=From:To:Cc:Subject:Date:From;
        b=ak33CQU8iAzKGbDmalDO6773lWTMM0OR2nzJ7d+AVupvUwIwS3OypLwN3eNtQ/zqX
         pYe8VGGZZ1xCcYvR7A8C14Srs++tidKS6p+LBtPTMg5O4cjbGxTfH2jE4F02zhBKEo
         L4to104+xFIgX2OGA2yHYRF/eAMqOwiBCz5lTSVyYD803jP6kpZU8OiehgkcW+ntPC
         kCb07aXEHXhMmMwGY8P0/SuZ01LXbc6DuBsH8iS4W9WWkKc5iA8fU4rPyPL7uq4pGV
         aYZKJPBrwzHWMK0W394iyJO6h3RtXVBDGKBz2bQXtfN5nQGHvQkljZ8KcuAaDMCahp
         HafuzQB/J+LpQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org
Subject: [PATCH 5.4 00/71] 5.4.129-rc1 review
Date:   Mon, 28 Jun 2021 10:28:53 -0400
Message-Id: <20210628143004.32596-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.129-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.129-rc1
X-KernelTest-Deadline: 2021-06-30T14:29+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is the start of the stable review cycle for the 5.4.129 release.
There are 71 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed 30 Jun 2021 02:29:43 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.4.y&id2=v5.4.128
or in the git tree and branch at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

Thanks,
Sasha

-------------
Pseudo-Shortlog of commits:

Alex Shi (1):
  mm: add VM_WARN_ON_ONCE_PAGE() macro

Arnd Bergmann (1):
  ARM: 9081/1: fix gcc-10 thumb2-kernel regression

Austin Kim (1):
  net: ethtool: clear heap allocations for ethtool function

Christian König (2):
  drm/nouveau: wait for moving fence after pinning v2
  drm/radeon: wait for moving fence after pinning

Du Cheng (1):
  cfg80211: call cfg80211_leave_ocb when switching away from OCB

Eric Dumazet (3):
  inet: annotate date races around sk->sk_txhash
  net/packet: annotate accesses to po->bind
  net/packet: annotate accesses to po->ifindex

Eric Snowberg (2):
  certs: Add EFI_CERT_X509_GUID support for dbx entries
  certs: Move load_system_certificate_list to a common function

Esben Haabendal (2):
  net: ll_temac: Add memory-barriers for TX BD access
  net: ll_temac: Avoid ndo_start_xmit returning NETDEV_TX_BUSY

Fabien Dessenne (1):
  pinctrl: stm32: fix the reported number of GPIO lines per bank

Fuad Tabba (1):
  KVM: selftests: Fix kvm_check_cap() assertion

Guillaume Ranquet (3):
  dmaengine: mediatek: free the proper desc in desc_free handler
  dmaengine: mediatek: do not issue a new desc if one is still current
  dmaengine: mediatek: use GFP_NOWAIT instead of GFP_ATOMIC in prep_dma

Haibo Chen (1):
  spi: spi-nxp-fspi: move the register operation after the clock enable

Hugh Dickins (16):
  mm/thp: fix __split_huge_pmd_locked() on shmem migration entry
  mm/thp: make is_huge_zero_pmd() safe and quicker
  mm/thp: try_to_unmap() use TTU_SYNC for safe splitting
  mm/thp: fix vma_address() if virtual address below file offset
  mm/thp: unmap_mapping_page() to fix THP truncate_cleanup_page()
  mm: page_vma_mapped_walk(): use page for pvmw->page
  mm: page_vma_mapped_walk(): settle PageHuge on entry
  mm: page_vma_mapped_walk(): use pmde for *pvmw->pmd
  mm: page_vma_mapped_walk(): prettify PVMW_MIGRATION block
  mm: page_vma_mapped_walk(): crossing page table boundary
  mm: page_vma_mapped_walk(): add a level of indentation
  mm: page_vma_mapped_walk(): use goto instead of while (1)
  mm: page_vma_mapped_walk(): get vma_address_end() earlier
  mm/thp: fix page_vma_mapped_walk() if THP mapped by ptes
  mm/thp: another PVMW_SYNC fix in page_vma_mapped_walk()
  mm, futex: fix shared futex pgoff on shmem huge page

Johan Hovold (1):
  i2c: robotfuzz-osif: fix control-request directions

Johannes Berg (3):
  mac80211: remove warning in ieee80211_get_sband()
  mac80211_hwsim: drop pending frames on stop
  mac80211: drop multicast fragments

Jue Wang (1):
  mm/thp: fix page_address_in_vma() on file THP tails

Kees Cook (4):
  r8152: Avoid memcpy() over-reading of ETH_SS_STATS
  sh_eth: Avoid memcpy() over-reading of ETH_SS_STATS
  r8169: Avoid memcpy() over-reading of ETH_SS_STATS
  net: qed: Fix memcpy() overflow of qed_dcbx_params()

Miaohe Lin (2):
  mm/rmap: remove unneeded semicolon in page_not_mapped()
  mm/rmap: use page_not_mapped in try_to_unmap()

Mikel Rychliski (1):
  PCI: Add AMD RS690 quirk to enable 64-bit DMA

Mimi Zohar (1):
  module: limit enabling module.sig_enforce

Nathan Chancellor (1):
  MIPS: generic: Update node names to avoid unit addresses

Nayna Jain (2):
  certs: Add wrapper function to check blacklisted binary hash
  x86/efi: move common keyring handler functions to new file

Neil Armstrong (1):
  mmc: meson-gx: use memcpy_to/fromio for dram-access-quirk

Nicholas Piggin (1):
  KVM: do not allow mapping valid but non-reference-counted pages

Nick Desaulniers (1):
  arm64: link with -z norelro for LLD or aarch64-elf

Pavel Skripkin (2):
  net: caif: fix memory leak in ldisc_open
  nilfs2: fix memory leak in nilfs_sysfs_delete_device_group

Peter Zijlstra (1):
  recordmcount: Correct st_shndx handling

Petr Mladek (2):
  kthread_worker: split code for canceling the delayed work timer
  kthread: prevent deadlock when kthread_mod_delayed_work() races with
    kthread_cancel_delayed_work_sync()

Praneeth Bajjuri (1):
  net: phy: dp83867: perform soft reset and retain established link

Rafael J. Wysocki (1):
  Revert "PCI: PM: Do not read power state in pci_enable_device_flags()"

Sami Tolvanen (1):
  kbuild: add CONFIG_LD_IS_LLD

Sasha Levin (1):
  Linux 5.4.129-rc1

Xu Yu (1):
  mm, thp: use head page in __migration_entry_wait()

Yang Shi (1):
  mm: thp: replace DEBUG_VM BUG with VM_WARN when unmap fails for split

Yifan Zhang (2):
  Revert "drm/amdgpu/gfx9: fix the doorbell missing when in CGPG issue."
  Revert "drm/amdgpu/gfx10: enlarge CP_MEC_DOORBELL_RANGE_UPPER to cover
    full doorbell."

Yu Kuai (1):
  dmaengine: zynqmp_dma: Fix PM reference leak in
    zynqmp_dma_alloc_chan_resourc()

Zheng Yongjun (2):
  net: ipv4: Remove unneed BUG() function
  ping: Check return value of function 'ping_queue_rcv_skb'

Zou Wei (1):
  dmaengine: rcar-dmac: Fix PM reference leak in rcar_dmac_probe()

 Makefile                                      |   4 +-
 arch/arm/kernel/setup.c                       |  16 +-
 arch/arm64/Makefile                           |  10 +-
 arch/mips/generic/board-boston.its.S          |  10 +-
 arch/mips/generic/board-ni169445.its.S        |  10 +-
 arch/mips/generic/board-ocelot.its.S          |  20 +--
 arch/mips/generic/board-xilfpga.its.S         |  10 +-
 arch/mips/generic/vmlinux.its.S               |  10 +-
 arch/x86/pci/fixup.c                          |  44 +++++
 certs/Kconfig                                 |   9 +
 certs/Makefile                                |   2 +-
 certs/blacklist.c                             |  52 ++++++
 certs/blacklist.h                             |   2 +
 certs/common.c                                |  57 +++++++
 certs/common.h                                |   9 +
 certs/system_keyring.c                        |  55 +-----
 drivers/dma/mediatek/mtk-uart-apdma.c         |  27 +--
 drivers/dma/sh/rcar-dmac.c                    |   2 +-
 drivers/dma/xilinx/zynqmp_dma.c               |   2 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c        |   6 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c         |   6 +-
 drivers/gpu/drm/nouveau/nouveau_prime.c       |  17 +-
 drivers/gpu/drm/radeon/radeon_prime.c         |  16 +-
 drivers/i2c/busses/i2c-robotfuzz-osif.c       |   4 +-
 drivers/mmc/host/meson-gx-mmc.c               |  50 +++++-
 drivers/net/caif/caif_serial.c                |   1 +
 drivers/net/ethernet/qlogic/qed/qed_dcbx.c    |   4 +-
 drivers/net/ethernet/realtek/r8169_main.c     |   2 +-
 drivers/net/ethernet/renesas/sh_eth.c         |   2 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c   |  19 ++-
 drivers/net/phy/dp83867.c                     |   6 +-
 drivers/net/usb/r8152.c                       |   2 +-
 drivers/net/wireless/mac80211_hwsim.c         |   5 +
 drivers/pci/pci.c                             |  16 +-
 drivers/pinctrl/stm32/pinctrl-stm32.c         |   9 +-
 drivers/spi/spi-nxp-fspi.c                    |  11 +-
 fs/nilfs2/sysfs.c                             |   1 +
 include/keys/system_keyring.h                 |  21 +++
 include/linux/huge_mm.h                       |   8 +-
 include/linux/hugetlb.h                       |  16 --
 include/linux/mm.h                            |   3 +
 include/linux/mmdebug.h                       |  13 ++
 include/linux/pagemap.h                       |  13 +-
 include/linux/rmap.h                          |   3 +-
 include/net/sock.h                            |  10 +-
 init/Kconfig                                  |   3 +
 kernel/futex.c                                |   2 +-
 kernel/kthread.c                              |  77 ++++++---
 kernel/module.c                               |  14 +-
 mm/huge_memory.c                              |  56 +++---
 mm/hugetlb.c                                  |   5 +-
 mm/internal.h                                 |  53 ++++--
 mm/memory.c                                   |  41 +++++
 mm/migrate.c                                  |   1 +
 mm/page_vma_mapped.c                          | 160 +++++++++++-------
 mm/pgtable-generic.c                          |   4 +-
 mm/rmap.c                                     |  50 +++---
 mm/truncate.c                                 |  43 +++--
 net/core/ethtool.c                            |  10 +-
 net/ipv4/devinet.c                            |   2 +-
 net/ipv4/ping.c                               |  12 +-
 net/ipv6/addrconf.c                           |   2 +-
 net/mac80211/ieee80211_i.h                    |   2 +-
 net/mac80211/rx.c                             |   9 +-
 net/packet/af_packet.c                        |  32 ++--
 net/wireless/util.c                           |   3 +
 scripts/recordmcount.h                        |  15 +-
 security/integrity/Makefile                   |   3 +-
 .../platform_certs/keyring_handler.c          |  91 ++++++++++
 .../platform_certs/keyring_handler.h          |  32 ++++
 security/integrity/platform_certs/load_uefi.c |  67 +-------
 tools/testing/selftests/kvm/lib/kvm_util.c    |   2 +-
 virt/kvm/kvm_main.c                           |  19 ++-
 73 files changed, 959 insertions(+), 466 deletions(-)
 create mode 100644 certs/common.c
 create mode 100644 certs/common.h
 create mode 100644 security/integrity/platform_certs/keyring_handler.c
 create mode 100644 security/integrity/platform_certs/keyring_handler.h

-- 
2.30.2


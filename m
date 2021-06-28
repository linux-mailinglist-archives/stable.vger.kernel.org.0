Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6972E3B5FD2
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232299AbhF1OU5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:20:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:54008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232093AbhF1OU4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:20:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2962A6142D;
        Mon, 28 Jun 2021 14:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624889911;
        bh=HltLN9j1t1o2m2iJzKKwOVDtisqTm4V0hm5zIIeV/3U=;
        h=From:To:Cc:Subject:Date:From;
        b=m/qimR30Mr/scTxvSg3HH78ZzqE+bO6VLm/8/hL/EnmLkboC4xUUhAICne7SqTPZa
         4qmcC91ilOTaKH82wn2eJfm6nJwxvhyGdxEadwS2yjS9/tt153Sa/m7nXdqQ/uAk7P
         l05pn4neoGFpzWpj+4w0hG6xsx45o2bQMofxnsLAJxgwzhc6qYDkHftNem4TVyXVYJ
         W7hVXiMd8dlng7KxV+ZQIkdA5Q/X6NYONTOvlvzV0Zi+bezpeud89y+mbOHEZ3Boil
         A5VJK/nClwGg+MW4i8RJTia5Ai/Yz+ysB6jUpds0L82IxeW00z5JviWa/oYd/cElIk
         f1n951R1dTzpQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org
Subject: [PATCH 5.12 000/110] 5.12.14-rc1 review
Date:   Mon, 28 Jun 2021 10:16:38 -0400
Message-Id: <20210628141828.31757-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.14-rc1
X-KernelTest-Deadline: 2021-06-30T14:18+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is the start of the stable review cycle for the 5.12.14 release.
There are 110 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed 30 Jun 2021 02:18:05 PM UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.12.y&id2=v5.12.13
or in the git tree and branch at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
and the diffstat can be found below.

Thanks,
Sasha

-------------
Pseudo-Shortlog of commits:

Alper Gun (1):
  KVM: SVM: Call SEV Guest Decommission if ASID binding fails

Andy Shevchenko (1):
  pinctrl: microchip-sgpio: Put fwnode in error case during ->probe()

Arnd Bergmann (1):
  ARM: 9081/1: fix gcc-10 thumb2-kernel regression

Austin Kim (1):
  net: ethtool: clear heap allocations for ethtool function

Bumyong Lee (1):
  swiotlb: manipulate orig_addr when tlb_addr has offset

Christian König (3):
  drm/nouveau: wait for moving fence after pinning v2
  drm/radeon: wait for moving fence after pinning
  drm/amdgpu: wait for moving fence after pinning

Christoph Hellwig (1):
  scsi: sd: Call sd_revalidate_disk() for ioctl(BLKRRPART)

Daniel Borkmann (1):
  bpf, selftests: Adjust few selftest outcomes wrt unreachable code

Daniel Vetter (1):
  Revert "drm: add a locked version of drm_is_current_master"

David Abdurachmanov (1):
  riscv: dts: fu740: fix cache-controller interrupts

Desmond Cheong Zhi Xi (1):
  drm: add a locked version of drm_is_current_master

Du Cheng (1):
  cfg80211: call cfg80211_leave_ocb when switching away from OCB

Eric Dumazet (6):
  inet: annotate data race in inet_send_prepare() and
    inet_dgram_connect()
  net: annotate data race in sock_error()
  inet: annotate date races around sk->sk_txhash
  net/packet: annotate data race in packet_sendmsg()
  net/packet: annotate accesses to po->bind
  net/packet: annotate accesses to po->ifindex

Eric Snowberg (4):
  certs: Add EFI_CERT_X509_GUID support for dbx entries
  certs: Move load_system_certificate_list to a common function
  certs: Add ability to preload revocation certs
  integrity: Load mokx variables into the blacklist keyring

Esben Haabendal (2):
  net: ll_temac: Add memory-barriers for TX BD access
  net: ll_temac: Avoid ndo_start_xmit returning NETDEV_TX_BUSY

Fabien Dessenne (1):
  pinctrl: stm32: fix the reported number of GPIO lines per bank

Fuad Tabba (1):
  KVM: selftests: Fix kvm_check_cap() assertion

Gabriel Knezek (1):
  gpiolib: cdev: zero padding during conversion to gpioline_info_changed

Guillaume Ranquet (3):
  dmaengine: mediatek: free the proper desc in desc_free handler
  dmaengine: mediatek: do not issue a new desc if one is still current
  dmaengine: mediatek: use GFP_NOWAIT instead of GFP_ATOMIC in prep_dma

Haibo Chen (1):
  spi: spi-nxp-fspi: move the register operation after the clock enable

Heikki Krogerus (1):
  software node: Handle software node injection to an existing device
    properly

Heiko Carstens (1):
  s390/stack: fix possible register corruption with stack switch helper

Heiner Kallweit (1):
  i2c: i801: Ensure that SMBHSTSTS_INUSE_STS is cleared when leaving
    i801_access

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

Jeff Layton (2):
  ceph: must hold snap_rwsem when filling inode for async create
  netfs: fix test for whether we can skip read when writing beyond EOF

Jiapeng Chong (1):
  dmaengine: idxd: Fix missing error code in idxd_cdev_open()

Johan Hovold (1):
  i2c: robotfuzz-osif: fix control-request directions

Johannes Berg (5):
  mac80211: remove warning in ieee80211_get_sband()
  mac80211_hwsim: drop pending frames on stop
  mac80211: drop multicast fragments
  mac80211: reset profile_periodicity/ema_ap
  mac80211: handle various extensible elements correctly

Johannes Weiner (1):
  psi: Fix psi state corruption when schedule() races with cgroup move

Jue Wang (1):
  mm/thp: fix page_address_in_vma() on file THP tails

Juergen Gross (1):
  xen/events: reset active flag for lateeoi events later

Kan Liang (1):
  perf/x86: Track pmu in per-CPU cpu_hw_events

Kees Cook (4):
  r8152: Avoid memcpy() over-reading of ETH_SS_STATS
  sh_eth: Avoid memcpy() over-reading of ETH_SS_STATS
  r8169: Avoid memcpy() over-reading of ETH_SS_STATS
  net: qed: Fix memcpy() overflow of qed_dcbx_params()

Khem Raj (1):
  riscv32: Use medany C model for modules

Kristian Evensen (1):
  qmi_wwan: Do not call netif_rx from rx_fixup

Laurent Pinchart (2):
  dmaengine: xilinx: dpdma: Add missing dependencies to Kconfig
  dmaengine: xilinx: dpdma: Limit descriptor IDs to 16 bits

Like Xu (1):
  perf/x86/lbr: Remove cpuc->lbr_xsave allocation from atomic context

Maxime Ripard (2):
  drm/vc4: hdmi: Move the HSM clock enable to runtime_pm
  drm/vc4: hdmi: Make sure the controller is powered in detect

Mikel Rychliski (1):
  PCI: Add AMD RS690 quirk to enable 64-bit DMA

Mimi Zohar (1):
  module: limit enabling module.sig_enforce

Naoya Horiguchi (1):
  mm/hwpoison: do not lock page again when me_huge_page() successfully
    recovers

Neil Armstrong (1):
  mmc: meson-gx: use memcpy_to/fromio for dram-access-quirk

Nicholas Piggin (1):
  KVM: do not allow mapping valid but non-reference-counted pages

Pavel Skripkin (2):
  net: caif: fix memory leak in ldisc_open
  nilfs2: fix memory leak in nilfs_sysfs_delete_device_group

Peter Zijlstra (5):
  x86/entry: Fix noinstr fail in __do_fast_syscall_32()
  x86/xen: Fix noinstr fail in xen_pv_evtchn_do_upcall()
  x86/xen: Fix noinstr fail in exc_xen_unknown_trap()
  locking/lockdep: Improve noinstr vs errors
  recordmcount: Correct st_shndx handling

Petr Mladek (2):
  kthread_worker: split code for canceling the delayed work timer
  kthread: prevent deadlock when kthread_mod_delayed_work() races with
    kthread_cancel_delayed_work_sync()

Praneeth Bajjuri (1):
  net: phy: dp83867: perform soft reset and retain established link

Rafael J. Wysocki (1):
  Revert "PCI: PM: Do not read power state in pci_enable_device_flags()"

Sasha Levin (1):
  Linux 5.12.14-rc1

Sven Schnelle (3):
  s390/topology: clear thread/group maps for offline cpus
  s390: fix system call restart with multiple signals
  s390: clear pt_regs::flags on irq entry

Thomas Gleixner (3):
  perf/x86/intel/lbr: Zero the xstate buffer on allocation
  x86/fpu: Preserve supervisor states in sanitize_restored_user_xstate()
  x86/fpu: Make init_fpstate correct with optimized XSAVE

Tony Luck (1):
  mm/memory-failure: use a mutex to avoid memory_failure() races

Xu Yu (1):
  mm, thp: use head page in __migration_entry_wait()

Yang Shi (1):
  mm: thp: replace DEBUG_VM BUG with VM_WARN when unmap fails for split

Yifan Zhang (2):
  Revert "drm/amdgpu/gfx9: fix the doorbell missing when in CGPG issue."
  Revert "drm/amdgpu/gfx10: enlarge CP_MEC_DOORBELL_RANGE_UPPER to cover
    full doorbell."

Yu Kuai (2):
  dmaengine: zynqmp_dma: Fix PM reference leak in
    zynqmp_dma_alloc_chan_resourc()
  dmaengine: stm32-mdma: fix PM reference leak in
    stm32_mdma_alloc_chan_resourc()

Zhen Lei (1):
  drm/kmb: Fix error return code in kmb_hw_init()

Zheng Yongjun (2):
  net: ipv4: Remove unneed BUG() function
  ping: Check return value of function 'ping_queue_rcv_skb'

Zou Wei (1):
  dmaengine: rcar-dmac: Fix PM reference leak in rcar_dmac_probe()

 Makefile                                      |   4 +-
 arch/arm/kernel/setup.c                       |  16 +-
 arch/riscv/Makefile                           |   2 +-
 arch/riscv/boot/dts/sifive/fu740-c000.dtsi    |   2 +-
 arch/s390/include/asm/stacktrace.h            |  18 +-
 arch/s390/kernel/entry.S                      |   1 +
 arch/s390/kernel/signal.c                     |   1 -
 arch/s390/kernel/topology.c                   |  12 +-
 arch/x86/entry/common.c                       |   5 +-
 arch/x86/events/core.c                        |  23 ++-
 arch/x86/events/intel/core.c                  |   2 +-
 arch/x86/events/intel/ds.c                    |   4 +-
 arch/x86/events/intel/lbr.c                   |  36 ++--
 arch/x86/events/perf_event.h                  |  10 +-
 arch/x86/include/asm/fpu/internal.h           |  30 +---
 arch/x86/kernel/fpu/signal.c                  |  26 +--
 arch/x86/kernel/fpu/xstate.c                  |  41 ++++-
 arch/x86/kvm/svm/sev.c                        |  32 ++--
 arch/x86/pci/fixup.c                          |  44 +++++
 arch/x86/xen/enlighten_pv.c                   |   2 +
 certs/Kconfig                                 |  17 ++
 certs/Makefile                                |  21 ++-
 certs/blacklist.c                             |  64 +++++++
 certs/blacklist.h                             |   2 +
 certs/common.c                                |  57 +++++++
 certs/common.h                                |   9 +
 certs/revocation_certificates.S               |  21 +++
 certs/system_keyring.c                        |  55 +-----
 drivers/base/swnode.c                         |  16 +-
 drivers/dma/Kconfig                           |   1 +
 drivers/dma/idxd/cdev.c                       |   1 +
 drivers/dma/mediatek/mtk-uart-apdma.c         |  27 +--
 drivers/dma/sh/rcar-dmac.c                    |   2 +-
 drivers/dma/stm32-mdma.c                      |   4 +-
 drivers/dma/xilinx/xilinx_dpdma.c             |   7 +-
 drivers/dma/xilinx/zynqmp_dma.c               |   2 +-
 drivers/gpio/gpiolib-cdev.c                   |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c   |  14 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c        |   6 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c         |   6 +-
 drivers/gpu/drm/kmb/kmb_drv.c                 |   1 +
 drivers/gpu/drm/nouveau/nouveau_prime.c       |  17 +-
 drivers/gpu/drm/radeon/radeon_prime.c         |  16 +-
 drivers/gpu/drm/vc4/vc4_hdmi.c                |  44 +++--
 drivers/i2c/busses/i2c-i801.c                 |   3 +
 drivers/i2c/busses/i2c-robotfuzz-osif.c       |   4 +-
 drivers/mmc/host/meson-gx-mmc.c               |  50 +++++-
 drivers/net/caif/caif_serial.c                |   1 +
 drivers/net/ethernet/qlogic/qed/qed_dcbx.c    |   4 +-
 drivers/net/ethernet/realtek/r8169_main.c     |   2 +-
 drivers/net/ethernet/renesas/sh_eth.c         |   2 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c   |  19 ++-
 drivers/net/phy/dp83867.c                     |   6 +-
 drivers/net/usb/qmi_wwan.c                    |   2 +-
 drivers/net/usb/r8152.c                       |   2 +-
 drivers/net/wireless/mac80211_hwsim.c         |   5 +
 drivers/pci/pci.c                             |  16 +-
 drivers/pinctrl/pinctrl-microchip-sgpio.c     |   4 +-
 drivers/pinctrl/stm32/pinctrl-stm32.c         |   9 +-
 drivers/scsi/sd.c                             |  22 ++-
 drivers/spi/spi-nxp-fspi.c                    |  11 +-
 drivers/xen/events/events_base.c              |  11 +-
 fs/ceph/addr.c                                |  54 ++++--
 fs/ceph/file.c                                |   3 +
 fs/ceph/inode.c                               |   2 +
 fs/nilfs2/sysfs.c                             |   1 +
 include/keys/system_keyring.h                 |  15 ++
 include/linux/debug_locks.h                   |   2 +
 include/linux/huge_mm.h                       |   8 +-
 include/linux/hugetlb.h                       |  16 --
 include/linux/mm.h                            |   3 +
 include/linux/pagemap.h                       |  13 +-
 include/linux/rmap.h                          |   1 +
 include/net/sock.h                            |  17 +-
 kernel/dma/swiotlb.c                          |   8 +-
 kernel/futex.c                                |   3 +-
 kernel/kthread.c                              |  77 ++++++---
 kernel/locking/lockdep.c                      |   4 +-
 kernel/module.c                               |  14 +-
 kernel/sched/psi.c                            |  36 ++--
 lib/debug_locks.c                             |   2 +-
 mm/huge_memory.c                              |  56 +++---
 mm/hugetlb.c                                  |   5 +-
 mm/internal.h                                 |  53 ++++--
 mm/memory-failure.c                           |  80 ++++++---
 mm/memory.c                                   |  41 +++++
 mm/migrate.c                                  |   1 +
 mm/page_vma_mapped.c                          | 160 +++++++++++-------
 mm/pgtable-generic.c                          |   5 +-
 mm/rmap.c                                     |  39 +++--
 mm/truncate.c                                 |  43 +++--
 net/ethtool/ioctl.c                           |  10 +-
 net/ipv4/af_inet.c                            |   4 +-
 net/ipv4/devinet.c                            |   2 +-
 net/ipv4/ping.c                               |  12 +-
 net/ipv6/addrconf.c                           |   2 +-
 net/mac80211/ieee80211_i.h                    |   2 +-
 net/mac80211/mlme.c                           |   8 +
 net/mac80211/rx.c                             |   9 +-
 net/mac80211/util.c                           |  22 +--
 net/packet/af_packet.c                        |  41 +++--
 net/wireless/util.c                           |   3 +
 scripts/Makefile                              |   1 +
 scripts/recordmcount.h                        |  15 +-
 .../platform_certs/keyring_handler.c          |  11 ++
 security/integrity/platform_certs/load_uefi.c |  20 ++-
 tools/testing/selftests/bpf/test_verifier.c   |   2 +-
 tools/testing/selftests/bpf/verifier/and.c    |   2 +
 tools/testing/selftests/bpf/verifier/bounds.c |  14 ++
 .../selftests/bpf/verifier/dead_code.c        |   2 +
 tools/testing/selftests/bpf/verifier/jmp32.c  |  22 +++
 tools/testing/selftests/bpf/verifier/jset.c   |  10 +-
 tools/testing/selftests/bpf/verifier/unpriv.c |   2 +
 .../selftests/bpf/verifier/value_ptr_arith.c  |   7 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    |   2 +-
 virt/kvm/kvm_main.c                           |  19 ++-
 116 files changed, 1345 insertions(+), 556 deletions(-)
 create mode 100644 certs/common.c
 create mode 100644 certs/common.h
 create mode 100644 certs/revocation_certificates.S

-- 
2.30.2


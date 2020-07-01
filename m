Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19B4C210CC5
	for <lists+stable@lfdr.de>; Wed,  1 Jul 2020 15:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731191AbgGANzF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 09:55:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:54702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730783AbgGANzE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jul 2020 09:55:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2418C20663;
        Wed,  1 Jul 2020 13:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593611702;
        bh=2QydTbX5039HPcmlnTUqhL6W7OOGfN7D+abAxjAbyw4=;
        h=From:To:Cc:Subject:Date:From;
        b=NjUFOT8IonidNeG+5PDZ908mhYkZ7L+LoSjSEc/HyDQna86tUu6AP7lWzvWJpZdQQ
         SCq1S8WjNDVZcBRwXavUG4F0wG1re8vCGKAkh2SoKlNW2WKu2k9wj94Dz0rI6qcdty
         XtBPAc3pnHlIh3y2QNXQ8vjjCz89J5rJRqkOmuSc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc:     lwn@lwn.net, jslaby@suse.cz, gregkh@linuxfoundation.org
Subject: Linux 5.4.50
Date:   Wed,  1 Jul 2020 09:54:59 -0400
Message-Id: <20200701135500.2688663-1-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

I'm announcing the release of the 5.4.50 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
        https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary


Thanks,
Sasha


 Makefile                                           |  2 +-
 arch/arm/boot/dts/am335x-pocketbeagle.dts          |  1 -
 arch/arm/boot/dts/bcm-nsp.dtsi                     |  6 +-
 arch/arm/boot/dts/omap4-duovero-parlor.dts         |  2 +-
 arch/arm/mach-imx/pm-imx5.c                        |  6 +-
 arch/arm/mach-omap2/omap_hwmod.c                   |  2 +-
 arch/arm64/boot/dts/freescale/imx8mm-evk.dts       |  4 +-
 arch/arm64/boot/dts/freescale/imx8mn-ddr4-evk.dts  |  4 +-
 arch/arm64/kernel/fpsimd.c                         |  6 +-
 arch/arm64/kernel/perf_regs.c                      | 25 +++++-
 arch/riscv/include/asm/cmpxchg.h                   |  8 +-
 arch/riscv/kernel/sys_riscv.c                      |  6 ++
 arch/s390/include/asm/vdso.h                       |  1 +
 arch/s390/kernel/asm-offsets.c                     |  2 +-
 arch/s390/kernel/entry.S                           |  2 +-
 arch/s390/kernel/ptrace.c                          | 37 ++++++--
 arch/s390/kernel/time.c                            |  1 +
 arch/s390/kernel/vdso64/Makefile                   | 10 +--
 arch/s390/kernel/vdso64/clock_getres.S             | 10 +--
 arch/sparc/kernel/ptrace_32.c                      |  9 +-
 arch/x86/include/asm/kvm_host.h                    |  2 +-
 arch/x86/kernel/cpu/common.c                       | 24 +++---
 arch/x86/kernel/cpu/resctrl/rdtgroup.c             |  1 +
 arch/x86/kernel/cpu/umwait.c                       |  6 --
 arch/x86/kvm/mmu.c                                 |  4 +-
 arch/x86/kvm/mmu.h                                 |  2 +-
 arch/x86/kvm/paging_tmpl.h                         |  7 +-
 arch/x86/kvm/vmx/vmx.c                             | 24 +-----
 arch/x86/kvm/vmx/vmx.h                             |  2 -
 arch/x86/kvm/x86.c                                 |  4 +-
 arch/x86/lib/usercopy_64.c                         |  1 +
 block/bio-integrity.c                              |  1 -
 block/blk-mq.c                                     |  4 +-
 drivers/acpi/acpi_configfs.c                       |  6 +-
 drivers/acpi/sysfs.c                               |  4 +-
 drivers/android/binder.c                           | 14 ++--
 drivers/ata/libata-scsi.c                          |  9 +-
 drivers/ata/sata_rcar.c                            | 11 ++-
 drivers/base/regmap/regmap.c                       |  1 +
 drivers/block/loop.c                               |  6 +-
 drivers/bus/ti-sysc.c                              | 15 +++-
 drivers/char/hw_random/ks-sa-rng.c                 |  1 +
 drivers/clk/sifive/fu540-prci.c                    |  5 +-
 drivers/firmware/efi/esrt.c                        |  2 +-
 drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c             |  6 +-
 drivers/gpu/drm/amd/amdkfd/kfd_process.c           |  1 +
 .../drm/amd/display/modules/color/color_gamma.c    |  2 +-
 drivers/gpu/drm/radeon/ni_dpm.c                    |  2 +-
 drivers/gpu/drm/rcar-du/Kconfig                    |  1 +
 drivers/i2c/busses/i2c-fsi.c                       |  2 +-
 drivers/i2c/busses/i2c-tegra.c                     |  9 --
 drivers/i2c/i2c-core-smbus.c                       |  7 ++
 drivers/infiniband/core/cma.c                      | 18 ++++
 drivers/infiniband/core/mad.c                      |  3 +-
 drivers/infiniband/hw/hfi1/debugfs.c               | 19 +----
 drivers/infiniband/hw/qedr/qedr_iw_cm.c            | 13 ++-
 drivers/infiniband/sw/rdmavt/qp.c                  |  6 +-
 drivers/infiniband/sw/siw/siw_qp_rx.c              |  3 +-
 drivers/iommu/dmar.c                               |  3 +-
 drivers/iommu/intel-iommu.c                        | 13 ++-
 drivers/md/dm-writecache.c                         |  4 +
 drivers/net/ethernet/atheros/alx/main.c            |  9 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |  8 +-
 drivers/net/ethernet/broadcom/tg3.c                |  4 +-
 drivers/net/ethernet/chelsio/cxgb4/l2t.c           | 52 ++++++------
 drivers/net/ethernet/freescale/enetc/enetc.c       |  4 +-
 drivers/net/ethernet/ibm/ibmveth.c                 |  2 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 | 21 ++++-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |  4 +-
 drivers/net/ethernet/qlogic/qed/qed_cxt.c          |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_dev.c          |  9 +-
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c        |  2 -
 drivers/net/ethernet/qlogic/qed/qed_roce.c         |  1 -
 drivers/net/ethernet/qlogic/qed/qed_vf.c           | 23 +++--
 drivers/net/ethernet/qlogic/qede/qede_main.c       |  3 +-
 drivers/net/ethernet/qlogic/qede/qede_ptp.c        | 31 +++----
 drivers/net/ethernet/qlogic/qede/qede_ptp.h        |  2 +-
 drivers/net/ethernet/qlogic/qede/qede_rdma.c       |  3 +-
 drivers/net/ethernet/rocker/rocker_main.c          |  4 +-
 drivers/net/geneve.c                               |  1 +
 drivers/net/phy/phy_device.c                       |  6 +-
 drivers/net/usb/ax88179_178a.c                     | 11 +--
 drivers/nvme/host/multipath.c                      | 12 +--
 drivers/pinctrl/qcom/pinctrl-spmi-gpio.c           | 21 +++--
 drivers/pinctrl/tegra/pinctrl-tegra.c              |  4 +-
 drivers/regulator/pfuze100-regulator.c             | 60 ++++++++-----
 drivers/s390/net/qeth_core_main.c                  |  5 +-
 drivers/s390/scsi/zfcp_erp.c                       | 13 ++-
 drivers/scsi/lpfc/lpfc_init.c                      |  3 +-
 drivers/scsi/qla2xxx/qla_gs.c                      |  4 +-
 drivers/staging/rtl8723bs/core/rtw_wlan_util.c     |  4 +-
 drivers/tty/hvc/hvc_console.c                      | 16 +---
 drivers/usb/cdns3/ep0.c                            | 10 ++-
 drivers/usb/cdns3/trace.h                          |  2 +-
 drivers/usb/class/cdc-acm.c                        |  2 +
 drivers/usb/core/quirks.c                          |  3 +-
 drivers/usb/dwc2/gadget.c                          |  6 --
 drivers/usb/dwc2/platform.c                        | 11 +++
 drivers/usb/gadget/udc/mv_udc_core.c               |  3 +-
 drivers/usb/host/ehci-exynos.c                     |  5 +-
 drivers/usb/host/ehci-pci.c                        |  7 ++
 drivers/usb/host/ohci-sm501.c                      |  1 +
 drivers/usb/host/xhci-mtk.c                        |  5 +-
 drivers/usb/host/xhci.c                            |  9 +-
 drivers/usb/host/xhci.h                            |  2 +-
 drivers/usb/renesas_usbhs/fifo.c                   | 23 ++---
 drivers/usb/renesas_usbhs/fifo.h                   |  2 +-
 drivers/usb/typec/tcpm/tcpci_rt1711h.c             | 31 +++----
 fs/afs/cell.c                                      |  9 ++
 fs/afs/internal.h                                  |  2 +-
 fs/btrfs/block-group.c                             | 19 ++---
 fs/btrfs/ctree.h                                   |  2 +
 fs/btrfs/inode.c                                   | 39 +++++++--
 fs/btrfs/tree-log.c                                |  5 ++
 fs/cifs/smb2ops.c                                  | 12 +++
 fs/erofs/zdata.h                                   | 20 ++---
 fs/nfs/direct.c                                    | 13 ++-
 fs/nfs/file.c                                      |  1 +
 fs/nfs/flexfilelayout/flexfilelayout.c             | 11 ++-
 fs/ocfs2/dlmglue.c                                 | 17 +++-
 fs/ocfs2/ocfs2.h                                   |  1 +
 fs/ocfs2/ocfs2_fs.h                                |  4 +-
 fs/ocfs2/suballoc.c                                |  9 +-
 fs/xfs/libxfs/xfs_alloc.c                          | 16 ++++
 include/linux/netdevice.h                          |  2 +-
 include/linux/qed/qed_chain.h                      | 26 +++---
 include/linux/tpm_eventlog.h                       | 14 +++-
 include/net/sctp/constants.h                       |  8 +-
 include/net/sock.h                                 |  1 -
 include/net/xfrm.h                                 |  1 +
 kernel/bpf/cgroup.c                                | 53 +++++++-----
 kernel/bpf/devmap.c                                | 10 ++-
 kernel/kprobes.c                                   |  3 +-
 kernel/sched/core.c                                |  3 +-
 kernel/sched/deadline.c                            |  1 +
 kernel/trace/blktrace.c                            | 13 +++
 kernel/trace/ring_buffer.c                         |  2 +-
 kernel/trace/trace_events_trigger.c                | 21 ++++-
 lib/test_objagg.c                                  |  4 +-
 mm/memcontrol.c                                    |  4 +-
 mm/slab_common.c                                   |  2 +-
 net/bridge/br_private.h                            |  2 +-
 net/core/dev.c                                     |  9 ++
 net/core/sock.c                                    |  4 +-
 net/ipv4/fib_semantics.c                           |  2 +-
 net/ipv4/ip_tunnel.c                               | 14 ++--
 net/ipv4/tcp_cubic.c                               |  2 +
 net/ipv4/tcp_input.c                               | 26 ++++--
 net/ipv6/ip6_gre.c                                 |  9 +-
 net/ipv6/mcast.c                                   |  1 +
 net/netfilter/ipset/ip_set_core.c                  |  2 +
 net/openvswitch/actions.c                          |  9 +-
 net/rxrpc/call_accept.c                            |  7 ++
 net/rxrpc/input.c                                  |  7 +-
 net/sched/sch_cake.c                               | 58 +++++++++----
 net/sched/sch_generic.c                            |  1 +
 net/sctp/associola.c                               |  5 +-
 net/sctp/bind_addr.c                               |  1 +
 net/sctp/protocol.c                                |  3 +-
 net/sunrpc/rpc_pipe.c                              |  1 +
 net/sunrpc/xdr.c                                   |  4 +
 net/sunrpc/xprtrdma/rpc_rdma.c                     |  9 +-
 net/xfrm/xfrm_device.c                             |  4 +-
 samples/bpf/xdp_monitor_user.c                     |  8 +-
 samples/bpf/xdp_redirect_cpu_kern.c                |  2 +-
 samples/bpf/xdp_redirect_cpu_user.c                | 34 ++++----
 samples/bpf/xdp_rxq_info_user.c                    | 13 +--
 scripts/Kbuild.include                             | 11 +--
 scripts/recordmcount.h                             | 98 ++++++++++++++++++++--
 sound/pci/hda/patch_hdmi.c                         |  5 ++
 sound/pci/hda/patch_realtek.c                      |  3 +
 sound/soc/fsl/fsl_ssi.c                            | 13 ++-
 sound/soc/qcom/common.c                            | 14 +++-
 sound/soc/qcom/qdsp6/q6afe.c                       |  8 ++
 sound/soc/qcom/qdsp6/q6afe.h                       |  1 +
 sound/soc/qcom/qdsp6/q6asm.c                       |  7 +-
 sound/soc/rockchip/rockchip_pdm.c                  |  4 +-
 sound/usb/mixer.c                                  | 15 +++-
 sound/usb/mixer.h                                  |  9 +-
 sound/usb/mixer_quirks.c                           |  3 +-
 sound/usb/pcm.c                                    |  2 +
 sound/usb/quirks.c                                 |  9 ++
 tools/testing/selftests/net/so_txtime.c            | 33 ++++++--
 183 files changed, 1121 insertions(+), 577 deletions(-)

Aaron Plattner (1):
      ALSA: hda: Add NVIDIA codec IDs 9a & 9d through a0 to patch table

Aditya Pakki (3):
      rocker: fix incorrect error handling in dma_rings_init
      RDMA/rvt: Fix potential memory leak caused by rvt_alloc_rq
      test_objagg: Fix potential memory leak in error handling

Al Cooper (1):
      xhci: Fix enumeration issue when setting max packet size for FS devices.

Al Viro (1):
      fix a braino in "sparc32: fix register window handling in genregs32_[gs]et()"

Alexander Lobakin (7):
      net: qed: fix left elements count calculation
      net: qed: fix async event callbacks unregistering
      net: qede: stop adding events on an already destroyed workqueue
      net: qed: fix NVMe login fails over VFs
      net: qed: fix excessive QM ILT lines consumption
      net: qede: fix PTP initialization on recovery
      net: qede: fix use-after-free on recovery and AER handling

Bernard Zhao (1):
      drm/amd: fix potential memleak in err branch

Charles Keepax (1):
      regmap: Fix memory leak from regmap_register_patch

Chuck Lever (2):
      SUNRPC: Properly set the @subbuf parameter of xdr_buf_subsegment()
      xprtrdma: Fix handling of RDMA_ERROR replies

Chuhong Yuan (1):
      USB: ohci-sm501: Add missed iounmap() in remove

Claudiu Manoil (1):
      enetc: Fix tx rings bitmap iteration range, irq handling

Dan Carpenter (3):
      x86/resctrl: Fix a NULL vs IS_ERR() static checker warning in rdt_cdp_peer_get()
      usb: gadget: udc: Potential Oops in error handling code
      Staging: rtl8723bs: prevent buffer overflow in update_sta_support_rate()

Daniel Gomez (1):
      drm: rcar-du: Fix build error

David Christensen (1):
      tg3: driver sleeps indefinitely when EEH errors exceed eeh_max_freezes

David Howells (3):
      rxrpc: Fix notification call on completion of discarded calls
      rxrpc: Fix handling of rwind from an ACK packet
      afs: Fix storage of cell names

Denis Efremov (2):
      drm/amd/display: Use kfree() to free rgb_user in calculate_user_regamma_ramp()
      drm/radeon: fix fb_div check in ni_init_smc_spll_table()

Denis Kirjanov (1):
      tcp: don't ignore ECN CWR on pure ACK

Dennis Dalessandro (1):
      IB/hfi1: Fix module use count flaw due to leftover module put calls

Dinghao Liu (1):
      hwrng: ks-sa - Fix runtime PM imbalance on error

Dmitry Baryshkov (1):
      pinctrl: qcom: spmi-gpio: fix warning about irq chip reusage

Doug Berger (1):
      net: bcmgenet: use hardware padding of runt frames

Drew Fustini (1):
      ARM: dts: am335x-pocketbeagle: Fix mmc0 Write Protect

Eddie James (1):
      i2c: fsi: Fix the port number field in status register

Eric Dumazet (2):
      net: increment xmit_recursion level in dev_direct_xmit()
      tcp: grow window for OOO packets only for SACK flows

Fabian Vogt (1):
      efi/tpm: Verify event log header before parsing

Fan Guo (1):
      RDMA/mad: Fix possible memory leak in ib_mad_post_receive_mads()

Filipe Manana (4):
      btrfs: fix bytes_may_use underflow when running balance and scrub in parallel
      btrfs: fix data block group relocation failure due to concurrent scrub
      btrfs: check if a log root exists before locking the log_mutex on unlink
      btrfs: fix failure of RWF_NOWAIT write into prealloc extent beyond eof

Florian Fainelli (1):
      net: phy: Check harder for errors in get_phy_id()

Gao Xiang (1):
      erofs: fix partially uninitialized misuse in z_erofs_onlinepage_fixup

Gaurav Singh (1):
      bpf, xdp, samples: Fix null pointer dereference in *_user code

Greg Kroah-Hartman (1):
      Revert "tty: hvc: Fix data abort due to race in hvc_open"

Huaisheng Ye (1):
      dm writecache: correct uncommitted_block when discarding uncommitted entry

Huy Nguyen (1):
      xfrm: Fix double ESP trailer insertion in IPsec crypto offload.

Ilya Ponetayev (1):
      sch_cake: don't try to reallocate or unshare skb unconditionally

Jason A. Donenfeld (1):
      ACPI: configfs: Disallow loading ACPI tables when locked down

Jeremy Kerr (1):
      net: usb: ax88179_178a: fix packet alignment padding

Jiping Ma (1):
      arm64: perf: Report the PC value in REGS_ABI_32 mode

Joakim Tjernlund (1):
      cdc-acm: Add DISABLE_ECHO quirk for Microchip/SMSC chip

Julian Wiedmann (1):
      s390/qeth: fix error handling for isolation mode cmds

Junxiao Bi (4):
      ocfs2: avoid inode removal while nfsd is accessing it
      ocfs2: load global_inode_alloc
      ocfs2: fix value of OCFS2_INVALID_SLOT
      ocfs2: fix panic on nfs server over ocfs2

Juri Lelli (2):
      sched/deadline: Initialize ->dl_boosted
      sched/core: Fix PI boosting between RT and DEADLINE tasks

Kai-Heng Feng (3):
      xhci: Poll for U0 after disabling USB2 LPM
      xhci: Return if xHCI doesn't support LPM
      ALSA: hda/realtek: Add mute LED and micmute LED support for HP systems

Kees Cook (1):
      x86/cpu: Use pinning mask for CR4 bits needing to be 0

Laurence Tratt (1):
      ALSA: usb-audio: Add implicit feedback quirk for SSL2+.

Li Jun (1):
      usb: typec: tcpci_rt1711h: avoid screaming irq causing boot hangs

Longfang Liu (1):
      USB: ehci: reopen solution for Synopsys HC bug

Lorenzo Bianconi (2):
      openvswitch: take into account de-fragmentation/gso_size in execute_check_pkt_len
      samples/bpf: xdp_redirect_cpu: Set MAX_CPUS according to NR_CPUS

Lu Baolu (2):
      iommu/vt-d: Enable PCI ACS for platform opt in hint
      iommu/vt-d: Update scalable mode paging structure coherency

Luis Chamberlain (1):
      blktrace: break out of blktrace setup on concurrent calls

Macpaul Lin (2):
      usb: host: xhci-mtk: avoid runtime suspend when removing hcd
      ALSA: usb-audio: add quirk for Samsung USBC Headset (AKG)

Mans Rullgard (1):
      i2c: core: check returned size of emulated smbus block read

Marcelo Ricardo Leitner (1):
      sctp: Don't advertise IPv4 addresses if ipv6only is set on the socket

Mark Zhang (1):
      RDMA/cma: Protect bind_list and listen_list while finding matching cm id

Masahiro Yamada (1):
      kbuild: improve cc-option to clean up all temporary files

Masami Hiramatsu (2):
      kprobes: Suppress the suspicious RCU warning on kprobes
      tracing: Fix event trigger to accept redundant spaces

Mathias Nyman (1):
      xhci: Fix incorrect EP_STATE_MASK

Matt Fleming (1):
      x86/asm/64: Align start of __clear_user() loop to 16-bytes

Matthew Hagan (1):
      ARM: dts: NSP: Correct FA2 mailbox node

Michal Kalderon (1):
      RDMA/qedr: Fix KASAN: use-after-free in ucma_event_handler+0x532

Mikulas Patocka (1):
      dm writecache: add cond_resched to loop in persistent_memory_claim()

Minas Harutyunyan (1):
      usb: dwc2: Postponed gadget registration to the udc class driver

Muchun Song (1):
      mm/memcontrol.c: add missed css_put()

Nathan Chancellor (2):
      s390/vdso: Use $(LD) instead of $(CC) to link vDSO
      ACPI: sysfs: Fix pm_profile_attr type

Nathan Huckleberry (1):
      riscv/atomic: Fix sign extension for RV64I

Navid Emamdoost (1):
      sata_rcar: handle pm_runtime_get_sync failure cases

Neal Cardwell (1):
      tcp_cubic: fix spurious HYSTART_DELAY exit upon drop in min RTT

Olga Kornievskaia (1):
      NFSv4 fix CLOSE not waiting for direct IO compeletion

Peter Chen (3):
      usb: cdns3: trace: using correct dir value
      usb: cdns3: ep0: fix the test mode set incorrectly
      usb: cdns3: ep0: add spinlock for cdns3_check_new_setup

Qiushi Wu (2):
      efi/esrt: Fix reference count leak in esre_create_sysfs_entry.
      ASoC: rockchip: Fix a reference count leak.

Rahul Lakkireddy (1):
      cxgb4: move handling L2T ARP failures to caller

Robin Gong (3):
      regualtor: pfuze100: correct sw1a/sw2 on pfuze3000
      arm64: dts: imx8mm-evk: correct ldo1/ldo2 voltage range
      arm64: dts: imx8mn-ddr4-evk: correct ldo1/ldo2 voltage range

Roman Bolshakov (1):
      scsi: qla2xxx: Keep initiator ports after RSCN

Russell King (1):
      netfilter: ipset: fix unaligned atomic access

Sabrina Dubroca (1):
      geneve: allow changing DF behavior after creation

Sagi Grimberg (1):
      nvme: don't protect ns mutation with ns->head->lock

Sami Tolvanen (1):
      recordmcount: support >64k sections

Sasha Levin (2):
      btrfs: fix a block group ref counter leak after failure to remove block group
      Linux 5.4.50

Sean Christopherson (2):
      KVM: nVMX: Plumb L2 GPA through to PML emulation
      KVM: VMX: Stop context switching MSR_IA32_UMWAIT_CONTROL

SeongJae Park (1):
      scsi: lpfc: Avoid another null dereference in lpfc_sli4_hba_unset()

Shay Drory (1):
      IB/mad: Fix use after free when destroying MAD agent

Shengjiu Wang (1):
      ASoC: fsl_ssi: Fix bclk calculation for mono channel

Srinivas Kandagatla (3):
      ASoC: q6asm: handle EOS correctly
      ASoc: q6afe: add support to get port direction
      ASoC: qcom: common: set correct directions for dailinks

Stanislav Fomichev (1):
      bpf: Don't return EINVAL from {get,set}sockopt when optlen > PAGE_SIZE

Steffen Maier (1):
      scsi: zfcp: Fix panic on ERP timeout for previously dismissed ERP action

Steven Rostedt (VMware) (1):
      ring-buffer: Zero out time extend if it is nested and not absolute

Sven Auhagen (1):
      mvpp2: ethtool rxtx stats fix

Sven Schnelle (2):
      s390/ptrace: pass invalid syscall numbers to tracing
      s390/ptrace: fix setting syscall number

Taehee Yoo (3):
      net: core: reduce recursion limit value
      ip6_gre: fix use-after-free in ip6gre_tunnel_lookup()
      ip_tunnel: fix use-after-free in ip_tunnel_lookup()

Takashi Iwai (3):
      ALSA: usb-audio: Fix potential use-after-free of streams
      ALSA: usb-audio: Fix OOB access of mixer element list
      ALSA: hda/realtek - Add quirk for MSI GE63 laptop

Tang Bin (1):
      usb: host: ehci-exynos: Fix error check in exynos_ehci_probe()

Tariq Toukan (1):
      net: Do not clear the sock TX queue in sk_set_socket()

Thierry Reding (1):
      Revert "i2c: tegra: Fix suspending in active runtime PM state"

Thomas Falcon (2):
      ibmveth: Fix max MTU limit
      ibmvnic: Harden device login requests

Thomas Martitz (1):
      net: bridge: enfore alignment for ethernet address

Todd Kjos (1):
      binder: fix null deref of proc->context

Toke Høiland-Jørgensen (3):
      sch_cake: don't call diffserv parsing code when it is not needed
      sch_cake: fix a few style nits
      devmap: Use bpf_map_area_alloc() for allocating hash buckets

Tom Seewald (1):
      RDMA/siw: Fix pointer-to-int-cast warning in siw_rx_pbl()

Tomasz Meresiński (1):
      usb: add USB_QUIRK_DELAY_INIT for Logitech C922

Tony Lindgren (4):
      bus: ti-sysc: Flush posted write on enable and disable
      bus: ti-sysc: Ignore clockactivity unless specified as a quirk
      ARM: OMAP2+: Fix legacy mode dss_reset
      ARM: dts: Fix duovero smsc interrupt for suspend

Trond Myklebust (1):
      pNFS/flexfiles: Fix list corruption if the mirror count changes

Valentin Longchamp (1):
      net: sched: export __netdev_watchdog_up()

Vasily Averin (1):
      sunrpc: fixed rollback in rpc_gssd_dummy_populate()

Vidya Sagar (1):
      pinctrl: tegra: Use noirq suspend/resume callbacks

Vincent Chen (1):
      clk: sifive: allocate sufficient memory for struct __prci_data

Vincenzo Frascino (1):
      s390/vdso: fix vDSO clock_getres()

Waiman Long (1):
      mm/slab: use memzero_explicit() in kzfree()

Wang Hai (1):
      mld: fix memory leak in ipv6_mc_destroy_dev()

Weiping Zhang (1):
      block: update hctx map when use multiple maps

Wenhui Sheng (1):
      drm/amdgpu: add fw release for sdma v5_0

Will Deacon (1):
      arm64: sve: Fix build failure when ARM64_SVE=y and SYSCTL=n

Willem de Bruijn (1):
      selftests/net: report etf errors correctly

Xiaoyao Li (1):
      KVM: X86: Fix MSR range of APIC registers in X2APIC mode

Xiyu Yang (1):
      cifs: Fix cached_fid refcnt leak in open_shroot

Yang Yingliang (1):
      net: fix memleak in register_netdevice()

Yash Shah (1):
      RISC-V: Don't allow write+exec only page mapping request in mmap

Ye Bin (1):
      ata/libata: Fix usage of page address by page_address in ata_scsi_mode_select_xlat function

Yick W. Tse (1):
      ALSA: usb-audio: add quirk for Denon DCD-1500RE

Yoshihiro Shimoda (1):
      usb: renesas_usbhs: getting residue from callback_result

Zekun Shen (1):
      net: alx: fix race condition in alx_remove

Zhang Xiaoxu (2):
      cifs/smb3: Fix data inconsistent when punch hole
      cifs/smb3: Fix data inconsistent when zero file range

Zheng Bin (2):
      loop: replace kill_bdev with invalidate_bdev
      xfs: add agf freeblocks verify in xfs_agf_verify

guodeqing (1):
      net: Fix the arp error in some cases

yu kuai (2):
      block/bio-integrity: don't free 'buf' if bio_integrity_add_page() failed
      ARM: imx5: add missing put_device() call in imx_suspend_alloc_ocram()

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE4n5dijQDou9mhzu83qZv95d3LNwFAl78lZ8ACgkQ3qZv95d3
LNx4WA//cpo4FrJ6mmO2y5/X0pUKKlFJNeYNgae62TsjVCcsNIuqlwz19LkDg3xw
I8e5ul5RIhNJYuVh5T9VmmxACPV8J+LK96aIyYQNhqkLfWqi+kBID5NgFeSnSOBk
IhJmcSSuyU4J+XHFGPbBh0Zsk8nxoJrPJGmyBkKM8VQ2KJ/KwaDOdrysBiDE4mmX
hSE+lgKE8m1DohB8nrAg3Cn6mHjvmLE40Xybz4KTQTes1wuhososbp/RgFgjAosT
RCqNBgUhzTFkFZbZBpu0jv0/PO1q9sZnf65AIphUetuNXldyTYnnq5RGM3qrCbIC
KiRD27SAXTLKrbsX5xBakkp3Ea6u2puZFi6Y/nF6OJ82gPGyp1Jt6cEytbyY7H6b
GiMDz1mUqWlSeLxu2Pzs52VV5RNnvpHJhgyxNMShjRS9jGyHtmnQBC/llfdRNJW9
z8IDcvfPJ/6eYSygGwMP6mfih2d8hDdgeVeXEEPrXh6ZgtLyLohUDkGbGEDn/xqw
BC6TmT6iY++9EHlmvvduxUHTxSpPVbwhyU216Mj/GToSD7Kbzy4t2T8WyWtVSvEq
mmR9+5n/JyJER6/PxvqomyRx/rKeoQp9foVzjjTxvymKM79Gd/WOxKn2gs5CRJC6
I+zMWCFX5+ACfN9QkeAN1m+hzaGrM5WVgVKHjls73Xdaqd3cfJM=
=jmL1
-----END PGP SIGNATURE-----

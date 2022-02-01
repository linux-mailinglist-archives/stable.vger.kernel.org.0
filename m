Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61C694A61B2
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 17:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241302AbiBAQ5E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 11:57:04 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42652 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241316AbiBAQ5C (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 11:57:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8AE3D60C42;
        Tue,  1 Feb 2022 16:57:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38F97C340F5;
        Tue,  1 Feb 2022 16:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643734622;
        bh=WGA9Cv6EJraNWzTYEtFxwURAiG5aPNtLyZF0N7BZ8WY=;
        h=From:To:Cc:Subject:Date:From;
        b=XbDcd0YUojt6GXhv5FB7zEFdHwdJduZjW+AjzgCei2l0ifhRCHDZtlIl6wRQoJONG
         uZo9Tw6JgxSEhjzAQXdu/yTF8SLjYWbs1KBJvVYc17PyJ6FlKFT95JWOTlFyXsrcma
         o2mlohofUaFMye/meIBwRAxxhwfK9IVhYRh8BTjw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.19
Date:   Tue,  1 Feb 2022 17:56:48 +0100
Message-Id: <164373460813536@kroah.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.19 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/accounting/psi.rst                          |    3 
 Documentation/devicetree/bindings/net/can/tcan4x5x.txt    |    2 
 Makefile                                                  |    2 
 arch/arm/include/asm/assembler.h                          |    2 
 arch/arm/include/asm/processor.h                          |    1 
 arch/arm/include/asm/uaccess.h                            |   10 
 arch/arm/probes/kprobes/Makefile                          |    3 
 arch/arm64/kvm/hyp/exception.c                            |    5 
 arch/arm64/kvm/hyp/pgtable.c                              |   18 
 arch/ia64/pci/fixup.c                                     |    4 
 arch/mips/loongson64/vbios_quirk.c                        |    9 
 arch/powerpc/include/asm/book3s/32/mmu-hash.h             |    2 
 arch/powerpc/include/asm/kvm_book3s_64.h                  |    1 
 arch/powerpc/include/asm/kvm_host.h                       |    1 
 arch/powerpc/include/asm/ppc-opcode.h                     |    1 
 arch/powerpc/include/asm/syscall.h                        |    4 
 arch/powerpc/include/asm/thread_info.h                    |    2 
 arch/powerpc/kernel/Makefile                              |    1 
 arch/powerpc/kernel/interrupt_64.S                        |    2 
 arch/powerpc/kvm/book3s_hv.c                              |    3 
 arch/powerpc/kvm/book3s_hv_nested.c                       |    2 
 arch/powerpc/lib/Makefile                                 |    3 
 arch/powerpc/mm/book3s32/mmu.c                            |   15 
 arch/powerpc/mm/kasan/book3s_32.c                         |   59 +--
 arch/powerpc/net/bpf_jit_comp.c                           |   29 +
 arch/powerpc/net/bpf_jit_comp32.c                         |    9 
 arch/powerpc/net/bpf_jit_comp64.c                         |   29 +
 arch/powerpc/perf/core-book3s.c                           |   17 
 arch/s390/hypfs/hypfs_vm.c                                |    6 
 arch/s390/kernel/module.c                                 |   37 --
 arch/s390/kernel/nmi.c                                    |   27 +
 arch/x86/events/intel/core.c                              |   13 
 arch/x86/events/intel/uncore_snbep.c                      |    2 
 arch/x86/include/asm/kvm_host.h                           |    1 
 arch/x86/kernel/cpu/mce/amd.c                             |    2 
 arch/x86/kernel/cpu/mce/intel.c                           |    1 
 arch/x86/kvm/lapic.c                                      |    2 
 arch/x86/kvm/svm/nested.c                                 |    9 
 arch/x86/kvm/svm/svm.c                                    |   41 +-
 arch/x86/kvm/svm/svm.h                                    |    2 
 arch/x86/kvm/vmx/nested.c                                 |    1 
 arch/x86/kvm/x86.c                                        |   10 
 arch/x86/pci/fixup.c                                      |    4 
 block/bio.c                                               |    3 
 block/blk-core.c                                          |   25 +
 drivers/firmware/efi/efi.c                                |    7 
 drivers/firmware/efi/libstub/arm64-stub.c                 |    6 
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c     |    4 
 drivers/gpu/drm/ast/ast_tables.h                          |    2 
 drivers/gpu/drm/drm_atomic.c                              |   12 
 drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c              |    4 
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c                     |    2 
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_dspp.c               |   11 
 drivers/gpu/drm/msm/dsi/dsi.c                             |    7 
 drivers/gpu/drm/msm/dsi/phy/dsi_phy.c                     |    4 
 drivers/gpu/drm/msm/hdmi/hdmi.c                           |    7 
 drivers/gpu/drm/msm/msm_drv.c                             |    2 
 drivers/hv/hv_balloon.c                                   |    7 
 drivers/hwmon/adt7470.c                                   |    3 
 drivers/hwmon/lm90.c                                      |   21 -
 drivers/irqchip/irq-realtek-rtl.c                         |   10 
 drivers/md/dm.c                                           |   20 -
 drivers/mtd/nand/raw/mpc5121_nfc.c                        |    1 
 drivers/net/can/m_can/m_can.c                             |    6 
 drivers/net/can/m_can/tcan4x5x-regmap.c                   |    2 
 drivers/net/ethernet/google/gve/gve.h                     |    2 
 drivers/net/ethernet/google/gve/gve_main.c                |    6 
 drivers/net/ethernet/google/gve/gve_rx.c                  |    3 
 drivers/net/ethernet/google/gve/gve_rx_dqo.c              |    2 
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c |    3 
 drivers/net/ethernet/ibm/ibmvnic.c                        |  133 ++++---
 drivers/net/ethernet/intel/i40e/i40e.h                    |    9 
 drivers/net/ethernet/intel/i40e/i40e_debugfs.c            |    2 
 drivers/net/ethernet/intel/i40e/i40e_main.c               |   44 +-
 drivers/net/ethernet/intel/i40e/i40e_register.h           |    3 
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c        |  103 +++++
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h        |    1 
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h          |    3 
 drivers/net/ethernet/marvell/octeontx2/af/rpm.c           |   27 -
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c           |    7 
 drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c   |    2 
 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c       |   88 ++++
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c       |   22 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c    |   20 -
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h  |    1 
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c      |    7 
 drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c      |   42 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c         |   23 -
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c          |    3 
 drivers/net/ethernet/ti/cpsw_priv.c                       |    2 
 drivers/net/hamradio/yam.c                                |    4 
 drivers/net/phy/broadcom.c                                |    1 
 drivers/net/phy/phy_device.c                              |    6 
 drivers/net/phy/sfp-bus.c                                 |    5 
 drivers/rpmsg/rpmsg_char.c                                |   22 -
 drivers/s390/scsi/zfcp_fc.c                               |   13 
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c                         |   20 -
 drivers/scsi/elx/libefc/efc_els.c                         |    8 
 drivers/tty/n_gsm.c                                       |    4 
 drivers/tty/serial/8250/8250_of.c                         |   11 
 drivers/tty/serial/8250/8250_pci.c                        |  100 +++++
 drivers/tty/serial/amba-pl011.c                           |    8 
 drivers/tty/serial/stm32-usart.c                          |    2 
 drivers/usb/cdns3/drd.c                                   |    6 
 drivers/usb/common/ulpi.c                                 |    7 
 drivers/usb/core/hcd.c                                    |   14 
 drivers/usb/core/urb.c                                    |   12 
 drivers/usb/dwc3/dwc3-xilinx.c                            |   25 +
 drivers/usb/gadget/function/f_sourcesink.c                |    1 
 drivers/usb/host/xhci-plat.c                              |    3 
 drivers/usb/storage/unusual_devs.h                        |   10 
 drivers/usb/typec/tcpm/tcpci.c                            |   26 +
 drivers/usb/typec/tcpm/tcpci.h                            |    1 
 drivers/usb/typec/tcpm/tcpm.c                             |    7 
 drivers/usb/typec/ucsi/ucsi_ccg.c                         |    2 
 drivers/video/fbdev/hyperv_fb.c                           |   16 
 fs/btrfs/ioctl.c                                          |    6 
 fs/ceph/caps.c                                            |   55 ++
 fs/ceph/file.c                                            |    9 
 fs/configfs/dir.c                                         |    6 
 fs/devpts/inode.c                                         |    2 
 fs/io_uring.c                                             |    7 
 fs/jbd2/journal.c                                         |    2 
 fs/namei.c                                                |   10 
 fs/nfs/dir.c                                              |   22 +
 fs/nfsd/nfsctl.c                                          |    5 
 fs/ocfs2/suballoc.c                                       |   25 -
 fs/udf/inode.c                                            |    9 
 include/linux/blkdev.h                                    |    1 
 include/linux/fsnotify.h                                  |   48 ++
 include/linux/mm.h                                        |   17 
 include/linux/netdevice.h                                 |    1 
 include/linux/perf_event.h                                |   15 
 include/linux/psi.h                                       |   13 
 include/linux/psi_types.h                                 |    3 
 include/linux/usb/role.h                                  |    6 
 include/net/addrconf.h                                    |    2 
 include/net/ip.h                                          |   21 -
 include/net/ip6_fib.h                                     |    2 
 include/net/route.h                                       |    2 
 include/trace/events/sunrpc.h                             |   40 +-
 include/uapi/linux/cyclades.h                             |   35 +
 kernel/bpf/stackmap.c                                     |    5 
 kernel/cgroup/cgroup.c                                    |   11 
 kernel/events/core.c                                      |  257 ++++++++------
 kernel/power/wakelock.c                                   |   11 
 kernel/sched/fair.c                                       |   16 
 kernel/sched/membarrier.c                                 |    9 
 kernel/sched/pelt.h                                       |    4 
 kernel/sched/psi.c                                        |  145 +++----
 kernel/trace/trace.c                                      |    3 
 kernel/trace/trace_events_hist.c                          |    1 
 kernel/ucount.c                                           |    2 
 net/bluetooth/hci_event.c                                 |   10 
 net/bridge/br_vlan.c                                      |    9 
 net/core/net-procfs.c                                     |   38 +-
 net/ipv4/ip_output.c                                      |   26 +
 net/ipv4/ping.c                                           |    3 
 net/ipv4/raw.c                                            |    5 
 net/ipv6/addrconf.c                                       |   27 +
 net/ipv6/ip6_fib.c                                        |   23 -
 net/ipv6/ip6_tunnel.c                                     |    8 
 net/ipv6/route.c                                          |    2 
 net/netfilter/nf_conntrack_core.c                         |    8 
 net/packet/af_packet.c                                    |    2 
 net/rxrpc/call_event.c                                    |    8 
 net/rxrpc/output.c                                        |    2 
 net/sched/sch_htb.c                                       |   20 +
 net/smc/af_smc.c                                          |   63 ++-
 net/sunrpc/rpc_pipe.c                                     |    4 
 tools/testing/selftests/kvm/x86_64/smm_test.c             |    1 
 usr/include/Makefile                                      |    2 
 virt/kvm/kvm_main.c                                       |    1 
 173 files changed, 1730 insertions(+), 815 deletions(-)

Alan Stern (2):
      usb-storage: Add unusual-devs entry for VL817 USB-SATA bridge
      USB: core: Fix hang in usb_kill_urb by adding memory barriers

Amir Goldstein (2):
      fsnotify: fix fsnotify hooks in pseudo filesystems
      fsnotify: invalidate dcache before IN_DELETE event

Ard Biesheuvel (3):
      ARM: 9179/1: uaccess: avoid alignment faults in copy_[from|to]_kernel_nofault
      ARM: 9180/1: Thumb2: align ALT_UP() sections in modules sufficiently
      efi: runtime: avoid EFIv2 runtime services on Apple x86 machines

Athira Rajeev (1):
      powerpc/perf: Fix power_pmu_disable to call clear_pmi_irq_pending only if PMI is pending

Badhri Jagan Sridharan (2):
      usb: typec: tcpm: Do not disconnect while receiving VBUS off
      usb: typec: tcpm: Do not disconnect when receiving VSAFE0V

Bas Nieuwenhuizen (1):
      drm/amd/display: Fix FP start/end for dcn30_internal_validate_bw.

Bjorn Helgaas (1):
      PCI/sysfs: Find shadow ROM before static attribute initialization

Brian Gix (1):
      Bluetooth: refactor malicious adv data check

Cameron Williams (1):
      tty: Add support for Brainboxes UC cards.

Catherine Sullivan (1):
      gve: Fix GFP flags when allocing pages

Christian Borntraeger (2):
      s390/nmi: handle guarded storage validity failures for KVM guests
      s390/nmi: handle vector validity failures for KVM guests

Christophe Leroy (4):
      powerpc/audit: Fix syscall_get_arch()
      powerpc/32s: Allocate one 256k IBAT instead of two consecutives 128k IBATs
      powerpc/32s: Fix kasan_init_region() for KASAN
      powerpc/32: Fix boot failure with GCC latent entropy plugin

Chuck Lever (2):
      SUNRPC: Use BIT() macro in rpc_show_xprt_state()
      SUNRPC: Don't dereference xprt->snd_task if it's a cookie

Congyu Liu (1):
      net: fix information leakage in /proc/net/ptype

Dan Carpenter (1):
      hwmon: (adt7470) Prevent divide by zero in adt7470_fan_write()

Dave Airlie (1):
      Revert "drm/ast: Support 1600x900 with 108MHz PCLK"

David Howells (1):
      rxrpc: Adjust retransmission backoff

Denis Valeev (1):
      KVM: x86: nSVM: skip eax alignment check for non-SVM instructions

Dmitry V. Levin (1):
      usr/include/Makefile: add linux/nfc.h to the compile-test coverage

Dylan Yudaken (1):
      io_uring: fix bug in slow unregistering of nodes

Eric Dumazet (5):
      ipv4: avoid using shared IP generator for connected sockets
      ipv6: annotate accesses to fn->fn_sernum
      ipv4: raw: lock the socket in raw_bind()
      ipv4: tcp: send zero IPID in SYNACK messages
      ipv4: remove sparse error in ip_neigh_gw4()

Eric W. Biederman (1):
      ucount: Make get_ucount a safe get_user replacement

Florian Westphal (1):
      netfilter: conntrack: don't increment invalid counter on NF_REPEAT

Frank Li (1):
      usb: xhci-plat: fix crash when suspend if remote wake enable

Geert Uytterhoeven (1):
      mtd: rawnand: mpc5121: Remove unused variable in ads5121_select_chip()

Geetha sowjanya (4):
      octeontx2-af: Retry until RVU block reset complete
      octeontx2-pf: cn10k: Ensure valid pointers are freed to aura
      octeontx2-af: Increase link credit restore polling timeout
      octeontx2-af: cn10k: Do not enable RPM loopback for LPC interfaces

Greg Kroah-Hartman (3):
      PM: wakeup: simplify the output logic of pm_show_wakelocks()
      kbuild: remove include/linux/cyclades.h from header file check
      Linux 5.15.19

Guenter Roeck (6):
      hwmon: (lm90) Mark alert as broken for MAX6646/6647/6649
      hwmon: (lm90) Mark alert as broken for MAX6680
      hwmon: (lm90) Reduce maximum conversion rate for G781
      hwmon: (lm90) Re-enable interrupts after alert clears
      hwmon: (lm90) Mark alert as broken for MAX6654
      hwmon: (lm90) Fix sysfs and udev notifications

Guillaume Nault (1):
      Revert "ipv6: Honor all IPv6 PIO Valid Lifetime values"

Hangyu Hua (1):
      yam: fix a memory leak in yam_siocdevprivate()

Hariprasad Kelam (1):
      octeontx2-af: verify CQ context updates

Ido Schimmel (1):
      ipv6_tunnel: Rate limit warning messages

Ilya Leoshkevich (1):
      s390/module: fix loading modules with a lot of relocations

Jakub Kicinski (1):
      ipv4: fix ip option filtering for locally generated fragments

Jan Kara (2):
      udf: Restore i_lenAlloc when inode expansion fails
      udf: Fix NULL ptr deref when converting from inline format

Jedrzej Jagielski (2):
      i40e: Increase delay to 1 s after global EMP reset
      i40e: Fix issue when maximum queues is exceeded

Jeff Layton (2):
      ceph: properly put ceph_string reference after async create attempt
      ceph: set pool_ns in new inode layout for async creates

Jianguo Wu (1):
      net-procfs: show net devices bound packet types

Jochen Mades (1):
      serial: pl011: Fix incorrect rs485 RTS polarity on set_mctrl

Joe Damato (1):
      i40e: fix unsigned stat widths

John Meneghini (1):
      scsi: bnx2fc: Flush destroy_work queue before calling bnx2fc_interface_put()

Jon Hunter (1):
      usb: common: ulpi: Fix crash in ulpi_match()

Joseph Qi (2):
      jbd2: export jbd2_journal_[grab|put]_journal_head
      ocfs2: fix a deadlock when commit trans

José Expósito (2):
      drm/msm/dsi: invalid parameter check in msm_dsi_phy_enable
      drm/msm/dpu: invalid parameter check in dpu_setup_dspp_pcc

Kan Liang (1):
      perf/x86/intel: Add a quirk for the calculation of the number of counters on Alder Lake

Karen Sornek (1):
      i40e: Fix for failed to init adminq while VF reset

Like Xu (2):
      KVM: x86: Update vCPU's runtime CPUID on write to MSR_IA32_XSS
      KVM: x86: Sync the states size with the XCR0/IA32_XSS at, any time

Linyu Yuan (1):
      usb: roles: fix include/linux/usb/role.h compile issue

Lucas Stach (1):
      drm/etnaviv: relax submit size limits

Maciej W. Rozycki (1):
      tty: Partially revert the removal of the Cyclades public API

Manasi Navare (1):
      drm/atomic: Add the crtc to affected crtc only if uapi.enable = true

Marc Kleine-Budde (3):
      can: m_can: m_can_fifo_{read,write}: don't read or write from/to FIFO if length is 0
      can: tcan4x5x: regmap: fix max register value
      dt-bindings: can: tcan4x5x: fix mram-cfg RX FIFO config

Marc Zyngier (2):
      KVM: arm64: Use shadow SPSR_EL1 when injecting exceptions on !VHE
      KVM: arm64: pkvm: Use the mm_ops indirection for cache maintenance

Marek Behún (2):
      net: sfp: ignore disabled SFP node
      phylib: fix potential use-after-free

Mathieu Desnoyers (1):
      sched/membarrier: Fix membarrier-rseq fence command missing from query bitmask

Matthias Kaehlcke (1):
      rpmsg: char: Fix race between the release of rpmsg_eptdev and cdev

Maxim Mikityanskiy (1):
      sch_htb: Fail on unsupported parameters when offload is requested

Miaoqian Lin (2):
      drm/msm/dsi: Fix missing put_device() call in dsi_get_phy
      drm/msm/hdmi: Fix missing put_device() call in msm_hdmi_get_phy

Michael Kelley (1):
      video: hyperv_fb: Fix validation of screen resolution

Mihai Carabas (1):
      efi/libstub: arm64: Fix image check alignment at entry

Mike Snitzer (3):
      dm: revert partial fix for redundant bio-based IO accounting
      block: add bio_start_io_acct_time() to control start_time
      dm: properly fix redundant bio-based IO accounting

Mohammad Athari Bin Ismail (2):
      net: stmmac: configure PTP clock source prior to PTP initialization
      net: stmmac: skip only stmmac_ptp_register when resume from suspend

Namhyung Kim (1):
      perf/core: Fix cgroup event list management

Naveen N. Rao (4):
      bpf: Guard against accessing NULL pt_regs in bpf_get_task_stack()
      powerpc32/bpf: Fix codegen for bpf-to-bpf calls
      powerpc/bpf: Update ldimm64 instructions during extra pass
      powerpc64/bpf: Limit 'ldbrx' to processors compliant with ISA v2.06

Nicholas Piggin (2):
      KVM: PPC: Book3S HV Nested: Fix nested HFSCR being clobbered with multiple vCPUs
      powerpc/64s: Mask SRR0 before checking against the masked NIP

Nikolay Aleksandrov (1):
      net: bridge: vlan: fix single net device option dumping

OGAWA Hirofumi (1):
      block: Fix wrong offset in bio_truncate()

Pavankumar Kondeti (1):
      usb: gadget: f_sourcesink: Fix isoc transfer for USB_SPEED_SUPER_PLUS

Pawel Laszczak (1):
      usb: cdnsp: Fix segmentation fault in cdns_lost_power function

Peter Collingbourne (1):
      mm, kasan: use compare-exchange operation to set KASAN page tag

Peter Zijlstra (1):
      perf: Fix perf_event_read_local() time

Rob Clark (1):
      drm/msm/a6xx: Add missing suspend_count increment

Robert Hancock (5):
      serial: 8250: of: Fix mapped region size when using reg-offset property
      usb: dwc3: xilinx: Skip resets and USB3 register settings for USB2.0 mode
      usb: dwc3: xilinx: Fix error handling when getting USB3 PHY
      net: phy: broadcom: hook up soft_reset for BCM54616S
      usb: dwc3: xilinx: fix uninitialized return value

Sander Vanheule (2):
      irqchip/realtek-rtl: Map control data to virq
      irqchip/realtek-rtl: Fix off-by-one in routing

Sean Christopherson (5):
      Revert "KVM: SVM: avoid infinite loop on NPF from bad address"
      KVM: SVM: Never reject emulation due to SMAP errata for !SEV guests
      KVM: SVM: Don't intercept #GP for SEV guests
      KVM: x86: Forcibly leave nested virt when SMM state is toggled
      KVM: selftests: Don't skip L2's VMCALL in SMM test for SVM guest

Sing-Han Chen (1):
      ucsi_ccg: Check DEV_INT bit only when starting CCG4

Steffen Maier (1):
      scsi: zfcp: Fix failed recovery on gone remote port with non-NPIV FCP devices

Subbaraya Sundeep (2):
      octeontx2-af: Do not fixup all VF action entries
      octeontx2-pf: Forward error codes to VF

Sujit Kautkar (1):
      rpmsg: char: Fix race between the release of rpmsg_ctrldev and cdev

Sukadev Bhattiprolu (3):
      ibmvnic: Allow extra failures before disabling
      ibmvnic: init ->running_cap_crqs early
      ibmvnic: don't spin in tasklet

Sunil Goutham (1):
      octeontx2-af: Fix LBK backpressure id count

Suren Baghdasaryan (3):
      psi: Fix uaf issue when psi trigger is destroyed while being polled
      psi: fix "no previous prototype" warnings when CONFIG_CGROUPS=n
      psi: fix "defined but not used" warnings when CONFIG_PROC_FS=n

Sylwester Dziedziuch (1):
      i40e: Fix queues reservation for XDP

Tim Yi (1):
      net: bridge: vlan: fix memory leak in __allowed_ingress

Toke Høiland-Jørgensen (1):
      net: cpsw: Properly initialise struct page_pool_params

Tom Zanussi (1):
      tracing: Don't inc err_log entry count if entry allocation fails

Tony Luck (1):
      x86/cpu: Add Xeon Icelake-D to list of CPUs that support PPIN

Trond Myklebust (4):
      NFSv4: Handle case where the lookup of a directory fails
      NFSv4: nfs_atomic_open() can race when looking up a non-regular file
      NFS: Ensure the server has an up to date ctime before hardlinking
      NFS: Ensure the server has an up to date ctime before renaming

Valentin Caron (1):
      serial: stm32: fix software flow control transfer

Vasily Gorbik (1):
      s390/hypfs: include z/VM guests with access control group set

Vincent Guittot (1):
      sched/pelt: Relax the sync of util_sum with util_avg

Wanpeng Li (1):
      KVM: LAPIC: Also cancel preemption timer during SET_LAPIC

Wen Gu (1):
      net/smc: Transitional solution for clcsock race issue

Xianting Tian (1):
      drm/msm: Fix wrong size calculation

Xiaoke Wang (1):
      tracing/histogram: Fix a potential memory leak for kstrdup()

Xiaoyao Li (1):
      KVM: x86: Keep MSR_IA32_XSS unchanged for INIT

Xin Long (1):
      ping: fix the sk_bound_dev_if match in ping_lookup

Xiubo Li (1):
      ceph: put the requests/sessions when it fails to alloc memory

Xu Yang (1):
      usb: typec: tcpci: don't touch CC line if it's Vconn source

Yang Yingliang (1):
      scsi: elx: efct: Don't use GFP_KERNEL under spin lock

Yanming Liu (1):
      Drivers: hv: balloon: account for vmbus packet header in max_pkt_size

Yazen Ghannam (1):
      x86/MCE/AMD: Allow thresholding interface updates after init

Yufeng Mo (1):
      net: hns3: handle empty unknown interrupt for VF

Yuji Ishikawa (2):
      net: stmmac: dwmac-visconti: Fix bit definitions for ETHER_CLK_SEL
      net: stmmac: dwmac-visconti: Fix clock configuration for RMII mode

Zhengjun Xing (1):
      perf/x86/intel/uncore: Fix CAS_COUNT_WRITE issue for ICX

daniel.starke@siemens.com (1):
      tty: n_gsm: fix SW flow control encoding/handling

sparkhuang (1):
      ARM: 9170/1: fix panic when kasan and kprobe are enabled


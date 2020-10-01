Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E33C228079F
	for <lists+stable@lfdr.de>; Thu,  1 Oct 2020 21:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730152AbgJATVz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Oct 2020 15:21:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:50858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729990AbgJATVz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Oct 2020 15:21:55 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3370C20759;
        Thu,  1 Oct 2020 19:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601580112;
        bh=4QTKDArla9NodG8twiHgS9u9ge/aXIYNOYGE0oLFErg=;
        h=From:To:Cc:Subject:Date:From;
        b=fBHXN/7ngnbI6tdoek2ZSXPaGquZqvYBx0gLfdFYtmiP4zwVfWxHn+zTEO6FUCERg
         NHmz5AU1kRJXXfOEgVe+e7bAO/fE5XU3mYer3ulhLb4/lV6L8LfSyUSH2J6yNj9Je4
         fjcoxO08M4SSMd52rqhCwKC5Z+7mHlxUJaMLfQZU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.238
Date:   Thu,  1 Oct 2020 21:21:50 +0200
Message-Id: <1601580109173143@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.9.238 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/DocBook/libata.tmpl                  |    2 
 Documentation/devicetree/bindings/sound/wm8994.txt |   18 +-
 Makefile                                           |    2 
 arch/m68k/q40/config.c                             |    1 
 arch/mips/include/asm/cpu-type.h                   |    1 
 arch/s390/kernel/setup.c                           |    6 
 arch/x86/include/asm/nospec-branch.h               |    4 
 arch/x86/include/asm/pkeys.h                       |    5 
 arch/x86/kernel/fpu/xstate.c                       |    9 +
 arch/x86/kvm/mmutrace.h                            |    2 
 arch/x86/kvm/x86.c                                 |   10 +
 drivers/acpi/ec.c                                  |   16 --
 drivers/ata/acard-ahci.c                           |    6 
 drivers/ata/libahci.c                              |    6 
 drivers/ata/libata-core.c                          |    9 +
 drivers/ata/libata-sff.c                           |   12 +
 drivers/ata/pata_macio.c                           |    6 
 drivers/ata/pata_pxa.c                             |    8 -
 drivers/ata/pdc_adma.c                             |    7 -
 drivers/ata/sata_fsl.c                             |    4 
 drivers/ata/sata_inic162x.c                        |    4 
 drivers/ata/sata_mv.c                              |   34 ++---
 drivers/ata/sata_nv.c                              |   18 +-
 drivers/ata/sata_promise.c                         |    6 
 drivers/ata/sata_qstor.c                           |    8 -
 drivers/ata/sata_rcar.c                            |    6 
 drivers/ata/sata_sil.c                             |    8 -
 drivers/ata/sata_sil24.c                           |    6 
 drivers/ata/sata_sx4.c                             |    6 
 drivers/atm/eni.c                                  |    2 
 drivers/char/tlclk.c                               |   17 +-
 drivers/char/tpm/tpm_ibmvtpm.c                     |    9 +
 drivers/char/tpm/tpm_ibmvtpm.h                     |    1 
 drivers/clk/ti/adpll.c                             |   11 -
 drivers/clocksource/h8300_timer8.c                 |    2 
 drivers/cpufreq/powernv-cpufreq.c                  |   13 +
 drivers/devfreq/tegra-devfreq.c                    |    4 
 drivers/dma/tegra20-apb-dma.c                      |    3 
 drivers/dma/xilinx/zynqmp_dma.c                    |   24 ++-
 drivers/gpu/drm/amd/amdgpu/atom.c                  |    4 
 drivers/gpu/drm/gma500/cdv_intel_display.c         |    2 
 drivers/gpu/drm/omapdrm/dss/omapdss-boot-init.c    |    4 
 drivers/i2c/i2c-core.c                             |    2 
 drivers/infiniband/core/ucma.c                     |    6 
 drivers/infiniband/hw/cxgb4/cm.c                   |    4 
 drivers/infiniband/hw/i40iw/i40iw_cm.c             |    2 
 drivers/infiniband/sw/rxe/rxe_qp.c                 |    7 -
 drivers/md/bcache/bcache.h                         |    1 
 drivers/md/bcache/btree.c                          |   12 +
 drivers/md/bcache/super.c                          |    1 
 drivers/media/dvb-frontends/tda10071.c             |    9 -
 drivers/media/platform/ti-vpe/cal.c                |    6 
 drivers/media/usb/go7007/go7007-usb.c              |    4 
 drivers/mfd/mfd-core.c                             |   10 +
 drivers/mtd/chips/cfi_cmdset_0002.c                |    1 
 drivers/mtd/cmdlinepart.c                          |   23 +++
 drivers/mtd/nand/omap_elm.c                        |    1 
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |   31 +++-
 drivers/net/ethernet/intel/e1000/e1000_main.c      |   18 ++
 drivers/net/ieee802154/adf7242.c                   |    4 
 drivers/net/phy/phy_device.c                       |    3 
 drivers/net/wan/hdlc_ppp.c                         |   16 +-
 drivers/net/wireless/ath/ar5523/ar5523.c           |    2 
 drivers/net/wireless/marvell/mwifiex/fw.h          |    2 
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c |    4 
 drivers/phy/phy-s5pv210-usb2.c                     |    4 
 drivers/scsi/aacraid/aachba.c                      |    8 -
 drivers/scsi/lpfc/lpfc_ct.c                        |  137 ++++++++++-----------
 drivers/scsi/lpfc/lpfc_hw.h                        |   36 ++---
 drivers/scsi/lpfc/lpfc_sli.c                       |    4 
 drivers/tty/serial/8250/8250_core.c                |   11 +
 drivers/tty/serial/8250/8250_omap.c                |    8 -
 drivers/tty/serial/8250/8250_port.c                |   16 ++
 drivers/tty/serial/samsung.c                       |    8 -
 drivers/usb/host/ehci-mv.c                         |    8 -
 drivers/vfio/pci/vfio_pci.c                        |   13 +
 fs/block_dev.c                                     |   10 +
 fs/btrfs/extent-tree.c                             |    2 
 fs/ceph/caps.c                                     |   14 +-
 fs/cifs/cifsglob.h                                 |    9 -
 fs/cifs/file.c                                     |   21 ++-
 fs/cifs/misc.c                                     |   17 --
 fs/cifs/smb1ops.c                                  |    8 -
 fs/cifs/smb2misc.c                                 |   32 +---
 fs/cifs/smb2ops.c                                  |   44 ++++--
 fs/cifs/smb2pdu.h                                  |    2 
 fs/fuse/dev.c                                      |    1 
 fs/ubifs/io.c                                      |   16 ++
 fs/xfs/libxfs/xfs_attr_leaf.c                      |    4 
 fs/xfs/libxfs/xfs_dir2_node.c                      |    1 
 include/linux/debugfs.h                            |    5 
 include/linux/libata.h                             |   13 +
 include/linux/mtd/map.h                            |    2 
 include/linux/seqlock.h                            |   11 +
 include/linux/skbuff.h                             |   16 ++
 kernel/audit_watch.c                               |    2 
 kernel/bpf/hashtab.c                               |    8 -
 kernel/kprobes.c                                   |   14 +-
 kernel/printk/printk.c                             |    3 
 kernel/sys.c                                       |    4 
 kernel/time/timekeeping.c                          |    3 
 kernel/trace/trace.c                               |    5 
 kernel/trace/trace_entries.h                       |    2 
 kernel/trace/trace_events.c                        |    2 
 lib/string.c                                       |   24 +++
 mm/filemap.c                                       |    8 +
 mm/mmap.c                                          |    2 
 mm/pagewalk.c                                      |    4 
 net/atm/lec.c                                      |    6 
 net/batman-adv/bridge_loop_avoidance.c             |   42 ++++--
 net/batman-adv/bridge_loop_avoidance.h             |    4 
 net/batman-adv/routing.c                           |    4 
 net/batman-adv/soft-interface.c                    |    6 
 net/bluetooth/hci_event.c                          |   25 +++
 net/bluetooth/l2cap_core.c                         |   29 ++--
 net/bluetooth/l2cap_sock.c                         |   18 ++
 net/core/neighbour.c                               |    1 
 net/hsr/hsr_device.c                               |    3 
 net/ipv4/ip_output.c                               |    3 
 net/ipv4/route.c                                   |    1 
 net/key/af_key.c                                   |    7 +
 net/mac802154/tx.c                                 |    8 -
 net/sunrpc/svc_xprt.c                              |   19 ++
 net/sunrpc/xprtrdma/svc_rdma_backchannel.c         |    1 
 net/tipc/msg.c                                     |    3 
 net/unix/af_unix.c                                 |   11 +
 security/selinux/selinuxfs.c                       |    1 
 sound/hda/hdac_bus.c                               |    4 
 sound/pci/asihpi/hpioctl.c                         |    4 
 sound/pci/hda/hda_controller.c                     |   11 +
 sound/soc/kirkwood/kirkwood-dma.c                  |    2 
 sound/usb/midi.c                                   |   29 +++-
 sound/usb/quirks.c                                 |    7 -
 tools/gpio/gpio-hammer.c                           |   17 ++
 tools/objtool/check.c                              |    2 
 tools/perf/util/sort.c                             |    2 
 tools/perf/util/symbol-elf.c                       |    7 +
 tools/testing/selftests/x86/syscall_nt.c           |    1 
 virt/kvm/kvm_main.c                                |   22 +--
 139 files changed, 894 insertions(+), 463 deletions(-)

Adrian Hunter (1):
      perf kcore_copy: Fix module map when there are no modules loaded

Alain Michaud (1):
      Bluetooth: guard against controllers sending zero'd events

Alex Williamson (1):
      vfio/pci: Clear error and request eventfd ctx after releasing

Alexander Duyck (1):
      e1000: Do not perform reset in reset_task if we are already down

Andreas Steinmetz (1):
      ALSA: usb-audio: Fix case when USB MIDI interface has more than one extra endpoint descriptor

Andy Lutomirski (1):
      selftests/x86/syscall_nt: Clear weird flags after each test

Balsundar P (1):
      scsi: aacraid: fix illegal IO beyond last LBA

Bart Van Assche (1):
      RDMA/rxe: Fix configuration of atomic queue pair attributes

Ben Hutchings (1):
      mtd: Fix comparison in map_word_andequal()

Boris Brezillon (1):
      mtd: parser: cmdline: Support MTD names containing one or more colons

Brian Foster (1):
      xfs: fix attr leaf header freemap.size underflow

Christophe JAILLET (2):
      RDMA/iw_cgxb4: Fix an error handling path in 'c4iw_connect()'
      SUNRPC: Fix a potential buffer overflow in 'svc_print_xprts()'

Chuck Lever (1):
      svcrdma: Fix leak of transport addresses

Colin Ian King (2):
      media: tda10071: fix unsigned sign extension overflow
      USB: EHCI: ehci-mv: fix less than zero comparison of an unsigned int

Cong Wang (1):
      atm: fix a memory leak of vcc->user_back

Dan Carpenter (1):
      hdlc_ppp: add range checks in ppp_cp_parse_cr()

Darrick J. Wong (1):
      xfs: don't ever return a stale pointer from __xfs_dir3_free_read

Dave Hansen (1):
      x86/pkeys: Add check for pkey "overflow"

David Sterba (1):
      btrfs: don't force read-only after error in drop snapshot

Dinghao Liu (1):
      mtd: rawnand: omap_elm: Fix runtime PM imbalance on error

Divya Indi (1):
      tracing: Adding NULL checks for trace_array descriptor pointer

Dmitry Osipenko (2):
      PM / devfreq: tegra30: Fix integer overflow on CPU's freq max out
      dmaengine: tegra-apb: Prevent race conditions on channel's freeing

Douglas Anderson (1):
      bdev: Reduce time holding bd_mutex in sync in blkdev_close()

Eric Dumazet (2):
      net: add __must_check to skb_put_padto()
      mac802154: tx: fix use-after-free

Florian Fainelli (2):
      net: phy: Avoid NPD upon phy_detach() when driver is unbound
      net/hsr: Check skb_put_padto() return value

Fuqian Huang (1):
      m68k: q40: Fix info-leak in rtc_ioctl

Gabriel Ravier (1):
      tools: gpio-hammer: Avoid potential overflow in main

Greg Kroah-Hartman (1):
      Linux 4.9.238

Guoju Fang (1):
      bcache: fix a lost wake-up problem caused by mca_cannibalize_lock

Hans de Goede (1):
      i2c: core: Call i2c_acpi_install_space_handler() before i2c_acpi_register_devices()

Hillf Danton (1):
      Bluetooth: prefetch channel before killing sock

Hou Tao (1):
      mtd: cfi_cmdset_0002: don't free cfi->cfiq in error path of cfi_amdstd_setup()

Howard Chung (1):
      Bluetooth: L2CAP: handle l2cap config request during open state

Ilya Leoshkevich (1):
      s390/init: add missing __init annotations

Jaewon Kim (1):
      mm/mmap.c: initialize align_offset explicitly for vm_unmapped_area

James Smart (2):
      scsi: lpfc: Fix RQ buffer leakage when no IOCBs available
      scsi: lpfc: Fix coverity errors in fmdi attribute handling

Jeff Layton (1):
      ceph: fix potential race in ceph_check_caps

Jing Xiangfeng (1):
      atm: eni: fix the missed pci_disable_device() for eni_init_one()

Jiri Slaby (3):
      ata: define AC_ERR_OK
      ata: make qc_prep return ata_completion_errors
      ata: sata_mv, avoid trigerrable BUG_ON

Joakim Tjernlund (1):
      ALSA: usb-audio: Add delay quirk for H570e USB headsets

Joe Perches (1):
      kernel/sys.c: avoid copying possible padding bytes in copy_to_user

John Clements (1):
      drm/amdgpu: increase atombios cmd timeout

Jonathan Bakker (2):
      phy: samsung: s5pv210-usb2: Add delay after reset
      tty: serial: samsung: Correct clock selection logic

Josef Bacik (1):
      tracing: Set kernel_stack's caller size properly

Josh Poimboeuf (1):
      objtool: Fix noreturn detection for ignored functions

Kangjie Lu (1):
      gma/gma500: fix a memory disclosure bug due to uninitialized bytes

Krzysztof Kozlowski (1):
      dt-bindings: sound: wm8994: Correct required supplies based on actual implementaion

Kusanagi Kouichi (1):
      debugfs: Fix !DEBUG_FS debugfs_create_automount

Lee Jones (1):
      mfd: mfd-core: Protect against NULL call-back function pointer

Linus Lüssing (3):
      batman-adv: bla: fix type misuse for backbone_gw hash indexing
      batman-adv: mcast/TT: fix wrongly dropped or rerouted packets
      batman-adv: mcast: fix duplicate mcast packets in BLA backbone from mesh

Liu Song (1):
      ubifs: Fix out-of-bounds memory access caused by abnormal value of node_len

Lukas Wunner (1):
      serial: 8250: Avoid error message on reprobe

Madhuparna Bhowmik (1):
      drivers: char: tlclk.c: Avoid data race between init and interrupt handler

Manish Mandlik (1):
      Bluetooth: Fix refcount use-after-free issue

Marco Elver (1):
      seqlock: Require WRITE_ONCE surrounding raw_seqcount_barrier

Mark Salyzyn (1):
      af_key: pfkey_dump needs parameter validation

Masami Hiramatsu (1):
      kprobes: Fix to check probe enabled before disarm_kprobe_ftrace()

Matthias Fend (1):
      dmaengine: zynqmp_dma: fix burst length configuration

Maximilian Luz (1):
      mwifiex: Increase AES key storage size to 256 bits

Mert Dirik (1):
      ar5523: Add USB ID of SMCWUSBT-G2 wireless adapter

Michael Chan (1):
      bnxt_en: Protect bnxt_set_eee() and bnxt_set_pauseparam() with mutex.

Miklos Szeredi (1):
      fuse: don't check refcount after stealing page

Mohan Kumar (1):
      ALSA: hda: Clear RIRB status before reading WP

Muchun Song (1):
      kprobes: fix kill kprobe which has been marked as gone

Nathan Chancellor (1):
      tracing: Use address-of operator on section symbols

Nick Desaulniers (1):
      lib/string.c: implement stpcpy

Nikhil Devshatwar (1):
      media: ti-vpe: cal: Restrict DMA to avoid memory corruption

Pan Bian (1):
      RDMA/i40iw: Fix potential use after free

Paolo Bonzini (1):
      KVM: x86: fix incorrect comparison in trace event

Pavel Shilovsky (1):
      CIFS: Properly process SMB3 lease breaks

Peter Ujfalusi (1):
      serial: 8250_omap: Fix sleeping function called from invalid context during probe

Pratik Rajesh Sampat (1):
      cpufreq: powernv: Fix frame-size-overflow in powernv_cpufreq_work_fn

Qian Cai (2):
      skbuff: fix a data race in skb_queue_len()
      vfio/pci: fix memory leaks of eventfd ctx

Rafael J. Wysocki (1):
      ACPI: EC: Reference count query handlers under lock

Russell King (1):
      ASoC: kirkwood: fix IRQ error handling

Rustam Kovhaev (1):
      KVM: fix memory leak in kvm_io_bus_unregister_dev()

Shamir Rabinovitch (1):
      RDMA/ucma: ucma_context reference leak in error path

Shreyas Joshi (1):
      printk: handle blank console arguments passed in.

Sonny Sasaka (1):
      Bluetooth: Handle Inquiry Cancel error after Inquiry Complete

Stefan Berger (1):
      tpm: ibmvtpm: Wait for buffer to be set before proceeding

Stephen Kitt (1):
      clk/ti/adpll: allocate room for terminating null

Steve Grubb (1):
      audit: CONFIG_CHANGE don't log internal bookkeeping as an event

Steve Rutherford (1):
      KVM: Remove CREATE_IRQCHIP/SET_PIT2 race

Steven Price (1):
      mm: pagewalk: fix termination condition in walk_pte_range()

Sven Eckelmann (1):
      batman-adv: Add missing include for in_interrupt()

Takashi Iwai (2):
      media: go7007: Fix URB type for interrupt handling
      ALSA: hda: Fix potential race in unsol event handler

Tang Bin (1):
      USB: EHCI: ehci-mv: fix error handling in mv_ehci_probe()

Thomas Gleixner (2):
      bpf: Remove recursion prevention from rcu free callback
      x86/speculation/mds: Mark mds_user_clear_cpu_buffers() __always_inline

Tianjia Zhang (1):
      clocksource/drivers/h8300_timer8: Fix wrong return value in h8300_8timer_init()

Tom Rix (2):
      ieee802154/adf7242: check status of adf7242_read_reg
      ALSA: asihpi: fix iounmap in error handler

Vasily Averin (3):
      neigh_stat_seq_next() should increase position index
      rt_cpu_seq_next should increase position index
      selinux: sel_avc_get_stat_idx should increase position index

Vignesh Raghavendra (2):
      serial: 8250_port: Don't service RX FIFO if throttled
      serial: 8250: 8250_omap: Terminate DMA before pushing data on RX timeout

Wei Li (1):
      MIPS: Add the missing 'CPU_1074K' into __get_cpu_type()

Wei Wang (1):
      ip: fix tos reflection in ack and reset packets

Wen Yang (2):
      drm/omap: fix possible object reference leak
      timekeeping: Prevent 32bit truncation in scale64_check_overflow()

Xianting Tian (1):
      mm/filemap.c: clear page error before actual read

Xie XiuQi (1):
      perf util: Fix memory leak of prefix_if_not_in

Xin Long (1):
      tipc: use skb_unshare() instead in tipc_buf_append()

Zeng Tao (1):
      vfio/pci: fix racy on error and request eventfd ctx

Zhang Xiaoxu (1):
      cifs: Fix double add page to memcg when cifs_readpages

Zhuang Yanying (1):
      KVM: fix overflow of zero page refcount with ksm running


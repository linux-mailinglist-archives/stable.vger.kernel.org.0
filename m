Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 191F42802DD
	for <lists+stable@lfdr.de>; Thu,  1 Oct 2020 17:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732617AbgJAPfl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Oct 2020 11:35:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:49368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732588AbgJAPfl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Oct 2020 11:35:41 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C3B7207F7;
        Thu,  1 Oct 2020 15:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601566539;
        bh=hWcPTYRRkDsrTk/JdA7D95U5Q29ZjQZzxHpnG1qUSyU=;
        h=From:To:Cc:Subject:Date:From;
        b=u4Thj7EP1JVqtSwPMYkQaCLnnvOe/bFA3L7ub8MgAPOQMchpKdqudmbZLSu/ExoE5
         Z1eVViE3U8AMXQjBrJtjo02XvO/XCyQTdWyzuQxPF0Q5Hb3i98iMq++PdmjhjtRZq1
         L/xiCDcGFjE/Rk+6Zk0j0oMqG/fpFMU/YhMbUrrs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.200
Date:   Thu,  1 Oct 2020 17:35:36 +0200
Message-Id: <160156653691120@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.200 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/sound/wm8994.txt               |   18 -
 Documentation/driver-api/libata.rst                              |    2 
 Makefile                                                         |    2 
 arch/arm64/kernel/cpufeature.c                                   |   12 
 arch/m68k/q40/config.c                                           |    1 
 arch/mips/include/asm/cpu-type.h                                 |    1 
 arch/powerpc/kernel/eeh.c                                        |    2 
 arch/powerpc/kernel/traps.c                                      |    6 
 arch/s390/kernel/setup.c                                         |    6 
 arch/x86/include/asm/nospec-branch.h                             |    4 
 arch/x86/include/asm/pkeys.h                                     |    5 
 arch/x86/kernel/apic/io_apic.c                                   |    1 
 arch/x86/kernel/fpu/xstate.c                                     |    9 
 arch/x86/kvm/mmutrace.h                                          |    2 
 arch/x86/kvm/x86.c                                               |   10 
 arch/x86/lib/usercopy_64.c                                       |    2 
 drivers/acpi/ec.c                                                |   16 -
 drivers/ata/acard-ahci.c                                         |    6 
 drivers/ata/libahci.c                                            |    6 
 drivers/ata/libata-core.c                                        |    9 
 drivers/ata/libata-sff.c                                         |   12 
 drivers/ata/pata_macio.c                                         |    6 
 drivers/ata/pata_pxa.c                                           |    8 
 drivers/ata/pdc_adma.c                                           |    7 
 drivers/ata/sata_fsl.c                                           |    4 
 drivers/ata/sata_inic162x.c                                      |    4 
 drivers/ata/sata_mv.c                                            |   34 +-
 drivers/ata/sata_nv.c                                            |   18 -
 drivers/ata/sata_promise.c                                       |    6 
 drivers/ata/sata_qstor.c                                         |    8 
 drivers/ata/sata_rcar.c                                          |    6 
 drivers/ata/sata_sil.c                                           |    8 
 drivers/ata/sata_sil24.c                                         |    6 
 drivers/ata/sata_sx4.c                                           |    6 
 drivers/atm/eni.c                                                |    2 
 drivers/char/tlclk.c                                             |   17 -
 drivers/char/tpm/tpm_ibmvtpm.c                                   |    9 
 drivers/char/tpm/tpm_ibmvtpm.h                                   |    1 
 drivers/clk/ti/adpll.c                                           |   11 
 drivers/clocksource/h8300_timer8.c                               |    2 
 drivers/cpufreq/powernv-cpufreq.c                                |   13 
 drivers/devfreq/tegra-devfreq.c                                  |    4 
 drivers/dma/tegra20-apb-dma.c                                    |    3 
 drivers/dma/xilinx/zynqmp_dma.c                                  |   24 +
 drivers/gpu/drm/amd/amdgpu/atom.c                                |    4 
 drivers/gpu/drm/gma500/cdv_intel_display.c                       |    2 
 drivers/gpu/drm/nouveau/nouveau_debugfs.c                        |    5 
 drivers/gpu/drm/omapdrm/dss/omapdss-boot-init.c                  |    4 
 drivers/gpu/drm/vc4/vc4_hdmi.c                                   |    1 
 drivers/i2c/i2c-core-base.c                                      |    2 
 drivers/infiniband/core/ucma.c                                   |    6 
 drivers/infiniband/hw/cxgb4/cm.c                                 |    4 
 drivers/infiniband/hw/i40iw/i40iw_cm.c                           |    2 
 drivers/infiniband/sw/rxe/rxe.c                                  |    2 
 drivers/infiniband/sw/rxe/rxe_qp.c                               |    7 
 drivers/md/bcache/bcache.h                                       |    1 
 drivers/md/bcache/btree.c                                        |   12 
 drivers/md/bcache/super.c                                        |    1 
 drivers/media/dvb-frontends/tda10071.c                           |    9 
 drivers/media/i2c/smiapp/smiapp-core.c                           |    3 
 drivers/media/platform/ti-vpe/cal.c                              |    6 
 drivers/media/usb/go7007/go7007-usb.c                            |    4 
 drivers/mfd/mfd-core.c                                           |   10 
 drivers/mmc/core/mmc.c                                           |    9 
 drivers/mtd/chips/cfi_cmdset_0002.c                              |    1 
 drivers/mtd/cmdlinepart.c                                        |   23 +
 drivers/mtd/nand/omap_elm.c                                      |    1 
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c                |   31 +-
 drivers/net/ethernet/intel/e1000/e1000_main.c                    |   18 +
 drivers/net/ethernet/qlogic/qed/qed_sriov.c                      |    1 
 drivers/net/geneve.c                                             |   37 +-
 drivers/net/ieee802154/adf7242.c                                 |    4 
 drivers/net/ieee802154/ca8210.c                                  |    1 
 drivers/net/phy/phy_device.c                                     |    3 
 drivers/net/wan/hdlc_ppp.c                                       |   16 -
 drivers/net/wireless/ath/ar5523/ar5523.c                         |    2 
 drivers/net/wireless/ath/ath10k/sdio.c                           |   18 +
 drivers/net/wireless/marvell/mwifiex/fw.h                        |    2 
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c               |    4 
 drivers/phy/qualcomm/phy-qcom-qmp.c                              |   18 -
 drivers/phy/samsung/phy-s5pv210-usb2.c                           |    4 
 drivers/power/supply/max17040_battery.c                          |    2 
 drivers/rapidio/devices/rio_mport_cdev.c                         |   14 -
 drivers/rtc/rtc-ds1374.c                                         |   15 -
 drivers/s390/block/dasd_fba.c                                    |    9 
 drivers/scsi/aacraid/aachba.c                                    |    8 
 drivers/scsi/aacraid/commsup.c                                   |    2 
 drivers/scsi/aacraid/linit.c                                     |   34 +-
 drivers/scsi/fnic/fnic_scsi.c                                    |    3 
 drivers/scsi/libfc/fc_rport.c                                    |   13 
 drivers/scsi/lpfc/lpfc_ct.c                                      |  137 +++++-----
 drivers/scsi/lpfc/lpfc_hw.h                                      |   36 +-
 drivers/scsi/lpfc/lpfc_sli.c                                     |    4 
 drivers/scsi/qedi/qedi_iscsi.c                                   |    3 
 drivers/staging/media/imx/imx-media-capture.c                    |    2 
 drivers/staging/rtl8188eu/core/rtw_recv.c                        |   19 -
 drivers/tty/serial/8250/8250_core.c                              |   11 
 drivers/tty/serial/8250/8250_omap.c                              |    8 
 drivers/tty/serial/8250/8250_port.c                              |   16 +
 drivers/tty/serial/samsung.c                                     |    8 
 drivers/tty/serial/xilinx_uartps.c                               |    8 
 drivers/tty/vcc.c                                                |    1 
 drivers/usb/dwc3/gadget.c                                        |    2 
 drivers/usb/host/ehci-mv.c                                       |    8 
 drivers/vfio/pci/vfio_pci.c                                      |   13 
 fs/block_dev.c                                                   |   10 
 fs/btrfs/extent-tree.c                                           |    2 
 fs/btrfs/inode.c                                                 |   23 -
 fs/ceph/caps.c                                                   |   14 -
 fs/cifs/cifsglob.h                                               |    9 
 fs/cifs/file.c                                                   |   21 +
 fs/cifs/misc.c                                                   |   17 -
 fs/cifs/smb1ops.c                                                |    8 
 fs/cifs/smb2misc.c                                               |   32 --
 fs/cifs/smb2ops.c                                                |   44 ++-
 fs/cifs/smb2pdu.h                                                |    2 
 fs/ext4/inode.c                                                  |    2 
 fs/fuse/dev.c                                                    |    1 
 fs/gfs2/inode.c                                                  |   13 
 fs/nfs/pagelist.c                                                |   67 +++-
 fs/nfs/write.c                                                   |   10 
 fs/ubifs/io.c                                                    |   16 +
 fs/xfs/libxfs/xfs_attr_leaf.c                                    |    4 
 fs/xfs/libxfs/xfs_dir2_node.c                                    |    1 
 include/linux/debugfs.h                                          |    5 
 include/linux/libata.h                                           |   13 
 include/linux/mmc/card.h                                         |    2 
 include/linux/nfs_page.h                                         |    2 
 include/linux/seqlock.h                                          |   11 
 include/linux/skbuff.h                                           |   21 +
 kernel/audit_watch.c                                             |    2 
 kernel/bpf/hashtab.c                                             |    8 
 kernel/kprobes.c                                                 |   14 -
 kernel/printk/printk.c                                           |    3 
 kernel/sys.c                                                     |    4 
 kernel/time/timekeeping.c                                        |    3 
 kernel/trace/trace.c                                             |    5 
 kernel/trace/trace_entries.h                                     |    2 
 kernel/trace/trace_events.c                                      |    2 
 lib/string.c                                                     |   24 +
 mm/filemap.c                                                     |    8 
 mm/huge_memory.c                                                 |   40 +-
 mm/kmemleak.c                                                    |    2 
 mm/memory.c                                                      |  121 +++++++-
 mm/mmap.c                                                        |    2 
 mm/pagewalk.c                                                    |    4 
 mm/swap_state.c                                                  |    5 
 mm/swapfile.c                                                    |    2 
 mm/vmscan.c                                                      |   45 +--
 net/atm/lec.c                                                    |    6 
 net/batman-adv/bridge_loop_avoidance.c                           |   42 ++-
 net/batman-adv/bridge_loop_avoidance.h                           |    4 
 net/batman-adv/routing.c                                         |    4 
 net/batman-adv/soft-interface.c                                  |    6 
 net/bluetooth/hci_event.c                                        |   25 +
 net/bluetooth/l2cap_core.c                                       |   29 +-
 net/bluetooth/l2cap_sock.c                                       |   18 +
 net/core/neighbour.c                                             |    1 
 net/ipv4/ip_output.c                                             |    3 
 net/ipv4/route.c                                                 |   12 
 net/ipv6/Kconfig                                                 |    1 
 net/key/af_key.c                                                 |    7 
 net/mac802154/tx.c                                               |    8 
 net/sunrpc/svc_xprt.c                                            |   19 +
 net/sunrpc/xprtrdma/svc_rdma_backchannel.c                       |    1 
 net/tipc/msg.c                                                   |    3 
 net/tipc/socket.c                                                |    5 
 net/unix/af_unix.c                                               |   11 
 security/selinux/selinuxfs.c                                     |    1 
 sound/hda/hdac_bus.c                                             |    4 
 sound/pci/asihpi/hpioctl.c                                       |    4 
 sound/pci/hda/hda_controller.c                                   |   11 
 sound/pci/hda/patch_realtek.c                                    |    6 
 sound/soc/kirkwood/kirkwood-dma.c                                |    2 
 sound/usb/midi.c                                                 |   29 +-
 sound/usb/quirks.c                                               |    7 
 tools/gpio/gpio-hammer.c                                         |   17 +
 tools/objtool/check.c                                            |    2 
 tools/perf/tests/shell/lib/probe_vfs_getname.sh                  |    2 
 tools/perf/util/cpumap.c                                         |   10 
 tools/perf/util/sort.c                                           |    2 
 tools/perf/util/symbol-elf.c                                     |    7 
 tools/power/x86/intel_pstate_tracer/intel_pstate_tracer.py       |   22 -
 tools/testing/selftests/ftrace/test.d/ftrace/func-filter-glob.tc |    2 
 tools/testing/selftests/x86/syscall_nt.c                         |    1 
 virt/kvm/kvm_main.c                                              |   22 -
 186 files changed, 1319 insertions(+), 676 deletions(-)

Adrian Hunter (1):
      perf kcore_copy: Fix module map when there are no modules loaded

Alain Michaud (1):
      Bluetooth: guard against controllers sending zero'd events

Alex Williamson (1):
      vfio/pci: Clear error and request eventfd ctx after releasing

Alexander Duyck (1):
      e1000: Do not perform reset in reset_task if we are already down

Alexandre Belloni (1):
      rtc: ds1374: fix possible race condition

Andreas Steinmetz (1):
      ALSA: usb-audio: Fix case when USB MIDI interface has more than one extra endpoint descriptor

Andy Lutomirski (1):
      selftests/x86/syscall_nt: Clear weird flags after each test

Anshuman Khandual (1):
      arm64/cpufeature: Drop TraceFilt feature exposure from ID_DFR0 register

Balsundar P (1):
      scsi: aacraid: fix illegal IO beyond last LBA

Bart Van Assche (1):
      RDMA/rxe: Fix configuration of atomic queue pair attributes

Bob Peterson (1):
      gfs2: clean up iopen glock mess in gfs2_create_inode

Boris Brezillon (1):
      mtd: parser: cmdline: Support MTD names containing one or more colons

Bradley Bolen (1):
      mmc: core: Fix size overflow for mmc partitions

Brian Foster (1):
      xfs: fix attr leaf header freemap.size underflow

Christophe JAILLET (3):
      RDMA/iw_cgxb4: Fix an error handling path in 'c4iw_connect()'
      perf cpumap: Fix snprintf overflow check
      SUNRPC: Fix a potential buffer overflow in 'svc_print_xprts()'

Chuck Lever (1):
      svcrdma: Fix leak of transport addresses

Colin Ian King (2):
      media: tda10071: fix unsigned sign extension overflow
      USB: EHCI: ehci-mv: fix less than zero comparison of an unsigned int

Cong Wang (1):
      atm: fix a memory leak of vcc->user_back

Dan Carpenter (2):
      hdlc_ppp: add range checks in ppp_cp_parse_cr()
      media: staging/imx: Missing assignment in imx_media_capture_device_register()

Darrick J. Wong (1):
      xfs: don't ever return a stale pointer from __xfs_dir3_free_read

Dave Hansen (1):
      x86/pkeys: Add check for pkey "overflow"

David Ahern (1):
      ipv4: Update exception handling for multipath routes via same device

David Sterba (1):
      btrfs: don't force read-only after error in drop snapshot

Dinghao Liu (2):
      drm/nouveau/debugfs: fix runtime pm imbalance on error
      mtd: rawnand: omap_elm: Fix runtime PM imbalance on error

Divya Indi (1):
      tracing: Adding NULL checks for trace_array descriptor pointer

Dmitry Bogdanov (1):
      net: qed: RDMA personality shouldn't fail VF load

Dmitry Osipenko (2):
      PM / devfreq: tegra30: Fix integer overflow on CPU's freq max out
      dmaengine: tegra-apb: Prevent race conditions on channel's freeing

Doug Smythies (1):
      tools/power/x86/intel_pstate_tracer: changes for python 3 compatibility

Douglas Anderson (1):
      bdev: Reduce time holding bd_mutex in sync in blkdev_close()

Eric Dumazet (2):
      net: add __must_check to skb_put_padto()
      mac802154: tx: fix use-after-free

Florian Fainelli (1):
      net: phy: Avoid NPD upon phy_detach() when driver is unbound

Fuqian Huang (1):
      m68k: q40: Fix info-leak in rtc_ioctl

Gabriel Ravier (1):
      tools: gpio-hammer: Avoid potential overflow in main

Gao Xiang (1):
      mm, THP, swap: fix allocating cluster for swapfile by mistake

Greg Kroah-Hartman (1):
      Linux 4.14.200

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

Hui Wang (1):
      ALSA: hda/realtek - Couldn't detect Mic if booting with headset plugged

Ilya Leoshkevich (1):
      s390/init: add missing __init annotations

Ivan Safonov (1):
      staging:r8188eu: avoid skb_clone for amsdu to msdu conversion

Jaewon Kim (1):
      mm/mmap.c: initialize align_offset explicitly for vm_unmapped_area

James Smart (2):
      scsi: lpfc: Fix RQ buffer leakage when no IOCBs available
      scsi: lpfc: Fix coverity errors in fmdi attribute handling

Jan Höppner (1):
      s390/dasd: Fix zero write for FBA devices

Javed Hasan (2):
      scsi: libfc: Handling of extra kref
      scsi: libfc: Skip additional kref updating work event

Jeff Layton (1):
      ceph: fix potential race in ceph_check_caps

Jia He (1):
      mm: fix double page fault on arm64 if PTE_AF is cleared

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

Jonathan Bakker (3):
      power: supply: max17040: Correct voltage reading
      phy: samsung: s5pv210-usb2: Add delay after reset
      tty: serial: samsung: Correct clock selection logic

Josef Bacik (1):
      tracing: Set kernel_stack's caller size properly

Josh Poimboeuf (1):
      objtool: Fix noreturn detection for ignored functions

Kangjie Lu (1):
      gma/gma500: fix a memory disclosure bug due to uninitialized bytes

Kirill A. Shutemov (1):
      mm: avoid data corruption on CoW fault into PFN-mapped VMA

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

Liu Jian (1):
      ieee802154: fix one possible memleak in ca8210_dev_com_init

Liu Song (1):
      ubifs: Fix out-of-bounds memory access caused by abnormal value of node_len

Lukas Wunner (1):
      serial: 8250: Avoid error message on reprobe

Madhuparna Bhowmik (2):
      drivers: char: tlclk.c: Avoid data race between init and interrupt handler
      rapidio: avoid data race between file operation callbacks and mport_cdev_add().

Manish Mandlik (1):
      Bluetooth: Fix refcount use-after-free issue

Marco Elver (1):
      seqlock: Require WRITE_ONCE surrounding raw_seqcount_barrier

Marek Szyprowski (1):
      drm/vc4/vc4_hdmi: fill ASoC card owner

Mark Gray (1):
      geneve: add transport ports in route lookup for geneve

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

Mikulas Patocka (1):
      arch/x86/lib/usercopy_64.c: fix __copy_user_flushcache() cache writeback

Mohan Kumar (1):
      ALSA: hda: Clear RIRB status before reading WP

Muchun Song (1):
      kprobes: fix kill kprobe which has been marked as gone

Nathan Chancellor (2):
      tracing: Use address-of operator on section symbols
      mm/kmemleak.c: use address-of operator on section symbols

Necip Fazil Yildiran (1):
      net: ipv6: fix kconfig dependency warning for IPV6_SEG6_HMAC

Nicholas Piggin (1):
      powerpc/traps: Make unrecoverable NMIs die instead of panic

Nick Desaulniers (1):
      lib/string.c: implement stpcpy

Nikhil Devshatwar (1):
      media: ti-vpe: cal: Restrict DMA to avoid memory corruption

Nilesh Javali (1):
      scsi: qedi: Fix termination timeouts in session logout

Oliver O'Halloran (1):
      powerpc/eeh: Only dump stack once if an MMIO loop is detected

Pan Bian (2):
      scsi: fnic: fix use after free
      RDMA/i40iw: Fix potential use after free

Paolo Bonzini (1):
      KVM: x86: fix incorrect comparison in trace event

Pavel Shilovsky (1):
      CIFS: Properly process SMB3 lease breaks

Peter Ujfalusi (1):
      serial: 8250_omap: Fix sleeping function called from invalid context during probe

Pratik Rajesh Sampat (1):
      cpufreq: powernv: Fix frame-size-overflow in powernv_cpufreq_work_fn

Qian Cai (4):
      skbuff: fix a data race in skb_queue_len()
      mm/vmscan.c: fix data races using kswapd_classzone_idx
      vfio/pci: fix memory leaks of eventfd ctx
      mm/swap_state: fix a data race in swapin_nr_pages

Qiujun Huang (1):
      ext4: fix a data race at inode->i_disksize

Qu Wenruo (1):
      btrfs: qgroup: fix data leak caused by race between writeback and truncate

Rafael J. Wysocki (1):
      ACPI: EC: Reference count query handlers under lock

Ralph Campbell (1):
      mm/thp: fix __split_huge_pmd_locked() for migration PMD

Raviteja Narayanam (1):
      serial: uartps: Wait for tx_empty in console setup

Russell King (1):
      ASoC: kirkwood: fix IRQ error handling

Rustam Kovhaev (1):
      KVM: fix memory leak in kvm_io_bus_unregister_dev()

Sagar Biradar (1):
      scsi: aacraid: Disabling TM path and only processing IOP reset

Sakari Ailus (1):
      media: smiapp: Fix error handling at NVM reading

Shamir Rabinovitch (1):
      RDMA/ucma: ucma_context reference leak in error path

Shreyas Joshi (1):
      printk: handle blank console arguments passed in.

Sivaprakash Murugesan (1):
      phy: qcom-qmp: Use correct values for ipq8074 PCIe Gen2 PHY init

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

Sven Schnelle (1):
      selftests/ftrace: fix glob selftest

Takashi Iwai (2):
      media: go7007: Fix URB type for interrupt handling
      ALSA: hda: Fix potential race in unsol event handler

Tang Bin (1):
      USB: EHCI: ehci-mv: fix error handling in mv_ehci_probe()

Tetsuo Handa (1):
      tipc: fix shutdown() of connection oriented socket

Thomas Gleixner (3):
      x86/ioapic: Unbreak check_timer()
      bpf: Remove recursion prevention from rcu free callback
      x86/speculation/mds: Mark mds_user_clear_cpu_buffers() __always_inline

Thomas Richter (1):
      perf test: Fix test trace+probe_vfs_getname.sh on s390

Tianjia Zhang (1):
      clocksource/drivers/h8300_timer8: Fix wrong return value in h8300_8timer_init()

Tom Rix (2):
      ieee802154/adf7242: check status of adf7242_read_reg
      ALSA: asihpi: fix iounmap in error handler

Trond Myklebust (1):
      NFS: Fix races nfs_page_group_destroy() vs nfs_destroy_unlinked_subrequests()

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

Wei Yongjun (1):
      sparc64: vcc: Fix error return code in vcc_probe()

Wen Gong (1):
      ath10k: use kzalloc to read for ath10k_sdio_hif_diag_read

Wen Yang (2):
      drm/omap: fix possible object reference leak
      timekeeping: Prevent 32bit truncation in scale64_check_overflow()

Will Deacon (1):
      arm64: cpufeature: Relax checks for AArch32 support at EL[0-2]

Xianting Tian (1):
      mm/filemap.c: clear page error before actual read

Xie XiuQi (1):
      perf util: Fix memory leak of prefix_if_not_in

Xin Long (1):
      tipc: use skb_unshare() instead in tipc_buf_append()

Yu Chen (1):
      usb: dwc3: Increase timeout for CmdAct cleared by device controller

Zeng Tao (1):
      vfio/pci: fix racy on error and request eventfd ctx

Zhang Xiaoxu (1):
      cifs: Fix double add page to memcg when cifs_readpages

Zhu Yanjun (1):
      RDMA/rxe: Set sys_image_guid to be aligned with HW IB devices

Zhuang Yanying (1):
      KVM: fix overflow of zero page refcount with ksm running


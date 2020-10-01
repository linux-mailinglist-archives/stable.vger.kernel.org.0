Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB63B2802D4
	for <lists+stable@lfdr.de>; Thu,  1 Oct 2020 17:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732119AbgJAPf3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Oct 2020 11:35:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:49018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731885AbgJAPf3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Oct 2020 11:35:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 361702074B;
        Thu,  1 Oct 2020 15:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601566527;
        bh=59nT4oYmyhfJgHWqT+CComLHn+Pbv4RnmFFnWNhpOCI=;
        h=From:To:Cc:Subject:Date:From;
        b=VEgHm3zYu5u3X/O+8D1re4qdtvTIHCKzLnuhd7lROHqRqf78T3ghth64q/jRbFr6/
         6nVV8YtCrE77A/WZkCpOCBHKRXbX2knwAkCJA65m1g0Fiud739yHMB245zHYx0hmbM
         xCaVxDNPwaLwJjlN6UCKEi89IwQQN8spDX8BElJY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.4.238
Date:   Thu,  1 Oct 2020 17:35:27 +0200
Message-Id: <160156652710911@kroah.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.238 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/DocBook/libata.tmpl                  |    2 -
 Documentation/devicetree/bindings/sound/wm8994.txt |   18 +++++++----
 Makefile                                           |    2 -
 arch/m68k/q40/config.c                             |    1 
 arch/mips/include/asm/cpu-type.h                   |    1 
 arch/s390/kernel/setup.c                           |    6 +--
 arch/x86/include/asm/nospec-branch.h               |    4 +-
 arch/x86/kvm/x86.c                                 |   10 ++++--
 drivers/acpi/ec.c                                  |   16 ++-------
 drivers/ata/acard-ahci.c                           |    6 ++-
 drivers/ata/libahci.c                              |    6 ++-
 drivers/ata/libata-core.c                          |    9 ++++-
 drivers/ata/libata-sff.c                           |   12 ++++---
 drivers/ata/pata_macio.c                           |    6 ++-
 drivers/ata/pata_pxa.c                             |    8 +++-
 drivers/ata/pdc_adma.c                             |    7 ++--
 drivers/ata/sata_fsl.c                             |    4 +-
 drivers/ata/sata_inic162x.c                        |    4 +-
 drivers/ata/sata_mv.c                              |   34 +++++++++++----------
 drivers/ata/sata_nv.c                              |   18 ++++++-----
 drivers/ata/sata_promise.c                         |    6 ++-
 drivers/ata/sata_qstor.c                           |    8 +++-
 drivers/ata/sata_rcar.c                            |    6 ++-
 drivers/ata/sata_sil.c                             |    8 +++-
 drivers/ata/sata_sil24.c                           |    6 ++-
 drivers/ata/sata_sx4.c                             |    6 ++-
 drivers/atm/eni.c                                  |    2 -
 drivers/char/tlclk.c                               |   17 ++++++----
 drivers/char/tpm/tpm_ibmvtpm.c                     |    9 +++++
 drivers/char/tpm/tpm_ibmvtpm.h                     |    1 
 drivers/devfreq/tegra-devfreq.c                    |    4 +-
 drivers/dma/tegra20-apb-dma.c                      |    3 -
 drivers/gpu/drm/amd/amdgpu/atom.c                  |    4 +-
 drivers/gpu/drm/gma500/cdv_intel_display.c         |    2 +
 drivers/infiniband/core/ucma.c                     |    6 +--
 drivers/md/bcache/bcache.h                         |    1 
 drivers/md/bcache/btree.c                          |   12 ++++---
 drivers/md/bcache/super.c                          |    1 
 drivers/media/dvb-frontends/tda10071.c             |    9 +++--
 drivers/media/usb/go7007/go7007-usb.c              |    4 +-
 drivers/mfd/mfd-core.c                             |   10 ++++++
 drivers/mtd/chips/cfi_cmdset_0002.c                |    1 
 drivers/mtd/cmdlinepart.c                          |   23 ++++++++++++--
 drivers/mtd/nand/omap_elm.c                        |    1 
 drivers/net/ethernet/intel/e1000/e1000_main.c      |   18 ++++++++---
 drivers/net/wan/hdlc_ppp.c                         |   16 ++++++---
 drivers/net/wireless/ath/ar5523/ar5523.c           |    2 +
 drivers/net/wireless/mwifiex/fw.h                  |    2 -
 drivers/net/wireless/mwifiex/sta_cmdresp.c         |    4 +-
 drivers/phy/phy-s5pv210-usb2.c                     |    4 ++
 drivers/scsi/aacraid/aachba.c                      |    8 ++--
 drivers/scsi/lpfc/lpfc_sli.c                       |    4 ++
 drivers/tty/serial/8250/8250_core.c                |   11 +++++-
 drivers/tty/serial/8250/8250_omap.c                |    2 -
 drivers/tty/serial/samsung.c                       |    8 ++--
 drivers/tty/vt/vt.c                                |    2 -
 drivers/usb/host/ehci-mv.c                         |    8 +---
 drivers/vfio/pci/vfio_pci.c                        |   13 ++++++++
 drivers/video/fbdev/omap2/dss/omapdss-boot-init.c  |    4 +-
 fs/block_dev.c                                     |   10 ++++++
 fs/ceph/caps.c                                     |   14 ++++++++
 fs/fuse/dev.c                                      |    1 
 fs/ubifs/io.c                                      |   16 ++++++++-
 fs/xfs/libxfs/xfs_attr_leaf.c                      |    4 +-
 include/linux/libata.h                             |   13 ++++----
 include/linux/mtd/map.h                            |    2 -
 include/linux/seqlock.h                            |   11 +++++-
 include/linux/skbuff.h                             |   16 ++++++++-
 kernel/audit_watch.c                               |    2 -
 kernel/kprobes.c                                   |   14 ++++++--
 kernel/printk/printk.c                             |    3 +
 kernel/sys.c                                       |    4 +-
 kernel/trace/ftrace.c                              |    9 +++--
 kernel/trace/trace.c                               |    5 ++-
 kernel/trace/trace_entries.h                       |    2 -
 kernel/trace/trace_events.c                        |    2 +
 lib/string.c                                       |   24 ++++++++++++++
 mm/filemap.c                                       |    8 ++++
 mm/mmap.c                                          |    2 +
 mm/pagewalk.c                                      |    4 +-
 net/atm/lec.c                                      |    6 +++
 net/batman-adv/bridge_loop_avoidance.c             |    7 ++--
 net/batman-adv/routing.c                           |    4 ++
 net/bluetooth/hci_event.c                          |   25 ++++++++++++++-
 net/bluetooth/l2cap_core.c                         |   29 ++++++++++-------
 net/bluetooth/l2cap_sock.c                         |   18 +++++++++--
 net/core/neighbour.c                               |    1 
 net/ipv4/ip_output.c                               |    3 +
 net/ipv4/route.c                                   |    1 
 net/key/af_key.c                                   |    7 ++++
 net/sunrpc/svc_xprt.c                              |   19 ++++++++---
 net/tipc/msg.c                                     |    3 +
 net/unix/af_unix.c                                 |   11 +++++-
 security/selinux/selinuxfs.c                       |    1 
 sound/hda/hdac_bus.c                               |    4 ++
 sound/pci/asihpi/hpioctl.c                         |    4 +-
 sound/soc/kirkwood/kirkwood-dma.c                  |    2 -
 sound/usb/midi.c                                   |   29 ++++++++++++++---
 tools/perf/util/symbol-elf.c                       |    7 ++++
 virt/kvm/kvm_main.c                                |   21 +++++++-----
 100 files changed, 580 insertions(+), 218 deletions(-)

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

Balsundar P (1):
      scsi: aacraid: fix illegal IO beyond last LBA

Ben Hutchings (1):
      mtd: Fix comparison in map_word_andequal()

Boris Brezillon (1):
      mtd: parser: cmdline: Support MTD names containing one or more colons

Brian Foster (1):
      xfs: fix attr leaf header freemap.size underflow

Chengming Zhou (1):
      ftrace: Setup correct FTRACE_FL_REGS flags for module

Christophe JAILLET (1):
      SUNRPC: Fix a potential buffer overflow in 'svc_print_xprts()'

Colin Ian King (2):
      media: tda10071: fix unsigned sign extension overflow
      USB: EHCI: ehci-mv: fix less than zero comparison of an unsigned int

Cong Wang (1):
      atm: fix a memory leak of vcc->user_back

Dan Carpenter (1):
      hdlc_ppp: add range checks in ppp_cp_parse_cr()

Dinghao Liu (1):
      mtd: rawnand: omap_elm: Fix runtime PM imbalance on error

Divya Indi (1):
      tracing: Adding NULL checks for trace_array descriptor pointer

Dmitry Osipenko (2):
      PM / devfreq: tegra30: Fix integer overflow on CPU's freq max out
      dmaengine: tegra-apb: Prevent race conditions on channel's freeing

Douglas Anderson (1):
      bdev: Reduce time holding bd_mutex in sync in blkdev_close()

Eric Dumazet (1):
      net: add __must_check to skb_put_padto()

Fuqian Huang (1):
      m68k: q40: Fix info-leak in rtc_ioctl

Greg Kroah-Hartman (1):
      Linux 4.4.238

Guoju Fang (1):
      bcache: fix a lost wake-up problem caused by mca_cannibalize_lock

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

James Smart (1):
      scsi: lpfc: Fix RQ buffer leakage when no IOCBs available

Jeff Layton (1):
      ceph: fix potential race in ceph_check_caps

Jing Xiangfeng (1):
      atm: eni: fix the missed pci_disable_device() for eni_init_one()

Jiri Slaby (4):
      tty: vt, consw->con_scrolldelta cleanup
      ata: define AC_ERR_OK
      ata: make qc_prep return ata_completion_errors
      ata: sata_mv, avoid trigerrable BUG_ON

Joe Perches (1):
      kernel/sys.c: avoid copying possible padding bytes in copy_to_user

John Clements (1):
      drm/amdgpu: increase atombios cmd timeout

Jonathan Bakker (2):
      phy: samsung: s5pv210-usb2: Add delay after reset
      tty: serial: samsung: Correct clock selection logic

Josef Bacik (1):
      tracing: Set kernel_stack's caller size properly

Kangjie Lu (1):
      gma/gma500: fix a memory disclosure bug due to uninitialized bytes

Krzysztof Kozlowski (1):
      dt-bindings: sound: wm8994: Correct required supplies based on actual implementaion

Lee Jones (1):
      mfd: mfd-core: Protect against NULL call-back function pointer

Linus Lüssing (2):
      batman-adv: bla: fix type misuse for backbone_gw hash indexing
      batman-adv: mcast/TT: fix wrongly dropped or rerouted packets

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

Maximilian Luz (1):
      mwifiex: Increase AES key storage size to 256 bits

Mert Dirik (1):
      ar5523: Add USB ID of SMCWUSBT-G2 wireless adapter

Miklos Szeredi (1):
      fuse: don't check refcount after stealing page

Muchun Song (1):
      kprobes: fix kill kprobe which has been marked as gone

Nathan Chancellor (1):
      tracing: Use address-of operator on section symbols

Nick Desaulniers (1):
      lib/string.c: implement stpcpy

Peter Ujfalusi (1):
      serial: 8250_omap: Fix sleeping function called from invalid context during probe

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

Steve Grubb (1):
      audit: CONFIG_CHANGE don't log internal bookkeeping as an event

Steve Rutherford (1):
      KVM: Remove CREATE_IRQCHIP/SET_PIT2 race

Steven Price (1):
      mm: pagewalk: fix termination condition in walk_pte_range()

Takashi Iwai (2):
      media: go7007: Fix URB type for interrupt handling
      ALSA: hda: Fix potential race in unsol event handler

Tang Bin (1):
      USB: EHCI: ehci-mv: fix error handling in mv_ehci_probe()

Thomas Gleixner (1):
      x86/speculation/mds: Mark mds_user_clear_cpu_buffers() __always_inline

Tom Rix (1):
      ALSA: asihpi: fix iounmap in error handler

Vasily Averin (3):
      neigh_stat_seq_next() should increase position index
      rt_cpu_seq_next should increase position index
      selinux: sel_avc_get_stat_idx should increase position index

Wei Li (1):
      MIPS: Add the missing 'CPU_1074K' into __get_cpu_type()

Wei Wang (1):
      ip: fix tos reflection in ack and reset packets

Wen Yang (1):
      drm/omap: fix possible object reference leak

Xianting Tian (1):
      mm/filemap.c: clear page error before actual read

Xin Long (1):
      tipc: use skb_unshare() instead in tipc_buf_append()

Zeng Tao (1):
      vfio/pci: fix racy on error and request eventfd ctx


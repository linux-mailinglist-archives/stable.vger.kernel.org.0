Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAF2046CEE4
	for <lists+stable@lfdr.de>; Wed,  8 Dec 2021 09:28:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240542AbhLHIcB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Dec 2021 03:32:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244795AbhLHIbt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Dec 2021 03:31:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76F56C0617A1;
        Wed,  8 Dec 2021 00:28:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1DA39B81FDA;
        Wed,  8 Dec 2021 08:28:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34C0CC00446;
        Wed,  8 Dec 2021 08:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638952094;
        bh=lumudLlEmR6M0HH8TRJMj4IJDdO9o1A3sqpkN1U1s7g=;
        h=From:To:Cc:Subject:Date:From;
        b=aWCVAC8rmsDLRtb9WjY+B3y80L4bFa6e7pYbE1QRZuSx7QNeSaKrJogw7zBLgPkd0
         P3+I57hRkfVUMr/Q2F1A6ft7rqXkOjGsD1mMFe11BDk0ULQFyE6ZAISBQUYoCL/G25
         PVUGGBbn7kxx/uYlzuWOmYN7EX/YoTYmLZ79pTRw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.257
Date:   Wed,  8 Dec 2021 09:27:56 +0100
Message-Id: <163895207666254@kroah.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.257 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/pinctrl/marvell,armada-37xx-pinctrl.txt |   26 
 Documentation/networking/ipvs-sysctl.txt                                  |    3 
 Makefile                                                                  |    2 
 arch/arm/boot/dts/bcm5301x.dtsi                                           |    4 
 arch/arm/include/asm/tlb.h                                                |    8 
 arch/arm/mach-socfpga/core.h                                              |    2 
 arch/arm/mach-socfpga/platsmp.c                                           |    8 
 arch/arm64/boot/dts/marvell/armada-3720-db.dts                            |    3 
 arch/arm64/boot/dts/marvell/armada-3720-espressobin.dts                   |    3 
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi                              |    9 
 arch/ia64/include/asm/tlb.h                                               |   10 
 arch/mips/Kconfig                                                         |    2 
 arch/parisc/Makefile                                                      |    5 
 arch/parisc/install.sh                                                    |    1 
 arch/parisc/kernel/time.c                                                 |   24 
 arch/s390/include/asm/tlb.h                                               |   14 
 arch/s390/kernel/setup.c                                                  |    3 
 arch/s390/mm/pgtable.c                                                    |   13 
 arch/sh/include/asm/tlb.h                                                 |   10 
 arch/um/include/asm/tlb.h                                                 |   12 
 arch/x86/realmode/init.c                                                  |   12 
 drivers/android/binder.c                                                  |    2 
 drivers/ata/sata_fsl.c                                                    |   20 
 drivers/block/xen-blkfront.c                                              |  126 +-
 drivers/gpu/drm/vc4/vc4_bo.c                                              |    2 
 drivers/hid/wacom_wac.c                                                   |    8 
 drivers/hid/wacom_wac.h                                                   |    1 
 drivers/media/cec/cec-adap.c                                              |    1 
 drivers/net/ethernet/dec/tulip/de4x5.c                                    |   34 
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c                        |    4 
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c                            |    9 
 drivers/net/ethernet/natsemi/xtsonic.c                                    |    2 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c                       |   10 
 drivers/net/usb/lan78xx.c                                                 |    2 
 drivers/net/vrf.c                                                         |    2 
 drivers/net/xen-netfront.c                                                |  257 +++--
 drivers/pci/host/pci-aardvark.c                                           |  463 ++++++++--
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c                               |   28 
 drivers/platform/x86/thinkpad_acpi.c                                      |   12 
 drivers/scsi/mpt3sas/mpt3sas_scsih.c                                      |    2 
 drivers/scsi/scsi_transport_iscsi.c                                       |    6 
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c                              |    3 
 drivers/staging/typec/tcpm.c                                              |    4 
 drivers/thermal/thermal_core.c                                            |    2 
 drivers/tty/hvc/hvc_xen.c                                                 |   17 
 drivers/tty/serial/amba-pl011.c                                           |    1 
 drivers/tty/serial/msm_serial.c                                           |    3 
 drivers/tty/serial/serial_core.c                                          |   13 
 drivers/usb/core/hub.c                                                    |   23 
 drivers/usb/host/xhci-ring.c                                              |   21 
 drivers/usb/serial/option.c                                               |    5 
 drivers/vhost/vsock.c                                                     |    2 
 drivers/video/console/vgacon.c                                            |   14 
 drivers/xen/xenbus/xenbus_probe.c                                         |   27 
 fs/btrfs/disk-io.c                                                        |   14 
 fs/file.c                                                                 |   19 
 fs/file_table.c                                                           |    9 
 fs/fuse/dev.c                                                             |   14 
 fs/nfs/nfs42proc.c                                                        |    5 
 fs/nfs/nfs42xdr.c                                                         |    3 
 fs/proc/vmcore.c                                                          |   15 
 include/asm-generic/tlb.h                                                 |    2 
 include/linux/file.h                                                      |    2 
 include/linux/fs.h                                                        |    4 
 include/linux/ipc_namespace.h                                             |   15 
 include/linux/kprobes.h                                                   |    2 
 include/linux/sched/task.h                                                |    2 
 include/linux/shm.h                                                       |   13 
 include/linux/siphash.h                                                   |   14 
 include/net/nfc/nci_core.h                                                |    1 
 include/net/nl802154.h                                                    |    7 
 include/uapi/linux/pci_regs.h                                             |    5 
 include/xen/interface/io/ring.h                                           |  293 +++---
 ipc/shm.c                                                                 |  176 ++-
 ipc/util.c                                                                |    6 
 kernel/kprobes.c                                                          |    3 
 kernel/power/hibernate.c                                                  |    6 
 kernel/trace/trace.h                                                      |   24 
 kernel/trace/trace_events.c                                               |    7 
 lib/siphash.c                                                             |   12 
 mm/hugetlb.c                                                              |   72 +
 mm/memory.c                                                               |   10 
 net/ipv4/devinet.c                                                        |    2 
 net/ipv4/tcp_cubic.c                                                      |    5 
 net/ipv6/ip6_output.c                                                     |    2 
 net/mpls/af_mpls.c                                                        |   68 +
 net/netfilter/ipvs/ip_vs_core.c                                           |    8 
 net/nfc/nci/core.c                                                        |   19 
 net/rds/tcp.c                                                             |    2 
 net/smc/af_smc.c                                                          |    8 
 net/smc/smc_close.c                                                       |   10 
 sound/pci/ctxfi/ctamixer.c                                                |   14 
 sound/pci/ctxfi/ctdaio.c                                                  |   16 
 sound/pci/ctxfi/ctresource.c                                              |    7 
 sound/pci/ctxfi/ctresource.h                                              |    4 
 sound/pci/ctxfi/ctsrc.c                                                   |    7 
 sound/soc/soc-topology.c                                                  |    3 
 tools/perf/ui/hist.c                                                      |   28 
 tools/perf/util/hist.h                                                    |    1 
 99 files changed, 1590 insertions(+), 669 deletions(-)

Alexander Aring (1):
      net: ieee802154: handle iftypes as u32

Alexander Mikhalitsyn (2):
      shm: extend forced shm destroy to support objects from several IPC nses
      ipc: WARN if trying to remove ipc object which is absent

Arnd Bergmann (1):
      siphash: use _unaligned version by default

Badhri Jagan Sridharan (1):
      usb: typec: tcpm: Wait in SNK_DEBOUNCED until disconnect

Baokun Li (2):
      sata_fsl: fix UAF in sata_fsl_port_stop when rmmod sata_fsl
      sata_fsl: fix warning in remove_proc_entry when rmmod sata_fsl

Benjamin Coddington (1):
      NFSv42: Fix pagecache invalidation after COPY/CLONE

Benjamin Poirier (1):
      net: mpls: Fix notifications when deleting a device

Dan Carpenter (2):
      staging: rtl8192e: Fix use after free in _rtl92e_pci_disconnect()
      drm/vc4: fix error code in vc4_create_object()

Daniele Palmas (1):
      USB: serial: option: add Telit LE910S1 0x9200 composition

David Hildenbrand (2):
      s390/mm: validate VMA in PGSTE manipulation functions
      proc/vmcore: fix clearing user buffer by properly using clear_user()

Eric Dumazet (2):
      ipv6: fix typos in __ip6_finish_output()
      tcp_cubic: fix spurious Hystart ACK train detections for not-cwnd-limited flows

Evan Wang (1):
      PCI: aardvark: Remove PCIe outbound window configuration

Florian Fainelli (2):
      ARM: dts: BCM5301X: Fix I2C controller interrupt
      ARM: dts: BCM5301X: Add interrupt properties to GPIO node

Frederick Lawler (1):
      PCI: Add PCI_EXP_LNKCTL2_TLS* macros

Greg Kroah-Hartman (1):
      Linux 4.14.257

Gregory CLEMENT (1):
      pinctrl: armada-37xx: add missing pin: PCIe1 Wakeup

Hans Verkuil (1):
      media: cec: copy sequence field for the reply

Helge Deller (3):
      parisc: Fix KBUILD_IMAGE for self-extracting kernel
      parisc: Fix "make install" on newer debian releases
      parisc: Mark cr16 CPU clocksource unstable on all SMP machines

Huang Pei (1):
      MIPS: use 3-level pgtable for 64KB page size on MIPS_VA_BITS_48

Ian Rogers (1):
      perf hist: Fix memory leak of a perf_hpp_fmt

Jason Gerecke (1):
      HID: wacom: Use "Confidence" flag to prevent reporting invalid contacts

Jens Axboe (1):
      fs: add fget_many() and fput_many()

Joerg Roedel (1):
      x86/64/mm: Map all kernel memory into trampoline_pgd

Johan Hovold (1):
      serial: core: fix transmit-buffer reset and memleak

Juergen Gross (9):
      xen: sync include/xen/interface/io/ring.h with Xen's newest version
      xen/blkfront: read response from backend only once
      xen/blkfront: don't take local copy of a request from the ring page
      xen/blkfront: don't trust the backend response data blindly
      xen/netfront: read response from backend only once
      xen/netfront: don't read data from request on the ring page
      xen/netfront: disentangle tx_skb_freelist
      xen/netfront: don't trust the backend response data blindly
      tty: hvc: replace BUG_ON() with negative return value

Lin Ma (1):
      NFC: add NCI_UNREG flag to eliminate the race

Linus Torvalds (1):
      fget: check that the fd still exists after getting a ref to it

Maciej W. Rozycki (1):
      vgacon: Propagate console boot parameters before calling `vc_resize'

Manaf Meethalavalappu Pallikunhi (1):
      thermal: core: Reset previous low and high trip during thermal zone init

Marek Behún (4):
      PCI: aardvark: Improve link training
      pinctrl: armada-37xx: Correct mpp definitions
      pinctrl: armada-37xx: Correct PWM pins definitions
      arm64: dts: marvell: armada-37xx: Set pcie_reset_pin to gpio function

Masami Hiramatsu (1):
      kprobes: Limit max data_size of the kretprobe instances

Mathias Nyman (3):
      usb: hub: Fix usb enumeration issue due to address0 race
      usb: hub: Fix locking issues with address0_mutex
      xhci: Fix commad ring abort, write all 64 bits to CRCR register.

Mike Christie (1):
      scsi: iscsi: Unblock session then wake up error handler

Mike Kravetz (1):
      hugetlb: take PMD sharing into account when flushing tlb/caches

Miklos Szeredi (2):
      fuse: fix page stealing
      fuse: release pipe buf after last use

Mingjie Zhang (1):
      USB: serial: option: add Fibocom FM101-GL variants

Miquel Raynal (1):
      arm64: dts: marvell: armada-37xx: declare PCIe reset pin

Nadav Amit (1):
      hugetlbfs: flush TLBs correctly after huge_pmd_unshare

Pali Rohár (12):
      PCI: aardvark: Train link immediately after enabling training
      PCI: aardvark: Issue PERST via GPIO
      PCI: aardvark: Replace custom macros by standard linux/pci_regs.h macros
      PCI: aardvark: Indicate error in 'val' when config read fails
      PCI: aardvark: Don't touch PCIe registers if no card connected
      PCI: aardvark: Fix compilation on s390
      PCI: aardvark: Move PCIe reset card code to advk_pcie_train_link()
      PCI: aardvark: Update comment about disabling link training
      PCI: aardvark: Configure PCIe resources from 'ranges' DT property
      PCI: aardvark: Fix PCIe Max Payload Size setting
      PCI: aardvark: Fix link training
      PCI: aardvark: Fix checking for link up via LTSSM state

Pierre Gondois (1):
      serial: pl011: Add ACPI SBSA UART match id

Randy Dunlap (1):
      natsemi: xtensa: fix section mismatch warnings

Remi Pommarel (1):
      PCI: aardvark: Wait for endpoint to be ready before training link

Sergei Shtylyov (1):
      PCI: aardvark: Fix I/O space page leak

Slark Xiao (1):
      platform/x86: thinkpad_acpi: Fix WWAN device disabled issue after S3 deep

Sreekanth Reddy (1):
      scsi: mpt3sas: Fix kernel panic during drive powercycle test

Stefano Garzarella (1):
      vhost/vsock: fix incorrect used length reported to the guest

Stefano Stabellini (2):
      xen: don't continue xenstore initialization in case of errors
      xen: detect uninitialized xenbus in xenbus_init

Stephen Suryaputra (1):
      vrf: Reset IPCB/IP6CB when processing outbound pkts in vrf dev xmit

Steven Rostedt (VMware) (2):
      tracing: Fix pid filtering when triggers are attached
      tracing: Check pid filtering when creating events

Sven Eckelmann (1):
      tty: serial: msm_serial: Deactivate RX DMA for polling support

Sven Schuchmann (1):
      net: usb: lan78xx: lan78xx_phy_init(): use PHY_POLL instead of "0" if no IRQ is available

Takashi Iwai (3):
      ALSA: ctxfi: Fix out-of-range access
      ASoC: topology: Add missing rwsem around snd_ctl_remove() calls
      ARM: socfpga: Fix crash with CONFIG_FORTIRY_SOURCE

Teng Qi (2):
      ethernet: hisilicon: hns: hns_dsaf_misc: fix a possible array overflow in hns_dsaf_ge_srst_by_port()
      net: ethernet: dec: tulip: de4x5: fix possible array overflows in type3_infoblock()

Thomas Petazzoni (1):
      PCI: aardvark: Introduce an advk_pcie_valid_device() helper

Thomas Zeitlhofer (1):
      PM: hibernate: use correct mode for swsusp_close()

Todd Kjos (1):
      binder: fix test regression due to sender_euid change

Tony Lu (3):
      net/smc: Ensure the active closing peer first closes clcsock
      net/smc: Don't call clcsock shutdown twice when smc shutdown
      net/smc: Keep smc_close_final rc during active close

Trond Myklebust (1):
      NFSv42: Don't fail clone() unless the OP_CLONE operation failed

Vasily Gorbik (1):
      s390/setup: avoid using memblock_enforce_memory_limit

Wang Yugui (1):
      btrfs: check-integrity: fix a warning on write caching disabled disk

Wen Yang (1):
      PCI: aardvark: Fix a leaked reference by adding missing of_node_put()

William Kucharski (1):
      net/rds: correct socket tunable error in rds_tcp_tune()

Zhou Qingyang (2):
      net: qlogic: qlcnic: Fix a NULL pointer dereference in qlcnic_83xx_add_rings()
      net/mlx4_en: Fix an use-after-free bug in mlx4_en_try_alloc_resources()

liuguoqiang (1):
      net: return correct error code

yangxingwu (1):
      netfilter: ipvs: Fix reuse connection if RS weight is 0

zhangyue (1):
      net: tulip: de4x5: fix the problem that the array 'lp->phy[8]' may be out of bound


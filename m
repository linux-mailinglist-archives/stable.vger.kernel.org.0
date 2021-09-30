Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C51D41D74F
	for <lists+stable@lfdr.de>; Thu, 30 Sep 2021 12:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349812AbhI3KMF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Sep 2021 06:12:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:36794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349834AbhI3KL7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Sep 2021 06:11:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F94E61884;
        Thu, 30 Sep 2021 10:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632996617;
        bh=ffl5uJjIZx4zpHKzuCvhkY9JKJtFG0YXFNDtFJI19KY=;
        h=From:To:Cc:Subject:Date:From;
        b=QtobjXxrI5ZgFGK5rK7LWXC2O8dhvqcgUIRy/khmTN/Br8jbpvbzOJFC26fEqFGAt
         iQOj4VL7BkY5UqTbY0t1p96zdqFXW+SojhDIDA41bAkWoENIXLYhvlJtrb1GhsKoun
         ubucYEGw5tZs5ZjWqbXlKwE5ZwpADFr2Xl6UpDAQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.150
Date:   Thu, 30 Sep 2021 12:10:13 +0200
Message-Id: <1632996613115188@kroah.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.150 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                         |    2 
 arch/alpha/include/asm/io.h                                      |    6 
 arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts           |   17 
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi                     |   11 
 arch/arm64/kernel/process.c                                      |    2 
 arch/m68k/include/asm/raw_io.h                                   |   20 -
 arch/parisc/include/asm/page.h                                   |    2 
 arch/sparc/kernel/ioport.c                                       |    4 
 arch/sparc/kernel/mdesc.c                                        |    3 
 arch/x86/xen/enlighten_pv.c                                      |   15 
 block/blk-cgroup.c                                               |    8 
 drivers/android/binder.c                                         |   23 -
 drivers/edac/synopsys_edac.c                                     |    2 
 drivers/fpga/machxo2-spi.c                                       |    6 
 drivers/gpio/gpio-uniphier.c                                     |    4 
 drivers/irqchip/Kconfig                                          |    1 
 drivers/irqchip/irq-gic-v3-its.c                                 |    2 
 drivers/mcb/mcb-core.c                                           |   12 
 drivers/md/md.c                                                  |    5 
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                        |    8 
 drivers/net/ethernet/broadcom/bnxt/bnxt.h                        |    5 
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c                |    2 
 drivers/net/ethernet/cadence/macb_pci.c                          |    2 
 drivers/net/ethernet/freescale/enetc/enetc.c                     |    5 
 drivers/net/ethernet/i825xx/82596.c                              |    2 
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c                   |    3 
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c                      |    8 
 drivers/net/ethernet/qlogic/qed/qed_roce.c                       |    8 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c                |    2 
 drivers/net/hamradio/6pack.c                                     |    4 
 drivers/net/usb/hso.c                                            |   12 
 drivers/nvme/host/multipath.c                                    |    7 
 drivers/platform/x86/intel_punit_ipc.c                           |    3 
 drivers/scsi/lpfc/lpfc_attr.c                                    |    3 
 drivers/scsi/qla2xxx/qla_init.c                                  |    3 
 drivers/scsi/scsi_transport_iscsi.c                              |    8 
 drivers/spi/spi-tegra20-slink.c                                  |    4 
 drivers/staging/greybus/uart.c                                   |   62 +--
 drivers/thermal/intel/int340x_thermal/processor_thermal_device.c |    5 
 drivers/thermal/thermal_core.c                                   |    7 
 drivers/tty/serial/mvebu-uart.c                                  |    2 
 drivers/tty/synclink_gt.c                                        |  101 +----
 drivers/usb/class/cdc-acm.c                                      |    7 
 drivers/usb/class/cdc-acm.h                                      |    2 
 drivers/usb/core/hcd.c                                           |   29 +
 drivers/usb/dwc2/gadget.c                                        |  193 +++++-----
 drivers/usb/gadget/udc/r8a66597-udc.c                            |    2 
 drivers/usb/host/xhci.c                                          |    1 
 drivers/usb/musb/tusb6010.c                                      |    1 
 drivers/usb/serial/cp210x.c                                      |    1 
 drivers/usb/serial/mos7840.c                                     |    2 
 drivers/usb/serial/option.c                                      |   11 
 drivers/usb/storage/unusual_devs.h                               |    9 
 drivers/usb/storage/unusual_uas.h                                |    2 
 drivers/xen/balloon.c                                            |   62 ++-
 fs/afs/dir.c                                                     |   46 --
 fs/btrfs/space-info.c                                            |    5 
 fs/cifs/connect.c                                                |    5 
 fs/cifs/file.c                                                   |    2 
 fs/ocfs2/dlmglue.c                                               |    3 
 fs/qnx4/dir.c                                                    |   69 ++-
 include/linux/compiler.h                                         |    2 
 include/linux/usb/hcd.h                                          |    2 
 include/trace/events/erofs.h                                     |    6 
 kernel/bpf/verifier.c                                            |    2 
 kernel/trace/blktrace.c                                          |    8 
 net/ipv6/ip6_fib.c                                               |    3 
 net/smc/smc_clc.c                                                |    3 
 68 files changed, 508 insertions(+), 381 deletions(-)

Andreas Larsson (1):
      sparc32: page align size in arch_dma_alloc

Andy Shevchenko (1):
      platform/x86/intel: punit_ipc: Drop wrong use of ACPI_PTR()

Antoine Tenart (1):
      thermal/drivers/int340x: Do not set a wrong tcc offset on resume

Anton Eidelman (1):
      nvme-multipath: fix ANA state updates when a namespace is not present

Aya Levin (1):
      net/mlx4_en: Don't allow aRFS for encapsulated packets

Baokun Li (1):
      scsi: iscsi: Adjust iface sysfs attr detection

Bixuan Cui (1):
      bpf: Add oversize check before call kvcalloc()

Carlo Lobrano (1):
      USB: serial: option: add Telit LN920 compositions

Christoph Hellwig (1):
      md: fix a lock order reversal in md_alloc

Claudiu Manoil (1):
      enetc: Fix illegal access when reading affinity_hint

Dan Carpenter (6):
      usb: gadget: r8a66597: fix a loop in set_feature()
      usb: musb: tusb6010: uninitialized data in tusb_fifo_write_unaligned()
      mcb: fix error handling in mcb_alloc_bus()
      thermal/core: Potential buffer overflow in thermal_build_list_of_policies()
      cifs: fix a sign extension bug
      scsi: lpfc: Use correct scnprintf() limit

Dan Li (1):
      arm64: Mark __stack_chk_guard as __ro_after_init

David Howells (1):
      afs: Fix incorrect triggering of sillyrename on 3rd-party invalidation

Dmitry Bogdanov (1):
      scsi: qla2xxx: Restore initiator in dual mode

Gao Xiang (1):
      erofs: fix up erofs_lookup tracepoint

Greg Kroah-Hartman (1):
      Linux 5.4.150

Guenter Roeck (5):
      m68k: Double cast io functions to unsigned long
      compiler.h: Introduce absolute_pointer macro
      net: i825xx: Use absolute_pointer for memcpy from fixed memory location
      alpha: Declare virt_to_phys and virt_to_bus parameter as pointer to volatile
      net: 6pack: Fix tx timeout and slot time

Helge Deller (1):
      parisc: Use absolute_pointer() to define PAGE0

Jan Beulich (1):
      xen/x86: fix PV trap handling on secondary processors

Jesper Nilsson (1):
      net: stmmac: allow CSR clock of 300MHz

Jiapeng Chong (1):
      fpga: machxo2-spi: Fix missing error code in machxo2_write_complete()

Jiri Slaby (1):
      tty: synclink_gt, drop unneeded forward declarations

Johan Hovold (3):
      USB: cdc-acm: fix minor-number release
      staging: greybus: uart: fix tty use after free
      net: hso: fix muxed tty registration

Juergen Gross (2):
      xen/balloon: use a kernel thread instead a workqueue
      xen/balloon: fix balloon kthread freezing

Julian Sikorski (1):
      Re-enable UAS for LaCie Rugged USB3-FW with fk quirk

Kaige Fu (1):
      irqchip/gic-v3-its: Fix potential VPE leak on error

Karsten Graul (1):
      net/smc: add missing error check in smc_clc_prfx_set()

Kishon Vijay Abraham I (2):
      usb: core: hcd: Add support for deferring roothub registration
      xhci: Set HCD flag to defer primary roothub registration

Krzysztof Kozlowski (2):
      USB: serial: mos7840: remove duplicated 0xac24 device ID
      USB: serial: option: remove duplicate USB device ID

Kunihiko Hayashi (1):
      gpio: uniphier: Fix void functions to remove return value

Li Jinlin (1):
      blk-cgroup: fix UAF by grabbing blkcg lock before destroying blkg pd

Linus Torvalds (4):
      sparc: avoid stringop-overread errors
      qnx4: avoid stringop-overread errors
      spi: Fix tegra20 build with CONFIG_PM=n
      qnx4: work around gcc false positive warning bug

Michael Chan (1):
      bnxt_en: Fix TX timeout when TX ring size is set to the smallest

Minas Harutyunyan (2):
      usb: dwc2: gadget: Fix ISOC flow for BDMA and Slave
      usb: dwc2: gadget: Fix ISOC transfer complete handling for DDMA

Ondrej Zary (1):
      usb-storage: Add quirk for ScanLogic SL11R-IDE older than 2.6c

Pali Rohár (2):
      serial: mvebu-uart: fix driver's tx_empty callback
      arm64: dts: marvell: armada-37xx: Extend PCIe MEM space

Qu Wenruo (1):
      btrfs: prevent __btrfs_dump_space_info() to underflow its free space

Randy Dunlap (2):
      tty: synclink_gt: rename a conflicting function name
      irqchip/goldfish-pic: Select GENERIC_IRQ_CHIP to fix build

Sai Krishna Potthuri (1):
      EDAC/synopsys: Fix wrong value type assignment for edac_mode

Shai Malin (1):
      qed: rdma - don't wait for resources under hw error recovery flow

Slark Xiao (1):
      USB: serial: option: add device id for Foxconn T99W265

Steve French (1):
      cifs: fix incorrect check for null pointer in header_assemble

Todd Kjos (1):
      binder: make sure fd closes complete

Tom Rix (1):
      fpga: machxo2-spi: Return an error on failure

Tong Zhang (1):
      net: macb: fix use after free on rmmod

Uwe Brandt (1):
      USB: serial: cp210x: add ID for GW Instek GDM-834x Digital Multimeter

Wengang Wang (1):
      ocfs2: drop acl cache for directories too

Zhihao Cheng (1):
      blktrace: Fix uaf in blk_trace access after removing by sysfs

zhang kai (1):
      ipv6: delay fib6_sernum increase in fib6_add


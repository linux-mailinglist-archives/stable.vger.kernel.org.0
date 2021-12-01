Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC9994649DC
	for <lists+stable@lfdr.de>; Wed,  1 Dec 2021 09:39:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348047AbhLAImo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Dec 2021 03:42:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348055AbhLAImg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Dec 2021 03:42:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D4DBC061756;
        Wed,  1 Dec 2021 00:39:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 316C3B81DFD;
        Wed,  1 Dec 2021 08:39:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BC66C53FAD;
        Wed,  1 Dec 2021 08:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638347952;
        bh=xvgcTpjShC/OuHFBzYO0WJ3Mcq/QOZnJFxP0HRmvyNQ=;
        h=From:To:Cc:Subject:Date:From;
        b=oEnC743MulmKd1dA6/EvOzhIhXDpecXD1XEHgGoGA8kYZw8t+oyM9APjt4BXbDAZz
         vpJ/ioS1ca2TADjMscQ6Hf8VgpphmogeRKOL9JlysZhAqFoKmEX09xIghVYHGIn9nK
         zGFRroF08tQjjGL4DiJf4QREsOnoIQtiuBwOfPvU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.219
Date:   Wed,  1 Dec 2021 09:39:05 +0100
Message-Id: <16383479463828@kroah.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.219 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
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
 arch/s390/include/asm/tlb.h                                               |   16 
 arch/s390/mm/pgtable.c                                                    |   13 
 arch/sh/include/asm/tlb.h                                                 |   10 
 arch/um/include/asm/tlb.h                                                 |   12 
 arch/xtensa/include/asm/vectors.h                                         |    2 
 arch/xtensa/kernel/setup.c                                                |   12 
 arch/xtensa/mm/mmu.c                                                      |    2 
 drivers/android/binder.c                                                  |    2 
 drivers/block/xen-blkfront.c                                              |  126 +-
 drivers/firmware/arm_scmi/scmi_pm_domain.c                                |    4 
 drivers/gpu/drm/vc4/vc4_bo.c                                              |    2 
 drivers/hid/wacom_wac.c                                                   |    8 
 drivers/hid/wacom_wac.h                                                   |    1 
 drivers/media/cec/cec-adap.c                                              |    1 
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c                 |    4 
 drivers/net/xen-netfront.c                                                |  257 +++--
 drivers/pci/controller/pci-aardvark.c                                     |  436 ++++++++--
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c                               |   28 
 drivers/scsi/mpt3sas/mpt3sas_scsih.c                                      |    2 
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c                              |    3 
 drivers/tty/hvc/hvc_xen.c                                                 |   17 
 drivers/usb/core/hub.c                                                    |   23 
 drivers/usb/dwc2/hcd_queue.c                                              |    2 
 drivers/usb/serial/option.c                                               |    5 
 drivers/vhost/vsock.c                                                     |    2 
 drivers/xen/xenbus/xenbus_probe.c                                         |   27 
 fs/fuse/dev.c                                                             |   14 
 fs/nfs/nfs42xdr.c                                                         |    3 
 fs/proc/vmcore.c                                                          |   15 
 include/asm-generic/tlb.h                                                 |    2 
 include/net/nfc/nci_core.h                                                |    1 
 include/net/nl802154.h                                                    |    7 
 include/xen/interface/io/ring.h                                           |  293 +++---
 kernel/power/hibernate.c                                                  |    6 
 kernel/trace/trace.h                                                      |   24 
 kernel/trace/trace_events.c                                               |    7 
 mm/hugetlb.c                                                              |   23 
 mm/memory.c                                                               |   10 
 net/ipv4/tcp_cubic.c                                                      |    5 
 net/ipv6/ip6_output.c                                                     |    2 
 net/netfilter/ipvs/ip_vs_core.c                                           |    8 
 net/nfc/nci/core.c                                                        |   19 
 net/smc/af_smc.c                                                          |    8 
 net/smc/smc_close.c                                                       |    6 
 sound/pci/ctxfi/ctamixer.c                                                |   14 
 sound/pci/ctxfi/ctdaio.c                                                  |   16 
 sound/pci/ctxfi/ctresource.c                                              |    7 
 sound/pci/ctxfi/ctresource.h                                              |    4 
 sound/pci/ctxfi/ctsrc.c                                                   |    7 
 sound/soc/qcom/qdsp6/q6routing.c                                          |    6 
 sound/soc/soc-topology.c                                                  |    3 
 63 files changed, 1156 insertions(+), 451 deletions(-)

Alexander Aring (1):
      net: ieee802154: handle iftypes as u32

Dan Carpenter (2):
      staging: rtl8192e: Fix use after free in _rtl92e_pci_disconnect()
      drm/vc4: fix error code in vc4_create_object()

Daniele Palmas (1):
      USB: serial: option: add Telit LE910S1 0x9200 composition

David Hildenbrand (2):
      proc/vmcore: fix clearing user buffer by properly using clear_user()
      s390/mm: validate VMA in PGSTE manipulation functions

Eric Dumazet (2):
      ipv6: fix typos in __ip6_finish_output()
      tcp_cubic: fix spurious Hystart ACK train detections for not-cwnd-limited flows

Florian Fainelli (2):
      ARM: dts: BCM5301X: Fix I2C controller interrupt
      ARM: dts: BCM5301X: Add interrupt properties to GPIO node

Greg Kroah-Hartman (1):
      Linux 4.19.219

Gregory CLEMENT (1):
      pinctrl: armada-37xx: add missing pin: PCIe1 Wakeup

Guangbin Huang (1):
      net: hns3: fix VF RSS failed problem after PF enable multi-TCs

Hans Verkuil (1):
      media: cec: copy sequence field for the reply

Huang Pei (1):
      MIPS: use 3-level pgtable for 64KB page size on MIPS_VA_BITS_48

Jason Gerecke (1):
      HID: wacom: Use "Confidence" flag to prevent reporting invalid contacts

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

Marek Behún (4):
      PCI: aardvark: Improve link training
      pinctrl: armada-37xx: Correct mpp definitions
      pinctrl: armada-37xx: Correct PWM pins definitions
      arm64: dts: marvell: armada-37xx: Set pcie_reset_pin to gpio function

Mathias Nyman (2):
      usb: hub: Fix usb enumeration issue due to address0 race
      usb: hub: Fix locking issues with address0_mutex

Miklos Szeredi (2):
      fuse: fix page stealing
      fuse: release pipe buf after last use

Mingjie Zhang (1):
      USB: serial: option: add Fibocom FM101-GL variants

Miquel Raynal (1):
      arm64: dts: marvell: armada-37xx: declare PCIe reset pin

Nadav Amit (1):
      hugetlbfs: flush TLBs correctly after huge_pmd_unshare

Nathan Chancellor (1):
      usb: dwc2: hcd_queue: Fix use of floating point literal

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

Peng Fan (1):
      firmware: arm_scmi: pm: Propagate return value to caller

Randy Dunlap (1):
      xtensa: use CONFIG_USE_OF instead of CONFIG_OF

Remi Pommarel (1):
      PCI: aardvark: Wait for endpoint to be ready before training link

Sreekanth Reddy (1):
      scsi: mpt3sas: Fix kernel panic during drive powercycle test

Srinivas Kandagatla (1):
      ASoC: qdsp6: q6routing: Conditionally reset FrontEnd Mixer

Stefano Garzarella (1):
      vhost/vsock: fix incorrect used length reported to the guest

Stefano Stabellini (2):
      xen: don't continue xenstore initialization in case of errors
      xen: detect uninitialized xenbus in xenbus_init

Steven Rostedt (VMware) (2):
      tracing: Fix pid filtering when triggers are attached
      tracing: Check pid filtering when creating events

Takashi Iwai (3):
      ALSA: ctxfi: Fix out-of-range access
      ASoC: topology: Add missing rwsem around snd_ctl_remove() calls
      ARM: socfpga: Fix crash with CONFIG_FORTIRY_SOURCE

Thomas Zeitlhofer (1):
      PM: hibernate: use correct mode for swsusp_close()

Todd Kjos (1):
      binder: fix test regression due to sender_euid change

Tony Lu (2):
      net/smc: Ensure the active closing peer first closes clcsock
      net/smc: Don't call clcsock shutdown twice when smc shutdown

Trond Myklebust (1):
      NFSv42: Don't fail clone() unless the OP_CLONE operation failed

Wen Yang (1):
      PCI: aardvark: Fix a leaked reference by adding missing of_node_put()

yangxingwu (1):
      netfilter: ipvs: Fix reuse connection if RS weight is 0


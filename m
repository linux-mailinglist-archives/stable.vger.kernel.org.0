Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E1C34649D8
	for <lists+stable@lfdr.de>; Wed,  1 Dec 2021 09:39:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348020AbhLAIml (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Dec 2021 03:42:41 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40164 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348025AbhLAIm3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Dec 2021 03:42:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C7EDB81E04;
        Wed,  1 Dec 2021 08:39:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DEBAC53FAD;
        Wed,  1 Dec 2021 08:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638347944;
        bh=gfKDJea9xF40ckZVGLmJmkm/pW+bSErWWYwc7ME1FI4=;
        h=From:To:Cc:Subject:Date:From;
        b=sE8HdjCOPokDejAlglA4FVzXGji3cHT+AmwBPlzOZqskI5aV/FOB6B1ajFTv2+zhQ
         AGqJB+DbIZ9MX9UUtHSIfnBtU1KvhIVZKbTMHVqv3qlilWtFVtwzM9J/OvX0PBTQNr
         WA0LSpF1/PgLml5E08Fhfy/s8QW3us5KLpI2Bbyw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.163
Date:   Wed,  1 Dec 2021 09:39:01 +0100
Message-Id: <1638347941163164@kroah.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.163 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/pinctrl/marvell,armada-37xx-pinctrl.txt |    8 
 Documentation/networking/ipvs-sysctl.txt                                  |    3 
 Makefile                                                                  |    2 
 arch/arm/boot/dts/bcm5301x.dtsi                                           |    4 
 arch/arm/mach-socfpga/core.h                                              |    2 
 arch/arm/mach-socfpga/platsmp.c                                           |    8 
 arch/arm64/boot/dts/marvell/armada-3720-db.dts                            |    3 
 arch/arm64/boot/dts/marvell/armada-3720-espressobin.dts                   |    1 
 arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts                    |    4 
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi                              |    2 
 arch/mips/Kconfig                                                         |    2 
 arch/parisc/kernel/vmlinux.lds.S                                          |    3 
 arch/powerpc/kvm/book3s_hv_builtin.c                                      |    5 
 arch/s390/mm/pgtable.c                                                    |   13 
 drivers/android/binder.c                                                  |    2 
 drivers/block/xen-blkfront.c                                              |  126 +-
 drivers/firmware/arm_scmi/scmi_pm_domain.c                                |    4 
 drivers/gpu/drm/vc4/vc4_bo.c                                              |    2 
 drivers/hid/wacom_wac.c                                                   |    8 
 drivers/hid/wacom_wac.h                                                   |    1 
 drivers/media/cec/cec-adap.c                                              |    1 
 drivers/mmc/host/sdhci.c                                                  |   21 
 drivers/mmc/host/sdhci.h                                                  |    4 
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c                 |    4 
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c                            |   30 
 drivers/net/ethernet/intel/igb/igb_main.c                                 |    2 
 drivers/net/ethernet/mscc/ocelot.c                                        |   11 
 drivers/net/ethernet/netronome/nfp/nfp_net.h                              |    3 
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c                      |    2 
 drivers/net/phy/mdio-aspeed.c                                             |    7 
 drivers/net/xen-netfront.c                                                |  255 ++--
 drivers/nvme/target/io-cmd-file.c                                         |    4 
 drivers/nvme/target/tcp.c                                                 |    7 
 drivers/pci/controller/pci-aardvark.c                                     |  576 ++++++++--
 drivers/pci/pci-bridge-emul.c                                             |   11 
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c                               |   17 
 drivers/scsi/mpt3sas/mpt3sas_scsih.c                                      |    2 
 drivers/scsi/scsi_sysfs.c                                                 |    2 
 drivers/staging/fbtft/fb_ssd1351.c                                        |    4 
 drivers/staging/fbtft/fbtft-core.c                                        |    9 
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c                              |    3 
 drivers/tty/hvc/hvc_xen.c                                                 |   17 
 drivers/usb/core/hub.c                                                    |   23 
 drivers/usb/dwc2/gadget.c                                                 |   17 
 drivers/usb/dwc2/hcd_queue.c                                              |    2 
 drivers/usb/serial/option.c                                               |    5 
 drivers/usb/typec/tcpm/fusb302.c                                          |    6 
 drivers/vhost/vsock.c                                                     |    2 
 drivers/xen/xenbus/xenbus_probe.c                                         |   27 
 fs/cifs/file.c                                                            |   35 
 fs/f2fs/node.c                                                            |    1 
 fs/fuse/dev.c                                                             |   10 
 fs/nfs/nfs42xdr.c                                                         |    3 
 fs/proc/vmcore.c                                                          |   16 
 include/linux/ipc_namespace.h                                             |   15 
 include/linux/sched/task.h                                                |    2 
 include/net/ip6_fib.h                                                     |    1 
 include/net/ipv6_stubs.h                                                  |    1 
 include/net/nfc/nci_core.h                                                |    1 
 include/net/nl802154.h                                                    |    7 
 include/xen/interface/io/ring.h                                           |  293 ++---
 ipc/shm.c                                                                 |  189 ++-
 kernel/power/hibernate.c                                                  |    6 
 kernel/trace/trace.h                                                      |   24 
 kernel/trace/trace_events.c                                               |    7 
 kernel/trace/trace_uprobe.c                                               |    1 
 net/8021q/vlan.c                                                          |    3 
 net/8021q/vlan_dev.c                                                      |    3 
 net/ipv4/nexthop.c                                                        |   35 
 net/ipv4/tcp_cubic.c                                                      |    5 
 net/ipv6/af_inet6.c                                                       |    1 
 net/ipv6/ip6_output.c                                                     |    2 
 net/ipv6/route.c                                                          |   19 
 net/ncsi/ncsi-cmd.c                                                       |   24 
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
 85 files changed, 1463 insertions(+), 616 deletions(-)

Adrian Hunter (1):
      mmc: sdhci: Fix ADMA for PAGE_SIZE >= 64KiB

Alexander Aring (1):
      net: ieee802154: handle iftypes as u32

Alexander Mikhalitsyn (1):
      shm: extend forced shm destroy to support objects from several IPC nses

Dan Carpenter (2):
      staging: rtl8192e: Fix use after free in _rtl92e_pci_disconnect()
      drm/vc4: fix error code in vc4_create_object()

Daniele Palmas (1):
      USB: serial: option: add Telit LE910S1 0x9200 composition

David Hildenbrand (2):
      proc/vmcore: fix clearing user buffer by properly using clear_user()
      s390/mm: validate VMA in PGSTE manipulation functions

Diana Wang (1):
      nfp: checking parameter process for rx-usecs/tx-usecs is invalid

Dylan Hung (1):
      mdio: aspeed: Fix "Link is Down" issue

Eric Dumazet (2):
      ipv6: fix typos in __ip6_finish_output()
      tcp_cubic: fix spurious Hystart ACK train detections for not-cwnd-limited flows

Florian Fainelli (2):
      ARM: dts: BCM5301X: Fix I2C controller interrupt
      ARM: dts: BCM5301X: Add interrupt properties to GPIO node

Greg Kroah-Hartman (1):
      Linux 5.4.163

Grzegorz Jaszczyk (1):
      PCI: aardvark: Fix big endian support

Guangbin Huang (1):
      net: hns3: fix VF RSS failed problem after PF enable multi-TCs

Hans Verkuil (1):
      media: cec: copy sequence field for the reply

Helge Deller (1):
      Revert "parisc: Fix backtrace to always include init funtion names"

Huang Pei (1):
      MIPS: use 3-level pgtable for 64KB page size on MIPS_VA_BITS_48

Jason Gerecke (1):
      HID: wacom: Use "Confidence" flag to prevent reporting invalid contacts

Jesse Brandeburg (1):
      igb: fix netpoll exit with traffic

Jiri Olsa (1):
      tracing/uprobe: Fix uprobe_perf_open probes iteration

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

Kumar Thangavel (1):
      net/ncsi : Add payload to be 32-bit aligned to fix dropped packets

Lin Ma (1):
      NFC: add NCI_UNREG flag to eliminate the race

Marek Behún (4):
      PCI: aardvark: Deduplicate code in advk_pcie_rd_conf()
      PCI: aardvark: Improve link training
      pinctrl: armada-37xx: Correct PWM pins definitions
      arm64: dts: marvell: armada-37xx: Set pcie_reset_pin to gpio function

Mathias Nyman (2):
      usb: hub: Fix usb enumeration issue due to address0 race
      usb: hub: Fix locking issues with address0_mutex

Maurizio Lombardi (1):
      nvmet: use IOCB_NOWAIT only if the filesystem supports it

Mike Christie (1):
      scsi: core: sysfs: Fix setting device state to SDEV_RUNNING

Miklos Szeredi (1):
      fuse: release pipe buf after last use

Minas Harutyunyan (1):
      usb: dwc2: gadget: Fix ISOC flow for elapsed frames

Mingjie Zhang (1):
      USB: serial: option: add Fibocom FM101-GL variants

Nathan Chancellor (1):
      usb: dwc2: hcd_queue: Fix use of floating point literal

Nicholas Piggin (1):
      KVM: PPC: Book3S HV: Prevent POWER7/8 TLB flush flushing SLB

Nikolay Aleksandrov (3):
      net: nexthop: fix null pointer dereference when IPv6 is not enabled
      net: ipv6: add fib6_nh_release_dsts stub
      net: nexthop: release IPv6 per-cpu dsts when replacing a nexthop group

Nitesh B Venkatesh (1):
      iavf: Prevent changing static ITR values if adaptive moderation is on

Noralf Trønnes (1):
      staging/fbtft: Fix backlight

Ondrej Jirman (1):
      usb: typec: fusb302: Fix masking of comparator and bc_lvl interrupts

Pali Rohár (15):
      PCI: aardvark: Train link immediately after enabling training
      PCI: aardvark: Issue PERST via GPIO
      PCI: aardvark: Replace custom macros by standard linux/pci_regs.h macros
      PCI: aardvark: Don't touch PCIe registers if no card connected
      PCI: aardvark: Fix compilation on s390
      PCI: aardvark: Move PCIe reset card code to advk_pcie_train_link()
      PCI: aardvark: Update comment about disabling link training
      PCI: aardvark: Configure PCIe resources from 'ranges' DT property
      PCI: aardvark: Fix PCIe Max Payload Size setting
      PCI: aardvark: Implement re-issuing config requests on CRS response
      PCI: aardvark: Simplify initialization of rootcap on virtual bridge
      PCI: aardvark: Fix link training
      PCI: aardvark: Fix support for bus mastering and PCI_COMMAND on emulated bridge
      PCI: aardvark: Set PCI Bridge Class Code to PCI Bridge
      PCI: aardvark: Fix support for PCI_BRIDGE_CTL_BUS_RESET on emulated bridge

Peng Fan (1):
      firmware: arm_scmi: pm: Propagate return value to caller

Remi Pommarel (1):
      PCI: aardvark: Wait for endpoint to be ready before training link

Russell King (1):
      PCI: pci-bridge-emul: Fix array overruns, improve safety

Sreekanth Reddy (1):
      scsi: mpt3sas: Fix kernel panic during drive powercycle test

Srinivas Kandagatla (1):
      ASoC: qdsp6: q6routing: Conditionally reset FrontEnd Mixer

Stefano Garzarella (1):
      vhost/vsock: fix incorrect used length reported to the guest

Stefano Stabellini (2):
      xen: don't continue xenstore initialization in case of errors
      xen: detect uninitialized xenbus in xenbus_init

Steve French (1):
      smb3: do not error on fsync when readonly

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

Varun Prakash (1):
      nvmet-tcp: fix incomplete data digest send

Vladimir Oltean (2):
      net: mscc: ocelot: don't downgrade timestamping RX filters in SIOCSHWTSTAMP
      net: mscc: ocelot: correctly report the timestamping RX filters in ethtool

Weichao Guo (1):
      f2fs: set SBI_NEED_FSCK flag when inconsistent node block found

Ziyang Xuan (1):
      net: vlan: fix underflow for the real_dev refcnt

yangxingwu (1):
      netfilter: ipvs: Fix reuse connection if RS weight is 0


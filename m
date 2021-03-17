Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC09A33F678
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 18:19:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231536AbhCQRTN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 13:19:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:46978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231520AbhCQRS6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Mar 2021 13:18:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50B1561490;
        Wed, 17 Mar 2021 17:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616001537;
        bh=WgnPxhsvd3gXG23prZ54oAo+6W1ejEPeE0ayRSwmBlI=;
        h=From:To:Cc:Subject:Date:From;
        b=V1d3Q9IuDLViJDpiZHm7J1hqkgZCvT5EECJVAA9Rm6NJ49LSqDfRxkN6s9KGgT1Ak
         ehiccOuCeBA5kAl0dxLhVCI82V1TLfonM1BmbaYhANIHiTy+keMa1JRhYcY2zUnKOz
         PA0X8U0wT1/lb9Ttqxr0KpwaaqXcPstfVEcvGegE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.181
Date:   Wed, 17 Mar 2021 18:18:51 +0100
Message-Id: <1616001531174122@kroah.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.181 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                            |    2 
 arch/powerpc/include/asm/code-patching.h                            |    2 
 arch/powerpc/include/asm/machdep.h                                  |    3 
 arch/powerpc/kernel/pci-common.c                                    |   10 
 arch/powerpc/kernel/traps.c                                         |    5 
 arch/powerpc/perf/core-book3s.c                                     |   19 +
 arch/s390/kernel/smp.c                                              |    2 
 arch/sparc/include/asm/mman.h                                       |   54 ++--
 arch/sparc/mm/init_32.c                                             |    3 
 arch/x86/kernel/unwind_orc.c                                        |   12 
 drivers/block/rsxx/core.c                                           |    1 
 drivers/gpu/drm/drm_ioc32.c                                         |   11 
 drivers/gpu/drm/meson/meson_drv.c                                   |   11 
 drivers/hwmon/lm90.c                                                |   42 ++-
 drivers/i2c/busses/i2c-rcar.c                                       |    2 
 drivers/media/platform/vsp1/vsp1_drm.c                              |    6 
 drivers/media/usb/usbtv/usbtv-audio.c                               |    2 
 drivers/mmc/core/bus.c                                              |   11 
 drivers/mmc/core/mmc.c                                              |   15 -
 drivers/mmc/host/mtk-sd.c                                           |   18 -
 drivers/mmc/host/mxs-mmc.c                                          |    2 
 drivers/net/can/flexcan.c                                           |   12 
 drivers/net/ethernet/atheros/alx/main.c                             |    7 
 drivers/net/ethernet/davicom/dm9000.c                               |   21 +
 drivers/net/ethernet/intel/i40e/i40e_main.c                         |    2 
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c                     |    2 
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c                      |    2 
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h                        |    1 
 drivers/net/ethernet/renesas/sh_eth.c                               |    7 
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c                    |   19 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c                    |    4 
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c                   |    2 
 drivers/net/phy/phy.c                                               |    7 
 drivers/net/usb/qmi_wwan.c                                          |   14 -
 drivers/net/wan/lapbether.c                                         |    3 
 drivers/net/wireless/ath/ath9k/ath9k.h                              |    3 
 drivers/net/wireless/ath/ath9k/xmit.c                               |    6 
 drivers/net/wireless/mediatek/mt76/dma.c                            |   11 
 drivers/pci/controller/pci-xgene-msi.c                              |   10 
 drivers/pci/controller/pcie-mediatek.c                              |    7 
 drivers/pci/pci.c                                                   |    4 
 drivers/s390/block/dasd.c                                           |    6 
 drivers/s390/cio/vfio_ccw_ops.c                                     |    6 
 drivers/scsi/libiscsi.c                                             |   11 
 drivers/staging/comedi/drivers/addi_apci_1032.c                     |    4 
 drivers/staging/comedi/drivers/addi_apci_1500.c                     |   18 -
 drivers/staging/comedi/drivers/adv_pci1710.c                        |   10 
 drivers/staging/comedi/drivers/das6402.c                            |    2 
 drivers/staging/comedi/drivers/das800.c                             |    2 
 drivers/staging/comedi/drivers/dmm32at.c                            |    2 
 drivers/staging/comedi/drivers/me4000.c                             |    2 
 drivers/staging/comedi/drivers/pcl711.c                             |    2 
 drivers/staging/comedi/drivers/pcl818.c                             |    2 
 drivers/staging/ks7010/ks_wlan_net.c                                |    6 
 drivers/staging/rtl8188eu/core/rtw_ap.c                             |    5 
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c                      |    6 
 drivers/staging/rtl8192e/rtl8192e/rtl_wx.c                          |    7 
 drivers/staging/rtl8192u/r8192U_wx.c                                |    6 
 drivers/staging/rtl8712/rtl871x_cmd.c                               |    6 
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c                       |    2 
 drivers/target/target_core_pr.c                                     |   15 -
 drivers/target/target_core_transport.c                              |   15 -
 drivers/usb/class/cdc-acm.c                                         |    5 
 drivers/usb/class/usblp.c                                           |   16 -
 drivers/usb/dwc3/dwc3-qcom.c                                        |    7 
 drivers/usb/gadget/function/f_uac1.c                                |    1 
 drivers/usb/gadget/function/f_uac2.c                                |    2 
 drivers/usb/gadget/function/u_ether_configfs.h                      |    5 
 drivers/usb/host/xhci-pci.c                                         |    8 
 drivers/usb/host/xhci.c                                             |   16 -
 drivers/usb/renesas_usbhs/pipe.c                                    |    2 
 drivers/usb/serial/ch341.c                                          |    1 
 drivers/usb/serial/cp210x.c                                         |    3 
 drivers/usb/serial/io_edgeport.c                                    |   26 +
 drivers/usb/usbip/stub_dev.c                                        |   42 ++-
 drivers/usb/usbip/vhci_sysfs.c                                      |   39 ++
 drivers/usb/usbip/vudc_sysfs.c                                      |   50 +++
 drivers/xen/events/events_2l.c                                      |   22 +
 drivers/xen/events/events_base.c                                    |  132 +++++++---
 drivers/xen/events/events_fifo.c                                    |    7 
 drivers/xen/events/events_internal.h                                |   22 +
 fs/binfmt_misc.c                                                    |   29 +-
 fs/cifs/cifsfs.c                                                    |    2 
 fs/configfs/file.c                                                  |    6 
 fs/nfs/nfs4proc.c                                                   |    2 
 fs/udf/inode.c                                                      |    9 
 include/linux/can/skb.h                                             |    8 
 include/linux/netdevice.h                                           |   10 
 include/linux/sched/mm.h                                            |    3 
 include/linux/stop_machine.h                                        |   11 
 include/linux/virtio_net.h                                          |    7 
 include/net/tcp.h                                                   |    2 
 include/target/target_core_backend.h                                |    1 
 include/uapi/linux/netfilter/nfnetlink_cthelper.h                   |    2 
 kernel/time/hrtimer.c                                               |   60 ++--
 lib/logic_pio.c                                                     |    3 
 mm/slub.c                                                           |    2 
 net/ipv4/cipso_ipv4.c                                               |   11 
 net/ipv4/tcp.c                                                      |   59 ++--
 net/ipv4/tcp_diag.c                                                 |    5 
 net/ipv4/tcp_input.c                                                |    6 
 net/ipv4/tcp_ipv4.c                                                 |   23 -
 net/ipv4/tcp_minisocks.c                                            |    4 
 net/ipv4/tcp_output.c                                               |    6 
 net/ipv4/udp_offload.c                                              |    2 
 net/ipv6/calipso.c                                                  |   14 -
 net/ipv6/tcp_ipv6.c                                                 |   15 -
 net/mpls/mpls_gso.c                                                 |    3 
 net/netfilter/x_tables.c                                            |    6 
 net/netlabel/netlabel_cipso_v4.c                                    |    3 
 net/qrtr/qrtr.c                                                     |    4 
 net/sched/sch_api.c                                                 |    8 
 scripts/recordmcount.c                                              |    2 
 scripts/recordmcount.pl                                             |   13 
 security/commoncap.c                                                |   12 
 sound/pci/hda/hda_bind.c                                            |    4 
 sound/pci/hda/hda_controller.c                                      |    7 
 sound/pci/hda/patch_hdmi.c                                          |   13 
 sound/usb/quirks.c                                                  |    9 
 tools/perf/util/trace-event-read.c                                  |    1 
 tools/testing/selftests/net/forwarding/mirror_gre_bridge_1d_vlan.sh |    9 
 virt/kvm/arm/mmu.c                                                  |    2 
 122 files changed, 890 insertions(+), 426 deletions(-)

Adrian Hunter (1):
      mmc: core: Fix partition switch time for eMMC

Aleksandr Miloserdov (2):
      scsi: target: core: Add cmd length set before cmd complete
      scsi: target: core: Prevent underflow for service actions

Andreas Larsson (1):
      sparc32: Limit memblock allocation to low memory

Anna-Maria Behnsen (1):
      hrtimer: Update softirq_expires_next correctly after __hrtimer_get_next_event()

Arnd Bergmann (1):
      stop_machine: mark helpers __always_inline

Artem Lapkin (1):
      drm: meson_drv add shutdown function

Athira Rajeev (1):
      powerpc/perf: Record counter overflow always if SAMPLE_IP is unset

Balazs Nemeth (2):
      net: check if protocol extracted by virtio_net_hdr_set_proto is correct
      net: avoid infinite loop in mpls_gso_segment when mpls_hlen == 0

Biju Das (2):
      media: v4l: vsp1: Fix uif null pointer access
      media: v4l: vsp1: Fix bru null pointer access

Boyang Yu (1):
      hwmon: (lm90) Fix max6658 sporadic wrong temperature reading

Chaotian Jing (1):
      mmc: mediatek: fix race condition between msdc_request_timeout and irq

Christophe JAILLET (1):
      mmc: mxs-mmc: Fix a resource leak in an error handling path in 'mxs_mmc_probe()'

Daiyue Zhang (1):
      configfs: fix a use-after-free in __configfs_open_file

Dan Carpenter (6):
      USB: gadget: u_ether: Fix a configfs return code
      staging: rtl8192u: fix ->ssid overflow in r8192_wx_set_scan()
      staging: rtl8188eu: prevent ->ssid overflow in rtw_wx_set_scan()
      staging: rtl8712: unterminated string leads to read overflow
      staging: rtl8188eu: fix potential memory corruption in rtw_check_beacon_data()
      staging: ks7010: prevent buffer overflow in ks_wlan_set_scan()

Daniel Borkmann (1):
      net: Fix gro aggregation for udp encaps with zero csum

Daniel Vetter (1):
      drm/compat: Clear bounce structures

Daniele Palmas (1):
      net: usb: qmi_wwan: allow qmimux add/del with master up

Danielle Ratson (1):
      selftests: forwarding: Fix race condition in mirror installation

Dmitry V. Levin (1):
      uapi: nfnetlink_cthelper.h: fix userspace compilation error

Eric Dumazet (3):
      tcp: annotate tp->copied_seq lockless reads
      tcp: annotate tp->write_seq lockless reads
      tcp: add sanity tests to TCP_QUEUE_SEQ

Eric Farman (1):
      s390/cio: return -EFAULT if copy_to_user() fails

Eric W. Biederman (1):
      Revert 95ebabde382c ("capabilities: Don't allow writing ambiguous v3 file capabilities")

Felix Fietkau (1):
      ath9k: fix transmitting to stations in dynamic SMPS mode

Forest Crossman (1):
      usb: xhci: Fix ASMedia ASM1042A and ASM3242 DMA addressing

Frank Li (1):
      mmc: cqhci: Fix random crash when remove mmc module/card

Geert Uytterhoeven (1):
      PCI: Fix pci_register_io_range() memory leak

Greg Kroah-Hartman (1):
      Linux 4.19.181

Guangbin Huang (1):
      net: phy: fix save wrong speed and duplex problem if autoneg is on

Heiko Carstens (1):
      s390/smp: __smp_rescan_cpus() - move cpumask away from stack

Ian Abbott (9):
      staging: comedi: addi_apci_1032: Fix endian problem for COS sample
      staging: comedi: addi_apci_1500: Fix endian problem for command sample
      staging: comedi: adv_pci1710: Fix endian problem for AI command data
      staging: comedi: das6402: Fix endian problem for AI command data
      staging: comedi: das800: Fix endian problem for AI command data
      staging: comedi: dmm32at: Fix endian problem for AI command data
      staging: comedi: me4000: Fix endian problem for AI command data
      staging: comedi: pcl711: Fix endian problem for AI command data
      staging: comedi: pcl818: Fix endian problem for AI command data

Ian Rogers (1):
      perf traceevent: Ensure read cmdlines are null terminated.

Jakub Kicinski (1):
      ethernet: alx: fix order of calls on resume

Jia-Ju Bai (2):
      net: qrtr: fix error return code of qrtr_sendmsg()
      block: rsxx: fix error return code of rsxx_pci_probe()

Joakim Zhang (4):
      can: flexcan: assert FRZ bit in flexcan_chip_freeze()
      can: flexcan: enable RX FIFO after FRZ/HALT valid
      net: stmmac: stop each tx channel independently
      net: stmmac: fix watchdog timeout during suspend/resume stress test

Joe Lawrence (1):
      scripts/recordmcount.{c,pl}: support -ffunction-sections .text.* section names

John Ernberg (1):
      ALSA: usb: Add Plantronics C320-M USB ctrl msg delay quirk

Josh Poimboeuf (1):
      x86/unwind/orc: Disable KASAN checking in the ORC unwinder, part 2

Juergen Gross (3):
      xen/events: reset affinity of 2-level event when tearing it down
      xen/events: don't unmask an event channel when an eoi is pending
      xen/events: avoid handling the same event on two cpus at the same time

Karan Singhal (1):
      USB: serial: cp210x: add ID for Acuity Brands nLight Air Adapter

Keita Suzuki (1):
      i40e: Fix memory leak in i40e_probe

Kevin(Yudong) Yang (1):
      net/mlx4_en: update moderation when config reset

Khalid Aziz (1):
      sparc64: Use arch_validate_flags() to validate ADI flag

Krzysztof Wilczyński (1):
      PCI: mediatek: Add missing of_node_put() to fix reference leak

Lee Gibson (2):
      staging: rtl8712: Fix possible buffer overflow in r8712_sitesurvey_cmd
      staging: rtl8192e: Fix possible buffer overflow in _rtl92e_wx_set_scan

Linus Torvalds (1):
      Revert "mm, slub: consider rest of partial list if acquire_slab() fails"

Lior Ribak (1):
      binfmt_misc: fix possible deadlock in bm_register_write

Lorenzo Bianconi (1):
      mt76: dma: do not report truncated frames to mac80211

Marc Zyngier (1):
      KVM: arm64: Fix exclusive limit for IPA size

Martin Kaiser (1):
      PCI: xgene-msi: Fix race in installing chained irq handler

Mathias Nyman (1):
      xhci: Improve detection of device initiated wake signal.

Matthew Wilcox (Oracle) (1):
      include/linux/sched/mm.h: use rcu_dereference in in_vfork()

Matthias Kaehlcke (1):
      usb: dwc3: qcom: Honor wakeup enabled/disabled state

Maxim Mikityanskiy (2):
      net: Introduce parse_protocol header_ops callback
      media: usbtv: Fix deadlock on suspend

Maximilian Heyne (1):
      net: sched: avoid duplicates in classes dump

Mike Christie (1):
      scsi: libiscsi: Fix iscsi_prep_scsi_cmd_pdu() error handling

Naveen N. Rao (1):
      powerpc/64s: Fix instruction encoding for lis in ppc_function_entry()

Nicholas Piggin (1):
      powerpc: improve handling of unrecoverable system reset

Niv Sardi (1):
      USB: serial: ch341: add new Product ID

Oleksij Rempel (1):
      can: skb: can_skb_set_owner(): fix ref counting if socket was closed before setting skb ownership

Oliver O'Halloran (1):
      powerpc/pci: Add ppc_md.discover_phbs()

Ondrej Mosnacek (1):
      NFSv4.2: fix return value of _nfs4_get_security_label()

Ong Boon Leong (1):
      net: stmmac: fix incorrect DMA channel intr enable setting of EQoS v4.10

Paul Cercueil (2):
      net: davicom: Fix regulator not turned off on failed probe
      net: davicom: Fix regulator not turned off on driver removal

Paul Moore (1):
      cipso,calipso: resolve a number of problems with the DOI refcounts

Paulo Alcantara (1):
      cifs: return proper error code in statfs(2)

Pavel Skripkin (1):
      USB: serial: io_edgeport: fix memory leak in edge_startup

Pete Zaitcev (1):
      USB: usblp: fix a hang in poll() if disconnected

Ruslan Bilovol (2):
      usb: gadget: f_uac2: always increase endpoint max_packet_size by one audio slot
      usb: gadget: f_uac1: stop playback on function disable

Sebastian Reichel (1):
      USB: serial: cp210x: add some more GE USB IDs

Sergey Shtylyov (3):
      sh_eth: fix TRSCER mask for SH771x
      sh_eth: fix TRSCER mask for R7S9210
      sh_eth: fix TRSCER mask for R7S72100

Shuah Khan (6):
      usbip: fix stub_dev to check for stream socket
      usbip: fix vhci_hcd to check for stream socket
      usbip: fix vudc to check for stream socket
      usbip: fix stub_dev usbip_sockfd_store() races leading to gpf
      usbip: fix vhci_hcd attach_store() races leading to gpf
      usbip: fix vudc usbip_sockfd_store races leading to gpf

Stefan Haberland (2):
      s390/dasd: fix hanging DASD driver unbind
      s390/dasd: fix hanging IO request during DASD driver unbind

Steven J. Magnani (1):
      udf: fix silent AED tagLocation corruption

Takashi Iwai (5):
      ALSA: hda/hdmi: Cancel pending works before suspend
      ALSA: hda: Drop the BATCH workaround for AMD controllers
      ALSA: hda: Avoid spurious unsol event handling during S3/S4
      ALSA: usb-audio: Fix "cannot get freq eq" errors on Dell AE515 sound bar
      ALSA: usb-audio: Apply the control quirk to Plantronics headsets

Vasily Averin (1):
      netfilter: x_tables: gpf inside xt_find_revision()

Wang Qing (1):
      s390/cio: return -EFAULT if copy_to_user() fails again

Wolfram Sang (1):
      i2c: rcar: optimize cacheline to minimize HW race condition

Xie He (1):
      net: lapbether: Remove netif_start_queue / netif_stop_queue

Yorick de Wid (1):
      Goodix Fingerprint device is not a modem

Yoshihiro Shimoda (1):
      usb: renesas_usbhs: Clear PIPECFG for re-enabling pipe with other EPNUM


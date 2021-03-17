Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E821633F673
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 18:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbhCQRTK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 13:19:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:46888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231494AbhCQRSt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Mar 2021 13:18:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C24F661490;
        Wed, 17 Mar 2021 17:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616001529;
        bh=FSKg570YivxKDe4wcWBMarxnkWIS6kT1FVPvJ/GP5sI=;
        h=From:To:Cc:Subject:Date:From;
        b=Dor15B1mBQsICUr5wBacEsAhcFmEDX8iyQSGUMuO0Q0H4hTXP96SEi/lPymcI/hgA
         l5IRIqRfgXuJHBUZItSwDNa049QLXtHgaw9QJlGzIDK4llPTcEpMWFj98jxS2lJnCc
         P19CBjsiikfi2cEYxqij6JLhhEoCoX2kwTYKCKuE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.226
Date:   Wed, 17 Mar 2021 18:18:45 +0100
Message-Id: <161600152222178@kroah.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.226 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                          |    2 
 arch/powerpc/include/asm/code-patching.h          |    2 
 arch/powerpc/kernel/traps.c                       |    5 
 arch/powerpc/perf/core-book3s.c                   |   19 ++-
 arch/s390/kernel/smp.c                            |    2 
 drivers/block/rsxx/core.c                         |    1 
 drivers/gpu/drm/drm_ioc32.c                       |   11 +
 drivers/gpu/drm/meson/meson_drv.c                 |   11 +
 drivers/hwmon/lm90.c                              |   42 ++++++-
 drivers/iio/imu/adis_buffer.c                     |    5 
 drivers/media/usb/usbtv/usbtv-audio.c             |    2 
 drivers/mmc/core/mmc.c                            |   15 +-
 drivers/mmc/host/mtk-sd.c                         |   18 +--
 drivers/mmc/host/mxs-mmc.c                        |    2 
 drivers/net/can/flexcan.c                         |   12 +-
 drivers/net/ethernet/atheros/alx/main.c           |    7 -
 drivers/net/ethernet/davicom/dm9000.c             |   21 ++-
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c   |    2 
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c    |    2 
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h      |    1 
 drivers/net/ethernet/renesas/sh_eth.c             |    5 
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c  |   19 +++
 drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c  |    4 
 drivers/net/phy/phy.c                             |    7 -
 drivers/net/usb/qmi_wwan.c                        |   14 --
 drivers/net/wan/lapbether.c                       |    3 
 drivers/net/wireless/ath/ath9k/ath9k.h            |    3 
 drivers/net/wireless/ath/ath9k/xmit.c             |    6 +
 drivers/pci/host/pci-xgene-msi.c                  |   10 -
 drivers/pci/host/pcie-mediatek.c                  |    7 -
 drivers/s390/block/dasd.c                         |    6 -
 drivers/s390/cio/vfio_ccw_ops.c                   |    6 -
 drivers/scsi/libiscsi.c                           |   11 -
 drivers/staging/comedi/drivers/addi_apci_1032.c   |    4 
 drivers/staging/comedi/drivers/addi_apci_1500.c   |   18 +--
 drivers/staging/comedi/drivers/adv_pci1710.c      |   10 -
 drivers/staging/comedi/drivers/das6402.c          |    2 
 drivers/staging/comedi/drivers/das800.c           |    2 
 drivers/staging/comedi/drivers/dmm32at.c          |    2 
 drivers/staging/comedi/drivers/me4000.c           |    2 
 drivers/staging/comedi/drivers/pcl711.c           |    2 
 drivers/staging/comedi/drivers/pcl818.c           |    2 
 drivers/staging/ks7010/ks_wlan_net.c              |    6 -
 drivers/staging/rtl8188eu/core/rtw_ap.c           |    5 
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c    |    6 -
 drivers/staging/rtl8192e/rtl8192e/rtl_wx.c        |    7 -
 drivers/staging/rtl8192u/r8192U_wx.c              |    6 -
 drivers/staging/rtl8712/rtl871x_cmd.c             |    6 -
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c     |    2 
 drivers/usb/class/cdc-acm.c                       |    5 
 drivers/usb/gadget/function/f_uac1.c              |    1 
 drivers/usb/gadget/function/f_uac2.c              |    2 
 drivers/usb/gadget/function/u_ether_configfs.h    |    5 
 drivers/usb/host/xhci-pci.c                       |    8 +
 drivers/usb/host/xhci.c                           |   16 ++
 drivers/usb/renesas_usbhs/pipe.c                  |    2 
 drivers/usb/serial/ch341.c                        |    1 
 drivers/usb/serial/cp210x.c                       |    3 
 drivers/usb/serial/io_edgeport.c                  |   26 ++--
 drivers/usb/usbip/stub_dev.c                      |   42 +++++--
 drivers/usb/usbip/vhci_sysfs.c                    |   39 +++++-
 drivers/usb/usbip/vudc_sysfs.c                    |   10 +
 drivers/xen/events/events_2l.c                    |   22 ++-
 drivers/xen/events/events_base.c                  |  132 ++++++++++++++++------
 drivers/xen/events/events_fifo.c                  |    7 -
 drivers/xen/events/events_internal.h              |   22 ++-
 fs/binfmt_misc.c                                  |   29 ++--
 fs/cifs/cifsfs.c                                  |    2 
 fs/configfs/file.c                                |    6 -
 fs/nfs/nfs4proc.c                                 |    2 
 fs/udf/inode.c                                    |    9 +
 include/linux/can/skb.h                           |    8 +
 include/linux/netdevice.h                         |   10 +
 include/linux/sched/mm.h                          |    3 
 include/linux/stop_machine.h                      |   11 +
 include/linux/virtio_net.h                        |    7 +
 include/uapi/linux/netfilter/nfnetlink_cthelper.h |    2 
 mm/slub.c                                         |    2 
 net/ipv4/cipso_ipv4.c                             |   11 -
 net/ipv4/udp_offload.c                            |    2 
 net/ipv6/calipso.c                                |   14 --
 net/mpls/mpls_gso.c                               |    3 
 net/netfilter/x_tables.c                          |    6 -
 net/netlabel/netlabel_cipso_v4.c                  |    3 
 net/sched/sch_api.c                               |    8 -
 scripts/recordmcount.c                            |    2 
 scripts/recordmcount.pl                           |   13 ++
 security/commoncap.c                              |   12 --
 sound/pci/hda/hda_bind.c                          |    4 
 sound/pci/hda/hda_controller.c                    |    7 -
 sound/pci/hda/patch_hdmi.c                        |   13 ++
 sound/usb/quirks.c                                |    1 
 tools/perf/util/trace-event-read.c                |    1 
 virt/kvm/arm/mmu.c                                |    2 
 94 files changed, 614 insertions(+), 287 deletions(-)

Adrian Hunter (1):
      mmc: core: Fix partition switch time for eMMC

Arnd Bergmann (1):
      stop_machine: mark helpers __always_inline

Artem Lapkin (1):
      drm: meson_drv add shutdown function

Athira Rajeev (1):
      powerpc/perf: Record counter overflow always if SAMPLE_IP is unset

Balazs Nemeth (2):
      net: check if protocol extracted by virtio_net_hdr_set_proto is correct
      net: avoid infinite loop in mpls_gso_segment when mpls_hlen == 0

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

Dmitry V. Levin (1):
      uapi: nfnetlink_cthelper.h: fix userspace compilation error

Eric Farman (1):
      s390/cio: return -EFAULT if copy_to_user() fails

Eric W. Biederman (1):
      Revert 95ebabde382c ("capabilities: Don't allow writing ambiguous v3 file capabilities")

Felix Fietkau (1):
      ath9k: fix transmitting to stations in dynamic SMPS mode

Forest Crossman (1):
      usb: xhci: Fix ASMedia ASM1042A and ASM3242 DMA addressing

Greg Kroah-Hartman (1):
      Linux 4.14.226

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

Jia-Ju Bai (1):
      block: rsxx: fix error return code of rsxx_pci_probe()

Joakim Zhang (3):
      can: flexcan: assert FRZ bit in flexcan_chip_freeze()
      can: flexcan: enable RX FIFO after FRZ/HALT valid
      net: stmmac: stop each tx channel independently

Joe Lawrence (1):
      scripts/recordmcount.{c,pl}: support -ffunction-sections .text.* section names

Juergen Gross (3):
      xen/events: reset affinity of 2-level event when tearing it down
      xen/events: don't unmask an event channel when an eoi is pending
      xen/events: avoid handling the same event on two cpus at the same time

Karan Singhal (1):
      USB: serial: cp210x: add ID for Acuity Brands nLight Air Adapter

Kevin(Yudong) Yang (1):
      net/mlx4_en: update moderation when config reset

Krzysztof Wilczyński (1):
      PCI: mediatek: Add missing of_node_put() to fix reference leak

Lee Gibson (2):
      staging: rtl8712: Fix possible buffer overflow in r8712_sitesurvey_cmd
      staging: rtl8192e: Fix possible buffer overflow in _rtl92e_wx_set_scan

Linus Torvalds (1):
      Revert "mm, slub: consider rest of partial list if acquire_slab() fails"

Lior Ribak (1):
      binfmt_misc: fix possible deadlock in bm_register_write

Marc Zyngier (1):
      KVM: arm64: Fix exclusive limit for IPA size

Martin Kaiser (1):
      PCI: xgene-msi: Fix race in installing chained irq handler

Mathias Nyman (1):
      xhci: Improve detection of device initiated wake signal.

Matthew Wilcox (Oracle) (1):
      include/linux/sched/mm.h: use rcu_dereference in in_vfork()

Maxim Mikityanskiy (2):
      net: Introduce parse_protocol header_ops callback
      media: usbtv: Fix deadlock on suspend

Maximilian Heyne (1):
      net: sched: avoid duplicates in classes dump

Mike Christie (1):
      scsi: libiscsi: Fix iscsi_prep_scsi_cmd_pdu() error handling

Naveen N. Rao (1):
      powerpc/64s: Fix instruction encoding for lis in ppc_function_entry()

Navid Emamdoost (1):
      iio: imu: adis16400: release allocated memory on failure

Nicholas Piggin (1):
      powerpc: improve handling of unrecoverable system reset

Niv Sardi (1):
      USB: serial: ch341: add new Product ID

Oleksij Rempel (1):
      can: skb: can_skb_set_owner(): fix ref counting if socket was closed before setting skb ownership

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

Ruslan Bilovol (2):
      usb: gadget: f_uac2: always increase endpoint max_packet_size by one audio slot
      usb: gadget: f_uac1: stop playback on function disable

Sebastian Reichel (1):
      USB: serial: cp210x: add some more GE USB IDs

Sergey Shtylyov (2):
      sh_eth: fix TRSCER mask for SH771x
      sh_eth: fix TRSCER mask for R7S72100

Shuah Khan (5):
      usbip: fix stub_dev to check for stream socket
      usbip: fix vhci_hcd to check for stream socket
      usbip: fix vudc to check for stream socket
      usbip: fix stub_dev usbip_sockfd_store() races leading to gpf
      usbip: fix vhci_hcd attach_store() races leading to gpf

Stefan Haberland (2):
      s390/dasd: fix hanging DASD driver unbind
      s390/dasd: fix hanging IO request during DASD driver unbind

Steven J. Magnani (1):
      udf: fix silent AED tagLocation corruption

Takashi Iwai (4):
      ALSA: hda/hdmi: Cancel pending works before suspend
      ALSA: hda: Drop the BATCH workaround for AMD controllers
      ALSA: hda: Avoid spurious unsol event handling during S3/S4
      ALSA: usb-audio: Fix "cannot get freq eq" errors on Dell AE515 sound bar

Vasily Averin (1):
      netfilter: x_tables: gpf inside xt_find_revision()

Wang Qing (1):
      s390/cio: return -EFAULT if copy_to_user() fails again

Xie He (1):
      net: lapbether: Remove netif_start_queue / netif_stop_queue

Yorick de Wid (1):
      Goodix Fingerprint device is not a modem

Yoshihiro Shimoda (1):
      usb: renesas_usbhs: Clear PIPECFG for re-enabling pipe with other EPNUM


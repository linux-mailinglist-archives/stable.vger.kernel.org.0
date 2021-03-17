Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB4B133F657
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 18:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbhCQRNR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 13:13:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:44482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231218AbhCQRNO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Mar 2021 13:13:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DDAC64EB6;
        Wed, 17 Mar 2021 17:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616001193;
        bh=6P7Ze0sijUOES0Rq2Vc0r3dCjN3J4b5aDMG+fElo6Fo=;
        h=From:To:Cc:Subject:Date:From;
        b=nbsONxekMgUhFBq0f5butGK/L7OkhlY8vhLxYfKAzGFzAyiiIPvFsYSvBMC14c23i
         GGybIyValvw+hsSWfj/ai6C0PrK752x+MX+AY+BnGlS+vEyQ0zGGCkuLcnyNHP1qg9
         Dvmgdy/+kJmHoWLa8PN2ySHTc4umoopuSa9sdhaQ=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.4.262
Date:   Wed, 17 Mar 2021 18:13:09 +0100
Message-Id: <161600118855228@kroah.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

I'm announcing the release of the 4.4.262 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                          |    2 
 arch/alpha/include/asm/Kbuild                     |    1 
 arch/alpha/include/asm/uaccess.h                  |   76 +-------
 arch/alpha/kernel/Makefile                        |    2 
 arch/alpha/kernel/alpha_ksyms.c                   |  102 ----------
 arch/alpha/kernel/machvec_impl.h                  |    6 
 arch/alpha/kernel/setup.c                         |    1 
 arch/alpha/lib/Makefile                           |   33 ++-
 arch/alpha/lib/callback_srm.S                     |    5 
 arch/alpha/lib/checksum.c                         |    3 
 arch/alpha/lib/clear_page.S                       |    3 
 arch/alpha/lib/clear_user.S                       |   66 ++----
 arch/alpha/lib/copy_page.S                        |    3 
 arch/alpha/lib/copy_user.S                        |  101 ++++------
 arch/alpha/lib/csum_ipv6_magic.S                  |    2 
 arch/alpha/lib/csum_partial_copy.c                |    2 
 arch/alpha/lib/dec_and_lock.c                     |    2 
 arch/alpha/lib/divide.S                           |    3 
 arch/alpha/lib/ev6-clear_page.S                   |    3 
 arch/alpha/lib/ev6-clear_user.S                   |   85 +++-----
 arch/alpha/lib/ev6-copy_page.S                    |    3 
 arch/alpha/lib/ev6-copy_user.S                    |  130 +++++--------
 arch/alpha/lib/ev6-csum_ipv6_magic.S              |    2 
 arch/alpha/lib/ev6-divide.S                       |    3 
 arch/alpha/lib/ev6-memchr.S                       |    3 
 arch/alpha/lib/ev6-memcpy.S                       |    3 
 arch/alpha/lib/ev6-memset.S                       |    7 
 arch/alpha/lib/ev67-strcat.S                      |    3 
 arch/alpha/lib/ev67-strchr.S                      |    3 
 arch/alpha/lib/ev67-strlen.S                      |    3 
 arch/alpha/lib/ev67-strncat.S                     |    3 
 arch/alpha/lib/ev67-strrchr.S                     |    3 
 arch/alpha/lib/fpreg.c                            |    7 
 arch/alpha/lib/memchr.S                           |    3 
 arch/alpha/lib/memcpy.c                           |    5 
 arch/alpha/lib/memmove.S                          |    3 
 arch/alpha/lib/memset.S                           |    7 
 arch/alpha/lib/strcat.S                           |    2 
 arch/alpha/lib/strchr.S                           |    3 
 arch/alpha/lib/strcpy.S                           |    3 
 arch/alpha/lib/strlen.S                           |    3 
 arch/alpha/lib/strncat.S                          |    3 
 arch/alpha/lib/strncpy.S                          |    3 
 arch/alpha/lib/strrchr.S                          |    3 
 arch/arm/kvm/mmu.c                                |    2 
 arch/powerpc/include/asm/code-patching.h          |    2 
 arch/powerpc/perf/core-book3s.c                   |   19 +-
 arch/s390/kernel/smp.c                            |    2 
 drivers/block/floppy.c                            |   35 ++-
 drivers/block/rsxx/core.c                         |    1 
 drivers/iio/imu/adis16400_buffer.c                |    5 
 drivers/iio/imu/adis_buffer.c                     |    5 
 drivers/media/usb/hdpvr/hdpvr-core.c              |   33 ++-
 drivers/media/usb/usbtv/usbtv-audio.c             |    2 
 drivers/mmc/core/mmc.c                            |   15 +
 drivers/mmc/host/mtk-sd.c                         |   18 +
 drivers/mmc/host/mxs-mmc.c                        |    2 
 drivers/net/can/flexcan.c                         |   12 -
 drivers/net/ethernet/davicom/dm9000.c             |   21 +-
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c   |    2 
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c    |    2 
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h      |    1 
 drivers/net/wan/lapbether.c                       |    3 
 drivers/net/wireless/ath/ath9k/ath9k.h            |    3 
 drivers/net/wireless/ath/ath9k/xmit.c             |    6 
 drivers/net/wireless/libertas/if_sdio.c           |    5 
 drivers/pci/host/pci-xgene-msi.c                  |   10 -
 drivers/s390/block/dasd.c                         |    3 
 drivers/scsi/libiscsi.c                           |   11 -
 drivers/staging/comedi/drivers/addi_apci_1032.c   |    4 
 drivers/staging/comedi/drivers/addi_apci_1500.c   |   18 -
 drivers/staging/comedi/drivers/adv_pci1710.c      |   10 -
 drivers/staging/comedi/drivers/das6402.c          |    2 
 drivers/staging/comedi/drivers/das800.c           |    2 
 drivers/staging/comedi/drivers/dmm32at.c          |    2 
 drivers/staging/comedi/drivers/me4000.c           |    2 
 drivers/staging/comedi/drivers/pcl711.c           |    2 
 drivers/staging/comedi/drivers/pcl818.c           |    2 
 drivers/staging/rtl8188eu/core/rtw_ap.c           |    5 
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c    |    6 
 drivers/staging/rtl8192e/rtl8192e/rtl_wx.c        |    7 
 drivers/staging/rtl8192u/r8192U_wx.c              |    6 
 drivers/staging/rtl8712/rtl871x_cmd.c             |    6 
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c     |    2 
 drivers/usb/class/cdc-acm.c                       |    5 
 drivers/usb/gadget/function/f_uac2.c              |    2 
 drivers/usb/host/xhci.c                           |   16 +
 drivers/usb/renesas_usbhs/pipe.c                  |    2 
 drivers/usb/serial/ch341.c                        |    1 
 drivers/usb/serial/cp210x.c                       |    3 
 drivers/usb/serial/io_edgeport.c                  |   26 +-
 drivers/usb/usbip/stub_dev.c                      |   42 +++-
 drivers/usb/usbip/vhci_sysfs.c                    |   10 -
 drivers/xen/events/events_2l.c                    |   22 +-
 drivers/xen/events/events_base.c                  |  130 ++++++++++---
 drivers/xen/events/events_fifo.c                  |    7 
 drivers/xen/events/events_internal.h              |   22 +-
 fs/cifs/cifsfs.c                                  |    2 
 fs/nfs/nfs4proc.c                                 |    2 
 include/linux/can/skb.h                           |    8 
 include/uapi/linux/netfilter/nfnetlink_cthelper.h |    2 
 kernel/futex.c                                    |  209 ++++++++++++++++++----
 mm/slub.c                                         |    2 
 net/ipv4/udp_offload.c                            |    2 
 net/netfilter/x_tables.c                          |    6 
 scripts/recordmcount.c                            |    2 
 scripts/recordmcount.pl                           |   13 +
 sound/pci/hda/hda_bind.c                          |    4 
 sound/pci/hda/patch_hdmi.c                        |   13 +
 sound/usb/quirks.c                                |    1 
 110 files changed, 893 insertions(+), 669 deletions(-)

Adrian Hunter (1):
      mmc: core: Fix partition switch time for eMMC

Al Viro (3):
      alpha: move exports to actual definitions
      alpha: get rid of tail-zeroing in __copy_user()
      alpha: switch __copy_user() and __do_clean_user() to normal calling conventions

Allen Pais (1):
      libertas: fix a potential NULL pointer dereference

Arvind Yadav (1):
      media: hdpvr: Fix an error handling path in hdpvr_probe()

Athira Rajeev (1):
      powerpc/perf: Record counter overflow always if SAMPLE_IP is unset

Chaotian Jing (1):
      mmc: mediatek: fix race condition between msdc_request_timeout and irq

Christophe JAILLET (1):
      mmc: mxs-mmc: Fix a resource leak in an error handling path in 'mxs_mmc_probe()'

Dan Carpenter (4):
      staging: rtl8192u: fix ->ssid overflow in r8192_wx_set_scan()
      staging: rtl8188eu: prevent ->ssid overflow in rtw_wx_set_scan()
      staging: rtl8712: unterminated string leads to read overflow
      staging: rtl8188eu: fix potential memory corruption in rtw_check_beacon_data()

Daniel Borkmann (1):
      net: Fix gro aggregation for udp encaps with zero csum

Dmitry V. Levin (1):
      uapi: nfnetlink_cthelper.h: fix userspace compilation error

Felix Fietkau (1):
      ath9k: fix transmitting to stations in dynamic SMPS mode

Greg Kroah-Hartman (1):
      Linux 4.4.262

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

Jia-Ju Bai (1):
      block: rsxx: fix error return code of rsxx_pci_probe()

Jiri Kosina (1):
      floppy: fix lock_fdc() signal handling

Joakim Zhang (2):
      can: flexcan: assert FRZ bit in flexcan_chip_freeze()
      can: flexcan: enable RX FIFO after FRZ/HALT valid

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

Lee Gibson (2):
      staging: rtl8712: Fix possible buffer overflow in r8712_sitesurvey_cmd
      staging: rtl8192e: Fix possible buffer overflow in _rtl92e_wx_set_scan

Linus Torvalds (1):
      Revert "mm, slub: consider rest of partial list if acquire_slab() fails"

Marc Zyngier (1):
      KVM: arm64: Fix exclusive limit for IPA size

Martin Kaiser (1):
      PCI: xgene-msi: Fix race in installing chained irq handler

Masahiro Yamada (3):
      alpha: add $(src)/ rather than $(obj)/ to make source file path
      alpha: merge build rules of division routines
      alpha: make short build log available for division routines

Mathias Nyman (1):
      xhci: Improve detection of device initiated wake signal.

Maxim Mikityanskiy (1):
      media: usbtv: Fix deadlock on suspend

Mike Christie (1):
      scsi: libiscsi: Fix iscsi_prep_scsi_cmd_pdu() error handling

Naveen N. Rao (1):
      powerpc/64s: Fix instruction encoding for lis in ppc_function_entry()

Navid Emamdoost (2):
      iio: imu: adis16400: release allocated memory on failure
      iio: imu: adis16400: fix memory leak

Niv Sardi (1):
      USB: serial: ch341: add new Product ID

Oleksij Rempel (1):
      can: skb: can_skb_set_owner(): fix ref counting if socket was closed before setting skb ownership

Ondrej Mosnacek (1):
      NFSv4.2: fix return value of _nfs4_get_security_label()

Paul Cercueil (2):
      net: davicom: Fix regulator not turned off on failed probe
      net: davicom: Fix regulator not turned off on driver removal

Paulo Alcantara (1):
      cifs: return proper error code in statfs(2)

Pavel Skripkin (1):
      USB: serial: io_edgeport: fix memory leak in edge_startup

Peter Zijlstra (1):
      futex: Change locking rules

Richard Henderson (1):
      alpha: Package string routines together

Ruslan Bilovol (1):
      usb: gadget: f_uac2: always increase endpoint max_packet_size by one audio slot

Sebastian Reichel (1):
      USB: serial: cp210x: add some more GE USB IDs

Shuah Khan (3):
      usbip: fix stub_dev to check for stream socket
      usbip: fix vhci_hcd to check for stream socket
      usbip: fix stub_dev usbip_sockfd_store() races leading to gpf

Stefan Haberland (1):
      s390/dasd: fix hanging DASD driver unbind

Takashi Iwai (3):
      ALSA: hda/hdmi: Cancel pending works before suspend
      ALSA: hda: Avoid spurious unsol event handling during S3/S4
      ALSA: usb-audio: Fix "cannot get freq eq" errors on Dell AE515 sound bar

Thomas Gleixner (2):
      futex: Cure exit race
      futex: fix dead code in attach_to_pi_owner()

Vasily Averin (1):
      netfilter: x_tables: gpf inside xt_find_revision()

Xie He (1):
      net: lapbether: Remove netif_start_queue / netif_stop_queue

Yorick de Wid (1):
      Goodix Fingerprint device is not a modem

Yoshihiro Shimoda (1):
      usb: renesas_usbhs: Clear PIPECFG for re-enabling pipe with other EPNUM


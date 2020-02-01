Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1766B14F776
	for <lists+stable@lfdr.de>; Sat,  1 Feb 2020 10:57:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbgBAJ5e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Feb 2020 04:57:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:38960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726213AbgBAJ5e (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Feb 2020 04:57:34 -0500
Received: from localhost (unknown [83.216.75.91])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0A96206D3;
        Sat,  1 Feb 2020 09:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580551053;
        bh=PjefGEyoz0DWsqsg8zWToWx2OgN54bHy7QZvPUHenoU=;
        h=Date:From:To:Cc:Subject:From;
        b=GAS2QVDodWKeMYPxeud7/4xqI78jukrau1yKzrPfFbwSNZFzu5dZkYq5n/i7yzi8w
         1bcSkQbgahAUrpYT4RJkmsvSl+imUTW5C908OWul36ol1BKslK9dl66fHe0EN8Z7UD
         M5byX11nQ6m/SXj8kzmL6mHfCVNVOX32tI5ELGEA=
Date:   Sat, 1 Feb 2020 09:57:18 +0000
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.101
Message-ID: <20200201095718.GA2305395@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="zhXaljGHf11kAtnf"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.101 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                               |    2=20
 arch/arc/plat-eznps/Kconfig                            |    2=20
 arch/arm64/kvm/debug.c                                 |    6=20
 block/blk-lib.c                                        |   23 --
 crypto/af_alg.c                                        |    6=20
 drivers/atm/eni.c                                      |    4=20
 drivers/base/component.c                               |    8=20
 drivers/char/random.c                                  |   62 ++++++
 drivers/crypto/chelsio/chcr_algo.c                     |   16 -
 drivers/gpio/Kconfig                                   |    1=20
 drivers/hid/hid-ids.h                                  |    3=20
 drivers/hid/hid-ite.c                                  |    3=20
 drivers/hid/hid-multitouch.c                           |    5=20
 drivers/hid/hid-quirks.c                               |    1=20
 drivers/hid/hid-steam.c                                |    4=20
 drivers/hid/i2c-hid/i2c-hid-core.c                     |   16 +
 drivers/iio/gyro/st_gyro_core.c                        |   75 ++++++++
 drivers/iommu/amd_iommu.c                              |   37 +++-
 drivers/misc/mei/hw-me-regs.h                          |    4=20
 drivers/misc/mei/pci-me.c                              |    2=20
 drivers/net/ethernet/broadcom/b44.c                    |    9 -
 drivers/net/wan/sdla.c                                 |    2=20
 drivers/net/wireless/ath/ath9k/hif_usb.c               |    2=20
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c |    4=20
 drivers/net/wireless/intersil/orinoco/orinoco_usb.c    |    4=20
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |    2=20
 drivers/net/wireless/rsi/rsi_91x_hal.c                 |   12 -
 drivers/net/wireless/rsi/rsi_91x_usb.c                 |   19 +-
 drivers/net/wireless/zydas/zd1211rw/zd_usb.c           |    2=20
 drivers/pci/quirks.c                                   |   34 +++
 drivers/phy/motorola/phy-cpcap-usb.c                   |   18 +-
 drivers/phy/qualcomm/phy-qcom-qmp.c                    |    2=20
 drivers/platform/x86/dell-laptop.c                     |   26 ++
 drivers/spi/spi-dw.c                                   |   15 +
 drivers/spi/spi-dw.h                                   |    1=20
 drivers/staging/most/net/net.c                         |   10 +
 drivers/staging/vt6656/device.h                        |    2=20
 drivers/staging/vt6656/int.c                           |    6=20
 drivers/staging/vt6656/main_usb.c                      |    1=20
 drivers/staging/vt6656/rxtx.c                          |   26 +-
 drivers/staging/wlan-ng/prism2mgmt.c                   |    2=20
 drivers/tty/serial/8250/8250_bcm2835aux.c              |    2=20
 drivers/usb/dwc3/core.c                                |    3=20
 drivers/usb/dwc3/dwc3-pci.c                            |    4=20
 drivers/usb/serial/ir-usb.c                            |  136 +++++++++++-=
---
 drivers/usb/storage/unusual_uas.h                      |    7=20
 drivers/watchdog/Kconfig                               |    1=20
 drivers/watchdog/rn5t618_wdt.c                         |    1=20
 fs/cifs/smb2misc.c                                     |    2=20
 include/linux/power/smartreflex.h                      |    3=20
 include/linux/usb/irda.h                               |   13 +
 include/net/pkt_cls.h                                  |   33 ++-
 include/net/sch_generic.h                              |    3=20
 kernel/sched/fair.c                                    |  153 ++++++++++--=
-----
 net/sched/cls_basic.c                                  |   11 -
 net/sched/cls_bpf.c                                    |   11 -
 net/sched/cls_flower.c                                 |   11 -
 net/sched/cls_fw.c                                     |   11 -
 net/sched/cls_matchall.c                               |   11 -
 net/sched/cls_route.c                                  |   11 -
 net/sched/cls_rsvp.h                                   |   11 -
 net/sched/cls_tcindex.c                                |   11 -
 net/sched/cls_u32.c                                    |   11 -
 net/sched/ematch.c                                     |    3=20
 net/sched/sch_api.c                                    |    6=20
 65 files changed, 709 insertions(+), 239 deletions(-)

Aaron Ma (1):
      HID: multitouch: Add LG MELF0410 I2C touchscreen support

Andreas Kemnade (1):
      watchdog: rn5t618_wdt: fix module aliases

Andrew Murray (1):
      KVM: arm64: Write arch.mdcr_el2 changes since last vcpu_load on VHE

Andrey Shvetsov (1):
      staging: most: net: fix buffer overflow

Andy Shevchenko (1):
      iio: st_gyro: Correct data for LSM9DS0 gyro

Arnd Bergmann (1):
      atm: eni: fix uninitialized variable warning

Ben Dooks (1):
      ARM: OMAP2+: SmartReflex: add omap_sr_pdata definition

Bin Liu (1):
      usb: dwc3: turn off VBUS when leaving host mode

Bjorn Andersson (1):
      phy: qcom-qmp: Increase PHY ready timeout

Colin Ian King (1):
      staging: wlan-ng: ensure error return is actually returned

Cong Wang (1):
      net_sched: fix ops->bind_class() implementations

Dave Chinner (1):
      block: fix 32 bit overflow in __blkdev_issue_discard()

David Engraf (1):
      watchdog: max77620_wdt: fix potential build errors

Dmitry Osipenko (1):
      gpio: max77620: Add missing dependency on GPIOLIB_IRQCHIP

Eric Biggers (1):
      crypto: chelsio - fix writing tfm flags to wrong place

Eric Dumazet (1):
      net_sched: ematch: reject invalid TCF_EM_SIMPLE

Fenghua Yu (1):
      drivers/net/b44: Change to non-atomic bit operations on pwol_mask

Greg Kroah-Hartman (1):
      Linux 4.19.101

Hans de Goede (1):
      HID: ite: Add USB id match for Acer SW5-012 keyboard dock

Heikki Krogerus (1):
      usb: dwc3: pci: add ID for the Intel Comet Lake -V variant

Herbert Xu (1):
      crypto: af_alg - Use bh_lock_sock in sk_destruct

Johan Hovold (12):
      orinoco_usb: fix interface sanity check
      rsi_91x_usb: fix interface sanity check
      USB: serial: ir-usb: add missing endpoint sanity check
      USB: serial: ir-usb: fix link-speed handling
      USB: serial: ir-usb: fix IrLAP framing
      ath9k: fix storage endpoint lookup
      brcmfmac: fix interface sanity check
      rtl8xxxu: fix interface sanity check
      zd1211rw: fix storage endpoint lookup
      rsi: fix use-after-free on probe errors
      rsi: fix memory leak on failed URB submission
      rsi: fix non-atomic allocation in completion handler

Krzysztof Kozlowski (1):
      net: wan: sdla: Fix cast from pointer to integer of different size

Laura Abbott (1):
      usb-storage: Disable UAS on JMicron SATA enclosure

Linus Torvalds (1):
      random: try to actively add entropy rather than passively wait for it

Logan Gunthorpe (1):
      iommu/amd: Support multiple PCI DMA aliases in IRQ Remapping

Lubomir Rintel (1):
      component: do not dereference opaque pointer in debugfs

Lukas Wunner (1):
      serial: 8250_bcm2835aux: Fix line mismatch on driver unbind

Malcolm Priestley (3):
      staging: vt6656: correct packet types for CTS protect, mode.
      staging: vt6656: use NULLFUCTION stack on mac80211
      staging: vt6656: Fix false Tx excessive retries reporting.

Ming Lei (1):
      block: cleanup __blkdev_issue_discard()

Pacien TRAN-GIRARD (1):
      platform/x86: dell-laptop: disable kbd backlight on Inspiron 10xx

Pan Zhang (1):
      drivers/hid/hid-multitouch.c: fix a possible null pointer access.

Paulo Alcantara (SUSE) (1):
      cifs: Fix memory allocation in __smb2_handle_cancelled_cmd()

Pavel Balan (1):
      HID: Add quirk for incorrect input length on Lenovo Y720

Peter Zijlstra (1):
      sched/fair: Add tmp_alone_branch assertion

Priit Laes (1):
      HID: Add quirk for Xin-Mo Dual Controller

Randy Dunlap (1):
      arc: eznps: fix allmodconfig kconfig warning

Rodrigo Rivas Costa (1):
      HID: steam: Fix input device disappearing

Slawomir Pawlowski (1):
      PCI: Add DMA alias quirk for Intel VCA NTB

Tomas Winkler (1):
      mei: me: add comet point (lake) H device ids

Tony Lindgren (1):
      phy: cpcap-usb: Prevent USB line glitches from waking up modem

Vincent Guittot (1):
      sched/fair: Fix insertion in rq->leaf_cfs_rq_list

wuxu.wu (1):
      spi: spi-dw: Add lock protect dw_spi rx/tx to prevent concurrent calls


--zhXaljGHf11kAtnf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl41S34ACgkQONu9yGCS
aT6etw/9Gb97P/KHQ72t+B0xxIUYUI3YMAuywnHSBz3M1/YOuZf+X+m+Zg8fk6Js
9XEN6/SOEIf/745+kSs3Hxoi+9KL/+Wta6mZcQVegCHUD9sts9Tg8ok3UTVml+BZ
citoIi87sauMl0TnfImBW3P9i1DG/5uhQAfdasun5qcx+NGSNQS5a+A0IfVuZTLC
vG7TNgecgNmsorrQcyjOa8B6MNmNvXStVJ42Q+G+wflYRq3nYSrNXGU06v8mddxA
qzFAQUpXxsByYp43HeylcuhhkhWT8JsOmybNgHIWlwX6v3dSMuGYTcngpQtAxfas
X6x4i80aWyGhQ0/l2eO/oyiW3WdhLf0sYMcoOcpWDymD6MxnBMYeIOkUT1mVWFbo
PWuBrjZ0IWc3EqBxxPc7IdNARkB6qyrUcjyUjT1F01y8UO9ah0fOaKeHoTBFFKTZ
ES7OBNLuTpw1MJiyFEHGndE4RN4C1SF5dRdjpY+pCTYMuh4JeNNYU+gVRnEX1CUA
iNs2dYiSK9fbibeB/3zbW0OuCBznvChGHQfYcPNcNT3a10SNYpDMVogFjmF2P3OF
9OLqSMTzw1l73f9CobwbsiaZWEw/YasC1gstxEI1OVnD3XfOi8pdDdAAicu6L6Uy
QI/fgwZGDUKm+VTsYRsW7+uUaXfjFZJHNmg9Qw5t8Mz3HouWY20=
=DkW4
-----END PGP SIGNATURE-----

--zhXaljGHf11kAtnf--

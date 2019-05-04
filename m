Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 801D31383E
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 10:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725819AbfEDIU3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 04:20:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:33916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725808AbfEDIU3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 4 May 2019 04:20:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B8132084A;
        Sat,  4 May 2019 08:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556958027;
        bh=JvOlgXk4rTspvcfPv3tVGWQTBXVEM+BOxAY9ZioxEeg=;
        h=Date:From:To:Cc:Subject:From;
        b=080UvskP4IR8npVzZF9crbUhdmm9oBfEzrl2/AiPCLXCMECZ/ebe1DFnKhrxH+Xnz
         j38ZlMnu37tIwQMocSwRK2ouwkTfgGP0/IiNjuf1TPssNEV/UXBWi26ISbdh3dokI9
         QGoMCDlp5vaebyosqFsK9sfHSx5fa9EvVm1Fozm0=
Date:   Sat, 4 May 2019 10:20:25 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.116
Message-ID: <20190504082025.GA26822@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
Content-Disposition: inline
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.14.116 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.14.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                            |    2=20
 arch/arm/boot/dts/bcm2835-rpi-b-rev2.dts            |    2=20
 arch/arm/boot/dts/imx6qdl-icore-rqs.dtsi            |    4 -
 arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi        |    1=20
 arch/s390/include/asm/elf.h                         |   11 +++-
 drivers/ata/libata-zpodd.c                          |   34 ++++++++++-----
 drivers/gpio/gpio-aspeed.c                          |    2=20
 drivers/gpio/gpiolib-of.c                           |    8 +++
 drivers/gpu/drm/meson/meson_drv.c                   |    9 ++--
 drivers/iommu/amd_iommu.c                           |    9 ++--
 drivers/iommu/amd_iommu_init.c                      |    7 +--
 drivers/iommu/amd_iommu_types.h                     |    2=20
 drivers/leds/leds-pca9532.c                         |    8 ++-
 drivers/net/ethernet/cadence/macb_main.c            |   10 +++-
 drivers/net/ethernet/ibm/ehea/ehea_main.c           |    1=20
 drivers/net/ethernet/micrel/ks8851.c                |   36 ++++++++--------
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c |    2=20
 drivers/net/ethernet/ti/netcp_ethss.c               |    8 ++-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c   |    2=20
 drivers/net/usb/ipheth.c                            |   33 ++++++++++----
 drivers/s390/net/qeth_l3_main.c                     |    4 +
 drivers/s390/scsi/zfcp_fc.c                         |   21 +++++++--
 drivers/scsi/qla4xxx/ql4_os.c                       |    2=20
 drivers/staging/rtl8188eu/core/rtw_xmit.c           |    9 +++-
 drivers/staging/rtl8188eu/include/rtw_xmit.h        |    2=20
 drivers/staging/rtl8712/rtl8712_cmd.c               |   10 ----
 drivers/staging/rtl8712/rtl8712_cmd.h               |    2=20
 drivers/staging/rtl8723bs/core/rtw_xmit.c           |   14 +++---
 drivers/staging/rtl8723bs/include/rtw_xmit.h        |    2=20
 drivers/staging/rtlwifi/phydm/rtl_phydm.c           |    2=20
 drivers/staging/rtlwifi/rtl8822be/fw.c              |    2=20
 drivers/tty/serial/ar933x_uart.c                    |   24 +++-------
 drivers/tty/serial/sc16is7xx.c                      |   12 ++++-
 drivers/usb/gadget/udc/net2272.c                    |    1=20
 drivers/usb/gadget/udc/net2280.c                    |    8 +--
 drivers/usb/host/u132-hcd.c                         |    3 +
 drivers/usb/misc/usb251xb.c                         |    2=20
 fs/ceph/inode.c                                     |    2=20
 fs/fuse/dev.c                                       |   12 ++---
 fs/nfs/client.c                                     |    2=20
 fs/pipe.c                                           |    4 -
 fs/splice.c                                         |   12 ++++-
 include/linux/mm.h                                  |   15 ++++++
 include/linux/pipe_fs_i.h                           |   10 ++--
 include/linux/sched/signal.h                        |   18 ++++++++
 include/net/tc_act/tc_gact.h                        |    2=20
 kernel/ptrace.c                                     |   15 +++++-
 kernel/trace/trace.c                                |    6 ++
 mm/gup.c                                            |   45 +++++++++++++++=
-----
 mm/hugetlb.c                                        |   13 +++++
 net/bridge/br_netfilter_hooks.c                     |    1=20
 net/bridge/br_netfilter_ipv6.c                      |    2=20
 net/netfilter/nft_set_rbtree.c                      |    7 +--
 scripts/kconfig/lxdialog/inputbox.c                 |    3 -
 scripts/kconfig/nconf.c                             |    2=20
 scripts/kconfig/nconf.gui.c                         |    3 -
 scripts/selinux/genheaders/genheaders.c             |    1=20
 scripts/selinux/mdp/mdp.c                           |    1=20
 security/selinux/include/classmap.h                 |    1=20
 virt/kvm/arm/vgic/vgic-its.c                        |   13 ++++-
 60 files changed, 346 insertions(+), 155 deletions(-)

Aditya Pakki (5):
      qlcnic: Avoid potential NULL pointer dereference
      staging: rtl8188eu: Fix potential NULL pointer dereference of kcalloc
      staging: rtlwifi: rtl8822b: fix to avoid potential NULL pointer deref=
erence
      staging: rtlwifi: Fix potential NULL pointer dereference of kzalloc
      usb: usb251xb: fix to avoid potential NULL pointer dereference

Al Viro (1):
      ceph: fix use-after-free on symlink traversal

Alexander Kappner (1):
      usbnet: ipheth: prevent TX queue timeouts when device not ready

Andrei Vagin (1):
      ptrace: take into account saved_sigmask in PTRACE{GET,SET}SIGMASK

Changbin Du (1):
      kconfig/[mn]conf: handle backspace (^H) key

Dan Carpenter (1):
      staging: rtl8712: uninitialized memory in read_bbreg_hdl()

Davide Caratti (1):
      net/sched: don't dereference a->goto_chain to read the chain index

Geert Uytterhoeven (1):
      gpio: of: Fix of_gpiochip_add() error path

Greg Kroah-Hartman (1):
      Linux 4.14.116

Guido Kiener (3):
      usb: gadget: net2280: Fix overrun of OUT messages
      usb: gadget: net2280: Fix net2280_dequeue()
      usb: gadget: net2272: Fix net2272_dequeue()

Gustavo A. R. Silva (1):
      usbnet: ipheth: fix potential null pointer dereference in ipheth_carr=
ier_set

Harini Katakam (1):
      net: macb: Add null check for PCLK and HCLK

Helen Koike (1):
      ARM: dts: bcm283x: Fix hdmi hpd gpio pull

Jean-Philippe Brucker (2):
      drm/meson: Fix invalid pointer in meson_drv_unbind()
      drm/meson: Uninstall IRQ handler

Joerg Roedel (1):
      iommu/amd: Reserve exclusion range in iova-domain

Julian Wiedmann (1):
      s390/qeth: fix race when initializing the IP address table

Kangjie Lu (3):
      gpio: aspeed: fix a potential NULL pointer dereference
      scsi: qla4xxx: fix a potential NULL pointer dereference
      leds: pca9532: fix a potential NULL pointer dereference

Linus Torvalds (3):
      mm: make page ref count overflow check tighter and more explicit
      mm: add 'try_get_page()' helper function
      mm: prevent get_user_pages() from overflowing page refcount

Lukas Wunner (4):
      net: ks8851: Dequeue RX packets explicitly
      net: ks8851: Reassert reset pin if chip ID check fails
      net: ks8851: Delay requesting IRQ until opened
      net: ks8851: Set initial carrier state to down

Mao Wenan (1):
      sc16is7xx: missing unregister/delete driver on error in sc16is7xx_ini=
t()

Marc Zyngier (1):
      KVM: arm/arm64: vgic-its: Take the srcu lock when parsing the memslots

Marco Felsch (1):
      ARM: dts: pfla02: increase phy reset duration

Martin Schwidefsky (1):
      s390: limit brk randomization to 32MB

Masanari Iida (1):
      ARM: dts: imx6qdl: Fix typo in imx6qdl-icore-rqs.dtsi

Matthew Wilcox (1):
      fs: prevent page refcount overflow in pipe_buf_get

Mukesh Ojha (1):
      usb: u132-hcd: fix resource leak

Pablo Neira Ayuso (1):
      netfilter: nft_set_rbtree: check for inactive element after flag mism=
atch

Paulo Alcantara (1):
      selinux: use kernel linux/socket.h for genheaders and mdp

Petr =C5=A0tetiar (1):
      serial: ar933x_uart: Fix build failure with disabled console

Steffen Maier (1):
      scsi: zfcp: reduce flood of fcrscn1 trace records on multi-element RS=
CN

Trond Myklebust (1):
      NFS: Fix a typo in nfs_init_timeout_values()

Wen Yang (3):
      net: xilinx: fix possible object reference leak
      net: ibm: fix possible object reference leak
      net: ethernet: ti: fix possible object reference leak

Xin Long (1):
      netfilter: bridge: set skb transport_header before entering NF_INET_P=
RE_ROUTING

raymond pang (1):
      libata: fix using DMA buffers on stack


--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAlzNS0kACgkQONu9yGCS
aT57CxAAsV9ovIkZVFK47ok1037NONNfJrY04gC3WN/NolvHj0Vs1zWUt938iCoV
lTqbgR0bDropwwZGRe1pUOhvcEiUOaHK8xkSvqpDRAaAYpWpoi63Q3mRTEyd1qHN
lrDBmEv7U4wVlhEoKyXK+PgPifSrCeKn1STIjA4S3jVYw128yW48xO5Gumka6Eda
d/lZtdqZZifUzaNrniWUGvsMfWD150UQE29VYmTzlV+u8O3y+gTB+wH+e7Ebeb8m
d8T3UBUxmfYzIZf8a3CZASgczkbNxRpe89126tviWQizH/bWa3grJHQB7Lb1GrwT
Z4WXbrH00H95gO01zSlkvTbENba5l+x0Tu4S2+Qmg+De6g2d2emEK7skyapoNiA8
DrjFwZWBa1l30y8iV5K8ZRthrYeop6g1tpquba9iIV4kYbImQEnKVXcYL4jba61Q
7aHnPj4Mtr5plJhxX/EqCBnG4K2loB+cn1U8j1GAuBiJXpIWFbQB2+BxPnUuzjRI
58SPukpovcAbP2zHxjFAWDceX3HdxXpnF72Zi5HiRnl5lBWm8I/9UzqRPCAFbHc4
7A8nHFQHqfLD3G54tlqptO4frvJBKSkTztkZYQ5GIcK/hqdzhB/ImMKyWUDFMNHs
fdbGGRBSM2BmyKrHmQzdAhCiuWJ+x3H7nYI2ZaZOXmtP7yCYbH4=
=2PgI
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--

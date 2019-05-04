Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1963F1383A
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 10:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725850AbfEDIUM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 04:20:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:33706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725819AbfEDIUL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 4 May 2019 04:20:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 937D92084A;
        Sat,  4 May 2019 08:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556958010;
        bh=o3kG/hfCv1ccdOuvTxjhloIJO5yP1qGbRQXc+0vS9pM=;
        h=Date:From:To:Cc:Subject:From;
        b=zMMG9nSUFBnB3BuExykhz0pBLUSr1qbFSLnSsg9sPxWDgbGgTCfcTdd3MsCrPao1o
         TFBJV23TDP7BV8NPIHLP2UpJ8dLQ4vehTPZA6ZXcqJIsP3a4UeKBVRCUrMbcg8wssp
         q+3JN+tIASQE5gx4gGhb2o/X0XMRBenFgRMawSh8=
Date:   Sat, 4 May 2019 10:20:07 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.9.173
Message-ID: <20190504082007.GA15253@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="AhhlLboLdkugWU4S"
Content-Disposition: inline
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.9.173 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.9.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                            |    2 -
 arch/arm/boot/dts/bcm2835-rpi-b-rev2.dts            |    2 -
 arch/arm/boot/dts/imx6qdl-phytec-pfla02.dtsi        |    1=20
 arch/s390/include/asm/elf.h                         |   11 +++---
 drivers/ata/libata-zpodd.c                          |   34 +++++++++++++--=
---
 drivers/gpio/gpiolib-of.c                           |    8 +++-
 drivers/leds/leds-pca9532.c                         |    8 +++-
 drivers/media/platform/vivid/vivid-vid-common.c     |    3 +
 drivers/net/ethernet/ibm/ehea/ehea_main.c           |    1=20
 drivers/net/ethernet/micrel/ks8851.c                |   36 ++++++++++-----=
-----
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c |    2 +
 drivers/net/ethernet/ti/netcp_ethss.c               |    8 +++-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c   |    2 +
 drivers/net/usb/ipheth.c                            |   33 +++++++++++++--=
---
 drivers/s390/scsi/zfcp_fc.c                         |   21 +++++++++--
 drivers/scsi/qla4xxx/ql4_os.c                       |    2 +
 drivers/staging/rtl8712/rtl8712_cmd.c               |   10 -----
 drivers/staging/rtl8712/rtl8712_cmd.h               |    2 -
 drivers/tty/serial/ar933x_uart.c                    |   24 ++++---------
 drivers/tty/serial/sc16is7xx.c                      |   12 +++++-
 drivers/usb/gadget/udc/net2272.c                    |    1=20
 drivers/usb/gadget/udc/net2280.c                    |    8 +---
 drivers/usb/host/u132-hcd.c                         |    3 +
 drivers/vfio/vfio_iommu_type1.c                     |   14 +++++++
 fs/ceph/inode.c                                     |    2 -
 fs/nfs/client.c                                     |    2 -
 net/bridge/br_netfilter_hooks.c                     |    1=20
 net/bridge/br_netfilter_ipv6.c                      |    2 +
 net/netfilter/nft_set_rbtree.c                      |    7 +--
 scripts/kconfig/lxdialog/inputbox.c                 |    3 +
 scripts/kconfig/nconf.c                             |    2 -
 scripts/kconfig/nconf.gui.c                         |    3 +
 32 files changed, 175 insertions(+), 95 deletions(-)

Aditya Pakki (1):
      qlcnic: Avoid potential NULL pointer dereference

Al Viro (1):
      ceph: fix use-after-free on symlink traversal

Alex Williamson (1):
      vfio/type1: Limit DMA mappings per container

Alexander Kappner (1):
      usbnet: ipheth: prevent TX queue timeouts when device not ready

Changbin Du (1):
      kconfig/[mn]conf: handle backspace (^H) key

Dan Carpenter (1):
      staging: rtl8712: uninitialized memory in read_bbreg_hdl()

Geert Uytterhoeven (1):
      gpio: of: Fix of_gpiochip_add() error path

Greg Kroah-Hartman (1):
      Linux 4.9.173

Guido Kiener (3):
      usb: gadget: net2280: Fix overrun of OUT messages
      usb: gadget: net2280: Fix net2280_dequeue()
      usb: gadget: net2272: Fix net2272_dequeue()

Gustavo A. R. Silva (1):
      usbnet: ipheth: fix potential null pointer dereference in ipheth_carr=
ier_set

Hans Verkuil (1):
      media: vivid: check if the cec_adapter is valid

Helen Koike (1):
      ARM: dts: bcm283x: Fix hdmi hpd gpio pull

Kangjie Lu (2):
      scsi: qla4xxx: fix a potential NULL pointer dereference
      leds: pca9532: fix a potential NULL pointer dereference

Lukas Wunner (4):
      net: ks8851: Dequeue RX packets explicitly
      net: ks8851: Reassert reset pin if chip ID check fails
      net: ks8851: Delay requesting IRQ until opened
      net: ks8851: Set initial carrier state to down

Mao Wenan (1):
      sc16is7xx: missing unregister/delete driver on error in sc16is7xx_ini=
t()

Marco Felsch (1):
      ARM: dts: pfla02: increase phy reset duration

Martin Schwidefsky (1):
      s390: limit brk randomization to 32MB

Mukesh Ojha (1):
      usb: u132-hcd: fix resource leak

Pablo Neira Ayuso (1):
      netfilter: nft_set_rbtree: check for inactive element after flag mism=
atch

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


--AhhlLboLdkugWU4S
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAlzNSzMACgkQONu9yGCS
aT657Q//YFhX8e8Rc0DnLo15Npqn37FU13NnDdcaAWFCJ3e0GSocQPZHU63xptkv
EE3gfCT0WEOZvzj4ORAljXabpwzx8zeL93tkTM5ZoCW99xPFTHDM+jjpfvjD8fnh
MnPng0AgTKXMarvz+Tx8IDChq0N2Xvj4yIg9yJj9FNITDWkR0VN6buhZaAp8G5lc
pzADigoUO9NtMc1IEsQPEmgtJshRGClTScY73hvvulXVE0wyXUcVvypNi78GZbRI
oA6Md1tlbqLYhsyLLCjNxrev2qL+ROfA8hUTCg8JIT7cqXvga8Qo4PxMeQoxXUY8
/X9ZXlimK5qAk2h6CeNuQ8NYEktKK5y3+LoIVq27hgb7U7TieZBqcXgn5mohuxdX
/lkF+9NJoL/w9Sclu0qT49CgEOsx8aIv1O2gwfpkCSqdfR/B5ia3PJPKjkPqTmwU
KBa3kJFST234pTPUBrfh47DQwWx1uK9S08+n6sZslpqn5yXwsvSPih01ZOJ/LPWf
stGNwA5oJURvLgAfqpd8qhzn7CjABQtUbESrAwViimSh8wqt2K57rV1WHuHFFkd9
JiDDFiBFJsNj6L4BAZVHdsNKt71wB4tANEB9Z/yoW7DZjtRzriOJTJEPlM4Wb6DO
PARlWZqqMjLnbXGDdZWit6TIK12np1kVgZLShulWYqcnrfWQw7Q=
=Rdkh
-----END PGP SIGNATURE-----

--AhhlLboLdkugWU4S--

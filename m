Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 870121288A1
	for <lists+stable@lfdr.de>; Sat, 21 Dec 2019 11:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbfLUKle (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Dec 2019 05:41:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:47910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726098AbfLUKl3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 21 Dec 2019 05:41:29 -0500
Received: from localhost (unknown [38.98.37.136])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E1C421927;
        Sat, 21 Dec 2019 10:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576924888;
        bh=/bDFaSuN6t71N+dn2E8XSAmjoaOI08E1pwYFZ1bhxZs=;
        h=Date:From:To:Cc:Subject:From;
        b=vp9nIDwSSGcg9DxbxOtxnLEWvKwOCE8xb3Y5CjEDps4cyoKlkzox9zaz0BsQtUQoi
         EQgihORHDvikGSlpHxuA43wqhRP02LsCg4rLlPqXV8B+Yhuu6K6Ow3Qp1LipZc3W3Y
         nfoHrxT6VkSKAphCWxXyhpkqoDdv3zb2qoigj1v8=
Date:   Sat, 21 Dec 2019 11:40:57 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.160
Message-ID: <20191221104057.GA61719@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="TB36FDmn/VVEgNH/"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.14.160 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                           |    2=20
 arch/arm/boot/dts/s3c6410-mini6410.dts             |    4 +
 arch/arm/boot/dts/s3c6410-smdk6410.dts             |    4 +
 arch/arm/mach-tegra/reset-handler.S                |    6 +-
 arch/xtensa/mm/tlb.c                               |    4 -
 drivers/dma-buf/sync_file.c                        |    2=20
 drivers/gpu/drm/radeon/r100.c                      |    4 -
 drivers/gpu/drm/radeon/r200.c                      |    4 -
 drivers/md/persistent-data/dm-btree-remove.c       |    8 ++-
 drivers/net/ethernet/cavium/thunder/thunder_bgx.c  |    2=20
 drivers/net/ethernet/stmicro/stmmac/common.h       |    2=20
 drivers/net/ethernet/stmicro/stmmac/descs_com.h    |   22 +++++---
 drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c |    2=20
 drivers/net/ethernet/stmicro/stmmac/enh_desc.c     |   10 ++-
 drivers/net/ethernet/stmicro/stmmac/norm_desc.c    |   10 ++-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   22 ++++----
 drivers/net/ethernet/ti/cpsw.c                     |    2=20
 drivers/nvme/host/core.c                           |    4 -
 drivers/pci/msi.c                                  |    2=20
 drivers/pci/pci-driver.c                           |   17 ++++--
 drivers/pci/quirks.c                               |   22 +++++---
 drivers/regulator/core.c                           |   42 ++++------------
 drivers/rpmsg/qcom_glink_native.c                  |   53 ++++++++++++++++=
-----
 drivers/rpmsg/qcom_glink_smem.c                    |    2=20
 drivers/scsi/libiscsi.c                            |    4 -
 drivers/usb/host/xhci-hub.c                        |    8 +++
 drivers/usb/host/xhci-ring.c                       |    6 --
 drivers/vfio/pci/vfio_pci_intrs.c                  |    2=20
 fs/cifs/file.c                                     |    7 ++
 include/linux/netdevice.h                          |    5 +
 include/linux/time.h                               |   13 +++++
 include/net/ip.h                                   |    5 +
 include/net/tcp.h                                  |   18 +++++--
 net/bridge/br_device.c                             |    6 ++
 net/core/dev.c                                     |    3 -
 net/core/flow_dissector.c                          |    5 +
 net/ipv4/devinet.c                                 |    5 -
 net/ipv4/ip_output.c                               |   14 +++--
 net/ipv4/tcp_output.c                              |    5 +
 net/openvswitch/conntrack.c                        |   11 ++++
 net/tipc/core.c                                    |   29 +++++------
 41 files changed, 256 insertions(+), 142 deletions(-)

Aaro Koskinen (2):
      net: stmmac: use correct DMA buffer size in the RX descriptor
      net: stmmac: don't stop NAPI processing when dropping a packet

Aaron Conole (1):
      openvswitch: support asymmetric conntrack

Alex Deucher (1):
      drm/radeon: fix r1xx/r2xx register checker for POT textures

Alexander Lobakin (1):
      net: dsa: fix flow dissection on Tx path

Arun Kumar Neelakantam (2):
      rpmsg: glink: Fix reuse intents memory leak issue
      rpmsg: glink: Fix use after free in open_ack TIMEOUT case

Bart Van Assche (1):
      scsi: iscsi: Fix a potential deadlock in the timeout handler

Bjorn Andersson (2):
      rpmsg: glink: Don't send pending rx_done during remove
      rpmsg: glink: Free pending deferred work on remove

Chris Lew (3):
      rpmsg: glink: Set tail pointer to 0 at end of FIFO
      rpmsg: glink: Put an extra reference during cleanup
      rpmsg: glink: Fix rpmsg_register_device err handling

Dexuan Cui (1):
      PCI/PM: Always return devices to D0 when thawing

Dmitry Osipenko (1):
      ARM: tegra: Fix FLOW_CTLR_HALT register clobbering by tegra_resume()

Eric Dumazet (2):
      tcp: md5: fix potential overestimation of TCP option space
      inet: protect against too small mtu values.

George Cherian (1):
      PCI: Apply Cavium ACS quirk to ThunderX2 and ThunderX3

Greg Kroah-Hartman (2):
      Revert "regulator: Defer init completion for a while after late_initc=
all"
      Linux 4.14.160

Grygorii Strashko (1):
      net: ethernet: ti: cpsw: fix extra rx interrupt

Guillaume Nault (3):
      tcp: fix rejected syncookies due to stale timestamps
      tcp: tighten acceptance of ACKs not matching a child socket
      tcp: Protect accesses to .ts_recent_stamp with {READ,WRITE}_ONCE()

Hou Tao (1):
      dm btree: increase rebalance threshold in __rebalance2()

Ivan Bornyakov (1):
      nvme: host: core: fix precedence of ternary operator

Jian-Hong Pan (1):
      PCI/MSI: Fix incorrect MSI-X masking on resume

Jiang Yi (1):
      vfio/pci: call irq_bypass_unregister_producer() before freeing irq

Lihua Yao (1):
      ARM: dts: s3c64xx: Fix init order of clock providers

Mathias Nyman (1):
      xhci: fix USB3 device initiated resume race with roothub autosuspend

Max Filippov (1):
      xtensa: fix TLB sanity checker

Mian Yousaf Kaukab (1):
      net: thunderx: start phy before starting autonegotiation

Navid Emamdoost (1):
      dma-buf: Fix memory leak in sync_file_merge()

Nikolay Aleksandrov (1):
      net: bridge: deny dev_set_mac_address() when unregistering

Pavel Shilovsky (1):
      CIFS: Respect O_SYNC and O_DIRECT flags during reconnect

Steffen Liebergeld (1):
      PCI: Fix Intel ACS quirk UPDCR register address

Taehee Yoo (1):
      tipc: fix ordering of tipc module init and exit routine


--TB36FDmn/VVEgNH/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl399rkACgkQONu9yGCS
aT4WPQ//ZrU8rJbCpeDgI/o1UTRGOa18PRZY3Ld4hxSRezXGo/txja+xSuUn4CFP
70GS52aW0abFJ1sW2v2a58m5tFVcIO5rWoXIgCycWHvFVyZGBKOiIG6Mmy6KSE0r
T0TfXdvq9BXcVokI3C5BWafFGUNmEF8vmqq+yOa32sVH/ayfNFqJhpUWW76yJHDk
irZ4gPInVV1IN3I+0MRb7qm4ppnku7QFBW8GdfyZumAGiNC/P10fvgpwT53mAUnt
d1doYD/CpPAIaZIaU9rOnqmB6ovl3MuO80Png8yj8ZnvoUOsblVcnjTdJP3aEOLQ
HWOtgr/6Tqb0TeYAZ0u7kDm8XsvTc34EQRzIKjI0VSFoq9IN0Bfn/G61hp1nEWLL
3sGJQLgBesGXL9XH9+mp9V2Ll0/Oknr9Xz+33T2Bb2EZ5glUFL1ep3bkp82dQvJF
9VFkobnB4fyreRswMN6PKH1DrCxUI/B8n5wuSpwTnFuhmadp9wqZfjHHxxvryksk
SVdAYJ9Vwu7LLFBqF4VJ0eCT6KTRpNzFofevJrczic1KXc+N9LmoUAnMe6sgW8u8
Q0lyNgSTlrDqsTbYKVgtu72hg2GWb3aqwCJxJVh+tovHEMvuSwc5lPl5uinUTtvH
LocRTD56xNiZlN8XZVx6PLEbfOWg7HMMDL5ja9ofg++01u5etpE=
=2pfB
-----END PGP SIGNATURE-----

--TB36FDmn/VVEgNH/--

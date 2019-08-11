Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11EA0891EE
	for <lists+stable@lfdr.de>; Sun, 11 Aug 2019 15:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbfHKN5q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Aug 2019 09:57:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:45410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726164AbfHKN5p (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 11 Aug 2019 09:57:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15592216F4;
        Sun, 11 Aug 2019 13:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565531864;
        bh=/d7uah1TlOAtvaaZu4l/VVUMpaRMGaZCVz9tSbpWQq4=;
        h=Date:From:To:Cc:Subject:From;
        b=m0+rTqqELen2lcrjj85Q6l269Ua1TNIyA+fy26NokO1dJhmTlRCgEGTDaJvNv6V9+
         DfwVfD68/crNK4y1DUSFeUWWD3OlhdmfQ7M7BAB1ZPQoRi/8lzK73yXdg39+Wnwvaq
         RZxVxpkpfj4KS0wrmj7qPutO66Y2rGNDPVZPSUfY=
Date:   Sun, 11 Aug 2019 15:57:42 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.9.189
Message-ID: <20190811135742.GA23209@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.9.189 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Documentation/kernel-parameters.txt             |    9 +-
 Makefile                                        |    2=20
 arch/arm/boot/dts/logicpd-som-lv.dtsi           |   18 ++++
 arch/arm/boot/dts/logicpd-torpedo-som.dtsi      |   16 +++
 arch/arm64/include/asm/cpufeature.h             |    7 -
 arch/arm64/kernel/cpufeature.c                  |   14 ++-
 arch/x86/entry/calling.h                        |   18 ++++
 arch/x86/entry/entry_64.S                       |   21 ++++
 arch/x86/include/asm/cpufeatures.h              |    8 -
 arch/x86/kernel/cpu/bugs.c                      |  105 +++++++++++++++++++=
++---
 arch/x86/kernel/cpu/common.c                    |   42 ++++++---
 block/blk-core.c                                |    1=20
 drivers/atm/iphase.c                            |    8 +
 drivers/hid/hid-ids.h                           |    1=20
 drivers/hid/usbhid/hid-quirks.c                 |    1=20
 drivers/hid/wacom_wac.c                         |   12 +-
 drivers/infiniband/core/addr.c                  |   15 +--
 drivers/infiniband/core/sa_query.c              |   10 +-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c        |    5 -
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c        |    5 -
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c |    2=20
 drivers/net/ethernet/mellanox/mlx5/core/dev.c   |    2=20
 drivers/net/ppp/pppoe.c                         |    3=20
 drivers/net/ppp/pppox.c                         |   13 ++
 drivers/net/ppp/pptp.c                          |    3=20
 drivers/scsi/fcoe/fcoe_ctlr.c                   |   51 ++++-------
 drivers/scsi/libfc/fc_rport.c                   |    5 -
 drivers/spi/spi-bcm2835.c                       |    3=20
 fs/compat_ioctl.c                               |    3=20
 include/linux/ceph/ceph_debug.h                 |    6 -
 include/linux/if_pppox.h                        |    3=20
 include/net/tcp.h                               |   17 +++
 include/scsi/libfcoe.h                          |    1=20
 net/bridge/br_multicast.c                       |    3=20
 net/bridge/br_vlan.c                            |    5 +
 net/ceph/ceph_common.c                          |   13 --
 net/core/dev.c                                  |    2=20
 net/ipv4/tcp_output.c                           |   11 ++
 net/ipv6/ip6_tunnel.c                           |    8 -
 net/l2tp/l2tp_ppp.c                             |    3=20
 net/sched/act_ife.c                             |    3=20
 net/sched/sch_codel.c                           |    6 -
 net/tipc/netlink_compat.c                       |   11 +-
 tools/objtool/check.c                           |    2=20
 44 files changed, 362 insertions(+), 135 deletions(-)

Aaron Armstrong Skomra (1):
      HID: wacom: fix bit shift for Cintiq Companion 2

Adam Ford (3):
      ARM: dts: Add pinmuxing for i2c2 and i2c3 for LogicPD SOM-LV
      ARM: dts: Add pinmuxing for i2c2 and i2c3 for LogicPD torpedo
      ARM: dts: logicpd-som-lv: Fix Audio Mute

Arnd Bergmann (1):
      compat_ioctl: pppoe: fix PPPOEIOCSFWD handling

Ben Hutchings (1):
      x86: cpufeatures: Sort feature word 7

Cong Wang (1):
      ife: error out when nla attributes are empty

Eric Dumazet (1):
      tcp: be more careful in tcp_fragment()

Greg Kroah-Hartman (2):
      IB: directly cast the sockaddr union to aockaddr
      Linux 4.9.189

Gustavo A. R. Silva (1):
      atm: iphase: Fix Spectre v1 vulnerability

Haishuang Yan (1):
      ip6_tunnel: fix possible use-after-free on xmit

Hannes Reinecke (1):
      scsi: fcoe: Embed fc_rport_priv in fcoe_rport structure

Ilya Dryomov (1):
      libceph: use kbasename() and kill ceph_file_part()

Jason Gunthorpe (1):
      RDMA: Directly cast the sockaddr union to sockaddr

Jia-Ju Bai (1):
      net: sched: Fix a possible null-pointer dereference in dequeue_func()

Jiri Pirko (1):
      net: fix ifindex collision during namespace removal

Josh Poimboeuf (5):
      objtool: Add machine_real_restart() to the noreturn list
      objtool: Add rewind_stack_do_exit() to the noreturn list
      x86/speculation: Prepare entry code for Spectre v1 swapgs mitigations
      x86/speculation: Enable Spectre v1 swapgs mitigations
      x86/entry/64: Use JMP instead of JMPQ

Lukas Wunner (1):
      spi: bcm2835: Fix 3-wire mode if DMA is enabled

Mark Zhang (1):
      net/mlx5: Use reversed order when unregister devices

Nikolay Aleksandrov (2):
      net: bridge: delete local fdb on device init failure
      net: bridge: mcast: don't delete permanent entries when fast leave is=
 enabled

Sebastian Parschauer (1):
      HID: Add quirk for HP X1200 PIXART OEM mouse

Sudarsana Reddy Kalluru (1):
      bnx2x: Disable multi-cos feature.

Taras Kondratiuk (1):
      tipc: compat: allow tipc commands without arguments

Thomas Gleixner (1):
      x86/speculation/swapgs: Exclude ATOMs from speculation through SWAPGS

Will Deacon (2):
      arm64: cpufeature: Fix CTR_EL0 field definitions
      arm64: cpufeature: Fix feature comparison for CTR_EL0.{CWG,ERG}

xiao jin (1):
      block: blk_init_allocated_queue() set q->fq as NULL in the fail case


--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl1QHtMACgkQONu9yGCS
aT67/A//bhSxLyyspFPwVgRWQ+GEZsm6Pgho5Xgg+2tpkEMKX2XVw85V1pAO4qtQ
wNiBOk3VDA/zfMhqsULur+LQUwoxRkEVGspmCPrtpo2pmtaqOFc+YuRc0IWhPz8H
RzdET35ghFkYU2nKnoE1PA2Ss1avwpNh1kUkNioyc3QxbojdiqRsua/oJeyrgucs
W8pirrBAxjvI3QX5AY0suwPVb+e3ZN2BLubeGu0xNcXY1Af3+ipyXVX43yDtdX4R
X5v2EMeWAhwCDRDQ6q4ogcJCI8hcjLaLVdxXAibS7bq146RejlYZ0dqF0uV/yxAb
7lYqN8EU3R/N+tRXdJXz/Buji0/F3Qqg5hBh2i4Lt9g+p0euOf9yT66SHBDwhGW4
3c4yyGqeSJNwgoQQOUmMLSmwVGc44SbEMLGeuhiYkqRRcSUlCiTfvhtFOQF+4CnF
i1ffyYNp0ywghj+uvGcQQAXN04y/C40jO/6jJc/CeIeRkYCTZY6Fm7VR1Ditc7t2
R7V7xI7JlsTWS1U6TaXzI7e9kDZ3VQlZx4ASPdzpaCDyjhyZCwEe19bfuz4sMMZA
gXYsm7oBi2fTk5v63s1VPMlGgNg4JSd9/rUT8oLXbo8wxXSTBIb2N2fml7ivLRoQ
h+Ky6vujfv5ctY2yJf9QiZpnhFFJinvJaR5+Y2PJhzQR4WFMA50=
=Bbdx
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--

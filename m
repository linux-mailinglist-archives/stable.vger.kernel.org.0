Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69382AE7C2
	for <lists+stable@lfdr.de>; Tue, 10 Sep 2019 12:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729662AbfIJKRk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Sep 2019 06:17:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:46014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726353AbfIJKRk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Sep 2019 06:17:40 -0400
Received: from localhost (110.8.30.213.rev.vodafone.pt [213.30.8.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B6CE2081B;
        Tue, 10 Sep 2019 10:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568110658;
        bh=6VX3ppImVvBjTUPNI3lOnSt69r1kYoz4PCDhiQGOeAg=;
        h=Date:From:To:Cc:Subject:From;
        b=1UozwKW4uyAFbgEXW2tEs6vu4hDBFQjQp7a8ZCB2Y6UubZGqmdnyl63ESoc2jpfGd
         +7wriWRp0uNkz8E65vB3dlEyQ4IuoMsSNLxbTrx2iURSTFiJxpnf3RYTUV6ysaGpZd
         dOFiDvFomYQKQuBnrYhXZOaSMCVLClP2k9R8wMd0=
Date:   Tue, 10 Sep 2019 11:17:36 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.9.192
Message-ID: <20190910101736.GA7195@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tThc/1wpZn/ma/RB"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.9.192 kernel.

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

 Makefile                                           |    2=20
 arch/arm/kvm/mmio.c                                |    7 ++
 arch/x86/kernel/apic/apic.c                        |    4 -
 drivers/bluetooth/btqca.c                          |    3 +
 drivers/infiniband/hw/mlx4/mad.c                   |    4 -
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c |    4 +
 drivers/net/ethernet/ibm/ibmveth.c                 |    9 +--
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c   |    2=20
 drivers/net/ethernet/renesas/ravb_main.c           |    8 ++
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c     |    6 --
 drivers/net/ethernet/toshiba/tc35815.c             |    2=20
 drivers/net/ethernet/tundra/tsi108_eth.c           |    5 +
 drivers/net/usb/cx82310_eth.c                      |    3 -
 drivers/net/usb/kalmia.c                           |    6 +-
 drivers/net/wimax/i2400m/fw.c                      |    4 +
 drivers/spi/spi-bcm2835aux.c                       |   57 +++++++---------=
-----
 fs/ceph/inode.c                                    |    7 +-
 fs/ceph/xattr.c                                    |    8 ++
 include/linux/ceph/buffer.h                        |    3 -
 include/linux/gpio.h                               |   24 --------
 net/core/netpoll.c                                 |    6 +-
 net/ipv4/tcp_output.c                              |    3 -
 net/ipv6/mcast.c                                   |    5 +
 tools/hv/hv_kvp_daemon.c                           |    2=20
 24 files changed, 83 insertions(+), 101 deletions(-)

Andrew Jones (1):
      KVM: arm/arm64: Only skip MMIO insn once

Chen-Yu Tsai (1):
      net: stmmac: dwmac-rk: Don't fail if phy regulator is absent

Eric Dumazet (1):
      mld: fix memory leak in mld_del_delrec()

Feng Sun (1):
      net: fix skb use after free in netpoll

Fuqian Huang (1):
      net: tundra: tsi108: use spin_lock_irqsave instead of spin_lock_irq i=
n IRQ context

Greg Kroah-Hartman (1):
      Linux 4.9.192

Linus Torvalds (1):
      Revert "x86/apic: Include the LDR when clearing out APIC registers"

Luis Henriques (3):
      ceph: fix buffer free while holding i_ceph_lock in __ceph_setxattr()
      ceph: fix buffer free while holding i_ceph_lock in fill_inode()
      libceph: allow ceph_buffer_put() to receive a NULL ceph_buffer

Martin Sperl (3):
      spi: bcm2835aux: unifying code between polling and interrupt driven c=
ode
      spi: bcm2835aux: remove dangerous uncontrolled read of fifo
      spi: bcm2835aux: fix corruptions for longer spi transfers

Matthias Kaehlcke (1):
      Bluetooth: btqca: Add a short delay before downloading the NVM

Nathan Chancellor (1):
      net: tc35815: Explicitly check NET_IP_ALIGN is not zero in tc35815_rx

Rob Herring (1):
      spi: bcm2835aux: ensure interrupts are enabled for shared handler

Tho Vu (1):
      ravb: Fix use-after-free ravb_tstamp_skb

Thomas Falcon (1):
      ibmveth: Convert multicast list size for little-endian system

Vitaly Kuznetsov (1):
      Tools: hv: kvp: eliminate 'may be used uninitialized' warning

Wenwen Wang (6):
      cxgb4: fix a memory leak bug
      net: myri10ge: fix memory leaks
      cx82310_eth: fix a memory leak bug
      net: kalmia: fix memory leaks
      wimax/i2400m: fix a memory leak bug
      IB/mlx4: Fix memory leaks

Willem de Bruijn (1):
      tcp: inherit timestamp on mtu probe

YueHaibing (1):
      gpio: Fix build error of function redefinition


--tThc/1wpZn/ma/RB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl13eD0ACgkQONu9yGCS
aT5D4A//ZErHkzMKpXI42x43nARJjb+b3s2KRMRy+w7BOxRjBw5t6e8ykbo8+8TD
YvQwVNq3WWvWyuSUpCnJ8A9jlTF8KC5eYUKk2BPtZmIDA/I1wosbMGDwn51uyjwv
iYYmQYQVEG4HSuhBpSPb3C7tHcqXHVzzLepRGh0VIWZJ/jX4Uf743ku9cBF3BmsB
QxCRN8pQE1JhIxc92z+GaCPf7v0UmkO1CRZE8wgJtTfOw0TdTFVa+DYSwmh7hBLr
PQ1PlHslkkwcX+9TYTB0vnEUYzT2H2lhR7b5+SObIKuNFcROwHmNGbJPxRjurQWq
6h0OLlykWps2SqsNObrbi8MJWjLCqfily3ry8nG+MmfEdKZiGj6qFYstarqaRUm7
MMN0PoTYgLiTLteGe6lcSpQlX3iN+VdHzEvJWWle4dQ4R+6HK5FvgLQBHDTr2SEw
DJNWd3vWiPaks3PV4oeukI3EhXlQ108eOJO8y/N5m5z9w4uSOez3MtQm1YO9AKZl
sAC/8h7ZMNET5hzc9QMHp6tTj2+sDx3klxoMQ/IvcjJsaLB4d+iefTdUOosGX0Pc
ZLLG3ZQxT0T9uZOSFDnsaaFlaSkg8OASUcWmx9XlWLb89YckwOb6XMxP9WS/qLkx
p3fDwW1hmqrVNxTLbkQR2acAnm+moS/i2NiyuaMfD4AV13aWtJ4=
=Q+tV
-----END PGP SIGNATURE-----

--tThc/1wpZn/ma/RB--

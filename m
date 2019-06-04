Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3DE634074
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 09:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbfFDHiq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 03:38:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:60582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726792AbfFDHiq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 03:38:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0CD624C4F;
        Tue,  4 Jun 2019 07:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559633925;
        bh=axZOWHeODaUssjn77DBZDdTL58oilR+SgBIMQ0R2EXQ=;
        h=Date:From:To:Cc:Subject:From;
        b=IlbcjkKRahkclVOLvSaIEFDyY+VoJ/9C9wn8ePJNO21E1RFHYW22SKQz1kYxegCLQ
         1Ft+/N9Ph/sZ8J9cUhuDvV5gMN+6ypeKKZmVuUwltJ6RzPHigdC4hKqJgSaK1qsYDv
         w86B7S5vKqyW8djxYlg+ZtNYeNQpF7SpOJRXBtYs=
Date:   Tue, 4 Jun 2019 09:38:43 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.0.21
Message-ID: <20190604073843.GA4985@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
Content-Disposition: inline
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.0.21 kernel.

All users of the 5.0 kernel series must upgrade.

Note, this is the LAST 5.0.y kernel to be released.  It is now
end-of-life.  Please move to the 5.1.y kernel tree at this point in
time.

The updated 5.0.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.0.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                               |    2=20
 drivers/crypto/vmx/ghash.c                             |  212 ++++++------=
-----
 drivers/net/bonding/bond_main.c                        |   15 -
 drivers/net/dsa/mv88e6xxx/chip.c                       |    2=20
 drivers/net/ethernet/broadcom/bnxt/bnxt.c              |   19 -
 drivers/net/ethernet/broadcom/bnxt/bnxt.h              |    6=20
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c      |    2=20
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c          |    2=20
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c   |    5=20
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c             |   11=20
 drivers/net/ethernet/freescale/fec_main.c              |    2=20
 drivers/net/ethernet/marvell/mvneta.c                  |    4=20
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c        |   10=20
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c      |   13 +
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c      |    6=20
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_erp.c |   11=20
 drivers/net/ethernet/realtek/r8169.c                   |    3=20
 drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c   |    4=20
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c      |    8=20
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c      |    3=20
 drivers/net/phy/marvell10g.c                           |   13 +
 drivers/net/usb/usbnet.c                               |    6=20
 drivers/xen/xen-pciback/pciback_ops.c                  |    2=20
 include/linux/siphash.h                                |    5=20
 include/net/netns/ipv4.h                               |    2=20
 include/uapi/linux/tipc_config.h                       |   10=20
 net/core/dev.c                                         |    2=20
 net/core/skbuff.c                                      |    6=20
 net/ipv4/igmp.c                                        |   47 ++-
 net/ipv4/ip_output.c                                   |    4=20
 net/ipv4/route.c                                       |   12=20
 net/ipv6/ip6_output.c                                  |    4=20
 net/ipv6/output_core.c                                 |   30 +-
 net/ipv6/raw.c                                         |    2=20
 net/ipv6/route.c                                       |    6=20
 net/llc/llc_output.c                                   |    2=20
 net/sched/act_api.c                                    |    3=20
 net/tipc/core.c                                        |   32 +-
 net/tipc/subscr.h                                      |    5=20
 net/tipc/topsrv.c                                      |   14 -
 net/tls/tls_device.c                                   |    9=20
 41 files changed, 312 insertions(+), 244 deletions(-)

Andy Duan (1):
      net: fec: fix the clk mismatch in failed_reset path

Antoine Tenart (1):
      net: mvpp2: fix bad MVPP2_TXQ_SCHED_TOKEN_CNTR_REG queue value

Chris Packham (1):
      tipc: Avoid copying bytes beyond the supplied data

Daniel Axtens (1):
      crypto: vmx - ghash: do nosimd fallback manually

David Ahern (1):
      ipv6: Fix redirect with VRF

David S. Miller (1):
      Revert "tipc: fix modprobe tipc failed after switch order of device r=
egistration"

Eric Dumazet (5):
      inet: switch IP ID generator to siphash
      ipv4/igmp: fix another memory leak in igmpv3_del_delrec()
      ipv4/igmp: fix build error if !CONFIG_IP_MULTICAST
      llc: fix skb leak in llc_build_and_send_ui_pkt()
      net-gro: fix use-after-free read in napi_gro_frags()

Greg Kroah-Hartman (1):
      Linux 5.0.21

Heiner Kallweit (1):
      r8169: fix MAC address being lost in PCI D3

Jakub Kicinski (2):
      net/tls: fix state removal with feature flags off
      net/tls: don't ignore netdev notifications if no TLS features

Jarod Wilson (1):
      bonding/802.3ad: fix slave link initialization transition states

Jiri Pirko (1):
      mlxsw: spectrum_acl: Avoid warning after identical rules insertion

Jisheng Zhang (2):
      net: mvneta: Fix err code path of probe
      net: stmmac: fix reset gpio free missing

Junwei Hu (1):
      tipc: fix modprobe tipc failed after switch order of device registrat=
ion

Kloetzke Jan (1):
      usbnet: fix kernel crash after disconnect

Konrad Rzeszutek Wilk (1):
      xen/pciback: Don't disable PCI_COMMAND on PCI device reset.

Michael Chan (3):
      bnxt_en: Fix aggregation buffer leak under OOM condition.
      bnxt_en: Fix possible BUG() condition when calling pci_disable_msix().
      bnxt_en: Reduce memory usage when running in kdump kernel.

Mike Manning (1):
      ipv6: Consider sk_bound_dev_if when binding a raw socket to an address

Parav Pandit (2):
      net/mlx5: Avoid double free in fs init error unwinding path
      net/mlx5: Allocate root ns memory using kzalloc to match kfree

Raju Rangoju (1):
      cxgb4: offload VLAN flows regardless of VLAN ethtype

Rasmus Villemoes (1):
      net: dsa: mv88e6xxx: fix handling of upper half of STATS_TYPE_PORT

Russell King (1):
      net: phy: marvell10g: report if the PHY fails to boot firmware

Saeed Mahameed (1):
      net/mlx5e: Disable rxhash when CQE compress is enabled

Tan, Tee Min (1):
      net: stmmac: fix ethtool flow control not able to get/set

Vishal Kulkarni (1):
      cxgb4: Revert "cxgb4: Remove SGE_HOST_PAGE_SIZE dependency on page si=
ze"

Vlad Buslov (1):
      net: sched: don't use tc_action->order during action dump

Weifeng Voon (1):
      net: stmmac: dma channel control register need to be init first

Willem de Bruijn (1):
      net: correct zerocopy refcnt with udp MSG_MORE


--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAlz2IAIACgkQONu9yGCS
aT4D9RAA08cV7ynRyNbat+yWBeP2s0sYey3dm9ufEDI+YLFjLolKGW455OffJwW2
2IuLov4Yij+ToeKpkHGubQZD6m0mj4c4iXH2n77qwKZfeyQtu05fSCfdG0ucrQwc
E7KyqraBhYc4ApkI9vj/+lrMQ+cNTFisVc5zdEpmiKuT2DONmRdGKHnZAZ0PVl2I
cnvM1gLkrR4PRZA4fa2zJy+eFhxPeDV9WqQucojMgdYJcsah6AwrSSZ2grHwMklM
4SzDkFwibWr3vqKbAWXZFun1BGZOt/7YWVp46blp+mUHZvV+8QXGJcfPvZXEgN/O
N05oTltf4EBrCsjv5h4mRsgyPxStGTbotTvXaef+9Tg+njCQzvkWDmkh3sPBKY69
MTZtcE7usXBZ7M70zS8DrGmAA7EOcQC1IsOwGNr9Yw8J2xP/hPQee4AlOLX6dyqp
vm7Yl/HF+RwlAhyoNHwuJLKMqMPpDO5/YwSKNxIFWpjaqc6tXB1AcpgqB4F3Lebb
YGaDjobd+3CEDDAHbWsXyceF3H/EDvh9N1JIcjiSDJshsrBQspKX6/VuZO3tJBIU
2LWEEPUlyJEvABMMdqzJxvipuDlMlzYgL5qCC5AlYDFcaaP0kii804pTE3Xkc4Il
VylH4s22o/wCGgZ66yoYeZ4by6RHbPAB+zaqR2nQz2CVLDHFeKQ=
=Uj/u
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--

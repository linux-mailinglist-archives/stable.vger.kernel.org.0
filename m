Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B89A34079
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 09:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbfFDHjL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 03:39:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:60892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726713AbfFDHjL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 03:39:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AA6B24C53;
        Tue,  4 Jun 2019 07:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559633949;
        bh=HLCSzYlmW3OxGQUPup4v5Fy9rGsBZBcrE3QHujMCqVA=;
        h=Date:From:To:Cc:Subject:From;
        b=h2XhkgvnkZRKBcd9kO+J2tRjb1ecPkonzEL1+GpA5Jpf6nOmi68jRj9Bun6zf6srN
         a+PYXoofknz1N1pzNYDluUqfDMi0DeD6rNQSdchkjn27SQa53tPzc5sMZ+euUIOQfV
         T6D7quXLG1pQjKkBfHr+xK016uoexhkKrXOMpJGk=
Date:   Tue, 4 Jun 2019 09:39:07 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.1.7
Message-ID: <20190604073907.GA10233@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="wac7ysb48OaltWcw"
Content-Disposition: inline
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.1.7 kernel.

All users of the 5.1 kernel series must upgrade.

The updated 5.1.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.1.y
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
 include/linux/siphash.h                                |    5=20
 include/net/netns/ipv4.h                               |    2=20
 include/uapi/linux/tipc_config.h                       |   10=20
 net/core/dev.c                                         |    2=20
 net/core/ethtool.c                                     |    8=20
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
 net/tls/tls_sw.c                                       |   19 -
 tools/testing/selftests/net/tls.c                      |   34 ++
 43 files changed, 359 insertions(+), 256 deletions(-)

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
      Linux 5.1.7

Heiner Kallweit (1):
      r8169: fix MAC address being lost in PCI D3

Jakub Kicinski (6):
      net/tls: fix lowat calculation if some data came from previous record
      selftests/tls: test for lowat overshoot with multiple records
      net/tls: fix no wakeup on partial reads
      selftests/tls: add test for sleeping even though there is data
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

Maxime Chevallier (1):
      ethtool: Check for vlan etype or vlan tci when parsing flow_rule

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


--wac7ysb48OaltWcw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAlz2IBoACgkQONu9yGCS
aT7NAQ/9ERJLK62LyFsWb8VVZ4V2eGwrUIjXSklZtJ6iVzsBW8q2QlXXVInds3+r
QkkXTsxCj7f1mRn6KejLUXn3qZIjVuoINq/K7UXY61IkwDYlj/i3QHlZqHDnARQr
BrfNA1SO5vHT46VWOCDU81UBRbuQHKEt6Xbr7ajCSY8V9YtfCgVUEvPDy0voBvZS
mjdxr90wUZ+NrGrGdnQBlT/7O4wtmE57/xAt5TILgXiNDMlRs1ahbNGD9ccMyjPK
1r5Bw4FFA8brQ6absgpvk9dx0KOTqlEzrml7igwAZLLZF1V/vcMhSANSy4gWs7DY
BZMuUzuantLSq52ZftPEwLcsrNlh2A3RKP2B8Lpdk4d+aTxMav5QhlEApB+ceEL6
pLy8rP/E8CSUbCfUcJIU94XPDdcqrnOthLRIxlB5r/IdsciMhBSgSMi6CJwj+nRd
W8vc5/BO+cxZUUA1LBp4OarAFELP6iZzyB3UKZIVZPcvU3El3clT0k6C5AMT+mG4
SUO9rz5wCD6j/fwVlTPnI5k+nQQ5hsYyHFQULUCp8XXHGzhX+Q802v41t0Lr/SLu
lDosSYZJf/ihDcd4XvZz79l5Gbrhpnc56yEp8GU6W26MuxjEuffewaUVNY2NUsO3
XBNrpD/6gbvWJV32itgRhs23gNHSVPioitkjrTCWQn9m3Mw41g8=
=VUzl
-----END PGP SIGNATURE-----

--wac7ysb48OaltWcw--

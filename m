Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF973406F
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 09:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbfFDHh7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 03:37:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:60054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726653AbfFDHh7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 03:37:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 038EF24BCC;
        Tue,  4 Jun 2019 07:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559633878;
        bh=MZSE5k2pJwBOPeNlyJ1376oQhjXUyuo5tV0bdooE00M=;
        h=Date:From:To:Cc:Subject:From;
        b=nqEdkOr4yQ1+jT6dXPQyfuF2AowMI7m1oY71gsjL6QJBqrKpWf4rlnQfQsXYUjo8z
         mkvqo/PlzFvY1sFM1nEuLYTN85NnGFMMzPATB0V3ZwDCxV5zOgPcMEmJ86ARUqT8ac
         Id9Rog/BsNVsHsOUII2FB2WOFOcrG10oo1Jx4RDU=
Date:   Tue, 4 Jun 2019 09:37:56 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.48
Message-ID: <20190604073756.GA32163@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="envbJBWh7q8WU6mo"
Content-Disposition: inline
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.48 kernel.

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

 Makefile                                             |    9=20
 arch/Kconfig                                         |    1=20
 arch/arm/kernel/jump_label.c                         |    4=20
 arch/arm64/kernel/jump_label.c                       |    4=20
 arch/mips/kernel/jump_label.c                        |    4=20
 arch/powerpc/include/asm/asm-prototypes.h            |    2=20
 arch/powerpc/kernel/jump_label.c                     |    2=20
 arch/powerpc/platforms/powernv/opal-tracepoints.c    |    2=20
 arch/powerpc/platforms/powernv/opal-wrappers.S       |    2=20
 arch/powerpc/platforms/pseries/hvCall.S              |    4=20
 arch/powerpc/platforms/pseries/lpar.c                |    2=20
 arch/s390/kernel/Makefile                            |    3=20
 arch/s390/kernel/jump_label.c                        |    4=20
 arch/sparc/kernel/Makefile                           |    2=20
 arch/sparc/kernel/jump_label.c                       |    4=20
 arch/x86/Makefile                                    |    2=20
 arch/x86/entry/calling.h                             |    2=20
 arch/x86/include/asm/cpufeature.h                    |    2=20
 arch/x86/include/asm/jump_label.h                    |   13 -
 arch/x86/include/asm/rmwcc.h                         |    6=20
 arch/x86/kernel/Makefile                             |    3=20
 arch/x86/kernel/jump_label.c                         |    4=20
 arch/x86/kvm/emulate.c                               |    2=20
 drivers/crypto/vmx/ghash.c                           |  212 +++++++-------=
-----
 drivers/net/bonding/bond_main.c                      |   15 -
 drivers/net/dsa/mv88e6xxx/chip.c                     |    2=20
 drivers/net/ethernet/broadcom/bnxt/bnxt.c            |    2=20
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c |    5=20
 drivers/net/ethernet/freescale/fec_main.c            |    2=20
 drivers/net/ethernet/marvell/mvneta.c                |    4=20
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c      |   10=20
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c    |   13 +
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c    |    6=20
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c    |    8=20
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c    |    3=20
 drivers/net/phy/marvell10g.c                         |   13 +
 drivers/net/usb/usbnet.c                             |    6=20
 drivers/xen/xen-pciback/pciback_ops.c                |    2=20
 include/linux/compiler.h                             |   17 -
 include/linux/compiler_types.h                       |    4=20
 include/linux/dynamic_debug.h                        |    6=20
 include/linux/jump_label.h                           |   22 -
 include/linux/jump_label_ratelimit.h                 |    8=20
 include/linux/module.h                               |    2=20
 include/linux/netfilter.h                            |    4=20
 include/linux/netfilter_ingress.h                    |    2=20
 include/linux/siphash.h                              |    5=20
 include/net/netns/ipv4.h                             |    2=20
 include/uapi/linux/tipc_config.h                     |   10=20
 init/Kconfig                                         |    3=20
 kernel/jump_label.c                                  |   10=20
 kernel/module.c                                      |    2=20
 kernel/sched/core.c                                  |    2=20
 kernel/sched/debug.c                                 |    4=20
 kernel/sched/fair.c                                  |    6=20
 kernel/sched/sched.h                                 |    6=20
 lib/dynamic_debug.c                                  |    2=20
 net/core/dev.c                                       |    8=20
 net/ipv4/igmp.c                                      |   47 ++--
 net/ipv4/route.c                                     |   12 -
 net/ipv6/output_core.c                               |   30 +-
 net/ipv6/raw.c                                       |    2=20
 net/ipv6/route.c                                     |    6=20
 net/llc/llc_output.c                                 |    2=20
 net/netfilter/core.c                                 |    6=20
 net/sched/act_api.c                                  |    3=20
 net/tipc/core.c                                      |   32 +-
 net/tipc/subscr.h                                    |    5=20
 net/tipc/topsrv.c                                    |   14 +
 net/tls/tls_device.c                                 |    9=20
 scripts/gcc-goto.sh                                  |    2=20
 tools/arch/x86/include/asm/rmwcc.h                   |    6=20
 72 files changed, 337 insertions(+), 350 deletions(-)

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
      Linux 4.19.48

Jakub Kicinski (2):
      net/tls: fix state removal with feature flags off
      net/tls: don't ignore netdev notifications if no TLS features

Jarod Wilson (1):
      bonding/802.3ad: fix slave link initialization transition states

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

Masahiro Yamada (2):
      compiler.h: give up __compiletime_assert_fallback()
      jump_label: move 'asm goto' support test to Kconfig

Michael Chan (1):
      bnxt_en: Fix aggregation buffer leak under OOM condition.

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

Vlad Buslov (1):
      net: sched: don't use tc_action->order during action dump

Weifeng Voon (1):
      net: stmmac: dma channel control register need to be init first

ndesaulniers@google.com (1):
      include/linux/compiler*.h: define asm_volatile_goto


--envbJBWh7q8WU6mo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAlz2H9AACgkQONu9yGCS
aT78xg/+ImryiwrBgKW5LyW1vjHq3Nn30RtxXtKTiZwIJuWUxGf9SqGHEIuJ7Y3C
gl3/wmEBA2Pn7QppqSqCu/x5/RmzlHxjHuDQBbh38j1jZknQ+mZAewpCXv3+uJCa
x2Lils3vF1ZGypw8jyP+baUfgBeGnAvzyuHQjoSBPVDDsXGiXkN9EBLu58StQ1yZ
Xjp91MXKZyGO99e+ScsGwvAVTvLz4DTRimPj/k37pFlUaoeogkTrPBpH4Lf6ehMe
PgcYuEE2mRH0JbTcDwgRjTLoNqLPPo6OKTI8G7cjUDS6diwnYNT2o37iJK9X673P
T+WgEFQMEBD2v6Wwiy4BoWyUsL6MsL6e/kXBSncoLMfygkSiDMS5v7P7WSk/0LMX
mYV9mMp+GHNedwJdaRpfDwWD30P6FJg4t3Gopl+0UhEZqe79KgrVMz+jhs+GugDn
k2o2yMzJP39K9tbqUlSEz8r++hn9g0nWWR8K4syrFrAqvb5ZuHtdm3c8y/WPyekW
kR2x483HpTDtNSD3cNxJlf7DmQKDHr8cgH365yJZVOUMEkyqZg6lYqIZcY+d2RGU
Wx7xbnsF+8EZ15WTp6vNQRjLY8+ThUcr/G14WfJCampnW1D5LWXZaLYw6L3grkXE
Xh5ykhIcitMcR5esT1QLwkB6JgL94UF/4uYdwAHCwQgd3mx2SZM=
=3fbI
-----END PGP SIGNATURE-----

--envbJBWh7q8WU6mo--

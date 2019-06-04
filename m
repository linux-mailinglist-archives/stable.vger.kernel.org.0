Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2219B34137
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 10:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbfFDILq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 04:11:46 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:35720 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726637AbfFDILp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 04:11:45 -0400
Received: by mail-pl1-f193.google.com with SMTP id p1so8031265plo.2;
        Tue, 04 Jun 2019 01:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tFI610DY+bgCVaUPpuS1z2PY9xoB2Z0nQtZ31SJB2tM=;
        b=EWEWeScEfkXzrgOPE1aXMu+Pls9+jrRtffFtX3TsooA9kXpX/sfkQ1GHJFzg2Im+/I
         P1RPyc7vfCtk3Px3fqDmcFqpZZxS0Se2tWWtYsp8SooDNeqtJ/IIi1MybtOmEm1awrO+
         jYp3KNsX6pzRmuXb6yd2riA9bpnG7pRSqdjz8pEPGLNOVHecoN5LBv0Ut2CvYY6JedAW
         cX5G9i26Du6nNJLsmV9kOVl8/UxHGHhWv7trgIZsqDSU7pvbVoAGh1j1THE8hPKka9DZ
         nZxDow4q2PQ9Aq0q9mCW6nEjku+UEaqJA8c89FgJqM6qkVOE1+7NhX0uMUGpsHfNmcZL
         POyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=tFI610DY+bgCVaUPpuS1z2PY9xoB2Z0nQtZ31SJB2tM=;
        b=sUZE/Jco2huEWZJN9PLEGYF0P9ZL9oASv6BQxiQEGi+AZ36ycUXuv7O//jUTkEvwjm
         tSFa4BZad+QB5WvMwBLHJ5ZGyAg7zEeL2QpCXFXdMKrEdMQM+Hp9FxyKkQpo0gV4rwjt
         vAC6fqLR/mBlmAV2SouTqDwAto/0LFW5ALNJUn9vDzanpXsFyKdPTnQh6Jab1yD9QQkw
         +pxggdabRtNakAxKj/rBUzRgOOu/vduEEWOWQlxU3uPoh2h/BSPSBwk607mhyd0LAS63
         +au2DJPxsET41kAM2sAoWrCNY5VDtV3WBce6bc6FRVQnFcYs4nHoECKkNcZYABtqdy0+
         kftQ==
X-Gm-Message-State: APjAAAU/PUF1OOpBoTbGaKordgsNX1SFvA10wsCusUABe40vGIKQbTOU
        PpiS7sM7vmpkjmG8DDeyVaBw1QQAVHzHvg==
X-Google-Smtp-Source: APXvYqx5Edf1gShejE1jX7qU2dOpKixWhxupf2qsurfFVSuF2qwSbcobiLlgWq98RrC569S62uEpoA==
X-Received: by 2002:a17:902:9689:: with SMTP id n9mr35178701plp.133.1559635904852;
        Tue, 04 Jun 2019 01:11:44 -0700 (PDT)
Received: from Gentoo ([103.231.91.66])
        by smtp.gmail.com with ESMTPSA id t124sm17718153pfb.80.2019.06.04.01.11.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 01:11:43 -0700 (PDT)
Date:   Tue, 4 Jun 2019 13:41:29 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 5.1.7
Message-ID: <20190604081129.GA10154@Gentoo>
References: <20190604073907.GA10233@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
In-Reply-To: <20190604073907.GA10233@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

Thanks, a bunch Greg!

On 09:39 Tue 04 Jun , Greg KH wrote:
>I'm announcing the release of the 5.1.7 kernel.
>
>All users of the 5.1 kernel series must upgrade.
>
>The updated 5.1.y git tree can be found at:
>	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.1.y
>and can be browsed at the normal kernel.org git web browser:
>	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary
>
>thanks,
>
>greg k-h
>
>------------
>
> Makefile                                               |    2
> drivers/crypto/vmx/ghash.c                             |  212 ++++++-----------
> drivers/net/bonding/bond_main.c                        |   15 -
> drivers/net/dsa/mv88e6xxx/chip.c                       |    2
> drivers/net/ethernet/broadcom/bnxt/bnxt.c              |   19 -
> drivers/net/ethernet/broadcom/bnxt/bnxt.h              |    6
> drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c      |    2
> drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c          |    2
> drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c   |    5
> drivers/net/ethernet/chelsio/cxgb4/t4_hw.c             |   11
> drivers/net/ethernet/freescale/fec_main.c              |    2
> drivers/net/ethernet/marvell/mvneta.c                  |    4
> drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c        |   10
> drivers/net/ethernet/mellanox/mlx5/core/en_main.c      |   13 +
> drivers/net/ethernet/mellanox/mlx5/core/fs_core.c      |    6
> drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_erp.c |   11
> drivers/net/ethernet/realtek/r8169.c                   |    3
> drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c   |    4
> drivers/net/ethernet/stmicro/stmmac/stmmac_main.c      |    8
> drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c      |    3
> drivers/net/phy/marvell10g.c                           |   13 +
> drivers/net/usb/usbnet.c                               |    6
> include/linux/siphash.h                                |    5
> include/net/netns/ipv4.h                               |    2
> include/uapi/linux/tipc_config.h                       |   10
> net/core/dev.c                                         |    2
> net/core/ethtool.c                                     |    8
> net/core/skbuff.c                                      |    6
> net/ipv4/igmp.c                                        |   47 ++-
> net/ipv4/ip_output.c                                   |    4
> net/ipv4/route.c                                       |   12
> net/ipv6/ip6_output.c                                  |    4
> net/ipv6/output_core.c                                 |   30 +-
> net/ipv6/raw.c                                         |    2
> net/ipv6/route.c                                       |    6
> net/llc/llc_output.c                                   |    2
> net/sched/act_api.c                                    |    3
> net/tipc/core.c                                        |   32 +-
> net/tipc/subscr.h                                      |    5
> net/tipc/topsrv.c                                      |   14 -
> net/tls/tls_device.c                                   |    9
> net/tls/tls_sw.c                                       |   19 -
> tools/testing/selftests/net/tls.c                      |   34 ++
> 43 files changed, 359 insertions(+), 256 deletions(-)
>
>Andy Duan (1):
>      net: fec: fix the clk mismatch in failed_reset path
>
>Antoine Tenart (1):
>      net: mvpp2: fix bad MVPP2_TXQ_SCHED_TOKEN_CNTR_REG queue value
>
>Chris Packham (1):
>      tipc: Avoid copying bytes beyond the supplied data
>
>Daniel Axtens (1):
>      crypto: vmx - ghash: do nosimd fallback manually
>
>David Ahern (1):
>      ipv6: Fix redirect with VRF
>
>David S. Miller (1):
>      Revert "tipc: fix modprobe tipc failed after switch order of device registration"
>
>Eric Dumazet (5):
>      inet: switch IP ID generator to siphash
>      ipv4/igmp: fix another memory leak in igmpv3_del_delrec()
>      ipv4/igmp: fix build error if !CONFIG_IP_MULTICAST
>      llc: fix skb leak in llc_build_and_send_ui_pkt()
>      net-gro: fix use-after-free read in napi_gro_frags()
>
>Greg Kroah-Hartman (1):
>      Linux 5.1.7
>
>Heiner Kallweit (1):
>      r8169: fix MAC address being lost in PCI D3
>
>Jakub Kicinski (6):
>      net/tls: fix lowat calculation if some data came from previous record
>      selftests/tls: test for lowat overshoot with multiple records
>      net/tls: fix no wakeup on partial reads
>      selftests/tls: add test for sleeping even though there is data
>      net/tls: fix state removal with feature flags off
>      net/tls: don't ignore netdev notifications if no TLS features
>
>Jarod Wilson (1):
>      bonding/802.3ad: fix slave link initialization transition states
>
>Jiri Pirko (1):
>      mlxsw: spectrum_acl: Avoid warning after identical rules insertion
>
>Jisheng Zhang (2):
>      net: mvneta: Fix err code path of probe
>      net: stmmac: fix reset gpio free missing
>
>Junwei Hu (1):
>      tipc: fix modprobe tipc failed after switch order of device registration
>
>Kloetzke Jan (1):
>      usbnet: fix kernel crash after disconnect
>
>Maxime Chevallier (1):
>      ethtool: Check for vlan etype or vlan tci when parsing flow_rule
>
>Michael Chan (3):
>      bnxt_en: Fix aggregation buffer leak under OOM condition.
>      bnxt_en: Fix possible BUG() condition when calling pci_disable_msix().
>      bnxt_en: Reduce memory usage when running in kdump kernel.
>
>Mike Manning (1):
>      ipv6: Consider sk_bound_dev_if when binding a raw socket to an address
>
>Parav Pandit (2):
>      net/mlx5: Avoid double free in fs init error unwinding path
>      net/mlx5: Allocate root ns memory using kzalloc to match kfree
>
>Raju Rangoju (1):
>      cxgb4: offload VLAN flows regardless of VLAN ethtype
>
>Rasmus Villemoes (1):
>      net: dsa: mv88e6xxx: fix handling of upper half of STATS_TYPE_PORT
>
>Russell King (1):
>      net: phy: marvell10g: report if the PHY fails to boot firmware
>
>Saeed Mahameed (1):
>      net/mlx5e: Disable rxhash when CQE compress is enabled
>
>Tan, Tee Min (1):
>      net: stmmac: fix ethtool flow control not able to get/set
>
>Vishal Kulkarni (1):
>      cxgb4: Revert "cxgb4: Remove SGE_HOST_PAGE_SIZE dependency on page size"
>
>Vlad Buslov (1):
>      net: sched: don't use tc_action->order during action dump
>
>Weifeng Voon (1):
>      net: stmmac: dma channel control register need to be init first
>
>Willem de Bruijn (1):
>      net: correct zerocopy refcnt with udp MSG_MORE
>



--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAlz2J60ACgkQsjqdtxFL
KRUgAwgAyBG88i3AfRFgm3bZ5kjwJwFpwmpRw720/zp8hwIboUQumnrlcU5U6Ood
MzNRY97CdZ5qCw1CYvL3bXwYK071Nfl7TepaQPX4R37SQirojRoZ3pdzbg5h3o8z
Z1KebrYNsXwdxc4udJuZs9MM55ZHj86sDaXcnyPUMnEhQ0fQowErrqtn3xWWbaqL
yPGB8gdR+gvfUgZINofc2ymLu/aUp8QFkBEC9tUTj1x1oZDifm0SwspAsqRYEN3i
FhcPCND5cQaXNhs1EzmoqRpg70aNiYWMNgqI0Fh0655YHSf5KbR5CfjUVJMzT5vF
/dHY8fuu3z3VzoIC6RO+/BPCr8rLSA==
=v+kp
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--

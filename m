Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7698A3418D
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 10:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbfFDIQK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 04:16:10 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36050 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726927AbfFDIQK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 04:16:10 -0400
Received: by mail-pf1-f194.google.com with SMTP id u22so12220323pfm.3;
        Tue, 04 Jun 2019 01:16:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jCHecnT0sYNlMgEQO4s05IEDfcTXYeUHL4Z0ONFa9so=;
        b=RAGX3I7NlXEhkSEXwbvcJD6bKhPmmqUcDGtJ2G0lsqekmlIwRD6OnieNZIWJjaRurb
         OhvXnhdArx7K6vTqUkzqtV7d5wLzlysuhNOQOtqzZfXtRKzZgQ953McbxQAS5prJJuTm
         pNRolY/qDVu/1+29ypKCfd90jC05n1gwGXZdGpS+A+cvRlbwxHHL6ySQ3BFSw11mGWHb
         FZ19LFlap68nhqXBs77wkPfG+SWIl1FHjGGeRcmHUk5LhSJv0Cm3s11XwxCOkVFk7wvE
         41RjlgFVt0CsgKnvHcJ6yjzhKQCUKfCrbDzJdG0gMJVqSC1Lw1rlAksS7QF9P1WiZq+c
         s/+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jCHecnT0sYNlMgEQO4s05IEDfcTXYeUHL4Z0ONFa9so=;
        b=OMw8X7JUe5W7q0vpLEavfkyhzcmIEB+4fwtfw9INEPj5+jKmoCDn9nx5kJvpVwW1of
         5E1UBSN+r/Sxael/x7brLKfSanSbPcaHT1Dq97KKcHEeyVG2seWNpiEtmT0ztchPWp4p
         7Wz4o5xYtEaLpR9TajAh8h5/VyoxYQ1AUQT38sxD6eeXjB73g8uiTrEhxnjw0V5SetmM
         ZPTwXxjwsY/wUJ6vP9PecUmi6yQ3dLTbFr+KJbR7JzqSDNkg4c/+sXGs9gKW4izDpkkc
         OZejCs1RP5f6fEAOxUBup7ObWKpsmfhDx1RDb+5+JYWkXeMz1GFZnYmd0jnSZZXwvXzk
         6XoQ==
X-Gm-Message-State: APjAAAUN9zDqvki5KvyUDA5kNDrYLw6Zy+3aG0RcPQtSei5Vq5LVOOLB
        uhpTcdIh0zRQOG5KjKmb2Kg=
X-Google-Smtp-Source: APXvYqzdkxeIJwI3y/8voHOex3X1QneNgzO5Pb81QFjwH3Kphj/oaypdhy/tZMuKtNMVCNdQsNDZ+g==
X-Received: by 2002:a17:90a:2ec9:: with SMTP id h9mr36459752pjs.130.1559636169132;
        Tue, 04 Jun 2019 01:16:09 -0700 (PDT)
Received: from Gentoo ([103.231.91.66])
        by smtp.gmail.com with ESMTPSA id f21sm37258pjq.2.2019.06.04.01.16.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 01:16:07 -0700 (PDT)
Date:   Tue, 4 Jun 2019 13:45:53 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 5.0.21
Message-ID: <20190604081553.GB10154@Gentoo>
References: <20190604073843.GA4985@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="K8nIJk4ghYZn606h"
Content-Disposition: inline
In-Reply-To: <20190604073843.GA4985@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--K8nIJk4ghYZn606h
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

Heads up! this has reached an EOL ...so please move to 5.1 series.

On 09:38 Tue 04 Jun , Greg KH wrote:
>I'm announcing the release of the 5.0.21 kernel.
>
>All users of the 5.0 kernel series must upgrade.
>
>Note, this is the LAST 5.0.y kernel to be released.  It is now
>end-of-life.  Please move to the 5.1.y kernel tree at this point in
>time.
>
>The updated 5.0.y git tree can be found at:
>	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.0.y
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
> drivers/xen/xen-pciback/pciback_ops.c                  |    2
> include/linux/siphash.h                                |    5
> include/net/netns/ipv4.h                               |    2
> include/uapi/linux/tipc_config.h                       |   10
> net/core/dev.c                                         |    2
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
> 41 files changed, 312 insertions(+), 244 deletions(-)
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
>      Linux 5.0.21
>
>Heiner Kallweit (1):
>      r8169: fix MAC address being lost in PCI D3
>
>Jakub Kicinski (2):
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
>Konrad Rzeszutek Wilk (1):
>      xen/pciback: Don't disable PCI_COMMAND on PCI device reset.
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



--K8nIJk4ghYZn606h
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAlz2KLgACgkQsjqdtxFL
KRUf+gf/e/yYQox7coZor7MfMrIQwvS9BmksSZ9DYwF9F63rWz8lzbKTN9pT6hKe
P8/HFFHq5yy9Yvv9tkCsfa+fpfiTo1eIUWQndVgXH2uqjnlBDSF6HTp8W9EPfxs8
TqHlzjkr7c4WFkZoj2wNKXufFPXf2gdYjwiEM7/8l95rFwwKctXAR7hHeBuLpJEB
adc7h8tnmcfthEfJ50UEglQn3aHqKoVtf+bvP9eckc3LMz2Xa4g4DY2DpvDMZRso
QHFrdzhriRXbwRGhBYsNt3ewejlT/ai94cW4QnDD3fa7sfVmVIkvNapS4lrslnB5
66wlbz7eAwYdu43eG2KdP1/9eXNRsQ==
=LeE4
-----END PGP SIGNATURE-----

--K8nIJk4ghYZn606h--

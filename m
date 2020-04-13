Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B94C71A67BF
	for <lists+stable@lfdr.de>; Mon, 13 Apr 2020 16:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730509AbgDMOS3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Apr 2020 10:18:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:48458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730508AbgDMOS3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Apr 2020 10:18:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6CA82075E;
        Mon, 13 Apr 2020 14:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586787508;
        bh=6njGK8AxXTRP6KBcSmipD5AP5YkdiEtpH27PiA2mVSw=;
        h=Date:From:To:Cc:Subject:From;
        b=sqpKYfJuOnREYoxHe4Sfdh/ETY3RF8bd5Id8CB5u9YyJoAqZuwQLLUl6ow/FnpIvN
         wfA5167uGP4Y3EwVp6aBmDJ7d9nnhhPJsiNAO5UgcscD65AQqkSuy0x8PKMtW5NRjK
         rMTb7oK/Zf6la82VdHz/j20XT7vt3aZdP/CYdIbA=
Date:   Mon, 13 Apr 2020 16:18:26 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.9.219
Message-ID: <20200413141826.GA3547401@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.9.219 kernel.

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

 Makefile                                             |    2=20
 arch/arm64/kernel/head.S                             |    2=20
 block/blk-mq-tag.c                                   |    9 ++-
 block/blk-mq.c                                       |    4 +
 drivers/char/random.c                                |   10 ---
 drivers/clk/qcom/clk-rcg2.c                          |    2=20
 drivers/gpu/drm/bochs/bochs_hw.c                     |    6 --
 drivers/gpu/drm/drm_dp_mst_topology.c                |    1=20
 drivers/gpu/drm/etnaviv/etnaviv_buffer.c             |   10 ++-
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c                |    2=20
 drivers/gpu/drm/etnaviv/etnaviv_gpu.h                |    1=20
 drivers/gpu/drm/etnaviv/etnaviv_mmu.c                |    6 +-
 drivers/gpu/drm/etnaviv/etnaviv_mmu.h                |    2=20
 drivers/gpu/drm/msm/msm_gem.c                        |   47 ++++++++++++++=
--
 drivers/infiniband/core/cma.c                        |    1=20
 drivers/infiniband/hw/hfi1/sysfs.c                   |   26 ++++++---
 drivers/net/can/slcan.c                              |    4 -
 drivers/net/dsa/bcm_sf2.c                            |    7 ++
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c |    2=20
 drivers/net/phy/micrel.c                             |    7 ++
 drivers/usb/dwc3/gadget.c                            |    1=20
 fs/ceph/super.c                                      |   54 ++++++++++++--=
-----
 fs/ceph/super.h                                      |    2=20
 include/uapi/linux/coresight-stm.h                   |    6 +-
 kernel/padata.c                                      |    4 -
 mm/mempolicy.c                                       |    6 +-
 net/bluetooth/rfcomm/tty.c                           |    4 -
 net/dsa/tag_brcm.c                                   |    4 -
 net/ipv4/fib_trie.c                                  |    3 +
 net/ipv4/ip_tunnel.c                                 |    6 --
 net/l2tp/l2tp_core.c                                 |    6 ++
 net/l2tp/l2tp_core.h                                 |    1=20
 net/l2tp/l2tp_ppp.c                                  |    8 +-
 net/sctp/ipv6.c                                      |   20 ++++---
 net/sctp/protocol.c                                  |   28 ++++++---
 net/sctp/socket.c                                    |   31 ++++++++--
 sound/soc/jz4740/jz4740-i2s.c                        |    2=20
 tools/accounting/getdelays.c                         |    2=20
 38 files changed, 232 insertions(+), 107 deletions(-)

Arun KS (1):
      arm64: Fix size of __early_cpu_boot_status

Avihai Horon (1):
      RDMA/cm: Update num_paths in cma_resolve_iboe_route error flow

Daniel Jordan (1):
      padata: always acquire cpu_hotplug_lock before pinst->lock

David Ahern (1):
      tools/accounting/getdelays.c: fix netlink attribute length

Eugene Syromiatnikov (1):
      coresight: do not use the BIT() macro in the UAPI header

Florian Fainelli (2):
      net: dsa: tag_brcm: Fix skb->fwd_offload_mark location
      net: dsa: bcm_sf2: Ensure correct sub-node is parsed

Gerd Hoffmann (1):
      drm/bochs: downgrade pci_request_region failure from error to warning

Greg Kroah-Hartman (1):
      Linux 4.9.219

Guillaume Nault (2):
      l2tp: ensure sessions are freed after their PPPOL2TP socket
      l2tp: fix race between l2tp_session_delete() and l2tp_tunnel_closeall=
()

Hans Verkuil (1):
      drm_dp_mst_topology: fix broken drm_dp_sideband_parse_remote_dpcd_rea=
d()

Ilya Dryomov (1):
      ceph: canonicalize server path in place

Jason A. Donenfeld (1):
      random: always use batched entropy for get_random_u{32,64}

Jianchao Wang (1):
      blk-mq: sync the update nr_hw_queues with blk_mq_queue_tag_busy_iter

Jisheng Zhang (1):
      net: stmmac: dwmac1000: fix out-of-bounds mac address reg setting

Kaike Wan (2):
      IB/hfi1: Call kobject_put() when kobject_init_and_add() fails
      IB/hfi1: Fix memory leaks in sysfs registration and unregistration

Keith Busch (1):
      blk-mq: Allow blocking queue tag iter callbacks

Lucas Stach (1):
      drm/etnaviv: replace MMU flush marker with flush sequence

Marcelo Ricardo Leitner (1):
      sctp: fix possibly using a bad saddr with a given dst

Oleksij Rempel (1):
      net: phy: micrel: kszphy_resume(): add delay after genphy_resume() be=
fore accessing PHY registers

Paul Cercueil (1):
      ASoC: jz4740-i2s: Fix divider written at incorrect offset in register

Qian Cai (1):
      ipv4: fix a RCU-list lock in fib_triestat_seq_show

Qiujun Huang (2):
      sctp: fix refcount bug in sctp_wfree
      Bluetooth: RFCOMM: fix ODEBUG bug in rfcomm_dev_ioctl

Randy Dunlap (1):
      mm: mempolicy: require at least one nodeid for MPOL_PREFERRED

Richard Palethorpe (1):
      slcan: Don't transmit uninitialized stack data in padding

Rob Clark (2):
      drm/msm: stop abusing dma_map/unmap for cache
      drm/msm: Use the correct dma_sync calls in msm_gem

Roger Quadros (1):
      usb: dwc3: don't set gadget->is_otg flag

Taniya Das (1):
      clk: qcom: rcg: Return failure for RCG update

William Dauchy (1):
      net, ip_tunnel: fix interface lookup with no key

Xiubo Li (1):
      ceph: remove the extra slashes in the server path


--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl6UdK8ACgkQONu9yGCS
aT6PghAAsD13KfV1QCsiXdzdMLlJZOQaxZKY9TOgNj4Ah2JA3l8JJy8Ed1tjDDdy
b27X4ZEUwwIZBPYUA+u+y1STjEy4BhYSSDeQOf9YsKCvD9glHDiKbVRTkbWwLdUk
f5gx+WFiH5bt4Oh5mUnsxrKxEVKIU2nKzoceCw9bYG328+s/hL/fpowXPfZPfuGB
bG2vT0Q6Q2a8pXWAqlig+yubxzHJ8Q93znoBntGtuwIXECuTd7+Dn/tgN6+Tk1zg
yjbFPW2hfooIn3NFTnN7AvYDK6AzeEzoSga+v1EwmPpaHrDeTIe1JtBwO9wCdXRP
2OeX8Z313DquAYh3p/wU0nddEqCYbeB5AUe6CH0jFyfOuTSvfzW+oJHhk1sBNknX
TfXy+RfY/X5lxAf/FPLR8kieYL5dBRUCLf1Wu9wJUAHFCKFh3ccDeaZtRL8yxXSv
DpwO+iU5vs1g9edI7ghi0JG/a5yyL6NYOXtQRNPZP9OhUfZDY9I3KLWbzohDozPy
aSilnMQF4vUEHdy8NvgXG+DcxWLzsoRIRdkb8Et1HqstIblk3/FYbvNhHi9Q3Z3I
ryPaxTBzhoPHCtFTRX+dkTF/FjUF8udX0w2rr+HpkZ+75KSB5iMevJRBHOn1wnFQ
jI4KaIe/Ap4Z5Ejl2nCSl+iZP5O/FcNyzUzJXi6NBIQZw8NQBEQ=
=VBrl
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--

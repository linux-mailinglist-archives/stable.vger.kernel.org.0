Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6D71A67CA
	for <lists+stable@lfdr.de>; Mon, 13 Apr 2020 16:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730551AbgDMOU0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Apr 2020 10:20:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:49200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730546AbgDMOUY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Apr 2020 10:20:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2FF3D2075E;
        Mon, 13 Apr 2020 14:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586787623;
        bh=lmTilo/mB1eKlNbyNDmn4HJtM5rB3TFcFrYUnL52FDw=;
        h=Date:From:To:Cc:Subject:From;
        b=hP8fRYl87cCeNjlfePzn1YWWtnE/T6cVTul0EhvPe8Rz5XXs3LMOcqmowlFMYHf6G
         DQT7yS5JyYXukirMevIFztxQmRvngCtn3mnUQ/qdYqgOJaRD/gyLoGELxxM6wobioy
         5HUToiP3tojRkkSYah9PjQyKLhksFxX4UhkBpXBM=
Date:   Mon, 13 Apr 2020 16:20:21 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.176
Message-ID: <20200413142021.GA3547641@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.14.176 kernel.

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

 Makefile                                              |    2=20
 arch/arm64/kernel/head.S                              |    2=20
 block/blk-mq-tag.c                                    |    9 ++
 block/blk-mq.c                                        |    4 +
 drivers/acpi/nfit/core.c                              |   24 ++++---
 drivers/char/hw_random/imx-rngc.c                     |    4 -
 drivers/char/random.c                                 |   20 +-----
 drivers/clk/qcom/clk-rcg2.c                           |    2=20
 drivers/gpu/drm/bochs/bochs_hw.c                      |    6 -
 drivers/gpu/drm/drm_dp_mst_topology.c                 |    1=20
 drivers/gpu/drm/etnaviv/etnaviv_buffer.c              |   10 +--
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c                 |    2=20
 drivers/gpu/drm/etnaviv/etnaviv_gpu.h                 |    1=20
 drivers/gpu/drm/etnaviv/etnaviv_mmu.c                 |    8 +-
 drivers/gpu/drm/etnaviv/etnaviv_mmu.h                 |    2=20
 drivers/gpu/drm/msm/msm_gem.c                         |   47 +++++++++++++=
--
 drivers/infiniband/core/cma.c                         |    1=20
 drivers/infiniband/hw/hfi1/sysfs.c                    |   26 ++++++--
 drivers/misc/pci_endpoint_test.c                      |    2=20
 drivers/net/can/slcan.c                               |    4 -
 drivers/net/dsa/bcm_sf2.c                             |    7 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c |    8 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c  |    2=20
 drivers/net/phy/micrel.c                              |    7 ++
 drivers/rpmsg/qcom_glink_native.c                     |    3=20
 drivers/rpmsg/qcom_glink_smem.c                       |   12 +--
 drivers/usb/dwc3/gadget.c                             |    1=20
 drivers/video/fbdev/core/fbcon.c                      |    3=20
 fs/ceph/super.c                                       |   56 +++++++++++--=
-----
 fs/ceph/super.h                                       |    2=20
 include/uapi/linux/coresight-stm.h                    |    6 +
 kernel/padata.c                                       |    4 -
 mm/mempolicy.c                                        |    6 +
 net/bluetooth/rfcomm/tty.c                            |    4 -
 net/ipv4/fib_trie.c                                   |    3=20
 net/ipv4/ip_tunnel.c                                  |    6 -
 net/ipv6/addrconf.c                                   |    4 +
 net/sctp/ipv6.c                                       |   20 ++++--
 net/sctp/protocol.c                                   |   28 ++++++---
 net/sctp/socket.c                                     |   31 +++++++--
 sound/soc/jz4740/jz4740-i2s.c                         |    2=20
 tools/accounting/getdelays.c                          |    2=20
 tools/power/x86/turbostat/turbostat.c                 |    4 -
 usr/Kconfig                                           |   22 +++----
 44 files changed, 270 insertions(+), 150 deletions(-)

Arun KS (1):
      arm64: Fix size of __early_cpu_boot_status

Arun Kumar Neelakantam (1):
      rpmsg: glink: smem: Support rx peak for size less than 4 bytes

Avihai Horon (1):
      RDMA/cm: Update num_paths in cma_resolve_iboe_route error flow

Chris Lew (1):
      rpmsg: glink: Remove chunk size word align warning

Dan Williams (1):
      acpi/nfit: Fix bus command validation

Daniel Jordan (1):
      padata: always acquire cpu_hotplug_lock before pinst->lock

David Ahern (1):
      tools/accounting/getdelays.c: fix netlink attribute length

Eugene Syromiatnikov (1):
      coresight: do not use the BIT() macro in the UAPI header

Eugeniy Paltsev (1):
      initramfs: restore default compression behavior

Florian Fainelli (1):
      net: dsa: bcm_sf2: Ensure correct sub-node is parsed

Gerd Hoffmann (1):
      drm/bochs: downgrade pci_request_region failure from error to warning

Greg Kroah-Hartman (1):
      Linux 4.14.176

Hans Verkuil (1):
      drm_dp_mst_topology: fix broken drm_dp_sideband_parse_remote_dpcd_rea=
d()

Ilya Dryomov (1):
      ceph: canonicalize server path in place

Jarod Wilson (1):
      ipv6: don't auto-add link-local address to lag ports

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

Kishon Vijay Abraham I (1):
      misc: pci_endpoint_test: Fix to support > 10 pci-endpoint-test devices

Len Brown (1):
      tools/power turbostat: Fix gcc build warnings

Lucas Stach (1):
      drm/etnaviv: replace MMU flush marker with flush sequence

Marcelo Ricardo Leitner (1):
      sctp: fix possibly using a bad saddr with a given dst

Martin Kaiser (1):
      hwrng: imx-rngc - fix an error path

Oleksij Rempel (1):
      net: phy: micrel: kszphy_resume(): add delay after genphy_resume() be=
fore accessing PHY registers

Paul Cercueil (1):
      ASoC: jz4740-i2s: Fix divider written at incorrect offset in register

Petr Machata (1):
      mlxsw: spectrum_flower: Do not stop at FLOW_ACTION_VLAN_MANGLE

Qian Cai (1):
      ipv4: fix a RCU-list lock in fib_triestat_seq_show

Qiujun Huang (3):
      sctp: fix refcount bug in sctp_wfree
      Bluetooth: RFCOMM: fix ODEBUG bug in rfcomm_dev_ioctl
      fbcon: fix null-ptr-deref in fbcon_switch

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


--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl6UdSUACgkQONu9yGCS
aT6X1A/+P7+1vVzt1eUC1316E3N8ipoXOpTwYEqhPSv1rUlUosfMQWg4THNVRq4P
x0Pk/q2H0BDvZUFx2AG4qVfCgyIBaX4h/YSM5vB1GvajqUzP2fnDtGZXeYwyVrNO
6NhDKMTaDAhJg5W6Bjm7sisP3C6HhJ5002cMJHUJBibrs3QDp9XP0v0TKSTqXiM3
PtQjenuHEnn/uASWyGMkRRlxVagogoD5uMm7l2bta0T+fVyZRvsAwhOeBNcRFuw3
jngqI/LetbxcmvQ0M8yOlo5n7NvI34P6VUSrxyh2nMQePToAeVJ40FbkqyFbejN2
8gCk7ipn245I1PLzS5R8RgaY5bqG6M61dXI4P95CmjUEJZitdNpWvLOogRwJjlDc
RH29iIIjLalRrOx/O7JwHbIv7ZaIkblrx+xeLdZ7rylkFcOlxYUMK3k8J9Y9lZL7
h+EQeWxaBI9osXLo5FaWmI5KMu8witLwYUVgB6uni3u6hwuZfBFfo1rZKQyEL+/T
MxajY7F6aniqgJ9vBQEcf62mFk59DJBo6vkkX5qQ1DM1s3XfPSpqolxQL/KhI4P0
Ny0qC0N1AnOGZHn+WFdKczYN1QcRrFWoNezIYKnoanu2Ui+PrttM6kiI0qOR+70E
K0VrZUObjZjPE8Ez+pGDhCn0/fbHC9syJClcYX1OaOaO6Yyezkc=
=ZC5f
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--

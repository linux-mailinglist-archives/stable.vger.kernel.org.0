Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2711A67F2
	for <lists+stable@lfdr.de>; Mon, 13 Apr 2020 16:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730604AbgDMOXE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Apr 2020 10:23:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:50520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730593AbgDMOXD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Apr 2020 10:23:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07CDE2075E;
        Mon, 13 Apr 2020 14:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586787781;
        bh=0q4wIuVdi2Hyz/iaXUk9Wih8dfvmhFFVe4i/gQnPVeM=;
        h=Date:From:To:Cc:Subject:From;
        b=UWZjWFIAUGTzPtGCSo9jEbD5mzmfFKAo2UFv5pqcnNBblGlk/WK9YBwD7fmZE5NNx
         JxV7pAO46Pm4okgf8NfGmwfiggv7GdSFFX1Rh6bf8+BX4EdfZ32dNS8appXqUgjima
         AyutZWDb+pFGlMd0dWnxz3Og+truxnd9JGQ249Tc=
Date:   Mon, 13 Apr 2020 16:22:59 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.115
Message-ID: <20200413142259.GA3548020@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[first try failed, sorry about that, error was on my side, not on the
image on kernel.org's side, that's fine.]

I'm announcing the release of the 4.19.115 kernel.

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

 Makefile                                              |    2=20
 arch/arm64/kernel/head.S                              |    2=20
 drivers/char/hw_random/imx-rngc.c                     |    4 -
 drivers/char/random.c                                 |   20 +-----
 drivers/clk/qcom/clk-rcg2.c                           |    2=20
 drivers/extcon/extcon-axp288.c                        |   32 ++++++++++
 drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c                 |    2=20
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c      |   11 +++
 drivers/gpu/drm/bochs/bochs_hw.c                      |    6 -
 drivers/gpu/drm/drm_dp_mst_topology.c                 |    1=20
 drivers/gpu/drm/etnaviv/etnaviv_buffer.c              |   10 +--
 drivers/gpu/drm/etnaviv/etnaviv_gpu.h                 |    1=20
 drivers/gpu/drm/etnaviv/etnaviv_mmu.c                 |    6 -
 drivers/gpu/drm/etnaviv/etnaviv_mmu.h                 |    2=20
 drivers/gpu/drm/msm/msm_gem.c                         |   47 +++++++++++++-
 drivers/infiniband/core/cma.c                         |   14 ++++
 drivers/infiniband/core/ucma.c                        |   49 +++++++++++++=
+-
 drivers/infiniband/hw/hfi1/sysfs.c                    |   26 ++++++--
 drivers/media/rc/lirc_dev.c                           |    2=20
 drivers/misc/cardreader/rts5227.c                     |    1=20
 drivers/misc/mei/hw-me-regs.h                         |    2=20
 drivers/misc/mei/pci-me.c                             |    2=20
 drivers/misc/pci_endpoint_test.c                      |   14 +++-
 drivers/net/can/slcan.c                               |    4 -
 drivers/net/dsa/bcm_sf2.c                             |    9 ++
 drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c |    8 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c  |    2=20
 drivers/net/phy/micrel.c                              |    7 ++
 drivers/nvme/host/rdma.c                              |    8 +-
 drivers/power/supply/axp288_charger.c                 |   57 +++++++++++++=
++++-
 drivers/rpmsg/qcom_glink_native.c                     |    3=20
 drivers/usb/dwc3/gadget.c                             |    3=20
 drivers/video/fbdev/core/fbcon.c                      |    3=20
 fs/ceph/super.c                                       |   56 +++++++++++--=
----
 fs/ceph/super.h                                       |    2=20
 include/linux/bitops.h                                |   14 ++--
 include/linux/notifier.h                              |    3=20
 include/uapi/linux/coresight-stm.h                    |    6 +
 kernel/padata.c                                       |    4 -
 mm/mempolicy.c                                        |    6 +
 net/bluetooth/rfcomm/tty.c                            |    4 -
 net/core/dev.c                                        |    2=20
 net/ipv4/fib_trie.c                                   |    3=20
 net/ipv4/ip_tunnel.c                                  |    6 -
 net/ipv6/addrconf.c                                   |    4 +
 net/rxrpc/sendmsg.c                                   |    4 -
 net/sctp/ipv6.c                                       |   20 ++++--
 net/sctp/protocol.c                                   |   28 ++++++--
 net/sctp/socket.c                                     |   31 +++++++--
 sound/pci/hda/patch_ca0132.c                          |    1=20
 sound/soc/jz4740/jz4740-i2s.c                         |    2=20
 tools/accounting/getdelays.c                          |    2=20
 tools/power/x86/turbostat/turbostat.c                 |   27 +++++---
 usr/Kconfig                                           |   22 +++---
 54 files changed, 448 insertions(+), 161 deletions(-)

Alexander Usyskin (1):
      mei: me: add cedar fork device ids

Amritha Nambiar (1):
      net: Fix Tx hash bound checking

Arun KS (1):
      arm64: Fix size of __early_cpu_boot_status

Avihai Horon (1):
      RDMA/cm: Update num_paths in cma_resolve_iboe_route error flow

Chris Lew (1):
      rpmsg: glink: Remove chunk size word align warning

Daniel Jordan (1):
      padata: always acquire cpu_hotplug_lock before pinst->lock

David Ahern (1):
      tools/accounting/getdelays.c: fix netlink attribute length

David Howells (1):
      rxrpc: Fix sendmsg(MSG_WAITALL) handling

Eugene Syromiatnikov (1):
      coresight: do not use the BIT() macro in the UAPI header

Eugeniy Paltsev (1):
      initramfs: restore default compression behavior

Florian Fainelli (2):
      net: dsa: bcm_sf2: Do not register slave MDIO bus with OF
      net: dsa: bcm_sf2: Ensure correct sub-node is parsed

Geoffrey Allott (1):
      ALSA: hda/ca0132 - Add Recon3Di quirk to handle integrated sound on E=
VGA X99 Classified motherboard

Gerd Hoffmann (1):
      drm/bochs: downgrade pci_request_region failure from error to warning

Greg Kroah-Hartman (1):
      Linux 4.19.115

Hans Verkuil (1):
      drm_dp_mst_topology: fix broken drm_dp_sideband_parse_remote_dpcd_rea=
d()

Hans de Goede (2):
      extcon: axp288: Add wakeup support
      power: supply: axp288_charger: Add special handling for HP Pavilion x=
2 10

Ilya Dryomov (1):
      ceph: canonicalize server path in place

James Zhu (1):
      drm/amdgpu: fix typo for vcn1 idle check

Jarod Wilson (1):
      ipv6: don't auto-add link-local address to lag ports

Jason A. Donenfeld (1):
      random: always use batched entropy for get_random_u{32,64}

Jason Gunthorpe (2):
      RDMA/ucma: Put a lock around every call to the rdma_cm layer
      RDMA/cma: Teach lockdep about the order of rtnl and lock

Jisheng Zhang (1):
      net: stmmac: dwmac1000: fix out-of-bounds mac address reg setting

Kaike Wan (2):
      IB/hfi1: Call kobject_put() when kobject_init_and_add() fails
      IB/hfi1: Fix memory leaks in sysfs registration and unregistration

Kishon Vijay Abraham I (2):
      misc: pci_endpoint_test: Fix to support > 10 pci-endpoint-test devices
      misc: pci_endpoint_test: Avoid using module parameter to determine ir=
qtype

Len Brown (2):
      tools/power turbostat: Fix gcc build warnings
      tools/power turbostat: Fix missing SYS_LPI counter on some Chromebooks

Lucas Stach (1):
      drm/etnaviv: replace MMU flush marker with flush sequence

Marcelo Ricardo Leitner (1):
      sctp: fix possibly using a bad saddr with a given dst

Mario Kleiner (1):
      drm/amd/display: Add link_rate quirk for Apple 15" MBP 2017

Martin Kaiser (1):
      hwrng: imx-rngc - fix an error path

Miklos Szeredi (1):
      bitops: protect variables in set_mask_bits() macro

Oleksij Rempel (1):
      net: phy: micrel: kszphy_resume(): add delay after genphy_resume() be=
fore accessing PHY registers

Paul Cercueil (1):
      ASoC: jz4740-i2s: Fix divider written at incorrect offset in register

Petr Machata (1):
      mlxsw: spectrum_flower: Do not stop at FLOW_ACTION_VLAN_MANGLE

Prabhath Sajeepa (1):
      nvme-rdma: Avoid double freeing of async event data

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

Sam Protsenko (1):
      include/linux/notifier.h: SRCU: fix ctags

Sean Young (1):
      media: rc: IR signal for Panasonic air conditioner too long

Taniya Das (1):
      clk: qcom: rcg: Return failure for RCG update

Thinh Nguyen (1):
      usb: dwc3: gadget: Wrap around when skip TRBs

William Dauchy (1):
      net, ip_tunnel: fix interface lookup with no key

Xiubo Li (1):
      ceph: remove the extra slashes in the server path

YueHaibing (1):
      misc: rtsx: set correct pcr_ops for rts522A


--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl6UdcMACgkQONu9yGCS
aT7M2BAAmVTpDC3vDTZ4yF2NvUlE1WdNq0VasabS576UknSD8B1CQJTK+S32+IDe
a6P4fikUgltVkJOfjzjT2zudmVVgCkJL8JPXkEup5yzsXFGwZ8VR6NuyDdudf3pn
a8kNy0wsS5xUUTxYa+K7SAxjQqhWjR/HrOXxmMb1IFOdHJ7/f2rEB6qW3OZAI7Qb
L3KIC0CfFEGijOUz+lgy2v0/53mbb18XjEZNct7HKgKUs3OvVVPxzn6+5RPzqYeF
wE7nFTjLf9KgYy3RMVU0GpYceq735C+tVWivx7lb5doPKno8zJ26iV2POC1wc46n
1G5v1JXiSiNQDiP5Js8exkKhtmzVx1m/A2LhBAvZX3O+FDqQLrWNtpWLgqaBTqoZ
T0bmG5T2ThtQoutLqVhQF0kvu3DA0+hnTy4Ao3mkSuXZhNqNJUk7Fv48XZ61Ohr1
5OZuoKjN7yrPmkuJK+msGJ3AVC1CiZ0kYbp8DhpTI61v38UF34ouHUEiL43X1Ql3
mkV3B/aJ4viLx515y5JjfT++fOKM0IoeMqqklu1IM8/5nz7fX40TVLf4pThqTZxL
1r8nk4SZkUMOBuM7jSoCDvIGSDnVmk5xtSjz6+CckTWUxhhSGDFl/OQtTm01yq0H
rWjzgfZybK1Bxq2ViE2jMd4jfoeI8J+3Q7U+3UaEEX0vezjd3n8=
=S3cW
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--

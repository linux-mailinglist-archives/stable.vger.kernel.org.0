Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5EBD88146
	for <lists+stable@lfdr.de>; Fri,  9 Aug 2019 19:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436864AbfHIRdc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Aug 2019 13:33:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:40116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436858AbfHIRdb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Aug 2019 13:33:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50D7E20B7C;
        Fri,  9 Aug 2019 17:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565372010;
        bh=TJBBWPij9xZkEjIlloShzZqaHgHv5SW8L9Vv/DBsyFw=;
        h=Date:From:To:Cc:Subject:From;
        b=xkrdrjphypxkGREeBnl6CKuFy/DlHgdtmcHR3kv8NoHO7i4Traxp5oPmD5GqgR1V+
         YuP7sCxZPl8zthj4D/lomiddCyx7a0XGp32HA8C3587h9pki+/pFghMVEy6AKviCWZ
         o44kzkfeTT2CRPu9K5gM2ODqgPmcLEEIhU3kzFQI=
Date:   Fri, 9 Aug 2019 19:33:28 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.2.8
Message-ID: <20190809173328.GA18975@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Nq2Wo0NMKNjxTN9z"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.2.8 kernel.

All users of the 5.2 kernel series must upgrade.

The updated 5.2.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.2.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                                  |    2=20
 drivers/atm/iphase.c                                      |    8 +
 drivers/gpu/drm/i915/intel_bios.c                         |    2=20
 drivers/gpu/drm/i915/intel_vbt_defs.h                     |    6 -
 drivers/hid/hid-ids.h                                     |    1=20
 drivers/hid/hid-quirks.c                                  |    1=20
 drivers/hid/wacom_wac.c                                   |   12 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c           |    3=20
 drivers/net/ethernet/marvell/mvmdio.c                     |   28 ++++-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c           |   46 ++------
 drivers/net/ethernet/mellanox/mlx5/core/dev.c             |    2=20
 drivers/net/ethernet/mellanox/mlx5/core/en/port.c         |   27 +++--
 drivers/net/ethernet/mellanox/mlx5/core/en/port.h         |    6 -
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c      |   67 ++++++++-=
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c         |    5=20
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c           |    4=20
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h         |    5=20
 drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c     |    5=20
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c            |    2=20
 drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c    |    4=20
 drivers/net/ethernet/mscc/ocelot.c                        |    1=20
 drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h           |    2=20
 drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c      |   13 +-
 drivers/net/ethernet/realtek/r8169.c                      |    9 +
 drivers/net/ethernet/rocker/rocker_main.c                 |    1=20
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c         |    5=20
 drivers/net/phy/fixed_phy.c                               |    6 -
 drivers/net/phy/mscc.c                                    |   16 +--
 drivers/net/phy/phy_device.c                              |    6 +
 drivers/net/phy/phylink.c                                 |   10 +
 drivers/net/ppp/pppoe.c                                   |    3=20
 drivers/net/ppp/pppox.c                                   |   13 ++
 drivers/net/ppp/pptp.c                                    |    3=20
 drivers/net/tun.c                                         |    9 +
 drivers/nfc/nfcmrvl/main.c                                |    4=20
 drivers/nfc/nfcmrvl/uart.c                                |    4=20
 drivers/nfc/nfcmrvl/usb.c                                 |    1=20
 drivers/nvdimm/bus.c                                      |   73 ++++++++-=
-----
 drivers/nvdimm/region_devs.c                              |    4=20
 drivers/scsi/fcoe/fcoe_ctlr.c                             |   51 +++------
 drivers/scsi/libfc/fc_rport.c                             |    5=20
 drivers/spi/spi-bcm2835.c                                 |    3=20
 fs/compat_ioctl.c                                         |    3=20
 include/linux/if_pppox.h                                  |    3=20
 include/linux/mlx5/fs.h                                   |    1=20
 include/linux/mlx5/mlx5_ifc.h                             |    6 -
 include/scsi/libfcoe.h                                    |    1=20
 net/bridge/br.c                                           |    5=20
 net/bridge/br_multicast.c                                 |    3=20
 net/bridge/br_private.h                                   |    9 -
 net/bridge/br_vlan.c                                      |   29 +++--
 net/core/dev.c                                            |   17 ++-
 net/ipv4/ipip.c                                           |    3=20
 net/ipv6/ip6_gre.c                                        |    3=20
 net/ipv6/ip6_tunnel.c                                     |    6 -
 net/l2tp/l2tp_ppp.c                                       |    3=20
 net/mac80211/iface.c                                      |    1=20
 net/sched/act_bpf.c                                       |    9 -
 net/sched/act_connmark.c                                  |    9 -
 net/sched/act_csum.c                                      |    9 -
 net/sched/act_gact.c                                      |    8 -
 net/sched/act_ife.c                                       |   13 +-
 net/sched/act_mirred.c                                    |   13 +-
 net/sched/act_nat.c                                       |    9 -
 net/sched/act_pedit.c                                     |   10 +
 net/sched/act_police.c                                    |    8 -
 net/sched/act_sample.c                                    |   10 -
 net/sched/act_simple.c                                    |   10 +
 net/sched/act_skbedit.c                                   |   11 +-
 net/sched/act_skbmod.c                                    |   11 +-
 net/sched/act_tunnel_key.c                                |    8 -
 net/sched/act_vlan.c                                      |   25 +++-
 net/sched/sch_codel.c                                     |    6 -
 net/smc/af_smc.c                                          |   15 +-
 net/tipc/netlink_compat.c                                 |   11 +-
 net/tipc/socket.c                                         |    3=20
 net/vmw_vsock/hyperv_transport.c                          |    8 +
 sound/usb/helper.c                                        |   17 +++
 sound/usb/helper.h                                        |    1=20
 sound/usb/quirks.c                                        |   18 ++-
 tools/testing/selftests/bpf/Makefile                      |    3=20
 tools/testing/selftests/bpf/test_xdp_vlan.sh              |   57 ++++++++--
 tools/testing/selftests/bpf/test_xdp_vlan_mode_generic.sh |    9 +
 tools/testing/selftests/bpf/test_xdp_vlan_mode_native.sh  |    9 +
 84 files changed, 578 insertions(+), 313 deletions(-)

Aaron Armstrong Skomra (1):
      HID: wacom: fix bit shift for Cintiq Companion 2

Alexis Bauvin (1):
      tun: mark small packets as owned by the tap sock

Andreas Schwab (1):
      net: phy: mscc: initialize stats array

Ariel Levkovich (1):
      net/mlx5e: Prevent encap flow counter update async to user query

Arnaud Patard (1):
      drivers/net/ethernet/marvell/mvmdio.c: Fix non OF case

Arnd Bergmann (1):
      compat_ioctl: pppoe: fix PPPOEIOCSFWD handling

Arseny Solokha (1):
      net: phylink: don't start and stop SGMII PHYs in SFP modules twice

Aya Levin (1):
      net/mlx5e: Fix matching of speed to PRM link modes

Claudiu Manoil (1):
      ocelot: Cancel delayed work before wq destruction

Colin Ian King (1):
      rocker: fix memory leaks of fib_work on two error return paths

Cong Wang (1):
      ife: error out when nla attributes are empty

Dan Williams (2):
      libnvdimm/bus: Prepare the nd_ioctl() path to be re-entrant
      libnvdimm/bus: Fix wait_nvdimm_bus_probe_idle() ABBA deadlock

Dexuan Cui (1):
      hv_sock: Fix hang when a connection is closed

Dhinakaran Pandiyan (1):
      drm/i915/vbt: Fix VBT parsing for the PSR section

Dmytro Linkin (1):
      net: sched: use temporary variable for actions indexes

Edward Srouji (1):
      net/mlx5: Fix modify_cq_in alignment

Frode Isaksen (1):
      net: stmmac: Use netif_tx_napi_add() for TX polling function

Greg Kroah-Hartman (1):
      Linux 5.2.8

Gustavo A. R. Silva (1):
      atm: iphase: Fix Spectre v1 vulnerability

Haishuang Yan (3):
      ip6_gre: reload ipv6h in prepare_ip6gre_xmit_ipv6
      ip6_tunnel: fix possible use-after-free on xmit
      ipip: validate header length in ipip_tunnel_xmit

Hannes Reinecke (1):
      scsi: fcoe: Embed fc_rport_priv in fcoe_rport structure

Heiner Kallweit (2):
      r8169: don't use MSI before RTL8168d
      net: phy: fix race in genphy_update_link

Hillf Danton (1):
      ALSA: usb-audio: Fix gpf in snd_usb_pipe_sanity_check

Hubert Feurstein (1):
      net: phy: fixed_phy: print gpio error only if gpio node is present

Jesper Dangaard Brouer (4):
      bpf: fix XDP vlan selftests test_xdp_vlan.sh
      selftests/bpf: add wrapper scripts for test_xdp_vlan.sh
      selftests/bpf: reduce time to execute test_xdp_vlan.sh
      net: fix bpf_xdp_adjust_head regression for generic-XDP

Jia-Ju Bai (1):
      net: sched: Fix a possible null-pointer dereference in dequeue_func()

Jiri Pirko (2):
      mlxsw: spectrum: Fix error path in mlxsw_sp_module_init()
      net: fix ifindex collision during namespace removal

Johan Hovold (1):
      NFC: nfcmrvl: fix gpio-handling regression

Johannes Berg (1):
      Revert "mac80211: set NETIF_F_LLTX when using intermediate tx queues"

Jon Maloy (1):
      tipc: fix unitilized skb list crash

Lukas Wunner (1):
      spi: bcm2835: Fix 3-wire mode if DMA is enabled

Maor Gottlieb (1):
      net/mlx5: Add missing RDMA_RX capabilities

Mark Zhang (1):
      net/mlx5: Use reversed order when unregister devices

Matteo Croce (2):
      mvpp2: fix panic on module removal
      mvpp2: refactor MTU change code

Nikolay Aleksandrov (3):
      net: bridge: delete local fdb on device init failure
      net: bridge: mcast: don't delete permanent entries when fast leave is=
 enabled
      net: bridge: move default pvid init/deinit to NETDEV_REGISTER/UNREGIS=
TER

Petr Machata (1):
      mlxsw: spectrum_buffers: Further reduce pool size on Spectrum-2

Qian Cai (1):
      net/mlx5e: always initialize frag->last_in_page

Ren=E9 van Dorst (1):
      net: phylink: Fix flow control for fixed-link

Roman Mashak (1):
      net sched: update vlan action for batched events operations

Sebastian Parschauer (1):
      HID: Add quirk for HP X1200 PIXART OEM mouse

Subash Abhinov Kasiviswanathan (1):
      net: qualcomm: rmnet: Fix incorrect UL checksum offload logic

Sudarsana Reddy Kalluru (1):
      bnx2x: Disable multi-cos feature.

Takashi Iwai (1):
      ALSA: usb-audio: Sanity checks for each pipe and EP types

Taras Kondratiuk (1):
      tipc: compat: allow tipc commands without arguments

Ursula Braun (2):
      net/smc: do not schedule tx_work in SMC_CLOSED state
      net/smc: avoid fallback in case of non-blocking connect


--Nq2Wo0NMKNjxTN9z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl1NrmgACgkQONu9yGCS
aT7Wuw//cI9SBsoNz5kBX5E5K0B+iSlZrmtzInjeU5g1TvIQfzEnl1Qe/X898sUv
kb6FAtTW6kuOdlGf8KVbV6GHgBWyIjN6htJTRxVULAK1pXrzwuqzhqJLiVs6f+3Y
hwMVjtmP/c53sK7eUHqxq4rflHVhZ7CQggPRl9mc5AY0nmD2k2J0kRgAGVjmGI7m
01drJ7FGYN3XPyoTrIMT6EsbMzbwPadWK+a/2h2JtNYXEGH+QLZSwg73rWTLij+h
74K7xGC3XZdwT+lkYJbc1GUJ0cRoNHVUINASRKTdhpHJLKstNyU3bQWGSaXOuNbE
T4YagIANGXiG7T5seikMCZYbFUWGkMut3KGqHY5RE9obOsWekGTPgYzcQK3rcMuT
cfBB140J9NFBBWFFx2lSIAII8D94aoK5RINC1tBp0AmnYxGh8xccFiSK964DI6fL
0Mxk/m6sRZiV74dyAU7A/NX4y1iuxmH277pdMrmCKew/Fu3C+Ya6zIJyLMza+nuK
QpFlkGCYTS/iBOTO8bWJt0wC/0oTG7k8+7ll3SvAwcSo6Q0PGN2sRxwVnUn6NwnS
U5XvYB3U1o/avJhWGTTCkExhqQNu0MRTmgcjWrVigLou0orYT8pr6W9AX+4Fje2n
8EQJW3Cf5BU0/yhUA+RjNKDubRJuxZROqRlEUaTjx9k1vFIZ7Ks=
=+P+s
-----END PGP SIGNATURE-----

--Nq2Wo0NMKNjxTN9z--

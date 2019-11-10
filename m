Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A518F6A48
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 17:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbfKJQub (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Nov 2019 11:50:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:45882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726616AbfKJQub (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 10 Nov 2019 11:50:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 669772080F;
        Sun, 10 Nov 2019 16:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573404629;
        bh=OPdMyizUvQfr+Quawidj5lQd+jdzECv5ta9c0OpcmGE=;
        h=Date:From:To:Cc:Subject:From;
        b=EHU9TL3z0MPN3lszN7IQ2HMu5FslsUsUbwWtAwqkB9bOq1GphrF8eDtQ9nTbbdXFC
         jB1kPTjLRfKIrlJZx+3dvnz4crncqjTNLdQR73scog48aV7YPuQvQtCkl+vOKDBKTw
         CfdT+i9FI4patExXmlKC5lpuqpsJkTpME+Zu2ZDw=
Date:   Sun, 10 Nov 2019 17:50:27 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.9.200
Message-ID: <20191110165027.GA2873024@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="envbJBWh7q8WU6mo"
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.9.200 kernel.

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

 Makefile                                              |   14 ++++-
 arch/arm/boot/dts/imx7s.dtsi                          |    8 +--
 arch/arm/boot/dts/logicpd-torpedo-som.dtsi            |    4 +
 arch/arm/mach-davinci/dm365.c                         |    4 -
 arch/arm/mm/alignment.c                               |   44 +++++++++++++=
---
 arch/mips/bcm63xx/prom.c                              |    2=20
 arch/mips/include/asm/bmips.h                         |   10 +--
 arch/mips/kernel/smp-bmips.c                          |    8 +--
 drivers/dma/qcom/bam_dma.c                            |   14 +++++
 drivers/net/ethernet/broadcom/genet/bcmgenet.c        |    9 ++-
 drivers/net/ethernet/hisilicon/hip04_eth.c            |   15 +++--
 drivers/net/ethernet/mellanox/mlx4/resource_tracker.c |   42 +++++++++----=
--
 drivers/net/vxlan.c                                   |    5 +
 drivers/of/unittest.c                                 |    1=20
 drivers/pinctrl/bcm/pinctrl-ns2-mux.c                 |    4 -
 drivers/regulator/pfuze100-regulator.c                |    8 ++-
 drivers/regulator/ti-abb-regulator.c                  |   26 +++------
 drivers/scsi/Kconfig                                  |    2=20
 drivers/scsi/device_handler/scsi_dh_alua.c            |   21 ++++++-
 drivers/scsi/sni_53c710.c                             |    4 -
 drivers/target/target_core_device.c                   |   21 -------
 fs/cifs/cifsglob.h                                    |    5 +
 fs/cifs/cifsproto.h                                   |    1=20
 fs/cifs/file.c                                        |   23 +++++---
 fs/cifs/smb2file.c                                    |    2=20
 include/linux/gfp.h                                   |   23 ++++++++
 include/linux/skbuff.h                                |    3 -
 include/net/flow_dissector.h                          |    3 -
 include/net/fq.h                                      |    2=20
 include/net/fq_impl.h                                 |    4 -
 include/net/sock.h                                    |   11 +++-
 kernel/time/alarmtimer.c                              |    4 -
 net/core/datagram.c                                   |    2=20
 net/core/ethtool.c                                    |    4 +
 net/core/flow_dissector.c                             |   48 +++++++------=
-----
 net/dccp/ipv4.c                                       |    4 -
 net/dsa/dsa2.c                                        |    2=20
 net/ipv4/datagram.c                                   |    2=20
 net/ipv4/tcp_ipv4.c                                   |    4 -
 net/sched/sch_fq_codel.c                              |    6 +-
 net/sched/sch_hhf.c                                   |    8 +--
 net/sched/sch_sfb.c                                   |   13 ++--
 net/sched/sch_sfq.c                                   |   14 +++--
 net/sctp/socket.c                                     |    2=20
 sound/soc/codecs/wm_adsp.c                            |    3 -
 sound/soc/rockchip/rockchip_i2s.c                     |    2=20
 tools/perf/builtin-kmem.c                             |    1=20
 tools/testing/selftests/net/reuseport_dualstack.c     |    3 -
 48 files changed, 285 insertions(+), 180 deletions(-)

Adam Ford (1):
      ARM: dts: logicpd-torpedo-som: Remove twl_keypad

Anson Huang (1):
      ARM: dts: imx7s: Correct GPT's ipg clock source

Axel Lin (1):
      regulator: ti-abb: Fix timeout in ti_abb_wait_txdone/ti_abb_clear_all=
_txdone

Bodo Stroesser (1):
      scsi: target: core: Do not overwrite CDB byte 1

Dan Carpenter (1):
      pinctrl: ns2: Fix off by one bugs in ns2_pinmux_enable()

Dave Wysochanski (1):
      cifs: Fix cifsInodeInfo lock_sem deadlock when reconnect occurs

Doug Berger (1):
      net: bcmgenet: reset 40nm EPHY on energy detect

Eran Ben Elisha (1):
      net/mlx4_core: Dynamically set guaranteed amount of counters per VF

Eric Dumazet (4):
      dccp: do not leak jiffies on the wire
      net: add READ_ONCE() annotation in __skb_wait_for_more_packets()
      inet: stop leaking jiffies on the wire
      net/flow_dissector: switch to siphash

Greg Kroah-Hartman (1):
      Linux 4.9.200

Hannes Reinecke (1):
      scsi: scsi_dh_alua: handle RTPG sense code correctly during state tra=
nsitions

Jeffrey Hugo (1):
      dmaengine: qcom: bam_dma: Fix resource leak

Jiangfeng Xiao (1):
      net: hisilicon: Fix ping latency when deal with high throughput

Jonas Gorski (1):
      MIPS: bmips: mark exception vectors as char arrays

Kees Cook (1):
      Kbuild: make designated_init attribute fatal

Masahiro Yamada (1):
      kbuild: use -fmacro-prefix-map to make __FILE__ a relative path

Navid Emamdoost (1):
      of: unittest: fix memory leak in unittest_data_add

Peter Ujfalusi (1):
      ARM: davinci: dm365: Fix McBSP dma_slave_map entry

Petr Vorel (1):
      alarmtimer: Change remaining ENOTSUPP to EOPNOTSUPP

Robin Murphy (1):
      ASoc: rockchip: i2s: Fix RPM imbalance

Russell King (1):
      ARM: mm: fix alignment handler faults under memory pressure

Seth Forshee (1):
      kbuild: add -fcf-protection=3Dnone when using retpoline flags

Stuart Henderson (1):
      ASoC: wm_adsp: Don't generate kcontrols without READ flags

Tejun Heo (1):
      net: fix sk_page_frag() recursion from memory reclaim

Thomas Bogendoerfer (2):
      scsi: sni_53c710: fix compilation error
      scsi: fix kconfig dependency warning related to 53C700_LE_ON_BE

Vivien Didelot (1):
      net: dsa: fix switch tree list

Wei Wang (1):
      selftests: net: reuseport_dualstack: fix uninitalized parameter

Xin Long (1):
      vxlan: check tun_info options_len properly

Yizhuo (1):
      regulator: pfuze100-regulator: Variable "val" in pfuze100_regulator_p=
robe() could be uninitialized

Yunfeng Ye (1):
      perf kmem: Fix memory leak in compact_gfp_flags()

zhanglin (1):
      net: Zeroing the structure ethtool_wolinfo in ethtool_get_wol()


--envbJBWh7q8WU6mo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl3IP8wACgkQONu9yGCS
aT4BaxAAvo6quZXJwijHQ7TudDQUuW3kFDE+XtkNoj+jJ0Z7QTAj1fIjSwD1G3+k
b5mWGoZpUZgBEWNQ2pcBr51mum2sScQ03k3JgE5x+HBwNYWHX9wpSergZmj0srFl
vsyPsvhsNtFsuPkO3z7+reBLBzt6Xbt/JofGPgUOW3029JtOAcyvpsX8e4Fanq4g
b7MreNqS0uKa3wcQw5uTd11voeH8HZ4P9aPdQAv8D+k5AoRhn/E/vmKa/9umSsOM
zv+wissWP09VhdIqf7I5gwNMzUMsWVcyMOBA7UYD4cwbcHycRxDrQnLrPd68pjyP
abgMJWHMHPa05pCf4v0CCj2mOW/YyrTMHpKJ99/heeY3F+Lzsgpw1jhnvEhLgp4F
FCTsOK1A4X0NbQA/oziLKHtpe1JYCWkv3vmn6319A3xTOM1dfd8wOgthGjZXu8RL
OkUtPyO0QjjnNqort+9j6H6fOvwxKpjRW/zSmGBZomVokXvzvgQjkulRy5bacT3u
se5lMhFAJ/rPjHpdYZmSXmvAOTgM8U3o39usJfiQeB7Xk0HkIWYFTME0PsIR5Rrb
mHZ6p9oPK8oMjFIYS5gbmyRGYwDT2Z62NIaedw0Q6HqigcNC8gBIYz8++kYyb5eF
uWUx0TVS/7UGjNPT8xr5LYdGIKuCKSjE36DFeeORP8wQ1VNRbuk=
=2b1i
-----END PGP SIGNATURE-----

--envbJBWh7q8WU6mo--

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44CCCB386F
	for <lists+stable@lfdr.de>; Mon, 16 Sep 2019 12:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728049AbfIPKmg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Sep 2019 06:42:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:58854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726055AbfIPKmg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Sep 2019 06:42:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 243E8206A4;
        Mon, 16 Sep 2019 10:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568630554;
        bh=9+wlTcELL5AtCJUjiak261GIkPhJgGhOU8ts5mQOiZY=;
        h=Date:From:To:Cc:Subject:From;
        b=MRNXarjCvkzAglQvPyzbgFMqKSpQHIsNqAOM7hatvOwoKr2DmjtJkfvgiVveMbK1P
         otb9hONqI3hf6dyktfUy1uq3KJ3pb1vMANLewaVK6JUSYzPj9Bn7ZZkJn3Ob3Ey1qI
         YHDwR2nz4g0DNYPcq42rap1Ykdxrx9aIyWSIGP1M=
Date:   Mon, 16 Sep 2019 12:42:32 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.144
Message-ID: <20190916104232.GA1386818@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="M9NhX3UHpAaciwkO"
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.14.144 kernel.

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

 Makefile                                       |    2 -
 arch/arm64/boot/dts/rockchip/rk3328-rock64.dts |    2 +
 arch/powerpc/kernel/head_64.S                  |    2 +
 arch/powerpc/kernel/process.c                  |    3 +-
 drivers/clk/clk-s2mps11.c                      |    2 -
 drivers/gpu/drm/vmwgfx/vmwgfx_msg.c            |    8 ++---
 drivers/pci/dwc/pci-dra7xx.c                   |    3 +-
 drivers/pci/dwc/pcie-designware-ep.c           |   34 +++++++++++++++++++-=
-----
 drivers/pci/dwc/pcie-designware.h              |    8 ++++-
 drivers/vhost/test.c                           |   13 ++++++---
 drivers/vhost/vhost.c                          |    4 +-
 include/net/ipv6_frag.h                        |    1=20
 include/net/xfrm.h                             |   17 ++++++++++++
 kernel/module.c                                |   22 ++++++++++++----
 kernel/sched/fair.c                            |    5 +++
 net/batman-adv/bat_iv_ogm.c                    |   20 +++++++++-----
 net/batman-adv/netlink.c                       |    2 -
 net/key/af_key.c                               |    4 ++
 net/vmw_vsock/hyperv_transport.c               |    8 +++++
 net/xfrm/xfrm_state.c                          |    2 -
 net/xfrm/xfrm_user.c                           |   14 ----------
 scripts/decode_stacktrace.sh                   |    2 -
 sound/pci/hda/hda_auto_parser.c                |    4 +-
 sound/pci/hda/hda_generic.c                    |    3 +-
 sound/pci/hda/hda_generic.h                    |    1=20
 sound/pci/hda/patch_realtek.c                  |    4 ++
 26 files changed, 132 insertions(+), 58 deletions(-)

Christophe Leroy (1):
      powerpc/64: mark start_here_multiplatform as __ref

Cong Wang (1):
      xfrm: clean up xfrm protocol checks

Dan Carpenter (1):
      drm/vmwgfx: Fix double free in vmw_recv_msg()

Dexuan Cui (1):
      hv_sock: Fix hang when a connection is closed

Dmitry Voytik (1):
      arm64: dts: rockchip: enable usb-host regulators at boot on rk3328-ro=
ck64

Eric Dumazet (2):
      ip6: fix skb leak in ip6frag_expire_frag_queue()
      batman-adv: fix uninit-value in batadv_netlink_get_ifindex()

Greg Kroah-Hartman (1):
      Linux 4.14.144

Gustavo Romero (1):
      powerpc/tm: Fix FP/VMX unavailable exceptions inside a transaction

Hui Wang (1):
      ALSA: hda/realtek - Fix the problem of two front mics on a ThinkCentre

Liangyan (1):
      sched/fair: Don't assign runtime for throttled cfs_rq

Nathan Chancellor (1):
      clk: s2mps11: Add used attribute to s2mps11_dt_match

Nicolas Boichat (1):
      scripts/decode_stacktrace: match basepath using shell prefix operator=
, not regex

Niklas Cassel (1):
      PCI: designware-ep: Fix find_first_zero_bit() usage

Sven Eckelmann (1):
      batman-adv: Only read OGM tvlv_len after buffer len check

Takashi Iwai (2):
      ALSA: hda - Fix potential endless loop at applying quirks
      ALSA: hda/realtek - Fix overridden device-specific initialization

Tiwei Bie (1):
      vhost/test: fix build for vhost test

Vignesh R (1):
      PCI: dra7xx: Fix legacy INTD IRQ handling

YueHaibing (1):
      kernel/module: Fix mem leak in module_add_modinfo_attrs

yongduan (1):
      vhost: make sure log_num < in_num


--M9NhX3UHpAaciwkO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl1/ZxgACgkQONu9yGCS
aT4XrA/8DTXm9ldvNdRk+vcGB/b7SCztKaJcX/QGz7sO720Sp9xaYdkpvsoHk8aq
reWhwj2PBzqrRBjbhfYr8heyqoiFn9tFI3X+xL+siHYdMzx96cE4e5oEQi7iVcDY
QjBfR40/Kw/xzNv7++D5+aH/oNEbGOSOVYE7T92J0ZOQjV4Ew57lHC3qGb9+MYZE
8c8Y9ufv08N44z7U1RXA0/AVcI/1ujqn5alkyqnGkWgmGZaKj8f5/CGxPfNNgxg1
Hw/4JfEz3rIKG+xzCSjKSSNHOF7/HYRCecKJ4yf02j9ip9AAjLJcQ9WQpoNgCkV/
aYHe0pPAIt4nb7AS+Ot8vl0cqwpVUe1h8aLTjnM+x2vjKeQ8sG3jyKeNYNJ/st6a
GY57lVSRooQ8E+8GAWSj4+QX/EkA9E0fL9ppH/XgOTmhFfcIJIU+oawz/FzHxJUV
HLyT4Rcs5FCmNBUGf36i9jx3fPEerdL4VUvfGwLUmHAocXU2ntGMqt04QXDyYJyS
hZ17+SCUCG95wYkOQkvIjG3zHrOad0UNCNO3G3Y8Hclv+ugzoIcfqKaFWWIAr9AR
50JLZcsFnsPqHEyKgeLpHrlulUtNu1v9qrQFn5SOx+VaaJBPF6yz6I+zL6QYoKee
PWQXDiSGWygrAH53mQ7sCZr7fPyBbu70JN+8MRtgGIjHYIxonSo=
=Wm3b
-----END PGP SIGNATURE-----

--M9NhX3UHpAaciwkO--

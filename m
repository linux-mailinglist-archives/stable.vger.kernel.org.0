Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CBE919CB2D
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 22:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389523AbgDBU0a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 16:26:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:38650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732263AbgDBU0a (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Apr 2020 16:26:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE94F20678;
        Thu,  2 Apr 2020 20:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585859189;
        bh=Fkz2116eDBdo3pWRUfC9KCn/KYbiBgqK6ntPlI0N5bA=;
        h=Date:From:To:Cc:Subject:From;
        b=gb6xu+cUvF/YNcWUN9g1qZ1mH1agJNwXunFvKvfwOB2QOBfxdezklP2Ry8UvrS8sD
         eJr36B1Yxtac3E7QEjsjBdwvvjQaIH3dplJtSkvEBopGWLxZ9jKQJLw80LwUslC5lF
         Yv0NoY4fhkQWbdJ2zthtEd21PfTT1UqCPqjuKxXQ=
Date:   Thu, 2 Apr 2020 22:26:26 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.4.30
Message-ID: <20200402202626.GA3259625@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="/9DWx/yDrRhgMJTb"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.4.30 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                          |    2=20
 arch/arm/boot/dts/bcm2835-rpi-zero-w.dts          |    1=20
 arch/arm/boot/dts/imx6qdl-phytec-phycore-som.dtsi |    4 -
 arch/arm/boot/dts/omap3-n900.dts                  |   44 ++++++++----
 arch/arm/boot/dts/ox810se.dtsi                    |    4 -
 arch/arm/boot/dts/ox820.dtsi                      |    4 -
 arch/arm/boot/dts/sun8i-r40.dtsi                  |   21 ++----
 arch/arm64/boot/dts/freescale/fsl-ls1043a-rdb.dts |    4 -
 arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts |    4 -
 arch/arm64/include/asm/alternative.h              |    2=20
 drivers/clk/imx/clk-scu.c                         |    8 +-
 drivers/clk/ti/clk-43xx.c                         |    2=20
 drivers/gpio/gpiolib-acpi.c                       |   15 ++++
 drivers/net/ethernet/micrel/ks8851_mll.c          |   56 +++++++++++++++-
 drivers/platform/x86/pmc_atom.c                   |    8 ++
 drivers/tty/serial/sprd_serial.c                  |    3=20
 drivers/tty/vt/selection.c                        |    5 +
 drivers/tty/vt/vt.c                               |   30 +++++++-
 drivers/tty/vt/vt_ioctl.c                         |   75 +++++++++++------=
-----
 include/linux/ceph/messenger.h                    |    7 +-
 include/linux/selection.h                         |    4 -
 include/linux/vt_kern.h                           |    2=20
 kernel/bpf/btf.c                                  |    3=20
 kernel/bpf/syscall.c                              |    9 +-
 net/ceph/messenger.c                              |    9 ++
 net/ceph/osd_client.c                             |   14 ----
 net/mac80211/tx.c                                 |   20 +++++
 tools/perf/util/map.c                             |    2=20
 28 files changed, 249 insertions(+), 113 deletions(-)

Arthur Demchenkov (1):
      ARM: dts: N900: fix onenand timings

Chen-Yu Tsai (1):
      ARM: dts: sun8i: r40: Move AHCI device node based on address order

Eric Biggers (3):
      vt: vt_ioctl: remove unnecessary console allocation checks
      vt: vt_ioctl: fix VT_DISALLOCATE freeing in-use virtual console
      vt: vt_ioctl: fix use-after-free in vt_in_use()

Georg M=FCller (1):
      platform/x86: pmc_atom: Add Lex 2I385SW to critclk_systems DMI table

Greg Kroah-Hartman (3):
      bpf: Explicitly memset the bpf_attr structure
      bpf: Explicitly memset some bpf info structures declared on the stack
      Linux 5.4.30

Hans de Goede (1):
      gpiolib: acpi: Add quirk to ignore EC wakeups on HP x2 10 CHT + AXP28=
8 model

Ilie Halip (1):
      arm64: alternative: fix build with clang integrated assembler

Ilya Dryomov (1):
      libceph: fix alloc_msg_with_page_vector() memory leaks

Jiri Slaby (3):
      vt: selection, introduce vc_is_sel
      vt: ioctl, switch VT_IS_IN_USE and VT_BUSY to inlines
      vt: switch vt_dont_switch to bool

Johannes Berg (1):
      mac80211: fix authentication with iwlwifi/mvm

Jouni Malinen (1):
      mac80211: Check port authorization in the ieee80211_tx_dequeue() case

Lanqing Liu (1):
      serial: sprd: Fix a dereference warning

Leonard Crestez (2):
      clk: imx: Align imx sc clock msg structs to 4
      clk: imx: Align imx sc clock parent msg structs to 4

Madalin Bucur (2):
      arm64: dts: ls1043a-rdb: correct RGMII delay mode to rgmii-id
      arm64: dts: ls1046ardb: set RGMII interfaces to RGMII_ID mode

Marco Felsch (1):
      ARM: dts: imx6: phycore-som: fix arm and soc minimum voltage

Marek Vasut (1):
      net: ks8851-ml: Fix IO operations, again

Nick Hudson (1):
      ARM: bcm2835-rpi-zero-w: Add missing pinctrl name

Sungbo Eo (1):
      ARM: dts: oxnas: Fix clear-mask property

Tony Lindgren (1):
      clk: ti: am43xx: Fix clock parent for RTC clock

disconnect3d (1):
      perf map: Fix off by one in strncpy() size argument


--/9DWx/yDrRhgMJTb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl6GSnIACgkQONu9yGCS
aT4ikw//V85NGfYMzt7Y2B5UOWBnxW3rsXHjlyim2oiiAhQlsiQbFc/S8Srn7lLl
DyjyTkoOSM6DT7tOPlGblqM8CxPUzk9OY4+DCQvSiZ4StLxFOOtBoAR+e7hzrzeT
iY8PsnpirmVZbWJzIJ8u61tEXhCTi8h/yvTxwUaFEr+xAc3iP5sIrbjzGXLhO/f5
SFOqppT8i+rAhrw2o4SACVMTL7g1AVD2+EGaEaL7x+wB6fK7F4pP2oavoJXZEU6t
killgPCNxmKb/iatkstL224ApPE+Xe/1nMssEjlDdBpAsUEtQqDnvQQCohlZj/4N
DowazbE93v5qicTsEL6ASTzKuYKyKKioGBmgdOEt4+9Al8kuYfVi/8UYLsirkvv5
92Tzhu6+IEfAv8SgvJ0UJ81Kxgcie714rbToVIY/FUAbbllNynVD32/2lT+yldpL
UaW01CzAd7iKe6x8GFeRRI659CRJl7k47TZ6LODK5JmWkLnh4zxblT3Mjhulxlyw
UxnXPHxDk6Iu2hY844E8Fp8K+1Zsz8zb8e5HrYqHC+LegIvzqkUM/DfJ1fDjpf6y
yA/lMnQnZeFVndxWhtq7JkDTI6IZUgr86IgAULgL4fnMzwnOCrHUmBpwXcbJ5mAq
MY2AjYn6b1+jNqi9G3G9NPHlTomLjKs6nBYK99bQb2sZ9Q4OO7I=
=vmbO
-----END PGP SIGNATURE-----

--/9DWx/yDrRhgMJTb--

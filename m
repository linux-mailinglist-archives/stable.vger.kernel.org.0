Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7242919CB31
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 22:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389471AbgDBU1G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 16:27:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:39436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730837AbgDBU1G (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Apr 2020 16:27:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97B6720678;
        Thu,  2 Apr 2020 20:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585859225;
        bh=HuoW3d574iGL9TdWdqoUQUnzCPiRFcj2SCtfb5X8U6k=;
        h=Date:From:To:Cc:Subject:From;
        b=B7Rq16qtKvS3KWEml00jBomCUTlvkJx9uDFZk+oTTPVszGYa9D5oUFytvCGTPmh0S
         A/R7JNkzF9lYLpXJNWKw81Nn/BCLhku7Atsrayka3fQhAxUqBQmZra6zPU98aSlC4v
         AKQ9Qlyq81X0Aj8Qz8tAZ2LXq/ISi8zoDxvF9D2o=
Date:   Thu, 2 Apr 2020 22:27:01 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.5.15
Message-ID: <20200402202701.GA3259729@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bp/iNruPH9dso1Pn"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.5.15 kernel.

All users of the 5.5 kernel series must upgrade.

The updated 5.5.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.5.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                          |    2=20
 arch/arm/boot/dts/bcm2835-rpi-zero-w.dts          |    1=20
 arch/arm/boot/dts/bcm2835-rpi.dtsi                |    1=20
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
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c      |   14 ++--
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h      |   14 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c       |    9 ++
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
 tools/testing/selftests/bpf/verifier/jmp32.c      |    9 +-
 33 files changed, 280 insertions(+), 129 deletions(-)

Arthur Demchenkov (1):
      ARM: dts: N900: fix onenand timings

Chen-Yu Tsai (1):
      ARM: dts: sun8i: r40: Move AHCI device node based on address order

Daniel Borkmann (1):
      bpf: update jmp32 test cases to fix range bound deduction

Eric Biggers (3):
      vt: vt_ioctl: remove unnecessary console allocation checks
      vt: vt_ioctl: fix VT_DISALLOCATE freeing in-use virtual console
      vt: vt_ioctl: fix use-after-free in vt_in_use()

Georg M=FCller (1):
      platform/x86: pmc_atom: Add Lex 2I385SW to critclk_systems DMI table

Golan Ben Ami (1):
      iwlwifi: don't send GEO_TX_POWER_LIMIT if no wgds table

Greg Kroah-Hartman (3):
      bpf: Explicitly memset the bpf_attr structure
      bpf: Explicitly memset some bpf info structures declared on the stack
      Linux 5.5.15

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

Nicolas Saenz Julienne (1):
      ARM: dts: bcm283x: Fix vc4's firmware bus DMA limitations

Sungbo Eo (1):
      ARM: dts: oxnas: Fix clear-mask property

Tony Lindgren (1):
      clk: ti: am43xx: Fix clock parent for RTC clock

disconnect3d (1):
      perf map: Fix off by one in strncpy() size argument


--bp/iNruPH9dso1Pn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl6GSpUACgkQONu9yGCS
aT65mxAAmxnW3+BL6fFjdvGyOlOD+CTRvZG1r479N5mf1DcuP0Nbtpk5CFexr5gF
PZkN8h5mIWZkdtMIXxPADpgCe0tO+Y1+7oEghBo5JpXKRC5wBNZphOnBQj7HB/mZ
QKqt5u+mF73LyPZ4i/PnMfM7yUFQIDtx6/p5IwF2p+B1GS0iWVko6pJhugzlC7bV
NB4NVbCd53GyRiVTssgXqkga7qn5Q0NvS78mHODUfZMuCf+QCemv7hJJHKve30qZ
ATgcaoJbraqNw8itUjtrTHOeqbjhfPHnEBDM8T6VXtNuQXI5cpzxjX+tS1MP5Vvd
VVlAhAY930vCS2FeL3QCr/M3IjCIs0Mx7tpdXf3bmofSpcdXZeU0kvz3N/0la5fG
aIFK3BmIYROXHPJL5wg7rsdVzvie01Zrw6id/T3MxP1oG0Dsnb7WXUV/h99x4TFq
CAkICTLWQwo1vumnfuvQjTSLeez1/rJ4cMTYND9FutouAvEtJuz1qj+MEc3YIpDa
gNquWFR4sv2cr7bRx/YCh1Lj6VzGlOnNWp9gyZPxvIsZKUlYvbbrMuLAc4cU0Ho+
lVFsyIcFSiEPQ8kUIA4IGBJJcNuBPPpM5EFJvjzPG2qm4sFQ5Ci1CuqJQ9Nk+PY0
jNzjIhI20UTv6FF4TQKguUlKDCRAL+iAY6IBQA2rh7U6ommds7E=
=uHp5
-----END PGP SIGNATURE-----

--bp/iNruPH9dso1Pn--

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E93C5153344
	for <lists+stable@lfdr.de>; Wed,  5 Feb 2020 15:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbgBEOoT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 09:44:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:37274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726740AbgBEOoS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Feb 2020 09:44:18 -0500
Received: from localhost (unknown [212.187.182.165])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D27A1217F4;
        Wed,  5 Feb 2020 14:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580913857;
        bh=H5OUpQFlpzYsAxpmlHqILFCaiPRxtVENl8s+mY6rIvQ=;
        h=Date:From:To:Cc:Subject:From;
        b=YbNTUiLxTIxbGYfc6Eb7Ai6TB+vbf4my0sFsLucEO06OeRggB81w2IJNgFjFIlpwL
         SkwVCvqUWaOafbnPKSyrf12r/jIkOOyro6L9/11YZS3MyCKOAOunZB86DpuOkTuMb7
         bxFPeyDT1gP413J1VVjcoRIiYcVDHJijyNAmd9Ow=
Date:   Wed, 5 Feb 2020 14:44:14 +0000
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.9.213
Message-ID: <20200205144414.GA1232713@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.9.213 kernel.

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

 Makefile                                                       |    2=20
 arch/arc/plat-eznps/Kconfig                                    |    2=20
 arch/arm/boot/dts/am57xx-beagle-x15-common.dtsi                |   21 +
 arch/arm64/boot/Makefile                                       |    2=20
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0-best-effort.dtsi |    1=20
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi             |    1=20
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1-best-effort.dtsi |    1=20
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi             |    1=20
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi              |    1=20
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi              |    1=20
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi              |    1=20
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi              |    1=20
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi              |    1=20
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi              |    1=20
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi             |    1=20
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi             |    1=20
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi              |    1=20
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi              |    1=20
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi              |    1=20
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi              |    1=20
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi              |    1=20
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi              |    1=20
 crypto/af_alg.c                                                |    6=20
 crypto/pcrypt.c                                                |    3=20
 drivers/atm/eni.c                                              |    4=20
 drivers/char/ttyprintk.c                                       |   15=20
 drivers/clk/mmp/clk-of-mmp2.c                                  |    2=20
 drivers/gpio/Kconfig                                           |    1=20
 drivers/iio/gyro/st_gyro.h                                     |    1=20
 drivers/iio/gyro/st_gyro_core.c                                |  210 +++-=
------
 drivers/iio/gyro/st_gyro_i2c.c                                 |    5=20
 drivers/iio/gyro/st_gyro_spi.c                                 |    1=20
 drivers/media/radio/si470x/radio-si470x-i2c.c                  |    2=20
 drivers/media/usb/dvb-usb/af9005.c                             |    2=20
 drivers/media/usb/dvb-usb/digitv.c                             |   10=20
 drivers/media/usb/dvb-usb/dvb-usb-urb.c                        |    2=20
 drivers/media/usb/gspca/gspca.c                                |    2=20
 drivers/net/ethernet/broadcom/b44.c                            |    9=20
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c             |    3=20
 drivers/net/ethernet/chelsio/cxgb4/l2t.c                       |    3=20
 drivers/net/ethernet/freescale/fman/fman_memac.c               |    4=20
 drivers/net/ethernet/freescale/xgmac_mdio.c                    |    7=20
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c                  |   37 +
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c              |    5=20
 drivers/net/ethernet/natsemi/sonic.c                           |  109 ++++-
 drivers/net/ethernet/natsemi/sonic.h                           |   25 -
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c          |    1=20
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_minidump.c           |    2=20
 drivers/net/usb/r8152.c                                        |    9=20
 drivers/net/wan/sdla.c                                         |    2=20
 drivers/net/wireless/ath/ath9k/hif_usb.c                       |    2=20
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c         |    4=20
 drivers/net/wireless/cisco/airo.c                              |   20=20
 drivers/net/wireless/intersil/orinoco/orinoco_usb.c            |    4=20
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c          |    2=20
 drivers/net/wireless/rsi/rsi_91x_usb.c                         |    2=20
 drivers/net/wireless/zydas/zd1211rw/zd_usb.c                   |    2=20
 drivers/scsi/fnic/fnic_scsi.c                                  |    3=20
 drivers/soc/ti/wkup_m3_ipc.c                                   |    4=20
 drivers/staging/most/aim-network/networking.c                  |   10=20
 drivers/staging/vt6656/device.h                                |    2=20
 drivers/staging/vt6656/int.c                                   |    6=20
 drivers/staging/vt6656/main_usb.c                              |    1=20
 drivers/staging/vt6656/rxtx.c                                  |   26 -
 drivers/staging/wlan-ng/prism2mgmt.c                           |    2=20
 drivers/tty/serial/8250/8250_bcm2835aux.c                      |    2=20
 drivers/usb/dwc3/core.c                                        |    3=20
 drivers/usb/serial/ir-usb.c                                    |  136 ++++=
--
 drivers/usb/storage/unusual_uas.h                              |    7=20
 drivers/watchdog/rn5t618_wdt.c                                 |    1=20
 fs/btrfs/super.c                                               |   10=20
 fs/namei.c                                                     |    4=20
 fs/reiserfs/super.c                                            |    2=20
 include/linux/usb/irda.h                                       |   13=20
 mm/mempolicy.c                                                 |    6=20
 net/bluetooth/hci_sock.c                                       |    3=20
 net/core/utils.c                                               |   20=20
 net/ipv4/ip_vti.c                                              |   13=20
 net/ipv6/ip6_vti.c                                             |   13=20
 net/mac80211/mesh_hwmp.c                                       |    3=20
 net/mac80211/tkip.c                                            |   18=20
 net/sched/ematch.c                                             |    3=20
 net/wireless/reg.c                                             |   13=20
 net/wireless/wext-core.c                                       |    3=20
 sound/core/pcm_native.c                                        |    2=20
 tools/include/linux/string.h                                   |    8=20
 tools/lib/string.c                                             |    7=20
 87 files changed, 591 insertions(+), 316 deletions(-)

Al Viro (1):
      vfs: fix do_last() regression

Andreas Kemnade (1):
      watchdog: rn5t618_wdt: fix module aliases

Andrey Shvetsov (1):
      staging: most: net: fix buffer overflow

Arnd Bergmann (2):
      atm: eni: fix uninitialized variable warning
      wireless: wext: avoid gcc -O3 warning

Bin Liu (1):
      usb: dwc3: turn off VBUS when leaving host mode

Cambda Zhu (1):
      ixgbe: Fix calculation of queue with VFs and flow director on interfa=
ce flap

Colin Ian King (1):
      staging: wlan-ng: ensure error return is actually returned

Dan Carpenter (2):
      mm/mempolicy.c: fix out of bounds write in mpol_parse_str()
      Bluetooth: Fix race condition in hci_release_sock()

Dave Gerlach (1):
      soc: ti: wkup_m3_ipc: Fix race condition with rproc_boot

Dirk Behme (1):
      arm64: kbuild: remove compressed images on 'make ARCH=3Darm64 (dist)c=
lean'

Dmitry Osipenko (1):
      gpio: max77620: Add missing dependency on GPIOLIB_IRQCHIP

Eric Dumazet (1):
      net_sched: ematch: reject invalid TCF_EM_SIMPLE

Fenghua Yu (1):
      drivers/net/b44: Change to non-atomic bit operations on pwol_mask

Finn Thain (4):
      net/sonic: Add mutual exclusion for accessing shared state
      net/sonic: Use MMIO accessors
      net/sonic: Fix receive buffer handling
      net/sonic: Quiesce SONIC before re-initializing descriptor memory

Ganapathi Bhat (1):
      wireless: fix enabling channel 12 for custom regulatory domain

Greg Kroah-Hartman (1):
      Linux 4.9.213

Hannes Reinecke (1):
      scsi: fnic: do not queue commands during fwreset

Hans Verkuil (2):
      media: gspca: zero usb_buf
      media: dvb-usb/dvb-usb-urb.c: initialize actlen to 0

Hayes Wang (1):
      r8152: get default setting of WOL before initializing

Herbert Xu (2):
      crypto: af_alg - Use bh_lock_sock in sk_destruct
      crypto: pcrypt - Fix user-after-free on module unload

Jan Kara (1):
      reiserfs: Fix memory leak of journal device string

Johan Hovold (9):
      orinoco_usb: fix interface sanity check
      rsi_91x_usb: fix interface sanity check
      USB: serial: ir-usb: add missing endpoint sanity check
      USB: serial: ir-usb: fix link-speed handling
      USB: serial: ir-usb: fix IrLAP framing
      ath9k: fix storage endpoint lookup
      brcmfmac: fix interface sanity check
      rtl8xxxu: fix interface sanity check
      zd1211rw: fix storage endpoint lookup

Josef Bacik (1):
      btrfs: do not zero f_bavail if we have available space

Jouni Malinen (1):
      mac80211: Fix TKIP replay protection immediately after key setup

Kishon Vijay Abraham I (1):
      ARM: dts: beagle-x15-common: Model 5V0 regulator

Krzysztof Kozlowski (1):
      net: wan: sdla: Fix cast from pointer to integer of different size

Laura Abbott (1):
      usb-storage: Disable UAS on JMicron SATA enclosure

Lee Jones (1):
      media: si470x-i2c: Move free() past last use of 'radio'

Linus Walleij (1):
      iio: gyro: st_gyro: inline per-sensor data

Lorenzo Bianconi (1):
      iio: gyro: st_gyro: fix L3GD20H support

Lubomir Rintel (1):
      clk: mmp2: Fix the order of timer mux parents

Lukas Wunner (1):
      serial: 8250_bcm2835aux: Fix line mismatch on driver unbind

Madalin Bucur (3):
      powerpc/fsl/dts: add fsl,erratum-a011043
      net/fsl: treat fsl,erratum-a011043
      net: fsl/fman: rename IF_MODE_XGMII to IF_MODE_10G

Malcolm Priestley (3):
      staging: vt6656: correct packet types for CTS protect, mode.
      staging: vt6656: use NULLFUCTION stack on mac80211
      staging: vt6656: Fix false Tx excessive retries reporting.

Manish Chopra (1):
      qlcnic: Fix CPU soft lockup while collecting firmware dump

Markus Theil (1):
      mac80211: mesh: restrict airtime metric to peered established plinks

Michael Ellerman (2):
      airo: Fix possible info leak in AIROOLDIOCTL/SIOCDEVPRIVATE
      airo: Add missing CAP_NET_ADMIN check in AIROOLDIOCTL/SIOCDEVPRIVATE

Nicolas Dichtel (1):
      vti[6]: fix packet tx through bpf_redirect()

Praveen Chaudhary (1):
      net: Fix skb->csum update in inet_proto_csum_replace16().

Radoslaw Tyl (1):
      ixgbevf: Remove limit of 10 entries for unicast filter list

Randy Dunlap (1):
      arc: eznps: fix allmodconfig kconfig warning

Sean Young (2):
      media: digitv: don't continue if remote control state can't be read
      media: af9005: uninitialized variable printked

Takashi Iwai (1):
      ALSA: pcm: Add missing copy ops check before clearing buffer

Vasily Averin (2):
      seq_tab_next() should increase position index
      l2t_seq_next should increase position index

Vitaly Chikunov (1):
      tools lib: Fix builds when glibc contains strlcpy()

Zhenzhong Duan (1):
      ttyprintk: fix a potential deadlock in interrupt context issue


--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl461LsACgkQONu9yGCS
aT402w//QoxQ/pljiA9/k0Ja3ZxN0KPkweNmre/BZoPr37ZoRyxildJkA4I99lQf
ikSv2Gy2iw2YMCi/555Iw6MPfnRGzvB3TQWAilTNnkPmw44FAjwZH/JhrVhRye5f
YXid1kDiqvt/mkAwkmKKII7nMl7Y/eNybeaCjD/ibMCVxyt/Qr2gZr5Utx59xVuS
BWoe3YVOyVgM4qxW2/DpDjWbRigo5lB4RzYzyt1/09Tq1mBH9HB1V9uYj/Okw24n
CxbJ4Qh93eLWhmiew7n3s2xfLdTkgp7QxCx3i++D56emPmBI7uDYU6lYsY4Vrwx7
T+5u8BYGGOhvIPPB/1GK5ibmiJ9sgGhAj1hyk11EBqDwYlSqEdPfz/ethphz6a2q
MhR0aj40M2GPHlyxTMrJOtHh0NLvk6SMBZH2P8pRc+LeRkRXy3UmdUsomy2VSfyb
e/hteiNrpO2dsfeBqUALY1z8tbfZfa4gp6BsMaopHpsF36NIu7iSVfpLxycvHc5l
jewqlogsafzyQJ5xDYByxk1J0AuulEK3pVENVgh/cbAI6N5K0kIQl+jBXyBiYsgg
n2gvQlovjiWFU7u46OgFxGSqIV/tHYmGnuhNXi9D/BJI3p0PbIjfMI2vllO21RHq
8LedZgEAN/D5D9YkpDrnJkIkcHO5cme1X88g8jjWNId6bigFXtA=
=EeIt
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--

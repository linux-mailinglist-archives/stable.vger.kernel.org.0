Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4344C153ABF
	for <lists+stable@lfdr.de>; Wed,  5 Feb 2020 23:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgBEWPZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 17:15:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:36434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727106AbgBEWPZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Feb 2020 17:15:25 -0500
Received: from localhost (unknown [193.117.204.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B36A20730;
        Wed,  5 Feb 2020 22:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580940922;
        bh=YeMYyeKPoHGbu1PKXhz9BZIcAUJgTYMOs1KCrYnDREA=;
        h=Date:From:To:Cc:Subject:From;
        b=l1h9P37Cxpo64JiHnHtHCf4kXHd4DTVjYXDgykDRlKvLRco7YYtPAYJHLH0e10DCB
         upJsx9xXH9mKo9sx7OGUheAYSC427cek9U+kiaBm6tvoiNLO4OsB0KOiDbZOn9sv2/
         vyL82CBAxZ33Dy0kbfC3QD0UvOCEfFnnZB8Sd00o=
Date:   Wed, 5 Feb 2020 22:15:18 +0000
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.14.170
Message-ID: <20200205221518.GA1472679@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="1yeeQ81UyVL57Vl7"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.14.170 kernel.

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

 Documentation/ABI/testing/sysfs-class-devfreq                  |    7=20
 Makefile                                                       |    2=20
 arch/arc/plat-eznps/Kconfig                                    |    2=20
 arch/arm/boot/dts/am335x-boneblack-common.dtsi                 |    5=20
 arch/arm/boot/dts/am57xx-beagle-x15-common.dtsi                |   21 +
 arch/arm/boot/dts/sun8i-a83t-cubietruck-plus.dts               |    2=20
 arch/arm/kernel/hyp-stub.S                                     |    7=20
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
 arch/x86/kernel/cpu/intel_rdt_rdtgroup.c                       |   38 +-
 crypto/af_alg.c                                                |    6=20
 crypto/pcrypt.c                                                |    3=20
 drivers/atm/eni.c                                              |    4=20
 drivers/char/ttyprintk.c                                       |   15 -
 drivers/clk/mmp/clk-of-mmp2.c                                  |    2=20
 drivers/crypto/chelsio/chcr_algo.c                             |   16 -
 drivers/devfreq/devfreq.c                                      |    9=20
 drivers/gpio/Kconfig                                           |    1=20
 drivers/hid/hid-ids.h                                          |    1=20
 drivers/hid/hid-ite.c                                          |    3=20
 drivers/media/radio/si470x/radio-si470x-i2c.c                  |    2=20
 drivers/media/usb/dvb-usb/af9005.c                             |    2=20
 drivers/media/usb/dvb-usb/digitv.c                             |   10=20
 drivers/media/usb/dvb-usb/dvb-usb-urb.c                        |    2=20
 drivers/media/usb/gspca/gspca.c                                |    2=20
 drivers/net/dsa/bcm_sf2.c                                      |    2=20
 drivers/net/ethernet/broadcom/b44.c                            |    9=20
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                      |   22 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c             |    3=20
 drivers/net/ethernet/chelsio/cxgb4/l2t.c                       |    3=20
 drivers/net/ethernet/freescale/fman/fman_memac.c               |    4=20
 drivers/net/ethernet/freescale/xgmac_mdio.c                    |    7=20
 drivers/net/ethernet/intel/igb/e1000_82575.c                   |    8=20
 drivers/net/ethernet/intel/igb/igb_ethtool.c                   |    2=20
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c                  |   37 +-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c              |    5=20
 drivers/net/ethernet/natsemi/sonic.c                           |  109 ++++=
++--
 drivers/net/ethernet/natsemi/sonic.h                           |   25 +
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c          |    1=20
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_minidump.c           |    2=20
 drivers/net/usb/qmi_wwan.c                                     |    1=20
 drivers/net/usb/r8152.c                                        |    9=20
 drivers/net/wan/sdla.c                                         |    2=20
 drivers/net/wireless/ath/ath9k/hif_usb.c                       |    2=20
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c         |    4=20
 drivers/net/wireless/cisco/airo.c                              |   20 -
 drivers/net/wireless/intersil/orinoco/orinoco_usb.c            |    4=20
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c          |    2=20
 drivers/net/wireless/rsi/rsi_91x_hal.c                         |   12=20
 drivers/net/wireless/rsi/rsi_91x_usb.c                         |    2=20
 drivers/net/wireless/zydas/zd1211rw/zd_usb.c                   |    2=20
 drivers/pci/quirks.c                                           |   34 ++
 drivers/phy/motorola/phy-cpcap-usb.c                           |   18 +
 drivers/scsi/fnic/fnic_scsi.c                                  |    3=20
 drivers/soc/ti/wkup_m3_ipc.c                                   |    4=20
 drivers/spi/spi-dw.c                                           |   15 -
 drivers/spi/spi-dw.h                                           |    1=20
 drivers/staging/most/aim-network/networking.c                  |   10=20
 drivers/staging/vt6656/device.h                                |    2=20
 drivers/staging/vt6656/int.c                                   |    6=20
 drivers/staging/vt6656/main_usb.c                              |    1=20
 drivers/staging/vt6656/rxtx.c                                  |   26 -
 drivers/staging/wlan-ng/prism2mgmt.c                           |    2=20
 drivers/tee/optee/Kconfig                                      |    1=20
 drivers/tty/serial/8250/8250_bcm2835aux.c                      |    2=20
 drivers/usb/dwc3/core.c                                        |    3=20
 drivers/usb/serial/ir-usb.c                                    |  136 ++++=
+++---
 drivers/usb/storage/unusual_uas.h                              |    7=20
 drivers/watchdog/Kconfig                                       |    1=20
 drivers/watchdog/rn5t618_wdt.c                                 |    1=20
 fs/btrfs/super.c                                               |   10=20
 fs/ext4/super.c                                                |  127 ++++=
-----
 fs/namei.c                                                     |    4=20
 fs/reiserfs/super.c                                            |    2=20
 include/linux/usb/irda.h                                       |   13=20
 include/net/cfg80211.h                                         |    5=20
 kernel/cgroup/cgroup.c                                         |   11=20
 mm/mempolicy.c                                                 |    6=20
 net/bluetooth/hci_sock.c                                       |    3=20
 net/core/utils.c                                               |   20 +
 net/ipv4/ip_vti.c                                              |   13=20
 net/ipv6/ip6_vti.c                                             |   13=20
 net/mac80211/cfg.c                                             |   23 +
 net/mac80211/mesh_hwmp.c                                       |    3=20
 net/mac80211/tkip.c                                            |   18 +
 net/sched/ematch.c                                             |    3=20
 net/wireless/rdev-ops.h                                        |   10=20
 net/wireless/reg.c                                             |   36 ++
 net/wireless/trace.h                                           |    5=20
 net/wireless/wext-core.c                                       |    3=20
 sound/soc/sti/uniperif_player.c                                |    7=20
 tools/include/linux/string.h                                   |    8=20
 tools/lib/string.c                                             |    7=20
 tools/perf/builtin-c2c.c                                       |   10=20
 tools/perf/builtin-report.c                                    |    6=20
 112 files changed, 811 insertions(+), 309 deletions(-)

Al Viro (1):
      vfs: fix do_last() regression

Andreas Kemnade (1):
      watchdog: rn5t618_wdt: fix module aliases

Andres Freund (1):
      perf c2c: Fix return type for histogram sorting comparision functions

Andrey Shvetsov (1):
      staging: most: net: fix buffer overflow

Arnaud Pouliquen (1):
      ASoC: sti: fix possible sleep-in-atomic

Arnd Bergmann (2):
      atm: eni: fix uninitialized variable warning
      wireless: wext: avoid gcc -O3 warning

Bin Liu (1):
      usb: dwc3: turn off VBUS when leaving host mode

Cambda Zhu (1):
      ixgbe: Fix calculation of queue with VFs and flow director on interfa=
ce flap

Chanwoo Choi (1):
      PM / devfreq: Add new name attribute for sysfs

Colin Ian King (1):
      staging: wlan-ng: ensure error return is actually returned

Dan Carpenter (2):
      mm/mempolicy.c: fix out of bounds write in mpol_parse_str()
      Bluetooth: Fix race condition in hci_release_sock()

Dave Gerlach (1):
      soc: ti: wkup_m3_ipc: Fix race condition with rproc_boot

David Engraf (1):
      watchdog: max77620_wdt: fix potential build errors

Dirk Behme (1):
      arm64: kbuild: remove compressed images on 'make ARCH=3Darm64 (dist)c=
lean'

Dmitry Osipenko (1):
      gpio: max77620: Add missing dependency on GPIOLIB_IRQCHIP

Eric Biggers (1):
      crypto: chelsio - fix writing tfm flags to wrong place

Eric Dumazet (1):
      net_sched: ematch: reject invalid TCF_EM_SIMPLE

Fenghua Yu (1):
      drivers/net/b44: Change to non-atomic bit operations on pwol_mask

Finn Thain (4):
      net/sonic: Add mutual exclusion for accessing shared state
      net/sonic: Use MMIO accessors
      net/sonic: Fix receive buffer handling
      net/sonic: Quiesce SONIC before re-initializing descriptor memory

Florian Fainelli (1):
      net: dsa: bcm_sf2: Configure IMP port for 2Gb/sec

Ganapathi Bhat (1):
      wireless: fix enabling channel 12 for custom regulatory domain

Greg Kroah-Hartman (1):
      Linux 4.14.170

Hannes Reinecke (1):
      scsi: fnic: do not queue commands during fwreset

Hans Verkuil (2):
      media: gspca: zero usb_buf
      media: dvb-usb/dvb-usb-urb.c: initialize actlen to 0

Hans de Goede (1):
      HID: ite: Add USB id match for Acer SW5-012 keyboard dock

Hayes Wang (1):
      r8152: get default setting of WOL before initializing

Herbert Xu (2):
      crypto: af_alg - Use bh_lock_sock in sk_destruct
      crypto: pcrypt - Fix user-after-free on module unload

Jan Kara (1):
      reiserfs: Fix memory leak of journal device string

Jin Yao (1):
      perf report: Fix no libunwind compiled warning break s390 issue

Johan Hovold (10):
      orinoco_usb: fix interface sanity check
      rsi_91x_usb: fix interface sanity check
      USB: serial: ir-usb: add missing endpoint sanity check
      USB: serial: ir-usb: fix link-speed handling
      USB: serial: ir-usb: fix IrLAP framing
      ath9k: fix storage endpoint lookup
      brcmfmac: fix interface sanity check
      rtl8xxxu: fix interface sanity check
      zd1211rw: fix storage endpoint lookup
      rsi: fix use-after-free on probe errors

Josef Bacik (1):
      btrfs: do not zero f_bavail if we have available space

Jouni Malinen (1):
      mac80211: Fix TKIP replay protection immediately after key setup

Kishon Vijay Abraham I (1):
      ARM: dts: beagle-x15-common: Model 5V0 regulator

Kristian Evensen (1):
      qmi_wwan: Add support for Quectel RM500Q

Krzysztof Kozlowski (1):
      net: wan: sdla: Fix cast from pointer to integer of different size

Laura Abbott (1):
      usb-storage: Disable UAS on JMicron SATA enclosure

Lee Jones (1):
      media: si470x-i2c: Move free() past last use of 'radio'

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

Manfred Rudigier (1):
      igb: Fix SGMII SFP module discovery for 100FX/LX.

Manish Chopra (1):
      qlcnic: Fix CPU soft lockup while collecting firmware dump

Marek Szyprowski (1):
      ARM: dts: sun8i: a83t: Correct USB3503 GPIOs polarity

Markus Theil (1):
      mac80211: mesh: restrict airtime metric to peered established plinks

Matwey V. Kornilov (1):
      ARM: dts: am335x-boneblack-common: fix memory size

Michael Chan (1):
      bnxt_en: Fix ipv6 RFS filter matching logic.

Michael Ellerman (2):
      airo: Fix possible info leak in AIROOLDIOCTL/SIOCDEVPRIVATE
      airo: Add missing CAP_NET_ADMIN check in AIROOLDIOCTL/SIOCDEVPRIVATE

Michal Koutn=FD (1):
      cgroup: Prevent double killing of css when enabling threaded cgroup

Nicolas Dichtel (1):
      vti[6]: fix packet tx through bpf_redirect()

Orr Mazor (1):
      cfg80211: Fix radar event during another phy CAC

Praveen Chaudhary (1):
      net: Fix skb->csum update in inet_proto_csum_replace16().

Radoslaw Tyl (1):
      ixgbevf: Remove limit of 10 entries for unicast filter list

Randy Dunlap (1):
      arc: eznps: fix allmodconfig kconfig warning

Sean Young (2):
      media: digitv: don't continue if remote control state can't be read
      media: af9005: uninitialized variable printked

Slawomir Pawlowski (1):
      PCI: Add DMA alias quirk for Intel VCA NTB

Theodore Ts'o (1):
      ext4: validate the debug_want_extra_isize mount option at parse time

Tony Lindgren (1):
      phy: cpcap-usb: Prevent USB line glitches from waking up modem

Vasily Averin (2):
      seq_tab_next() should increase position index
      l2t_seq_next should increase position index

Vincenzo Frascino (1):
      tee: optee: Fix compilation issue with nommu

Vitaly Chikunov (1):
      tools lib: Fix builds when glibc contains strlcpy()

Vladimir Murzin (1):
      ARM: 8955/1: virt: Relax arch timer version check during early boot

Xiaochen Shen (3):
      x86/resctrl: Fix use-after-free when deleting resource groups
      x86/resctrl: Fix use-after-free due to inaccurate refcount of rdtgroup
      x86/resctrl: Fix a deadlock due to inaccurate reference

Zhenzhong Duan (1):
      ttyprintk: fix a potential deadlock in interrupt context issue

wuxu.wu (1):
      spi: spi-dw: Add lock protect dw_spi rx/tx to prevent concurrent calls


--1yeeQ81UyVL57Vl7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl47PnQACgkQONu9yGCS
aT6TtRAAv5X7UQ3tXa/q2Z/+j+wQtGfisGV0wpnxIFgMb9Ilt6cMu6HxMP9wlPr1
yUMw6/ziBeiELqLKew7mDMx5T45/ddNnBpbYmHLB1GmAF8GDR5UnhGz6sgfZpSF5
7bjvZQkXig2bpu9WyqRiX0287gfQer+ibrDcZHiwM4WiMPdBYpdaCLvyAqmKYppI
J0992Vy2eV1Ie2qyHUAvFLeu3OjmOtbNOiei4A5k9GwLWFjDvpKMaUERQyzE/rM+
+fA7AHtDgApJP5Dg7WvgQluwEmoj3DYwHWVVmXOxDnYP5yt9QMMPCaHOvSoQGczA
gHHudDI/JawKVF0MLOAr6bLYE0rT59J5lngf7oMV+7v5YDPosbBsUO2ovlTEmBdz
mc8MFPavkfnWge2ONklsQnN1Io6jRmQn/euLQ5IAs885lIXPqn+nrsuPYMS16Ewk
5Pjzwx7RUYrBUXlfiGT7LA2VSDNvxE3F8Gnkj4grZW1JJx6Ts7wXSQM1kMHc0Q7+
nwBxPJb0pFzeI+5Do7G2KKNxX5DQw3vKI2UzIublYIlWFDTNbL276u88jFFZjZ1L
in+6lnX4mdlN6Gsqbl8spoSDoKYLxlwFHRzpN1nZTrI3JXXyr4S6roLiS5wAVS4O
oN8qyf3Szi+D7tQjBS4E+L/nfdWt1dQXm1L4Yt9oQsYVNu1Xn2o=
=0BiA
-----END PGP SIGNATURE-----

--1yeeQ81UyVL57Vl7--

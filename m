Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD68C153AC4
	for <lists+stable@lfdr.de>; Wed,  5 Feb 2020 23:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbgBEWPt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 17:15:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:36846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727106AbgBEWPt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Feb 2020 17:15:49 -0500
Received: from localhost (unknown [193.117.204.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B68A820730;
        Wed,  5 Feb 2020 22:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580940947;
        bh=d1Ru47OUcPtD8enYc353ed2yPY1I6IlZbKUOSg1ybX8=;
        h=Date:From:To:Cc:Subject:From;
        b=XJzlK//1nSvtuuPdmZJksD6I/mfNmMvt+B/aUn7lQS08dmul39756iqa62cMCczEF
         uw06aKx36KP9uioTl42vq3r0vdB2D0pFBtD6bF6pOHy5cq1josWZrxGtr84fI6D/Ao
         Mc0FL9bgfP2uWuGxCZTSLQT0VZ9077SFnajxmR7A=
Date:   Wed, 5 Feb 2020 22:15:43 +0000
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.102
Message-ID: <20200205221543.GA1472796@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="+HP7ph2BbKc20aGI"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.102 kernel.

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

 Documentation/ABI/testing/sysfs-class-devfreq                  |    7=20
 Makefile                                                       |    2=20
 arch/arm/boot/dts/am335x-boneblack-common.dtsi                 |    5=20
 arch/arm/boot/dts/am43x-epos-evm.dts                           |    2=20
 arch/arm/boot/dts/am571x-idk.dts                               |    4=20
 arch/arm/boot/dts/am572x-idk-common.dtsi                       |    4=20
 arch/arm/boot/dts/am57xx-beagle-x15-common.dtsi                |   25 +
 arch/arm/boot/dts/sun8i-a83t-cubietruck-plus.dts               |    2=20
 arch/arm/kernel/hyp-stub.S                                     |    7=20
 arch/arm64/boot/Makefile                                       |    2=20
 arch/parisc/kernel/drivers.c                                   |    4=20
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
 arch/riscv/kernel/vdso/Makefile                                |    3=20
 arch/x86/kernel/cpu/intel_rdt_rdtgroup.c                       |   32 +-
 crypto/pcrypt.c                                                |    3=20
 drivers/char/ttyprintk.c                                       |   15 -
 drivers/clk/mmp/clk-of-mmp2.c                                  |    2=20
 drivers/clk/sunxi-ng/ccu-sun50i-h6-r.c                         |    4=20
 drivers/devfreq/devfreq.c                                      |    9=20
 drivers/media/radio/si470x/radio-si470x-i2c.c                  |    2=20
 drivers/media/usb/dvb-usb/af9005.c                             |    2=20
 drivers/media/usb/dvb-usb/digitv.c                             |   10=20
 drivers/media/usb/dvb-usb/dvb-usb-urb.c                        |    2=20
 drivers/media/usb/dvb-usb/vp7045.c                             |   21 +
 drivers/media/usb/gspca/gspca.c                                |    2=20
 drivers/net/dsa/bcm_sf2.c                                      |    2=20
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                      |   22 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c             |    3=20
 drivers/net/ethernet/chelsio/cxgb4/l2t.c                       |    3=20
 drivers/net/ethernet/freescale/fman/fman_memac.c               |    4=20
 drivers/net/ethernet/freescale/xgmac_mdio.c                    |    7=20
 drivers/net/ethernet/intel/igb/e1000_82575.c                   |    8=20
 drivers/net/ethernet/intel/igb/igb_ethtool.c                   |    2=20
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c                  |   37 ++
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c              |    5=20
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c          |    1=20
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_minidump.c           |    2=20
 drivers/net/usb/qmi_wwan.c                                     |    1=20
 drivers/net/usb/r8152.c                                        |    9=20
 drivers/net/wireless/cisco/airo.c                              |   20 -
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c             |   48 +++
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h             |    6=20
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c              |    3=20
 drivers/net/wireless/rsi/rsi_91x_sdio.c                        |   18 +
 drivers/net/wireless/rsi/rsi_91x_usb.c                         |   25 +
 drivers/platform/x86/gpd-pocket-fan.c                          |    2=20
 drivers/scsi/fnic/fnic_scsi.c                                  |    3=20
 drivers/soc/ti/wkup_m3_ipc.c                                   |    4=20
 drivers/tee/optee/Kconfig                                      |    1=20
 fs/btrfs/super.c                                               |   10=20
 fs/ext4/super.c                                                |  127 ++++=
+-----
 fs/namei.c                                                     |    4=20
 fs/reiserfs/super.c                                            |    2=20
 include/linux/sched.h                                          |    4=20
 include/net/cfg80211.h                                         |    5=20
 kernel/cgroup/cgroup.c                                         |   11=20
 mm/mempolicy.c                                                 |    6=20
 mm/migrate.c                                                   |    2=20
 net/bluetooth/hci_sock.c                                       |    3=20
 net/core/utils.c                                               |   20 +
 net/ipv4/ip_vti.c                                              |   13 -
 net/ipv6/ip6_vti.c                                             |   13 -
 net/mac80211/cfg.c                                             |   23 +
 net/mac80211/mesh_hwmp.c                                       |    3=20
 net/mac80211/tkip.c                                            |   18 +
 net/netfilter/nft_tunnel.c                                     |    3=20
 net/wireless/rdev-ops.h                                        |   10=20
 net/wireless/reg.c                                             |   36 ++
 net/wireless/trace.h                                           |    5=20
 net/wireless/wext-core.c                                       |    3=20
 net/xfrm/xfrm_interface.c                                      |   34 ++
 security/tomoyo/common.c                                       |   11=20
 sound/soc/codecs/rt5640.c                                      |    7=20
 sound/soc/sti/uniperif_player.c                                |    7=20
 tools/include/linux/string.h                                   |    8=20
 tools/lib/string.c                                             |    7=20
 tools/lib/traceevent/parse-filter.c                            |    4=20
 tools/perf/builtin-c2c.c                                       |   10=20
 tools/perf/builtin-report.c                                    |    6=20
 96 files changed, 606 insertions(+), 234 deletions(-)

Al Viro (1):
      vfs: fix do_last() regression

Andres Freund (1):
      perf c2c: Fix return type for histogram sorting comparision functions

Arnaud Pouliquen (1):
      ASoC: sti: fix possible sleep-in-atomic

Arnd Bergmann (1):
      wireless: wext: avoid gcc -O3 warning

Cambda Zhu (1):
      ixgbe: Fix calculation of queue with VFs and flow director on interfa=
ce flap

Chanwoo Choi (1):
      PM / devfreq: Add new name attribute for sysfs

Dan Carpenter (2):
      mm/mempolicy.c: fix out of bounds write in mpol_parse_str()
      Bluetooth: Fix race condition in hci_release_sock()

Dave Gerlach (1):
      soc: ti: wkup_m3_ipc: Fix race condition with rproc_boot

Dirk Behme (1):
      arm64: kbuild: remove compressed images on 'make ARCH=3Darm64 (dist)c=
lean'

Dmitry Osipenko (1):
      ASoC: rt5640: Fix NULL dereference on module unload

Florian Fainelli (1):
      net: dsa: bcm_sf2: Configure IMP port for 2Gb/sec

Florian Westphal (1):
      netfilter: nft_tunnel: ERSPAN_VERSION must not be null

Ganapathi Bhat (1):
      wireless: fix enabling channel 12 for custom regulatory domain

Greg Kroah-Hartman (1):
      Linux 4.19.102

Haim Dreyfuss (1):
      iwlwifi: Don't ignore the cap field upon mcc update

Hannes Reinecke (1):
      scsi: fnic: do not queue commands during fwreset

Hans Verkuil (2):
      media: gspca: zero usb_buf
      media: dvb-usb/dvb-usb-urb.c: initialize actlen to 0

Hans de Goede (1):
      platform/x86: GPD pocket fan: Allow somewhat lower/higher temperature=
 limits

Hayes Wang (1):
      r8152: get default setting of WOL before initializing

Herbert Xu (1):
      crypto: pcrypt - Fix user-after-free on module unload

Hewenliang (1):
      tools lib traceevent: Fix memory leakage in filter_event

Ilie Halip (1):
      riscv: delete temporary files

Jan Kara (1):
      reiserfs: Fix memory leak of journal device string

Jin Yao (1):
      perf report: Fix no libunwind compiled warning break s390 issue

Johan Hovold (1):
      rsi: fix use-after-free on failed probe and unbind

Josef Bacik (1):
      btrfs: do not zero f_bavail if we have available space

Jouni Malinen (1):
      mac80211: Fix TKIP replay protection immediately after key setup

Kishon Vijay Abraham I (2):
      ARM: dts: am57xx-beagle-x15/am57xx-idk: Remove "gpios" for endpoint d=
t nodes
      ARM: dts: beagle-x15-common: Model 5V0 regulator

Kristian Evensen (1):
      qmi_wwan: Add support for Quectel RM500Q

Krzysztof Kozlowski (1):
      parisc: Use proper printk format for resource_size_t

Lee Jones (1):
      media: si470x-i2c: Move free() past last use of 'radio'

Lubomir Rintel (1):
      clk: mmp2: Fix the order of timer mux parents

Madalin Bucur (3):
      powerpc/fsl/dts: add fsl,erratum-a011043
      net/fsl: treat fsl,erratum-a011043
      net: fsl/fman: rename IF_MODE_XGMII to IF_MODE_10G

Manfred Rudigier (1):
      igb: Fix SGMII SFP module discovery for 100FX/LX.

Manish Chopra (1):
      qlcnic: Fix CPU soft lockup while collecting firmware dump

Marek Szyprowski (1):
      ARM: dts: sun8i: a83t: Correct USB3503 GPIOs polarity

Markus Theil (1):
      mac80211: mesh: restrict airtime metric to peered established plinks

Mathieu Desnoyers (1):
      rseq: Unregister rseq for clone CLONE_VM

Matwey V. Kornilov (1):
      ARM: dts: am335x-boneblack-common: fix memory size

Michael Chan (1):
      bnxt_en: Fix ipv6 RFS filter matching logic.

Michael Ellerman (2):
      airo: Fix possible info leak in AIROOLDIOCTL/SIOCDEVPRIVATE
      airo: Add missing CAP_NET_ADMIN check in AIROOLDIOCTL/SIOCDEVPRIVATE

Michal Koutn=FD (1):
      cgroup: Prevent double killing of css when enabling threaded cgroup

Nicolas Dichtel (2):
      vti[6]: fix packet tx through bpf_redirect()
      xfrm interface: fix packet tx through bpf_redirect()

Orr Mazor (1):
      cfg80211: Fix radar event during another phy CAC

Praveen Chaudhary (1):
      net: Fix skb->csum update in inet_proto_csum_replace16().

Raag Jadav (1):
      ARM: dts: am43x-epos-evm: set data pin directions for spi0 and spi1

Radoslaw Tyl (1):
      ixgbevf: Remove limit of 10 entries for unicast filter list

Samuel Holland (1):
      clk: sunxi-ng: h6-r: Fix AR100/R_APB2 parent order

Sean Young (3):
      media: digitv: don't continue if remote control state can't be read
      media: af9005: uninitialized variable printked
      media: vp7045: do not read uninitialized values if usb transfer fails

Siva Rebbagondla (1):
      rsi: add hci detach for hibernation and poweroff

Tetsuo Handa (1):
      tomoyo: Use atomic_t for statistics counter

Theodore Ts'o (1):
      ext4: validate the debug_want_extra_isize mount option at parse time

Vasily Averin (2):
      seq_tab_next() should increase position index
      l2t_seq_next should increase position index

Vincenzo Frascino (1):
      tee: optee: Fix compilation issue with nommu

Vitaly Chikunov (1):
      tools lib: Fix builds when glibc contains strlcpy()

Vladimir Murzin (1):
      ARM: 8955/1: virt: Relax arch timer version check during early boot

Wei Yang (1):
      mm/migrate.c: also overwrite error when it is bigger than zero

Xiaochen Shen (3):
      x86/resctrl: Fix use-after-free when deleting resource groups
      x86/resctrl: Fix use-after-free due to inaccurate refcount of rdtgroup
      x86/resctrl: Fix a deadlock due to inaccurate reference

Xu Wang (1):
      xfrm: interface: do not confirm neighbor when do pmtu update

Zhenzhong Duan (1):
      ttyprintk: fix a potential deadlock in interrupt context issue


--+HP7ph2BbKc20aGI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl47Po8ACgkQONu9yGCS
aT6l/xAAi575Rq8fj+dGNMhc/UIA0q2GOX/Au+5MdJuETzzuwx4GbSGWxWn1USZx
hpBvgvr91eZsc4bWNLCjKSSCjhKyQEMRlVP33PGhotop5x8z2sAkDZV8SqaNYCuZ
VBcNYXLy2SbHWTIfFPnXUFNohVOyF4hnfKse3XL1bq1qknnBBnfKyptLF38lVKLR
ecNxYtlzYvq7M9d6p7SimloNdEEe2i98WcuYwS+e5NJOMY8eqGoJLevV1DGrIqPv
idHTTNYEwHkdW6wfVv8x01P5mS+b2V3yplluzyVSOrmQHsjnT5TKI5P+G54JDX4k
ihMURrIMBZB4rozv4JmgeryB8W4g7aXBFFLbM67yxCJcN3aVLV1j35dCoJszce1j
cHMFSWAzxDE6XiM+DFrla8abguMcJxFboH8EsrLAgGZdyQkYw6t1FqSBn+dGASA9
e6E3+i2QAmUPnSc/GiRdjn2vXM6lBiSuwe41hKEPT/rISl06jYm8msFJaZ4xYQA8
guF69ap3YOuVDGrJZK32MYMSBKpw2F9bGdco3J9jcJ8yBQR1PnVDuo9x+LCqtkDB
eney69cXuXDbDXv+mLfr1GtY6bKl4YRNFtyFcLa3fAVs9/oqMd/JYZFFkWWCzsbQ
dpVGg4hs0I4cW58gdbKY43e/sEYRTVRUDsnH8FomecVydvRv/98=
=Bc5U
-----END PGP SIGNATURE-----

--+HP7ph2BbKc20aGI--

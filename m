Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F170E153AC8
	for <lists+stable@lfdr.de>; Wed,  5 Feb 2020 23:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727237AbgBEWQJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 17:16:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:37162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727165AbgBEWQJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Feb 2020 17:16:09 -0500
Received: from localhost (unknown [193.117.204.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C3AD20730;
        Wed,  5 Feb 2020 22:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580940967;
        bh=jpd6KYSutx5WYvWW1/qhRBukyO1tMnNLJ0YitPbAJVA=;
        h=Date:From:To:Cc:Subject:From;
        b=RZqwMQL2pnkzwC1hDAbftRDeDdGMYWG6Q5PPNd2Y+T1bPVKd9GJkzoEAENyQbBjVH
         xzlsYskvAgkx4Hs6Qr/Q/7pYeQxsu0r4XAsc6Q8BV7H1GvsO86iY41Eq554shxGmnf
         rIY57VkFEmSeE8mHR5hfHQHnortEs5XUlVn2No7c=
Date:   Wed, 5 Feb 2020 22:16:04 +0000
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.4.18
Message-ID: <20200205221604.GA1472899@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.4.18 kernel.

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

 Documentation/ABI/testing/sysfs-class-devfreq                  |    7=20
 Makefile                                                       |    2=20
 arch/arm/boot/dts/am335x-boneblack-common.dtsi                 |    5=20
 arch/arm/boot/dts/am43x-epos-evm.dts                           |    2=20
 arch/arm/boot/dts/am571x-idk.dts                               |    4=20
 arch/arm/boot/dts/am572x-idk-common.dtsi                       |    4=20
 arch/arm/boot/dts/am57xx-beagle-x15-common.dtsi                |   25 ++-
 arch/arm/boot/dts/sun8i-a83t-cubietruck-plus.dts               |    2=20
 arch/arm/kernel/hyp-stub.S                                     |    7=20
 arch/arm64/boot/Makefile                                       |    2=20
 arch/arm64/boot/dts/amlogic/meson-sm1-sei610.dts               |    2=20
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
 arch/x86/events/intel/uncore_snb.c                             |    6=20
 arch/x86/events/intel/uncore_snbep.c                           |   24 --
 arch/x86/kernel/cpu/resctrl/rdtgroup.c                         |   32 ++-
 drivers/char/ttyprintk.c                                       |   15 +
 drivers/clk/mmp/clk-of-mmp2.c                                  |    2=20
 drivers/clk/sunxi-ng/ccu-sun50i-h6-r.c                         |    4=20
 drivers/clk/sunxi-ng/ccu-sun8i-r.c                             |   21 --
 drivers/clk/sunxi-ng/ccu-sun8i-v3s.c                           |    4=20
 drivers/clk/sunxi-ng/ccu-sun8i-v3s.h                           |    2=20
 drivers/cpuidle/governors/teo.c                                |   21 ++
 drivers/devfreq/devfreq.c                                      |    9 +
 drivers/input/evdev.c                                          |    5=20
 drivers/input/misc/max77650-onkey.c                            |    7=20
 drivers/leds/leds-max77650.c                                   |    7=20
 drivers/md/dm-thin.c                                           |    7=20
 drivers/media/usb/dvb-usb/af9005.c                             |    2=20
 drivers/media/usb/dvb-usb/digitv.c                             |   10 -
 drivers/media/usb/dvb-usb/dvb-usb-urb.c                        |    2=20
 drivers/media/usb/dvb-usb/vp7045.c                             |   21 +-
 drivers/media/usb/gspca/gspca.c                                |    2=20
 drivers/misc/lkdtm/bugs.c                                      |    2=20
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c             |    3=20
 drivers/net/ethernet/chelsio/cxgb4/l2t.c                       |    3=20
 drivers/net/ethernet/freescale/fman/fman_memac.c               |    4=20
 drivers/net/ethernet/freescale/xgmac_mdio.c                    |    7=20
 drivers/net/ethernet/intel/e1000e/e1000.h                      |    5=20
 drivers/net/ethernet/intel/e1000e/netdev.c                     |   61 +++-=
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c             |   22 ++
 drivers/net/ethernet/intel/iavf/iavf.h                         |    2=20
 drivers/net/ethernet/intel/iavf/iavf_main.c                    |   17 +-
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c                |    3=20
 drivers/net/ethernet/intel/igb/e1000_82575.c                   |    8=20
 drivers/net/ethernet/intel/igb/igb_ethtool.c                   |    2=20
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c                  |   37 +++-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c              |    5=20
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c          |    1=20
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_minidump.c           |    2=20
 drivers/net/usb/qmi_wwan.c                                     |    1=20
 drivers/net/usb/r8152.c                                        |   82 ++++=
+++++-
 drivers/net/wireless/intel/iwlwifi/dvm/tx.c                    |    3=20
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c                    |    7=20
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c             |   48 +++++
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h             |    6=20
 drivers/net/wireless/intel/iwlwifi/iwl-trans.c                 |   10 -
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h                 |   26 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c              |    3=20
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c                    |   15 -
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h             |    6=20
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c                |   32 ++-
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c              |   21 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c                   |   20 +-
 drivers/net/wireless/rsi/rsi_91x_usb.c                         |    2=20
 drivers/platform/x86/gpd-pocket-fan.c                          |    2=20
 drivers/platform/x86/intel_pmc_core_pltdrv.c                   |    2=20
 drivers/s390/crypto/ap_bus.c                                   |    2=20
 drivers/s390/crypto/ap_bus.h                                   |    2=20
 drivers/s390/crypto/ap_queue.c                                 |    5=20
 drivers/s390/crypto/zcrypt_cex2a.c                             |    1=20
 drivers/s390/crypto/zcrypt_cex2c.c                             |    2=20
 drivers/s390/crypto/zcrypt_cex4.c                              |    1=20
 drivers/scsi/fnic/fnic_scsi.c                                  |    3=20
 drivers/soc/ti/wkup_m3_ipc.c                                   |    4=20
 drivers/tee/optee/Kconfig                                      |    1=20
 fs/btrfs/super.c                                               |   10 +
 fs/cifs/smb2pdu.c                                              |    2=20
 fs/gfs2/lops.c                                                 |   68 ++++=
+---
 fs/namei.c                                                     |    4=20
 fs/reiserfs/super.c                                            |    2=20
 include/linux/sched.h                                          |    4=20
 include/net/cfg80211.h                                         |    5=20
 kernel/cgroup/cgroup.c                                         |   11 -
 kernel/trace/trace_kprobe.c                                    |    2=20
 kernel/trace/trace_probe.c                                     |    9 -
 kernel/trace/trace_probe.h                                     |   10 -
 kernel/trace/trace_uprobe.c                                    |   29 ---
 lib/test_xarray.c                                              |   22 ++
 lib/xarray.c                                                   |    8=20
 mm/mempolicy.c                                                 |    6=20
 mm/migrate.c                                                   |    2=20
 net/bluetooth/hci_sock.c                                       |    3=20
 net/core/flow_dissector.c                                      |   11 +
 net/core/utils.c                                               |   20 ++
 net/ipv4/ip_vti.c                                              |   13 +
 net/ipv6/ip6_vti.c                                             |   13 +
 net/mac80211/cfg.c                                             |   23 ++
 net/mac80211/mesh_hwmp.c                                       |    3=20
 net/mac80211/tkip.c                                            |   18 +-
 net/netfilter/nf_conntrack_proto_sctp.c                        |    6=20
 net/netfilter/nf_tables_offload.c                              |    2=20
 net/wireless/rdev-ops.h                                        |   10 +
 net/wireless/reg.c                                             |   36 +++-
 net/wireless/trace.h                                           |    5=20
 net/wireless/wext-core.c                                       |    3=20
 net/xfrm/xfrm_interface.c                                      |   34 +++-
 security/tomoyo/common.c                                       |   11 -
 sound/soc/codecs/hdac_hda.c                                    |    4=20
 sound/soc/codecs/rt5640.c                                      |    7=20
 sound/soc/soc-topology.c                                       |    7=20
 sound/soc/sof/intel/hda-codec.c                                |   19 +-
 sound/soc/sti/uniperif_player.c                                |    7=20
 tools/include/linux/string.h                                   |    8=20
 tools/lib/string.c                                             |    7=20
 tools/lib/traceevent/parse-filter.c                            |    4=20
 tools/perf/builtin-c2c.c                                       |   10 -
 tools/perf/builtin-report.c                                    |    6=20
 136 files changed, 869 insertions(+), 396 deletions(-)

Al Viro (1):
      vfs: fix do_last() regression

Alexander Duyck (1):
      e1000e: Drop unnecessary __E1000_DOWN bit twiddling

Andreas Gruenbacher (1):
      gfs2: Another gfs2_find_jhead fix

Andres Freund (1):
      perf c2c: Fix return type for histogram sorting comparision functions

Arnaud Pouliquen (1):
      ASoC: sti: fix possible sleep-in-atomic

Arnd Bergmann (1):
      wireless: wext: avoid gcc -O3 warning

Bartosz Golaszewski (2):
      Input: max77650-onkey - add of_match table
      led: max77650: add of_match table

Brendan Higgins (1):
      lkdtm/bugs: fix build error in lkdtm_UNSET_SMEP

Brett Creeley (1):
      i40e: Fix virtchnl_queue_select bitmap validation

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

Ganapathi Bhat (1):
      wireless: fix enabling channel 12 for custom regulatory domain

Greg Kroah-Hartman (1):
      Linux 5.4.18

Guillaume La Roque (1):
      arm64: dts: meson-sm1-sei610: add gpio bluetooth interrupt

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

Harald Freudenberger (1):
      s390/zcrypt: move ap device reset from bus to driver code

Harry Pan (1):
      platform/x86: intel_pmc_core: update Comet Lake platform driver

Hayes Wang (6):
      r8152: get default setting of WOL before initializing
      r8152: disable U2P3 for RTL8153B
      r8152: Disable PLA MCU clock speed down
      r8152: disable test IO for RTL8153B
      r8152: avoid the MCU to clear the lanwake
      r8152: disable DelayPhyPwrChg

Hewenliang (1):
      tools lib traceevent: Fix memory leakage in filter_event

Ilie Halip (1):
      riscv: delete temporary files

Jan Kara (1):
      reiserfs: Fix memory leak of journal device string

Jaroslav Kysela (1):
      ASoC: topology: fix soc_tplg_fe_link_create() - link->dobj initializa=
tion order

Jeff Kirsher (1):
      e1000e: Revert "e1000e: Make watchdog use delayed work"

Jin Yao (1):
      perf report: Fix no libunwind compiled warning break s390 issue

Jiri Wiesner (1):
      netfilter: conntrack: sctp: use distinct states for new SCTP connecti=
ons

Johan Hovold (1):
      Revert "rsi: fix potential null dereference in rsi_probe()"

Johannes Berg (1):
      iwlwifi: pcie: allocate smaller dev_cmd for TX headers

Josef Bacik (1):
      btrfs: do not zero f_bavail if we have available space

Jouni Malinen (1):
      mac80211: Fix TKIP replay protection immediately after key setup

Kai Vehmanen (2):
      ASoC: SOF: Intel: fix HDA codec driver probe with multiple controllers
      ASoC: hdac_hda: Fix error in driver removal after failed probe

Kan Liang (2):
      perf/x86/intel/uncore: Add PCI ID of IMC for Xeon E3 V5 Family
      perf/x86/intel/uncore: Remove PCIe3 unit for SNR

Kishon Vijay Abraham I (2):
      ARM: dts: am57xx-beagle-x15/am57xx-idk: Remove "gpios" for endpoint d=
t nodes
      ARM: dts: beagle-x15-common: Model 5V0 regulator

Kristian Evensen (1):
      qmi_wwan: Add support for Quectel RM500Q

Krzysztof Kozlowski (1):
      parisc: Use proper printk format for resource_size_t

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

Masami Hiramatsu (1):
      tracing/uprobe: Fix to make trace_uprobe_filter alignment safe

Mathieu Desnoyers (1):
      rseq: Unregister rseq for clone CLONE_VM

Matthew Wilcox (Oracle) (1):
      XArray: Fix xas_pause at ULONG_MAX

Matwey V. Kornilov (1):
      ARM: dts: am335x-boneblack-common: fix memory size

Michal Koutn=FD (1):
      cgroup: Prevent double killing of css when enabling threaded cgroup

Mike Snitzer (1):
      dm thin: fix use-after-free in metadata_pre_commit_callback

Miles Chen (1):
      Input: evdev - convert kzalloc()/vzalloc() to kvzalloc()

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

Rafael J. Wysocki (1):
      cpuidle: teo: Avoid using "early hits" incorrectly

Ronnie Sahlberg (1):
      cifs: fix soft mounts hanging in the reconnect code

Samuel Holland (2):
      clk: sunxi-ng: sun8i-r: Fix divider on APB0 clock
      clk: sunxi-ng: h6-r: Fix AR100/R_APB2 parent order

Sean Young (3):
      media: digitv: don't continue if remote control state can't be read
      media: af9005: uninitialized variable printked
      media: vp7045: do not read uninitialized values if usb transfer fails

Shahar S Matityahu (1):
      iwlwifi: dbg: force stop the debug monitor HW

Stefan Assmann (1):
      iavf: remove current MAC address filter on VF reset

Tetsuo Handa (1):
      tomoyo: Use atomic_t for statistics counter

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
      x86/resctrl: Fix a deadlock due to inaccurate reference
      x86/resctrl: Fix use-after-free when deleting resource groups
      x86/resctrl: Fix use-after-free due to inaccurate refcount of rdtgroup

Xu Wang (1):
      xfrm: interface: do not confirm neighbor when do pmtu update

Yoshiki Komachi (1):
      flow_dissector: Fix to use new variables for port ranges in bpf hook

Yunhao Tian (1):
      clk: sunxi-ng: v3s: Fix incorrect number of hw_clks.

Zhenzhong Duan (1):
      ttyprintk: fix a potential deadlock in interrupt context issue

wenxu (1):
      netfilter: nf_tables_offload: fix check the chain offload flag


--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl47PqQACgkQONu9yGCS
aT6Ifw//QHVoM7D9iuUQ7GymUZ23JhNU3YdGIWL+kSh9Y8sHDCFSbGgNhiXO1iCU
giiOMCJk0nqAeVsyfiWfP2GnOBTsg/sVl8f8DlHW5J/FXYjSLqNPtG20rrsGsJKe
fe7fc7Jqv1FHLH3vaAM/WFPaijsQIcjjIpa7DwnSltUVsykE9ujXS+FWtv1f1K0K
u3RVogpaZIsGO22i0JKVf/3frqigoHJDhfqJvJiU6Pi/FJUOZoIlBu3mUbauaSiV
F1lRnnditdBHb5tit2r/Rb/A5Jkc8uHSnnuVNNX6AKS0/SL2jOTuqJG71PwwS/8t
Wp9n0nLhVpVmMn1wZJ3O+cIcOXnoqLBv6gVxeeGjSxsDnj3N7eoHoyNMNqYOJVvh
/9Mu6jyVHz9NCl0zRHsY5Pd4DhB67sOeAFMZ2sVnWC9fN/jK2tJ4UQfRgEZcEGCy
mcfn4/6n4D0/Bz5L5iy/we50KF8EJT1DOeG+/PvDt4lE9iLxFvp2NEZTF7Ec+Joc
3LQCwcjspdGm4ij6tuSRzYKY41vYxA895peiBb7yrR/7SA/1wO937Dr8nUCfS7++
MdOquy8kFJRekJSgRsJsO4EQVb2BXRIPLH/80sY1gail86/gOGkiAnhUvxcdpbKB
+qoXrBqWGt8ZYtmzFio3CfhnUXJCmjSowuK2LNiBYDbrVPGCHgw=
=MeNJ
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--

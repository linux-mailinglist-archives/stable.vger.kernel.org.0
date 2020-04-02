Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4E5719CB27
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 22:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389242AbgDBU0J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 16:26:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:38324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732263AbgDBU0J (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Apr 2020 16:26:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DE5320678;
        Thu,  2 Apr 2020 20:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585859168;
        bh=1GP0Ou8s3HzT/VZwg/95iRpBuOS3a8RikHsb47BiI9I=;
        h=Date:From:To:Cc:Subject:From;
        b=LdG5hGHmNFHQ+evFCtbCnA/uptwzJAihGr5ZFraAnqovoPQbEmWCyLPCKrTezS05L
         XT+bP+BDnxG8u2/kqcvObkejC+Tte7jX+GM2NOKg3ER2+steCZepMSVmBx6J5qGqmh
         kb8Yx8xB7958fUyX9sOm87hMzZFyprodTp1ZSQuI=
Date:   Thu, 2 Apr 2020 22:26:05 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 4.19.114
Message-ID: <20200402202605.GA3259510@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 4.19.114 kernel.

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

 Documentation/devicetree/bindings/net/fsl-fman.txt         |    7=20
 Makefile                                                   |    2=20
 arch/arm/boot/dts/bcm2835-rpi-zero-w.dts                   |    1=20
 arch/arm/boot/dts/dra7.dtsi                                |    1=20
 arch/arm/boot/dts/imx6qdl-phytec-phycore-som.dtsi          |    4=20
 arch/arm/boot/dts/omap3-n900.dts                           |   44 ++--
 arch/arm/boot/dts/omap5.dtsi                               |    1=20
 arch/arm/boot/dts/ox810se.dtsi                             |    4=20
 arch/arm/boot/dts/ox820.dtsi                               |    4=20
 arch/arm64/boot/dts/freescale/fsl-ls1043-post.dtsi         |    2=20
 arch/arm64/boot/dts/freescale/fsl-ls1043a-rdb.dts          |    4=20
 arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts          |    4=20
 arch/arm64/include/asm/alternative.h                       |    2=20
 arch/x86/kernel/ftrace.c                                   |    2=20
 drivers/ata/ahci.c                                         |    1=20
 drivers/gpio/gpiolib-acpi.c                                |  140 ++++++++=
++---
 drivers/gpu/drm/drm_dp_mst_topology.c                      |   15 -
 drivers/i2c/busses/i2c-hix5hd2.c                           |    1=20
 drivers/infiniband/core/security.c                         |   11 -
 drivers/infiniband/hw/mlx5/qp.c                            |    4=20
 drivers/input/mouse/synaptics.c                            |    1=20
 drivers/input/touchscreen/raydium_i2c_ts.c                 |    8=20
 drivers/media/usb/b2c2/flexcop-usb.c                       |    6=20
 drivers/media/usb/dvb-usb/dib0700_core.c                   |    4=20
 drivers/media/usb/gspca/ov519.c                            |   10=20
 drivers/media/usb/gspca/stv06xx/stv06xx.c                  |   19 +
 drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.c           |    4=20
 drivers/media/usb/gspca/xirlink_cit.c                      |   18 +
 drivers/media/usb/usbtv/usbtv-core.c                       |    2=20
 drivers/media/usb/usbtv/usbtv-video.c                      |    5=20
 drivers/mmc/core/core.c                                    |    5=20
 drivers/mmc/core/mmc.c                                     |    7=20
 drivers/mmc/core/mmc_ops.c                                 |    8=20
 drivers/mmc/host/sdhci-omap.c                              |    3=20
 drivers/mmc/host/sdhci-tegra.c                             |    3=20
 drivers/net/can/slcan.c                                    |    3=20
 drivers/net/dsa/mt7530.c                                   |    2=20
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                  |    4=20
 drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c              |   15 -
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c             |    4=20
 drivers/net/ethernet/freescale/fman/Kconfig                |   28 ++
 drivers/net/ethernet/freescale/fman/fman.c                 |   18 +
 drivers/net/ethernet/freescale/fman/fman.h                 |    5=20
 drivers/net/ethernet/marvell/mvneta.c                      |    3=20
 drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c          |    8=20
 drivers/net/ethernet/micrel/ks8851_mll.c                   |   56 ++++-
 drivers/net/ethernet/realtek/r8169.c                       |   11 -
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c            |    2=20
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c             |    2=20
 drivers/net/geneve.c                                       |    8=20
 drivers/net/macsec.c                                       |    3=20
 drivers/net/phy/mdio-mux-bcm-iproc.c                       |    7=20
 drivers/net/usb/qmi_wwan.c                                 |    1=20
 drivers/net/vxlan.c                                        |   11 -
 drivers/nfc/fdp/fdp.c                                      |    5=20
 drivers/of/of_mdio.c                                       |    1=20
 drivers/platform/x86/pmc_atom.c                            |    8=20
 drivers/s390/net/qeth_core_main.c                          |   13 -
 drivers/scsi/ipr.c                                         |    3=20
 drivers/scsi/ipr.h                                         |    1=20
 drivers/scsi/sd.c                                          |    4=20
 drivers/staging/rtl8188eu/os_dep/usb_intf.c                |    1=20
 drivers/staging/wlan-ng/hfa384x_usb.c                      |    2=20
 drivers/staging/wlan-ng/prism2usb.c                        |    1=20
 drivers/tty/vt/selection.c                                 |    5=20
 drivers/tty/vt/vt.c                                        |   30 ++
 drivers/tty/vt/vt_ioctl.c                                  |   80 +++----
 drivers/usb/class/cdc-acm.c                                |   18 -
 drivers/usb/musb/musb_host.c                               |   17 -
 drivers/usb/serial/io_edgeport.c                           |    2=20
 drivers/usb/serial/option.c                                |    6=20
 fs/afs/rxrpc.c                                             |    4=20
 fs/ceph/file.c                                             |   14 +
 fs/libfs.c                                                 |    8=20
 fs/nfs/client.c                                            |    1=20
 fs/nfs/fscache.c                                           |    2=20
 fs/nfs/nfs4client.c                                        |    1=20
 include/linux/ceph/osdmap.h                                |    4=20
 include/linux/ceph/rados.h                                 |    6=20
 include/linux/mmc/host.h                                   |    1=20
 include/linux/selection.h                                  |    4=20
 include/linux/vt_kern.h                                    |    2=20
 include/trace/events/afs.h                                 |    2=20
 include/uapi/linux/serio.h                                 |   10=20
 kernel/bpf/btf.c                                           |    5=20
 kernel/bpf/syscall.c                                       |    9=20
 kernel/cgroup/cgroup-v1.c                                  |    3=20
 kernel/irq/manage.c                                        |   11 -
 net/ceph/osdmap.c                                          |    9=20
 net/dsa/tag_brcm.c                                         |    2=20
 net/hsr/hsr_framereg.c                                     |   10=20
 net/hsr/hsr_netlink.c                                      |   74 +++---
 net/hsr/hsr_slave.c                                        |    8=20
 net/ipv4/Kconfig                                           |    1=20
 net/ipv4/ip_gre.c                                          |  105 ++++++++-
 net/ipv4/ip_vti.c                                          |   38 ++-
 net/ipv4/tcp.c                                             |    4=20
 net/ipv6/ip6_vti.c                                         |   34 ++-
 net/mac80211/ieee80211_i.h                                 |    3=20
 net/mac80211/mesh_hwmp.c                                   |    3=20
 net/mac80211/sta_info.c                                    |    7=20
 net/mac80211/tdls.c                                        |    2=20
 net/mac80211/tx.c                                          |   44 +++-
 net/netfilter/nf_flow_table_ip.c                           |    2=20
 net/netfilter/nft_fwd_netdev.c                             |    9=20
 net/packet/af_packet.c                                     |   21 +
 net/packet/internal.h                                      |    5=20
 net/sched/cls_route.c                                      |    4=20
 net/sched/cls_tcindex.c                                    |    1=20
 net/sched/sch_cbs.c                                        |   12 +
 net/wireless/nl80211.c                                     |    2=20
 net/xfrm/xfrm_device.c                                     |    1=20
 net/xfrm/xfrm_policy.c                                     |    2=20
 net/xfrm/xfrm_user.c                                       |    6=20
 scripts/dtc/dtc-lexer.l                                    |    1=20
 tools/perf/Makefile                                        |    2=20
 tools/perf/util/map.c                                      |    2=20
 tools/perf/util/probe-finder.c                             |   11 -
 tools/power/cpupower/utils/idle_monitor/amd_fam14h_idle.c  |    2=20
 tools/power/cpupower/utils/idle_monitor/cpuidle_sysfs.c    |    2=20
 tools/power/cpupower/utils/idle_monitor/cpupower-monitor.c |    2=20
 tools/power/cpupower/utils/idle_monitor/cpupower-monitor.h |    2=20
 tools/scripts/Makefile.include                             |    4=20
 123 files changed, 928 insertions(+), 341 deletions(-)

Arthur Demchenkov (1):
      ARM: dts: N900: fix onenand timings

Chuhong Yuan (1):
      i2c: hix5hd2: add missed clk_disable_unprepare in remove

Cong Wang (2):
      net_sched: cls_route: remove the right filter from hashtable
      net_sched: keep alloc_hash updated after hash allocation

Dajun Jin (1):
      drivers/of/of_mdio.c:fix of_mdiobus_register()

Dan Carpenter (2):
      NFC: fdp: Fix a signedness bug in fdp_nci_send_patch()
      Input: raydium_i2c_ts - fix error codes in raydium_i2c_boot_trigger()

David Howells (1):
      afs: Fix some tracing details

Dirk Mueller (1):
      scripts/dtc: Remove redundant YYLOC global declaration

Dominik Czarnota (1):
      sxgbe: Fix off by one in samsung driver strncpy size arg

Edward Cree (1):
      genirq: Fix reference leaks on irq affinity notifiers

Edwin Peer (1):
      bnxt_en: fix memory leaks in bnxt_dcbnl_ieee_getets()

Emil Renner Berthing (1):
      net: stmmac: dwmac-rk: fix error path in rk_gmac_probe

Eric Biggers (4):
      libfs: fix infoleak in simple_attr_read()
      vt: vt_ioctl: remove unnecessary console allocation checks
      vt: vt_ioctl: fix VT_DISALLOCATE freeing in-use virtual console
      vt: vt_ioctl: fix use-after-free in vt_in_use()

Eric Dumazet (1):
      tcp: repair: fix TCP_QUEUE_SEQ implementation

Eugene Syromiatnikov (1):
      Input: avoid BIT() macro usage in the serio.h UAPI header

Florian Fainelli (1):
      net: dsa: Fix duplicate frames flooded by learning

Florian Westphal (1):
      geneve: move debug check after netdev unregister

Georg M=FCller (1):
      platform/x86: pmc_atom: Add Lex 2I385SW to critclk_systems DMI table

Greg Kroah-Hartman (4):
      Revert "r8169: check that Realtek PHY driver module is loaded"
      bpf: Explicitly memset the bpf_attr structure
      bpf: Explicitly memset some bpf info structures declared on the stack
      Linux 4.19.114

Haishuang Yan (1):
      netfilter: flowtable: reload ip{v6}h in nf_flow_tuple_ip{v6}

Hans de Goede (4):
      gpiolib: acpi: Correct comment for HP x2 10 honor_wakeup quirk
      gpiolib: acpi: Rework honor_wakeup option into an ignore_wake option
      gpiolib: acpi: Add quirk to ignore EC wakeups on HP x2 10 BYT + AXP28=
8 model
      gpiolib: acpi: Add quirk to ignore EC wakeups on HP x2 10 CHT + AXP28=
8 model

Heiner Kallweit (1):
      r8169: re-enable MSI on RTL8168c

Ido Schimmel (1):
      mlxsw: spectrum_mr: Fix list iteration in error path

Ilie Halip (1):
      arm64: alternative: fix build with clang integrated assembler

Ilya Dryomov (1):
      ceph: check POOL_FLAG_FULL/NEARFULL in addition to OSDMAP_FULL/NEARFU=
LL

Jiri Kosina (1):
      ftrace/x86: Anotate text_mutex split between ftrace_arch_code_modify_=
post_process() and ftrace_arch_code_modify_prepare()

Jiri Slaby (3):
      vt: selection, introduce vc_is_sel
      vt: ioctl, switch VT_IS_IN_USE and VT_BUSY to inlines
      vt: switch vt_dont_switch to bool

Jisheng Zhang (1):
      net: mvneta: Fix the case where the last poll did not process all rx

Johan Hovold (6):
      media: flexcop-usb: fix endpoint sanity check
      media: usbtv: fix control-message timeouts
      media: ov519: add missing endpoint sanity checks
      media: dib0700: fix rc endpoint lookup
      media: stv06xx: add missing descriptor sanity checks
      media: xirlink_cit: add missing descriptor sanity checks

Johannes Berg (4):
      nl80211: fix NL80211_ATTR_CHANNEL_WIDTH attribute type
      mac80211: mark station unauthorized before key removal
      mac80211: set IEEE80211_TX_CTRL_PORT_CTRL_PROTO for nl80211 TX
      mac80211: fix authentication with iwlwifi/mvm

Jouni Malinen (1):
      mac80211: Check port authorization in the ieee80211_tx_dequeue() case

Julian Wiedmann (1):
      s390/qeth: handle error when backing RX buffer

Kai-Heng Feng (1):
      ahci: Add Intel Comet Lake H RAID PCI ID

Larry Finger (1):
      staging: rtl8188eu: Add ASUS USB-N10 Nano B1 to device table

Lyude Paul (1):
      Revert "drm/dp_mst: Skip validating ports during destruction, just re=
f"

Madalin Bucur (5):
      dt-bindings: net: FMan erratum A050385
      arm64: dts: ls1043a: FMan erratum A050385
      fsl/fman: detect FMan erratum A050385
      arm64: dts: ls1043a-rdb: correct RGMII delay mode to rgmii-id
      arm64: dts: ls1046ardb: set RGMII interfaces to RGMII_ID mode

Mans Rullgard (1):
      usb: musb: fix crash with highmen PIO and usbmon

Maor Gottlieb (1):
      RDMA/mlx5: Block delay drop to unprivileged users

Marco Felsch (1):
      ARM: dts: imx6: phycore-som: fix arm and soc minimum voltage

Marek Vasut (1):
      net: ks8851-ml: Fix IO operations, again

Martin K. Petersen (1):
      scsi: sd: Fix optimal I/O size for devices that change reported values

Masami Hiramatsu (2):
      perf probe: Do not depend on dwfl_module_addrsym()
      tools: Let O=3D makes handle a relative path with -C option

Matthias Reichl (1):
      USB: cdc-acm: restore capability check order

Mike Gilbert (1):
      cpupower: avoid multiple definition with gcc -fno-common

Mike Marciniszyn (1):
      RDMA/core: Ensure security pkey modify is not lost

Nathan Chancellor (1):
      dpaa_eth: Remove unnecessary boolean expression in dpaa_get_headroom

Nick Hudson (1):
      ARM: bcm2835-rpi-zero-w: Add missing pinctrl name

Nicolas Cavallari (1):
      mac80211: Do not send mesh HWMP PREQ if HWMP is disabled

Nicolas Dichtel (1):
      vti[6]: fix packet tx through bpf_redirect() in XinY cases

Oliver Hartkopp (1):
      slcan: not call free_netdev before rtnl_unlock in slcan_open

Pablo Neira Ayuso (1):
      netfilter: nft_fwd_netdev: validate family and chain type

Pawel Dembicki (4):
      net: qmi_wwan: add support for ASKEY WWHC050
      USB: serial: option: add support for ASKEY WWHC050
      USB: serial: option: add BroadMobi BM806U
      USB: serial: option: add Wistron Neweb D19Q1

Petr Machata (2):
      net: ip_gre: Separate ERSPAN newlink / changelink callbacks
      net: ip_gre: Accept IFLA_INFO_DATA-less configuration

Qiujun Huang (3):
      USB: serial: io_edgeport: fix slab-out-of-bounds read in edge_interru=
pt_callback
      staging: wlan-ng: fix ODEBUG bug in prism2sta_disconnect_usb
      staging: wlan-ng: fix use-after-free Read in hfa384x_usbin_callback

Raed Salem (1):
      xfrm: handle NETDEV_UNREGISTER for xfrm device

Rajkumar Manoharan (1):
      mac80211: add option for setting control flags

Rayagonda Kokatanur (1):
      net: phy: mdio-mux-bcm-iproc: check clk_prepare_enable() return value

Ren=E9 van Dorst (1):
      net: dsa: mt7530: Change the LINK bit to reflect the link status

Roger Quadros (2):
      ARM: dts: dra7: Add bus_dma_limit for L3 bus
      ARM: dts: omap5: Add bus_dma_limit for L3 bus

Scott Mayhew (1):
      nfs: add minor version to nfs_server_key for fscache

Sungbo Eo (1):
      ARM: dts: oxnas: Fix clear-mask property

Taehee Yoo (5):
      hsr: fix general protection fault in hsr_addr_is_self()
      vxlan: check return value of gro_cells_init()
      hsr: use rcu_read_lock() in hsr_get_node_{list/status}()
      hsr: add restart routine into hsr_get_node_list()
      hsr: set .netnsok flag

Torsten Hilbrich (1):
      vti6: Fix memory leak of skb if input policy check fails

Tycho Andersen (1):
      cgroup1: don't call release_agent when it is ""

Ulf Hansson (5):
      mmc: core: Allow host controllers to require R1B for CMD6
      mmc: core: Respect MMC_CAP_NEED_RSP_BUSY for erase/trim/discard
      mmc: core: Respect MMC_CAP_NEED_RSP_BUSY for eMMC sleep command
      mmc: sdhci-omap: Fix busy detection by enabling MMC_CAP_NEED_RSP_BUSY
      mmc: sdhci-tegra: Fix busy detection by enabling MMC_CAP_NEED_RSP_BUSY

Vasily Averin (1):
      cgroup-v1: cgroup_pidlist_next should update position index

Vasundhara Volam (1):
      bnxt_en: Reset rings if ring reservation fails during open()

Wen Xiong (1):
      scsi: ipr: Fix softlockup when rescanning devices in petitboot

Willem de Bruijn (2):
      macsec: restrict to ethernet devices
      net/packet: tpacket_rcv: avoid a producer race condition

Xin Long (2):
      xfrm: fix uctx len check in verify_sec_ctx_len
      xfrm: add the missing verify_sec_ctx_len check in xfrm_add_acquire

Yoshiki Komachi (1):
      bpf/btf: Fix BTF verification of enum members in struct/union

YueHaibing (1):
      xfrm: policy: Fix doulbe free in xfrm_policy_timer

Yussuf Khalil (1):
      Input: synaptics - enable RMI on HP Envy 13-ad105ng

Zh-yuan Ye (1):
      net: cbs: Fix software cbs to consider packet sending time

disconnect3d (1):
      perf map: Fix off by one in strncpy() size argument


--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl6GSl0ACgkQONu9yGCS
aT6gBRAAxdhXnzg55YFfLSJkIYUvkVIOkeoC8sGfUCvp8QFk5ddS5u/dPmgl/Lcv
UNcuk+4fE152if2cIonLf+IghG3oA+6Xk10rQ6MEK7OpOk321XBeZsmfsjC8hh4n
Y4aT8zXygx6J/4bFsNbIL6yi1Na3KBK9IId8pDZDtMZgEguBzmRayPbrgBRlr80J
zH3T8G92Rucq0XJyEJGCpWtQprKsnXgVKHOfBlT/YxqrXzf+sQg0jA2ClJXBf+4V
TV0fNkkZ0clvU+d233iYkW/IJ0wyjriJcAhvScWGDF4IUUcj2x60+Ca0KI7bZmFe
R3cm0VgE2xzlHN0OaIXItuegSeizgtpG6rQIDqMDiw+E4jpDdlgMhc3gQedk4e4y
CWtPNAvUHylPaUXq+TMqTjh/e+ZYk/CMlLHSVY4oV6KNlcOmnUSPrfvPdo7Ii5Y0
yZWB1OvPLVvmlXim840DDCep88e3ieeqztv2LPVXEJHtXjo1K1fyEFJPJ5zZQW7q
k3L5170afkUL1ITfD3nM9XAbw5nTtUG9Cb3hChZRMuNKDANWD+pln1VzWr9CS8lb
+5Cx4CFssxSbjFonmd9G+76VyfpNVojPY+pDqf/iSVQwjjhcbz5P+xSCKl8RPq6H
wVFxEZLcO16tNJQoV1g5GXa+vj9HDWR1jTbERCfPPZW+bgfQVIA=
=jj6f
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--

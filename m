Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1D3019AD67
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 16:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732898AbgDAOHX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 10:07:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:58148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732880AbgDAOHX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 10:07:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A661206F6;
        Wed,  1 Apr 2020 14:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585750040;
        bh=J4KVZ+i505yLttWAuDo65ui5CE0rpptkTgm5aYf2YRg=;
        h=Date:From:To:Cc:Subject:From;
        b=EjxFndu4x47x5FJF/GQgvbywyZWTpLq2qU+1jZr18IDsRq9k/hZeqtpI3OPPIR5Nk
         qDG0DqM4JqjbG/jBbZ5wA+E5+pCcntd6JWKFwFFPhuwnNat0ADLLVG1m7/Qfk31sSV
         RSIbLZLgGfc9F2so0PqLMeflFPSeSOGWX1/rLr3k=
Date:   Wed, 1 Apr 2020 16:04:18 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.5.14
Message-ID: <20200401140418.GA2427650@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="2oS5YaxWCcQjTEyO"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.5.14 kernel.

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

 Makefile                                                                  =
         |    2=20
 arch/arm/boot/dts/dra7.dtsi                                               =
         |    1=20
 arch/arm/boot/dts/omap5.dtsi                                              =
         |    1=20
 arch/arm/boot/dts/sun8i-a83t-tbs-a711.dts                                 =
         |    3=20
 arch/arm64/crypto/chacha-neon-glue.c                                      =
         |    8=20
 arch/x86/kvm/svm.c                                                        =
         |   22=20
 arch/x86/mm/ioremap.c                                                     =
         |    3=20
 arch/x86/net/bpf_jit_comp32.c                                             =
         |   10=20
 drivers/ata/ahci.c                                                        =
         |    1=20
 drivers/base/memory.c                                                     =
         |   23=20
 drivers/clocksource/hyperv_timer.c                                        =
         |    6=20
 drivers/gpio/gpiolib-acpi.c                                               =
         |  125=20
 drivers/gpio/gpiolib.c                                                    =
         |    9=20
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c                                   =
         |    2=20
 drivers/gpu/drm/amd/amdgpu/soc15.c                                        =
         |   25=20
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c                     =
         |  114=20
 drivers/gpu/drm/drm_prime.c                                               =
         |    2=20
 drivers/gpu/drm/exynos/exynos5433_drm_decon.c                             =
         |    5=20
 drivers/gpu/drm/exynos/exynos7_drm_decon.c                                =
         |    5=20
 drivers/gpu/drm/exynos/exynos_drm_dma.c                                   =
         |   28=20
 drivers/gpu/drm/exynos/exynos_drm_drv.h                                   =
         |    6=20
 drivers/gpu/drm/exynos/exynos_drm_fimc.c                                  =
         |    5=20
 drivers/gpu/drm/exynos/exynos_drm_fimd.c                                  =
         |    5=20
 drivers/gpu/drm/exynos/exynos_drm_g2d.c                                   =
         |    5=20
 drivers/gpu/drm/exynos/exynos_drm_gsc.c                                   =
         |    5=20
 drivers/gpu/drm/exynos/exynos_drm_rotator.c                               =
         |    5=20
 drivers/gpu/drm/exynos/exynos_drm_scaler.c                                =
         |    6=20
 drivers/gpu/drm/exynos/exynos_mixer.c                                     =
         |    7=20
 drivers/gpu/drm/radeon/radeon_ttm.c                                       =
         |    2=20
 drivers/i2c/busses/i2c-hix5hd2.c                                          =
         |    1=20
 drivers/i2c/busses/i2c-nvidia-gpu.c                                       =
         |   20=20
 drivers/infiniband/core/device.c                                          =
         |    4=20
 drivers/infiniband/core/nldev.c                                           =
         |    6=20
 drivers/infiniband/core/security.c                                        =
         |   11=20
 drivers/infiniband/core/umem_odp.c                                        =
         |    2=20
 drivers/infiniband/core/user_mad.c                                        =
         |   33=20
 drivers/infiniband/hw/mlx5/cq.c                                           =
         |   27=20
 drivers/infiniband/hw/mlx5/main.c                                         =
         |    5=20
 drivers/infiniband/hw/mlx5/mlx5_ib.h                                      =
         |    1=20
 drivers/infiniband/hw/mlx5/qp.c                                           =
         |    5=20
 drivers/infiniband/sw/rdmavt/cq.c                                         =
         |    2=20
 drivers/input/input.c                                                     =
         |    1=20
 drivers/input/mouse/synaptics.c                                           =
         |    1=20
 drivers/input/touchscreen/raydium_i2c_ts.c                                =
         |    8=20
 drivers/iommu/dmar.c                                                      =
         |    3=20
 drivers/iommu/intel-iommu-debugfs.c                                       =
         |   51=20
 drivers/iommu/intel-iommu.c                                               =
         |    4=20
 drivers/media/usb/b2c2/flexcop-usb.c                                      =
         |    6=20
 drivers/media/usb/dvb-usb/dib0700_core.c                                  =
         |    4=20
 drivers/media/usb/gspca/ov519.c                                           =
         |   10=20
 drivers/media/usb/gspca/stv06xx/stv06xx.c                                 =
         |   19=20
 drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.c                          =
         |    4=20
 drivers/media/usb/gspca/xirlink_cit.c                                     =
         |   18=20
 drivers/media/usb/usbtv/usbtv-core.c                                      =
         |    2=20
 drivers/media/usb/usbtv/usbtv-video.c                                     =
         |    5=20
 drivers/media/v4l2-core/v4l2-device.c                                     =
         |    1=20
 drivers/mmc/core/core.c                                                   =
         |    5=20
 drivers/mmc/core/mmc.c                                                    =
         |    7=20
 drivers/mmc/core/mmc_ops.c                                                =
         |    8=20
 drivers/mmc/host/sdhci-omap.c                                             =
         |    3=20
 drivers/mmc/host/sdhci-tegra.c                                            =
         |    3=20
 drivers/net/Kconfig                                                       =
         |    1=20
 drivers/net/can/slcan.c                                                   =
         |    3=20
 drivers/net/dsa/mt7530.c                                                  =
         |    4=20
 drivers/net/ethernet/amazon/ena/ena_netdev.c                              =
         |   78=20
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                                 =
         |   28=20
 drivers/net/ethernet/broadcom/bnxt/bnxt.h                                 =
         |    2=20
 drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c                             =
         |   15=20
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c                         =
         |    8=20
 drivers/net/ethernet/broadcom/genet/bcmgenet.c                            =
         |   10=20
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c                        =
         |    6=20
 drivers/net/ethernet/broadcom/genet/bcmmii.c                              =
         |   40=20
 drivers/net/ethernet/chelsio/cxgb4/sge.c                                  =
         |   52=20
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c                            =
         |    4=20
 drivers/net/ethernet/ibm/ibmvnic.c                                        =
         |   24=20
 drivers/net/ethernet/ibm/ibmvnic.h                                        =
         |    6=20
 drivers/net/ethernet/marvell/mvneta.c                                     =
         |    3=20
 drivers/net/ethernet/mellanox/mlx5/core/en.h                              =
         |    2=20
 drivers/net/ethernet/mellanox/mlx5/core/en/health.h                       =
         |    3=20
 drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c                  =
         |    2=20
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h                         =
         |    6=20
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c                =
         |    2=20
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c                         =
         |   31=20
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c                           =
         |   11=20
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c                           =
         |    5=20
 drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c                         =
         |    1=20
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c              =
         |    1=20
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c                =
         |    3=20
 drivers/net/ethernet/mellanox/mlx5/core/vport.c                           =
         |    3=20
 drivers/net/ethernet/mellanox/mlxsw/pci.c                                 =
         |   50=20
 drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c                         =
         |    8=20
 drivers/net/ethernet/realtek/r8169_main.c                                 =
         |   18=20
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c                           =
         |    2=20
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c                            =
         |    2=20
 drivers/net/geneve.c                                                      =
         |    8=20
 drivers/net/ifb.c                                                         =
         |    6=20
 drivers/net/macsec.c                                                      =
         |    3=20
 drivers/net/phy/dp83867.c                                                 =
         |   21=20
 drivers/net/phy/mdio-bcm-unimac.c                                         =
         |    6=20
 drivers/net/phy/mdio-mux-bcm-iproc.c                                      =
         |    7=20
 drivers/net/usb/qmi_wwan.c                                                =
         |    1=20
 drivers/net/veth.c                                                        =
         |    2=20
 drivers/net/vxlan.c                                                       =
         |   11=20
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.h                      =
         |    1=20
 drivers/nfc/fdp/fdp.c                                                     =
         |    5=20
 drivers/of/of_mdio.c                                                      =
         |    1=20
 drivers/scsi/ipr.c                                                        =
         |    3=20
 drivers/scsi/ipr.h                                                        =
         |    1=20
 drivers/scsi/sd.c                                                         =
         |    4=20
 drivers/soc/samsung/exynos-chipid.c                                       =
         |    2=20
 drivers/staging/kpc2000/kpc2000/core.c                                    =
         |    4=20
 drivers/staging/rtl8188eu/os_dep/usb_intf.c                               =
         |    1=20
 drivers/staging/wfx/Documentation/devicetree/bindings/net/wireless/siliabs=
,wfx.txt |    7=20
 drivers/staging/wfx/bus_sdio.c                                            =
         |   15=20
 drivers/staging/wfx/bus_spi.c                                             =
         |   41=20
 drivers/staging/wfx/main.c                                                =
         |   21=20
 drivers/staging/wfx/main.h                                                =
         |    1=20
 drivers/staging/wfx/queue.c                                               =
         |   16=20
 drivers/staging/wlan-ng/hfa384x_usb.c                                     =
         |    2=20
 drivers/staging/wlan-ng/prism2usb.c                                       =
         |    1=20
 drivers/usb/class/cdc-acm.c                                               =
         |   18=20
 drivers/usb/musb/musb_host.c                                              =
         |   17=20
 drivers/usb/serial/io_edgeport.c                                          =
         |    2=20
 drivers/usb/serial/option.c                                               =
         |    6=20
 fs/afs/cmservice.c                                                        =
         |   14=20
 fs/afs/fs_probe.c                                                         =
         |    2=20
 fs/afs/internal.h                                                         =
         |   12=20
 fs/afs/rxrpc.c                                                            =
         |   71=20
 fs/ceph/file.c                                                            =
         |   14=20
 fs/ceph/snap.c                                                            =
         |    1=20
 fs/libfs.c                                                                =
         |    8=20
 fs/nfs/client.c                                                           =
         |    1=20
 fs/nfs/fscache.c                                                          =
         |    2=20
 fs/nfs/nfs4client.c                                                       =
         |    1=20
 include/linux/ceph/osdmap.h                                               =
         |    4=20
 include/linux/ceph/rados.h                                                =
         |    6=20
 include/linux/dmar.h                                                      =
         |    6=20
 include/linux/dsa/8021q.h                                                 =
         |    7=20
 include/linux/ieee80211.h                                                 =
         |    4=20
 include/linux/intel-iommu.h                                               =
         |    2=20
 include/linux/memcontrol.h                                                =
         |   12=20
 include/linux/mmc/host.h                                                  =
         |    1=20
 include/linux/skbuff.h                                                    =
         |   36=20
 include/net/af_rxrpc.h                                                    =
         |    4=20
 include/net/sch_generic.h                                                 =
         |   16=20
 include/trace/events/afs.h                                                =
         |    2=20
 include/uapi/linux/serio.h                                                =
         |   10=20
 kernel/bpf/btf.c                                                          =
         |    2=20
 kernel/bpf/cgroup.c                                                       =
         |    7=20
 kernel/bpf/verifier.c                                                     =
         |   19=20
 kernel/cgroup/cgroup-v1.c                                                 =
         |    3=20
 kernel/fork.c                                                             =
         |    4=20
 kernel/irq/manage.c                                                       =
         |   11=20
 lib/crypto/chacha20poly1305-selftest.c                                    =
         | 1717 +++++++++-
 mm/memcontrol.c                                                           =
         |   38=20
 mm/sparse.c                                                               =
         |    6=20
 mm/swapfile.c                                                             =
         |   39=20
 net/Kconfig                                                               =
         |    3=20
 net/bpfilter/main.c                                                       =
         |   14=20
 net/ceph/osdmap.c                                                         =
         |    9=20
 net/core/dev.c                                                            =
         |    4=20
 net/core/pktgen.c                                                         =
         |    2=20
 net/core/sock_map.c                                                       =
         |   12=20
 net/dsa/tag_8021q.c                                                       =
         |   43=20
 net/dsa/tag_brcm.c                                                        =
         |    2=20
 net/dsa/tag_sja1105.c                                                     =
         |   19=20
 net/hsr/hsr_framereg.c                                                    =
         |    9=20
 net/hsr/hsr_netlink.c                                                     =
         |   70=20
 net/hsr/hsr_slave.c                                                       =
         |    8=20
 net/ipv4/Kconfig                                                          =
         |    1=20
 net/ipv4/fib_frontend.c                                                   =
         |    2=20
 net/ipv4/ip_gre.c                                                         =
         |  105=20
 net/ipv4/ip_vti.c                                                         =
         |   38=20
 net/ipv4/tcp.c                                                            =
         |    4=20
 net/ipv4/tcp_output.c                                                     =
         |   12=20
 net/ipv6/ip6_vti.c                                                        =
         |   34=20
 net/mac80211/debugfs_sta.c                                                =
         |    3=20
 net/mac80211/key.c                                                        =
         |   20=20
 net/mac80211/mesh_hwmp.c                                                  =
         |    3=20
 net/mac80211/sta_info.c                                                   =
         |    7=20
 net/mac80211/sta_info.h                                                   =
         |    1=20
 net/mac80211/tx.c                                                         =
         |   20=20
 net/netfilter/nf_flow_table_ip.c                                          =
         |    2=20
 net/netfilter/nf_flow_table_offload.c                                     =
         |    1=20
 net/netfilter/nft_fwd_netdev.c                                            =
         |   12=20
 net/packet/af_packet.c                                                    =
         |   21=20
 net/packet/internal.h                                                     =
         |    5=20
 net/rxrpc/af_rxrpc.c                                                      =
         |   33=20
 net/rxrpc/ar-internal.h                                                   =
         |    1=20
 net/rxrpc/input.c                                                         =
         |    1=20
 net/sched/act_ct.c                                                        =
         |    2=20
 net/sched/act_mirred.c                                                    =
         |    6=20
 net/sched/cls_route.c                                                     =
         |    4=20
 net/sched/cls_tcindex.c                                                   =
         |    3=20
 net/sched/sch_cbs.c                                                       =
         |   12=20
 net/wireless/nl80211.c                                                    =
         |    2=20
 net/xfrm/xfrm_device.c                                                    =
         |    1=20
 net/xfrm/xfrm_policy.c                                                    =
         |    2=20
 net/xfrm/xfrm_user.c                                                      =
         |    6=20
 scripts/dtc/dtc-lexer.l                                                   =
         |    1=20
 tools/perf/Makefile                                                       =
         |    2=20
 tools/perf/util/probe-file.c                                              =
         |    3=20
 tools/perf/util/probe-finder.c                                            =
         |   11=20
 tools/power/cpupower/utils/idle_monitor/amd_fam14h_idle.c                 =
         |    2=20
 tools/power/cpupower/utils/idle_monitor/cpuidle_sysfs.c                   =
         |    2=20
 tools/power/cpupower/utils/idle_monitor/cpupower-monitor.c                =
         |    2=20
 tools/power/cpupower/utils/idle_monitor/cpupower-monitor.h                =
         |    2=20
 tools/scripts/Makefile.include                                            =
         |    4=20
 208 files changed, 3225 insertions(+), 834 deletions(-)

Andre Przywara (1):
      net: phy: mdio-bcm-unimac: Fix clock handling

Andrii Nakryiko (2):
      bpf: Fix cgroup ref leak in cgroup_bpf_inherit on out-of-memory
      bpf: Initialize storage pointers to NULL to prevent freeing garbage p=
ointer

Aneesh Kumar K.V (1):
      mm/sparse: fix kernel crash with pfn_section_valid check

Arthur Kiyanovski (4):
      net: ena: fix incorrect setting of the number of msix vectors
      net: ena: fix request of incorrect number of IRQ vectors
      net: ena: avoid memory access violation by validating req_id properly
      net: ena: fix continuous keep-alive resets

Aya Levin (4):
      net/mlx5e: Enhance ICOSQ WQE info fields
      net/mlx5e: Fix missing reset of SW metadata in Striding RQ reset
      net/mlx5e: Fix ICOSQ recovery flow with Striding RQ
      net/mlx5e: Do not recover from a non-fatal syndrome

Borislav Petkov (1):
      x86/ioremap: Fix CONFIG_EFI=3Dn build

Bruno Meneguele (1):
      net/bpfilter: fix dprintf usage for /dev/kmsg

Chuhong Yuan (1):
      i2c: hix5hd2: add missed clk_disable_unprepare in remove

Cong Wang (3):
      net_sched: cls_route: remove the right filter from hashtable
      net_sched: hold rtnl lock in tcindex_partial_destroy_work()
      net_sched: keep alloc_hash updated after hash allocation

Dafna Hirschfeld (1):
      media: v4l2-core: fix a use-after-free bug of sd->devnode

Dajun Jin (1):
      drivers/of/of_mdio.c:fix of_mdiobus_register()

Dan Carpenter (3):
      NFC: fdp: Fix a signedness bug in fdp_nci_send_patch()
      Input: raydium_i2c_ts - fix error codes in raydium_i2c_boot_trigger()
      staging: kpc2000: prevent underflow in cpld_reconfigure()

Daniel Borkmann (1):
      bpf: Undo incorrect __reg_bound_offset32 handling

David Hildenbrand (1):
      drivers/base/memory.c: indicate all memory blocks as removable

David Howells (4):
      afs: Fix handling of an abort from a service handler
      afs: Fix client call Rx-phase signal handling
      afs: Fix some tracing details
      afs: Fix unpinned address list during probing

Dirk Mueller (1):
      scripts/dtc: Remove redundant YYLOC global declaration

Dmitry Torokhov (1):
      Input: fix stale timestamp on key autorepeat events

Dominik Czarnota (1):
      sxgbe: Fix off by one in samsung driver strncpy size arg

Doug Berger (2):
      Revert "net: bcmgenet: use RGMII loopback for MAC reset"
      net: bcmgenet: keep MAC in reset until PHY is up

Edward Cree (2):
      genirq: Fix reference leaks on irq affinity notifiers
      netfilter: flowtable: populate addr_type mask

Edwin Peer (1):
      bnxt_en: fix memory leaks in bnxt_dcbnl_ieee_getets()

Emil Renner Berthing (1):
      net: stmmac: dwmac-rk: fix error path in rk_gmac_probe

Eric Biggers (1):
      libfs: fix infoleak in simple_attr_read()

Eric Dumazet (2):
      tcp: ensure skb->dev is NULL before leaving TCP stack
      tcp: repair: fix TCP_QUEUE_SEQ implementation

Eugene Syromiatnikov (1):
      Input: avoid BIT() macro usage in the serio.h UAPI header

Florian Fainelli (1):
      net: dsa: Fix duplicate frames flooded by learning

Florian Westphal (2):
      geneve: move debug check after netdev unregister
      tcp: also NULL skb->dev when copy was needed

Greg Kroah-Hartman (1):
      Linux 5.5.14

Grygorii Strashko (1):
      net: phy: dp83867: w/a for fld detect threshold bootstrapping issue

Guilherme G. Piccoli (1):
      net: ena: Add PCI shutdown handler to allow safe kexec

Haishuang Yan (1):
      netfilter: flowtable: reload ip{v6}h in nf_flow_tuple_ip{v6}

Hamdan Igbaria (1):
      net/mlx5: DR, Fix postsend actions write length

Hans de Goede (3):
      gpiolib: acpi: Correct comment for HP x2 10 honor_wakeup quirk
      gpiolib: acpi: Rework honor_wakeup option into an ignore_wake option
      gpiolib: acpi: Add quirk to ignore EC wakeups on HP x2 10 BYT + AXP28=
8 model

Hawking Zhang (1):
      drm/amdgpu: correct ROM_INDEX/DATA offset for VEGA20

Heiner Kallweit (2):
      r8169: re-enable MSI on RTL8168c
      r8169: fix PHY driver check on platforms w/o module softdeps

Ido Schimmel (2):
      mlxsw: pci: Only issue reset when system is ready
      mlxsw: spectrum_mr: Fix list iteration in error path

Ilya Dryomov (1):
      ceph: check POOL_FLAG_FULL/NEARFULL in addition to OSDMAP_FULL/NEARFU=
LL

Jason A. Donenfeld (2):
      crypto: chacha20poly1305 - add back missing test vectors and test chu=
nking
      crypto: arm64/chacha - correctly walk through blocks

Jason Gunthorpe (4):
      RDMA/core: Fix missing error check on dev_set_name()
      RDMA/odp: Fix leaking the tgid for implicit ODP
      RDMA/nl: Do not permit empty devices names during RDMA_NLDEV_CMD_NEWL=
INK/SET
      RDMA/mad: Do not crash if the rdma device does not have a umad interf=
ace

Jiang Lidong (1):
      veth: ignore peer tx_dropped when counting local rx_dropped

Jisheng Zhang (1):
      net: mvneta: Fix the case where the last poll did not process all rx

Johan Hovold (6):
      media: flexcop-usb: fix endpoint sanity check
      media: usbtv: fix control-message timeouts
      media: ov519: add missing endpoint sanity checks
      media: dib0700: fix rc endpoint lookup
      media: stv06xx: add missing descriptor sanity checks
      media: xirlink_cit: add missing descriptor sanity checks

Johannes Berg (5):
      nl80211: fix NL80211_ATTR_CHANNEL_WIDTH attribute type
      mac80211: drop data frames without key on encrypted links
      mac80211: mark station unauthorized before key removal
      ieee80211: fix HE SPR size calculation
      mac80211: set IEEE80211_TX_CTRL_PORT_CTRL_PROTO for nl80211 TX

John Fastabend (1):
      bpf, sockmap: Remove bucket->lock from sock_{hash|map}_free

Juliet Kim (1):
      ibmvnic: Do not process device remove during device reset

Kai-Heng Feng (2):
      i2c: nvidia-gpu: Handle timeout correctly in gpu_i2c_check_status()
      ahci: Add Intel Comet Lake H RAID PCI ID

Kaike Wan (1):
      IB/rdmavt: Free kernel completion queue when done

Larry Finger (2):
      rtlwifi: rtl8188ee: Fix regression due to commit d1d1a96bdb44
      staging: rtl8188eu: Add ASUS USB-N10 Nano B1 to device table

Leon Romanovsky (2):
      net/mlx5_core: Set IB capability mask1 to fix ib_srpt connection fail=
ure
      RDMA/mlx5: Fix access to wrong pointer while performing flush due to =
error

Linus Walleij (1):
      gpiolib: Fix irq_disable() semantics

Luis Henriques (1):
      ceph: fix memory leak in ceph_cleanup_snapid_map()

Luke Nelson (1):
      bpf, x32: Fix bug with JMP32 JSET BPF_X checking upper bits

Mans Rullgard (1):
      usb: musb: fix crash with highmen PIO and usbmon

Maor Gottlieb (1):
      RDMA/mlx5: Block delay drop to unprivileged users

Marek Szyprowski (2):
      drm/exynos: Fix cleanup of IOMMU related objects
      soc: samsung: chipid: Fix return value on non-Exynos platforms

Mark Zhang (1):
      RDMA/mlx5: Fix the number of hwcounters of a dynamic counter

Martin K. Petersen (1):
      scsi: sd: Fix optimal I/O size for devices that change reported values

Martin Leung (1):
      drm/amd/display: update soc bb for nv14

Masami Hiramatsu (3):
      perf probe: Fix to delete multiple probe event
      perf probe: Do not depend on dwfl_module_addrsym()
      tools: Let O=3D makes handle a relative path with -C option

Matthias Reichl (1):
      USB: cdc-acm: restore capability check order

Megha Dey (2):
      iommu/vt-d: Fix debugfs register reads
      iommu/vt-d: Populate debugfs if IOMMUs are detected

Michael Chan (3):
      bnxt_en: Fix Priority Bytes and Packets counters in ethtool -S.
      bnxt_en: Return error if bnxt_alloc_ctx_mem() fails.
      bnxt_en: Free context memory after disabling PCI in probe error path.

Micha=C5=82 Miros=C5=82aw (3):
      staging: wfx: add proper "compatible" string
      staging: wfx: fix init/remove vs IRQ race
      staging: wfx: annotate nested gc_list vs tx queue locking

Mike Gilbert (1):
      cpupower: avoid multiple definition with gcc -fno-common

Mike Marciniszyn (1):
      RDMA/core: Ensure security pkey modify is not lost

Naohiro Aota (1):
      mm/swapfile.c: move inode_lock out of claim_swapfile

Nathan Chancellor (1):
      dpaa_eth: Remove unnecessary boolean expression in dpaa_get_headroom

Nicolas Cavallari (1):
      mac80211: Do not send mesh HWMP PREQ if HWMP is disabled

Nicolas Dichtel (1):
      vti[6]: fix packet tx through bpf_redirect() in XinY cases

Oliver Hartkopp (1):
      slcan: not call free_netdev before rtnl_unlock in slcan_open

Ondrej Jirman (1):
      ARM: dts: sun8i-a83t-tbs-a711: Fix USB OTG mode detection

Pablo Neira Ayuso (3):
      netfilter: nft_fwd_netdev: validate family and chain type
      netfilter: nft_fwd_netdev: allow to redirect to ifb via ingress
      net: Fix CONFIG_NET_CLS_ACT=3Dn and CONFIG_NFT_FWD_NETDEV=3D{y, m} bu=
ild

Paul Blakey (1):
      net/sched: act_ct: Fix leak of ct zone template on replace

Pawel Dembicki (4):
      net: qmi_wwan: add support for ASKEY WWHC050
      USB: serial: option: add support for ASKEY WWHC050
      USB: serial: option: add BroadMobi BM806U
      USB: serial: option: add Wistron Neweb D19Q1

Petr Machata (2):
      net: ip_gre: Separate ERSPAN newlink / changelink callbacks
      net: ip_gre: Accept IFLA_INFO_DATA-less configuration

Qian Cai (2):
      ipv4: fix a RCU-list lock in inet_dump_fib()
      iommu/vt-d: Silence RCU-list debugging warnings

Qiujun Huang (3):
      USB: serial: io_edgeport: fix slab-out-of-bounds read in edge_interru=
pt_callback
      staging: wlan-ng: fix ODEBUG bug in prism2sta_disconnect_usb
      staging: wlan-ng: fix use-after-free Read in hfa384x_usbin_callback

Raed Salem (1):
      xfrm: handle NETDEV_UNREGISTER for xfrm device

Rahul Lakkireddy (2):
      cxgb4: fix throughput drop during Tx backpressure
      cxgb4: fix Txq restart check during backpressure

Rayagonda Kokatanur (1):
      net: phy: mdio-mux-bcm-iproc: check clk_prepare_enable() return value

Ren=C3=A9 van Dorst (1):
      net: dsa: mt7530: Change the LINK bit to reflect the link status

Roger Quadros (2):
      ARM: dts: dra7: Add bus_dma_limit for L3 bus
      ARM: dts: omap5: Add bus_dma_limit for L3 bus

Roman Gushchin (1):
      mm: fork: fix kernel_stack memcg stats for various stack implementati=
ons

Scott Mayhew (1):
      nfs: add minor version to nfs_server_key for fscache

Sebastian Hense (1):
      net/mlx5e: Fix endianness handling in pedit mask

Shane Francis (3):
      drm/prime: use dma length macro when mapping sg
      drm/amdgpu: fix scatter-gather mapping with user pages
      drm/radeon: fix scatter-gather mapping with user pages

Taehee Yoo (5):
      hsr: fix general protection fault in hsr_addr_is_self()
      vxlan: check return value of gro_cells_init()
      hsr: use rcu_read_lock() in hsr_get_node_{list/status}()
      hsr: add restart routine into hsr_get_node_list()
      hsr: set .netnsok flag

Tariq Toukan (1):
      net/mlx5e: kTLS, Fix TCP seq off-by-1 issue in TX resync flow

Tom Lendacky (1):
      KVM: SVM: Issue WBINVD after deactivating an SEV guest

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

Vladimir Oltean (1):
      net: dsa: tag_8021q: replace dsa_8021q_remove_header with __skb_vlan_=
pop

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

Yubo Xie (1):
      clocksource/drivers/hyper-v: Untangle stimers and timesync from clock=
sources

YueHaibing (1):
      xfrm: policy: Fix doulbe free in xfrm_policy_timer

Yussuf Khalil (1):
      Input: synaptics - enable RMI on HP Envy 13-ad105ng

Zh-yuan Ye (1):
      net: cbs: Fix software cbs to consider packet sending time


--2oS5YaxWCcQjTEyO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl6En2EACgkQONu9yGCS
aT5KkRAAjLc1CX2h1LfuO9rBH+uU1Faecc+yShGKwDAxbQeBPKgxXIIEzQ5eRl43
/j3vAXbvjhdgg7BDCVsJ9bUgSJ6mdwuHKTktifaDQKo2yfxAWE1emv18uD26Gsg+
6Xzt6uTGqb3G1IAK2rJ2pLosCzdp2DXVY351yn0tYRYudHcHs7CnWsNlUzQ8vdsm
PJHiPQauABiHEGS/aHrHwf3UBNTng7H5jEyzW8cIu0Ncp7S/wpaB0gfYCEqzutfI
UnJSE/uwS8GX7kntni3p8SA0Uiwn9eZh9BfcktrQkatsrmm0+86dPo78+1GMGWsj
+KN40Q67FWXHoxfZTjU4Q/kc4BgL86dA9QSo2VTTUJJi4JGMtuq+v2odsGz4WqmG
hUq5+yMK6rv61Xyw/c/Q09cpVnmwLjAu9ZEy5Yt70xcc3RDaZS0n+yTvjZg7FY7D
uFsE8vux0W4wFV0iAkhEuE2BcSViXdj60b4YAUZdGfl28go4w6FnbP1zBTSFxUfC
tyGOdbLEIz6VEry5koE9BqI8L9bsTTJgWIUAKMMKpFH7RbKCdWHmSPlLbWFky/aV
b+NxC61034onX9+LpvMOm8VmL6mU5l8H1wMeCVccvm8arYRmBmz4vPloF3+VoE4h
Yg8FsTRno22FK5CXZ31SElCtUEKLySRRZ82RCcF932fqDa9uXts=
=gurM
-----END PGP SIGNATURE-----

--2oS5YaxWCcQjTEyO--

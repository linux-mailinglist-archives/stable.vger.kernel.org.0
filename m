Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 362D6114287
	for <lists+stable@lfdr.de>; Thu,  5 Dec 2019 15:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729572AbfLEOY3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 09:24:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:45790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729165AbfLEOY2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Dec 2019 09:24:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 577CE24249;
        Thu,  5 Dec 2019 14:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575555867;
        bh=KIUOzRCmyGP6aeg7WcRmemKmmxrnPlA1hPoUVFqowR4=;
        h=Date:From:To:Cc:Subject:From;
        b=huLlP2FK7QkXtB86kb9T3jaUpdUo8DKq6yEGh/nR7FZaPZgYRfnD8CMnt6j6DRIt2
         NFEdqwHCxQrtQpkOkKvDJfeeJeUR6YzuYkDG5oReGc2YLExMt3XFPFTx9sz3FhAEtG
         vFTHeORzDvIisTFn407n5or4XRNSW1PEPOwscAMI=
Date:   Thu, 5 Dec 2019 15:24:24 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 5.3.15
Message-ID: <20191205142424.GA693681@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="M9NhX3UHpAaciwkO"
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 5.3.15 kernel.

All users of the 5.3 kernel series must upgrade.

The updated 5.3.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-5.3.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Ds=
ummary

thanks,

greg k-h

------------

 Makefile                                                           |    2=
=20
 arch/arm/boot/dts/imx6qdl-sabreauto.dtsi                           |    8=
=20
 arch/arm/boot/dts/stm32mp157c.dtsi                                 |    4=
=20
 arch/arm/boot/dts/sun8i-a83t-tbs-a711.dts                          |    1=
=20
 arch/arm64/boot/dts/freescale/fsl-ls1028a-qds.dts                  |    2=
=20
 arch/arm64/boot/dts/freescale/imx8mm.dtsi                          |    6=
=20
 arch/arm64/boot/dts/freescale/imx8mq-zii-ultra.dtsi                |    2=
=20
 arch/powerpc/net/bpf_jit_comp64.c                                  |   13=
=20
 arch/x86/include/asm/fpu/internal.h                                |    2=
=20
 arch/x86/kernel/cpu/resctrl/ctrlmondata.c                          |    4=
=20
 arch/x86/kernel/tsc.c                                              |    3=
=20
 drivers/block/drbd/drbd_main.c                                     |    1=
=20
 drivers/clk/at91/clk-main.c                                        |    7=
=20
 drivers/clk/at91/sam9x60.c                                         |    1=
=20
 drivers/clk/at91/sckc.c                                            |   20 -
 drivers/clk/meson/gxbb.c                                           |    1=
=20
 drivers/clk/samsung/clk-exynos5420.c                               |   27 +
 drivers/clk/samsung/clk-exynos5433.c                               |   14=
=20
 drivers/clk/sunxi-ng/ccu-sun9i-a80.c                               |    2=
=20
 drivers/clk/sunxi/clk-sunxi.c                                      |    4=
=20
 drivers/clk/ti/clk-dra7-atl.c                                      |    6=
=20
 drivers/clk/ti/clkctrl.c                                           |    5=
=20
 drivers/clocksource/timer-mediatek.c                               |   10=
=20
 drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c                            |    5=
=20
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c                         |    7=
=20
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c                            |    1=
=20
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c                              |    7=
=20
 drivers/gpu/drm/amd/powerplay/navi10_ppt.c                         |    2=
=20
 drivers/gpu/drm/amd/powerplay/vega20_ppt.c                         |    2=
=20
 drivers/hid/hid-core.c                                             |   51 =
++
 drivers/misc/mei/bus.c                                             |    9=
=20
 drivers/misc/mei/hw-me-regs.h                                      |    1=
=20
 drivers/misc/mei/pci-me.c                                          |    1=
=20
 drivers/net/can/c_can/c_can.c                                      |   26 +
 drivers/net/can/flexcan.c                                          |   10=
=20
 drivers/net/can/rx-offload.c                                       |   96 =
++++-
 drivers/net/can/spi/mcp251x.c                                      |    2=
=20
 drivers/net/can/usb/peak_usb/pcan_usb.c                            |   15=
=20
 drivers/net/dsa/sja1105/sja1105_main.c                             |   10=
=20
 drivers/net/ethernet/broadcom/genet/bcmgenet.c                     |    7=
=20
 drivers/net/ethernet/broadcom/genet/bcmmii.c                       |   33 +
 drivers/net/ethernet/cadence/macb_main.c                           |    1=
=20
 drivers/net/ethernet/freescale/fec_main.c                          |   13=
=20
 drivers/net/ethernet/google/gve/gve_main.c                         |    3=
=20
 drivers/net/ethernet/intel/i40e/i40e_common.c                      |    3=
=20
 drivers/net/ethernet/intel/iavf/iavf_main.c                        |    4=
=20
 drivers/net/ethernet/intel/ice/ice_sched.c                         |    2=
=20
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c         |    2=
=20
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c |    3=
=20
 drivers/net/ethernet/mscc/ocelot.h                                 |    2=
=20
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c                  |    2=
=20
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c                |    3=
=20
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c                 |    2=
=20
 drivers/net/macvlan.c                                              |    3=
=20
 drivers/net/phy/mdio_bus.c                                         |    6=
=20
 drivers/net/slip/slip.c                                            |    1=
=20
 drivers/nvme/host/multipath.c                                      |    2=
=20
 drivers/nvme/host/rdma.c                                           |    8=
=20
 drivers/pinctrl/intel/pinctrl-cherryview.c                         |   24 -
 drivers/platform/x86/hp-wmi.c                                      |   10=
=20
 drivers/pwm/pwm-bcm-iproc.c                                        |    1=
=20
 drivers/reset/core.c                                               |    1=
=20
 drivers/soc/imx/gpc.c                                              |    8=
=20
 drivers/soundwire/intel.c                                          |    4=
=20
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c                       |    5=
=20
 drivers/staging/rtl8723bs/os_dep/sdio_intf.c                       |    7=
=20
 drivers/staging/wilc1000/wilc_hif.c                                |   25 -
 drivers/thunderbolt/switch.c                                       |   82 =
++--
 drivers/usb/dwc2/core.c                                            |    2=
=20
 drivers/usb/serial/ftdi_sio.c                                      |    3=
=20
 drivers/usb/serial/ftdi_sio_ids.h                                  |    7=
=20
 drivers/video/fbdev/c2p_core.h                                     |    8=
=20
 drivers/watchdog/bd70528_wdt.c                                     |    1=
=20
 drivers/watchdog/imx_sc_wdt.c                                      |    8=
=20
 drivers/watchdog/meson_gxbb_wdt.c                                  |    4=
=20
 drivers/watchdog/pm8916_wdt.c                                      |   15=
=20
 fs/ceph/super.c                                                    |   11=
=20
 fs/ext4/inode.c                                                    |   15=
=20
 fs/ext4/super.c                                                    |   21 -
 fs/io_uring.c                                                      |   23 +
 include/linux/bpf.h                                                |    4=
=20
 include/linux/idr.h                                                |    2=
=20
 include/linux/reset-controller.h                                   |    2=
=20
 include/linux/skmsg.h                                              |   26 -
 include/net/fq_impl.h                                              |    4=
=20
 include/net/sctp/structs.h                                         |    3=
=20
 include/net/tls.h                                                  |    3=
=20
 kernel/bpf/cgroup.c                                                |    4=
=20
 kernel/bpf/syscall.c                                               |    7=
=20
 kernel/stacktrace.c                                                |    6=
=20
 lib/idr.c                                                          |   31 -
 lib/radix-tree.c                                                   |    2=
=20
 lib/test_xarray.c                                                  |   24 +
 lib/xarray.c                                                       |    4=
=20
 net/bridge/netfilter/ebt_dnat.c                                    |   19 -
 net/core/filter.c                                                  |    8=
=20
 net/core/skmsg.c                                                   |    2=
=20
 net/ipv4/tcp_bpf.c                                                 |    2=
=20
 net/mac80211/main.c                                                |    2=
=20
 net/mac80211/sta_info.c                                            |    3=
=20
 net/netfilter/ipset/ip_set_core.c                                  |   41 =
+-
 net/netfilter/ipset/ip_set_hash_net.c                              |    1=
=20
 net/netfilter/ipset/ip_set_hash_netnet.c                           |    1=
=20
 net/netfilter/nf_tables_api.c                                      |    1=
=20
 net/netfilter/nf_tables_offload.c                                  |    3=
=20
 net/openvswitch/datapath.c                                         |   17=
=20
 net/psample/psample.c                                              |    2=
=20
 net/sched/sch_mq.c                                                 |    3=
=20
 net/sched/sch_mqprio.c                                             |    4=
=20
 net/sched/sch_multiq.c                                             |    2=
=20
 net/sched/sch_prio.c                                               |    2=
=20
 net/sctp/associola.c                                               |    1=
=20
 net/sctp/endpointola.c                                             |    1=
=20
 net/sctp/input.c                                                   |    4=
=20
 net/sctp/sm_statefuns.c                                            |    4=
=20
 net/socket.c                                                       |  184 =
+++++++---
 net/tipc/netlink_compat.c                                          |    4=
=20
 net/tls/tls_main.c                                                 |   13=
=20
 net/tls/tls_sw.c                                                   |   32 +
 net/xfrm/xfrm_state.c                                              |    2=
=20
 samples/bpf/Makefile                                               |    1=
=20
 scripts/gdb/linux/symbols.py                                       |    3=
=20
 sound/core/compress_offload.c                                      |    2=
=20
 sound/pci/hda/patch_hdmi.c                                         |   13=
=20
 sound/soc/codecs/hdac_hda.c                                        |    2=
=20
 sound/soc/codecs/msm8916-wcd-analog.c                              |    4=
=20
 sound/soc/kirkwood/kirkwood-i2s.c                                  |   11=
=20
 sound/soc/rockchip/rockchip_max98090.c                             |    7=
=20
 sound/soc/sof/ipc.c                                                |    4=
=20
 sound/soc/sof/topology.c                                           |   11=
=20
 sound/soc/stm/stm32_sai_sub.c                                      |   12=
=20
 sound/soc/ti/sdma-pcm.c                                            |    2=
=20
 tools/perf/util/scripting-engines/trace-event-perl.c               |    8=
=20
 tools/perf/util/scripting-engines/trace-event-python.c             |    9=
=20
 tools/testing/selftests/bpf/test_sockmap.c                         |   47 =
+-
 tools/testing/selftests/bpf/test_sysctl.c                          |    8=
=20
 tools/testing/selftests/bpf/xdping.c                               |    2=
=20
 tools/testing/selftests/net/pmtu.sh                                |    5=
=20
 tools/testing/selftests/net/tls.c                                  |   60 =
+++
 tools/testing/selftests/vm/gup_benchmark.c                         |    2=
=20
 140 files changed, 1063 insertions(+), 405 deletions(-)

Ahmed Zaki (1):
      mac80211: fix station inactive_time shortly after boot

Ajay Singh (1):
      staging: wilc1000: fix illegal memory access in wilc_parse_join_bss_p=
aram()

Alexander Usyskin (2):
      mei: bus: prefix device names on bus with the bus name
      mei: me: add comet point V device id

Alexandre Belloni (1):
      clk: at91: avoid sleeping early

Andy Shevchenko (1):
      pinctrl: cherryview: Allocate IRQ chip dynamic

Anson Huang (1):
      watchdog: imx_sc_wdt: Pretimeout should follow SCU firmware format

Anton Eidelman (1):
      nvme-multipath: fix crash in nvme_mpath_clear_ctrl_paths

Arkadiusz Kubalewski (1):
      i40e: Fix for ethtool -m issue on X722 NIC

Bard Liao (1):
      soundwire: intel: fix intel_register_dai PDI offsets and numbers

Ben Dooks (1):
      soc: imx: gpc: fix initialiser format

Bj=F6rn T=F6pel (2):
      samples/bpf: fix build by setting HAVE_ATTR_TEST to zero
      bpf: Change size to u64 for bpf_map_{area_alloc, charge_init}()

Candle Sun (1):
      HID: core: check whether Usage Page item is after Usage ID items

Cheng-Yi Chiang (1):
      ASoC: rockchip: rockchip_max98090: Enable SHDN to fix headset detecti=
on

Christophe Roullier (1):
      ARM: dts: stm32: Fix CAN RAM mapping on stm32mp157c

Chuhong Yuan (3):
      net: fec: add missed clk_disable_unprepare in remove
      net: macb: add missed tasklet_kill
      net: fec: fix clock count mis-match

Colin Ian King (2):
      clk: sunxi-ng: a80: fix the zero'ing of bits 16 and 18
      ice: fix potential infinite loop because loop counter being too small

Dan Carpenter (1):
      block: drbd: remove a stray unlock in __drbd_send_protocol()

David Bauer (1):
      mdio_bus: don't use managed reset-controller

Dmytro Linkin (1):
      net/mlx5e: Use correct enum to determine uplink port

Doug Berger (2):
      net: bcmgenet: use RGMII loopback for MAC reset
      net: bcmgenet: reapply manual settings to the PHY

Dragos Tarcatu (1):
      ASoC: SOF: topology: Fix bytes control size checks

Dust Li (1):
      net: sched: fix `tc -s class show` no bstats on class with nolock sub=
queues

Eric Dumazet (1):
      powerpc/bpf: Fix tail call implementation

Eugen Hristev (2):
      clk: at91: sam9x60: fix programmable clock
      clk: at91: fix update bit maps on CFG_MOR write

Evan Quan (1):
      drm/amdgpu: register gpu instance before fan boost feature enablment

Fabien Parent (1):
      clocksource/drivers/mediatek: Fix error handling

Fabio D'Urso (1):
      USB: serial: ftdi_sio: add device IDs for U-Blox C099-F9P

Fabio Estevam (1):
      ARM: dts: imx6qdl-sabreauto: Fix storm of accelerometer interrupts

Florian Westphal (1):
      bridge: ebtables: don't crash when using dnat target in output chains

Geert Uytterhoeven (1):
      fbdev: c2p: Fix link failure on non-inlining

Greg Kroah-Hartman (1):
      Linux 5.3.15

Hans de Goede (4):
      staging: rtl8723bs: Drop ACPI device ids
      staging: rtl8723bs: Add 024c:0525 to the list of SDIO device-ids
      platform/x86: hp-wmi: Fix ACPI errors caused by too small buffer
      platform/x86: hp-wmi: Fix ACPI errors caused by passing 0 as input si=
ze

Ilya Leoshkevich (2):
      bpf: Allow narrow loads of bpf_sysctl fields with offset > 0
      scripts/gdb: fix debugging modules compiled with hot/cold partitioning

Jakub Kicinski (8):
      net/tls: take into account that bpf_exec_tx_verdict() may free the re=
cord
      net/tls: free the record on encryption error
      net: skmsg: fix TLS 1.3 crash with full sk_msg
      selftests/tls: add a test for fragmented messages
      net/tls: remove the dead inplace_crypto code
      net/tls: use sg_next() to walk sg entries
      selftests: bpf: test_sockmap: handle file creation failures gracefully
      selftests: bpf: correct perror strings

Jeff Layton (1):
      ceph: return -EINVAL if given fsc mount option on kernel w/o support

Jens Axboe (3):
      io_uring: async workers should inherit the user creds
      net: separate out the msghdr copy from ___sys_{send,recv}msg()
      net: disallow ancillary data for __sys_{send,recv}msg_file()

Jeroen Hofstee (3):
      can: peak_usb: report bus recovery as well
      can: c_can: D_CAN: c_can_chip_config(): perform a sofware reset on op=
en
      can: rx-offload: can_rx_offload_irq_offload_timestamp(): continue on =
error

Jeroen de Borst (1):
      gve: Fix the queue page list allocated pages count

Jiri Slaby (1):
      stacktrace: Don't skip first entry on noncurrent tasks

Johannes Berg (1):
      mac80211: fix ieee80211_txq_setup_flows() failure path

John Hubbard (1):
      mm/gup_benchmark: fix MAP_HUGETLB case

John Rutherford (1):
      tipc: fix link name length check

Jorge Ramirez-Ortiz (1):
      watchdog: pm8916_wdt: fix pretimeout registration flow

Jose Abreu (4):
      net: stmmac: gmac4: bitrev32 returns u32
      net: stmmac: xgmac: bitrev32 returns u32
      net: stmmac: xgmac: Fix TSA selection
      net: stmmac: xgmac: Disable Flow Control when 1 or more queues are in=
 AV

Jouni Hogander (1):
      slip: Fix use-after-free Read in slip_open

Jozsef Kadlecsik (1):
      netfilter: ipset: Fix nla_policies to fully support NL_VALIDATE_STRICT

Kai Vehmanen (2):
      ASoC: hdac_hda: fix race in device removal
      ALSA: hda: hdmi - add Tigerlake support

Kevin Wang (1):
      drm/amd/swSMU: fix smu workload bit map error

Kishon Vijay Abraham I (1):
      reset: Fix memory leak in reset_control_array_put()

Lucas Stach (1):
      arm64: dts: zii-ultra: fix ARM regulator GPIO handle

Marc Kleine-Budde (6):
      can: rx-offload: can_rx_offload_queue_tail(): fix error handling, avo=
id skb mem leak
      can: rx-offload: can_rx_offload_offload_one(): do not increase the sk=
b_queue beyond skb_queue_len_max
      can: rx-offload: can_rx_offload_offload_one(): increment rx_fifo_erro=
rs on queue overflow or OOM
      can: rx-offload: can_rx_offload_offload_one(): use ERR_PTR() to propa=
gate error value in case of errors
      can: rx-offload: can_rx_offload_irq_offload_fifo(): continue on error
      can: flexcan: increase error counters if skb enqueueing via can_rx_of=
fload_queue_sorted() fails

Marek Szyprowski (3):
      clk: samsung: exynos5433: Fix error paths
      clk: samsung: exynos542x: Move G3D subsystem clocks to its sub-CMU
      clk: samsung: exynos5420: Preserve PLL configuration during suspend/r=
esume

Martin Blumenstingl (1):
      clk: meson: gxbb: let sar_adc_clk_div set the parent clock rate

Mathias Kresin (1):
      usb: dwc2: use a longer core rest timeout in dwc2_core_reset()

Matthew Wilcox (Oracle) (4):
      XArray: Fix xas_next() with a single entry at 0
      idr: Fix idr_get_next_ul race with idr_remove
      idr: Fix integer overflow in idr_for_each_entry
      idr: Fix idr_alloc_u32 on 32-bit systems

Matti Vaittinen (1):
      watchdog: bd70528: Add MODULE_ALIAS to allow module auto loading

Max Gurtovoy (1):
      nvme-rdma: fix a segmentation fault during module unload

Menglong Dong (1):
      macvlan: schedule bc_work even if error

Michael Zhivich (1):
      x86/tsc: Respect tsc command line paraemeter for clocksource_tsc_early

Mika Westerberg (3):
      thunderbolt: Read DP IN adapter first two dwords in one go
      thunderbolt: Fix lockdep circular locking depedency warning
      thunderbolt: Power cycle the router if NVM authentication fails

Nathan Chancellor (1):
      clk: sunxi: Fix operator precedence in sunxi_divs_clk_setup

Navid Emamdoost (2):
      ASoC: SOF: ipc: Fix memory leak in sof_set_get_large_ctrl_data
      sctp: Fix memory leak in sctp_sf_do_5_2_4_dupcook

Nicholas Nunley (1):
      iavf: initialize ITRN registers with correct values

Nikolay Aleksandrov (1):
      net: psample: fix skb_over_panic

Oleksij Rempel (1):
      net: dsa: sja1105: fix sja1105_parse_rgmii_delays()

Olivier Moysan (1):
      ASoC: stm32: sai: add restriction on mmap support

Ondrej Jirman (1):
      ARM: dts: sun8i-a83t-tbs-a711: Fix WiFi resume from suspend

Pablo Neira Ayuso (2):
      netfilter: nf_tables: bogus EOPNOTSUPP on basechain update
      netfilter: nf_tables_offload: skip EBUSY on chain update

Pan Bian (1):
      staging: rtl8192e: fix potential use after free

Paolo Abeni (3):
      openvswitch: fix flow command message size
      openvswitch: drop unneeded BUG_ON() in ovs_flow_cmd_build_info()
      openvswitch: remove another BUG_ON()

Peter Ujfalusi (2):
      ASoC: ti: sdma-pcm: Add back the flags parameter for non standard dma=
 names
      clk: ti: dra7-atl-clock: Remove ti_clk_add_alias call

Randy Dunlap (1):
      reset: fix reset_control_ops kerneldoc comment

Roi Dayan (1):
      net/mlx5e: Fix eswitch debug print of max fdb flow

Russell King (2):
      ASoC: kirkwood: fix external clock probe defer
      ASoC: kirkwood: fix device remove ordering

Sebastian Andrzej Siewior (1):
      x86/fpu: Don't cache access to fpu_fpregs_owner_ctx

Shengjiu Wang (1):
      arm64: dts: imx8mm: fix compatible string for sdma

Shirish S (1):
      drm/amdgpu: dont schedule jobs while in reset

Steffen Klassert (1):
      xfrm: Fix memleak on xfrm state destroy

Stephan Gerhold (1):
      ASoC: msm8916-wcd-analog: Fix RX1 selection in RDAC2 MUX

Steven Rostedt (VMware) (1):
      perf scripting engines: Iterate on tep event arrays directly

Thadeu Lima de Souza Cascardo (1):
      selftests: pmtu: use -oneline for ip route list cache

Theodore Ts'o (1):
      ext4: add more paranoia checking in ext4_expand_extra_isize handling

Timo Schl=FC=DFler (1):
      can: mcp251x: mcp251x_restart_work_handler(): Fix potential force_qui=
t race condition

Toke H=F8iland-J=F8rgensen (1):
      net/fq_impl: Switch to kvmalloc() for memory allocation

Tony Lindgren (1):
      clk: ti: clkctrl: Fix failed to enable error with double udelay timeo=
ut

Uwe Kleine-K=F6nig (1):
      pwm: bcm-iproc: Prevent unloading the driver module while in use

Vladimir Oltean (1):
      net: mscc: ocelot: fix __ocelot_rmw_ix prototype

Xiaochen Shen (1):
      x86/resctrl: Prevent NULL pointer dereference when reading mondata

Xiaojun Sang (1):
      ASoC: compress: fix unsigned integer overflow check

Xin Long (1):
      sctp: cache netns in sctp_ep_common

Xingyu Chen (1):
      watchdog: meson: Fix the wrong value of left time

Yuantian Tang (1):
      arm64: dts: ls1028a: fix a compatible issue

changzhu (1):
      drm/amdgpu: add warning for GRBM 1-cycle delay issue in gfx9


--M9NhX3UHpAaciwkO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEZH8oZUiU471FcZm+ONu9yGCSaT4FAl3pExgACgkQONu9yGCS
aT4xDRAA0nQ0SpSvJeywK/EpKL9i2NadO1NZgU/3NfLFW9PfCJ1yFGiGMmJR2EMG
bVH2BbBdoDWxVT5AsMkvG6Vbr63guJul9CQ/nh81qMpIGu087Pe0jL3vYukb6ert
xY7pHBzS7uWpKlhMxGB9YAr0MQz13CFs+SxJnwekD1w5WGbyRLuCzkOAI4kGIObl
kUFcfC6NN/nXJSh8/7ptD6n5dRzq9iVAWQfvqjbBxeZTTGnFF7ofHS6rkJ5D06q5
XB4sxr3uzscLZa79Lo0esTyJFeS5n7xt636r39GLXA+7IJnKwsewvEtkJi2XF6df
s312mZUeBAOplKJ9R8GWsS/pYLIhw7h1xwul6FIwfqmbe+sd3MjSMnNvOMw2VuyT
2/IfLtzsvpb8uuTPWRwwG/hYEQhlYfmFaLuXwUEtXwYnciPUoa4Z6BQLwlv6L3Cu
DB9tsPn7lbJMoFKmIL2Y7Kn7K2WgTKVJiSZBsoa4b5ekSgxvchjMeRqyTxRL+oQE
M8PSQis0IxMRYRCYAwxBwf+UFxskiTCLbymf7btnZuQHyyWbXXvyC88ramZNQ1sJ
+R9T138u19khg65jV+FbU9/gh1lvlVKeawv8ROvpUQjkXu6yFs7WNmtKNF1J8pcM
ojHPpP3SBDSM66bu47Fadvb0a2vcL2fBm++hdpd6aKqb30heKHE=
=Brf1
-----END PGP SIGNATURE-----

--M9NhX3UHpAaciwkO--

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F96C571DCF
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 17:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233353AbiGLPDG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 11:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233248AbiGLPBw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 11:01:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FE7AC08C7;
        Tue, 12 Jul 2022 07:59:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 940B661477;
        Tue, 12 Jul 2022 14:59:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E390C385A2;
        Tue, 12 Jul 2022 14:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657637981;
        bh=RcTBF4tyz6j1G8ajZ2ENvPzxnadofuktUTNlGFGkBtI=;
        h=From:To:Cc:Subject:Date:From;
        b=cxDjqZDu8k7jQ3ZKsINT+335WhRB7RZ6O+gp+xzQ5w7DJa11myAXeZnr62i3hMenX
         x4CNCzpYmw9XNB+n9ClECbSqRY7t8gwMsW5KzAx6ZloleBkBzjKHNUCiCRVX/zHa5J
         EHygwog2dyfug9FPoQKxpevvliw2UBd+tAWyTtcc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.18.11
Date:   Tue, 12 Jul 2022 16:59:18 +0200
Message-Id: <165763795884238@kroah.com>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.18.11 kernel.

All users of the 5.18 kernel series must upgrade.

The updated 5.18.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.18.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/dma/allwinner,sun50i-a64-dma.yaml |    2 
 MAINTAINERS                                                         |   11 
 Makefile                                                            |    2 
 arch/arm/boot/dts/at91-sam9x60ek.dts                                |    3 
 arch/arm/boot/dts/at91-sama5d2_icp.dts                              |    6 
 arch/arm/boot/dts/stm32mp151.dtsi                                   |    4 
 arch/arm/configs/mxs_defconfig                                      |    1 
 arch/arm/mach-at91/pm.c                                             |   10 
 arch/arm/mach-meson/platsmp.c                                       |    2 
 arch/arm64/boot/dts/freescale/imx8mp-evk.dts                        |   58 +-
 arch/arm64/boot/dts/freescale/imx8mp-phyboard-pollux-rdk.dts        |   48 -
 arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi                   |    2 
 arch/arm64/boot/dts/qcom/msm8992-xiaomi-libra.dts                   |    2 
 arch/arm64/boot/dts/qcom/msm8994.dtsi                               |    4 
 arch/arm64/boot/dts/qcom/sdm845.dtsi                                |    2 
 arch/arm64/boot/dts/qcom/sm8450.dtsi                                |    4 
 arch/powerpc/platforms/powernv/rng.c                                |   16 
 arch/x86/kernel/acpi/cppc.c                                         |   10 
 drivers/acpi/bus.c                                                  |   39 -
 drivers/acpi/cppc_acpi.c                                            |   29 -
 drivers/base/core.c                                                 |   13 
 drivers/base/power/runtime.c                                        |   34 -
 drivers/cxl/cxlmem.h                                                |    8 
 drivers/cxl/mem.c                                                   |    7 
 drivers/cxl/pmem.c                                                  |    6 
 drivers/dma/at_xdmac.c                                              |    5 
 drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c                      |    8 
 drivers/dma/idxd/device.c                                           |    5 
 drivers/dma/imx-sdma.c                                              |    4 
 drivers/dma/lgm/lgm-dma.c                                           |    3 
 drivers/dma/pl330.c                                                 |    2 
 drivers/dma/qcom/bam_dma.c                                          |   39 -
 drivers/dma/ti/dma-crossbar.c                                       |    5 
 drivers/i2c/busses/i2c-cadence.c                                    |    1 
 drivers/i2c/busses/i2c-piix4.c                                      |   16 
 drivers/iommu/intel/dmar.c                                          |    2 
 drivers/iommu/intel/iommu.c                                         |   24 
 drivers/iommu/intel/pasid.c                                         |   69 --
 drivers/iommu/intel/pasid.h                                         |    1 
 drivers/misc/cardreader/rtsx_usb.c                                  |   27 
 drivers/net/can/grcan.c                                             |    1 
 drivers/net/can/m_can/m_can.c                                       |    8 
 drivers/net/can/rcar/rcar_canfd.c                                   |    5 
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c                      |    6 
 drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c                    |   22 
 drivers/net/can/usb/gs_usb.c                                        |   23 
 drivers/net/can/usb/kvaser_usb/kvaser_usb.h                         |   25 
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c                    |  285 +++++-----
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c                   |    4 
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c                    |  119 ++--
 drivers/net/dsa/qca8k.c                                             |   23 
 drivers/net/ethernet/ibm/ibmvnic.c                                  |    9 
 drivers/net/ethernet/intel/i40e/i40e.h                              |   16 
 drivers/net/ethernet/intel/i40e/i40e_main.c                         |   73 ++
 drivers/net/ethernet/intel/i40e/i40e_register.h                     |   13 
 drivers/net/ethernet/intel/i40e/i40e_type.h                         |    1 
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c                  |    4 
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c                     |   13 
 drivers/net/ethernet/microchip/lan966x/lan966x_main.c               |    8 
 drivers/net/ethernet/microchip/lan966x/lan966x_main.h               |    1 
 drivers/net/ethernet/realtek/r8169_main.c                           |   10 
 drivers/net/usb/usbnet.c                                            |   17 
 drivers/pinctrl/sunxi/pinctrl-sun8i-a83t.c                          |   10 
 drivers/pinctrl/sunxi/pinctrl-sunxi.c                               |    2 
 drivers/soc/atmel/soc.c                                             |   12 
 drivers/video/fbdev/core/fbcon.c                                    |   33 +
 drivers/video/fbdev/core/fbmem.c                                    |   16 
 fs/fscache/cookie.c                                                 |   15 
 fs/fscache/volume.c                                                 |    4 
 fs/io_uring.c                                                       |   14 
 include/acpi/cppc_acpi.h                                            |    1 
 include/linux/acpi.h                                                |    4 
 include/linux/fbcon.h                                               |    4 
 include/linux/fscache.h                                             |    1 
 include/linux/intel-iommu.h                                         |    3 
 include/linux/memregion.h                                           |    2 
 include/linux/pm_runtime.h                                          |    5 
 include/linux/rtsx_usb.h                                            |    2 
 include/net/act_api.h                                               |    3 
 include/net/flow_offload.h                                          |    1 
 include/net/pkt_cls.h                                               |    6 
 include/video/of_display_timing.h                                   |    2 
 kernel/bpf/verifier.c                                               |  113 +--
 kernel/rcu/srcutree.c                                               |    6 
 lib/idr.c                                                           |    3 
 net/can/bcm.c                                                       |   18 
 net/mptcp/options.c                                                 |    3 
 net/mptcp/pm_netlink.c                                              |   16 
 net/mptcp/protocol.c                                                |    9 
 net/mptcp/protocol.h                                                |    1 
 net/netfilter/nf_tables_api.c                                       |    9 
 net/netfilter/nft_set_pipapo.c                                      |   48 +
 net/rose/rose_route.c                                               |    4 
 net/sched/act_api.c                                                 |    4 
 net/sched/act_csum.c                                                |    3 
 net/sched/act_ct.c                                                  |    3 
 net/sched/act_gact.c                                                |    3 
 net/sched/act_gate.c                                                |    3 
 net/sched/act_mirred.c                                              |    3 
 net/sched/act_mpls.c                                                |    3 
 net/sched/act_pedit.c                                               |    3 
 net/sched/act_police.c                                              |   20 
 net/sched/act_sample.c                                              |    3 
 net/sched/act_skbedit.c                                             |    3 
 net/sched/act_tunnel_key.c                                          |    3 
 net/sched/act_vlan.c                                                |    3 
 net/sched/cls_api.c                                                 |   16 
 net/sched/cls_flower.c                                              |    6 
 net/sched/cls_matchall.c                                            |    6 
 net/xdp/xsk_buff_pool.c                                             |    1 
 sound/pci/cs46xx/cs46xx.c                                           |   22 
 sound/pci/hda/patch_realtek.c                                       |    1 
 sound/soc/codecs/rt700.c                                            |   16 
 sound/soc/codecs/rt711-sdca.c                                       |   27 
 sound/soc/codecs/rt711.c                                            |   25 
 sound/soc/qcom/qdsp6/q6apm-dai.c                                    |    6 
 sound/soc/sof/intel/hda-pcm.c                                       |   74 --
 sound/soc/sof/intel/hda-stream.c                                    |   94 +++
 sound/soc/sof/intel/hda.h                                           |    3 
 sound/soc/sof/ipc3-topology.c                                       |   23 
 sound/usb/quirks.c                                                  |    4 
 tools/testing/selftests/net/forwarding/lib.sh                       |    6 
 tools/testing/selftests/net/udpgro.sh                               |    2 
 tools/testing/selftests/net/udpgro_bench.sh                         |    2 
 tools/testing/selftests/net/udpgro_frglist.sh                       |    2 
 tools/testing/selftests/net/udpgro_fwd.sh                           |    2 
 tools/testing/selftests/net/veth.sh                                 |    6 
 127 files changed, 1178 insertions(+), 813 deletions(-)

Alison Schofield (1):
      cxl/mbox: Use __le32 in get,set_lsa mailbox structures

Andrei Lalaev (1):
      pinctrl: sunxi: sunxi_pconf_set: use correct offset

Caleb Connolly (1):
      dmaengine: qcom: bam_dma: fix runtime PM underflow

Charles Keepax (2):
      ASoC: rt711: Add endianness flag in snd_soc_component_driver
      ASoC: rt711-sdca: Add endianness flag in snd_soc_component_driver

Christian Marangi (1):
      net: dsa: qca8k: reset cpu port on MTU change

Christophe JAILLET (1):
      dmaengine: lgm: Fix an error handling path in intel_ldma_probe()

Claudiu Beznea (3):
      ARM: at91: pm: use proper compatible for sama5d2's rtc
      ARM: at91: pm: use proper compatibles for sam9x60's rtc and rtt
      ARM: at91: pm: use proper compatibles for sama7g5's rtc and rtt

Dan Williams (1):
      memregion: Fix memregion_free() fallback definition

Daniel Borkmann (2):
      bpf: Fix incorrect verifier simulation around jmp32's jeq/jne
      bpf: Fix insufficient bounds propagation from adjust_scalar_min_max_vals

Dave Jiang (1):
      dmaengine: idxd: force wq context cleanup on device disable path

David Howells (1):
      fscache: Fix invalidation/lookup race

Dmitry Baryshkov (1):
      arm64: dts: qcom: sdm845: use dispcc AHB clock for mdss node

Dmitry Osipenko (1):
      dmaengine: pl330: Fix lockdep warning about non-static key

Duoming Zhou (1):
      net: rose: fix UAF bug caused by rose_t0timer_expiry

Duy Nguyen (1):
      can: rcar_canfd: Fix data transmission failed on R-Car V3U

Dylan Yudaken (1):
      io_uring: fix provided buffer import

Emil Renner Berthing (1):
      dmaengine: dw-axi-dmac: Fix RMW on channel suspend register

Eugen Hristev (2):
      ARM: dts: at91: sam9x60ek: fix eeprom compatible and size
      ARM: dts: at91: sama5d2_icp: fix eeprom compatibles

Fabio Estevam (1):
      ARM: mxs_defconfig: Enable the framebuffer

Fabrice Gasnier (1):
      ARM: dts: stm32: add missing usbh clock and fix clk order on stm32mp15

Greg Kroah-Hartman (1):
      Linux 5.18.11

Guiling Deng (1):
      fbdev: fbmem: Fix logo center image dx issue

Hangbin Liu (1):
      selftests/net: fix section name when using xdp_dummy.o

Heiner Kallweit (1):
      r8169: fix accessing unset transport header

Helge Deller (3):
      fbmem: Check virtual screen sizes in fb_set_var()
      fbcon: Disallow setting font bigger than screen size
      fbcon: Prevent that screen size is smaller than font size

Hsin-Yi Wang (1):
      video: of_display_timing.h: include errno.h

Ido Schimmel (2):
      net/sched: act_api: Add extack to offload_act_setup() callback
      net/sched: act_police: Add extack messages for offload failure

Ivan Malov (1):
      xsk: Clear page contiguity bit when unmapping pool

Jason A. Donenfeld (1):
      powerpc/powernv: delay rng platform device creation until later in boot

Jean Delvare (1):
      i2c: piix4: Fix a memory leak in the EFCH MMIO support

Jimmy Assarsson (3):
      can: kvaser_usb: replace run-time checks with struct kvaser_usb_driver_info
      can: kvaser_usb: kvaser_usb_leaf: fix CAN clock frequency regression
      can: kvaser_usb: kvaser_usb_leaf: fix bittiming limits

Joerg Roedel (1):
      MAINTAINERS: Remove iommu@lists.linux-foundation.org

Jonathan Cameron (1):
      cxl: Fix cleanup of port devices on failure to probe driver.

Konrad Dybcio (1):
      arm64: dts: qcom: msm8994: Fix CPU6/7 reg values

Liang He (1):
      can: grcan: grcan_probe(): remove extra of_node_get()

Linus Torvalds (1):
      ida: don't use BUG_ON() for debugging

Lu Baolu (1):
      iommu/vt-d: Fix RID2PASID setup/teardown failure

Lukasz Cieplicki (1):
      i40e: Fix dropped jumbo frames statistics

Marc Kleine-Budde (5):
      can: m_can: m_can_chip_config(): actually enable internal timestamping
      can: m_can: m_can_{read_fifo,echo_tx_event}(): shift timestamp to full 32 bits
      can: mcp251xfd: mcp251xfd_stop(): add missing hrtimer_cancel()
      can: mcp251xfd: mcp251xfd_register_get_dev_id(): use correct length to read dev_id
      can: mcp251xfd: mcp251xfd_register_get_dev_id(): fix endianness conversion

Mario Limonciello (2):
      ACPI: CPPC: Only probe for _CPC if CPPC v2 is acked
      ACPI: CPPC: Don't require _OSC if X86_FEATURE_CPPC is supported

Mat Martineau (2):
      mptcp: Avoid acquiring PM lock for subflow priority changes
      mptcp: Acquire the subflow socket lock before modifying MP_PRIO flags

Miaoqian Lin (3):
      ARM: meson: Fix refcount leak in meson_smp_prepare_cpus
      dmaengine: ti: Fix refcount leak in ti_dra7_xbar_route_allocate
      dmaengine: ti: Add missing put_device in ti_dra7_xbar_route_allocate

Michael Walle (2):
      net: lan966x: hardcode the number of external ports
      dmaengine: at_xdma: handle errors of at_xdmac_alloc_desc() correctly

Mihai Sain (1):
      ARM: at91: fix soc detection for SAM9X60 SiPs

Norbert Zulinski (1):
      i40e: Fix VF's MAC Address change on VM

Oliver Hartkopp (1):
      can: bcm: use call_rcu() instead of costly synchronize_rcu()

Oliver Neukum (1):
      usbnet: fix memory leak in error case

Pablo Neira Ayuso (2):
      netfilter: nft_set_pipapo: release elements in clone from abort path
      netfilter: nf_tables: stricter validation of element data

Paolo Abeni (1):
      mptcp: fix local endpoint accounting

Paul E. McKenney (1):
      srcu: Tighten cleanup_srcu_struct() GP checks

Peng Fan (10):
      arm64: dts: imx8mp-evk: correct mmc pad settings
      arm64: dts: imx8mp-evk: correct gpio-led pad settings
      arm64: dts: imx8mp-evk: correct vbus pad settings
      arm64: dts: imx8mp-evk: correct eqos pad settings
      arm64: dts: imx8mp-evk: correct I2C5 pad settings
      arm64: dts: imx8mp-evk: correct I2C1 pad settings
      arm64: dts: imx8mp-evk: correct I2C3 pad settings
      arm64: dts: imx8mp-phyboard-pollux-rdk: correct uart pad settings
      arm64: dts: imx8mp-phyboard-pollux-rdk: correct eqos pad settings
      arm64: dts: imx8mp-phyboard-pollux-rdk: correct i2c2 & mmc settings

Peter Robinson (1):
      dmaengine: imx-sdma: Allow imx8m for imx7 FW revs

Peter Ujfalusi (2):
      ASoC: SOF: ipc3-topology: Move and correct size checks in sof_ipc3_control_load_bytes()
      ASoC: SOF: Intel: hda: Fix compressed stream position tracking

Pierre Gondois (2):
      ACPI: CPPC: Check _OSC for flexible address space
      ACPI: bus: Set CPPC _OSC bits for all and when CPPC_LIB is supported

Pierre-Louis Bossart (1):
      ASoC: codecs: rt700/rt711/rt711-sdca: resume bus/codec in .set_jack_detect

Rafael J. Wysocki (2):
      PM: runtime: Redefine pm_runtime_release_supplier()
      PM: runtime: Fix supplier device management during consumer probe

Rhett Aultman (1):
      can: gs_usb: gs_usb_open/close(): fix memory leak

Rick Lindsley (1):
      ibmvnic: Properly dispose of all skbs during a failover.

Samuel Holland (2):
      pinctrl: sunxi: a83t: Fix NAND function name for some pins
      dt-bindings: dma: allwinner,sun50i-a64-dma: Fix min/max typo

Sascha Hauer (1):
      dmaengine: imx-sdma: only restart cyclic channel when enabled

Satish Nagireddy (1):
      i2c: cadence: Unregister the clk notifier in error path

Sherry Sun (1):
      arm64: dts: imx8mp-evk: correct the uart2 pinctl value

Shuah Khan (3):
      misc: rtsx_usb: fix use of dma mapped buffer for usb bulk transfer
      misc: rtsx_usb: use separate command and response buffers
      misc: rtsx_usb: set return value in rsp_buf alloc err path

Srinivas Kandagatla (1):
      ASoC: qdsp6: q6apm-dai: unprepare stream if its already prepared

Stephan Gerhold (1):
      arm64: dts: qcom: msm8992-*: Fix vdd_lvs1_2-supply typo

Takashi Iwai (2):
      ALSA: usb-audio: Workarounds for Behringer UMC 204/404 HD
      ALSA: cs46xx: Fix missing snd_card_free() call at probe error

Thomas Kopp (2):
      can: mcp251xfd: mcp251xfd_regmap_crc_read(): improve workaround handling for mcp2517fd
      can: mcp251xfd: mcp251xfd_regmap_crc_read(): update workaround broken CRC on TBC register

Tim Crawford (1):
      ALSA: hda/realtek: Add quirk for Clevo L140PU

Vlad Buslov (2):
      net/mlx5e: Fix matchall police parameters validation
      net/sched: act_police: allow 'continue' action offload

Vladimir Oltean (3):
      selftests: forwarding: fix flood_unicast_test when h2 supports IFF_UNICAST_FLT
      selftests: forwarding: fix learning_test when h1 supports IFF_UNICAST_FLT
      selftests: forwarding: fix error message in learning_test

Vladimir Zapolskiy (1):
      arm64: dts: qcom: sm8450: fix interconnects property of UFS node

Yian Chen (1):
      iommu/vt-d: Fix PCI bus rescan device hot add

Yue Hu (1):
      fscache: Fix if condition in fscache_wait_on_volume_collision()


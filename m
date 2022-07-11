Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE30F56FB4A
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232450AbiGKJ2S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232236AbiGKJ1o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:27:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A250E64E2C;
        Mon, 11 Jul 2022 02:15:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9EE9AB80E6D;
        Mon, 11 Jul 2022 09:15:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0EA2C34115;
        Mon, 11 Jul 2022 09:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530941;
        bh=ZuLb4omZQJ3lMYE2ZS2vxmz12GL7BupMP2fmN2v/ej4=;
        h=From:To:Cc:Subject:Date:From;
        b=qdY0pisCzgJ0kI5BrQDnh0mcn7WvuLRP8EzDFwRCG2zi9IMuSDFujbMHTOhs8nNyW
         7o53ZYbINiZytkziRdOTqEf36LGllupdgdLrks1Jp0jNc4U5NbMdfs/MB4sgsQJoQe
         yZbYj3cjfW/lBLZzQgZD96nmfrhWbjHVL92moCjI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.18 000/112] 5.18.11-rc1 review
Date:   Mon, 11 Jul 2022 11:06:00 +0200
Message-Id: <20220711090549.543317027@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.11-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.18.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.18.11-rc1
X-KernelTest-Deadline: 2022-07-13T09:05+00:00
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

This is the start of the stable review cycle for the 5.18.11 release.
There are 112 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 13 Jul 2022 09:05:28 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.11-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.18.11-rc1

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: force wq context cleanup on device disable path

Miaoqian Lin <linmq006@gmail.com>
    dmaengine: ti: Add missing put_device in ti_dra7_xbar_route_allocate

Caleb Connolly <caleb.connolly@linaro.org>
    dmaengine: qcom: bam_dma: fix runtime PM underflow

Miaoqian Lin <linmq006@gmail.com>
    dmaengine: ti: Fix refcount leak in ti_dra7_xbar_route_allocate

Michael Walle <michael@walle.cc>
    dmaengine: at_xdma: handle errors of at_xdmac_alloc_desc() correctly

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    dmaengine: lgm: Fix an error handling path in intel_ldma_probe()

Dmitry Osipenko <dmitry.osipenko@collabora.com>
    dmaengine: pl330: Fix lockdep warning about non-static key

Linus Torvalds <torvalds@linux-foundation.org>
    ida: don't use BUG_ON() for debugging

Samuel Holland <samuel@sholland.org>
    dt-bindings: dma: allwinner,sun50i-a64-dma: Fix min/max typo

Emil Renner Berthing <kernel@esmil.dk>
    dmaengine: dw-axi-dmac: Fix RMW on channel suspend register

Shuah Khan <skhan@linuxfoundation.org>
    misc: rtsx_usb: set return value in rsp_buf alloc err path

Shuah Khan <skhan@linuxfoundation.org>
    misc: rtsx_usb: use separate command and response buffers

Shuah Khan <skhan@linuxfoundation.org>
    misc: rtsx_usb: fix use of dma mapped buffer for usb bulk transfer

Sascha Hauer <s.hauer@pengutronix.de>
    dmaengine: imx-sdma: only restart cyclic channel when enabled

Peter Robinson <pbrobinson@gmail.com>
    dmaengine: imx-sdma: Allow imx8m for imx7 FW revs

Vlad Buslov <vladbu@nvidia.com>
    net/sched: act_police: allow 'continue' action offload

Ido Schimmel <idosch@nvidia.com>
    net/sched: act_police: Add extack messages for offload failure

Ido Schimmel <idosch@nvidia.com>
    net/sched: act_api: Add extack to offload_act_setup() callback

Satish Nagireddy <satish.nagireddy@getcruise.com>
    i2c: cadence: Unregister the clk notifier in error path

Heiner Kallweit <hkallweit1@gmail.com>
    r8169: fix accessing unset transport header

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix local endpoint accounting

Mat Martineau <mathew.j.martineau@linux.intel.com>
    mptcp: Acquire the subflow socket lock before modifying MP_PRIO flags

Mat Martineau <mathew.j.martineau@linux.intel.com>
    mptcp: Avoid acquiring PM lock for subflow priority changes

Vlad Buslov <vladbu@nvidia.com>
    net/mlx5e: Fix matchall police parameters validation

Mario Limonciello <mario.limonciello@amd.com>
    ACPI: CPPC: Don't require _OSC if X86_FEATURE_CPPC is supported

Mario Limonciello <mario.limonciello@amd.com>
    ACPI: CPPC: Only probe for _CPC if CPPC v2 is acked

Pierre Gondois <pierre.gondois@arm.com>
    ACPI: bus: Set CPPC _OSC bits for all and when CPPC_LIB is supported

Pierre Gondois <pierre.gondois@arm.com>
    ACPI: CPPC: Check _OSC for flexible address space

Vladimir Oltean <vladimir.oltean@nxp.com>
    selftests: forwarding: fix error message in learning_test

Vladimir Oltean <vladimir.oltean@nxp.com>
    selftests: forwarding: fix learning_test when h1 supports IFF_UNICAST_FLT

Vladimir Oltean <vladimir.oltean@nxp.com>
    selftests: forwarding: fix flood_unicast_test when h2 supports IFF_UNICAST_FLT

Rick Lindsley <ricklind@us.ibm.com>
    ibmvnic: Properly dispose of all skbs during a failover.

Fabrice Gasnier <fabrice.gasnier@foss.st.com>
    ARM: dts: stm32: add missing usbh clock and fix clk order on stm32mp15

Norbert Zulinski <norbertx.zulinski@intel.com>
    i40e: Fix VF's MAC Address change on VM

Lukasz Cieplicki <lukaszx.cieplicki@intel.com>
    i40e: Fix dropped jumbo frames statistics

Jean Delvare <jdelvare@suse.de>
    i2c: piix4: Fix a memory leak in the EFCH MMIO support

Ivan Malov <ivan.malov@oktetlabs.ru>
    xsk: Clear page contiguity bit when unmapping pool

Mihai Sain <mihai.sain@microchip.com>
    ARM: at91: fix soc detection for SAM9X60 SiPs

Eugen Hristev <eugen.hristev@microchip.com>
    ARM: dts: at91: sama5d2_icp: fix eeprom compatibles

Eugen Hristev <eugen.hristev@microchip.com>
    ARM: dts: at91: sam9x60ek: fix eeprom compatible and size

Claudiu Beznea <claudiu.beznea@microchip.com>
    ARM: at91: pm: use proper compatibles for sama7g5's rtc and rtt

Claudiu Beznea <claudiu.beznea@microchip.com>
    ARM: at91: pm: use proper compatibles for sam9x60's rtc and rtt

Claudiu Beznea <claudiu.beznea@microchip.com>
    ARM: at91: pm: use proper compatible for sama5d2's rtc

Stephan Gerhold <stephan.gerhold@kernkonzept.com>
    arm64: dts: qcom: msm8992-*: Fix vdd_lvs1_2-supply typo

Andrei Lalaev <andrey.lalaev@gmail.com>
    pinctrl: sunxi: sunxi_pconf_set: use correct offset

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8mp-phyboard-pollux-rdk: correct i2c2 & mmc settings

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8mp-phyboard-pollux-rdk: correct eqos pad settings

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8mp-phyboard-pollux-rdk: correct uart pad settings

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8mp-evk: correct I2C3 pad settings

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8mp-evk: correct I2C1 pad settings

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8mp-evk: correct I2C5 pad settings

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8mp-evk: correct eqos pad settings

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8mp-evk: correct vbus pad settings

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8mp-evk: correct gpio-led pad settings

Sherry Sun <sherry.sun@nxp.com>
    arm64: dts: imx8mp-evk: correct the uart2 pinctl value

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx8mp-evk: correct mmc pad settings

Fabio Estevam <festevam@denx.de>
    ARM: mxs_defconfig: Enable the framebuffer

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: sdm845: use dispcc AHB clock for mdss node

Konrad Dybcio <konrad.dybcio@somainline.org>
    arm64: dts: qcom: msm8994: Fix CPU6/7 reg values

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    arm64: dts: qcom: sm8450: fix interconnects property of UFS node

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: Intel: hda: Fix compressed stream position tracking

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: ipc3-topology: Move and correct size checks in sof_ipc3_control_load_bytes()

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: codecs: rt700/rt711/rt711-sdca: resume bus/codec in .set_jack_detect

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: rt711-sdca: Add endianness flag in snd_soc_component_driver

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: rt711: Add endianness flag in snd_soc_component_driver

Paul E. McKenney <paulmck@kernel.org>
    srcu: Tighten cleanup_srcu_struct() GP checks

Samuel Holland <samuel@sholland.org>
    pinctrl: sunxi: a83t: Fix NAND function name for some pins

Miaoqian Lin <linmq006@gmail.com>
    ARM: meson: Fix refcount leak in meson_smp_prepare_cpus

Christian Marangi <ansuelsmth@gmail.com>
    net: dsa: qca8k: reset cpu port on MTU change

Jason A. Donenfeld <Jason@zx2c4.com>
    powerpc/powernv: delay rng platform device creation until later in boot

Yue Hu <huyue2@coolpad.com>
    fscache: Fix if condition in fscache_wait_on_volume_collision()

David Howells <dhowells@redhat.com>
    fscache: Fix invalidation/lookup race

Hsin-Yi Wang <hsinyi@chromium.org>
    video: of_display_timing.h: include errno.h

Dan Williams <dan.j.williams@intel.com>
    memregion: Fix memregion_free() fallback definition

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: runtime: Fix supplier device management during consumer probe

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: runtime: Redefine pm_runtime_release_supplier()

Helge Deller <deller@gmx.de>
    fbcon: Prevent that screen size is smaller than font size

Helge Deller <deller@gmx.de>
    fbcon: Disallow setting font bigger than screen size

Helge Deller <deller@gmx.de>
    fbmem: Check virtual screen sizes in fb_set_var()

Guiling Deng <greens9@163.com>
    fbdev: fbmem: Fix logo center image dx issue

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    cxl: Fix cleanup of port devices on failure to probe driver.

Alison Schofield <alison.schofield@intel.com>
    cxl/mbox: Use __le32 in get,set_lsa mailbox structures

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Fix RID2PASID setup/teardown failure

Yian Chen <yian.chen@intel.com>
    iommu/vt-d: Fix PCI bus rescan device hot add

Joerg Roedel <jroedel@suse.de>
    MAINTAINERS: Remove iommu@lists.linux-foundation.org

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    ASoC: qdsp6: q6apm-dai: unprepare stream if its already prepared

Duy Nguyen <duy.nguyen.rh@renesas.com>
    can: rcar_canfd: Fix data transmission failed on R-Car V3U

Marc Kleine-Budde <mkl@pengutronix.de>
    can: mcp251xfd: mcp251xfd_register_get_dev_id(): fix endianness conversion

Marc Kleine-Budde <mkl@pengutronix.de>
    can: mcp251xfd: mcp251xfd_register_get_dev_id(): use correct length to read dev_id

Hangbin Liu <liuhangbin@gmail.com>
    selftests/net: fix section name when using xdp_dummy.o

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: stricter validation of element data

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_set_pipapo: release elements in clone from abort path

Michael Walle <michael@walle.cc>
    net: lan966x: hardcode the number of external ports

Duoming Zhou <duoming@zju.edu.cn>
    net: rose: fix UAF bug caused by rose_t0timer_expiry

Oliver Neukum <oneukum@suse.com>
    usbnet: fix memory leak in error case

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix insufficient bounds propagation from adjust_scalar_min_max_vals

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix incorrect verifier simulation around jmp32's jeq/jne

Marc Kleine-Budde <mkl@pengutronix.de>
    can: mcp251xfd: mcp251xfd_stop(): add missing hrtimer_cancel()

Thomas Kopp <thomas.kopp@microchip.com>
    can: mcp251xfd: mcp251xfd_regmap_crc_read(): update workaround broken CRC on TBC register

Thomas Kopp <thomas.kopp@microchip.com>
    can: mcp251xfd: mcp251xfd_regmap_crc_read(): improve workaround handling for mcp2517fd

Jimmy Assarsson <extja@kvaser.com>
    can: kvaser_usb: kvaser_usb_leaf: fix bittiming limits

Jimmy Assarsson <extja@kvaser.com>
    can: kvaser_usb: kvaser_usb_leaf: fix CAN clock frequency regression

Jimmy Assarsson <extja@kvaser.com>
    can: kvaser_usb: replace run-time checks with struct kvaser_usb_driver_info

Marc Kleine-Budde <mkl@pengutronix.de>
    can: m_can: m_can_{read_fifo,echo_tx_event}(): shift timestamp to full 32 bits

Marc Kleine-Budde <mkl@pengutronix.de>
    can: m_can: m_can_chip_config(): actually enable internal timestamping

Rhett Aultman <rhett.aultman@samsara.com>
    can: gs_usb: gs_usb_open/close(): fix memory leak

Liang He <windhl@126.com>
    can: grcan: grcan_probe(): remove extra of_node_get()

Oliver Hartkopp <socketcan@hartkopp.net>
    can: bcm: use call_rcu() instead of costly synchronize_rcu()

Takashi Iwai <tiwai@suse.de>
    ALSA: cs46xx: Fix missing snd_card_free() call at probe error

Tim Crawford <tcrawford@system76.com>
    ALSA: hda/realtek: Add quirk for Clevo L140PU

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Workarounds for Behringer UMC 204/404 HD

Dylan Yudaken <dylany@fb.com>
    io_uring: fix provided buffer import


-------------

Diffstat:

 .../bindings/dma/allwinner,sun50i-a64-dma.yaml     |   2 +-
 MAINTAINERS                                        |  11 -
 Makefile                                           |   4 +-
 arch/arm/boot/dts/at91-sam9x60ek.dts               |   3 +-
 arch/arm/boot/dts/at91-sama5d2_icp.dts             |   6 +-
 arch/arm/boot/dts/stm32mp151.dtsi                  |   4 +-
 arch/arm/configs/mxs_defconfig                     |   1 +
 arch/arm/mach-at91/pm.c                            |  10 +-
 arch/arm/mach-meson/platsmp.c                      |   2 +
 arch/arm64/boot/dts/freescale/imx8mp-evk.dts       |  58 ++---
 .../dts/freescale/imx8mp-phyboard-pollux-rdk.dts   |  48 ++--
 arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi  |   2 +-
 arch/arm64/boot/dts/qcom/msm8992-xiaomi-libra.dts  |   2 +-
 arch/arm64/boot/dts/qcom/msm8994.dtsi              |   4 +-
 arch/arm64/boot/dts/qcom/sdm845.dtsi               |   2 +-
 arch/arm64/boot/dts/qcom/sm8450.dtsi               |   4 +-
 arch/powerpc/platforms/powernv/rng.c               |  16 +-
 arch/x86/kernel/acpi/cppc.c                        |  10 +
 drivers/acpi/bus.c                                 |  39 ++-
 drivers/acpi/cppc_acpi.c                           |  29 ++-
 drivers/base/core.c                                |  13 +-
 drivers/base/power/runtime.c                       |  34 +--
 drivers/cxl/cxlmem.h                               |   8 +-
 drivers/cxl/mem.c                                  |   7 +-
 drivers/cxl/pmem.c                                 |   6 +-
 drivers/dma/at_xdmac.c                             |   5 +
 drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c     |   8 +-
 drivers/dma/idxd/device.c                          |   5 +-
 drivers/dma/imx-sdma.c                             |   4 +-
 drivers/dma/lgm/lgm-dma.c                          |   3 +-
 drivers/dma/pl330.c                                |   2 +-
 drivers/dma/qcom/bam_dma.c                         |  39 +--
 drivers/dma/ti/dma-crossbar.c                      |   5 +
 drivers/i2c/busses/i2c-cadence.c                   |   1 +
 drivers/i2c/busses/i2c-piix4.c                     |  16 +-
 drivers/iommu/intel/dmar.c                         |   2 +-
 drivers/iommu/intel/iommu.c                        |  24 --
 drivers/iommu/intel/pasid.c                        |  69 +----
 drivers/iommu/intel/pasid.h                        |   1 -
 drivers/misc/cardreader/rtsx_usb.c                 |  27 +-
 drivers/net/can/grcan.c                            |   1 -
 drivers/net/can/m_can/m_can.c                      |   8 +-
 drivers/net/can/rcar/rcar_canfd.c                  |   5 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c     |   6 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c   |  22 +-
 drivers/net/can/usb/gs_usb.c                       |  23 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb.h        |  25 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c   | 285 ++++++++++++---------
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c  |   4 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c   | 119 +++++----
 drivers/net/dsa/qca8k.c                            |  23 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |   9 +
 drivers/net/ethernet/intel/i40e/i40e.h             |  16 ++
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  73 ++++++
 drivers/net/ethernet/intel/i40e/i40e_register.h    |  13 +
 drivers/net/ethernet/intel/i40e/i40e_type.h        |   1 +
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |   4 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  13 +-
 .../net/ethernet/microchip/lan966x/lan966x_main.c  |   8 +-
 .../net/ethernet/microchip/lan966x/lan966x_main.h  |   1 +
 drivers/net/ethernet/realtek/r8169_main.c          |  10 +-
 drivers/net/usb/usbnet.c                           |  17 +-
 drivers/pinctrl/sunxi/pinctrl-sun8i-a83t.c         |  10 +-
 drivers/pinctrl/sunxi/pinctrl-sunxi.c              |   2 +
 drivers/soc/atmel/soc.c                            |  12 +-
 drivers/video/fbdev/core/fbcon.c                   |  33 +++
 drivers/video/fbdev/core/fbmem.c                   |  16 +-
 fs/fscache/cookie.c                                |  15 +-
 fs/fscache/volume.c                                |   4 +-
 fs/io_uring.c                                      |  14 +-
 include/acpi/cppc_acpi.h                           |   1 +
 include/linux/acpi.h                               |   4 +-
 include/linux/fbcon.h                              |   4 +
 include/linux/fscache.h                            |   1 +
 include/linux/intel-iommu.h                        |   3 -
 include/linux/memregion.h                          |   2 +-
 include/linux/pm_runtime.h                         |   5 +-
 include/linux/rtsx_usb.h                           |   2 -
 include/net/act_api.h                              |   3 +-
 include/net/flow_offload.h                         |   1 +
 include/net/pkt_cls.h                              |   6 +-
 include/video/of_display_timing.h                  |   2 +
 kernel/bpf/verifier.c                              | 113 ++++----
 kernel/rcu/srcutree.c                              |   6 +-
 lib/idr.c                                          |   3 +-
 net/can/bcm.c                                      |  18 +-
 net/mptcp/options.c                                |   3 +
 net/mptcp/pm_netlink.c                             |  16 +-
 net/mptcp/protocol.c                               |   9 +-
 net/mptcp/protocol.h                               |   1 +
 net/netfilter/nf_tables_api.c                      |   9 +-
 net/netfilter/nft_set_pipapo.c                     |  48 ++--
 net/rose/rose_route.c                              |   4 +-
 net/sched/act_api.c                                |   4 +-
 net/sched/act_csum.c                               |   3 +-
 net/sched/act_ct.c                                 |   3 +-
 net/sched/act_gact.c                               |   3 +-
 net/sched/act_gate.c                               |   3 +-
 net/sched/act_mirred.c                             |   3 +-
 net/sched/act_mpls.c                               |   3 +-
 net/sched/act_pedit.c                              |   3 +-
 net/sched/act_police.c                             |  20 +-
 net/sched/act_sample.c                             |   3 +-
 net/sched/act_skbedit.c                            |   3 +-
 net/sched/act_tunnel_key.c                         |   3 +-
 net/sched/act_vlan.c                               |   3 +-
 net/sched/cls_api.c                                |  16 +-
 net/sched/cls_flower.c                             |   6 +-
 net/sched/cls_matchall.c                           |   6 +-
 net/xdp/xsk_buff_pool.c                            |   1 +
 sound/pci/cs46xx/cs46xx.c                          |  22 +-
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/soc/codecs/rt700.c                           |  16 +-
 sound/soc/codecs/rt711-sdca.c                      |  27 +-
 sound/soc/codecs/rt711.c                           |  25 +-
 sound/soc/qcom/qdsp6/q6apm-dai.c                   |   6 +
 sound/soc/sof/intel/hda-pcm.c                      |  74 +-----
 sound/soc/sof/intel/hda-stream.c                   |  94 ++++++-
 sound/soc/sof/intel/hda.h                          |   3 +
 sound/soc/sof/ipc3-topology.c                      |  23 +-
 sound/usb/quirks.c                                 |   4 +
 tools/testing/selftests/net/forwarding/lib.sh      |   6 +-
 tools/testing/selftests/net/udpgro.sh              |   2 +-
 tools/testing/selftests/net/udpgro_bench.sh        |   2 +-
 tools/testing/selftests/net/udpgro_frglist.sh      |   2 +-
 tools/testing/selftests/net/udpgro_fwd.sh          |   2 +-
 tools/testing/selftests/net/veth.sh                |   6 +-
 127 files changed, 1179 insertions(+), 814 deletions(-)



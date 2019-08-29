Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F389EA2781
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 22:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728042AbfH2UAG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 16:00:06 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:35005 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727912AbfH2UAG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 16:00:06 -0400
Received: by mail-pl1-f195.google.com with SMTP id gn20so2094394plb.2
        for <stable@vger.kernel.org>; Thu, 29 Aug 2019 13:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=Q0/fnCYTSgCTfSXZe4s2VK94j+w1UjqPpctvwaWmRaQ=;
        b=V/y1wQaUj1RoXZzoU6fihCoLlUB7zBsqSg7hGaC3cdh716tRQMQfm/kFEV0KuGapt0
         ugP5Ay6317H2lBtysFMqr2dnXsxlcaqxpVXlkC0CnG00HM/SRxyFlsa0mjgUb7bGGHuH
         rygEdtsR4kUWnfRv8ZO2pI1KKJQurWQYnd18dCUBwXWNzUemstzKKo8ZIyXiPusM4Oxp
         oDf8WJurQMcTvvQewDtAPWOERzQyJfCDDAOvJQIfETvRC4F9gm10V5c+p69MQ0mrOx/2
         yCaAc2xCf8U2XM5KPpuD/GfAMlTjclJjyVVtE5n2sJswfBNNupfaykIQKMx4yV9ygA+1
         rVEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Q0/fnCYTSgCTfSXZe4s2VK94j+w1UjqPpctvwaWmRaQ=;
        b=oVCNZQC9s8MUfJTHKnsg+gCAjUvNoEHzDBSPkQo0xYXQlcar1a5MYQsC5WxOU48j/B
         7Nf6my4uZSII3YuQLW4JYbNdpYMBfxmk1RgBzoHoa0A/uRzqbrQkVHUo+mq00/iKbidG
         b9PkwDR8yDn6G+o1s3CLtBHMw/DuhXT3hA63h6h5s14ntX7S9Bf7Xu8TTefNLJrhP6+1
         YFqzH4hScA2OZjLstoSpRA6+3fvE3PV18365q92jp3v2lql8/udoml6aSJ/NaoMeLdsj
         dJAg2zR/xP+LVpKHWu1E1EnJtYmLiqH4ALvv0Fyrb35//sZ60tASQ9jYll/7Ba01XI/r
         5zlw==
X-Gm-Message-State: APjAAAVEJDT2pbbWIJMn6mbOXkgzcIvlC/quieIz9w2YXiP2z9+N3fyM
        vuhseIERcyLueIfYKVjyG2Hka/Paxms=
X-Google-Smtp-Source: APXvYqwiQ9MCf07sSguf9rTuZx4jmSZIY11T7YOmPN/ywrsQyCrotNvWS+7LO9++0RcuEr9Lp03bBQ==
X-Received: by 2002:a17:902:142:: with SMTP id 60mr11900962plb.155.1567108804156;
        Thu, 29 Aug 2019 13:00:04 -0700 (PDT)
Received: from xps15.cg.shawcable.net (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id u7sm3053766pgr.94.2019.08.29.13.00.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 13:00:03 -0700 (PDT)
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     stable@vger.kernel.org
Cc:     architt@codeaurora.org, a.hajda@samsung.com,
        Laurent.pinchart@ideasonboard.com, airlied@linux.ie, jsarha@ti.com,
        tomi.valkeinen@ti.com, vinholikatti@gmail.com,
        jejb@linux.vnet.ibm.com, martin.petersen@oracle.com,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: [BACKPORT 4.19.y 0/3] Candidate from TI 4.19 product kernel 
Date:   Thu, 29 Aug 2019 13:59:58 -0600
Message-Id: <20190829200001.17092-1-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I re-used the same scripted approach taken by Arnd [1] to look at patches 
backported to TI's ti-linux-4.19.y tree [2] (the full list can be found
below).  Out of the lot about a hundred were considered but most of them
either didn't apply cleanly, involved multiple files or did not compile.  

The remaining set is submitted herein and applies correctly to v4.19.68.

Regards,
Mathieu

[1]. https://lore.kernel.org/lkml/20190322154425.3852517-19-arnd@arndb.de/T/
[2]. http://git.ti.com/gitweb/?p=ti-linux-kernel/ti-linux-kernel.git;a=summary

Jyri Sarha (1):
  drm/tilcdc: Register cpufreq notifier after we have initialized crtc

Pedro Sousa (1):
  scsi: ufs: Fix RX_TERMINATION_FORCE_ENABLE define value

Tomi Valkeinen (1):
  drm/bridge: tfp410: fix memleak in get_modes()

 drivers/gpu/drm/bridge/ti-tfp410.c  |  7 +++++-
 drivers/gpu/drm/tilcdc/tilcdc_drv.c | 34 ++++++++++++++---------------
 drivers/scsi/ufs/unipro.h           |  2 +-
 3 files changed, 24 insertions(+), 19 deletions(-)

-- 
2.17.1

100  100 78eccc2ac98e arm64: dts: ti: k3-j721e: Add the MCU SRAM node
  73  100 073086fc68d7 arm64: dts: ti: k3-j721e: Add interrupt controllers in main domain
  77  100 1463a70dfc87 arm64: dts: ti: k3-j721e-main: Add Main NavSS Interrupt controller node
 100  100 3cd277c6d021 arm64: defconfig: Enable TI's J721E SoC platform
  97  100 803d3a1870e2 arm64: dts: ti: Add support for J721E Common Processor Board
 100  100 cff377f7897a soc: ti: Add Support for J721E SoC config option
  92  100 2d87061e70de arm64: dts: ti: Add Support for J721E SoC
 100  100 e28c6d941dac dt-bindings: serial: 8250_omap: Add compatible for J721E UART controller
 100  100 7c42f43c29e2 dt-bindings: arm: ti: Add bindings for J721E SoC
  84  100 30eb8ea46cc6 arm64: dts: k3-am6: Add PCIe Endpoint DT node
  41  100 cedc255cc6fe arm64: dts: k3-am6: Add SERDES DT node
 100  100 4b4ffc6e1f66 arm64: dts: k3-am6: Add "socionext,synquacer-pre-its" property to gic_its
 100  100 833123386c69 arm64: dts: ti: k3-am65: Add R5F ranges in interconnect nodes
  75  100 f853f0053164 arm64: dts: ti: k3-am65-mcu: Add the MCU RAM node
 100  100 0ded541218d1 arm64: dts: ti: k3-am65: Add MCU SRAM ranges in interconnect nodes
 100  100 c67f7388a62e arm64: dts: ti: am654-base-board: Add gpio_keys node
  69   53 fa42da11b285 firmware: ti_sci: Parse all resource ranges even if some is not available
  35  100 1e407f337f40 firmware: ti_sci: Add support for processor control
  86  100 68608b5e5063 firmware: ti_sci: Add resource management APIs for ringacc, psi-l and udma
 100  100 66f030eac257 firmware: ti_sci: Always request response from firmware
 100  100 541e4095f388 gpio: davinci: silence error prints in case of EPROBE_DEFER
 100  100 d4d98bba3ea5 hwspinlock/omap: Add a trace during probe
 100  100 6fa154e282f9 hwspinlock/omap: Add support for TI K3 SoCs
 100  100 7f40c260df86 dt-bindings: hwlock: Update OMAP binding for TI K3 SoCs
 100  100 81f4458c9c69 firmware: ti_sci: extend clock identifiers from u8 to u32
  94   94 3f1f22d80090 clk: keystone: sci-clk: extend clock IDs to 32 bits
  30  100 8e48b33f9def clk: keystone: sci-clk: probe clocks from DT instead of firmware
  88  100 4bfce5aba902 clk: keystone: sci-clk: split out the fw clock parsing to own function
 100  100 96488c09b0f4 clk: keystone: sci-clk: cut down the clock name length
 100  100 b1622cb3be45 drm/bridge: tfp410: fix use of cancel_delayed_work_sync
 100  100 c08f99c39083 drm/bridge: tfp410: fix memleak in get_modes()
  56   98 ff5781634c41 drm/bridge: sii902x: Implement HDMI audio support
  60  100 8dbfc5b65023 drm/bridge: sii902x: pixel clock unit is 10kHz instead of 1kHz
  33   33 bceee9bb8948 drm/bridge: sii902x: Set output mode to HDMI or DVI according to EDID
 100  100 9fba099b7a84 drm/bridge: sii902x: add input_bus_flags
 100  100 423997fffeaf dt-bindings: tc358767: add HPD support
  77   97 f25ee5017e4f drm/bridge: tc358767: add IRQ and HPD support
 100  100 af9526f262c0 drm/bridge: tc358767: add GPIO & interrupt registers
 100   25 46648a3cec2d drm/bridge: tc358767: copy the mode data, instead of storing the pointer
  55  100 0cdb42f313e0 drm/bridge: tc358767: remove tc_connector_best_encoder
 100  100 4647a64fd56a drm/bridge: tc358767: use bridge mode_valid
 100   50 2792c152a845 drm/bridge: tc358767: remove check for video mode in link enable
  60  100 f9538357760b drm/bridge: tc358767: clean-up link training
 100   87 0bf251465113 drm/bridge: tc358767: cleanup LT result check
 100  100 31b4c8848a89 drm/bridge: tc358767: remove unnecessary msleep
  92  100 cb3263b2df97 drm/bridge: tc358767: add link disable function
  90  100 bb24836869a7 drm/bridge: tc358767: move PXL PLL enable/disable to stream enable/disable
  82   80 80d57245063f drm/bridge: tc358767: split stream enable/disable
 100  100 ca342386a9b3 drm/bridge: tc358767: cleanup aux_link_setup
 100  100 ab947eb65a31 drm/bridge: tc358767: remove unused swing & preemp
 100  100 e5607637c461 drm/bridge: tc358767: cleanup spread & scrambler_dis
 100  100 4b30bf41e11f drm/bridge: tc358767: fix ansi 8b10b use
 100  100 bfb6e014c45f drm/bridge: tc358767: fix tc_aux_get_status error handling
 100  100 7ad9db66fafb drm/panel: simple: Fix panel_simple_dsi_probe
  87  100 b97b042a5029 drm/panel: Add OSD101T2587-53TS driver
  87  100 9c1f2a5dc294 mailbox: omap: Add support for TI K3 SoCs
  93  100 8c665292ec12 dt-bindings: mailbox: omap: Update bindings for TI K3 SoCs
  92  100 b07079f1642c mtd: hyperbus: Add driver for TI's HyperBus memory controller
  38  100 d7865933af9e dt-bindings: mtd: Add bindings for TI's AM654 HyperBus memory controller
  97  100 dcc7d3446a0f mtd: Add support for HyperBus memory devices
 100  100 89ebf2b8501c dt-bindings: mtd: Add binding documentation for HyperFlash
  25   98 4844ef80305d mtd: cfi_cmdset_0002: Add support for polling status register
 100   38 1accbced1c32 mmc: sdhci_am654: Add Support for 4 bit IP on J721E
  97   62 99909b55f298 mmc: sdhci_am654: Add Support for 8 bit IP on J721E
 100   77 a457b70904bb dt-bindings: mmc: sdhci-am654: Document bindings for the host controllers on TI's J721E devices.
 100  100 7e24e28b79b3 mmc: sdhci_am654: Print error message if the DLL fails to lock
  87   98 573aff747ee3 usb:cdns3 Fix for stuck packets in on-chip OUT buffer.
  84  100 8bc1901ca7b0 usb:cdns3 Add Cadence USB3 DRD Driver
 100   50 b13a3539eb2a scsi: ufs-bsg: complete ufs-bsg job only if no error
 100  100 821744403913 scsi: ufs: Add error-handling of Auto-Hibernate
  86  100 ee5f1042b20e scsi: ufs: Introduce ufshcd_is_auto_hibern8_supported()
 100   54 9700022109b6 ASoC: pcm3168a: Add support for multi DIN/DOUT with TDM slots parameter
 100   60 b5d8dffb8cc9 ASoC: pcm3168a: Rename min_frame_size to slot_width
 100   69 764958f2b523 ASoC: ti: davinci-mcasp: Support for auxclk-fs-ratio
 100  100 b7e47f48f119 bindings: sound: davinci-mcasp: Add support for optional auxclk-fs-ratio
  83  100 9b8e8b893ff5 ASoC: pcm3168a: Implement set_tdm_slot callback
 100  100 6eeea326b389 gpio: Davinci: Add K3 dependencies
 100  100 36c0551976d5 gpio: davinci: Fix the compiler warning with ARM64 config enabled
 100  100 009669e74813 arm64: arch_k3: Enable interrupt controller drivers
  79  100 accaf1fbfb5d dt-bindings: irqchip: Introduce TISCI Interrupt Aggregator bindings
  51  100 cd844b0715ce irqchip/ti-sci-intr: Add support for Interrupt Router driver
  22  100 67d2075ad695 dt-bindings: irqchip: Introduce TISCI Interrupt router bindings
  58  100 032a1ec549a7 firmware: ti_sci: Add helper apis to manage resources
 100  100 754c9477ae78 firmware: ti_sci: Add RM mapping table for am654
  66  100 997b001f6bb2 firmware: ti_sci: Add support for IRQ management
 100  100 9c19fb6895be firmware: ti_sci: Add support for RM core ops
  96  100 905c30477f4d firmware: ti_sci: Add support to get TISCI handle using of_phandle
 100  100 11140cc40ddc ARM: OMAP2+: sleep43xx: Run EMIF HW leveling on resume path
 100  100 6c110561eb2d memory: ti-emif-sram: Add ti_emif_run_hw_leveling for DDR3 hardware leveling
  72   90 5a99ae0092fe soc: ti: pm33xx: AM437X: Add rtc_only with ddr in self-refresh support
  80  100 1c6c03545089 soc: ti: pm33xx: Move the am33xx_push_sram_idle to the top
  85  100 44c22a2d12a5 ARM: OMAP2+: pm33xx: Add support for rtc+ddr in self refresh mode
  68  100 6256f7f7f217 rtc: OMAP: Add support for rtc-only mode
 100  100 b5acec09e259 ARM: dts: dra7: Add properties to enable PCIe x2 lane mode
 100  100 fbca0b284bd0 tools: PCI: Add 'h' in optstring of getopt()
  88  100 5bb04b19230c misc: pci_endpoint_test: Add support to test PCI EP in AM654x
 100  100 fc9a77040b04 PCI: designware-ep: Configure Resizable BAR cap to advertise the smallest size
  81   76 23284ad677a9 PCI: keystone: Add support for PCIe EP in AM654x Platforms
 100  100 ddf567e3d994 PCI: dwc: Add callbacks for accessing dbi2 address space
 100  100 421db1ab287e PCI: dwc: Fix dw_pcie_ep_find_capability() to return correct capability offset
  80   80 626961dd6d32 PCI: dwc: Add const qualifier to struct dw_pcie_ep_ops
 100  100 2a9a801620ef PCI: endpoint: Add support to specify alignment for buffers allocated to BARs
  82  100 fbb2de891cc4 PCI: keystone: Add support to set the max link speed from DT
 100  100 40e5d614a0cd PCI: OF: Allow of_pci_get_max_link_speed() to be used by PCI Endpoint drivers
 100  100 b22af42b3e57 PCI: keystone: Invoke phy_reset() API before enabling PHY
  54   85 18b0415bc802 PCI: keystone: Add support for PCIe RC in AM654x Platforms
 100  100 162aaa3b6cc1 dt-bindings: PCI: Add PCI RC DT binding documentation for AM654
  71   66 a9f4c2d2f99e PCI: dwc: Enable iATU unroll for endpoint too
 100  100 26f51e85b3b6 dt-bindings: PCI: Document "atu" reg-names
  72  100 156c6fef75a4 PCI: keystone: Explicitly set the PCIe mode
 100  100 1c55c4263fe7 dt-bindings: PCI: Add dt-binding to configure PCIe mode
 100  100 47fe944138a6 dt-bindings: PCI: keystone: Add "reg-names" binding information
  76   62 0790eb175ee0 PCI: keystone: Cleanup error_irq configuration
  81   77 9afb20d600da PCI: keystone: Add start_link()/stop_link() dw_pcie_ops
  83   83 fd8a44bd5b76 PCI: dwc: Remove default MSI initialization for platform specific MSI chips
  67   56 dad5258999e9 PCI: dwc: Remove Keystone specific dw_pcie_host_ops
 100   46 117c3b60bd53 PCI: keystone: Use Keystone specific msi_irq_chip
 100   33 f6f2900ca9b7 PCI: keystone: Use hwirq to get the MSI IRQ number offset
  55   75 1146c2953dcb PCI: keystone: Add separate functions for configuring MSI and legacy interrupt
 100  100 efc80fb37466 pwm: tiehrpwm: Enable compilation for ARCH_K3
 100  100 b54d1ed07ad8 dt-bindings: pwm: tiehrpwm: Add TI AM654 SoC specific compatible
  58   33 869decd1ff19 clk: ti: dra7: disable the RNG and TIMER12 clkctrl clocks on HS devices
  41   83 2b1202d708fd clk: ti: dra7x: prevent non-existing clkctrl clocks from registering
 100  100 e155e3883019 i2c: gpio: flag atomic capability if possible
 100  100 8927fbf48124 i2c: algo: bit: add flag to whitelist atomic transfers
 100  100 252fa60e7054 i2c: stu300: use xfer_atomic callback to bail out early
 100  100 08960b022fb6 i2c: tegra-bpmp: convert to use new atomic callbacks
 100  100 89f845a6dcd3 i2c: omap: Add the master_xfer_atomic hook
 100  100 77c1e1e062b6 i2c: demux: handle the new atomic callbacks
 100  100 7168bff2cfd7 i2c: mux: populate the new *_atomic callbacks
 100   91 63b96983a5dd i2c: core: introduce callbacks for atomic transfers
  53   46 83c42212d254 i2c: core: use I2C locking behaviour also for SMBUS
  83   83 bae1d3a05a8b i2c: core: remove use of in_atomic()
 100   71 5011454ee34a ASoC: pcm3168a: Enable TDM support for DSP_A/B modes
 100  100 8ca5104715cf ASoC: davinci-mcasp: Fix clang warning without CONFIG_PM
 100  100 0eb2766dd6f3 drm/bridge: ti-tfp410: Set the bus_format
 100   80 51c7b4477c8b dt-bindings: display: tfp410: Add bus-width parameter property
 100  100 3d31e2152281 drm/bridge: ti-tfp410: Fall back to HPD polling if HPD irq is not available
 100   40 a0970e87b5d3 drm: Turn bus flags macros into an enum
 100   77 8bf4b1621178 drm/omap: Remove panel-dpi driver
  99   73 be3143d8b27f drm/omap: Remove TFP410 and DVI connector drivers
  85   95 4e17763c321f drm/omap: Whitelist DT nodes to fixup with omapdss, prefix
 100   64 30b71761957c drm/omap: Add support for drm_panel
  88   37 79107f274b2f drm/omap: Add support for drm_bridge
 100  100 1b1b5330a007 dt-bindings: display: Add OSD Displays OSD070T1718-19TS panel binding
 100  100 b7b33786b7c3 dt-bindings: Add vendor prefix for OSD Displays
 100  100 897dae5657e6 drm/bridge: ti-tfp410: Report input bus config through bridge timings
 100  100 38c02db7e66e drm/bridge: ti-tfp410: Add support for the powerdown GPIO
 100  100 60b903c3e621 drm/bridge: ti-tfp410: Set connector type based on DT connector node
  91  100 2645d8d0980c dt-bindings: display: tfp410: Add bus parameters properties
  62   58 88bc4178568b drm: Use new DRM_BUS_FLAG_*_(DRIVE|SAMPLE)_(POS|NEG)EDGE flags
  88   46 0dbfc3966720 drm/omap: Merge omap_dss_device type and output_type fields
 100   29 ce69aac84fe3 drm/omap: Simplify OF lookup of DSS devices
 100   46 e5906f765c68 drm/omap: Store pixel clock instead of full mode in DPI and SDI encoders
 100   62 b08644a235a4 drm/omap: venc: Use drm_display_mode natively
  78   42 41322aa69195 drm/omap: Pass drm_display_mode to .check_timings() and .set_timings()
  73   70 d60dfaba4225 drm/omap: venc: Simplify mode setting by caching configuration
  52   52 40e5f937d50f drm/omap: venc: List both PAL and NTSC modes
  90   61 46b3847d7f68 drm/omap: Add a dss device operation flag for .get_modes()
  81   31 a872d5e92a67 drm/omap: Merge display .get_modes() and .get_size() operations
  82   47 870e19d59f8a drm/omap: Expose DRM modes instead of timings in display devices
  96   56 19b4200d8f4b drm/omap: Reverse direction of the DSS device enable/disable operations
  55   88 3f3623dd0f88 drm/omap: Remove enable checks from display .enable() and .remove()
  73   33 b49a2139ba67 drm/omap: Remove connection checks from display .enable() and .remove()
 100   65 f8a8eabb273b drm/omap: Remove connection checks from internal encoders .enable()
  79   94 b80bfc66b0ee drm/omap: Move common display enable/disable code to encoder
 100   28 d2c53162f557 drm/omap: Use atomic suspend/resume helpers
  81   81 d79bd6b445a2 drm/omap: venc: Remove wss_data field from venc_device structure
 100  100 374805b0bd84 drm/omap: Remove unused kobj field from struct omap_dss_device
 100  100 5d79ef3fcd41 drm/omap: Remove declaration of nonexisting function
 100  100 8518f05a7110 drm/atomic: Constify mode argument to mode_valid_path()
 100  100 ebcb8f8508c5 scsi: ufs: Fix RX_TERMINATION_FORCE_ENABLE define value
  97   72 4fed62bc1c26 scsi: ufs-cdns: Add support for UFSHCI with M31 PHY
  50  100 71e2f5c5c224 phy: ti: Add a new SERDES driver for TI's AM654x SoC
 100  100 4df614c4ab18 phy: core: Invoke pm_runtime_get_*/pm_runtime_put_* before invoking reset callback
  71  100 fec06b2bc436 phy: core: Add *release* phy_ops invoked when the consumer relinquishes PHY
 100  100 1d1bae725075 phy: ti-pipe3: Fix PCIe power up sequence
 100  100 9d009d9c2062 phy: ti-pipe3: Fix SATA & USB PHY power up sequence
  97   99 fdef2f9f700f phy: ti-pipe3: improve DPLL stability for SATA & USB
  97  100 22940823f062 phy: ti-pipe3: Introduce mode property in driver data
  80  100 a71a18f24d26 net: ethernet: ti: cpsw: introduce mac sl module api
 100  100 e374e87538f4 mmc: sdhci_am654: Clear HISPD_ENA in some lower speed modes
  94  100 5c41ea6d5200 mmc: sdhci-omap: Don't finish_mrq() on a command error during tuning
  91  100 60b8f0ddf1a9 clk: Add (devm_)clk_get_optional() functions
 100   33 5c17f87abb1a scsi: ufs-bsg: Allow reading descriptors
 100   40 4bbbe2421634 scsi: ufs: Allow reading descriptor via raw upiu
 100   77 35ce0d7922d6 PCI: endpoint: Remove features member in struct pci_epc
 100  100 92f2b028418c PCI: designware-plat: Remove setting epc->features in Designware plat EP driver
 100  100 f1267978457e PCI: rockchip: Remove pci_epf_linkup() from Rockchip EP driver
  83  100 c274c9f4ea75 PCI: cadence: Remove pci_epf_linkup() from Cadence EP driver
  90   97 2c04c5b8eef7 PCI: pci-epf-test: Use pci_epc_get_features() to get EPC features
 100  100 b866c56b66d8 PCI: pci-epf-test: Do not allocate next BARs memory if current BAR is 64Bit
  50  100 0342e9a797db PCI: pci-epf-test: Remove setting epf_bar flags in function driver
 100  100 5544d67ed112 PCI: endpoint: Fix pci_epf_alloc_space() to set correct MEM TYPE flags
 100  100 1e9efe6c9976 PCI: endpoint: Add helper to get first unreserved BAR
  53  100 67c777e6015d PCI: cadence: Populate ->get_features() cdns_pcie_epc_ops
  84  100 146221768c74 PCI: rockchip: Populate ->get_features() dw_pcie_ep_ops
 100  100 4894467e7861 PCI: pci-dra7xx: Populate ->get_features() dw_pcie_ep_ops
 100  100 3b4322e589a6 PCI: designware-plat: Populate ->get_features() dw_pcie_ep_ops
  84  100 fee35cb76a54 PCI: dwc: Add ->get_features() callback function to dw_pcie_ep_ops
  69  100 41cb8d189c9d PCI: endpoint: Add new pci_epc_ops to get EPC features
 100  100 c232c0df9610 PCI: dwc: dra7xx: Enable x2 mode support for dra74x, dra76x and dra72x
 100  100 1c5d2cc7196c dt-bindings: PCI: dra7xx: Add properties to enable x2 lane in dra7
 100  100 33d5c207a9ed dt-bindings: PCI: dra7xx: Add SoC specific compatible strings
 100  100 7945f929f1a7 drivers: provide devm_platform_ioremap_resource()
 100  100 432973fd3a20 drm/tilcdc: Register cpufreq notifier after we have initialized crtc
 111  111 c39ff7ea7805 drm: omapdrm: Cleanup drm_display_mode print str
 100  100 b962a12050a3 drm/atomic: integrate modeset lock with private objects
 100  100 1381a5113caf usb: dwc3: debug: purge usage of strcat
  36  100 7790b3556fcc usb: dwc3: trace: pass trace buffer size to decoding functions
 100  100 eca6b49430c6 usb: dwc3: keystone: Add support for ti,am654-dwc3
 100  100 d26c05781e08 dt-bindings: usb: keystone-usb: Add ti,am654-dwc3 support
 100  100 6777cee3a872 phy: ti: usb2: Add support for AM654 USB2 PHY
 100  100 e712792ec0dd dt-bindings: phy: ti: Add support for AM654x USB2 PHY
 100  100 266744faec8c phy: ti: Don't depend on OMAP_OCP2SCP
 100  100 ed31ee7cf1fe phy: ti: usb2: Fix logic on -EPROBE_DEFER
 100   85 7d470ebf586b serial: 8250_omap: Use clk_get_rate() to obtain fclk frequency
 100  100 7f0c77f35b1b dt-bindings: serial: omap_serial: add clocks entry
  61  100 d6ce4ec0b816 serial: 8250_omap: Drop check for of_node
 100  100 032ecb59aa38 staging: android: ion: Remove unused headers
 100  100 96d12a0d9409 staging: android: ion: Sync comment docs with struct ion_buffer
 100  100 4d5119f448a8 staging: android: ion: Fixup some white-space issues
  80  100 c72f4e31c8a3 staging: android: ion: Remove struct ion_platform_heap
 100  100 6e42d12ce0da staging: android: ion: Remove leftover comment
  97   97 4514e79e5a6b staging: android: ion: Merge ion-ioctl.c into ion.c
  75  100 2fbe1707bae2 staging: android: ion: Remove empty ion_ioctl_dir() function
 100  100 32462a98a005 staging: android: ion: Add proper header information
 100   96 540f1ba7b3a5 ASoC: ti: davinci-mcasp: Add support for GPIO mode of the pins
 100  100 4664b94c98b4 ASoC: davinci-mcasp: Document GPIO support
 100  100 aa6eaaa2ffad arm64: dts: ti: k3-am65-mcu: Add ADC nodes
 100  100 5bb57a7488c6 dt-bindings: input: ti-tsc-adc: Add new compatible for AM654 SoCs
  25  100 7147f341e982 arm64: dts: ti: am654: Add Main System Control Module node
 100  100 42d712a74d09 arm64: dts: ti: k3-am65: Add MSMC RAM node
 100  100 7dd2e8f8a5dc ARM: dts: da850-lcdk: Enable the analog mic input
 100  100 2cc788387497 mtd: spi-nor: cadence-quadspi: Add support for Octal SPI controller
 100  100 70b64604fef0 dt-bindings: cadence-quadspi: Add new compatible for AM654 SoC
 100   33 2bda2f811b36 mtd: spi-nor: add octal read flag for flash mt35xu512aba
  87   87 fcd44b64b1eb mtd: spi-nor: add opcodes for octal Read/Write commands
 100  100 6297388e1edd drm/omap: dsi: Hack-fix DSI bus flags
 100  100 4b3ab9372ffa iio: adc: ti_am335x_tscadc: Improve accuracy of measurement
 100  100 f8c15790e4d8 drm/bridge: tc358767: use DP connector if no panel set
  67  100 6d6b05e3d533 PCI: dwc: Don't hard-code DBI/ATU offset
 100  100 a6906a8b0ebf iommu/omap: Remove DEBUG_SEQ_FOPS_RO()
 100  100 5da94b50475a arm64: dts: ti: k3-am654: Enable main domain McSPI0
  80  100 2cd7d393f461 arm64: dts: ti: k3-am654: Add McSPI DT nodes
 100  100 e577d79424c0 arm64: dts: ti: k3-am654-base-board: Enable ECAP PWM
  77  100 07c663b0ee57 arm64: dts: ti: k3-am65-main: Add ECAP PWM node
  91  100 19a1768fc34a arm64: dts: ti: k3-am654-base-board: Add I2C nodes
 100  100 3f94859fd7ba arm64: dts: ti: am654-base-board: Add pinmux for main uart0
 100  100 1d79b4375fbc arm64: dts: ti: k3-am65: Add pinctrl regions
 100  100 fc66393ab5d6 dt-bindings: pinctrl: k3: Introduce pinmux definitions
 100   81 0ec47be539e3 ARM: dts: am437x-gp-evm: Add sleep state for beeper pins
 100   92 6a156a05bb55 ARM: dts: am437x-gp-evm: Add pinmux for gpio0 wake
  60   86 74fe9bf45e71 ARM: dts: am437x-gp-evm: Add uart0 pinctrl default and sleep states
 100   85 7235ed186e12 ARM: dts: am437x-gp-evm: Add pinctrl for debugss pins
  92   96 88f527d0cf0b ARM: dts: am437x-gp-evm: Add pinctrl for unused_pins
  75  100 865852a6e52f ARM: dts: am437x-gp-evm: Add state for ddr3 vtt toggle pin
 100  100 03b10fecb921 soc: ti: wkup_m3: Add PRCM int16 as the wake up source
 100  100 f9bb84090777 staging: android: ion: Remove unused header files
 100   96 4073536c9274 staging: android: ion: Add per-heap counters
 100  100 1517265228b4 usb: dwc3: trace: log ep commands in hex
 100  100 408d3ba006af usb: dwc3: don't log probe deferrals; but do log other error codes
 100  100 0d36dede4578 usb: dwc3: debugfs: Properly print/set link state for HS
 100  100 2ed869990e14 phy: Add MIPI D-PHY configuration options
 100  100 aeaac93ddb28 phy: Add configuration interface
 100  100 c8457828ff48 phy: Add MIPI D-PHY mode
  34   99 44d30d622821 phy: cadence: Add driver for Sierra PHY
 100  100 cb96a690724e dt-bindings: phy: Document cadence Sierra PHY bindings
 100   50 b3af06451bf8 phy: core: clean up unused ethernet specific phy modes
 100  100 cccc43b853df phy: mvebu-cp110-comphy: convert to use eth phy mode and submode
 100  100 2af8caeee478 phy: core: add PHY_MODE_ETHERNET
  96   96 79a5a18aa9d1 phy: core: rework phy_set_mode to accept phy mode and submode
 100  100 f0001f587731 dt-bindings: phy: Document cadence Sierra PHY bindings
  97  100 961de0a856e3 mmc: sdhci-omap: Workaround errata regarding SDR104/HS200 tuning failures (i929)
 100  100 58fe8bbacd28 dt-bindings: sdhci-omap: Add note for cpu_thermal
  60   78 41fd4caeb00b mmc: sdhci_am654: Add Initial Support for AM654 SDHCI driver
  94  100 f98b4f98bbc8 dt-bindings: mmc: sdhci-am654: Document bindings for the host controllers on TI's AM654 SOCs
 100  100 52b5f5cfa2f7 mmc: sdhci-omap: Remove redundant structure assignments
 100  100 5b0d62108b46 mmc: sdhci-omap: Add platform specific reset callback
  77  100 d90996dae8e4 scsi: ufs: Add UFS platform driver for Cadence UFS
  87  100 85408f830e70 scsi: dt-bindings: ufs: Add bindings for Cadence UFS
 100  100 9e1e8a757080 scsi: ufs: set the device reference clock setting
 100   92 5e28b8d8a1b0 bsg: provide bsg_remove_queue() helper
 100   90 aae3b069d5ce bsg: pass in desired timeout handler
 100  100 1ebb2446c303 net: ethernet: ti: cpsw: allow vlan tagged packets to be timestamped
  91  100 a9423120343c net: ethernet: ti: cpts: move enable/disable flags outside of cpts module
 100  100 f19dcd5f118d net: ethernet: ti: cpts: purge staled skbs from txq
 100  100 d0e14c4d9bce net: ethernet: ti: cpts: correct debug for expired txq skb
 100   77 b12a084c8729 spi: spi-mem: add support for octal mode I/O data transfer
 100   87 6b03061f882d spi: add support for octal mode I/O data transfer
 100  100 81df42d10457 spi: Kconfig: Enable McSPI driver for K3 platforms
 100  100 abc61f47a70f spi: omap-spi: Add compatible for AM654 SoC
 100  100 41e95652ee22 ARM: davinci_all_defconfig: Update the audio options
 100  100 eab5b50a13de ARM: omap1_defconfig: Do not select ASoC by default
 100  100 3162b05fb74c ARM: omap2plus_defconfig: Update the audio options
 100  100 4d8c1e7efb9f ARM: davinci: dm365-evm: Update for the new ASoC Kcofnig options
 100  100 558eb0bfb271 ARM: OMAP2: Update for new MCBSP Kconfig option
 100  100 c27ace2e95a2 ARM: OMAP1: Makefile: Update for new MCBSP Kconfig option
 100  100 ca1c4d653524 MAINTAINERS: Add entry for sound/soc/ti and update the OMAP audio support
  97   85 f2055e145f29 ASoC: ti: Merge davinci and omap directories
 100  100 22cc062c4dfb dt-bindings: sound: omap-mcpdm: Update documentation for pdmclk
 100  100 a3641b30c19b ASoC: davinci-mcasp: Document dismod optional property
 100  100 4647598cde0e ASoC: tlv320aic3x: Add support for CBM_CFS and CBS_CFM clocking modes
 100  100 c9ece9c29e26 ASoC: omap-mcbsp: Skip dma_data.maxburst initialization
 100  100 2c2596f3ab25 ASoC: omap: Remove unused machine driver for AM3517-evm
 100  100 223bc10b8497 ASoC: pcm3168a: remove read-only status register from snd_kcontrol_new
 100  100 e823fb165b76 media: ov5640: Add 60 fps support
 100   92 f6cc192fbf08 media: ov5640: Make the FPS clamping / rounding more extendable
  75  100 5a3ad937bc78 media: ov5640: Make the return rate type more explicit
 100   93 086c25f8fef9 media: ov5640: Enhance FPS handling
 100   33 dfbfb7aa832c media: ov5640: Compute the clock rate at runtime
 100  100 a9e17125a568 media: ov5640: Remove redundant register setup
 100  100 7851fe7ad4d9 media: ov5640: Remove redundant defines
  56  100 c14d107e7417 media: ov5640: Remove the clocks registers initialization
  87  100 aa2882481cad media: ov5640: Adjust the clock based on the expected rate
 100  100 2d18fbc5518f media: ov5640: support log_status ioctl and event interface
  66  100 a98086e00420 mtd: spi-nor: add entry for mt35xu512aba flash
 100  100 0005aad09453 mtd: spi-nor: add macros related to MICRON flash
 100  100 ea6b13e9fed0 drm/bridge/sii902x: Add missing dependency on I2C_MUX
  95  100 21d808405fe4 drm/bridge/sii902x: Fix EDID readback
  33   33 0a7f54ea0e1e drm/omap: fix bus_flags for panel-dpi
 100   94 24ec84e854c6 drm/omap: Move DISPC runtime PM handling to omapdrm
 100  100 350c03e88003 drm/omap: dsi: Ensure the device is active during probe
 100   80 f8523b64d2d2 drm/omap: hdmi4: Ensure the device is active during bind
 100  100 e0c827aca073 drm/omap: Populate DSS children in omapdss driver
 100  100 ab214c48387a dt-bindings: i2c: omap: Add new compatible for AM654 SoCs
 100  100 6f37709fb0a6 pwm: Enable TI ECAP driver for ARCH_K3
 100  100 3c413e7e3922 dt-bindings: pwm: tiecap: Add TI AM654 SoC specific compatible
 100  100 c289d6625237 Revert "pwm: Set class for exported channels in sysfs"
 100  100 d6e7bbc148f9 clk: ti: Add functions to save/restore clk context
  80  100 435365485f40 clk: clk: Add clk_gate_restore_context function
 100  100 8b95d1ce3300 clk: Add functions to save/restore clock context en-masse
 100  100 2f149e6e14bc clk: keystone: Enable TISCI clocks if K3_ARCH
 100  100 ccf45b18ce89 rpmsg: char: Migrate to iter versions of read and write
 100  100 3265230c5b05 remoteproc: add name in rproc_mem_entry struct
 100  100 1bb89893d4fa remoteproc: Add missing kernel-doc comment for auto-boot
 100  100 8abac18fecbd MAINTAINERS: Drop dt-bindings/genpd/k2g.h
 100  100 1b9c30fe01df ARM: OMAP2+: hwmod_core: improve the support for clkctrl clocks
 100  100 e69a35531589 firmware: ti_sci: Provide host-id as an optional dt parameter
 100  100 79a79c3a0ec2 Documentation: dt: keystone: ti-sci: Add optional host-id parameter
 100  100 d59c774496a2 arm64: defconfig: Enable SERIAL_8250_OMAP
 100  100 41925a21cdb5 arm64: defconfig: Enable TI_SCI related configs
  33  100 5c8a6b9db5e9 ARM: dts: am57xx-idk-common: Hook smps12 regulator as cpu vdd-supply
  85  100 42e54f6467ec arm64: dts: ti: k3-am6: Add Device Management Security Controller support
 100  100 77ccbae4f9c8 arm64: dts: ti: am654: Add secure proxy instance for main domain
  92  100 4201af2544b3 arm64: dts: ti: am654: Add uart nodes
  92  100 3bc1572068e3 arm64: dts: ti: k3-am65: Change #address-cells and #size-cells of interconnect to 2
 100  100 0929983e49c8 media: ov5640: fix framerate update
 100  100 b791187b0080 media: ov5640: use JPEG mode 3 for 720p
 100  100 c886751465b8 serial: 8250_omap: Make 8250_omap driver driver depend on ARCH_K3
  93  100 35ba13e43cfb staging: android: ion: Clean unused debug_show memeber of the heap object
 100  100 cfc0f7a8ea80 drivers: mailbox: Make ti-msgmr driver depend on ARCH_K3
 100  100 2e65c7a6a15f drm/omap: fix use of freed memory
 100  100 e64d0229340d drm/omap: Replace drm_gem_object_unreference_unlocked with put function
 100  100 3ce11806c0ba drm/omap: Replace drm_gem_object_{un/reference} with put,get functions
 100  100 e58febe1d99c drm/omap: Substitute format_is_yuv() with format->is_yuv
 100   98 f5b9930b85dc drm/omap: partial workaround for DRA7xx DMM errata i878
  95   95 176c866d4055 drm/omap: dmm_tiler: Fix interrupt request/free sequence during probe/remove
  33  100 157aa884c906 drm/omap: dmm_tiler: No need to check if irq is valid in omap_dmm_remove
 100  100 3a75010cecc9 drm/omap: remove set but not used variable 'frame_height'
 100  100 993d52e2f715 drm/omap: Use ERR_CAST directly instead of ERR_PTR(PTR_ERR())
 100  100 c7d6a0d67646 drm/omap: remove unused header tcm-sita.h
  90   22 6ea484309523 drm/omap: Don't call .set_timings() operation recursively
  28   78 d8dbe7914376 drm/omap: Store CRTC timings in .set_timings() operation
  67   62 96fc64c77537 drm/omap: sdi: Fixup video mode in .check_timings() operation
 100  100 95e472da1094 drm/omap: hdmi: Constify video mode and related pointers
 100  100 7d39e59be51b drm/omap: dsi: Fixup video mode in .set_config() operation
  83  100 f79fa7da6a29 drm/omap: dpi: Don't fixup video mode in dpi_set_mode()
  46   73 7c27fa57ef31 drm/omap: Call dispc timings check operation directly
  90  100 31cd7afa3086 drm/omap: panels: Don't modify fixed timings
 100   97 ca6e968b9326 drm/omap: Remove .get_timings() operation from display connectors
  64   57 28120302c2fd drm/omap: Don't call .check_timings() operation recursively
  28   88 b4935e3a3cfa drm/omap: Store bus flags in the omap_dss_device structure
 100  100 26c91a3898f1 drm/omap: Don't store video mode internally for external encoders
  75   75 138fe53ef8d3 drm/omap: Remove unneeded fallback for missing .check_timings()
 100  100 9c626dee5cdb drm/omap: encoder-tfp410: Don't fix timings in .set_timings() handler
  33  100 ec68cd5a18e1 drm/omap: dss: hdmi: Rename hdmi_display_(set|check)_timing() functions
  70   60 52c5dd2a7bed drm/omap: Determine connector type directly in omap_connector.c
  82   82 70f9cbfc56a3 drm/omap: Get from CRTC to display device directly
  61   81 90279e9518da drm/omap: Don't call EDID read operation recursively
  48   53 f006325cdc80 drm/omap: Move HPD disconnection handling to omap_connector
  87   48 18412b667c96 drm/omap: Merge HPD enable operation with HPD callback registration
  88   25 a21a8f3c93e1 drm/omap: Remove unneeded safety checks in the HPD operations
  41   63 949ea2ef3fed drm/omap: Don't call HPD registration operations recursively
  29   87 f2ea55775e05 drm/omap: Don't call .detect() operation recursively
  53  100 09e5bb6d5b94 drm/omap: dss: Add device operations flags
  50   47 83910ad3f51f drm/omap: Move most omap_dss_driver operations to omap_dss_device_ops
 100   96 e7df6571024b drm/omap: panel-tpo-td043mtea1: Convert to the GPIO descriptors API
 100  100 2167f9e28a30 drm/omap: panel-tpo-td028ttec1: Drop unneeded linux/gpio.h header
 100   96 aec338cbf8c3 drm/omap: panel-sony-acx565akm: Convert to the GPIO descriptors API
 100  100 57e0478a29cf drm/omap: panel-nec-nl8048hl11: Convert to the GPIO descriptors API
  49  100 ac2d1fcbebd6 drm/omap: encoder-tfp410: Convert to the GPIO descriptors API
  78  100 ede880e1825b drm/omap: connector-hdmi: Convert to the GPIO descriptors API
 100  100 6f7ae8c29242 drm/omap: dss: Remove omap_dss_driver .[gs]et_mirror operations
 100  100 e553ea09e268 drm/omap: dss: Remove unused omap_dss_driver operations
  87   34 43f7078f6b6f drm/omap: dss: Remove the dss_mgr_(dis)connect() operations
 100  100 d25a7d67465f drm/omap: Remove supported output check in CRTC connect handler
  83  100 67dfd2d3d0c2 drm/omap: Remove omap_crtc_output global array
  73   53 3be0f15bd6e9 drm/omap: dss: Merge two disconnection helpers
  73  100 79ddb2f0c348 drm/omap: dss: Move connection checks to omapdss_device_(dis)connect
  61   42 511afb44d72a drm/omap: Reverse direction of DSS device (dis)connect operations
  36   50 2ee767922e1b drm/omap: Group CRTC, encoder, connector and dssdev in a structure
  51   82 ac3b13189333 drm/omap: Create all planes before CRTCs
  33  100 f96993630445 drm/omap: Remove unneeded variable assignments in omap_modeset_init
  96   99 8a36357ae3b2 drm/omap: dss: Get regulators at probe time
  23   93 a48bc6ac2c6c drm/omap: dss: Remove duplicated parameter to dss_mgr_(dis)connect()
  94   92 c87193267d24 drm/omap: dss: venc: Move initialization code from bind to probe
  97   95 5f031b471734 drm/omap: dss: hdmi5: Move initialization code from bind to probe
  96   95 5fc15d98a068 drm/omap: dss: hdmi4: Move initialization code from bind to probe
  93   88 edb715dffdee drm/omap: dss: dsi: Move initialization code from bind to probe
  74  100 66aacfe22d53 drm/omap: dss: Cleanup error paths in output init functions
  65   95 4e20bda68e01 drm/omap: dss: Replace omap_dss_device port number with bitmask
  51   86 5c718e015a0f drm/omap: dss: Modify omapdss_find_output_from_display() to return channel
  87  100 845417b3b3b0 drm/omap: dss: Move DSS mgr ops and private data to dss_device
  32   46 c1dfe721e096 drm/omap: dss: Move and rename omap_dss_(get|put)_device()
  87   89 67822ae11971 drm/omap: dss: Remove panel devices list
  55  100 4e0bb06c0b9a drm/omap: dss: Split omapdss_register_display()
  71   98 b9f4d2ebf641 drm/omap: dss: Make omap_dss_get_next_device() more generic
  74   85 de57e9dbc145 drm/omap: dss: Remove output devices list
  79  100 3ce75d67e44c drm/omap: Move DSI debugfs clocks dump to dsi%u_clks files
  71  100 f3ed97f9ae7d drm/omap: dsi: Simplify debugfs implementation
  24   57 7269fde4e8c9 drm/omap: displays: Remove input omap_dss_device from panel data
  69   95 fb5571717c24 drm/omap: dss: Move src and dst check and set to connection handlers
  90  100 1f507968c30b drm/omap: dss: Move debug message and checks to connection handlers
  31  100 b93109d7dc9e drm/omap: dss: Move common device operations to common structure
  56   56 e10bd354ad79 drm/omap: dss: Allow looking up any device by port
  29  100 a7e82a67c1d7 drm/omap: dss: Rework output lookup by port node
  96   96 9184f8d94c38 drm/omap: dss: Create and use omapdss_device_is_registered()
  74  100 6a7c5a2200ad drm/omap: dss: Create global list of all omap_dss_device instances
  66  100 df91128b205d drm/omap: dss: Remove omap_dss_device panel fields
 100  100 d65b0e0530bb drm/omap: displays: Remove videomode from omap_dss_device structure
 100  100 21ebcbac5066 drm/omap: dss: Remove unused omapdss_default_get_timings()
 100  100 9976782f331b drm/omap: dss: Remove DSS encoders get_timings operation
 100  100 52dd898a30e0 drm/omap: dss: Remove omapdss_atv_ops get_wss and set_wss operations
 100  100 8023651bd3d9 drm/omap: dss: Handle DPI and SDI port initialization failures
  90  100 cc1876ce5791 drm/omap: dss: Move platform_device_register from core.c to dss.c probe
 100  100 f13e97cf3e72 drm/omap: dss: Gather OMAP DSS components at probe time
  88   88 36c61ae2b755 drm/omap: dss: Remove display ordering from dss/display.c
  79  100 fb96b67c8ae0 drm/omap: Allocate drm_device earlier and unref it as last step
 100  100 0aeb35ea0e1a drm/dp: add extended receiver capability field present bit
 100  100 09058eab4b4f rtc: omap: Cut down the shutdown time from 2 seconds to 1 sec
 100  100 0438002ac526 rtc: omap: use of_device_is_system_power_controller function
  40  100 c8b427edc737 phy: Add driver for Cadence MHDP DisplayPort SD0801 PHY
 100  100 7effc8ba3e83 dt-bindings: phy: Document Cadence MHDP DisplayPort PHY bindings
  47  100 471a7ba89158 ASoC: pcm3168a: add I2S/Left_J TDM support
  60  100 594680ea4a39 ASoC: pcm3168a: add hw constraint for channel
 100  100 380968898020 ASoC: pcm3168a: add HW constraint for non RIGHT_J
  50  100 642a722d3116 ASoC: omap: use devm_snd_soc_register_component()
 100   90 18d545bb2599 ASoC: tlv320aic31xx: Add overflow detection support
  94  100 80863ee222d3 ASoC: tlv320aic31xx: Add short circuit detection support
  89  100 e77044c5a842 scsi: ufs-bsg: Add support for uic commands in ufs_bsg_request()
  57   92 95e34bf930ea scsi: ufs-bsg: Add support for raw upiu in ufs_bsg_request()
  93  100 5e0a86eed846 scsi: ufs: Add API to execute raw upiu commands
 100  100 220d17a69de4 scsi: ufs: Use data structure size in pointer arithmetic
  89  100 df032bf27a41 scsi: ufs: Add a bsg endpoint that supports UPIUs
 100  100 a851b2bd3632 scsi: uapi: ufs: Make utp_upiu_req visible to user space
 100   80 c6049cd98212 scsi: ufs: add a low-level __ufshcd_issue_tm_cmd helper
  77  100 391e388f853d scsi: ufs: cleanup struct utp_task_req_desc
 100  100 c0b8558648c2 PCI: keystone: Reorder header file in alphabetical order
  93   43 daaaa665ca01 PCI: keystone: Add debug error message for all errors
  38   69 b4f1af8352fd PCI: keystone: Get number of outbound windows from DT
  85   35 8047eb55129a PCI: keystone: Invoke runtime PM APIs to enable clock
  85   98 49229238ab47 PCI: keystone: Cleanup PHY handling
  86  100 b51a625b784a PCI: keystone: Use SYSCON APIs to get device ID from control module
 100  100 03d178386477 dt-bindings: PCI: keystone: Add bindings to get device control module
  43   26 a1cabd2b42fd PCI: keystone: Use uniform function naming convention
 100  100 c81ab8013672 PCI: keystone: Remove redundant platform_set_drvdata() invocation
  43   99 b492aca35c98 PCI: keystone: Merge pci-keystone-dw.c and pci-keystone.c
  25  100 1f79f98f0575 PCI: keystone: Remove unused argument from ks_dw_pcie_host_init()
 100  100 1e10f73e4cb0 PCI: keystone: Move dw_pcie_setup_rc() out of ks_pcie_establish_link()
 100  100 00a2c4094f8e PCI: keystone: Use quirk to set MRRS for PCI host bridge
  33  100 148e340c0696 PCI: keystone: Use quirk to limit MRRS for K2G
 100  100 7a39915b723a Input: ti_am335x_tsc: Mark IRQ as wakeup capable
 100  100 9eea8326f4e6 iio: adc: ti_am335x_adc: Disable ADC during suspend unconditionally
 100  100 c974ac771479 mfd: ti_am335x_tscadc: Keep ADC interface on if child is wakeup capable
 100  100 333e07ec4b33 Input: ti_am335x_tsc: Mark TSC device as wakeup source
 100  100 cec945c293fb mfd: ti_am335x_tscadc: Don't mark TSCADC MFD as wakeup capable
 100  100 9737cc99dd14 net: ethernet: ti: cpsw: unsync mcast entries while switch promisc mode
 100  100 762b9e9abb58 net: ethernet: ti: davinci_emac: simplify getting .driver_data
 100  100 4e13c252276d net: ethernet: ti: cpsw: simplify getting .driver_data
 100  100 5b3a5a14f84c net: ethernet: ti: cpsw: use for mcast entries only host port
 100  100 5da1948969bc net: ethernet: ti: cpsw: fix lost of mcast packets while rx_mode update
 100  100 58bdeac8b0e7 net: ethernet: ti: cpsw_ale: use const for API having pointer on mac address
 100  100 a90546e83a11 net: ti: Use FIELD_SIZEOF directly instead of reimplementing its function
 100   97 89e8b9cb8465 spi: omap2-mcspi: Add slave mode support
  84  100 b682cffa3ac6 spi: omap2-mcspi: Set FIFO DMA trigger level to word length
  76  100 13d515c796ad spi: omap2-mcspi: Switch to readl_poll_timeout()


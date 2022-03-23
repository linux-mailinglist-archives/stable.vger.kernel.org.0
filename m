Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5282F4E4E3E
	for <lists+stable@lfdr.de>; Wed, 23 Mar 2022 09:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242766AbiCWIaa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Mar 2022 04:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242765AbiCWI31 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Mar 2022 04:29:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CD5B75215;
        Wed, 23 Mar 2022 01:27:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9AD7B6146B;
        Wed, 23 Mar 2022 08:27:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE7FC340E8;
        Wed, 23 Mar 2022 08:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648024073;
        bh=/MQ9YegcyblW36aBRj9NTs6qxpQr6VMQz5mvUjx8AGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lWEoH1NLJIs4oGKlcNyBFhFzuv3eYaH2xSRb+PxEt9EnL+3a1MhKXR0egfw60oHUN
         ZvqxKk15EJHovlyfFa8JP17Yr594ScM0WS77MJUnuFR10NPUTdpibJn0XIAQ+zE1Fs
         DM8owSCXMS8ldz27VPsuuPa8x1F9hAyG+cvxpLz0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.16.17
Date:   Wed, 23 Mar 2022 09:27:39 +0100
Message-Id: <1648024059210188@kroah.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <1648024059176135@kroah.com>
References: <1648024059176135@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index d625d3aeab2e..0ca39c16b3bf 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 16
-SUBLEVEL = 16
+SUBLEVEL = 17
 EXTRAVERSION =
 NAME = Gobble Gobble
 
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi
index f891ef6a3754..605072317243 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1088a.dtsi
@@ -241,18 +241,18 @@ extirq: interrupt-controller@14 {
 				interrupt-controller;
 				reg = <0x14 4>;
 				interrupt-map =
-					<0 0 &gic 0 0 GIC_SPI 0 IRQ_TYPE_LEVEL_HIGH>,
-					<1 0 &gic 0 0 GIC_SPI 1 IRQ_TYPE_LEVEL_HIGH>,
-					<2 0 &gic 0 0 GIC_SPI 2 IRQ_TYPE_LEVEL_HIGH>,
-					<3 0 &gic 0 0 GIC_SPI 3 IRQ_TYPE_LEVEL_HIGH>,
-					<4 0 &gic 0 0 GIC_SPI 4 IRQ_TYPE_LEVEL_HIGH>,
-					<5 0 &gic 0 0 GIC_SPI 5 IRQ_TYPE_LEVEL_HIGH>,
-					<6 0 &gic 0 0 GIC_SPI 6 IRQ_TYPE_LEVEL_HIGH>,
-					<7 0 &gic 0 0 GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>,
-					<8 0 &gic 0 0 GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>,
-					<9 0 &gic 0 0 GIC_SPI 9 IRQ_TYPE_LEVEL_HIGH>,
-					<10 0 &gic 0 0 GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>,
-					<11 0 &gic 0 0 GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>;
+					<0 0 &gic GIC_SPI 0 IRQ_TYPE_LEVEL_HIGH>,
+					<1 0 &gic GIC_SPI 1 IRQ_TYPE_LEVEL_HIGH>,
+					<2 0 &gic GIC_SPI 2 IRQ_TYPE_LEVEL_HIGH>,
+					<3 0 &gic GIC_SPI 3 IRQ_TYPE_LEVEL_HIGH>,
+					<4 0 &gic GIC_SPI 4 IRQ_TYPE_LEVEL_HIGH>,
+					<5 0 &gic GIC_SPI 5 IRQ_TYPE_LEVEL_HIGH>,
+					<6 0 &gic GIC_SPI 6 IRQ_TYPE_LEVEL_HIGH>,
+					<7 0 &gic GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>,
+					<8 0 &gic GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>,
+					<9 0 &gic GIC_SPI 9 IRQ_TYPE_LEVEL_HIGH>,
+					<10 0 &gic GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>,
+					<11 0 &gic GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>;
 				interrupt-map-mask = <0xffffffff 0x0>;
 			};
 		};
diff --git a/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi
index 3cb9c21d2775..1282b61da8a5 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls208xa.dtsi
@@ -293,18 +293,18 @@ extirq: interrupt-controller@14 {
 				interrupt-controller;
 				reg = <0x14 4>;
 				interrupt-map =
-					<0 0 &gic 0 0 GIC_SPI 0 IRQ_TYPE_LEVEL_HIGH>,
-					<1 0 &gic 0 0 GIC_SPI 1 IRQ_TYPE_LEVEL_HIGH>,
-					<2 0 &gic 0 0 GIC_SPI 2 IRQ_TYPE_LEVEL_HIGH>,
-					<3 0 &gic 0 0 GIC_SPI 3 IRQ_TYPE_LEVEL_HIGH>,
-					<4 0 &gic 0 0 GIC_SPI 4 IRQ_TYPE_LEVEL_HIGH>,
-					<5 0 &gic 0 0 GIC_SPI 5 IRQ_TYPE_LEVEL_HIGH>,
-					<6 0 &gic 0 0 GIC_SPI 6 IRQ_TYPE_LEVEL_HIGH>,
-					<7 0 &gic 0 0 GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>,
-					<8 0 &gic 0 0 GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>,
-					<9 0 &gic 0 0 GIC_SPI 9 IRQ_TYPE_LEVEL_HIGH>,
-					<10 0 &gic 0 0 GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>,
-					<11 0 &gic 0 0 GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>;
+					<0 0 &gic GIC_SPI 0 IRQ_TYPE_LEVEL_HIGH>,
+					<1 0 &gic GIC_SPI 1 IRQ_TYPE_LEVEL_HIGH>,
+					<2 0 &gic GIC_SPI 2 IRQ_TYPE_LEVEL_HIGH>,
+					<3 0 &gic GIC_SPI 3 IRQ_TYPE_LEVEL_HIGH>,
+					<4 0 &gic GIC_SPI 4 IRQ_TYPE_LEVEL_HIGH>,
+					<5 0 &gic GIC_SPI 5 IRQ_TYPE_LEVEL_HIGH>,
+					<6 0 &gic GIC_SPI 6 IRQ_TYPE_LEVEL_HIGH>,
+					<7 0 &gic GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>,
+					<8 0 &gic GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>,
+					<9 0 &gic GIC_SPI 9 IRQ_TYPE_LEVEL_HIGH>,
+					<10 0 &gic GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>,
+					<11 0 &gic GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>;
 				interrupt-map-mask = <0xffffffff 0x0>;
 			};
 		};
diff --git a/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi b/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
index 2433e6f2eda8..51c4f61007cd 100644
--- a/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
@@ -680,18 +680,18 @@ extirq: interrupt-controller@14 {
 				interrupt-controller;
 				reg = <0x14 4>;
 				interrupt-map =
-					<0 0 &gic 0 0 GIC_SPI 0 IRQ_TYPE_LEVEL_HIGH>,
-					<1 0 &gic 0 0 GIC_SPI 1 IRQ_TYPE_LEVEL_HIGH>,
-					<2 0 &gic 0 0 GIC_SPI 2 IRQ_TYPE_LEVEL_HIGH>,
-					<3 0 &gic 0 0 GIC_SPI 3 IRQ_TYPE_LEVEL_HIGH>,
-					<4 0 &gic 0 0 GIC_SPI 4 IRQ_TYPE_LEVEL_HIGH>,
-					<5 0 &gic 0 0 GIC_SPI 5 IRQ_TYPE_LEVEL_HIGH>,
-					<6 0 &gic 0 0 GIC_SPI 6 IRQ_TYPE_LEVEL_HIGH>,
-					<7 0 &gic 0 0 GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>,
-					<8 0 &gic 0 0 GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>,
-					<9 0 &gic 0 0 GIC_SPI 9 IRQ_TYPE_LEVEL_HIGH>,
-					<10 0 &gic 0 0 GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>,
-					<11 0 &gic 0 0 GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>;
+					<0 0 &gic GIC_SPI 0 IRQ_TYPE_LEVEL_HIGH>,
+					<1 0 &gic GIC_SPI 1 IRQ_TYPE_LEVEL_HIGH>,
+					<2 0 &gic GIC_SPI 2 IRQ_TYPE_LEVEL_HIGH>,
+					<3 0 &gic GIC_SPI 3 IRQ_TYPE_LEVEL_HIGH>,
+					<4 0 &gic GIC_SPI 4 IRQ_TYPE_LEVEL_HIGH>,
+					<5 0 &gic GIC_SPI 5 IRQ_TYPE_LEVEL_HIGH>,
+					<6 0 &gic GIC_SPI 6 IRQ_TYPE_LEVEL_HIGH>,
+					<7 0 &gic GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>,
+					<8 0 &gic GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>,
+					<9 0 &gic GIC_SPI 9 IRQ_TYPE_LEVEL_HIGH>,
+					<10 0 &gic GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>,
+					<11 0 &gic GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>;
 				interrupt-map-mask = <0xffffffff 0x0>;
 			};
 		};
diff --git a/arch/arm64/include/asm/vectors.h b/arch/arm64/include/asm/vectors.h
index f64613a96d53..bc9a2145f419 100644
--- a/arch/arm64/include/asm/vectors.h
+++ b/arch/arm64/include/asm/vectors.h
@@ -56,14 +56,14 @@ enum arm64_bp_harden_el1_vectors {
 DECLARE_PER_CPU_READ_MOSTLY(const char *, this_cpu_vector);
 
 #ifndef CONFIG_UNMAP_KERNEL_AT_EL0
-#define TRAMP_VALIAS	0
+#define TRAMP_VALIAS	0ul
 #endif
 
 static inline const char *
 arm64_get_bp_hardening_vector(enum arm64_bp_harden_el1_vectors slot)
 {
 	if (arm64_kernel_unmapped_at_el0())
-		return (char *)TRAMP_VALIAS + SZ_2K * slot;
+		return (char *)(TRAMP_VALIAS + SZ_2K * slot);
 
 	WARN_ON_ONCE(slot == EL1_VECTOR_KPTI);
 
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index a401180e8d66..146fa2e76834 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -611,7 +611,6 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 	{
 		.desc = "ARM erratum 2077057",
 		.capability = ARM64_WORKAROUND_2077057,
-		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
 		ERRATA_MIDR_REV_RANGE(MIDR_CORTEX_A510, 0, 0, 2),
 	},
 #endif
diff --git a/block/blk-core.c b/block/blk-core.c
index 5adca3a9cebe..94a551e7eed7 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -51,6 +51,7 @@
 #include "blk-mq-sched.h"
 #include "blk-pm.h"
 #include "blk-throttle.h"
+#include "blk-rq-qos.h"
 
 struct dentry *blk_debugfs_root;
 
@@ -354,6 +355,9 @@ void blk_cleanup_queue(struct request_queue *q)
 	 */
 	blk_freeze_queue(q);
 
+	/* cleanup rq qos structures for queue without disk */
+	rq_qos_exit(q);
+
 	blk_queue_flag_set(QUEUE_FLAG_DEAD, q);
 
 	blk_sync_queue(q);
diff --git a/drivers/atm/eni.c b/drivers/atm/eni.c
index 422753d52244..a31ffe16e626 100644
--- a/drivers/atm/eni.c
+++ b/drivers/atm/eni.c
@@ -1112,6 +1112,8 @@ DPRINTK("iovcnt = %d\n",skb_shinfo(skb)->nr_frags);
 	skb_data3 = skb->data[3];
 	paddr = dma_map_single(&eni_dev->pci_dev->dev,skb->data,skb->len,
 			       DMA_TO_DEVICE);
+	if (dma_mapping_error(&eni_dev->pci_dev->dev, paddr))
+		return enq_next;
 	ENI_PRV_PADDR(skb) = paddr;
 	/* prepare DMA queue entries */
 	j = 0;
diff --git a/drivers/crypto/qcom-rng.c b/drivers/crypto/qcom-rng.c
index 99ba8d51d102..11f30fd48c14 100644
--- a/drivers/crypto/qcom-rng.c
+++ b/drivers/crypto/qcom-rng.c
@@ -8,6 +8,7 @@
 #include <linux/clk.h>
 #include <linux/crypto.h>
 #include <linux/io.h>
+#include <linux/iopoll.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
@@ -43,16 +44,19 @@ static int qcom_rng_read(struct qcom_rng *rng, u8 *data, unsigned int max)
 {
 	unsigned int currsize = 0;
 	u32 val;
+	int ret;
 
 	/* read random data from hardware */
 	do {
-		val = readl_relaxed(rng->base + PRNG_STATUS);
-		if (!(val & PRNG_STATUS_DATA_AVAIL))
-			break;
+		ret = readl_poll_timeout(rng->base + PRNG_STATUS, val,
+					 val & PRNG_STATUS_DATA_AVAIL,
+					 200, 10000);
+		if (ret)
+			return ret;
 
 		val = readl_relaxed(rng->base + PRNG_DATA_OUT);
 		if (!val)
-			break;
+			return -EINVAL;
 
 		if ((max - currsize) >= WORD_SZ) {
 			memcpy(data, &val, WORD_SZ);
@@ -61,11 +65,10 @@ static int qcom_rng_read(struct qcom_rng *rng, u8 *data, unsigned int max)
 		} else {
 			/* copy only remaining bytes */
 			memcpy(data, &val, max - currsize);
-			break;
 		}
 	} while (currsize < max);
 
-	return currsize;
+	return 0;
 }
 
 static int qcom_rng_generate(struct crypto_rng *tfm,
@@ -87,7 +90,7 @@ static int qcom_rng_generate(struct crypto_rng *tfm,
 	mutex_unlock(&rng->lock);
 	clk_disable_unprepare(rng->clk);
 
-	return 0;
+	return ret;
 }
 
 static int qcom_rng_seed(struct crypto_rng *tfm, const u8 *seed,
diff --git a/drivers/firmware/efi/apple-properties.c b/drivers/firmware/efi/apple-properties.c
index 4c3201e290e2..ea84108035eb 100644
--- a/drivers/firmware/efi/apple-properties.c
+++ b/drivers/firmware/efi/apple-properties.c
@@ -24,7 +24,7 @@ static bool dump_properties __initdata;
 static int __init dump_properties_enable(char *arg)
 {
 	dump_properties = true;
-	return 0;
+	return 1;
 }
 
 __setup("dump_apple_properties", dump_properties_enable);
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 7de3f5b6e8d0..5502e176d51b 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -212,7 +212,7 @@ static int __init efivar_ssdt_setup(char *str)
 		memcpy(efivar_ssdt, str, strlen(str));
 	else
 		pr_warn("efivar_ssdt: name too long: %s\n", str);
-	return 0;
+	return 1;
 }
 __setup("efivar_ssdt=", efivar_ssdt_setup);
 
diff --git a/drivers/gpu/drm/bridge/Kconfig b/drivers/gpu/drm/bridge/Kconfig
index 431b6e12a81f..68ec45abc1fb 100644
--- a/drivers/gpu/drm/bridge/Kconfig
+++ b/drivers/gpu/drm/bridge/Kconfig
@@ -8,7 +8,6 @@ config DRM_BRIDGE
 config DRM_PANEL_BRIDGE
 	def_bool y
 	depends on DRM_BRIDGE
-	depends on DRM_KMS_HELPER
 	select DRM_PANEL
 	help
 	  DRM bridge wrapper of DRM panels
@@ -30,6 +29,7 @@ config DRM_CDNS_DSI
 config DRM_CHIPONE_ICN6211
 	tristate "Chipone ICN6211 MIPI-DSI/RGB Converter bridge"
 	depends on OF
+	select DRM_KMS_HELPER
 	select DRM_MIPI_DSI
 	select DRM_PANEL_BRIDGE
 	help
diff --git a/drivers/gpu/drm/imx/parallel-display.c b/drivers/gpu/drm/imx/parallel-display.c
index a8aba0141ce7..06cb1a59b9bc 100644
--- a/drivers/gpu/drm/imx/parallel-display.c
+++ b/drivers/gpu/drm/imx/parallel-display.c
@@ -217,14 +217,6 @@ static int imx_pd_bridge_atomic_check(struct drm_bridge *bridge,
 	if (!imx_pd_format_supported(bus_fmt))
 		return -EINVAL;
 
-	if (bus_flags &
-	    ~(DRM_BUS_FLAG_DE_LOW | DRM_BUS_FLAG_DE_HIGH |
-	      DRM_BUS_FLAG_PIXDATA_DRIVE_POSEDGE |
-	      DRM_BUS_FLAG_PIXDATA_DRIVE_NEGEDGE)) {
-		dev_warn(imxpd->dev, "invalid bus_flags (%x)\n", bus_flags);
-		return -EINVAL;
-	}
-
 	bridge_state->output_bus_cfg.flags = bus_flags;
 	bridge_state->input_bus_cfg.flags = bus_flags;
 	imx_crtc_state->bus_flags = bus_flags;
diff --git a/drivers/gpu/drm/mgag200/mgag200_pll.c b/drivers/gpu/drm/mgag200/mgag200_pll.c
index e9ae22b4f813..52be08b744ad 100644
--- a/drivers/gpu/drm/mgag200/mgag200_pll.c
+++ b/drivers/gpu/drm/mgag200/mgag200_pll.c
@@ -404,9 +404,9 @@ mgag200_pixpll_update_g200wb(struct mgag200_pll *pixpll, const struct mgag200_pl
 		udelay(50);
 
 		/* program pixel pll register */
-		WREG_DAC(MGA1064_PIX_PLLC_N, xpixpllcn);
-		WREG_DAC(MGA1064_PIX_PLLC_M, xpixpllcm);
-		WREG_DAC(MGA1064_PIX_PLLC_P, xpixpllcp);
+		WREG_DAC(MGA1064_WB_PIX_PLLC_N, xpixpllcn);
+		WREG_DAC(MGA1064_WB_PIX_PLLC_M, xpixpllcm);
+		WREG_DAC(MGA1064_WB_PIX_PLLC_P, xpixpllcp);
 
 		udelay(50);
 
diff --git a/drivers/gpu/drm/panel/Kconfig b/drivers/gpu/drm/panel/Kconfig
index 0d3798354e6a..42011d884202 100644
--- a/drivers/gpu/drm/panel/Kconfig
+++ b/drivers/gpu/drm/panel/Kconfig
@@ -96,6 +96,7 @@ config DRM_PANEL_EDP
 	select VIDEOMODE_HELPERS
 	select DRM_DP_AUX_BUS
 	select DRM_DP_HELPER
+	select DRM_KMS_HELPER
 	help
 	  DRM panel driver for dumb eDP panels that need at most a regulator and
 	  a GPIO to be powered up. Optionally a backlight can be attached so
diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index 87f30bced7b7..6a820b698f5a 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -2017,7 +2017,7 @@ static const struct display_timing innolux_g070y2_l01_timing = {
 static const struct panel_desc innolux_g070y2_l01 = {
 	.timings = &innolux_g070y2_l01_timing,
 	.num_timings = 1,
-	.bpc = 6,
+	.bpc = 8,
 	.size = {
 		.width = 152,
 		.height = 91,
diff --git a/drivers/input/tablet/aiptek.c b/drivers/input/tablet/aiptek.c
index fcb1b646436a..1581f6ef0927 100644
--- a/drivers/input/tablet/aiptek.c
+++ b/drivers/input/tablet/aiptek.c
@@ -1787,15 +1787,13 @@ aiptek_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	input_set_abs_params(inputdev, ABS_TILT_Y, AIPTEK_TILT_MIN, AIPTEK_TILT_MAX, 0, 0);
 	input_set_abs_params(inputdev, ABS_WHEEL, AIPTEK_WHEEL_MIN, AIPTEK_WHEEL_MAX - 1, 0, 0);
 
-	/* Verify that a device really has an endpoint */
-	if (intf->cur_altsetting->desc.bNumEndpoints < 1) {
+	err = usb_find_common_endpoints(intf->cur_altsetting,
+					NULL, NULL, &endpoint, NULL);
+	if (err) {
 		dev_err(&intf->dev,
-			"interface has %d endpoints, but must have minimum 1\n",
-			intf->cur_altsetting->desc.bNumEndpoints);
-		err = -EINVAL;
+			"interface has no int in endpoints, but must have minimum 1\n");
 		goto fail3;
 	}
-	endpoint = &intf->cur_altsetting->endpoint[0].desc;
 
 	/* Go set up our URB, which is called when the tablet receives
 	 * input.
diff --git a/drivers/net/ethernet/atheros/alx/main.c b/drivers/net/ethernet/atheros/alx/main.c
index 4ad3fc72e74e..a89b93cb4e26 100644
--- a/drivers/net/ethernet/atheros/alx/main.c
+++ b/drivers/net/ethernet/atheros/alx/main.c
@@ -1181,8 +1181,11 @@ static int alx_change_mtu(struct net_device *netdev, int mtu)
 	alx->hw.mtu = mtu;
 	alx->rxbuf_size = max(max_frame, ALX_DEF_RXBUF_SIZE);
 	netdev_update_features(netdev);
-	if (netif_running(netdev))
+	if (netif_running(netdev)) {
+		mutex_lock(&alx->mtx);
 		alx_reinit(alx);
+		mutex_unlock(&alx->mtx);
+	}
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
index a19dd6797070..2209d99b3404 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
@@ -2533,6 +2533,4 @@ void bnx2x_register_phc(struct bnx2x *bp);
  * Meant for implicit re-load flows.
  */
 int bnx2x_vlan_reconfigure_vid(struct bnx2x *bp);
-int bnx2x_init_firmware(struct bnx2x *bp);
-void bnx2x_release_firmware(struct bnx2x *bp);
 #endif /* bnx2x.h */
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index e57fe0034ce2..b1ad62774897 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -2363,24 +2363,30 @@ int bnx2x_compare_fw_ver(struct bnx2x *bp, u32 load_code, bool print_err)
 	/* is another pf loaded on this engine? */
 	if (load_code != FW_MSG_CODE_DRV_LOAD_COMMON_CHIP &&
 	    load_code != FW_MSG_CODE_DRV_LOAD_COMMON) {
-		/* build my FW version dword */
-		u32 my_fw = (bp->fw_major) + (bp->fw_minor << 8) +
-				(bp->fw_rev << 16) + (bp->fw_eng << 24);
+		u8 loaded_fw_major, loaded_fw_minor, loaded_fw_rev, loaded_fw_eng;
+		u32 loaded_fw;
 
 		/* read loaded FW from chip */
-		u32 loaded_fw = REG_RD(bp, XSEM_REG_PRAM);
+		loaded_fw = REG_RD(bp, XSEM_REG_PRAM);
 
-		DP(BNX2X_MSG_SP, "loaded fw %x, my fw %x\n",
-		   loaded_fw, my_fw);
+		loaded_fw_major = loaded_fw & 0xff;
+		loaded_fw_minor = (loaded_fw >> 8) & 0xff;
+		loaded_fw_rev = (loaded_fw >> 16) & 0xff;
+		loaded_fw_eng = (loaded_fw >> 24) & 0xff;
+
+		DP(BNX2X_MSG_SP, "loaded fw 0x%x major 0x%x minor 0x%x rev 0x%x eng 0x%x\n",
+		   loaded_fw, loaded_fw_major, loaded_fw_minor, loaded_fw_rev, loaded_fw_eng);
 
 		/* abort nic load if version mismatch */
-		if (my_fw != loaded_fw) {
+		if (loaded_fw_major != BCM_5710_FW_MAJOR_VERSION ||
+		    loaded_fw_minor != BCM_5710_FW_MINOR_VERSION ||
+		    loaded_fw_eng != BCM_5710_FW_ENGINEERING_VERSION ||
+		    loaded_fw_rev < BCM_5710_FW_REVISION_VERSION_V15) {
 			if (print_err)
-				BNX2X_ERR("bnx2x with FW %x was already loaded which mismatches my %x FW. Aborting\n",
-					  loaded_fw, my_fw);
+				BNX2X_ERR("loaded FW incompatible. Aborting\n");
 			else
-				BNX2X_DEV_INFO("bnx2x with FW %x was already loaded which mismatches my %x FW, possibly due to MF UNDI\n",
-					       loaded_fw, my_fw);
+				BNX2X_DEV_INFO("loaded FW incompatible, possibly due to MF UNDI\n");
+
 			return -EBUSY;
 		}
 	}
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index 4ce596daeaae..569004c961d4 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -12319,15 +12319,6 @@ static int bnx2x_init_bp(struct bnx2x *bp)
 
 	bnx2x_read_fwinfo(bp);
 
-	if (IS_PF(bp)) {
-		rc = bnx2x_init_firmware(bp);
-
-		if (rc) {
-			bnx2x_free_mem_bp(bp);
-			return rc;
-		}
-	}
-
 	func = BP_FUNC(bp);
 
 	/* need to reset chip if undi was active */
@@ -12340,7 +12331,6 @@ static int bnx2x_init_bp(struct bnx2x *bp)
 
 		rc = bnx2x_prev_unload(bp);
 		if (rc) {
-			bnx2x_release_firmware(bp);
 			bnx2x_free_mem_bp(bp);
 			return rc;
 		}
@@ -13420,7 +13410,7 @@ do {									\
 	     (u8 *)bp->arr, len);					\
 } while (0)
 
-int bnx2x_init_firmware(struct bnx2x *bp)
+static int bnx2x_init_firmware(struct bnx2x *bp)
 {
 	const char *fw_file_name, *fw_file_name_v15;
 	struct bnx2x_fw_file_hdr *fw_hdr;
@@ -13520,7 +13510,7 @@ int bnx2x_init_firmware(struct bnx2x *bp)
 	return rc;
 }
 
-void bnx2x_release_firmware(struct bnx2x *bp)
+static void bnx2x_release_firmware(struct bnx2x *bp)
 {
 	kfree(bp->init_ops_offsets);
 	kfree(bp->init_ops);
@@ -14037,7 +14027,6 @@ static int bnx2x_init_one(struct pci_dev *pdev,
 	return 0;
 
 init_one_freemem:
-	bnx2x_release_firmware(bp);
 	bnx2x_free_mem_bp(bp);
 
 init_one_exit:
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 87f1056e29ff..2da804f84b48 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -2287,8 +2287,10 @@ static unsigned int bcmgenet_desc_rx(struct bcmgenet_rx_ring *ring,
 		dma_length_status = status->length_status;
 		if (dev->features & NETIF_F_RXCSUM) {
 			rx_csum = (__force __be16)(status->rx_csum & 0xffff);
-			skb->csum = (__force __wsum)ntohs(rx_csum);
-			skb->ip_summed = CHECKSUM_COMPLETE;
+			if (rx_csum) {
+				skb->csum = (__force __wsum)ntohs(rx_csum);
+				skb->ip_summed = CHECKSUM_COMPLETE;
+			}
 		}
 
 		/* DMA flags and length are still valid no matter how
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 138db07bdfa8..42e6675078cd 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2133,6 +2133,13 @@ static void iavf_watchdog_task(struct work_struct *work)
 		queue_delayed_work(iavf_wq, &adapter->watchdog_task, HZ * 2);
 }
 
+/**
+ * iavf_disable_vf - disable VF
+ * @adapter: board private structure
+ *
+ * Set communication failed flag and free all resources.
+ * NOTE: This function is expected to be called with crit_lock being held.
+ **/
 static void iavf_disable_vf(struct iavf_adapter *adapter)
 {
 	struct iavf_mac_filter *f, *ftmp;
@@ -2187,7 +2194,6 @@ static void iavf_disable_vf(struct iavf_adapter *adapter)
 	memset(adapter->vf_res, 0, IAVF_VIRTCHNL_VF_RESOURCE_SIZE);
 	iavf_shutdown_adminq(&adapter->hw);
 	adapter->netdev->flags &= ~IFF_UP;
-	mutex_unlock(&adapter->crit_lock);
 	adapter->flags &= ~IAVF_FLAG_RESET_PENDING;
 	iavf_change_state(adapter, __IAVF_DOWN);
 	wake_up(&adapter->down_waitqueue);
@@ -4022,6 +4028,13 @@ static void iavf_remove(struct pci_dev *pdev)
 	struct iavf_hw *hw = &adapter->hw;
 	int err;
 
+	/* When reboot/shutdown is in progress no need to do anything
+	 * as the adapter is already REMOVE state that was set during
+	 * iavf_shutdown() callback.
+	 */
+	if (adapter->state == __IAVF_REMOVE)
+		return;
+
 	set_bit(__IAVF_IN_REMOVE_TASK, &adapter->crit_section);
 	/* Wait until port initialization is complete.
 	 * There are flows where register/unregister netdev may race.
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 8a6c3716cdab..b449b3408a1c 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5972,8 +5972,9 @@ ice_update_vsi_tx_ring_stats(struct ice_vsi *vsi,
 		u64 pkts = 0, bytes = 0;
 
 		ring = READ_ONCE(rings[i]);
-		if (ring)
-			ice_fetch_u64_stats_per_ring(&ring->syncp, ring->stats, &pkts, &bytes);
+		if (!ring)
+			continue;
+		ice_fetch_u64_stats_per_ring(&ring->syncp, ring->stats, &pkts, &bytes);
 		vsi_stats->tx_packets += pkts;
 		vsi_stats->tx_bytes += bytes;
 		vsi->tx_restart += ring->tx_stats.restart_q;
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 738dd2be79dc..a3f1f1fbaf7d 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -54,6 +54,12 @@ static int ocelot_chain_to_block(int chain, bool ingress)
  */
 static int ocelot_chain_to_lookup(int chain)
 {
+	/* Backwards compatibility with older, single-chain tc-flower
+	 * offload support in Ocelot
+	 */
+	if (chain == 0)
+		return 0;
+
 	return (chain / VCAP_LOOKUP) % 10;
 }
 
@@ -62,7 +68,15 @@ static int ocelot_chain_to_lookup(int chain)
  */
 static int ocelot_chain_to_pag(int chain)
 {
-	int lookup = ocelot_chain_to_lookup(chain);
+	int lookup;
+
+	/* Backwards compatibility with older, single-chain tc-flower
+	 * offload support in Ocelot
+	 */
+	if (chain == 0)
+		return 0;
+
+	lookup = ocelot_chain_to_lookup(chain);
 
 	/* calculate PAG value as chain index relative to the first PAG */
 	return chain - VCAP_IS2_CHAIN(lookup, 0);
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 7e66ae1d2a59..7117187dfbd7 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -1587,6 +1587,9 @@ static void netvsc_get_ethtool_stats(struct net_device *dev,
 	pcpu_sum = kvmalloc_array(num_possible_cpus(),
 				  sizeof(struct netvsc_ethtool_pcpu_stats),
 				  GFP_KERNEL);
+	if (!pcpu_sum)
+		return;
+
 	netvsc_get_pcpu_stats(dev, pcpu_sum);
 	for_each_present_cpu(cpu) {
 		struct netvsc_ethtool_pcpu_stats *this_sum = &pcpu_sum[cpu];
diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index cfda625dbea5..4d726ee03ce2 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -1693,8 +1693,8 @@ static int marvell_suspend(struct phy_device *phydev)
 	int err;
 
 	/* Suspend the fiber mode first */
-	if (!linkmode_test_bit(ETHTOOL_LINK_MODE_FIBRE_BIT,
-			       phydev->supported)) {
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_FIBRE_BIT,
+			      phydev->supported)) {
 		err = marvell_set_page(phydev, MII_MARVELL_FIBER_PAGE);
 		if (err < 0)
 			goto error;
@@ -1728,8 +1728,8 @@ static int marvell_resume(struct phy_device *phydev)
 	int err;
 
 	/* Resume the fiber mode first */
-	if (!linkmode_test_bit(ETHTOOL_LINK_MODE_FIBRE_BIT,
-			       phydev->supported)) {
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_FIBRE_BIT,
+			      phydev->supported)) {
 		err = marvell_set_page(phydev, MII_MARVELL_FIBER_PAGE);
 		if (err < 0)
 			goto error;
diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index ebfeeb3c67c1..7e3017e7a1c0 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -2685,3 +2685,6 @@ MODULE_DEVICE_TABLE(mdio, vsc85xx_tbl);
 MODULE_DESCRIPTION("Microsemi VSC85xx PHY driver");
 MODULE_AUTHOR("Nagaraju Lakkaraju");
 MODULE_LICENSE("Dual MIT/GPL");
+
+MODULE_FIRMWARE(MSCC_VSC8584_REVB_INT8051_FW);
+MODULE_FIRMWARE(MSCC_VSC8574_REVB_INT8051_FW);
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 4733fd7fb169..7c1c2658cb5f 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2611,30 +2611,9 @@ int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
 		ath10k_mac_handle_beacon(ar, skb);
 
 	if (ieee80211_is_beacon(hdr->frame_control) ||
-	    ieee80211_is_probe_resp(hdr->frame_control)) {
-		struct ieee80211_mgmt *mgmt = (void *)skb->data;
-		u8 *ies;
-		int ies_ch;
-
+	    ieee80211_is_probe_resp(hdr->frame_control))
 		status->boottime_ns = ktime_get_boottime_ns();
 
-		if (!ar->scan_channel)
-			goto drop;
-
-		ies = mgmt->u.beacon.variable;
-
-		ies_ch = cfg80211_get_ies_channel_number(mgmt->u.beacon.variable,
-							 skb_tail_pointer(skb) - ies,
-							 sband->band);
-
-		if (ies_ch > 0 && ies_ch != channel) {
-			ath10k_dbg(ar, ATH10K_DBG_MGMT,
-				   "channel mismatched ds channel %d scan channel %d\n",
-				   ies_ch, channel);
-			goto drop;
-		}
-	}
-
 	ath10k_dbg(ar, ATH10K_DBG_MGMT,
 		   "event mgmt rx skb %pK len %d ftype %02x stype %02x\n",
 		   skb, skb->len,
@@ -2648,10 +2627,6 @@ int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
 	ieee80211_rx_ni(ar->hw, skb);
 
 	return 0;
-
-drop:
-	dev_kfree_skb(skb);
-	return 0;
 }
 
 static int freq_to_idx(struct ath10k *ar, int freq)
diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/configfs.c
index 091a0ca16361..496d775c6770 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -1233,44 +1233,6 @@ static ssize_t nvmet_subsys_attr_model_store(struct config_item *item,
 }
 CONFIGFS_ATTR(nvmet_subsys_, attr_model);
 
-static ssize_t nvmet_subsys_attr_discovery_nqn_show(struct config_item *item,
-			char *page)
-{
-	return snprintf(page, PAGE_SIZE, "%s\n",
-			nvmet_disc_subsys->subsysnqn);
-}
-
-static ssize_t nvmet_subsys_attr_discovery_nqn_store(struct config_item *item,
-			const char *page, size_t count)
-{
-	struct nvmet_subsys *subsys = to_subsys(item);
-	char *subsysnqn;
-	int len;
-
-	len = strcspn(page, "\n");
-	if (!len)
-		return -EINVAL;
-
-	subsysnqn = kmemdup_nul(page, len, GFP_KERNEL);
-	if (!subsysnqn)
-		return -ENOMEM;
-
-	/*
-	 * The discovery NQN must be different from subsystem NQN.
-	 */
-	if (!strcmp(subsysnqn, subsys->subsysnqn)) {
-		kfree(subsysnqn);
-		return -EBUSY;
-	}
-	down_write(&nvmet_config_sem);
-	kfree(nvmet_disc_subsys->subsysnqn);
-	nvmet_disc_subsys->subsysnqn = subsysnqn;
-	up_write(&nvmet_config_sem);
-
-	return count;
-}
-CONFIGFS_ATTR(nvmet_subsys_, attr_discovery_nqn);
-
 #ifdef CONFIG_BLK_DEV_INTEGRITY
 static ssize_t nvmet_subsys_attr_pi_enable_show(struct config_item *item,
 						char *page)
@@ -1300,7 +1262,6 @@ static struct configfs_attribute *nvmet_subsys_attrs[] = {
 	&nvmet_subsys_attr_attr_cntlid_min,
 	&nvmet_subsys_attr_attr_cntlid_max,
 	&nvmet_subsys_attr_attr_model,
-	&nvmet_subsys_attr_attr_discovery_nqn,
 #ifdef CONFIG_BLK_DEV_INTEGRITY
 	&nvmet_subsys_attr_attr_pi_enable,
 #endif
diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 5119c687de68..626caf6f1e4b 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -1493,8 +1493,7 @@ static struct nvmet_subsys *nvmet_find_get_subsys(struct nvmet_port *port,
 	if (!port)
 		return NULL;
 
-	if (!strcmp(NVME_DISC_SUBSYS_NAME, subsysnqn) ||
-	    !strcmp(nvmet_disc_subsys->subsysnqn, subsysnqn)) {
+	if (!strcmp(NVME_DISC_SUBSYS_NAME, subsysnqn)) {
 		if (!kref_get_unless_zero(&nvmet_disc_subsys->ref))
 			return NULL;
 		return nvmet_disc_subsys;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 81dab9b82f79..0d37c4aca175 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2011,9 +2011,10 @@ mpt3sas_base_sync_reply_irqs(struct MPT3SAS_ADAPTER *ioc, u8 poll)
 				enable_irq(reply_q->os_irq);
 			}
 		}
+
+		if (poll)
+			_base_process_reply_queue(reply_q);
 	}
-	if (poll)
-		_base_process_reply_queue(reply_q);
 }
 
 /**
diff --git a/drivers/usb/class/usbtmc.c b/drivers/usb/class/usbtmc.c
index 73f419adce61..4bb6d304eb4b 100644
--- a/drivers/usb/class/usbtmc.c
+++ b/drivers/usb/class/usbtmc.c
@@ -1919,6 +1919,7 @@ static int usbtmc_ioctl_request(struct usbtmc_device_data *data,
 	struct usbtmc_ctrlrequest request;
 	u8 *buffer = NULL;
 	int rv;
+	unsigned int is_in, pipe;
 	unsigned long res;
 
 	res = copy_from_user(&request, arg, sizeof(struct usbtmc_ctrlrequest));
@@ -1928,12 +1929,14 @@ static int usbtmc_ioctl_request(struct usbtmc_device_data *data,
 	if (request.req.wLength > USBTMC_BUFSIZE)
 		return -EMSGSIZE;
 
+	is_in = request.req.bRequestType & USB_DIR_IN;
+
 	if (request.req.wLength) {
 		buffer = kmalloc(request.req.wLength, GFP_KERNEL);
 		if (!buffer)
 			return -ENOMEM;
 
-		if ((request.req.bRequestType & USB_DIR_IN) == 0) {
+		if (!is_in) {
 			/* Send control data to device */
 			res = copy_from_user(buffer, request.data,
 					     request.req.wLength);
@@ -1944,8 +1947,12 @@ static int usbtmc_ioctl_request(struct usbtmc_device_data *data,
 		}
 	}
 
+	if (is_in)
+		pipe = usb_rcvctrlpipe(data->usb_dev, 0);
+	else
+		pipe = usb_sndctrlpipe(data->usb_dev, 0);
 	rv = usb_control_msg(data->usb_dev,
-			usb_rcvctrlpipe(data->usb_dev, 0),
+			pipe,
 			request.req.bRequest,
 			request.req.bRequestType,
 			request.req.wValue,
@@ -1957,7 +1964,7 @@ static int usbtmc_ioctl_request(struct usbtmc_device_data *data,
 		goto exit;
 	}
 
-	if (rv && (request.req.bRequestType & USB_DIR_IN)) {
+	if (rv && is_in) {
 		/* Read control data from device */
 		res = copy_to_user(request.data, buffer, rv);
 		if (res)
diff --git a/drivers/usb/gadget/function/rndis.c b/drivers/usb/gadget/function/rndis.c
index 0f14c5291af0..4150de96b937 100644
--- a/drivers/usb/gadget/function/rndis.c
+++ b/drivers/usb/gadget/function/rndis.c
@@ -640,6 +640,7 @@ static int rndis_set_response(struct rndis_params *params,
 	BufLength = le32_to_cpu(buf->InformationBufferLength);
 	BufOffset = le32_to_cpu(buf->InformationBufferOffset);
 	if ((BufLength > RNDIS_MAX_TOTAL_SIZE) ||
+	    (BufOffset > RNDIS_MAX_TOTAL_SIZE) ||
 	    (BufOffset + 8 >= RNDIS_MAX_TOTAL_SIZE))
 		    return -EINVAL;
 
diff --git a/drivers/usb/gadget/udc/core.c b/drivers/usb/gadget/udc/core.c
index 568534a0d17c..c109b069f511 100644
--- a/drivers/usb/gadget/udc/core.c
+++ b/drivers/usb/gadget/udc/core.c
@@ -1436,7 +1436,6 @@ static void usb_gadget_remove_driver(struct usb_udc *udc)
 	usb_gadget_udc_stop(udc);
 
 	udc->driver = NULL;
-	udc->dev.driver = NULL;
 	udc->gadget->dev.driver = NULL;
 }
 
@@ -1498,7 +1497,6 @@ static int udc_bind_to_driver(struct usb_udc *udc, struct usb_gadget_driver *dri
 			driver->function);
 
 	udc->driver = driver;
-	udc->dev.driver = &driver->driver;
 	udc->gadget->dev.driver = &driver->driver;
 
 	usb_gadget_udc_set_speed(udc, driver->max_speed);
@@ -1521,7 +1519,6 @@ static int udc_bind_to_driver(struct usb_udc *udc, struct usb_gadget_driver *dri
 		dev_err(&udc->dev, "failed to start %s: %d\n",
 			udc->driver->function, ret);
 	udc->driver = NULL;
-	udc->dev.driver = NULL;
 	udc->gadget->dev.driver = NULL;
 	return ret;
 }
diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 37f0b4274113..e6c9d41db1de 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -753,7 +753,8 @@ static int vhost_vsock_dev_release(struct inode *inode, struct file *file)
 
 	/* Iterating over all connections for all CIDs to find orphans is
 	 * inefficient.  Room for improvement here. */
-	vsock_for_each_connected_socket(vhost_vsock_reset_orphans);
+	vsock_for_each_connected_socket(&vhost_transport.transport,
+					vhost_vsock_reset_orphans);
 
 	/* Don't check the owner, because we are in the release path, so we
 	 * need to stop the vsock device in any case.
diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index c4c8db2ffa84..05c606fb3968 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -124,7 +124,16 @@ void btrfs_put_block_group(struct btrfs_block_group *cache)
 {
 	if (refcount_dec_and_test(&cache->refs)) {
 		WARN_ON(cache->pinned > 0);
-		WARN_ON(cache->reserved > 0);
+		/*
+		 * If there was a failure to cleanup a log tree, very likely due
+		 * to an IO failure on a writeback attempt of one or more of its
+		 * extent buffers, we could not do proper (and cheap) unaccounting
+		 * of their reserved space, so don't warn on reserved > 0 in that
+		 * case.
+		 */
+		if (!(cache->flags & BTRFS_BLOCK_GROUP_METADATA) ||
+		    !BTRFS_FS_LOG_CLEANUP_ERROR(cache->fs_info))
+			WARN_ON(cache->reserved > 0);
 
 		/*
 		 * A block_group shouldn't be on the discard_list anymore.
@@ -3987,9 +3996,22 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info)
 		 * important and indicates a real bug if this happens.
 		 */
 		if (WARN_ON(space_info->bytes_pinned > 0 ||
-			    space_info->bytes_reserved > 0 ||
 			    space_info->bytes_may_use > 0))
 			btrfs_dump_space_info(info, space_info, 0, 0);
+
+		/*
+		 * If there was a failure to cleanup a log tree, very likely due
+		 * to an IO failure on a writeback attempt of one or more of its
+		 * extent buffers, we could not do proper (and cheap) unaccounting
+		 * of their reserved space, so don't warn on bytes_reserved > 0 in
+		 * that case.
+		 */
+		if (!(space_info->flags & BTRFS_BLOCK_GROUP_METADATA) ||
+		    !BTRFS_FS_LOG_CLEANUP_ERROR(info)) {
+			if (WARN_ON(space_info->bytes_reserved > 0))
+				btrfs_dump_space_info(info, space_info, 0, 0);
+		}
+
 		WARN_ON(space_info->reclaim_size > 0);
 		list_del(&space_info->list);
 		btrfs_sysfs_remove_space_info(space_info);
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index b18939863c29..cd8e0f9ae82c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -143,6 +143,9 @@ enum {
 	BTRFS_FS_STATE_DEV_REPLACING,
 	/* The btrfs_fs_info created for self-tests */
 	BTRFS_FS_STATE_DUMMY_FS_INFO,
+
+	/* Indicates there was an error cleaning up a log tree. */
+	BTRFS_FS_STATE_LOG_CLEANUP_ERROR,
 };
 
 #define BTRFS_BACKREF_REV_MAX		256
@@ -3585,6 +3588,10 @@ static inline void btrfs_print_v0_err(struct btrfs_fs_info *fs_info)
 "Unsupported V0 extent filesystem detected. Aborting. Please re-create your filesystem with a newer kernel");
 }
 
+#define BTRFS_FS_LOG_CLEANUP_ERROR(fs_info)				\
+	(unlikely(test_bit(BTRFS_FS_STATE_LOG_CLEANUP_ERROR,		\
+			   &(fs_info)->fs_state)))
+
 __printf(5, 6)
 __cold
 void __btrfs_handle_fs_error(struct btrfs_fs_info *fs_info, const char *function,
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index f5371c4653cd..90d5aa11e417 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3449,6 +3449,29 @@ static void free_log_tree(struct btrfs_trans_handle *trans,
 	if (log->node) {
 		ret = walk_log_tree(trans, log, &wc);
 		if (ret) {
+			/*
+			 * We weren't able to traverse the entire log tree, the
+			 * typical scenario is getting an -EIO when reading an
+			 * extent buffer of the tree, due to a previous writeback
+			 * failure of it.
+			 */
+			set_bit(BTRFS_FS_STATE_LOG_CLEANUP_ERROR,
+				&log->fs_info->fs_state);
+
+			/*
+			 * Some extent buffers of the log tree may still be dirty
+			 * and not yet written back to storage, because we may
+			 * have updates to a log tree without syncing a log tree,
+			 * such as during rename and link operations. So flush
+			 * them out and wait for their writeback to complete, so
+			 * that we properly cleanup their state and pages.
+			 */
+			btrfs_write_marked_extents(log->fs_info,
+						   &log->dirty_log_pages,
+						   EXTENT_DIRTY | EXTENT_NEW);
+			btrfs_wait_tree_log_extents(log,
+						    EXTENT_DIRTY | EXTENT_NEW);
+
 			if (trans)
 				btrfs_abort_transaction(trans, ret);
 			else
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 1286b88b6fa1..35c674041337 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1106,17 +1106,6 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 		goto read_super_error;
 	}
 
-	root = d_make_root(inode);
-	if (!root) {
-		status = -ENOMEM;
-		mlog_errno(status);
-		goto read_super_error;
-	}
-
-	sb->s_root = root;
-
-	ocfs2_complete_mount_recovery(osb);
-
 	osb->osb_dev_kset = kset_create_and_add(sb->s_id, NULL,
 						&ocfs2_kset->kobj);
 	if (!osb->osb_dev_kset) {
@@ -1134,6 +1123,17 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 		goto read_super_error;
 	}
 
+	root = d_make_root(inode);
+	if (!root) {
+		status = -ENOMEM;
+		mlog_errno(status);
+		goto read_super_error;
+	}
+
+	sb->s_root = root;
+
+	ocfs2_complete_mount_recovery(osb);
+
 	if (ocfs2_mount_local(osb))
 		snprintf(nodestr, sizeof(nodestr), "local");
 	else
diff --git a/include/linux/if_arp.h b/include/linux/if_arp.h
index b712217f7030..1ed52441972f 100644
--- a/include/linux/if_arp.h
+++ b/include/linux/if_arp.h
@@ -52,6 +52,7 @@ static inline bool dev_is_mac_header_xmit(const struct net_device *dev)
 	case ARPHRD_VOID:
 	case ARPHRD_NONE:
 	case ARPHRD_RAWIP:
+	case ARPHRD_PIMREG:
 		return false;
 	default:
 		return true;
diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index ab207677e0a8..f742e50207fb 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -205,7 +205,8 @@ struct sock *vsock_find_bound_socket(struct sockaddr_vm *addr);
 struct sock *vsock_find_connected_socket(struct sockaddr_vm *src,
 					 struct sockaddr_vm *dst);
 void vsock_remove_sock(struct vsock_sock *vsk);
-void vsock_for_each_connected_socket(void (*fn)(struct sock *sk));
+void vsock_for_each_connected_socket(struct vsock_transport *transport,
+				     void (*fn)(struct sock *sk));
 int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk);
 bool vsock_find_cid(unsigned int cid);
 
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 8d4104242100..ee67164531c0 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -478,7 +478,7 @@ struct page *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 		 * __read_swap_cache_async(), which has set SWAP_HAS_CACHE
 		 * in swap_map, but not yet added its page to swap cache.
 		 */
-		cond_resched();
+		schedule_timeout_uninterruptible(1);
 	}
 
 	/*
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 7578b1350f18..e64ef196a984 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1327,6 +1327,7 @@ static int dsa_port_parse_of(struct dsa_port *dp, struct device_node *dn)
 		const char *user_protocol;
 
 		master = of_find_net_device_by_node(ethernet);
+		of_node_put(ethernet);
 		if (!master)
 			return -EPROBE_DEFER;
 
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index b7b573085bd5..5023f59a5b96 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -813,8 +813,7 @@ int esp6_input_done2(struct sk_buff *skb, int err)
 		struct tcphdr *th;
 
 		offset = ipv6_skip_exthdr(skb, offset, &nexthdr, &frag_off);
-
-		if (offset < 0) {
+		if (offset == -1) {
 			err = -EINVAL;
 			goto out;
 		}
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index fe9b4c04744a..92d180a0db5a 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2316,8 +2316,11 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
 					copy_skb = skb_get(skb);
 					skb_head = skb->data;
 				}
-				if (copy_skb)
+				if (copy_skb) {
+					memset(&PACKET_SKB_CB(copy_skb)->sa.ll, 0,
+					       sizeof(PACKET_SKB_CB(copy_skb)->sa.ll));
 					skb_set_owner_r(copy_skb, sk);
+				}
 			}
 			snaplen = po->rx_ring.frame_size - macoff;
 			if ((int)snaplen < 0) {
@@ -3469,6 +3472,8 @@ static int packet_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	sock_recv_ts_and_drops(msg, sk, skb);
 
 	if (msg->msg_name) {
+		const size_t max_len = min(sizeof(skb->cb),
+					   sizeof(struct sockaddr_storage));
 		int copy_len;
 
 		/* If the address length field is there to be filled
@@ -3491,6 +3496,10 @@ static int packet_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 				msg->msg_namelen = sizeof(struct sockaddr_ll);
 			}
 		}
+		if (WARN_ON_ONCE(copy_len > max_len)) {
+			copy_len = max_len;
+			msg->msg_namelen = copy_len;
+		}
 		memcpy(msg->msg_name, &PACKET_SKB_CB(skb)->sa, copy_len);
 	}
 
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 8e4f2a1346be..782aa4209718 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -333,7 +333,8 @@ void vsock_remove_sock(struct vsock_sock *vsk)
 }
 EXPORT_SYMBOL_GPL(vsock_remove_sock);
 
-void vsock_for_each_connected_socket(void (*fn)(struct sock *sk))
+void vsock_for_each_connected_socket(struct vsock_transport *transport,
+				     void (*fn)(struct sock *sk))
 {
 	int i;
 
@@ -342,8 +343,12 @@ void vsock_for_each_connected_socket(void (*fn)(struct sock *sk))
 	for (i = 0; i < ARRAY_SIZE(vsock_connected_table); i++) {
 		struct vsock_sock *vsk;
 		list_for_each_entry(vsk, &vsock_connected_table[i],
-				    connected_table)
+				    connected_table) {
+			if (vsk->transport != transport)
+				continue;
+
 			fn(sk_vsock(vsk));
+		}
 	}
 
 	spin_unlock_bh(&vsock_table_lock);
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 4f7c99dfd16c..dad9ca65f4f9 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -24,6 +24,7 @@
 static struct workqueue_struct *virtio_vsock_workqueue;
 static struct virtio_vsock __rcu *the_virtio_vsock;
 static DEFINE_MUTEX(the_virtio_vsock_mutex); /* protects the_virtio_vsock */
+static struct virtio_transport virtio_transport; /* forward declaration */
 
 struct virtio_vsock {
 	struct virtio_device *vdev;
@@ -384,7 +385,8 @@ static void virtio_vsock_event_handle(struct virtio_vsock *vsock,
 	switch (le32_to_cpu(event->id)) {
 	case VIRTIO_VSOCK_EVENT_TRANSPORT_RESET:
 		virtio_vsock_update_guest_cid(vsock);
-		vsock_for_each_connected_socket(virtio_vsock_reset_sock);
+		vsock_for_each_connected_socket(&virtio_transport.transport,
+						virtio_vsock_reset_sock);
 		break;
 	}
 }
@@ -662,7 +664,8 @@ static void virtio_vsock_remove(struct virtio_device *vdev)
 	synchronize_rcu();
 
 	/* Reset all connected sockets when the device disappear */
-	vsock_for_each_connected_socket(virtio_vsock_reset_sock);
+	vsock_for_each_connected_socket(&virtio_transport.transport,
+					virtio_vsock_reset_sock);
 
 	/* Stop all work handlers to make sure no one is accessing the device,
 	 * so we can safely call vdev->config->reset().
diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
index 7aef34e32bdf..b17dc9745188 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -75,6 +75,8 @@ static u32 vmci_transport_qp_resumed_sub_id = VMCI_INVALID_ID;
 
 static int PROTOCOL_OVERRIDE = -1;
 
+static struct vsock_transport vmci_transport; /* forward declaration */
+
 /* Helper function to convert from a VMCI error code to a VSock error code. */
 
 static s32 vmci_transport_error_to_vsock_error(s32 vmci_error)
@@ -882,7 +884,8 @@ static void vmci_transport_qp_resumed_cb(u32 sub_id,
 					 const struct vmci_event_data *e_data,
 					 void *client_data)
 {
-	vsock_for_each_connected_socket(vmci_transport_handle_detach);
+	vsock_for_each_connected_socket(&vmci_transport,
+					vmci_transport_handle_detach);
 }
 
 static void vmci_transport_recv_pkt_work(struct work_struct *work)
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index b2ed3140a1fa..dfde9eada224 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -231,7 +231,7 @@ void symbols__fixup_end(struct rb_root_cached *symbols)
 		prev = curr;
 		curr = rb_entry(nd, struct symbol, rb_node);
 
-		if (prev->end == prev->start && prev->end != curr->start)
+		if (prev->end == prev->start || prev->end != curr->start)
 			arch__symbols__fixup_end(prev, curr);
 	}
 

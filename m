Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B91E638E89
	for <lists+stable@lfdr.de>; Fri, 25 Nov 2022 17:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbiKYQsS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Nov 2022 11:48:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbiKYQrk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Nov 2022 11:47:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC70652170;
        Fri, 25 Nov 2022 08:47:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6717B82B92;
        Fri, 25 Nov 2022 16:47:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F526C433C1;
        Fri, 25 Nov 2022 16:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669394821;
        bh=klM7xxC4VuAyz8b5R0b6/g6RCyWzA8pyaXz8R74Vikg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P5MXwQCY+6DvfOHBEidfxNNY36eh7xN07hJjF6ombKRPYtZkxMPUUl/sQ4FRRDqpQ
         Am48RZ6QuBzf/+kWOJ37tHxBgUf8q4zgjZSgK/uGsempRacVXRDu4pVyGSVwhrH4ck
         ecyj7g1HGQ/STcbT4l5gYnEN2H/PU85YakwXl4cM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.10.156
Date:   Fri, 25 Nov 2022 17:46:55 +0100
Message-Id: <1669394814121139@kroah.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <166939481462103@kroah.com>
References: <166939481462103@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/process/code-of-conduct-interpretation.rst b/Documentation/process/code-of-conduct-interpretation.rst
index 4f8a06b00f60..43da2cc2e3b9 100644
--- a/Documentation/process/code-of-conduct-interpretation.rst
+++ b/Documentation/process/code-of-conduct-interpretation.rst
@@ -51,7 +51,7 @@ the Technical Advisory Board (TAB) or other maintainers if you're
 uncertain how to handle situations that come up.  It will not be
 considered a violation report unless you want it to be.  If you are
 uncertain about approaching the TAB or any other maintainers, please
-reach out to our conflict mediator, Joanna Lee <joanna.lee@gesmer.com>.
+reach out to our conflict mediator, Joanna Lee <jlee@linuxfoundation.org>.
 
 In the end, "be kind to each other" is really what the end goal is for
 everybody.  We know everyone is human and we all fail at times, but the
diff --git a/Makefile b/Makefile
index 8ccf902b3609..166f87bdc190 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 10
-SUBLEVEL = 155
+SUBLEVEL = 156
 EXTRAVERSION =
 NAME = Dare mighty things
 
diff --git a/arch/arm/boot/dts/imx7s.dtsi b/arch/arm/boot/dts/imx7s.dtsi
index 9e1b0af0aa43..e4ff47110a96 100644
--- a/arch/arm/boot/dts/imx7s.dtsi
+++ b/arch/arm/boot/dts/imx7s.dtsi
@@ -1221,10 +1221,10 @@ dma_apbh: dma-apbh@33000000 {
 			clocks = <&clks IMX7D_NAND_USDHC_BUS_RAWNAND_CLK>;
 		};
 
-		gpmi: nand-controller@33002000{
+		gpmi: nand-controller@33002000 {
 			compatible = "fsl,imx7d-gpmi-nand";
 			#address-cells = <1>;
-			#size-cells = <1>;
+			#size-cells = <0>;
 			reg = <0x33002000 0x2000>, <0x33004000 0x4000>;
 			reg-names = "gpmi-nand", "bch";
 			interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
diff --git a/arch/arm64/boot/dts/freescale/imx8mm.dtsi b/arch/arm64/boot/dts/freescale/imx8mm.dtsi
index f4d7bb75707d..3490619a9ba9 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm.dtsi
@@ -939,10 +939,10 @@ dma_apbh: dma-controller@33000000 {
 			clocks = <&clk IMX8MM_CLK_NAND_USDHC_BUS_RAWNAND_CLK>;
 		};
 
-		gpmi: nand-controller@33002000{
+		gpmi: nand-controller@33002000 {
 			compatible = "fsl,imx8mm-gpmi-nand", "fsl,imx7d-gpmi-nand";
 			#address-cells = <1>;
-			#size-cells = <1>;
+			#size-cells = <0>;
 			reg = <0x33002000 0x2000>, <0x33004000 0x4000>;
 			reg-names = "gpmi-nand", "bch";
 			interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
diff --git a/arch/arm64/boot/dts/freescale/imx8mn.dtsi b/arch/arm64/boot/dts/freescale/imx8mn.dtsi
index aea723eb2ba3..7dba83041264 100644
--- a/arch/arm64/boot/dts/freescale/imx8mn.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mn.dtsi
@@ -809,7 +809,7 @@ dma_apbh: dma-controller@33000000 {
 		gpmi: nand-controller@33002000 {
 			compatible = "fsl,imx8mn-gpmi-nand", "fsl,imx7d-gpmi-nand";
 			#address-cells = <1>;
-			#size-cells = <1>;
+			#size-cells = <0>;
 			reg = <0x33002000 0x2000>, <0x33004000 0x4000>;
 			reg-names = "gpmi-nand", "bch";
 			interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index 457b6bb276bb..9cf5d9551e99 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -41,7 +41,7 @@
 	(((midr) & MIDR_IMPLEMENTOR_MASK) >> MIDR_IMPLEMENTOR_SHIFT)
 
 #define MIDR_CPU_MODEL(imp, partnum) \
-	(((imp)			<< MIDR_IMPLEMENTOR_SHIFT) | \
+	((_AT(u32, imp)		<< MIDR_IMPLEMENTOR_SHIFT) | \
 	(0xf			<< MIDR_ARCHITECTURE_SHIFT) | \
 	((partnum)		<< MIDR_PARTNUM_SHIFT))
 
diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
index 95234f46b0fb..d87421acddc3 100644
--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -1247,6 +1247,15 @@ static int pt_buffer_try_single(struct pt_buffer *buf, int nr_pages)
 	if (1 << order != nr_pages)
 		goto out;
 
+	/*
+	 * Some processors cannot always support single range for more than
+	 * 4KB - refer errata TGL052, ADL037 and RPL017. Future processors might
+	 * also be affected, so for now rather than trying to keep track of
+	 * which ones, just disable it for all.
+	 */
+	if (nr_pages > 1)
+		goto out;
+
 	buf->single = true;
 	buf->nr_pages = nr_pages;
 	ret = 0;
diff --git a/block/sed-opal.c b/block/sed-opal.c
index daafadbb88ca..0ac5a4f3f226 100644
--- a/block/sed-opal.c
+++ b/block/sed-opal.c
@@ -88,8 +88,8 @@ struct opal_dev {
 	u64 lowest_lba;
 
 	size_t pos;
-	u8 cmd[IO_BUFFER_LENGTH];
-	u8 resp[IO_BUFFER_LENGTH];
+	u8 *cmd;
+	u8 *resp;
 
 	struct parsed_resp parsed;
 	size_t prev_d_len;
@@ -2134,6 +2134,8 @@ void free_opal_dev(struct opal_dev *dev)
 		return;
 
 	clean_opal_dev(dev);
+	kfree(dev->resp);
+	kfree(dev->cmd);
 	kfree(dev);
 }
 EXPORT_SYMBOL(free_opal_dev);
@@ -2146,17 +2148,39 @@ struct opal_dev *init_opal_dev(void *data, sec_send_recv *send_recv)
 	if (!dev)
 		return NULL;
 
+	/*
+	 * Presumably DMA-able buffers must be cache-aligned. Kmalloc makes
+	 * sure the allocated buffer is DMA-safe in that regard.
+	 */
+	dev->cmd = kmalloc(IO_BUFFER_LENGTH, GFP_KERNEL);
+	if (!dev->cmd)
+		goto err_free_dev;
+
+	dev->resp = kmalloc(IO_BUFFER_LENGTH, GFP_KERNEL);
+	if (!dev->resp)
+		goto err_free_cmd;
+
 	INIT_LIST_HEAD(&dev->unlk_lst);
 	mutex_init(&dev->dev_lock);
 	dev->data = data;
 	dev->send_recv = send_recv;
 	if (check_opal_support(dev) != 0) {
 		pr_debug("Opal is not supported on this device\n");
-		kfree(dev);
-		return NULL;
+		goto err_free_resp;
 	}
 
 	return dev;
+
+err_free_resp:
+	kfree(dev->resp);
+
+err_free_cmd:
+	kfree(dev->cmd);
+
+err_free_dev:
+	kfree(dev);
+
+	return NULL;
 }
 EXPORT_SYMBOL(init_opal_dev);
 
diff --git a/drivers/accessibility/speakup/main.c b/drivers/accessibility/speakup/main.c
index 48019660a096..63c5444f0f1a 100644
--- a/drivers/accessibility/speakup/main.c
+++ b/drivers/accessibility/speakup/main.c
@@ -1780,7 +1780,7 @@ static void speakup_con_update(struct vc_data *vc)
 {
 	unsigned long flags;
 
-	if (!speakup_console[vc->vc_num] || spk_parked)
+	if (!speakup_console[vc->vc_num] || spk_parked || !synth)
 		return;
 	if (!spin_trylock_irqsave(&speakup_info.spinlock, flags))
 		/* Speakup output, discard */
diff --git a/drivers/ata/libata-transport.c b/drivers/ata/libata-transport.c
index b33772df9bc6..31a66fc0c31d 100644
--- a/drivers/ata/libata-transport.c
+++ b/drivers/ata/libata-transport.c
@@ -301,7 +301,9 @@ int ata_tport_add(struct device *parent,
 	pm_runtime_enable(dev);
 	pm_runtime_forbid(dev);
 
-	transport_add_device(dev);
+	error = transport_add_device(dev);
+	if (error)
+		goto tport_transport_add_err;
 	transport_configure_device(dev);
 
 	error = ata_tlink_add(&ap->link);
@@ -312,12 +314,12 @@ int ata_tport_add(struct device *parent,
 
  tport_link_err:
 	transport_remove_device(dev);
+ tport_transport_add_err:
 	device_del(dev);
 
  tport_err:
 	transport_destroy_device(dev);
 	put_device(dev);
-	ata_host_put(ap->host);
 	return error;
 }
 
@@ -426,7 +428,9 @@ int ata_tlink_add(struct ata_link *link)
 		goto tlink_err;
 	}
 
-	transport_add_device(dev);
+	error = transport_add_device(dev);
+	if (error)
+		goto tlink_transport_err;
 	transport_configure_device(dev);
 
 	ata_for_each_dev(ata_dev, link, ALL) {
@@ -441,6 +445,7 @@ int ata_tlink_add(struct ata_link *link)
 		ata_tdev_delete(ata_dev);
 	}
 	transport_remove_device(dev);
+  tlink_transport_err:
 	device_del(dev);
   tlink_err:
 	transport_destroy_device(dev);
@@ -678,7 +683,13 @@ static int ata_tdev_add(struct ata_device *ata_dev)
 		return error;
 	}
 
-	transport_add_device(dev);
+	error = transport_add_device(dev);
+	if (error) {
+		device_del(dev);
+		ata_tdev_free(ata_dev);
+		return error;
+	}
+
 	transport_configure_device(dev);
 	return 0;
 }
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 407527ff6b1f..51450f7c81af 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2720,7 +2720,7 @@ static int init_submitter(struct drbd_device *device)
 enum drbd_ret_code drbd_create_device(struct drbd_config_context *adm_ctx, unsigned int minor)
 {
 	struct drbd_resource *resource = adm_ctx->resource;
-	struct drbd_connection *connection;
+	struct drbd_connection *connection, *n;
 	struct drbd_device *device;
 	struct drbd_peer_device *peer_device, *tmp_peer_device;
 	struct gendisk *disk;
@@ -2839,7 +2839,7 @@ enum drbd_ret_code drbd_create_device(struct drbd_config_context *adm_ctx, unsig
 out_idr_remove_vol:
 	idr_remove(&connection->peer_devices, vnr);
 out_idr_remove_from_resource:
-	for_each_connection(connection, resource) {
+	for_each_connection_safe(connection, n, resource) {
 		peer_device = idr_remove(&connection->peer_devices, vnr);
 		if (peer_device)
 			kref_put(&connection->kref, drbd_destroy_connection);
diff --git a/drivers/firmware/google/coreboot_table.c b/drivers/firmware/google/coreboot_table.c
index 0205987a4fd4..568074148f62 100644
--- a/drivers/firmware/google/coreboot_table.c
+++ b/drivers/firmware/google/coreboot_table.c
@@ -152,12 +152,8 @@ static int coreboot_table_probe(struct platform_device *pdev)
 	if (!ptr)
 		return -ENOMEM;
 
-	ret = bus_register(&coreboot_bus_type);
-	if (!ret) {
-		ret = coreboot_table_populate(dev, ptr);
-		if (ret)
-			bus_unregister(&coreboot_bus_type);
-	}
+	ret = coreboot_table_populate(dev, ptr);
+
 	memunmap(ptr);
 
 	return ret;
@@ -172,7 +168,6 @@ static int __cb_dev_unregister(struct device *dev, void *dummy)
 static int coreboot_table_remove(struct platform_device *pdev)
 {
 	bus_for_each_dev(&coreboot_bus_type, NULL, NULL, __cb_dev_unregister);
-	bus_unregister(&coreboot_bus_type);
 	return 0;
 }
 
@@ -202,6 +197,32 @@ static struct platform_driver coreboot_table_driver = {
 		.of_match_table = of_match_ptr(coreboot_of_match),
 	},
 };
-module_platform_driver(coreboot_table_driver);
+
+static int __init coreboot_table_driver_init(void)
+{
+	int ret;
+
+	ret = bus_register(&coreboot_bus_type);
+	if (ret)
+		return ret;
+
+	ret = platform_driver_register(&coreboot_table_driver);
+	if (ret) {
+		bus_unregister(&coreboot_bus_type);
+		return ret;
+	}
+
+	return 0;
+}
+
+static void __exit coreboot_table_driver_exit(void)
+{
+	platform_driver_unregister(&coreboot_table_driver);
+	bus_unregister(&coreboot_bus_type);
+}
+
+module_init(coreboot_table_driver_init);
+module_exit(coreboot_table_driver_exit);
+
 MODULE_AUTHOR("Google, Inc.");
 MODULE_LICENSE("GPL");
diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
index 8f66eef0c683..c6c4888c6665 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -1746,7 +1746,7 @@ void dcn20_post_unlock_program_front_end(
 
 			for (j = 0; j < TIMEOUT_FOR_PIPE_ENABLE_MS*1000
 					&& hubp->funcs->hubp_is_flip_pending(hubp); j++)
-				mdelay(1);
+				udelay(1);
 		}
 	}
 
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
index 1c526cb239e0..3a31058b029e 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
@@ -379,16 +379,31 @@ static int arcturus_set_default_dpm_table(struct smu_context *smu)
 	return 0;
 }
 
-static int arcturus_check_powerplay_table(struct smu_context *smu)
+static void arcturus_check_bxco_support(struct smu_context *smu)
 {
 	struct smu_table_context *table_context = &smu->smu_table;
 	struct smu_11_0_powerplay_table *powerplay_table =
 		table_context->power_play_table;
 	struct smu_baco_context *smu_baco = &smu->smu_baco;
+	struct amdgpu_device *adev = smu->adev;
+	uint32_t val;
 
 	if (powerplay_table->platform_caps & SMU_11_0_PP_PLATFORM_CAP_BACO ||
-	    powerplay_table->platform_caps & SMU_11_0_PP_PLATFORM_CAP_MACO)
-		smu_baco->platform_support = true;
+	    powerplay_table->platform_caps & SMU_11_0_PP_PLATFORM_CAP_MACO) {
+		val = RREG32_SOC15(NBIO, 0, mmRCC_BIF_STRAP0);
+		smu_baco->platform_support =
+			(val & RCC_BIF_STRAP0__STRAP_PX_CAPABLE_MASK) ? true :
+									false;
+	}
+}
+
+static int arcturus_check_powerplay_table(struct smu_context *smu)
+{
+	struct smu_table_context *table_context = &smu->smu_table;
+	struct smu_11_0_powerplay_table *powerplay_table =
+		table_context->power_play_table;
+
+	arcturus_check_bxco_support(smu);
 
 	table_context->thermal_controller_type =
 		powerplay_table->thermal_controller_type;
@@ -2131,13 +2146,11 @@ static void arcturus_get_unique_id(struct smu_context *smu)
 static bool arcturus_is_baco_supported(struct smu_context *smu)
 {
 	struct amdgpu_device *adev = smu->adev;
-	uint32_t val;
 
 	if (!smu_v11_0_baco_is_support(smu) || amdgpu_sriov_vf(adev))
 		return false;
 
-	val = RREG32_SOC15(NBIO, 0, mmRCC_BIF_STRAP0);
-	return (val & RCC_BIF_STRAP0__STRAP_PX_CAPABLE_MASK) ? true : false;
+	return true;
 }
 
 static int arcturus_set_df_cstate(struct smu_context *smu,
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
index 2937784bc824..a7773b6453d5 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
@@ -338,19 +338,34 @@ navi10_get_allowed_feature_mask(struct smu_context *smu,
 	return 0;
 }
 
-static int navi10_check_powerplay_table(struct smu_context *smu)
+static void navi10_check_bxco_support(struct smu_context *smu)
 {
 	struct smu_table_context *table_context = &smu->smu_table;
 	struct smu_11_0_powerplay_table *powerplay_table =
 		table_context->power_play_table;
 	struct smu_baco_context *smu_baco = &smu->smu_baco;
+	struct amdgpu_device *adev = smu->adev;
+	uint32_t val;
+
+	if (powerplay_table->platform_caps & SMU_11_0_PP_PLATFORM_CAP_BACO ||
+	    powerplay_table->platform_caps & SMU_11_0_PP_PLATFORM_CAP_MACO) {
+		val = RREG32_SOC15(NBIO, 0, mmRCC_BIF_STRAP0);
+		smu_baco->platform_support =
+			(val & RCC_BIF_STRAP0__STRAP_PX_CAPABLE_MASK) ? true :
+									false;
+	}
+}
+
+static int navi10_check_powerplay_table(struct smu_context *smu)
+{
+	struct smu_table_context *table_context = &smu->smu_table;
+	struct smu_11_0_powerplay_table *powerplay_table =
+		table_context->power_play_table;
 
 	if (powerplay_table->platform_caps & SMU_11_0_PP_PLATFORM_CAP_HARDWAREDC)
 		smu->dc_controlled_by_gpio = true;
 
-	if (powerplay_table->platform_caps & SMU_11_0_PP_PLATFORM_CAP_BACO ||
-	    powerplay_table->platform_caps & SMU_11_0_PP_PLATFORM_CAP_MACO)
-		smu_baco->platform_support = true;
+	navi10_check_bxco_support(smu);
 
 	table_context->thermal_controller_type =
 		powerplay_table->thermal_controller_type;
@@ -1948,13 +1963,11 @@ static int navi10_overdrive_get_gfx_clk_base_voltage(struct smu_context *smu,
 static bool navi10_is_baco_supported(struct smu_context *smu)
 {
 	struct amdgpu_device *adev = smu->adev;
-	uint32_t val;
 
 	if (amdgpu_sriov_vf(adev) || (!smu_v11_0_baco_is_support(smu)))
 		return false;
 
-	val = RREG32_SOC15(NBIO, 0, mmRCC_BIF_STRAP0);
-	return (val & RCC_BIF_STRAP0__STRAP_PX_CAPABLE_MASK) ? true : false;
+	return true;
 }
 
 static int navi10_set_default_od_settings(struct smu_context *smu)
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
index 49d7fa1d0842..45c815262200 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
@@ -294,16 +294,47 @@ sienna_cichlid_get_allowed_feature_mask(struct smu_context *smu,
 	return 0;
 }
 
-static int sienna_cichlid_check_powerplay_table(struct smu_context *smu)
+static void sienna_cichlid_check_bxco_support(struct smu_context *smu)
 {
 	struct smu_table_context *table_context = &smu->smu_table;
 	struct smu_11_0_7_powerplay_table *powerplay_table =
 		table_context->power_play_table;
 	struct smu_baco_context *smu_baco = &smu->smu_baco;
+	struct amdgpu_device *adev = smu->adev;
+	uint32_t val;
 
 	if (powerplay_table->platform_caps & SMU_11_0_7_PP_PLATFORM_CAP_BACO ||
-	    powerplay_table->platform_caps & SMU_11_0_7_PP_PLATFORM_CAP_MACO)
-		smu_baco->platform_support = true;
+	    powerplay_table->platform_caps & SMU_11_0_7_PP_PLATFORM_CAP_MACO) {
+		val = RREG32_SOC15(NBIO, 0, mmRCC_BIF_STRAP0);
+		smu_baco->platform_support =
+			(val & RCC_BIF_STRAP0__STRAP_PX_CAPABLE_MASK) ? true :
+									false;
+
+		/*
+		 * Disable BACO entry/exit completely on below SKUs to
+		 * avoid hardware intermittent failures.
+		 */
+		if (((adev->pdev->device == 0x73A1) &&
+		    (adev->pdev->revision == 0x00)) ||
+		    ((adev->pdev->device == 0x73BF) &&
+		    (adev->pdev->revision == 0xCF)) ||
+		    ((adev->pdev->device == 0x7422) &&
+		    (adev->pdev->revision == 0x00)))
+			smu_baco->platform_support = false;
+
+	}
+}
+
+static int sienna_cichlid_check_powerplay_table(struct smu_context *smu)
+{
+	struct smu_table_context *table_context = &smu->smu_table;
+	struct smu_11_0_7_powerplay_table *powerplay_table =
+		table_context->power_play_table;
+
+	if (powerplay_table->platform_caps & SMU_11_0_7_PP_PLATFORM_CAP_HARDWAREDC)
+		smu->dc_controlled_by_gpio = true;
+
+	sienna_cichlid_check_bxco_support(smu);
 
 	table_context->thermal_controller_type =
 		powerplay_table->thermal_controller_type;
@@ -1736,13 +1767,11 @@ static int sienna_cichlid_run_btc(struct smu_context *smu)
 static bool sienna_cichlid_is_baco_supported(struct smu_context *smu)
 {
 	struct amdgpu_device *adev = smu->adev;
-	uint32_t val;
 
 	if (amdgpu_sriov_vf(adev) || (!smu_v11_0_baco_is_support(smu)))
 		return false;
 
-	val = RREG32_SOC15(NBIO, 0, mmRCC_BIF_STRAP0);
-	return (val & RCC_BIF_STRAP0__STRAP_PX_CAPABLE_MASK) ? true : false;
+	return true;
 }
 
 static bool sienna_cichlid_is_mode1_reset_supported(struct smu_context *smu)
@@ -2806,6 +2835,7 @@ static const struct pptable_funcs sienna_cichlid_ppt_funcs = {
 	.get_dpm_ultimate_freq = sienna_cichlid_get_dpm_ultimate_freq,
 	.set_soft_freq_limited_range = smu_v11_0_set_soft_freq_limited_range,
 	.run_btc = sienna_cichlid_run_btc,
+	.set_power_source = smu_v11_0_set_power_source,
 	.get_pp_feature_mask = smu_cmn_get_pp_feature_mask,
 	.set_pp_feature_mask = smu_cmn_set_pp_feature_mask,
 	.get_gpu_metrics = sienna_cichlid_get_gpu_metrics,
diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
index 006e3b896cae..4ca995ce19af 100644
--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -610,7 +610,7 @@ static int drm_dev_init(struct drm_device *dev,
 	mutex_init(&dev->clientlist_mutex);
 	mutex_init(&dev->master_mutex);
 
-	ret = drmm_add_action(dev, drm_dev_init_release, NULL);
+	ret = drmm_add_action_or_reset(dev, drm_dev_init_release, NULL);
 	if (ret)
 		return ret;
 
diff --git a/drivers/gpu/drm/drm_internal.h b/drivers/gpu/drm/drm_internal.h
index f80e0f28087d..41efe40bc70f 100644
--- a/drivers/gpu/drm/drm_internal.h
+++ b/drivers/gpu/drm/drm_internal.h
@@ -116,7 +116,8 @@ static inline void drm_vblank_flush_worker(struct drm_vblank_crtc *vblank)
 
 static inline void drm_vblank_destroy_worker(struct drm_vblank_crtc *vblank)
 {
-	kthread_destroy_worker(vblank->worker);
+	if (vblank->worker)
+		kthread_destroy_worker(vblank->worker);
 }
 
 int drm_vblank_worker_init(struct drm_vblank_crtc *vblank);
diff --git a/drivers/gpu/drm/imx/imx-tve.c b/drivers/gpu/drm/imx/imx-tve.c
index 2a8d2e32e7b4..9fe6a4733106 100644
--- a/drivers/gpu/drm/imx/imx-tve.c
+++ b/drivers/gpu/drm/imx/imx-tve.c
@@ -212,8 +212,9 @@ static int imx_tve_connector_get_modes(struct drm_connector *connector)
 	return ret;
 }
 
-static int imx_tve_connector_mode_valid(struct drm_connector *connector,
-					struct drm_display_mode *mode)
+static enum drm_mode_status
+imx_tve_connector_mode_valid(struct drm_connector *connector,
+			     struct drm_display_mode *mode)
 {
 	struct imx_tve *tve = con_to_tve(connector);
 	unsigned long rate;
diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index b7b37082a9d7..1a87cc445b5e 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -2655,6 +2655,7 @@ static const struct display_timing logictechno_lt161010_2nh_timing = {
 static const struct panel_desc logictechno_lt161010_2nh = {
 	.timings = &logictechno_lt161010_2nh_timing,
 	.num_timings = 1,
+	.bpc = 6,
 	.size = {
 		.width = 154,
 		.height = 86,
@@ -2684,6 +2685,7 @@ static const struct display_timing logictechno_lt170410_2whc_timing = {
 static const struct panel_desc logictechno_lt170410_2whc = {
 	.timings = &logictechno_lt170410_2whc_timing,
 	.num_timings = 1,
+	.bpc = 8,
 	.size = {
 		.width = 217,
 		.height = 136,
diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index 5618c1ff34dc..45682d30d705 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -1275,6 +1275,7 @@ static const struct {
 	 */
 	{ "Latitude 5480",      0x29 },
 	{ "Vostro V131",        0x1d },
+	{ "Vostro 5568",        0x29 },
 };
 
 static void register_dell_lis3lv02d_i2c_device(struct i801_priv *priv)
diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index 8b113ae32dc7..42f1db60ad6f 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -283,6 +283,7 @@ struct tegra_i2c_dev {
 	struct dma_chan *tx_dma_chan;
 	struct dma_chan *rx_dma_chan;
 	unsigned int dma_buf_size;
+	struct device *dma_dev;
 	dma_addr_t dma_phys;
 	void *dma_buf;
 
@@ -419,7 +420,7 @@ static int tegra_i2c_dma_submit(struct tegra_i2c_dev *i2c_dev, size_t len)
 static void tegra_i2c_release_dma(struct tegra_i2c_dev *i2c_dev)
 {
 	if (i2c_dev->dma_buf) {
-		dma_free_coherent(i2c_dev->dev, i2c_dev->dma_buf_size,
+		dma_free_coherent(i2c_dev->dma_dev, i2c_dev->dma_buf_size,
 				  i2c_dev->dma_buf, i2c_dev->dma_phys);
 		i2c_dev->dma_buf = NULL;
 	}
@@ -466,10 +467,13 @@ static int tegra_i2c_init_dma(struct tegra_i2c_dev *i2c_dev)
 
 	i2c_dev->tx_dma_chan = chan;
 
+	WARN_ON(i2c_dev->tx_dma_chan->device != i2c_dev->rx_dma_chan->device);
+	i2c_dev->dma_dev = chan->device->dev;
+
 	i2c_dev->dma_buf_size = i2c_dev->hw->quirks->max_write_len +
 				I2C_PACKET_HEADER_SIZE;
 
-	dma_buf = dma_alloc_coherent(i2c_dev->dev, i2c_dev->dma_buf_size,
+	dma_buf = dma_alloc_coherent(i2c_dev->dma_dev, i2c_dev->dma_buf_size,
 				     &dma_phys, GFP_KERNEL | __GFP_NOWARN);
 	if (!dma_buf) {
 		dev_err(i2c_dev->dev, "failed to allocate DMA buffer\n");
@@ -1255,7 +1259,7 @@ static int tegra_i2c_xfer_msg(struct tegra_i2c_dev *i2c_dev,
 
 	if (i2c_dev->dma_mode) {
 		if (i2c_dev->msg_read) {
-			dma_sync_single_for_device(i2c_dev->dev,
+			dma_sync_single_for_device(i2c_dev->dma_dev,
 						   i2c_dev->dma_phys,
 						   xfer_size, DMA_FROM_DEVICE);
 
@@ -1263,7 +1267,7 @@ static int tegra_i2c_xfer_msg(struct tegra_i2c_dev *i2c_dev,
 			if (err)
 				return err;
 		} else {
-			dma_sync_single_for_cpu(i2c_dev->dev,
+			dma_sync_single_for_cpu(i2c_dev->dma_dev,
 						i2c_dev->dma_phys,
 						xfer_size, DMA_TO_DEVICE);
 		}
@@ -1276,7 +1280,7 @@ static int tegra_i2c_xfer_msg(struct tegra_i2c_dev *i2c_dev,
 			memcpy(i2c_dev->dma_buf + I2C_PACKET_HEADER_SIZE,
 			       msg->buf, msg->len);
 
-			dma_sync_single_for_device(i2c_dev->dev,
+			dma_sync_single_for_device(i2c_dev->dma_dev,
 						   i2c_dev->dma_phys,
 						   xfer_size, DMA_TO_DEVICE);
 
@@ -1327,7 +1331,7 @@ static int tegra_i2c_xfer_msg(struct tegra_i2c_dev *i2c_dev,
 		}
 
 		if (i2c_dev->msg_read && i2c_dev->msg_err == I2C_ERR_NONE) {
-			dma_sync_single_for_cpu(i2c_dev->dev,
+			dma_sync_single_for_cpu(i2c_dev->dma_dev,
 						i2c_dev->dma_phys,
 						xfer_size, DMA_FROM_DEVICE);
 
diff --git a/drivers/iio/adc/at91_adc.c b/drivers/iio/adc/at91_adc.c
index 0a793e7cd53e..38d4a910bc52 100644
--- a/drivers/iio/adc/at91_adc.c
+++ b/drivers/iio/adc/at91_adc.c
@@ -616,8 +616,10 @@ static struct iio_trigger *at91_adc_allocate_trigger(struct iio_dev *idev,
 	trig->ops = &at91_adc_trigger_ops;
 
 	ret = iio_trigger_register(trig);
-	if (ret)
+	if (ret) {
+		iio_trigger_free(trig);
 		return NULL;
+	}
 
 	return trig;
 }
diff --git a/drivers/iio/adc/mp2629_adc.c b/drivers/iio/adc/mp2629_adc.c
index 331a9a728217..acd9420c0416 100644
--- a/drivers/iio/adc/mp2629_adc.c
+++ b/drivers/iio/adc/mp2629_adc.c
@@ -56,7 +56,8 @@ static struct iio_map mp2629_adc_maps[] = {
 	MP2629_MAP(SYSTEM_VOLT, "system-volt"),
 	MP2629_MAP(INPUT_VOLT, "input-volt"),
 	MP2629_MAP(BATT_CURRENT, "batt-current"),
-	MP2629_MAP(INPUT_CURRENT, "input-current")
+	MP2629_MAP(INPUT_CURRENT, "input-current"),
+	{ }
 };
 
 static int mp2629_read_raw(struct iio_dev *indio_dev,
@@ -73,7 +74,7 @@ static int mp2629_read_raw(struct iio_dev *indio_dev,
 		if (ret)
 			return ret;
 
-		if (chan->address == MP2629_INPUT_VOLT)
+		if (chan->channel == MP2629_INPUT_VOLT)
 			rval &= GENMASK(6, 0);
 		*val = rval;
 		return IIO_VAL_INT;
diff --git a/drivers/iio/pressure/ms5611_spi.c b/drivers/iio/pressure/ms5611_spi.c
index 45d3a7d5be8e..f7743ee3318f 100644
--- a/drivers/iio/pressure/ms5611_spi.c
+++ b/drivers/iio/pressure/ms5611_spi.c
@@ -94,7 +94,7 @@ static int ms5611_spi_probe(struct spi_device *spi)
 	spi_set_drvdata(spi, indio_dev);
 
 	spi->mode = SPI_MODE_0;
-	spi->max_speed_hz = 20000000;
+	spi->max_speed_hz = min(spi->max_speed_hz, 20000000U);
 	spi->bits_per_word = 8;
 	ret = spi_setup(spi);
 	if (ret < 0)
diff --git a/drivers/iio/trigger/iio-trig-sysfs.c b/drivers/iio/trigger/iio-trig-sysfs.c
index 2277d6336ac0..9ed5b9405ade 100644
--- a/drivers/iio/trigger/iio-trig-sysfs.c
+++ b/drivers/iio/trigger/iio-trig-sysfs.c
@@ -209,9 +209,13 @@ static int iio_sysfs_trigger_remove(int id)
 
 static int __init iio_sysfs_trig_init(void)
 {
+	int ret;
 	device_initialize(&iio_sysfs_trig_dev);
 	dev_set_name(&iio_sysfs_trig_dev, "iio_sysfs_trigger");
-	return device_add(&iio_sysfs_trig_dev);
+	ret = device_add(&iio_sysfs_trig_dev);
+	if (ret)
+		put_device(&iio_sysfs_trig_dev);
+	return ret;
 }
 module_init(iio_sysfs_trig_init);
 
diff --git a/drivers/input/joystick/iforce/iforce-main.c b/drivers/input/joystick/iforce/iforce-main.c
index b86de1312512..84b87526b7ba 100644
--- a/drivers/input/joystick/iforce/iforce-main.c
+++ b/drivers/input/joystick/iforce/iforce-main.c
@@ -273,22 +273,22 @@ int iforce_init_device(struct device *parent, u16 bustype,
  * Get device info.
  */
 
-	if (!iforce_get_id_packet(iforce, 'M', buf, &len) || len < 3)
+	if (!iforce_get_id_packet(iforce, 'M', buf, &len) && len >= 3)
 		input_dev->id.vendor = get_unaligned_le16(buf + 1);
 	else
 		dev_warn(&iforce->dev->dev, "Device does not respond to id packet M\n");
 
-	if (!iforce_get_id_packet(iforce, 'P', buf, &len) || len < 3)
+	if (!iforce_get_id_packet(iforce, 'P', buf, &len) && len >= 3)
 		input_dev->id.product = get_unaligned_le16(buf + 1);
 	else
 		dev_warn(&iforce->dev->dev, "Device does not respond to id packet P\n");
 
-	if (!iforce_get_id_packet(iforce, 'B', buf, &len) || len < 3)
+	if (!iforce_get_id_packet(iforce, 'B', buf, &len) && len >= 3)
 		iforce->device_memory.end = get_unaligned_le16(buf + 1);
 	else
 		dev_warn(&iforce->dev->dev, "Device does not respond to id packet B\n");
 
-	if (!iforce_get_id_packet(iforce, 'N', buf, &len) || len < 2)
+	if (!iforce_get_id_packet(iforce, 'N', buf, &len) && len >= 2)
 		ff_effects = buf[1];
 	else
 		dev_warn(&iforce->dev->dev, "Device does not respond to id packet N\n");
diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
index a9f68f535b72..8648b4c46138 100644
--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -1543,8 +1543,6 @@ static int i8042_probe(struct platform_device *dev)
 {
 	int error;
 
-	i8042_platform_device = dev;
-
 	if (i8042_reset == I8042_RESET_ALWAYS) {
 		error = i8042_controller_selftest();
 		if (error)
@@ -1582,7 +1580,6 @@ static int i8042_probe(struct platform_device *dev)
 	i8042_free_aux_ports();	/* in case KBD failed but AUX not */
 	i8042_free_irqs();
 	i8042_controller_reset(false);
-	i8042_platform_device = NULL;
 
 	return error;
 }
@@ -1592,7 +1589,6 @@ static int i8042_remove(struct platform_device *dev)
 	i8042_unregister_ports();
 	i8042_free_irqs();
 	i8042_controller_reset(false);
-	i8042_platform_device = NULL;
 
 	return 0;
 }
diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index fb911b6c418f..86fd49ae7f61 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -669,7 +669,7 @@ int intel_pasid_setup_second_level(struct intel_iommu *iommu,
 	 * Since it is a second level only translation setup, we should
 	 * set SRE bit as well (addresses are expected to be GPAs).
 	 */
-	if (pasid != PASID_RID2PASID)
+	if (pasid != PASID_RID2PASID && ecap_srs(iommu->ecap))
 		pasid_set_sre(pte);
 	pasid_set_present(pte);
 	pasid_flush_caches(iommu, pte, pasid, did);
@@ -704,7 +704,8 @@ int intel_pasid_setup_pass_through(struct intel_iommu *iommu,
 	 * We should set SRE bit as well since the addresses are expected
 	 * to be GPAs.
 	 */
-	pasid_set_sre(pte);
+	if (ecap_srs(iommu->ecap))
+		pasid_set_sre(pte);
 	pasid_set_present(pte);
 	pasid_flush_caches(iommu, pte, pasid, did);
 
diff --git a/drivers/isdn/mISDN/core.c b/drivers/isdn/mISDN/core.c
index 7ea0100f218a..90ee56d07a6e 100644
--- a/drivers/isdn/mISDN/core.c
+++ b/drivers/isdn/mISDN/core.c
@@ -222,7 +222,7 @@ mISDN_register_device(struct mISDNdevice *dev,
 
 	err = get_free_devid();
 	if (err < 0)
-		goto error1;
+		return err;
 	dev->id = err;
 
 	device_initialize(&dev->dev);
diff --git a/drivers/isdn/mISDN/dsp_pipeline.c b/drivers/isdn/mISDN/dsp_pipeline.c
index c3b2c99b5cd5..cfbcd9e973c2 100644
--- a/drivers/isdn/mISDN/dsp_pipeline.c
+++ b/drivers/isdn/mISDN/dsp_pipeline.c
@@ -77,6 +77,7 @@ int mISDN_dsp_element_register(struct mISDN_dsp_element *elem)
 	if (!entry)
 		return -ENOMEM;
 
+	INIT_LIST_HEAD(&entry->list);
 	entry->elem = elem;
 
 	entry->dev.class = elements_class;
@@ -107,7 +108,7 @@ int mISDN_dsp_element_register(struct mISDN_dsp_element *elem)
 	device_unregister(&entry->dev);
 	return ret;
 err1:
-	kfree(entry);
+	put_device(&entry->dev);
 	return ret;
 }
 EXPORT_SYMBOL(mISDN_dsp_element_register);
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index b839705654d4..20171c9d8952 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -573,7 +573,7 @@ static void list_version_get_needed(struct target_type *tt, void *needed_param)
     size_t *needed = needed_param;
 
     *needed += sizeof(struct dm_target_versions);
-    *needed += strlen(tt->name);
+    *needed += strlen(tt->name) + 1;
     *needed += ALIGN_MASK;
 }
 
@@ -638,7 +638,7 @@ static int __list_versions(struct dm_ioctl *param, size_t param_size, const char
 	iter_info.old_vers = NULL;
 	iter_info.vers = vers;
 	iter_info.flags = 0;
-	iter_info.end = (char *)vers+len;
+	iter_info.end = (char *)vers + needed;
 
 	/*
 	 * Now loop through filling out the names & versions.
diff --git a/drivers/mfd/lpc_ich.c b/drivers/mfd/lpc_ich.c
index 3bbb29a7e7a5..2411b7a2e6f4 100644
--- a/drivers/mfd/lpc_ich.c
+++ b/drivers/mfd/lpc_ich.c
@@ -63,6 +63,8 @@
 #define SPIBASE_BYT		0x54
 #define SPIBASE_BYT_SZ		512
 #define SPIBASE_BYT_EN		BIT(1)
+#define BYT_BCR			0xfc
+#define BYT_BCR_WPD		BIT(0)
 
 #define SPIBASE_LPT		0x3800
 #define SPIBASE_LPT_SZ		512
@@ -1083,12 +1085,57 @@ static int lpc_ich_init_wdt(struct pci_dev *dev)
 	return ret;
 }
 
+static bool lpc_ich_byt_set_writeable(void __iomem *base, void *data)
+{
+	u32 val;
+
+	val = readl(base + BYT_BCR);
+	if (!(val & BYT_BCR_WPD)) {
+		val |= BYT_BCR_WPD;
+		writel(val, base + BYT_BCR);
+		val = readl(base + BYT_BCR);
+	}
+
+	return val & BYT_BCR_WPD;
+}
+
+static bool lpc_ich_lpt_set_writeable(void __iomem *base, void *data)
+{
+	struct pci_dev *pdev = data;
+	u32 bcr;
+
+	pci_read_config_dword(pdev, BCR, &bcr);
+	if (!(bcr & BCR_WPD)) {
+		bcr |= BCR_WPD;
+		pci_write_config_dword(pdev, BCR, bcr);
+		pci_read_config_dword(pdev, BCR, &bcr);
+	}
+
+	return bcr & BCR_WPD;
+}
+
+static bool lpc_ich_bxt_set_writeable(void __iomem *base, void *data)
+{
+	unsigned int spi = PCI_DEVFN(13, 2);
+	struct pci_bus *bus = data;
+	u32 bcr;
+
+	pci_bus_read_config_dword(bus, spi, BCR, &bcr);
+	if (!(bcr & BCR_WPD)) {
+		bcr |= BCR_WPD;
+		pci_bus_write_config_dword(bus, spi, BCR, bcr);
+		pci_bus_read_config_dword(bus, spi, BCR, &bcr);
+	}
+
+	return bcr & BCR_WPD;
+}
+
 static int lpc_ich_init_spi(struct pci_dev *dev)
 {
 	struct lpc_ich_priv *priv = pci_get_drvdata(dev);
 	struct resource *res = &intel_spi_res[0];
 	struct intel_spi_boardinfo *info;
-	u32 spi_base, rcba, bcr;
+	u32 spi_base, rcba;
 
 	info = devm_kzalloc(&dev->dev, sizeof(*info), GFP_KERNEL);
 	if (!info)
@@ -1102,6 +1149,8 @@ static int lpc_ich_init_spi(struct pci_dev *dev)
 		if (spi_base & SPIBASE_BYT_EN) {
 			res->start = spi_base & ~(SPIBASE_BYT_SZ - 1);
 			res->end = res->start + SPIBASE_BYT_SZ - 1;
+
+			info->set_writeable = lpc_ich_byt_set_writeable;
 		}
 		break;
 
@@ -1112,8 +1161,8 @@ static int lpc_ich_init_spi(struct pci_dev *dev)
 			res->start = spi_base + SPIBASE_LPT;
 			res->end = res->start + SPIBASE_LPT_SZ - 1;
 
-			pci_read_config_dword(dev, BCR, &bcr);
-			info->writeable = !!(bcr & BCR_WPD);
+			info->set_writeable = lpc_ich_lpt_set_writeable;
+			info->data = dev;
 		}
 		break;
 
@@ -1134,8 +1183,8 @@ static int lpc_ich_init_spi(struct pci_dev *dev)
 			res->start = spi_base & 0xfffffff0;
 			res->end = res->start + SPIBASE_APL_SZ - 1;
 
-			pci_bus_read_config_dword(bus, spi, BCR, &bcr);
-			info->writeable = !!(bcr & BCR_WPD);
+			info->set_writeable = lpc_ich_bxt_set_writeable;
+			info->data = bus;
 		}
 
 		pci_bus_write_config_byte(bus, p2sb, 0xe1, 0x1);
diff --git a/drivers/misc/vmw_vmci/vmci_queue_pair.c b/drivers/misc/vmw_vmci/vmci_queue_pair.c
index a49782dd903c..d4d388f021cc 100644
--- a/drivers/misc/vmw_vmci/vmci_queue_pair.c
+++ b/drivers/misc/vmw_vmci/vmci_queue_pair.c
@@ -852,6 +852,7 @@ static int qp_notify_peer_local(bool attach, struct vmci_handle handle)
 	u32 context_id = vmci_get_context_id();
 	struct vmci_event_qp ev;
 
+	memset(&ev, 0, sizeof(ev));
 	ev.msg.hdr.dst = vmci_make_handle(context_id, VMCI_EVENT_HANDLER);
 	ev.msg.hdr.src = vmci_make_handle(VMCI_HYPERVISOR_CONTEXT_ID,
 					  VMCI_CONTEXT_RESOURCE_ID);
@@ -1465,6 +1466,7 @@ static int qp_notify_peer(bool attach,
 	 * kernel.
 	 */
 
+	memset(&ev, 0, sizeof(ev));
 	ev.msg.hdr.dst = vmci_make_handle(peer_id, VMCI_EVENT_HANDLER);
 	ev.msg.hdr.src = vmci_make_handle(VMCI_HYPERVISOR_CONTEXT_ID,
 					  VMCI_CONTEXT_RESOURCE_ID);
diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index eb82f6aac951..7d9ec91e081b 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1128,7 +1128,13 @@ u32 mmc_select_voltage(struct mmc_host *host, u32 ocr)
 		mmc_power_cycle(host, ocr);
 	} else {
 		bit = fls(ocr) - 1;
-		ocr &= 3 << bit;
+		/*
+		 * The bit variable represents the highest voltage bit set in
+		 * the OCR register.
+		 * To keep a range of 2 values (e.g. 3.2V/3.3V and 3.3V/3.4V),
+		 * we must shift the mask '3' with (bit - 1).
+		 */
+		ocr &= 3 << (bit - 1);
 		if (bit != host->ios.vdd)
 			dev_warn(mmc_dev(host), "exceeding card's volts\n");
 	}
diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
index 449562122adc..1f1bdd34dd55 100644
--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -1621,14 +1621,14 @@ static int sdhci_esdhc_imx_probe(struct platform_device *pdev)
 	if (imx_data->socdata->flags & ESDHC_FLAG_ERR004536)
 		host->quirks |= SDHCI_QUIRK_BROKEN_ADMA;
 
-	if (host->caps & MMC_CAP_8_BIT_DATA &&
+	if (host->mmc->caps & MMC_CAP_8_BIT_DATA &&
 	    imx_data->socdata->flags & ESDHC_FLAG_HS400)
 		host->quirks2 |= SDHCI_QUIRK2_CAPS_BIT63_FOR_HS400;
 
 	if (imx_data->socdata->flags & ESDHC_FLAG_BROKEN_AUTO_CMD23)
 		host->quirks2 |= SDHCI_QUIRK2_ACMD23_BROKEN;
 
-	if (host->caps & MMC_CAP_8_BIT_DATA &&
+	if (host->mmc->caps & MMC_CAP_8_BIT_DATA &&
 	    imx_data->socdata->flags & ESDHC_FLAG_HS400_ES) {
 		host->mmc->caps2 |= MMC_CAP2_HS400_ES;
 		host->mmc_host_ops.hs400_enhanced_strobe =
diff --git a/drivers/mmc/host/sdhci-pci-core.c b/drivers/mmc/host/sdhci-pci-core.c
index 7eb9a62ee074..8b02fe3916d1 100644
--- a/drivers/mmc/host/sdhci-pci-core.c
+++ b/drivers/mmc/host/sdhci-pci-core.c
@@ -1799,6 +1799,8 @@ static int amd_probe(struct sdhci_pci_chip *chip)
 		}
 	}
 
+	pci_dev_put(smbus_dev);
+
 	if (gen == AMD_CHIPSET_BEFORE_ML || gen == AMD_CHIPSET_CZ)
 		chip->quirks2 |= SDHCI_QUIRK2_CLEAR_TRANSFERMODE_REG_BEFORE_CMD;
 
diff --git a/drivers/mmc/host/sdhci-pci-o2micro.c b/drivers/mmc/host/sdhci-pci-o2micro.c
index 8c357e3b78d7..72234790a310 100644
--- a/drivers/mmc/host/sdhci-pci-o2micro.c
+++ b/drivers/mmc/host/sdhci-pci-o2micro.c
@@ -31,6 +31,7 @@
 #define O2_SD_CAPS		0xE0
 #define O2_SD_ADMA1		0xE2
 #define O2_SD_ADMA2		0xE7
+#define O2_SD_MISC_CTRL2	0xF0
 #define O2_SD_INF_MOD		0xF1
 #define O2_SD_MISC_CTRL4	0xFC
 #define O2_SD_MISC_CTRL		0x1C0
@@ -822,6 +823,12 @@ static int sdhci_pci_o2_probe(struct sdhci_pci_chip *chip)
 		/* Set Tuning Windows to 5 */
 		pci_write_config_byte(chip->pdev,
 				O2_SD_TUNING_CTRL, 0x55);
+		//Adjust 1st and 2nd CD debounce time
+		pci_read_config_dword(chip->pdev, O2_SD_MISC_CTRL2, &scratch_32);
+		scratch_32 &= 0xFFE7FFFF;
+		scratch_32 |= 0x00180000;
+		pci_write_config_dword(chip->pdev, O2_SD_MISC_CTRL2, scratch_32);
+		pci_write_config_dword(chip->pdev, O2_SD_DETECT_SETTING, 1);
 		/* Lock WP */
 		ret = pci_read_config_byte(chip->pdev,
 					   O2_SD_LOCK_WP, &scratch);
diff --git a/drivers/mtd/spi-nor/controllers/intel-spi-pci.c b/drivers/mtd/spi-nor/controllers/intel-spi-pci.c
index 555fe55d14ae..8a3c1f3c2d2e 100644
--- a/drivers/mtd/spi-nor/controllers/intel-spi-pci.c
+++ b/drivers/mtd/spi-nor/controllers/intel-spi-pci.c
@@ -16,12 +16,30 @@
 #define BCR		0xdc
 #define BCR_WPD		BIT(0)
 
+static bool intel_spi_pci_set_writeable(void __iomem *base, void *data)
+{
+	struct pci_dev *pdev = data;
+	u32 bcr;
+
+	/* Try to make the chip read/write */
+	pci_read_config_dword(pdev, BCR, &bcr);
+	if (!(bcr & BCR_WPD)) {
+		bcr |= BCR_WPD;
+		pci_write_config_dword(pdev, BCR, bcr);
+		pci_read_config_dword(pdev, BCR, &bcr);
+	}
+
+	return bcr & BCR_WPD;
+}
+
 static const struct intel_spi_boardinfo bxt_info = {
 	.type = INTEL_SPI_BXT,
+	.set_writeable = intel_spi_pci_set_writeable,
 };
 
 static const struct intel_spi_boardinfo cnl_info = {
 	.type = INTEL_SPI_CNL,
+	.set_writeable = intel_spi_pci_set_writeable,
 };
 
 static int intel_spi_pci_probe(struct pci_dev *pdev,
@@ -29,7 +47,6 @@ static int intel_spi_pci_probe(struct pci_dev *pdev,
 {
 	struct intel_spi_boardinfo *info;
 	struct intel_spi *ispi;
-	u32 bcr;
 	int ret;
 
 	ret = pcim_enable_device(pdev);
@@ -41,15 +58,7 @@ static int intel_spi_pci_probe(struct pci_dev *pdev,
 	if (!info)
 		return -ENOMEM;
 
-	/* Try to make the chip read/write */
-	pci_read_config_dword(pdev, BCR, &bcr);
-	if (!(bcr & BCR_WPD)) {
-		bcr |= BCR_WPD;
-		pci_write_config_dword(pdev, BCR, bcr);
-		pci_read_config_dword(pdev, BCR, &bcr);
-	}
-	info->writeable = !!(bcr & BCR_WPD);
-
+	info->data = pdev;
 	ispi = intel_spi_probe(&pdev->dev, &pdev->resource[0], info);
 	if (IS_ERR(ispi))
 		return PTR_ERR(ispi);
diff --git a/drivers/mtd/spi-nor/controllers/intel-spi.c b/drivers/mtd/spi-nor/controllers/intel-spi.c
index b54a56a68100..6c802db6b4af 100644
--- a/drivers/mtd/spi-nor/controllers/intel-spi.c
+++ b/drivers/mtd/spi-nor/controllers/intel-spi.c
@@ -53,17 +53,17 @@
 #define FRACC				0x50
 
 #define FREG(n)				(0x54 + ((n) * 4))
-#define FREG_BASE_MASK			0x3fff
+#define FREG_BASE_MASK			GENMASK(14, 0)
 #define FREG_LIMIT_SHIFT		16
-#define FREG_LIMIT_MASK			(0x03fff << FREG_LIMIT_SHIFT)
+#define FREG_LIMIT_MASK			GENMASK(30, 16)
 
 /* Offset is from @ispi->pregs */
 #define PR(n)				((n) * 4)
 #define PR_WPE				BIT(31)
 #define PR_LIMIT_SHIFT			16
-#define PR_LIMIT_MASK			(0x3fff << PR_LIMIT_SHIFT)
+#define PR_LIMIT_MASK			GENMASK(30, 16)
 #define PR_RPE				BIT(15)
-#define PR_BASE_MASK			0x3fff
+#define PR_BASE_MASK			GENMASK(14, 0)
 
 /* Offsets are from @ispi->sregs */
 #define SSFSTS_CTL			0x00
@@ -117,7 +117,7 @@
 #define ERASE_OPCODE_SHIFT		8
 #define ERASE_OPCODE_MASK		(0xff << ERASE_OPCODE_SHIFT)
 #define ERASE_64K_OPCODE_SHIFT		16
-#define ERASE_64K_OPCODE_MASK		(0xff << ERASE_OPCODE_SHIFT)
+#define ERASE_64K_OPCODE_MASK		(0xff << ERASE_64K_OPCODE_SHIFT)
 
 #define INTEL_SPI_TIMEOUT		5000 /* ms */
 #define INTEL_SPI_FIFO_SZ		64
@@ -132,7 +132,6 @@
  * @sregs: Start of software sequencer registers
  * @nregions: Maximum number of regions
  * @pr_num: Maximum number of protected range registers
- * @writeable: Is the chip writeable
  * @locked: Is SPI setting locked
  * @swseq_reg: Use SW sequencer in register reads/writes
  * @swseq_erase: Use SW sequencer in erase operation
@@ -150,7 +149,6 @@ struct intel_spi {
 	void __iomem *sregs;
 	size_t nregions;
 	size_t pr_num;
-	bool writeable;
 	bool locked;
 	bool swseq_reg;
 	bool swseq_erase;
@@ -305,6 +303,14 @@ static int intel_spi_wait_sw_busy(struct intel_spi *ispi)
 				  INTEL_SPI_TIMEOUT * 1000);
 }
 
+static bool intel_spi_set_writeable(struct intel_spi *ispi)
+{
+	if (!ispi->info->set_writeable)
+		return false;
+
+	return ispi->info->set_writeable(ispi->base, ispi->info->data);
+}
+
 static int intel_spi_init(struct intel_spi *ispi)
 {
 	u32 opmenu0, opmenu1, lvscc, uvscc, val;
@@ -317,19 +323,6 @@ static int intel_spi_init(struct intel_spi *ispi)
 		ispi->nregions = BYT_FREG_NUM;
 		ispi->pr_num = BYT_PR_NUM;
 		ispi->swseq_reg = true;
-
-		if (writeable) {
-			/* Disable write protection */
-			val = readl(ispi->base + BYT_BCR);
-			if (!(val & BYT_BCR_WPD)) {
-				val |= BYT_BCR_WPD;
-				writel(val, ispi->base + BYT_BCR);
-				val = readl(ispi->base + BYT_BCR);
-			}
-
-			ispi->writeable = !!(val & BYT_BCR_WPD);
-		}
-
 		break;
 
 	case INTEL_SPI_LPT:
@@ -359,6 +352,12 @@ static int intel_spi_init(struct intel_spi *ispi)
 		return -EINVAL;
 	}
 
+	/* Try to disable write protection if user asked to do so */
+	if (writeable && !intel_spi_set_writeable(ispi)) {
+		dev_warn(ispi->dev, "can't disable chip write protection\n");
+		writeable = false;
+	}
+
 	/* Disable #SMI generation from HW sequencer */
 	val = readl(ispi->base + HSFSTS_CTL);
 	val &= ~HSFSTS_CTL_FSMIE;
@@ -885,9 +884,12 @@ static void intel_spi_fill_partition(struct intel_spi *ispi,
 		/*
 		 * If any of the regions have protection bits set, make the
 		 * whole partition read-only to be on the safe side.
+		 *
+		 * Also if the user did not ask the chip to be writeable
+		 * mask the bit too.
 		 */
-		if (intel_spi_is_protected(ispi, base, limit))
-			ispi->writeable = false;
+		if (!writeable || intel_spi_is_protected(ispi, base, limit))
+			part->mask_flags |= MTD_WRITEABLE;
 
 		end = (limit << 12) + 4096;
 		if (end > part->size)
@@ -928,7 +930,6 @@ struct intel_spi *intel_spi_probe(struct device *dev,
 
 	ispi->dev = dev;
 	ispi->info = info;
-	ispi->writeable = info->writeable;
 
 	ret = intel_spi_init(ispi);
 	if (ret)
@@ -946,10 +947,6 @@ struct intel_spi *intel_spi_probe(struct device *dev,
 
 	intel_spi_fill_partition(ispi, &part);
 
-	/* Prevent writes if not explicitly enabled */
-	if (!ispi->writeable || !writeable)
-		ispi->nor.mtd.flags &= ~MTD_WRITEABLE;
-
 	ret = mtd_device_register(&ispi->nor.mtd, &part, 1);
 	if (ret)
 		return ERR_PTR(ret);
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 52414ac2c901..1722d4091ea3 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -4488,13 +4488,19 @@ static struct pci_driver ena_pci_driver = {
 
 static int __init ena_init(void)
 {
+	int ret;
+
 	ena_wq = create_singlethread_workqueue(DRV_MODULE_NAME);
 	if (!ena_wq) {
 		pr_err("Failed to create workqueue\n");
 		return -ENOMEM;
 	}
 
-	return pci_register_driver(&ena_pci_driver);
+	ret = pci_register_driver(&ena_pci_driver);
+	if (ret)
+		destroy_workqueue(ena_wq);
+
+	return ret;
 }
 
 static void __exit ena_cleanup(void)
diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
index c26c9b0c00d8..fe3ca3af431a 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -1468,7 +1468,7 @@ static int ag71xx_open(struct net_device *ndev)
 	if (ret) {
 		netif_err(ag, link, ndev, "phylink_of_phy_connect filed with err: %i\n",
 			  ret);
-		goto err;
+		return ret;
 	}
 
 	max_frame_len = ag71xx_max_frame_len(ndev->mtu);
@@ -1489,6 +1489,7 @@ static int ag71xx_open(struct net_device *ndev)
 
 err:
 	ag71xx_rings_cleanup(ag);
+	phylink_disconnect_phy(ag->phylink);
 	return ret;
 }
 
diff --git a/drivers/net/ethernet/broadcom/Kconfig b/drivers/net/ethernet/broadcom/Kconfig
index 2b6d929d462f..7b79528d6eed 100644
--- a/drivers/net/ethernet/broadcom/Kconfig
+++ b/drivers/net/ethernet/broadcom/Kconfig
@@ -69,7 +69,7 @@ config BCMGENET
 	select BCM7XXX_PHY
 	select MDIO_BCM_UNIMAC
 	select DIMLIB
-	select BROADCOM_PHY if (ARCH_BCM2835 && PTP_1588_CLOCK_OPTIONAL)
+	select BROADCOM_PHY if ARCH_BCM2835
 	help
 	  This driver supports the built-in Ethernet MACs found in the
 	  Broadcom BCM7xxx Set Top Box family chipset.
diff --git a/drivers/net/ethernet/broadcom/bgmac.c b/drivers/net/ethernet/broadcom/bgmac.c
index 6290d8bedc92..9960127f612e 100644
--- a/drivers/net/ethernet/broadcom/bgmac.c
+++ b/drivers/net/ethernet/broadcom/bgmac.c
@@ -1568,7 +1568,6 @@ void bgmac_enet_remove(struct bgmac *bgmac)
 	phy_disconnect(bgmac->net_dev->phydev);
 	netif_napi_del(&bgmac->napi);
 	bgmac_dma_free(bgmac);
-	free_netdev(bgmac->net_dev);
 }
 EXPORT_SYMBOL_GPL(bgmac_enet_remove);
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 8311473d537b..92f54e333395 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -13111,8 +13111,16 @@ static struct pci_driver bnxt_pci_driver = {
 
 static int __init bnxt_init(void)
 {
+	int err;
+
 	bnxt_debug_init();
-	return pci_register_driver(&bnxt_pci_driver);
+	err = pci_register_driver(&bnxt_pci_driver);
+	if (err) {
+		bnxt_debug_exit();
+		return err;
+	}
+
+	return 0;
 }
 
 static void __exit bnxt_exit(void)
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index e0d18e917108..c4dc6e2ccd6b 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -1798,13 +1798,10 @@ static int liquidio_open(struct net_device *netdev)
 
 	ifstate_set(lio, LIO_IFSTATE_RUNNING);
 
-	if (OCTEON_CN23XX_PF(oct)) {
-		if (!oct->msix_on)
-			if (setup_tx_poll_fn(netdev))
-				return -1;
-	} else {
-		if (setup_tx_poll_fn(netdev))
-			return -1;
+	if (!OCTEON_CN23XX_PF(oct) || (OCTEON_CN23XX_PF(oct) && !oct->msix_on)) {
+		ret = setup_tx_poll_fn(netdev);
+		if (ret)
+			goto err_poll;
 	}
 
 	netif_tx_start_all_queues(netdev);
@@ -1817,7 +1814,7 @@ static int liquidio_open(struct net_device *netdev)
 	/* tell Octeon to start forwarding packets to host */
 	ret = send_rx_ctrl_cmd(lio, 1);
 	if (ret)
-		return ret;
+		goto err_rx_ctrl;
 
 	/* start periodical statistics fetch */
 	INIT_DELAYED_WORK(&lio->stats_wk.work, lio_fetch_stats);
@@ -1828,6 +1825,27 @@ static int liquidio_open(struct net_device *netdev)
 	dev_info(&oct->pci_dev->dev, "%s interface is opened\n",
 		 netdev->name);
 
+	return 0;
+
+err_rx_ctrl:
+	if (!OCTEON_CN23XX_PF(oct) || (OCTEON_CN23XX_PF(oct) && !oct->msix_on))
+		cleanup_tx_poll_fn(netdev);
+err_poll:
+	if (lio->ptp_clock) {
+		ptp_clock_unregister(lio->ptp_clock);
+		lio->ptp_clock = NULL;
+	}
+
+	if (oct->props[lio->ifidx].napi_enabled == 1) {
+		list_for_each_entry_safe(napi, n, &netdev->napi_list, dev_list)
+			napi_disable(napi);
+
+		oct->props[lio->ifidx].napi_enabled = 0;
+
+		if (OCTEON_CN23XX_PF(oct))
+			oct->droq[0]->ops.poll_mode = 0;
+	}
+
 	return ret;
 }
 
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index 4f1d585485d7..6ec042d48cd1 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -1502,8 +1502,15 @@ static struct pci_driver hinic_driver = {
 
 static int __init hinic_module_init(void)
 {
+	int ret;
+
 	hinic_dbg_register_debugfs(HINIC_DRV_NAME);
-	return pci_register_driver(&hinic_driver);
+
+	ret = pci_register_driver(&hinic_driver);
+	if (ret)
+		hinic_dbg_unregister_debugfs();
+
+	return ret;
 }
 
 static void __exit hinic_module_exit(void)
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index f60ffef33e0c..00b6985edea0 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -569,8 +569,14 @@ int ionic_port_reset(struct ionic *ionic)
 
 static int __init ionic_init_module(void)
 {
+	int ret;
+
 	ionic_debugfs_create();
-	return ionic_bus_register_driver();
+	ret = ionic_bus_register_driver();
+	if (ret)
+		ionic_debugfs_destroy();
+
+	return ret;
 }
 
 static void __exit ionic_cleanup_module(void)
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 6b269a72388b..5869bc2c3aa7 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -139,7 +139,7 @@ static struct macvlan_source_entry *macvlan_hash_lookup_source(
 	u32 idx = macvlan_eth_hash(addr);
 	struct hlist_head *h = &vlan->port->vlan_source_hash[idx];
 
-	hlist_for_each_entry_rcu(entry, h, hlist) {
+	hlist_for_each_entry_rcu(entry, h, hlist, lockdep_rtnl_is_held()) {
 		if (ether_addr_equal_64bits(entry->addr, addr) &&
 		    entry->vlan == vlan)
 			return entry;
@@ -1176,7 +1176,7 @@ void macvlan_common_setup(struct net_device *dev)
 {
 	ether_setup(dev);
 
-	dev->min_mtu		= 0;
+	/* ether_setup() has set dev->min_mtu to ETH_MIN_MTU. */
 	dev->max_mtu		= ETH_MAX_MTU;
 	dev->priv_flags	       &= ~IFF_TX_SKB_SHARING;
 	netif_keep_dst(dev);
@@ -1614,7 +1614,7 @@ static int macvlan_fill_info_macaddr(struct sk_buff *skb,
 	struct hlist_head *h = &vlan->port->vlan_source_hash[i];
 	struct macvlan_source_entry *entry;
 
-	hlist_for_each_entry_rcu(entry, h, hlist) {
+	hlist_for_each_entry_rcu(entry, h, hlist, lockdep_rtnl_is_held()) {
 		if (entry->vlan != vlan)
 			continue;
 		if (nla_put(skb, IFLA_MACVLAN_MACADDR, ETH_ALEN, entry->addr))
diff --git a/drivers/net/thunderbolt.c b/drivers/net/thunderbolt.c
index 3160443ef3b9..5d96dc1b00b3 100644
--- a/drivers/net/thunderbolt.c
+++ b/drivers/net/thunderbolt.c
@@ -1343,12 +1343,21 @@ static int __init tbnet_init(void)
 				  TBNET_MATCH_FRAGS_ID);
 
 	ret = tb_register_property_dir("network", tbnet_dir);
-	if (ret) {
-		tb_property_free_dir(tbnet_dir);
-		return ret;
-	}
+	if (ret)
+		goto err_free_dir;
+
+	ret = tb_register_service_driver(&tbnet_driver);
+	if (ret)
+		goto err_unregister;
 
-	return tb_register_service_driver(&tbnet_driver);
+	return 0;
+
+err_unregister:
+	tb_unregister_property_dir("network", tbnet_dir);
+err_free_dir:
+	tb_property_free_dir(tbnet_dir);
+
+	return ret;
 }
 module_init(tbnet_init);
 
diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index 65d42f5d42a3..e1cd4c2de2d3 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -61,6 +61,7 @@ struct smsc95xx_priv {
 	u8 suspend_flags;
 	struct mii_bus *mdiobus;
 	struct phy_device *phydev;
+	struct task_struct *pm_task;
 };
 
 static bool turbo_mode = true;
@@ -70,13 +71,14 @@ MODULE_PARM_DESC(turbo_mode, "Enable multiple frames per Rx transaction");
 static int __must_check __smsc95xx_read_reg(struct usbnet *dev, u32 index,
 					    u32 *data, int in_pm)
 {
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 	u32 buf;
 	int ret;
 	int (*fn)(struct usbnet *, u8, u8, u16, u16, void *, u16);
 
 	BUG_ON(!dev);
 
-	if (!in_pm)
+	if (current != pdata->pm_task)
 		fn = usbnet_read_cmd;
 	else
 		fn = usbnet_read_cmd_nopm;
@@ -100,13 +102,14 @@ static int __must_check __smsc95xx_read_reg(struct usbnet *dev, u32 index,
 static int __must_check __smsc95xx_write_reg(struct usbnet *dev, u32 index,
 					     u32 data, int in_pm)
 {
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 	u32 buf;
 	int ret;
 	int (*fn)(struct usbnet *, u8, u8, u16, u16, const void *, u16);
 
 	BUG_ON(!dev);
 
-	if (!in_pm)
+	if (current != pdata->pm_task)
 		fn = usbnet_write_cmd;
 	else
 		fn = usbnet_write_cmd_nopm;
@@ -1468,9 +1471,12 @@ static int smsc95xx_suspend(struct usb_interface *intf, pm_message_t message)
 	u32 val, link_up;
 	int ret;
 
+	pdata->pm_task = current;
+
 	ret = usbnet_suspend(intf, message);
 	if (ret < 0) {
 		netdev_warn(dev->net, "usbnet_suspend error\n");
+		pdata->pm_task = NULL;
 		return ret;
 	}
 
@@ -1717,6 +1723,7 @@ static int smsc95xx_suspend(struct usb_interface *intf, pm_message_t message)
 	if (ret && PMSG_IS_AUTO(message))
 		usbnet_resume(intf);
 
+	pdata->pm_task = NULL;
 	return ret;
 }
 
@@ -1737,29 +1744,31 @@ static int smsc95xx_resume(struct usb_interface *intf)
 	/* do this first to ensure it's cleared even in error case */
 	pdata->suspend_flags = 0;
 
+	pdata->pm_task = current;
+
 	if (suspend_flags & SUSPEND_ALLMODES) {
 		/* clear wake-up sources */
 		ret = smsc95xx_read_reg_nopm(dev, WUCSR, &val);
 		if (ret < 0)
-			return ret;
+			goto done;
 
 		val &= ~(WUCSR_WAKE_EN_ | WUCSR_MPEN_);
 
 		ret = smsc95xx_write_reg_nopm(dev, WUCSR, val);
 		if (ret < 0)
-			return ret;
+			goto done;
 
 		/* clear wake-up status */
 		ret = smsc95xx_read_reg_nopm(dev, PM_CTRL, &val);
 		if (ret < 0)
-			return ret;
+			goto done;
 
 		val &= ~PM_CTL_WOL_EN_;
 		val |= PM_CTL_WUPS_;
 
 		ret = smsc95xx_write_reg_nopm(dev, PM_CTRL, val);
 		if (ret < 0)
-			return ret;
+			goto done;
 	}
 
 	ret = usbnet_resume(intf);
@@ -1767,15 +1776,21 @@ static int smsc95xx_resume(struct usb_interface *intf)
 		netdev_warn(dev->net, "usbnet_resume error\n");
 
 	phy_init_hw(pdata->phydev);
+
+done:
+	pdata->pm_task = NULL;
 	return ret;
 }
 
 static int smsc95xx_reset_resume(struct usb_interface *intf)
 {
 	struct usbnet *dev = usb_get_intfdata(intf);
+	struct smsc95xx_priv *pdata = dev->driver_priv;
 	int ret;
 
+	pdata->pm_task = current;
 	ret = smsc95xx_reset(dev);
+	pdata->pm_task = NULL;
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 3f106771d15b..d9c78fe85cb3 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3330,11 +3330,17 @@ static long nvme_dev_ioctl(struct file *file, unsigned int cmd,
 	case NVME_IOCTL_IO_CMD:
 		return nvme_dev_user_cmd(ctrl, argp);
 	case NVME_IOCTL_RESET:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EACCES;
 		dev_warn(ctrl->device, "resetting controller\n");
 		return nvme_reset_ctrl_sync(ctrl);
 	case NVME_IOCTL_SUBSYS_RESET:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EACCES;
 		return nvme_reset_subsystem(ctrl);
 	case NVME_IOCTL_RESCAN:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EACCES;
 		nvme_queue_scan(ctrl);
 		return 0;
 	default:
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index abae7ef2ac51..86336496c65c 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -544,11 +544,23 @@ static inline void nvme_fault_inject_fini(struct nvme_fault_inject *fault_inj)
 static inline void nvme_should_fail(struct request *req) {}
 #endif
 
+bool nvme_wait_reset(struct nvme_ctrl *ctrl);
+int nvme_try_sched_reset(struct nvme_ctrl *ctrl);
+
 static inline int nvme_reset_subsystem(struct nvme_ctrl *ctrl)
 {
+	int ret;
+
 	if (!ctrl->subsystem)
 		return -ENOTTY;
-	return ctrl->ops->reg_write32(ctrl, NVME_REG_NSSR, 0x4E564D65);
+	if (!nvme_wait_reset(ctrl))
+		return -EBUSY;
+
+	ret = ctrl->ops->reg_write32(ctrl, NVME_REG_NSSR, 0x4E564D65);
+	if (ret)
+		return ret;
+
+	return nvme_try_sched_reset(ctrl);
 }
 
 /*
@@ -635,7 +647,6 @@ void nvme_cancel_tagset(struct nvme_ctrl *ctrl);
 void nvme_cancel_admin_tagset(struct nvme_ctrl *ctrl);
 bool nvme_change_ctrl_state(struct nvme_ctrl *ctrl,
 		enum nvme_ctrl_state new_state);
-bool nvme_wait_reset(struct nvme_ctrl *ctrl);
 int nvme_disable_ctrl(struct nvme_ctrl *ctrl);
 int nvme_enable_ctrl(struct nvme_ctrl *ctrl);
 int nvme_shutdown_ctrl(struct nvme_ctrl *ctrl);
@@ -688,7 +699,6 @@ int nvme_set_queue_count(struct nvme_ctrl *ctrl, int *count);
 void nvme_stop_keep_alive(struct nvme_ctrl *ctrl);
 int nvme_reset_ctrl(struct nvme_ctrl *ctrl);
 int nvme_reset_ctrl_sync(struct nvme_ctrl *ctrl);
-int nvme_try_sched_reset(struct nvme_ctrl *ctrl);
 int nvme_delete_ctrl(struct nvme_ctrl *ctrl);
 
 int nvme_get_log(struct nvme_ctrl *ctrl, u32 nsid, u8 log_page, u8 lsp, u8 csi,
diff --git a/drivers/parport/parport_pc.c b/drivers/parport/parport_pc.c
index eda4ded4d5e5..925be41eeebe 100644
--- a/drivers/parport/parport_pc.c
+++ b/drivers/parport/parport_pc.c
@@ -468,7 +468,7 @@ static size_t parport_pc_fifo_write_block_pio(struct parport *port,
 	const unsigned char *bufp = buf;
 	size_t left = length;
 	unsigned long expire = jiffies + port->physport->cad->timeout;
-	const int fifo = FIFO(port);
+	const unsigned long fifo = FIFO(port);
 	int poll_for = 8; /* 80 usecs */
 	const struct parport_pc_private *priv = port->physport->private_data;
 	const int fifo_depth = priv->fifo_depth;
diff --git a/drivers/pinctrl/devicetree.c b/drivers/pinctrl/devicetree.c
index 3fb238714718..eac55fee5281 100644
--- a/drivers/pinctrl/devicetree.c
+++ b/drivers/pinctrl/devicetree.c
@@ -220,6 +220,8 @@ int pinctrl_dt_to_map(struct pinctrl *p, struct pinctrl_dev *pctldev)
 	for (state = 0; ; state++) {
 		/* Retrieve the pinctrl-* property */
 		propname = kasprintf(GFP_KERNEL, "pinctrl-%d", state);
+		if (!propname)
+			return -ENOMEM;
 		prop = of_find_property(np, propname, &size);
 		kfree(propname);
 		if (!prop) {
diff --git a/drivers/platform/x86/intel_pmc_core_pltdrv.c b/drivers/platform/x86/intel_pmc_core_pltdrv.c
index 15ca8afdd973..ddfba38c2104 100644
--- a/drivers/platform/x86/intel_pmc_core_pltdrv.c
+++ b/drivers/platform/x86/intel_pmc_core_pltdrv.c
@@ -18,6 +18,8 @@
 #include <asm/cpu_device_id.h>
 #include <asm/intel-family.h>
 
+#include <xen/xen.h>
+
 static void intel_pmc_core_release(struct device *dev)
 {
 	kfree(dev);
@@ -53,6 +55,13 @@ static int __init pmc_core_platform_init(void)
 	if (acpi_dev_present("INT33A1", NULL, -1))
 		return -ENODEV;
 
+	/*
+	 * Skip forcefully attaching the device for VMs. Make an exception for
+	 * Xen dom0, which does have full hardware access.
+	 */
+	if (cpu_feature_enabled(X86_FEATURE_HYPERVISOR) && !xen_initial_domain())
+		return -ENODEV;
+
 	if (!x86_match_cpu(intel_pmc_core_platform_ids))
 		return -ENODEV;
 
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 8401c42db541..524947bf21b9 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -866,7 +866,7 @@ static int zfcp_fsf_req_send(struct zfcp_fsf_req *req)
 	const bool is_srb = zfcp_fsf_req_is_status_read_buffer(req);
 	struct zfcp_adapter *adapter = req->adapter;
 	struct zfcp_qdio *qdio = adapter->qdio;
-	int req_id = req->req_id;
+	unsigned long req_id = req->req_id;
 
 	zfcp_reqlist_add(adapter->req_list, req);
 
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 5eb959b5f701..261b915835b4 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -7079,8 +7079,12 @@ static int sdebug_add_host_helper(int per_host_idx)
 	dev_set_name(&sdbg_host->dev, "adapter%d", sdebug_num_hosts);
 
 	error = device_register(&sdbg_host->dev);
-	if (error)
+	if (error) {
+		spin_lock(&sdebug_host_list_lock);
+		list_del(&sdbg_host->host_list);
+		spin_unlock(&sdebug_host_list_lock);
 		goto clean;
+	}
 
 	++sdebug_num_hosts;
 	return 0;
diff --git a/drivers/siox/siox-core.c b/drivers/siox/siox-core.c
index f8c08fb9891d..e0ffef6e9386 100644
--- a/drivers/siox/siox-core.c
+++ b/drivers/siox/siox-core.c
@@ -835,6 +835,8 @@ static struct siox_device *siox_device_add(struct siox_master *smaster,
 
 err_device_register:
 	/* don't care to make the buffer smaller again */
+	put_device(&sdevice->dev);
+	sdevice = NULL;
 
 err_buf_alloc:
 	siox_master_unlock(smaster);
diff --git a/drivers/slimbus/stream.c b/drivers/slimbus/stream.c
index 75f87b3d8b95..73a2aa362957 100644
--- a/drivers/slimbus/stream.c
+++ b/drivers/slimbus/stream.c
@@ -67,10 +67,10 @@ static const int slim_presence_rate_table[] = {
 	384000,
 	768000,
 	0, /* Reserved */
-	110250,
-	220500,
-	441000,
-	882000,
+	11025,
+	22050,
+	44100,
+	88200,
 	176400,
 	352800,
 	705600,
diff --git a/drivers/spi/spi-stm32.c b/drivers/spi/spi-stm32.c
index a6dfc8fef20c..651a6510fb54 100644
--- a/drivers/spi/spi-stm32.c
+++ b/drivers/spi/spi-stm32.c
@@ -941,6 +941,7 @@ static irqreturn_t stm32h7_spi_irq_thread(int irq, void *dev_id)
 		static DEFINE_RATELIMIT_STATE(rs,
 					      DEFAULT_RATELIMIT_INTERVAL * 10,
 					      1);
+		ratelimit_set_flags(&rs, RATELIMIT_MSG_ON_RELEASE);
 		if (__ratelimit(&rs))
 			dev_dbg_ratelimited(spi->dev, "Communication suspended\n");
 		if (!spi->cur_usedma && (spi->rx_buf && (spi->rx_len > 0)))
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 16d5a4e117a2..5ae5d94c5b93 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -394,6 +394,7 @@ static int tcm_loop_setup_hba_bus(struct tcm_loop_hba *tl_hba, int tcm_loop_host
 	ret = device_register(&tl_hba->dev);
 	if (ret) {
 		pr_err("device_register() failed for tl_hba->dev: %d\n", ret);
+		put_device(&tl_hba->dev);
 		return -ENODEV;
 	}
 
@@ -1072,7 +1073,7 @@ static struct se_wwn *tcm_loop_make_scsi_hba(
 	 */
 	ret = tcm_loop_setup_hba_bus(tl_hba, tcm_loop_hba_no_cnt);
 	if (ret)
-		goto out;
+		return ERR_PTR(ret);
 
 	sh = tl_hba->sh;
 	tcm_loop_hba_no_cnt++;
diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index c91a3004931f..e85282825973 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -1416,7 +1416,7 @@ static struct gsm_control *gsm_control_send(struct gsm_mux *gsm,
 		unsigned int command, u8 *data, int clen)
 {
 	struct gsm_control *ctrl = kzalloc(sizeof(struct gsm_control),
-						GFP_KERNEL);
+						GFP_ATOMIC);
 	unsigned long flags;
 	if (ctrl == NULL)
 		return NULL;
diff --git a/drivers/tty/serial/8250/8250_lpss.c b/drivers/tty/serial/8250/8250_lpss.c
index dfb730b7ea2a..1349c161c192 100644
--- a/drivers/tty/serial/8250/8250_lpss.c
+++ b/drivers/tty/serial/8250/8250_lpss.c
@@ -268,8 +268,13 @@ static int lpss8250_dma_setup(struct lpss8250 *lpss, struct uart_8250_port *port
 	struct dw_dma_slave *rx_param, *tx_param;
 	struct device *dev = port->port.dev;
 
-	if (!lpss->dma_param.dma_dev)
+	if (!lpss->dma_param.dma_dev) {
+		dma = port->dma;
+		if (dma)
+			goto out_configuration_only;
+
 		return 0;
+	}
 
 	rx_param = devm_kzalloc(dev, sizeof(*rx_param), GFP_KERNEL);
 	if (!rx_param)
@@ -280,16 +285,18 @@ static int lpss8250_dma_setup(struct lpss8250 *lpss, struct uart_8250_port *port
 		return -ENOMEM;
 
 	*rx_param = lpss->dma_param;
-	dma->rxconf.src_maxburst = lpss->dma_maxburst;
-
 	*tx_param = lpss->dma_param;
-	dma->txconf.dst_maxburst = lpss->dma_maxburst;
 
 	dma->fn = lpss8250_dma_filter;
 	dma->rx_param = rx_param;
 	dma->tx_param = tx_param;
 
 	port->dma = dma;
+
+out_configuration_only:
+	dma->rxconf.src_maxburst = lpss->dma_maxburst;
+	dma->txconf.dst_maxburst = lpss->dma_maxburst;
+
 	return 0;
 }
 
diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
index f3744ac805ec..3f7379f16a36 100644
--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -157,7 +157,11 @@ static u32 uart_read(struct uart_8250_port *up, u32 reg)
 	return readl(up->port.membase + (reg << up->port.regshift));
 }
 
-static void omap8250_set_mctrl(struct uart_port *port, unsigned int mctrl)
+/*
+ * Called on runtime PM resume path from omap8250_restore_regs(), and
+ * omap8250_set_mctrl().
+ */
+static void __omap8250_set_mctrl(struct uart_port *port, unsigned int mctrl)
 {
 	struct uart_8250_port *up = up_to_u8250p(port);
 	struct omap8250_priv *priv = up->port.private_data;
@@ -181,6 +185,20 @@ static void omap8250_set_mctrl(struct uart_port *port, unsigned int mctrl)
 	}
 }
 
+static void omap8250_set_mctrl(struct uart_port *port, unsigned int mctrl)
+{
+	int err;
+
+	err = pm_runtime_resume_and_get(port->dev);
+	if (err)
+		return;
+
+	__omap8250_set_mctrl(port, mctrl);
+
+	pm_runtime_mark_last_busy(port->dev);
+	pm_runtime_put_autosuspend(port->dev);
+}
+
 /*
  * Work Around for Errata i202 (2430, 3430, 3630, 4430 and 4460)
  * The access to uart register after MDR1 Access
@@ -193,27 +211,10 @@ static void omap8250_set_mctrl(struct uart_port *port, unsigned int mctrl)
 static void omap_8250_mdr1_errataset(struct uart_8250_port *up,
 				     struct omap8250_priv *priv)
 {
-	u8 timeout = 255;
-
 	serial_out(up, UART_OMAP_MDR1, priv->mdr1);
 	udelay(2);
 	serial_out(up, UART_FCR, up->fcr | UART_FCR_CLEAR_XMIT |
 			UART_FCR_CLEAR_RCVR);
-	/*
-	 * Wait for FIFO to empty: when empty, RX_FIFO_E bit is 0 and
-	 * TX_FIFO_E bit is 1.
-	 */
-	while (UART_LSR_THRE != (serial_in(up, UART_LSR) &
-				(UART_LSR_THRE | UART_LSR_DR))) {
-		timeout--;
-		if (!timeout) {
-			/* Should *never* happen. we warn and carry on */
-			dev_crit(up->port.dev, "Errata i202: timedout %x\n",
-				 serial_in(up, UART_LSR));
-			break;
-		}
-		udelay(1);
-	}
 }
 
 static void omap_8250_get_divisor(struct uart_port *port, unsigned int baud,
@@ -341,7 +342,7 @@ static void omap8250_restore_regs(struct uart_8250_port *up)
 
 	omap8250_update_mdr1(up, priv);
 
-	up->port.ops->set_mctrl(&up->port, up->port.mctrl);
+	__omap8250_set_mctrl(&up->port, up->port.mctrl);
 
 	if (up->port.rs485.flags & SER_RS485_ENABLED)
 		serial8250_em485_stop_tx(up);
@@ -1474,9 +1475,15 @@ static int omap8250_probe(struct platform_device *pdev)
 static int omap8250_remove(struct platform_device *pdev)
 {
 	struct omap8250_priv *priv = platform_get_drvdata(pdev);
+	int err;
+
+	err = pm_runtime_resume_and_get(&pdev->dev);
+	if (err)
+		return err;
 
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
 	pm_runtime_put_sync(&pdev->dev);
+	flush_work(&priv->qos_work);
 	pm_runtime_disable(&pdev->dev);
 	serial8250_unregister_port(priv->line);
 	cpu_latency_qos_remove_request(&priv->pm_qos_request);
diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index f648fd1d7548..1f231fcda657 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -661,13 +661,6 @@ int serial8250_em485_config(struct uart_port *port, struct serial_rs485 *rs485)
 		rs485->flags &= ~SER_RS485_RTS_AFTER_SEND;
 	}
 
-	/* clamp the delays to [0, 100ms] */
-	rs485->delay_rts_before_send = min(rs485->delay_rts_before_send, 100U);
-	rs485->delay_rts_after_send  = min(rs485->delay_rts_after_send, 100U);
-
-	memset(rs485->padding, 0, sizeof(rs485->padding));
-	port->rs485 = *rs485;
-
 	gpiod_set_value(port->rs485_term_gpio,
 			rs485->flags & SER_RS485_TERMINATE_BUS);
 
@@ -675,15 +668,8 @@ int serial8250_em485_config(struct uart_port *port, struct serial_rs485 *rs485)
 	 * Both serial8250_em485_init() and serial8250_em485_destroy()
 	 * are idempotent.
 	 */
-	if (rs485->flags & SER_RS485_ENABLED) {
-		int ret = serial8250_em485_init(up);
-
-		if (ret) {
-			rs485->flags &= ~SER_RS485_ENABLED;
-			port->rs485.flags &= ~SER_RS485_ENABLED;
-		}
-		return ret;
-	}
+	if (rs485->flags & SER_RS485_ENABLED)
+		return serial8250_em485_init(up);
 
 	serial8250_em485_destroy(up);
 	return 0;
@@ -1883,10 +1869,13 @@ EXPORT_SYMBOL_GPL(serial8250_modem_status);
 static bool handle_rx_dma(struct uart_8250_port *up, unsigned int iir)
 {
 	switch (iir & 0x3f) {
-	case UART_IIR_RX_TIMEOUT:
-		serial8250_rx_dma_flush(up);
+	case UART_IIR_RDI:
+		if (!up->dma->rx_running)
+			break;
 		fallthrough;
 	case UART_IIR_RLSI:
+	case UART_IIR_RX_TIMEOUT:
+		serial8250_rx_dma_flush(up);
 		return true;
 	}
 	return up->dma->rx_dma(up);
diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index cf3d53165776..164597e2e004 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -2626,6 +2626,7 @@ static const struct dev_pm_ops imx_uart_pm_ops = {
 	.suspend_noirq = imx_uart_suspend_noirq,
 	.resume_noirq = imx_uart_resume_noirq,
 	.freeze_noirq = imx_uart_suspend_noirq,
+	.thaw_noirq = imx_uart_resume_noirq,
 	.restore_noirq = imx_uart_resume_noirq,
 	.suspend = imx_uart_suspend,
 	.resume = imx_uart_resume,
diff --git a/drivers/usb/chipidea/otg_fsm.c b/drivers/usb/chipidea/otg_fsm.c
index 6ed4b00dba96..7a2a9559693f 100644
--- a/drivers/usb/chipidea/otg_fsm.c
+++ b/drivers/usb/chipidea/otg_fsm.c
@@ -256,8 +256,10 @@ static void ci_otg_del_timer(struct ci_hdrc *ci, enum otg_fsm_timer t)
 	ci->enabled_otg_timer_bits &= ~(1 << t);
 	if (ci->next_otg_timer == t) {
 		if (ci->enabled_otg_timer_bits == 0) {
+			spin_unlock_irqrestore(&ci->lock, flags);
 			/* No enabled timers after delete it */
 			hrtimer_cancel(&ci->otg_fsm_hrtimer);
+			spin_lock_irqsave(&ci->lock, flags);
 			ci->next_otg_timer = NUM_OTG_FSM_TIMERS;
 		} else {
 			/* Find the next timer */
diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index eb3ea45d5d13..6d24d138cc77 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -362,6 +362,9 @@ static const struct usb_device_id usb_quirk_list[] = {
 	{ USB_DEVICE(0x0781, 0x5583), .driver_info = USB_QUIRK_NO_LPM },
 	{ USB_DEVICE(0x0781, 0x5591), .driver_info = USB_QUIRK_NO_LPM },
 
+	/* Realforce 87U Keyboard */
+	{ USB_DEVICE(0x0853, 0x011b), .driver_info = USB_QUIRK_NO_LPM },
+
 	/* M-Systems Flash Disk Pioneers */
 	{ USB_DEVICE(0x08ec, 0x1000), .driver_info = USB_QUIRK_RESET_RESUME },
 
diff --git a/drivers/usb/dwc3/host.c b/drivers/usb/dwc3/host.c
index 86bc2bec9038..b06ab85f8187 100644
--- a/drivers/usb/dwc3/host.c
+++ b/drivers/usb/dwc3/host.c
@@ -10,13 +10,8 @@
 #include <linux/acpi.h>
 #include <linux/platform_device.h>
 
-#include "../host/xhci-plat.h"
 #include "core.h"
 
-static const struct xhci_plat_priv dwc3_xhci_plat_priv = {
-	.quirks = XHCI_SKIP_PHY_INIT,
-};
-
 static int dwc3_host_get_irq(struct dwc3 *dwc)
 {
 	struct platform_device	*dwc3_pdev = to_platform_device(dwc->dev);
@@ -92,11 +87,6 @@ int dwc3_host_init(struct dwc3 *dwc)
 		goto err;
 	}
 
-	ret = platform_device_add_data(xhci, &dwc3_xhci_plat_priv,
-					sizeof(dwc3_xhci_plat_priv));
-	if (ret)
-		goto err;
-
 	memset(props, 0, sizeof(struct property_entry) * ARRAY_SIZE(props));
 
 	if (dwc->usb3_lpm_capable)
diff --git a/drivers/usb/host/bcma-hcd.c b/drivers/usb/host/bcma-hcd.c
index 2df52f75f6b3..7558cc4d90cc 100644
--- a/drivers/usb/host/bcma-hcd.c
+++ b/drivers/usb/host/bcma-hcd.c
@@ -285,7 +285,7 @@ static void bcma_hci_platform_power_gpio(struct bcma_device *dev, bool val)
 {
 	struct bcma_hcd_device *usb_dev = bcma_get_drvdata(dev);
 
-	if (IS_ERR_OR_NULL(usb_dev->gpio_desc))
+	if (!usb_dev->gpio_desc)
 		return;
 
 	gpiod_set_value(usb_dev->gpio_desc, val);
@@ -406,9 +406,11 @@ static int bcma_hcd_probe(struct bcma_device *core)
 		return -ENOMEM;
 	usb_dev->core = core;
 
-	if (core->dev.of_node)
-		usb_dev->gpio_desc = devm_gpiod_get(&core->dev, "vcc",
-						    GPIOD_OUT_HIGH);
+	usb_dev->gpio_desc = devm_gpiod_get_optional(&core->dev, "vcc",
+						     GPIOD_OUT_HIGH);
+	if (IS_ERR(usb_dev->gpio_desc))
+		return dev_err_probe(&core->dev, PTR_ERR(usb_dev->gpio_desc),
+				     "error obtaining VCC GPIO");
 
 	switch (core->id.id) {
 	case BCMA_CORE_USB20_HOST:
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index eea3dd18a044..537ef276c78f 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -162,6 +162,8 @@ static void option_instat_callback(struct urb *urb);
 #define NOVATELWIRELESS_PRODUCT_G2		0xA010
 #define NOVATELWIRELESS_PRODUCT_MC551		0xB001
 
+#define UBLOX_VENDOR_ID				0x1546
+
 /* AMOI PRODUCTS */
 #define AMOI_VENDOR_ID				0x1614
 #define AMOI_PRODUCT_H01			0x0800
@@ -240,7 +242,6 @@ static void option_instat_callback(struct urb *urb);
 #define QUECTEL_PRODUCT_UC15			0x9090
 /* These u-blox products use Qualcomm's vendor ID */
 #define UBLOX_PRODUCT_R410M			0x90b2
-#define UBLOX_PRODUCT_R6XX			0x90fa
 /* These Yuga products use Qualcomm's vendor ID */
 #define YUGA_PRODUCT_CLM920_NC5			0x9625
 
@@ -581,6 +582,9 @@ static void option_instat_callback(struct urb *urb);
 #define OPPO_VENDOR_ID				0x22d9
 #define OPPO_PRODUCT_R11			0x276c
 
+/* Sierra Wireless products */
+#define SIERRA_VENDOR_ID			0x1199
+#define SIERRA_PRODUCT_EM9191			0x90d3
 
 /* Device flags */
 
@@ -1124,8 +1128,16 @@ static const struct usb_device_id option_ids[] = {
 	/* u-blox products using Qualcomm vendor ID */
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, UBLOX_PRODUCT_R410M),
 	  .driver_info = RSVD(1) | RSVD(3) },
-	{ USB_DEVICE(QUALCOMM_VENDOR_ID, UBLOX_PRODUCT_R6XX),
+	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x908b),	/* u-blox LARA-R6 00B */
+	  .driver_info = RSVD(4) },
+	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x90fa),
 	  .driver_info = RSVD(3) },
+	/* u-blox products */
+	{ USB_DEVICE(UBLOX_VENDOR_ID, 0x1341) },	/* u-blox LARA-L6 */
+	{ USB_DEVICE(UBLOX_VENDOR_ID, 0x1342),		/* u-blox LARA-L6 (RMNET) */
+	  .driver_info = RSVD(4) },
+	{ USB_DEVICE(UBLOX_VENDOR_ID, 0x1343),		/* u-blox LARA-L6 (ECM) */
+	  .driver_info = RSVD(4) },
 	/* Quectel products using Quectel vendor ID */
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC21, 0xff, 0xff, 0xff),
 	  .driver_info = NUMEP2 },
@@ -2167,6 +2179,7 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_INTERFACE_CLASS(0x2cb7, 0x010a, 0xff) },			/* Fibocom MA510 (ECM mode) */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x2cb7, 0x010b, 0xff, 0xff, 0x30) },	/* Fibocom FG150 Diag */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x2cb7, 0x010b, 0xff, 0, 0) },		/* Fibocom FG150 AT */
+	{ USB_DEVICE_INTERFACE_CLASS(0x2cb7, 0x0111, 0xff) },			/* Fibocom FM160 (MBIM mode) */
 	{ USB_DEVICE_INTERFACE_CLASS(0x2cb7, 0x01a0, 0xff) },			/* Fibocom NL668-AM/NL652-EU (laptop MBIM) */
 	{ USB_DEVICE_INTERFACE_CLASS(0x2cb7, 0x01a2, 0xff) },			/* Fibocom FM101-GL (laptop MBIM) */
 	{ USB_DEVICE_INTERFACE_CLASS(0x2cb7, 0x01a4, 0xff),			/* Fibocom FM101-GL (laptop MBIM) */
@@ -2176,6 +2189,8 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_INTERFACE_CLASS(0x305a, 0x1405, 0xff) },			/* GosunCn GM500 MBIM */
 	{ USB_DEVICE_INTERFACE_CLASS(0x305a, 0x1406, 0xff) },			/* GosunCn GM500 ECM/NCM */
 	{ USB_DEVICE_AND_INTERFACE_INFO(OPPO_VENDOR_ID, OPPO_PRODUCT_R11, 0xff, 0xff, 0x30) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(SIERRA_VENDOR_ID, SIERRA_PRODUCT_EM9191, 0xff, 0xff, 0x30) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(SIERRA_VENDOR_ID, SIERRA_PRODUCT_EM9191, 0xff, 0, 0) },
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);
diff --git a/drivers/usb/typec/mux/intel_pmc_mux.c b/drivers/usb/typec/mux/intel_pmc_mux.c
index 80daa70e288b..1276112edeff 100644
--- a/drivers/usb/typec/mux/intel_pmc_mux.c
+++ b/drivers/usb/typec/mux/intel_pmc_mux.c
@@ -339,13 +339,24 @@ pmc_usb_mux_usb4(struct pmc_usb_port *port, struct typec_mux_state *state)
 	return pmc_usb_command(port, (void *)&req, sizeof(req));
 }
 
-static int pmc_usb_mux_safe_state(struct pmc_usb_port *port)
+static int pmc_usb_mux_safe_state(struct pmc_usb_port *port,
+				  struct typec_mux_state *state)
 {
 	u8 msg;
 
 	if (IOM_PORT_ACTIVITY_IS(port->iom_status, SAFE_MODE))
 		return 0;
 
+	if ((IOM_PORT_ACTIVITY_IS(port->iom_status, DP) ||
+	     IOM_PORT_ACTIVITY_IS(port->iom_status, DP_MFD)) &&
+	     state->alt && state->alt->svid == USB_TYPEC_DP_SID)
+		return 0;
+
+	if ((IOM_PORT_ACTIVITY_IS(port->iom_status, TBT) ||
+	     IOM_PORT_ACTIVITY_IS(port->iom_status, ALT_MODE_TBT_USB)) &&
+	     state->alt && state->alt->svid == USB_TYPEC_TBT_SID)
+		return 0;
+
 	msg = PMC_USB_SAFE_MODE;
 	msg |= port->usb3_port << PMC_USB_MSG_USB3_PORT_SHIFT;
 
@@ -413,7 +424,7 @@ pmc_usb_mux_set(struct typec_mux *mux, struct typec_mux_state *state)
 		return 0;
 
 	if (state->mode == TYPEC_STATE_SAFE)
-		return pmc_usb_mux_safe_state(port);
+		return pmc_usb_mux_safe_state(port, state);
 	if (state->mode == TYPEC_STATE_USB)
 		return pmc_usb_connect(port, port->role);
 
diff --git a/drivers/xen/pcpu.c b/drivers/xen/pcpu.c
index cdc6daa7a9f6..9cf7085a260b 100644
--- a/drivers/xen/pcpu.c
+++ b/drivers/xen/pcpu.c
@@ -228,7 +228,7 @@ static int register_pcpu(struct pcpu *pcpu)
 
 	err = device_register(dev);
 	if (err) {
-		pcpu_release(dev);
+		put_device(dev);
 		return err;
 	}
 
diff --git a/fs/btrfs/tests/qgroup-tests.c b/fs/btrfs/tests/qgroup-tests.c
index c4b31dccc184..289366c98f5b 100644
--- a/fs/btrfs/tests/qgroup-tests.c
+++ b/fs/btrfs/tests/qgroup-tests.c
@@ -230,7 +230,6 @@ static int test_no_shared_qgroup(struct btrfs_root *root,
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &old_roots,
 			false);
 	if (ret) {
-		ulist_free(old_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -246,7 +245,6 @@ static int test_no_shared_qgroup(struct btrfs_root *root,
 			false);
 	if (ret) {
 		ulist_free(old_roots);
-		ulist_free(new_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -258,18 +256,19 @@ static int test_no_shared_qgroup(struct btrfs_root *root,
 		return ret;
 	}
 
+	/* btrfs_qgroup_account_extent() always frees the ulists passed to it. */
+	old_roots = NULL;
+	new_roots = NULL;
+
 	if (btrfs_verify_qgroup_counts(fs_info, BTRFS_FS_TREE_OBJECTID,
 				nodesize, nodesize)) {
 		test_err("qgroup counts didn't match expected values");
 		return -EINVAL;
 	}
-	old_roots = NULL;
-	new_roots = NULL;
 
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &old_roots,
 			false);
 	if (ret) {
-		ulist_free(old_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -284,7 +283,6 @@ static int test_no_shared_qgroup(struct btrfs_root *root,
 			false);
 	if (ret) {
 		ulist_free(old_roots);
-		ulist_free(new_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -335,7 +333,6 @@ static int test_multiple_refs(struct btrfs_root *root,
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &old_roots,
 			false);
 	if (ret) {
-		ulist_free(old_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -351,7 +348,6 @@ static int test_multiple_refs(struct btrfs_root *root,
 			false);
 	if (ret) {
 		ulist_free(old_roots);
-		ulist_free(new_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -372,7 +368,6 @@ static int test_multiple_refs(struct btrfs_root *root,
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &old_roots,
 			false);
 	if (ret) {
-		ulist_free(old_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -388,7 +383,6 @@ static int test_multiple_refs(struct btrfs_root *root,
 			false);
 	if (ret) {
 		ulist_free(old_roots);
-		ulist_free(new_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -415,7 +409,6 @@ static int test_multiple_refs(struct btrfs_root *root,
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &old_roots,
 			false);
 	if (ret) {
-		ulist_free(old_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
@@ -431,7 +424,6 @@ static int test_multiple_refs(struct btrfs_root *root,
 			false);
 	if (ret) {
 		ulist_free(old_roots);
-		ulist_free(new_roots);
 		test_err("couldn't find old roots: %d", ret);
 		return ret;
 	}
diff --git a/fs/buffer.c b/fs/buffer.c
index 23f645657488..ee66abadcbc2 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2350,7 +2350,7 @@ int generic_cont_expand_simple(struct inode *inode, loff_t size)
 {
 	struct address_space *mapping = inode->i_mapping;
 	struct page *page;
-	void *fsdata;
+	void *fsdata = NULL;
 	int err;
 
 	err = inode_newsize_ok(inode, size);
@@ -2376,7 +2376,7 @@ static int cont_expand_zero(struct file *file, struct address_space *mapping,
 	struct inode *inode = mapping->host;
 	unsigned int blocksize = i_blocksize(inode);
 	struct page *page;
-	void *fsdata;
+	void *fsdata = NULL;
 	pgoff_t index, curidx;
 	loff_t curpos;
 	unsigned zerofrom, offset, len;
diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index dcde44ff6cf9..e45598b62242 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -193,7 +193,7 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 					rc = put_user(ExtAttrBits &
 						FS_FL_USER_VISIBLE,
 						(int __user *)arg);
-				if (rc != EOPNOTSUPP)
+				if (rc != -EOPNOTSUPP)
 					break;
 			}
 #endif /* CONFIG_CIFS_POSIX */
@@ -222,7 +222,7 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 			 *		       pSMBFile->fid.netfid,
 			 *		       extAttrBits,
 			 *		       &ExtAttrMask);
-			 * if (rc != EOPNOTSUPP)
+			 * if (rc != -EOPNOTSUPP)
 			 *	break;
 			 */
 
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 11efd5289ec4..72368b656b33 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1256,6 +1256,8 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 				COMPOUND_FID, current->tgid,
 				FILE_FULL_EA_INFORMATION,
 				SMB2_O_INFO_FILE, 0, data, size);
+	if (rc)
+		goto sea_exit;
 	smb2_set_next_command(tcon, &rqst[1]);
 	smb2_set_related(&rqst[1]);
 
@@ -1266,6 +1268,8 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 	rqst[2].rq_nvec = 1;
 	rc = SMB2_close_init(tcon, server,
 			     &rqst[2], COMPOUND_FID, COMPOUND_FID, false);
+	if (rc)
+		goto sea_exit;
 	smb2_set_related(&rqst[2]);
 
 	rc = compound_send_recv(xid, ses, server,
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index b9ed6a6dbcf5..648f7336043f 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -182,7 +182,10 @@ static int gfs2_check_sb(struct gfs2_sbd *sdp, int silent)
 		pr_warn("Invalid superblock size\n");
 		return -EINVAL;
 	}
-
+	if (sb->sb_bsize_shift != ffs(sb->sb_bsize) - 1) {
+		pr_warn("Invalid block size shift\n");
+		return -EINVAL;
+	}
 	return 0;
 }
 
@@ -381,8 +384,10 @@ static int init_names(struct gfs2_sbd *sdp, int silent)
 	if (!table[0])
 		table = sdp->sd_vfs->s_id;
 
-	strlcpy(sdp->sd_proto_name, proto, GFS2_FSNAME_LEN);
-	strlcpy(sdp->sd_table_name, table, GFS2_FSNAME_LEN);
+	BUILD_BUG_ON(GFS2_LOCKNAME_LEN > GFS2_FSNAME_LEN);
+
+	strscpy(sdp->sd_proto_name, proto, GFS2_LOCKNAME_LEN);
+	strscpy(sdp->sd_table_name, table, GFS2_LOCKNAME_LEN);
 
 	table = sdp->sd_table_name;
 	while ((table = strchr(table, '/')))
@@ -1414,13 +1419,13 @@ static int gfs2_parse_param(struct fs_context *fc, struct fs_parameter *param)
 
 	switch (o) {
 	case Opt_lockproto:
-		strlcpy(args->ar_lockproto, param->string, GFS2_LOCKNAME_LEN);
+		strscpy(args->ar_lockproto, param->string, GFS2_LOCKNAME_LEN);
 		break;
 	case Opt_locktable:
-		strlcpy(args->ar_locktable, param->string, GFS2_LOCKNAME_LEN);
+		strscpy(args->ar_locktable, param->string, GFS2_LOCKNAME_LEN);
 		break;
 	case Opt_hostdata:
-		strlcpy(args->ar_hostdata, param->string, GFS2_LOCKNAME_LEN);
+		strscpy(args->ar_hostdata, param->string, GFS2_LOCKNAME_LEN);
 		break;
 	case Opt_spectator:
 		args->ar_spectator = 1;
diff --git a/fs/namei.c b/fs/namei.c
index eba2f13d229d..4375565aca66 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4633,7 +4633,7 @@ int __page_symlink(struct inode *inode, const char *symname, int len, int nofs)
 {
 	struct address_space *mapping = inode->i_mapping;
 	struct page *page;
-	void *fsdata;
+	void *fsdata = NULL;
 	int err;
 	unsigned int flags = 0;
 	if (nofs)
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 03f09399abf4..36af3734ac87 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -7014,6 +7014,7 @@ static void nfs4_lock_done(struct rpc_task *task, void *calldata)
 {
 	struct nfs4_lockdata *data = calldata;
 	struct nfs4_lock_state *lsp = data->lsp;
+	struct nfs_server *server = NFS_SERVER(d_inode(data->ctx->dentry));
 
 	dprintk("%s: begin!\n", __func__);
 
@@ -7023,8 +7024,7 @@ static void nfs4_lock_done(struct rpc_task *task, void *calldata)
 	data->rpc_status = task->tk_status;
 	switch (task->tk_status) {
 	case 0:
-		renew_lease(NFS_SERVER(d_inode(data->ctx->dentry)),
-				data->timestamp);
+		renew_lease(server, data->timestamp);
 		if (data->arg.new_lock && !data->cancelled) {
 			data->fl.fl_flags &= ~(FL_SLEEP | FL_ACCESS);
 			if (locks_lock_inode_wait(lsp->ls_state->inode, &data->fl) < 0)
@@ -7045,6 +7045,8 @@ static void nfs4_lock_done(struct rpc_task *task, void *calldata)
 			if (!nfs4_stateid_match(&data->arg.open_stateid,
 						&lsp->ls_state->open_stateid))
 				goto out_restart;
+			else if (nfs4_async_handle_error(task, server, lsp->ls_state, NULL) == -EAGAIN)
+				goto out_restart;
 		} else if (!nfs4_stateid_match(&data->arg.lock_stateid,
 						&lsp->ls_stateid))
 				goto out_restart;
diff --git a/fs/ntfs/attrib.c b/fs/ntfs/attrib.c
index 914e99173130..c0881d39d36a 100644
--- a/fs/ntfs/attrib.c
+++ b/fs/ntfs/attrib.c
@@ -594,17 +594,37 @@ static int ntfs_attr_find(const ATTR_TYPE type, const ntfschar *name,
 	for (;;	a = (ATTR_RECORD*)((u8*)a + le32_to_cpu(a->length))) {
 		u8 *mrec_end = (u8 *)ctx->mrec +
 		               le32_to_cpu(ctx->mrec->bytes_allocated);
-		u8 *name_end = (u8 *)a + le16_to_cpu(a->name_offset) +
-			       a->name_length * sizeof(ntfschar);
-		if ((u8*)a < (u8*)ctx->mrec || (u8*)a > mrec_end ||
-		    name_end > mrec_end)
+		u8 *name_end;
+
+		/* check whether ATTR_RECORD wrap */
+		if ((u8 *)a < (u8 *)ctx->mrec)
+			break;
+
+		/* check whether Attribute Record Header is within bounds */
+		if ((u8 *)a > mrec_end ||
+		    (u8 *)a + sizeof(ATTR_RECORD) > mrec_end)
+			break;
+
+		/* check whether ATTR_RECORD's name is within bounds */
+		name_end = (u8 *)a + le16_to_cpu(a->name_offset) +
+			   a->name_length * sizeof(ntfschar);
+		if (name_end > mrec_end)
 			break;
+
 		ctx->attr = a;
 		if (unlikely(le32_to_cpu(a->type) > le32_to_cpu(type) ||
 				a->type == AT_END))
 			return -ENOENT;
 		if (unlikely(!a->length))
 			break;
+
+		/* check whether ATTR_RECORD's length wrap */
+		if ((u8 *)a + le32_to_cpu(a->length) < (u8 *)a)
+			break;
+		/* check whether ATTR_RECORD's length is within bounds */
+		if ((u8 *)a + le32_to_cpu(a->length) > mrec_end)
+			break;
+
 		if (a->type != type)
 			continue;
 		/*
diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index cf222c9225d6..645c4b1b23de 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -1829,6 +1829,13 @@ int ntfs_read_inode_mount(struct inode *vi)
 		goto err_out;
 	}
 
+	/* Sanity check offset to the first attribute */
+	if (le16_to_cpu(m->attrs_offset) >= le32_to_cpu(m->bytes_allocated)) {
+		ntfs_error(sb, "Incorrect mft offset to the first attribute %u in superblock.",
+			       le16_to_cpu(m->attrs_offset));
+		goto err_out;
+	}
+
 	/* Need this to sanity check attribute list references to $MFT. */
 	vi->i_generation = ni->seq_no = le16_to_cpu(m->sequence_number);
 
diff --git a/include/linux/platform_data/intel-spi.h b/include/linux/platform_data/intel-spi.h
index 7f53a5c6f35e..7dda3f690465 100644
--- a/include/linux/platform_data/intel-spi.h
+++ b/include/linux/platform_data/intel-spi.h
@@ -19,11 +19,13 @@ enum intel_spi_type {
 /**
  * struct intel_spi_boardinfo - Board specific data for Intel SPI driver
  * @type: Type which this controller is compatible with
- * @writeable: The chip is writeable
+ * @set_writeable: Try to make the chip writeable (optional)
+ * @data: Data to be passed to @set_writeable can be %NULL
  */
 struct intel_spi_boardinfo {
 	enum intel_spi_type type;
-	bool writeable;
+	bool (*set_writeable)(void __iomem *base, void *data);
+	void *data;
 };
 
 #endif /* INTEL_SPI_PDATA_H */
diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index c9237d30c29b..7d5a78f49d43 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -99,7 +99,7 @@ __ring_buffer_alloc(unsigned long size, unsigned flags, struct lock_class_key *k
 
 int ring_buffer_wait(struct trace_buffer *buffer, int cpu, int full);
 __poll_t ring_buffer_poll_wait(struct trace_buffer *buffer, int cpu,
-			  struct file *filp, poll_table *poll_table);
+			  struct file *filp, poll_table *poll_table, int full);
 void ring_buffer_wake_waiters(struct trace_buffer *buffer, int cpu);
 
 #define RING_BUFFER_ALL_CPUS -1
diff --git a/include/linux/stddef.h b/include/linux/stddef.h
index 998a4ba28eba..938216f8ab7e 100644
--- a/include/linux/stddef.h
+++ b/include/linux/stddef.h
@@ -36,4 +36,52 @@ enum {
 #define offsetofend(TYPE, MEMBER) \
 	(offsetof(TYPE, MEMBER)	+ sizeof_field(TYPE, MEMBER))
 
+/**
+ * struct_group() - Wrap a set of declarations in a mirrored struct
+ *
+ * @NAME: The identifier name of the mirrored sub-struct
+ * @MEMBERS: The member declarations for the mirrored structs
+ *
+ * Used to create an anonymous union of two structs with identical
+ * layout and size: one anonymous and one named. The former can be
+ * used normally without sub-struct naming, and the latter can be
+ * used to reason about the start, end, and size of the group of
+ * struct members.
+ */
+#define struct_group(NAME, MEMBERS...)	\
+	__struct_group(/* no tag */, NAME, /* no attrs */, MEMBERS)
+
+/**
+ * struct_group_attr() - Create a struct_group() with trailing attributes
+ *
+ * @NAME: The identifier name of the mirrored sub-struct
+ * @ATTRS: Any struct attributes to apply
+ * @MEMBERS: The member declarations for the mirrored structs
+ *
+ * Used to create an anonymous union of two structs with identical
+ * layout and size: one anonymous and one named. The former can be
+ * used normally without sub-struct naming, and the latter can be
+ * used to reason about the start, end, and size of the group of
+ * struct members. Includes structure attributes argument.
+ */
+#define struct_group_attr(NAME, ATTRS, MEMBERS...) \
+	__struct_group(/* no tag */, NAME, ATTRS, MEMBERS)
+
+/**
+ * struct_group_tagged() - Create a struct_group with a reusable tag
+ *
+ * @TAG: The tag name for the named sub-struct
+ * @NAME: The identifier name of the mirrored sub-struct
+ * @MEMBERS: The member declarations for the mirrored structs
+ *
+ * Used to create an anonymous union of two structs with identical
+ * layout and size: one anonymous and one named. The former can be
+ * used normally without sub-struct naming, and the latter can be
+ * used to reason about the start, end, and size of the group of
+ * struct members. Includes struct tag argument for the named copy,
+ * so the specified layout can be reused later.
+ */
+#define struct_group_tagged(TAG, NAME, MEMBERS...) \
+	__struct_group(TAG, NAME, /* no attrs */, MEMBERS)
+
 #endif
diff --git a/include/net/ip.h b/include/net/ip.h
index c5822d7824cd..4b775af57268 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -545,7 +545,7 @@ static inline void iph_to_flow_copy_v4addrs(struct flow_keys *flow,
 	BUILD_BUG_ON(offsetof(typeof(flow->addrs), v4addrs.dst) !=
 		     offsetof(typeof(flow->addrs), v4addrs.src) +
 			      sizeof(flow->addrs.v4addrs.src));
-	memcpy(&flow->addrs.v4addrs, &iph->saddr, sizeof(flow->addrs.v4addrs));
+	memcpy(&flow->addrs.v4addrs, &iph->addrs, sizeof(flow->addrs.v4addrs));
 	flow->control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
 }
 
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 60601896d474..89ce8a50f236 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -842,7 +842,7 @@ static inline void iph_to_flow_copy_v6addrs(struct flow_keys *flow,
 	BUILD_BUG_ON(offsetof(typeof(flow->addrs), v6addrs.dst) !=
 		     offsetof(typeof(flow->addrs), v6addrs.src) +
 		     sizeof(flow->addrs.v6addrs.src));
-	memcpy(&flow->addrs.v6addrs, &iph->saddr, sizeof(flow->addrs.v6addrs));
+	memcpy(&flow->addrs.v6addrs, &iph->addrs, sizeof(flow->addrs.v6addrs));
 	flow->control.addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
 }
 
diff --git a/include/uapi/linux/ip.h b/include/uapi/linux/ip.h
index e42d13b55cf3..d2f143393780 100644
--- a/include/uapi/linux/ip.h
+++ b/include/uapi/linux/ip.h
@@ -100,8 +100,10 @@ struct iphdr {
 	__u8	ttl;
 	__u8	protocol;
 	__sum16	check;
-	__be32	saddr;
-	__be32	daddr;
+	__struct_group(/* no tag */, addrs, /* no attrs */,
+		__be32	saddr;
+		__be32	daddr;
+	);
 	/*The options start here. */
 };
 
diff --git a/include/uapi/linux/ipv6.h b/include/uapi/linux/ipv6.h
index 13e8751bf24a..766ab5c8ee65 100644
--- a/include/uapi/linux/ipv6.h
+++ b/include/uapi/linux/ipv6.h
@@ -130,8 +130,10 @@ struct ipv6hdr {
 	__u8			nexthdr;
 	__u8			hop_limit;
 
-	struct	in6_addr	saddr;
-	struct	in6_addr	daddr;
+	__struct_group(/* no tag */, addrs, /* no attrs */,
+		struct	in6_addr	saddr;
+		struct	in6_addr	daddr;
+	);
 };
 
 
diff --git a/include/uapi/linux/stddef.h b/include/uapi/linux/stddef.h
index ee8220f8dcf5..c3725b492263 100644
--- a/include/uapi/linux/stddef.h
+++ b/include/uapi/linux/stddef.h
@@ -1,6 +1,31 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _UAPI_LINUX_STDDEF_H
+#define _UAPI_LINUX_STDDEF_H
+
 #include <linux/compiler_types.h>
 
 #ifndef __always_inline
 #define __always_inline inline
 #endif
+
+/**
+ * __struct_group() - Create a mirrored named and anonyomous struct
+ *
+ * @TAG: The tag name for the named sub-struct (usually empty)
+ * @NAME: The identifier name of the mirrored sub-struct
+ * @ATTRS: Any struct attributes (usually empty)
+ * @MEMBERS: The member declarations for the mirrored structs
+ *
+ * Used to create an anonymous union of two structs with identical layout
+ * and size: one anonymous and one named. The former's members can be used
+ * normally without sub-struct naming, and the latter can be used to
+ * reason about the start, end, and size of the group of struct members.
+ * The named struct can also be explicitly tagged for layer reuse, as well
+ * as both having struct attributes appended.
+ */
+#define __struct_group(TAG, NAME, ATTRS, MEMBERS...) \
+	union { \
+		struct { MEMBERS } ATTRS; \
+		struct TAG { MEMBERS } ATTRS NAME; \
+	}
+#endif
diff --git a/kernel/bpf/percpu_freelist.c b/kernel/bpf/percpu_freelist.c
index 3d897de89061..bbab8bb4b2fd 100644
--- a/kernel/bpf/percpu_freelist.c
+++ b/kernel/bpf/percpu_freelist.c
@@ -102,22 +102,21 @@ void pcpu_freelist_populate(struct pcpu_freelist *s, void *buf, u32 elem_size,
 			    u32 nr_elems)
 {
 	struct pcpu_freelist_head *head;
-	int i, cpu, pcpu_entries;
+	unsigned int cpu, cpu_idx, i, j, n, m;
 
-	pcpu_entries = nr_elems / num_possible_cpus() + 1;
-	i = 0;
+	n = nr_elems / num_possible_cpus();
+	m = nr_elems % num_possible_cpus();
 
+	cpu_idx = 0;
 	for_each_possible_cpu(cpu) {
-again:
 		head = per_cpu_ptr(s->freelist, cpu);
-		/* No locking required as this is not visible yet. */
-		pcpu_freelist_push_node(head, buf);
-		i++;
-		buf += elem_size;
-		if (i == nr_elems)
-			break;
-		if (i % pcpu_entries)
-			goto again;
+		j = n + (cpu_idx < m ? 1 : 0);
+		for (i = 0; i < j; i++) {
+			/* No locking required as this is not visible yet. */
+			pcpu_freelist_push_node(head, buf);
+			buf += elem_size;
+		}
+		cpu_idx++;
 	}
 }
 
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index b0f444e86487..75150e755518 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1841,7 +1841,13 @@ static int __unregister_kprobe_top(struct kprobe *p)
 				if ((list_p != p) && (list_p->post_handler))
 					goto noclean;
 			}
-			ap->post_handler = NULL;
+			/*
+			 * For the kprobe-on-ftrace case, we keep the
+			 * post_handler setting to identify this aggrprobe
+			 * armed with kprobe_ipmodify_ops.
+			 */
+			if (!kprobe_ftrace(ap))
+				ap->post_handler = NULL;
 		}
 noclean:
 		/*
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 8e9ef0f55596..d97c189695cb 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1295,6 +1295,7 @@ static int ftrace_add_mod(struct trace_array *tr,
 	if (!ftrace_mod)
 		return -ENOMEM;
 
+	INIT_LIST_HEAD(&ftrace_mod->list);
 	ftrace_mod->func = kstrdup(func, GFP_KERNEL);
 	ftrace_mod->module = kstrdup(module, GFP_KERNEL);
 	ftrace_mod->enable = enable;
@@ -3178,7 +3179,7 @@ static int ftrace_allocate_records(struct ftrace_page *pg, int count)
 		/* if we can't allocate this size, try something smaller */
 		if (!order)
 			return -ENOMEM;
-		order >>= 1;
+		order--;
 		goto again;
 	}
 
@@ -6877,7 +6878,7 @@ void __init ftrace_init(void)
 	}
 
 	pr_info("ftrace: allocating %ld entries in %ld pages\n",
-		count, count / ENTRIES_PER_PAGE + 1);
+		count, DIV_ROUND_UP(count, ENTRIES_PER_PAGE));
 
 	last_ftrace_enabled = ftrace_enabled = 1;
 
diff --git a/kernel/trace/kprobe_event_gen_test.c b/kernel/trace/kprobe_event_gen_test.c
index d81f7c51025c..c736487fc0e4 100644
--- a/kernel/trace/kprobe_event_gen_test.c
+++ b/kernel/trace/kprobe_event_gen_test.c
@@ -73,6 +73,10 @@ static struct trace_event_file *gen_kretprobe_test;
 #define KPROBE_GEN_TEST_ARG3	NULL
 #endif
 
+static bool trace_event_file_is_valid(struct trace_event_file *input)
+{
+	return input && !IS_ERR(input);
+}
 
 /*
  * Test to make sure we can create a kprobe event, then add more
@@ -139,6 +143,8 @@ static int __init test_gen_kprobe_cmd(void)
 	kfree(buf);
 	return ret;
  delete:
+	if (trace_event_file_is_valid(gen_kprobe_test))
+		gen_kprobe_test = NULL;
 	/* We got an error after creating the event, delete it */
 	ret = kprobe_event_delete("gen_kprobe_test");
 	goto out;
@@ -202,6 +208,8 @@ static int __init test_gen_kretprobe_cmd(void)
 	kfree(buf);
 	return ret;
  delete:
+	if (trace_event_file_is_valid(gen_kretprobe_test))
+		gen_kretprobe_test = NULL;
 	/* We got an error after creating the event, delete it */
 	ret = kprobe_event_delete("gen_kretprobe_test");
 	goto out;
@@ -217,10 +225,12 @@ static int __init kprobe_event_gen_test_init(void)
 
 	ret = test_gen_kretprobe_cmd();
 	if (ret) {
-		WARN_ON(trace_array_set_clr_event(gen_kretprobe_test->tr,
-						  "kprobes",
-						  "gen_kretprobe_test", false));
-		trace_put_event_file(gen_kretprobe_test);
+		if (trace_event_file_is_valid(gen_kretprobe_test)) {
+			WARN_ON(trace_array_set_clr_event(gen_kretprobe_test->tr,
+							  "kprobes",
+							  "gen_kretprobe_test", false));
+			trace_put_event_file(gen_kretprobe_test);
+		}
 		WARN_ON(kprobe_event_delete("gen_kretprobe_test"));
 	}
 
@@ -229,24 +239,30 @@ static int __init kprobe_event_gen_test_init(void)
 
 static void __exit kprobe_event_gen_test_exit(void)
 {
-	/* Disable the event or you can't remove it */
-	WARN_ON(trace_array_set_clr_event(gen_kprobe_test->tr,
-					  "kprobes",
-					  "gen_kprobe_test", false));
+	if (trace_event_file_is_valid(gen_kprobe_test)) {
+		/* Disable the event or you can't remove it */
+		WARN_ON(trace_array_set_clr_event(gen_kprobe_test->tr,
+						  "kprobes",
+						  "gen_kprobe_test", false));
+
+		/* Now give the file and instance back */
+		trace_put_event_file(gen_kprobe_test);
+	}
 
-	/* Now give the file and instance back */
-	trace_put_event_file(gen_kprobe_test);
 
 	/* Now unregister and free the event */
 	WARN_ON(kprobe_event_delete("gen_kprobe_test"));
 
-	/* Disable the event or you can't remove it */
-	WARN_ON(trace_array_set_clr_event(gen_kretprobe_test->tr,
-					  "kprobes",
-					  "gen_kretprobe_test", false));
+	if (trace_event_file_is_valid(gen_kretprobe_test)) {
+		/* Disable the event or you can't remove it */
+		WARN_ON(trace_array_set_clr_event(gen_kretprobe_test->tr,
+						  "kprobes",
+						  "gen_kretprobe_test", false));
+
+		/* Now give the file and instance back */
+		trace_put_event_file(gen_kretprobe_test);
+	}
 
-	/* Now give the file and instance back */
-	trace_put_event_file(gen_kretprobe_test);
 
 	/* Now unregister and free the event */
 	WARN_ON(kprobe_event_delete("gen_kretprobe_test"));
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index a12e27815555..49ebb8c66268 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -517,6 +517,7 @@ struct ring_buffer_per_cpu {
 	local_t				committing;
 	local_t				commits;
 	local_t				pages_touched;
+	local_t				pages_lost;
 	local_t				pages_read;
 	long				last_pages_touch;
 	size_t				shortest_full;
@@ -771,10 +772,18 @@ size_t ring_buffer_nr_pages(struct trace_buffer *buffer, int cpu)
 size_t ring_buffer_nr_dirty_pages(struct trace_buffer *buffer, int cpu)
 {
 	size_t read;
+	size_t lost;
 	size_t cnt;
 
 	read = local_read(&buffer->buffers[cpu]->pages_read);
+	lost = local_read(&buffer->buffers[cpu]->pages_lost);
 	cnt = local_read(&buffer->buffers[cpu]->pages_touched);
+
+	if (WARN_ON_ONCE(cnt < lost))
+		return 0;
+
+	cnt -= lost;
+
 	/* The reader can read an empty page, but not more than that */
 	if (cnt < read) {
 		WARN_ON_ONCE(read > cnt + 1);
@@ -784,6 +793,21 @@ size_t ring_buffer_nr_dirty_pages(struct trace_buffer *buffer, int cpu)
 	return cnt - read;
 }
 
+static __always_inline bool full_hit(struct trace_buffer *buffer, int cpu, int full)
+{
+	struct ring_buffer_per_cpu *cpu_buffer = buffer->buffers[cpu];
+	size_t nr_pages;
+	size_t dirty;
+
+	nr_pages = cpu_buffer->nr_pages;
+	if (!nr_pages || !full)
+		return true;
+
+	dirty = ring_buffer_nr_dirty_pages(buffer, cpu);
+
+	return (dirty * 100) > (full * nr_pages);
+}
+
 /*
  * rb_wake_up_waiters - wake up tasks waiting for ring buffer input
  *
@@ -912,22 +936,20 @@ int ring_buffer_wait(struct trace_buffer *buffer, int cpu, int full)
 		    !ring_buffer_empty_cpu(buffer, cpu)) {
 			unsigned long flags;
 			bool pagebusy;
-			size_t nr_pages;
-			size_t dirty;
+			bool done;
 
 			if (!full)
 				break;
 
 			raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
 			pagebusy = cpu_buffer->reader_page == cpu_buffer->commit_page;
-			nr_pages = cpu_buffer->nr_pages;
-			dirty = ring_buffer_nr_dirty_pages(buffer, cpu);
+			done = !pagebusy && full_hit(buffer, cpu, full);
+
 			if (!cpu_buffer->shortest_full ||
 			    cpu_buffer->shortest_full > full)
 				cpu_buffer->shortest_full = full;
 			raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
-			if (!pagebusy &&
-			    (!nr_pages || (dirty * 100) > full * nr_pages))
+			if (done)
 				break;
 		}
 
@@ -953,6 +975,7 @@ int ring_buffer_wait(struct trace_buffer *buffer, int cpu, int full)
  * @cpu: the cpu buffer to wait on
  * @filp: the file descriptor
  * @poll_table: The poll descriptor
+ * @full: wait until the percentage of pages are available, if @cpu != RING_BUFFER_ALL_CPUS
  *
  * If @cpu == RING_BUFFER_ALL_CPUS then the task will wake up as soon
  * as data is added to any of the @buffer's cpu buffers. Otherwise
@@ -962,14 +985,15 @@ int ring_buffer_wait(struct trace_buffer *buffer, int cpu, int full)
  * zero otherwise.
  */
 __poll_t ring_buffer_poll_wait(struct trace_buffer *buffer, int cpu,
-			  struct file *filp, poll_table *poll_table)
+			  struct file *filp, poll_table *poll_table, int full)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 	struct rb_irq_work *work;
 
-	if (cpu == RING_BUFFER_ALL_CPUS)
+	if (cpu == RING_BUFFER_ALL_CPUS) {
 		work = &buffer->irq_work;
-	else {
+		full = 0;
+	} else {
 		if (!cpumask_test_cpu(cpu, buffer->cpumask))
 			return -EINVAL;
 
@@ -977,8 +1001,14 @@ __poll_t ring_buffer_poll_wait(struct trace_buffer *buffer, int cpu,
 		work = &cpu_buffer->irq_work;
 	}
 
-	poll_wait(filp, &work->waiters, poll_table);
-	work->waiters_pending = true;
+	if (full) {
+		poll_wait(filp, &work->full_waiters, poll_table);
+		work->full_waiters_pending = true;
+	} else {
+		poll_wait(filp, &work->waiters, poll_table);
+		work->waiters_pending = true;
+	}
+
 	/*
 	 * There's a tight race between setting the waiters_pending and
 	 * checking if the ring buffer is empty.  Once the waiters_pending bit
@@ -994,6 +1024,9 @@ __poll_t ring_buffer_poll_wait(struct trace_buffer *buffer, int cpu,
 	 */
 	smp_mb();
 
+	if (full)
+		return full_hit(buffer, cpu, full) ? EPOLLIN | EPOLLRDNORM : 0;
+
 	if ((cpu == RING_BUFFER_ALL_CPUS && !ring_buffer_empty(buffer)) ||
 	    (cpu != RING_BUFFER_ALL_CPUS && !ring_buffer_empty_cpu(buffer, cpu)))
 		return EPOLLIN | EPOLLRDNORM;
@@ -1635,9 +1668,9 @@ static void rb_free_cpu_buffer(struct ring_buffer_per_cpu *cpu_buffer)
 
 	free_buffer_page(cpu_buffer->reader_page);
 
-	rb_head_page_deactivate(cpu_buffer);
-
 	if (head) {
+		rb_head_page_deactivate(cpu_buffer);
+
 		list_for_each_entry_safe(bpage, tmp, head, list) {
 			list_del_init(&bpage->list);
 			free_buffer_page(bpage);
@@ -1873,6 +1906,7 @@ rb_remove_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned long nr_pages)
 			 */
 			local_add(page_entries, &cpu_buffer->overrun);
 			local_sub(BUF_PAGE_SIZE, &cpu_buffer->entries_bytes);
+			local_inc(&cpu_buffer->pages_lost);
 		}
 
 		/*
@@ -2363,6 +2397,7 @@ rb_handle_head_page(struct ring_buffer_per_cpu *cpu_buffer,
 		 */
 		local_add(entries, &cpu_buffer->overrun);
 		local_sub(BUF_PAGE_SIZE, &cpu_buffer->entries_bytes);
+		local_inc(&cpu_buffer->pages_lost);
 
 		/*
 		 * The entries will be zeroed out when we move the
@@ -3033,10 +3068,6 @@ static void rb_commit(struct ring_buffer_per_cpu *cpu_buffer,
 static __always_inline void
 rb_wakeups(struct trace_buffer *buffer, struct ring_buffer_per_cpu *cpu_buffer)
 {
-	size_t nr_pages;
-	size_t dirty;
-	size_t full;
-
 	if (buffer->irq_work.waiters_pending) {
 		buffer->irq_work.waiters_pending = false;
 		/* irq_work_queue() supplies it's own memory barriers */
@@ -3060,10 +3091,7 @@ rb_wakeups(struct trace_buffer *buffer, struct ring_buffer_per_cpu *cpu_buffer)
 
 	cpu_buffer->last_pages_touch = local_read(&cpu_buffer->pages_touched);
 
-	full = cpu_buffer->shortest_full;
-	nr_pages = cpu_buffer->nr_pages;
-	dirty = ring_buffer_nr_dirty_pages(buffer, cpu_buffer->cpu);
-	if (full && nr_pages && (dirty * 100) <= full * nr_pages)
+	if (!full_hit(buffer, cpu_buffer->cpu, cpu_buffer->shortest_full))
 		return;
 
 	cpu_buffer->irq_work.wakeup_full = true;
@@ -4964,6 +4992,7 @@ rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer)
 	local_set(&cpu_buffer->committing, 0);
 	local_set(&cpu_buffer->commits, 0);
 	local_set(&cpu_buffer->pages_touched, 0);
+	local_set(&cpu_buffer->pages_lost, 0);
 	local_set(&cpu_buffer->pages_read, 0);
 	cpu_buffer->last_pages_touch = 0;
 	cpu_buffer->shortest_full = 0;
diff --git a/kernel/trace/synth_event_gen_test.c b/kernel/trace/synth_event_gen_test.c
index edd912cd14aa..a6a2813afb87 100644
--- a/kernel/trace/synth_event_gen_test.c
+++ b/kernel/trace/synth_event_gen_test.c
@@ -120,15 +120,13 @@ static int __init test_gen_synth_cmd(void)
 
 	/* Now generate a gen_synth_test event */
 	ret = synth_event_trace_array(gen_synth_test, vals, ARRAY_SIZE(vals));
- out:
+ free:
+	kfree(buf);
 	return ret;
  delete:
 	/* We got an error after creating the event, delete it */
 	synth_event_delete("gen_synth_test");
- free:
-	kfree(buf);
-
-	goto out;
+	goto free;
 }
 
 /*
@@ -227,15 +225,13 @@ static int __init test_empty_synth_event(void)
 
 	/* Now trace an empty_synth_test event */
 	ret = synth_event_trace_array(empty_synth_test, vals, ARRAY_SIZE(vals));
- out:
+ free:
+	kfree(buf);
 	return ret;
  delete:
 	/* We got an error after creating the event, delete it */
 	synth_event_delete("empty_synth_test");
- free:
-	kfree(buf);
-
-	goto out;
+	goto free;
 }
 
 static struct synth_field_desc create_synth_test_fields[] = {
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index b7cb9147f0c5..146771d6d007 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -6263,7 +6263,7 @@ trace_poll(struct trace_iterator *iter, struct file *filp, poll_table *poll_tabl
 		return EPOLLIN | EPOLLRDNORM;
 	else
 		return ring_buffer_poll_wait(iter->array_buffer->buffer, iter->cpu_file,
-					     filp, poll_table);
+					     filp, poll_table, iter->tr->buffer_percent);
 }
 
 static __poll_t
diff --git a/kernel/trace/trace_events_synth.c b/kernel/trace/trace_events_synth.c
index 881df991742a..18291ab35657 100644
--- a/kernel/trace/trace_events_synth.c
+++ b/kernel/trace/trace_events_synth.c
@@ -791,10 +791,9 @@ static int register_synth_event(struct synth_event *event)
 	}
 
 	ret = set_synth_event_print_fmt(call);
-	if (ret < 0) {
+	/* unregister_trace_event() will be called inside */
+	if (ret < 0)
 		trace_remove_event_call(call);
-		goto err;
-	}
  out:
 	return ret;
  err:
diff --git a/mm/filemap.c b/mm/filemap.c
index 125b69f59caa..3a983bc1a71c 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3303,7 +3303,7 @@ ssize_t generic_perform_write(struct file *file,
 		unsigned long offset;	/* Offset into pagecache page */
 		unsigned long bytes;	/* Bytes to write to page */
 		size_t copied;		/* Bytes copied from user */
-		void *fsdata;
+		void *fsdata = NULL;
 
 		offset = (pos & (PAGE_SIZE - 1));
 		bytes = min_t(unsigned long, PAGE_SIZE - offset,
diff --git a/mm/maccess.c b/mm/maccess.c
index 3bd70405f2d8..f6ea117a69eb 100644
--- a/mm/maccess.c
+++ b/mm/maccess.c
@@ -83,7 +83,7 @@ long strncpy_from_kernel_nofault(char *dst, const void *unsafe_addr, long count)
 	return src - unsafe_addr;
 Efault:
 	pagefault_enable();
-	dst[-1] = '\0';
+	dst[0] = '\0';
 	return -EFAULT;
 }
 #else /* HAVE_GET_KERNEL_NOFAULT */
diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index 8f528e783a6c..fec6c800c898 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -205,6 +205,8 @@ static void p9_conn_cancel(struct p9_conn *m, int err)
 		list_move(&req->req_list, &cancel_list);
 	}
 
+	spin_unlock(&m->client->lock);
+
 	list_for_each_entry_safe(req, rtmp, &cancel_list, req_list) {
 		p9_debug(P9_DEBUG_ERROR, "call back req %p\n", req);
 		list_del(&req->req_list);
@@ -212,7 +214,6 @@ static void p9_conn_cancel(struct p9_conn *m, int err)
 			req->t_err = err;
 		p9_client_cb(m->client, req, REQ_STATUS_ERROR);
 	}
-	spin_unlock(&m->client->lock);
 }
 
 static __poll_t
@@ -820,11 +821,14 @@ static int p9_fd_open(struct p9_client *client, int rfd, int wfd)
 		goto out_free_ts;
 	if (!(ts->rd->f_mode & FMODE_READ))
 		goto out_put_rd;
+	/* prevent workers from hanging on IO when fd is a pipe */
+	ts->rd->f_flags |= O_NONBLOCK;
 	ts->wr = fget(wfd);
 	if (!ts->wr)
 		goto out_put_rd;
 	if (!(ts->wr->f_mode & FMODE_WRITE))
 		goto out_put_wr;
+	ts->wr->f_flags |= O_NONBLOCK;
 
 	client->trans = ts;
 	client->status = Connected;
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index e69e96ef4927..c5e4d2b8cb0b 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -1986,7 +1986,7 @@ static struct l2cap_chan *l2cap_global_chan_by_psm(int state, __le16 psm,
 		if (link_type == LE_LINK && c->src_type == BDADDR_BREDR)
 			continue;
 
-		if (c->psm == psm) {
+		if (c->chan_type != L2CAP_CHAN_FIXED && c->psm == psm) {
 			int src_match, dst_match;
 			int src_any, dst_any;
 
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 2983e926fe3c..717b01ff9b2b 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -231,6 +231,7 @@ static void *bpf_test_init(const union bpf_attr *kattr, u32 size,
 	if (user_size > size)
 		return ERR_PTR(-EMSGSIZE);
 
+	size = SKB_DATA_ALIGN(size);
 	data = kzalloc(size + headroom + tailroom, GFP_USER);
 	if (!data)
 		return ERR_PTR(-ENOMEM);
diff --git a/net/caif/chnl_net.c b/net/caif/chnl_net.c
index 42dc080a4dbb..806fb4d84fd3 100644
--- a/net/caif/chnl_net.c
+++ b/net/caif/chnl_net.c
@@ -315,9 +315,6 @@ static int chnl_net_open(struct net_device *dev)
 
 	if (result == 0) {
 		pr_debug("connect timeout\n");
-		caif_disconnect_client(dev_net(dev), &priv->chnl);
-		priv->state = CAIF_DISCONNECTED;
-		pr_debug("state disconnected\n");
 		result = -ETIMEDOUT;
 		goto error;
 	}
diff --git a/net/ipv4/tcp_cdg.c b/net/ipv4/tcp_cdg.c
index 709d23801823..56dede4b59d9 100644
--- a/net/ipv4/tcp_cdg.c
+++ b/net/ipv4/tcp_cdg.c
@@ -375,6 +375,7 @@ static void tcp_cdg_init(struct sock *sk)
 	struct cdg *ca = inet_csk_ca(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
 
+	ca->gradients = NULL;
 	/* We silently fall back to window = 1 if allocation fails. */
 	if (window > 1)
 		ca->gradients = kcalloc(window, sizeof(ca->gradients[0]),
@@ -388,6 +389,7 @@ static void tcp_cdg_release(struct sock *sk)
 	struct cdg *ca = inet_csk_ca(sk);
 
 	kfree(ca->gradients);
+	ca->gradients = NULL;
 }
 
 static struct tcp_congestion_ops tcp_cdg __read_mostly = {
diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index 6b362b362f79..32b516ab9c47 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -221,7 +221,7 @@ static void requeue_rx_msgs(struct kcm_mux *mux, struct sk_buff_head *head)
 	struct sk_buff *skb;
 	struct kcm_sock *kcm;
 
-	while ((skb = __skb_dequeue(head))) {
+	while ((skb = skb_dequeue(head))) {
 		/* Reset destructor to avoid calling kcm_rcv_ready */
 		skb->destructor = sock_rfree;
 		skb_orphan(skb);
@@ -1084,53 +1084,18 @@ static int kcm_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	return err;
 }
 
-static struct sk_buff *kcm_wait_data(struct sock *sk, int flags,
-				     long timeo, int *err)
-{
-	struct sk_buff *skb;
-
-	while (!(skb = skb_peek(&sk->sk_receive_queue))) {
-		if (sk->sk_err) {
-			*err = sock_error(sk);
-			return NULL;
-		}
-
-		if (sock_flag(sk, SOCK_DONE))
-			return NULL;
-
-		if ((flags & MSG_DONTWAIT) || !timeo) {
-			*err = -EAGAIN;
-			return NULL;
-		}
-
-		sk_wait_data(sk, &timeo, NULL);
-
-		/* Handle signals */
-		if (signal_pending(current)) {
-			*err = sock_intr_errno(timeo);
-			return NULL;
-		}
-	}
-
-	return skb;
-}
-
 static int kcm_recvmsg(struct socket *sock, struct msghdr *msg,
 		       size_t len, int flags)
 {
+	int noblock = flags & MSG_DONTWAIT;
 	struct sock *sk = sock->sk;
 	struct kcm_sock *kcm = kcm_sk(sk);
 	int err = 0;
-	long timeo;
 	struct strp_msg *stm;
 	int copied = 0;
 	struct sk_buff *skb;
 
-	timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
-
-	lock_sock(sk);
-
-	skb = kcm_wait_data(sk, flags, timeo, &err);
+	skb = skb_recv_datagram(sk, flags, noblock, &err);
 	if (!skb)
 		goto out;
 
@@ -1161,14 +1126,11 @@ static int kcm_recvmsg(struct socket *sock, struct msghdr *msg,
 			/* Finished with message */
 			msg->msg_flags |= MSG_EOR;
 			KCM_STATS_INCR(kcm->stats.rx_msgs);
-			skb_unlink(skb, &sk->sk_receive_queue);
-			kfree_skb(skb);
 		}
 	}
 
 out:
-	release_sock(sk);
-
+	skb_free_datagram(sk, skb);
 	return copied ? : err;
 }
 
@@ -1176,9 +1138,9 @@ static ssize_t kcm_splice_read(struct socket *sock, loff_t *ppos,
 			       struct pipe_inode_info *pipe, size_t len,
 			       unsigned int flags)
 {
+	int noblock = flags & MSG_DONTWAIT;
 	struct sock *sk = sock->sk;
 	struct kcm_sock *kcm = kcm_sk(sk);
-	long timeo;
 	struct strp_msg *stm;
 	int err = 0;
 	ssize_t copied;
@@ -1186,11 +1148,7 @@ static ssize_t kcm_splice_read(struct socket *sock, loff_t *ppos,
 
 	/* Only support splice for SOCKSEQPACKET */
 
-	timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
-
-	lock_sock(sk);
-
-	skb = kcm_wait_data(sk, flags, timeo, &err);
+	skb = skb_recv_datagram(sk, flags, noblock, &err);
 	if (!skb)
 		goto err_out;
 
@@ -1218,13 +1176,11 @@ static ssize_t kcm_splice_read(struct socket *sock, loff_t *ppos,
 	 * finish reading the message.
 	 */
 
-	release_sock(sk);
-
+	skb_free_datagram(sk, skb);
 	return copied;
 
 err_out:
-	release_sock(sk);
-
+	skb_free_datagram(sk, skb);
 	return err;
 }
 
@@ -1844,10 +1800,10 @@ static int kcm_release(struct socket *sock)
 	kcm = kcm_sk(sk);
 	mux = kcm->mux;
 
+	lock_sock(sk);
 	sock_orphan(sk);
 	kfree_skb(kcm->seq_skb);
 
-	lock_sock(sk);
 	/* Purge queue under lock to avoid race condition with tx_work trying
 	 * to act when queue is nonempty. If tx_work runs after this point
 	 * it will just return.
diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 561b6d67ab8b..dc8987ed08ad 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1480,11 +1480,15 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 	tunnel->l2tp_net = net;
 	pn = l2tp_pernet(net);
 
+	sk = sock->sk;
+	sock_hold(sk);
+	tunnel->sock = sk;
+
 	spin_lock_bh(&pn->l2tp_tunnel_list_lock);
 	list_for_each_entry(tunnel_walk, &pn->l2tp_tunnel_list, list) {
 		if (tunnel_walk->tunnel_id == tunnel->tunnel_id) {
 			spin_unlock_bh(&pn->l2tp_tunnel_list_lock);
-
+			sock_put(sk);
 			ret = -EEXIST;
 			goto err_sock;
 		}
@@ -1492,10 +1496,6 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 	list_add_rcu(&tunnel->list, &pn->l2tp_tunnel_list);
 	spin_unlock_bh(&pn->l2tp_tunnel_list_lock);
 
-	sk = sock->sk;
-	sock_hold(sk);
-	tunnel->sock = sk;
-
 	if (tunnel->encap == L2TP_ENCAPTYPE_UDP) {
 		struct udp_tunnel_sock_cfg udp_cfg = {
 			.sk_user_data = tunnel,
diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index 3fd06a27105d..83a89dcf75ed 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -384,6 +384,7 @@ static int sctp_prsctp_prune_unsent(struct sctp_association *asoc,
 {
 	struct sctp_outq *q = &asoc->outqueue;
 	struct sctp_chunk *chk, *temp;
+	struct sctp_stream_out *sout;
 
 	q->sched->unsched_all(&asoc->stream);
 
@@ -398,12 +399,14 @@ static int sctp_prsctp_prune_unsent(struct sctp_association *asoc,
 		sctp_sched_dequeue_common(q, chk);
 		asoc->sent_cnt_removable--;
 		asoc->abandoned_unsent[SCTP_PR_INDEX(PRIO)]++;
-		if (chk->sinfo.sinfo_stream < asoc->stream.outcnt) {
-			struct sctp_stream_out *streamout =
-				SCTP_SO(&asoc->stream, chk->sinfo.sinfo_stream);
 
-			streamout->ext->abandoned_unsent[SCTP_PR_INDEX(PRIO)]++;
-		}
+		sout = SCTP_SO(&asoc->stream, chk->sinfo.sinfo_stream);
+		sout->ext->abandoned_unsent[SCTP_PR_INDEX(PRIO)]++;
+
+		/* clear out_curr if all frag chunks are pruned */
+		if (asoc->stream.out_curr == sout &&
+		    list_is_last(&chk->frag_list, &chk->msg->chunks))
+			asoc->stream.out_curr = NULL;
 
 		msg_len -= chk->skb->truesize + sizeof(struct sctp_chunk);
 		sctp_chunk_free(chk);
diff --git a/net/x25/x25_dev.c b/net/x25/x25_dev.c
index 25bf72ee6cad..226397add422 100644
--- a/net/x25/x25_dev.c
+++ b/net/x25/x25_dev.c
@@ -117,7 +117,7 @@ int x25_lapb_receive_frame(struct sk_buff *skb, struct net_device *dev,
 
 	if (!pskb_may_pull(skb, 1)) {
 		x25_neigh_put(nb);
-		return 0;
+		goto drop;
 	}
 
 	switch (skb->data[0]) {
diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index 6325bec3f66f..19af6dd160e6 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -1215,6 +1215,13 @@ sub dump_struct($$) {
 	$members =~ s/\s*CRYPTO_MINALIGN_ATTR/ /gos;
 	$members =~ s/\s*____cacheline_aligned_in_smp/ /gos;
 	$members =~ s/\s*____cacheline_aligned/ /gos;
+	# unwrap struct_group():
+	# - first eat non-declaration parameters and rewrite for final match
+	# - then remove macro, outer parens, and trailing semicolon
+	$members =~ s/\bstruct_group\s*\(([^,]*,)/STRUCT_GROUP(/gos;
+	$members =~ s/\bstruct_group_(attr|tagged)\s*\(([^,]*,){2}/STRUCT_GROUP(/gos;
+	$members =~ s/\b__struct_group\s*\(([^,]*,){3}/STRUCT_GROUP(/gos;
+	$members =~ s/\bSTRUCT_GROUP(\(((?:(?>[^)(]+)|(?1))*)\))[^;]*;/$2/gos;
 
 	# replace DECLARE_BITMAP
 	$members =~ s/__ETHTOOL_DECLARE_LINK_MODE_MASK\s*\(([^\)]+)\)/DECLARE_BITMAP($1, __ETHTOOL_LINK_MODE_MASK_NBITS)/gos;
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index e3f6b930ad4a..8011b451902a 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6883,6 +6883,7 @@ enum {
 	ALC256_FIXUP_MIC_NO_PRESENCE_AND_RESUME,
 	ALC285_FIXUP_LEGION_Y9000X_SPEAKERS,
 	ALC285_FIXUP_LEGION_Y9000X_AUTOMUTE,
+	ALC285_FIXUP_HP_SPEAKERS_MICMUTE_LED,
 };
 
 /* A special fixup for Lenovo C940 and Yoga Duet 7;
@@ -8693,6 +8694,16 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC269_FIXUP_HEADSET_MODE_NO_HP_MIC
 	},
+	[ALC285_FIXUP_HP_SPEAKERS_MICMUTE_LED] = {
+		.type = HDA_FIXUP_VERBS,
+		.v.verbs = (const struct hda_verb[]) {
+			 { 0x20, AC_VERB_SET_COEF_INDEX, 0x19 },
+			 { 0x20, AC_VERB_SET_PROC_COEF, 0x8e11 },
+			 { }
+		},
+		.chained = true,
+		.chain_id = ALC285_FIXUP_HP_MUTE_LED,
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -8915,6 +8926,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8870, "HP ZBook Fury 15.6 Inch G8 Mobile Workstation PC", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x8873, "HP ZBook Studio 15.6 Inch G8 Mobile Workstation PC", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x888d, "HP ZBook Power 15.6 inch G8 Mobile Workstation PC", ALC236_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8895, "HP EliteBook 855 G8 Notebook PC", ALC285_FIXUP_HP_SPEAKERS_MICMUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8896, "HP EliteBook 855 G8 Notebook PC", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x89aa, "HP EliteBook 630 G9", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x1043, 0x103e, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
@@ -8995,6 +9007,8 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x144d, 0xc176, "Samsung Notebook 9 Pro (NP930MBE-K04US)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc189, "Samsung Galaxy Flex Book (NT950QCG-X716)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc18a, "Samsung Galaxy Book Ion (NP930XCJ-K01US)", ALC298_FIXUP_SAMSUNG_AMP),
+	SND_PCI_QUIRK(0x144d, 0xc1a3, "Samsung Galaxy Book Pro (NP935XDB-KC1SE)", ALC298_FIXUP_SAMSUNG_AMP),
+	SND_PCI_QUIRK(0x144d, 0xc1a6, "Samsung Galaxy Book Pro 360 (NP930QBD)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc740, "Samsung Ativ book 8 (NP870Z5G)", ALC269_FIXUP_ATIV_BOOK_8),
 	SND_PCI_QUIRK(0x144d, 0xc812, "Samsung Notebook Pen S (NT950SBE-X58)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc830, "Samsung Galaxy Book Ion (NT950XCJ-X716A)", ALC298_FIXUP_SAMSUNG_AMP),
diff --git a/sound/soc/codecs/jz4725b.c b/sound/soc/codecs/jz4725b.c
index e49374c72e70..8a830d0ad950 100644
--- a/sound/soc/codecs/jz4725b.c
+++ b/sound/soc/codecs/jz4725b.c
@@ -136,14 +136,17 @@ enum {
 #define REG_CGR3_GO1L_OFFSET		0
 #define REG_CGR3_GO1L_MASK		(0x1f << REG_CGR3_GO1L_OFFSET)
 
+#define REG_CGR10_GIL_OFFSET		0
+#define REG_CGR10_GIR_OFFSET		4
+
 struct jz_icdc {
 	struct regmap *regmap;
 	void __iomem *base;
 	struct clk *clk;
 };
 
-static const SNDRV_CTL_TLVD_DECLARE_DB_LINEAR(jz4725b_dac_tlv, -2250, 0);
-static const SNDRV_CTL_TLVD_DECLARE_DB_LINEAR(jz4725b_line_tlv, -1500, 600);
+static const SNDRV_CTL_TLVD_DECLARE_DB_SCALE(jz4725b_adc_tlv,     0, 150, 0);
+static const SNDRV_CTL_TLVD_DECLARE_DB_SCALE(jz4725b_dac_tlv, -2250, 150, 0);
 
 static const struct snd_kcontrol_new jz4725b_codec_controls[] = {
 	SOC_DOUBLE_TLV("Master Playback Volume",
@@ -151,11 +154,11 @@ static const struct snd_kcontrol_new jz4725b_codec_controls[] = {
 		       REG_CGR1_GODL_OFFSET,
 		       REG_CGR1_GODR_OFFSET,
 		       0xf, 1, jz4725b_dac_tlv),
-	SOC_DOUBLE_R_TLV("Master Capture Volume",
-			 JZ4725B_CODEC_REG_CGR3,
-			 JZ4725B_CODEC_REG_CGR2,
-			 REG_CGR2_GO1R_OFFSET,
-			 0x1f, 1, jz4725b_line_tlv),
+	SOC_DOUBLE_TLV("Master Capture Volume",
+		       JZ4725B_CODEC_REG_CGR10,
+		       REG_CGR10_GIL_OFFSET,
+		       REG_CGR10_GIR_OFFSET,
+		       0xf, 0, jz4725b_adc_tlv),
 
 	SOC_SINGLE("Master Playback Switch", JZ4725B_CODEC_REG_CR1,
 		   REG_CR1_DAC_MUTE_OFFSET, 1, 1),
@@ -180,7 +183,7 @@ static SOC_VALUE_ENUM_SINGLE_DECL(jz4725b_codec_adc_src_enum,
 				  jz4725b_codec_adc_src_texts,
 				  jz4725b_codec_adc_src_values);
 static const struct snd_kcontrol_new jz4725b_codec_adc_src_ctrl =
-			SOC_DAPM_ENUM("Route", jz4725b_codec_adc_src_enum);
+	SOC_DAPM_ENUM("ADC Source Capture Route", jz4725b_codec_adc_src_enum);
 
 static const struct snd_kcontrol_new jz4725b_codec_mixer_controls[] = {
 	SOC_DAPM_SINGLE("Line In Bypass", JZ4725B_CODEC_REG_CR1,
@@ -225,7 +228,7 @@ static const struct snd_soc_dapm_widget jz4725b_codec_dapm_widgets[] = {
 	SND_SOC_DAPM_ADC("ADC", "Capture",
 			 JZ4725B_CODEC_REG_PMR1, REG_PMR1_SB_ADC_OFFSET, 1),
 
-	SND_SOC_DAPM_MUX("ADC Source", SND_SOC_NOPM, 0, 0,
+	SND_SOC_DAPM_MUX("ADC Source Capture Route", SND_SOC_NOPM, 0, 0,
 			 &jz4725b_codec_adc_src_ctrl),
 
 	/* Mixer */
@@ -236,7 +239,8 @@ static const struct snd_soc_dapm_widget jz4725b_codec_dapm_widgets[] = {
 	SND_SOC_DAPM_MIXER("DAC to Mixer", JZ4725B_CODEC_REG_CR1,
 			   REG_CR1_DACSEL_OFFSET, 0, NULL, 0),
 
-	SND_SOC_DAPM_MIXER("Line In", SND_SOC_NOPM, 0, 0, NULL, 0),
+	SND_SOC_DAPM_MIXER("Line In", JZ4725B_CODEC_REG_PMR1,
+			   REG_PMR1_SB_LIN_OFFSET, 1, NULL, 0),
 	SND_SOC_DAPM_MIXER("HP Out", JZ4725B_CODEC_REG_CR1,
 			   REG_CR1_HP_DIS_OFFSET, 1, NULL, 0),
 
@@ -283,11 +287,11 @@ static const struct snd_soc_dapm_route jz4725b_codec_dapm_routes[] = {
 	{"Mixer", NULL, "DAC to Mixer"},
 
 	{"Mixer to ADC", NULL, "Mixer"},
-	{"ADC Source", "Mixer", "Mixer to ADC"},
-	{"ADC Source", "Line In", "Line In"},
-	{"ADC Source", "Mic 1", "Mic 1"},
-	{"ADC Source", "Mic 2", "Mic 2"},
-	{"ADC", NULL, "ADC Source"},
+	{"ADC Source Capture Route", "Mixer", "Mixer to ADC"},
+	{"ADC Source Capture Route", "Line In", "Line In"},
+	{"ADC Source Capture Route", "Mic 1", "Mic 1"},
+	{"ADC Source Capture Route", "Mic 2", "Mic 2"},
+	{"ADC", NULL, "ADC Source Capture Route"},
 
 	{"Out Stage", NULL, "Mixer"},
 	{"HP Out", NULL, "Out Stage"},
diff --git a/sound/soc/codecs/mt6660.c b/sound/soc/codecs/mt6660.c
index e18a58868273..3cee2ea4b85d 100644
--- a/sound/soc/codecs/mt6660.c
+++ b/sound/soc/codecs/mt6660.c
@@ -504,14 +504,14 @@ static int mt6660_i2c_probe(struct i2c_client *client,
 		dev_err(chip->dev, "read chip revision fail\n");
 		goto probe_fail;
 	}
+	pm_runtime_set_active(chip->dev);
+	pm_runtime_enable(chip->dev);
 
 	ret = devm_snd_soc_register_component(chip->dev,
 					       &mt6660_component_driver,
 					       &mt6660_codec_dai, 1);
-	if (!ret) {
-		pm_runtime_set_active(chip->dev);
-		pm_runtime_enable(chip->dev);
-	}
+	if (ret)
+		pm_runtime_disable(chip->dev);
 
 	return ret;
 
diff --git a/sound/soc/codecs/rt1308-sdw.h b/sound/soc/codecs/rt1308-sdw.h
index c5ce75666dcc..98293d73ebab 100644
--- a/sound/soc/codecs/rt1308-sdw.h
+++ b/sound/soc/codecs/rt1308-sdw.h
@@ -139,9 +139,11 @@ static const struct reg_default rt1308_reg_defaults[] = {
 	{ 0x3005, 0x23 },
 	{ 0x3008, 0x02 },
 	{ 0x300a, 0x00 },
+	{ 0xc000 | (RT1308_DATA_PATH << 4), 0x00 },
 	{ 0xc003 | (RT1308_DAC_SET << 4), 0x00 },
 	{ 0xc001 | (RT1308_POWER << 4), 0x00 },
 	{ 0xc002 | (RT1308_POWER << 4), 0x00 },
+	{ 0xc000 | (RT1308_POWER_STATUS << 4), 0x00 },
 };
 
 #define RT1308_SDW_OFFSET 0xc000
diff --git a/sound/soc/codecs/tas2764.c b/sound/soc/codecs/tas2764.c
index 8b262e7f5275..c8f6f5122cac 100644
--- a/sound/soc/codecs/tas2764.c
+++ b/sound/soc/codecs/tas2764.c
@@ -386,20 +386,13 @@ static int tas2764_set_dai_tdm_slot(struct snd_soc_dai *dai,
 	if (tx_mask == 0 || rx_mask != 0)
 		return -EINVAL;
 
-	if (slots == 1) {
-		if (tx_mask != 1)
-			return -EINVAL;
-		left_slot = 0;
-		right_slot = 0;
+	left_slot = __ffs(tx_mask);
+	tx_mask &= ~(1 << left_slot);
+	if (tx_mask == 0) {
+		right_slot = left_slot;
 	} else {
-		left_slot = __ffs(tx_mask);
-		tx_mask &= ~(1 << left_slot);
-		if (tx_mask == 0) {
-			right_slot = left_slot;
-		} else {
-			right_slot = __ffs(tx_mask);
-			tx_mask &= ~(1 << right_slot);
-		}
+		right_slot = __ffs(tx_mask);
+		tx_mask &= ~(1 << right_slot);
 	}
 
 	if (tx_mask != 0 || left_slot >= slots || right_slot >= slots)
diff --git a/sound/soc/codecs/tas2770.c b/sound/soc/codecs/tas2770.c
index 171bbcc919d5..c213c8096142 100644
--- a/sound/soc/codecs/tas2770.c
+++ b/sound/soc/codecs/tas2770.c
@@ -395,21 +395,13 @@ static int tas2770_set_dai_tdm_slot(struct snd_soc_dai *dai,
 	if (tx_mask == 0 || rx_mask != 0)
 		return -EINVAL;
 
-	if (slots == 1) {
-		if (tx_mask != 1)
-			return -EINVAL;
-
-		left_slot = 0;
-		right_slot = 0;
+	left_slot = __ffs(tx_mask);
+	tx_mask &= ~(1 << left_slot);
+	if (tx_mask == 0) {
+		right_slot = left_slot;
 	} else {
-		left_slot = __ffs(tx_mask);
-		tx_mask &= ~(1 << left_slot);
-		if (tx_mask == 0) {
-			right_slot = left_slot;
-		} else {
-			right_slot = __ffs(tx_mask);
-			tx_mask &= ~(1 << right_slot);
-		}
+		right_slot = __ffs(tx_mask);
+		tx_mask &= ~(1 << right_slot);
 	}
 
 	if (tx_mask != 0 || left_slot >= slots || right_slot >= slots)
diff --git a/sound/soc/codecs/wm5102.c b/sound/soc/codecs/wm5102.c
index b7f5e5391fdb..2ed3fa67027d 100644
--- a/sound/soc/codecs/wm5102.c
+++ b/sound/soc/codecs/wm5102.c
@@ -2083,6 +2083,9 @@ static int wm5102_probe(struct platform_device *pdev)
 		regmap_update_bits(arizona->regmap, wm5102_digital_vu[i],
 				   WM5102_DIG_VU, WM5102_DIG_VU);
 
+	pm_runtime_enable(&pdev->dev);
+	pm_runtime_idle(&pdev->dev);
+
 	ret = arizona_request_irq(arizona, ARIZONA_IRQ_DSP_IRQ1,
 				  "ADSP2 Compressed IRQ", wm5102_adsp2_irq,
 				  wm5102);
@@ -2115,9 +2118,6 @@ static int wm5102_probe(struct platform_device *pdev)
 		goto err_spk_irqs;
 	}
 
-	pm_runtime_enable(&pdev->dev);
-	pm_runtime_idle(&pdev->dev);
-
 	return ret;
 
 err_spk_irqs:
diff --git a/sound/soc/codecs/wm5110.c b/sound/soc/codecs/wm5110.c
index c158f8b1e8e4..d0cef982215d 100644
--- a/sound/soc/codecs/wm5110.c
+++ b/sound/soc/codecs/wm5110.c
@@ -2452,6 +2452,9 @@ static int wm5110_probe(struct platform_device *pdev)
 		regmap_update_bits(arizona->regmap, wm5110_digital_vu[i],
 				   WM5110_DIG_VU, WM5110_DIG_VU);
 
+	pm_runtime_enable(&pdev->dev);
+	pm_runtime_idle(&pdev->dev);
+
 	ret = arizona_request_irq(arizona, ARIZONA_IRQ_DSP_IRQ1,
 				  "ADSP2 Compressed IRQ", wm5110_adsp2_irq,
 				  wm5110);
@@ -2484,9 +2487,6 @@ static int wm5110_probe(struct platform_device *pdev)
 		goto err_spk_irqs;
 	}
 
-	pm_runtime_enable(&pdev->dev);
-	pm_runtime_idle(&pdev->dev);
-
 	return ret;
 
 err_spk_irqs:
diff --git a/sound/soc/codecs/wm8962.c b/sound/soc/codecs/wm8962.c
index 38651022e3d5..21574447650c 100644
--- a/sound/soc/codecs/wm8962.c
+++ b/sound/soc/codecs/wm8962.c
@@ -1840,6 +1840,49 @@ SOC_SINGLE_TLV("SPKOUTR Mixer DACR Volume", WM8962_SPEAKER_MIXER_5,
 	       4, 1, 0, inmix_tlv),
 };
 
+static int tp_event(struct snd_soc_dapm_widget *w,
+		    struct snd_kcontrol *kcontrol, int event)
+{
+	int ret, reg, val, mask;
+	struct snd_soc_component *component = snd_soc_dapm_to_component(w->dapm);
+
+	ret = pm_runtime_resume_and_get(component->dev);
+	if (ret < 0) {
+		dev_err(component->dev, "Failed to resume device: %d\n", ret);
+		return ret;
+	}
+
+	reg = WM8962_ADDITIONAL_CONTROL_4;
+
+	if (!strcmp(w->name, "TEMP_HP")) {
+		mask = WM8962_TEMP_ENA_HP_MASK;
+		val = WM8962_TEMP_ENA_HP;
+	} else if (!strcmp(w->name, "TEMP_SPK")) {
+		mask = WM8962_TEMP_ENA_SPK_MASK;
+		val = WM8962_TEMP_ENA_SPK;
+	} else {
+		pm_runtime_put(component->dev);
+		return -EINVAL;
+	}
+
+	switch (event) {
+	case SND_SOC_DAPM_POST_PMD:
+		val = 0;
+		fallthrough;
+	case SND_SOC_DAPM_POST_PMU:
+		ret = snd_soc_component_update_bits(component, reg, mask, val);
+		break;
+	default:
+		WARN(1, "Invalid event %d\n", event);
+		pm_runtime_put(component->dev);
+		return -EINVAL;
+	}
+
+	pm_runtime_put(component->dev);
+
+	return 0;
+}
+
 static int cp_event(struct snd_soc_dapm_widget *w,
 		    struct snd_kcontrol *kcontrol, int event)
 {
@@ -2133,8 +2176,10 @@ SND_SOC_DAPM_SUPPLY("TOCLK", WM8962_ADDITIONAL_CONTROL_1, 0, 0, NULL, 0),
 SND_SOC_DAPM_SUPPLY_S("DSP2", 1, WM8962_DSP2_POWER_MANAGEMENT,
 		      WM8962_DSP2_ENA_SHIFT, 0, dsp2_event,
 		      SND_SOC_DAPM_POST_PMU | SND_SOC_DAPM_PRE_PMD),
-SND_SOC_DAPM_SUPPLY("TEMP_HP", WM8962_ADDITIONAL_CONTROL_4, 2, 0, NULL, 0),
-SND_SOC_DAPM_SUPPLY("TEMP_SPK", WM8962_ADDITIONAL_CONTROL_4, 1, 0, NULL, 0),
+SND_SOC_DAPM_SUPPLY("TEMP_HP", SND_SOC_NOPM, 0, 0, tp_event,
+		SND_SOC_DAPM_POST_PMU|SND_SOC_DAPM_POST_PMD),
+SND_SOC_DAPM_SUPPLY("TEMP_SPK", SND_SOC_NOPM, 0, 0, tp_event,
+		SND_SOC_DAPM_POST_PMU|SND_SOC_DAPM_POST_PMD),
 
 SND_SOC_DAPM_MIXER("INPGAL", WM8962_LEFT_INPUT_PGA_CONTROL, 4, 0,
 		   inpgal, ARRAY_SIZE(inpgal)),
@@ -3760,6 +3805,11 @@ static int wm8962_i2c_probe(struct i2c_client *i2c,
 	if (ret < 0)
 		goto err_pm_runtime;
 
+	regmap_update_bits(wm8962->regmap, WM8962_ADDITIONAL_CONTROL_4,
+			    WM8962_TEMP_ENA_HP_MASK, 0);
+	regmap_update_bits(wm8962->regmap, WM8962_ADDITIONAL_CONTROL_4,
+			    WM8962_TEMP_ENA_SPK_MASK, 0);
+
 	regcache_cache_only(wm8962->regmap, true);
 
 	/* The drivers should power up as needed */
diff --git a/sound/soc/codecs/wm8997.c b/sound/soc/codecs/wm8997.c
index 07378714b013..229f2986cd96 100644
--- a/sound/soc/codecs/wm8997.c
+++ b/sound/soc/codecs/wm8997.c
@@ -1156,6 +1156,9 @@ static int wm8997_probe(struct platform_device *pdev)
 		regmap_update_bits(arizona->regmap, wm8997_digital_vu[i],
 				   WM8997_DIG_VU, WM8997_DIG_VU);
 
+	pm_runtime_enable(&pdev->dev);
+	pm_runtime_idle(&pdev->dev);
+
 	arizona_init_common(arizona);
 
 	ret = arizona_init_vol_limit(arizona);
@@ -1174,9 +1177,6 @@ static int wm8997_probe(struct platform_device *pdev)
 		goto err_spk_irqs;
 	}
 
-	pm_runtime_enable(&pdev->dev);
-	pm_runtime_idle(&pdev->dev);
-
 	return ret;
 
 err_spk_irqs:
diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index a6d6d10cd471..e9da95ebccc8 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -3178,10 +3178,23 @@ EXPORT_SYMBOL_GPL(snd_soc_of_get_dai_link_codecs);
 
 static int __init snd_soc_init(void)
 {
+	int ret;
+
 	snd_soc_debugfs_init();
-	snd_soc_util_init();
+	ret = snd_soc_util_init();
+	if (ret)
+		goto err_util_init;
 
-	return platform_driver_register(&soc_driver);
+	ret = platform_driver_register(&soc_driver);
+	if (ret)
+		goto err_register;
+	return 0;
+
+err_register:
+	snd_soc_util_exit();
+err_util_init:
+	snd_soc_debugfs_exit();
+	return ret;
 }
 module_init(snd_soc_init);
 
diff --git a/sound/soc/soc-utils.c b/sound/soc/soc-utils.c
index f27f94ca064b..6b398ffabb02 100644
--- a/sound/soc/soc-utils.c
+++ b/sound/soc/soc-utils.c
@@ -171,7 +171,7 @@ int __init snd_soc_util_init(void)
 	return ret;
 }
 
-void __exit snd_soc_util_exit(void)
+void snd_soc_util_exit(void)
 {
 	platform_driver_unregister(&soc_dummy_driver);
 	platform_device_unregister(soc_dummy_dev);
diff --git a/sound/usb/midi.c b/sound/usb/midi.c
index 93fee6e365a6..b02e1a33304f 100644
--- a/sound/usb/midi.c
+++ b/sound/usb/midi.c
@@ -1149,10 +1149,8 @@ static int snd_usbmidi_output_open(struct snd_rawmidi_substream *substream)
 					port = &umidi->endpoints[i].out->ports[j];
 					break;
 				}
-	if (!port) {
-		snd_BUG();
+	if (!port)
 		return -ENXIO;
-	}
 
 	substream->runtime->private_data = port;
 	port->state = STATE_UNKNOWN;
diff --git a/tools/testing/selftests/futex/functional/Makefile b/tools/testing/selftests/futex/functional/Makefile
index 23207829ec75..6a0ed2e7881e 100644
--- a/tools/testing/selftests/futex/functional/Makefile
+++ b/tools/testing/selftests/futex/functional/Makefile
@@ -3,11 +3,11 @@ INCLUDES := -I../include -I../../
 CFLAGS := $(CFLAGS) -g -O2 -Wall -D_GNU_SOURCE -pthread $(INCLUDES)
 LDLIBS := -lpthread -lrt
 
-HEADERS := \
+LOCAL_HDRS := \
 	../include/futextest.h \
 	../include/atomic.h \
 	../include/logging.h
-TEST_GEN_FILES := \
+TEST_GEN_PROGS := \
 	futex_wait_timeout \
 	futex_wait_wouldblock \
 	futex_requeue_pi \
@@ -21,5 +21,3 @@ TEST_PROGS := run.sh
 top_srcdir = ../../../../..
 KSFT_KHDR_INSTALL := 1
 include ../../lib.mk
-
-$(TEST_GEN_FILES): $(HEADERS)
diff --git a/tools/testing/selftests/intel_pstate/Makefile b/tools/testing/selftests/intel_pstate/Makefile
index 39f0fa2a8fd6..05d66ef50c97 100644
--- a/tools/testing/selftests/intel_pstate/Makefile
+++ b/tools/testing/selftests/intel_pstate/Makefile
@@ -2,10 +2,10 @@
 CFLAGS := $(CFLAGS) -Wall -D_GNU_SOURCE
 LDLIBS += -lm
 
-uname_M := $(shell uname -m 2>/dev/null || echo not)
-ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/x86/ -e s/x86_64/x86/)
+ARCH ?= $(shell uname -m 2>/dev/null || echo not)
+ARCH_PROCESSED := $(shell echo $(ARCH) | sed -e s/i.86/x86/ -e s/x86_64/x86/)
 
-ifeq (x86,$(ARCH))
+ifeq (x86,$(ARCH_PROCESSED))
 TEST_GEN_FILES := msr aperf
 endif
 

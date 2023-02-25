Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 461F36A293F
	for <lists+stable@lfdr.de>; Sat, 25 Feb 2023 12:09:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229379AbjBYLJD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Feb 2023 06:09:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbjBYLJC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Feb 2023 06:09:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65D7517CE3;
        Sat, 25 Feb 2023 03:08:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F88560AF7;
        Sat, 25 Feb 2023 11:08:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73828C433D2;
        Sat, 25 Feb 2023 11:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677323329;
        bh=wSUHao70SZLDCybXNi+LJG+ifnc1moQQKfQKTRaKYt4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K6PRFTm/LCIRiATfiUdNlagz8oqNmG9xGepGAM+BkmEq5keS8Kwftgn3qkqZTXvNf
         FngicA1elgCcB3fQyd+BX5NWFPSbuqFYdkk/rPEkslh6iTqtcxLlawgYcKAJTCEBxY
         WvnWJTpxF2KOP1BMMovfi6bP/29YPbUNMQMZkvyc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.19.274
Date:   Sat, 25 Feb 2023 12:08:38 +0100
Message-Id: <167732331722267@kroah.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <1677323317234100@kroah.com>
References: <1677323317234100@kroah.com>
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

diff --git a/Makefile b/Makefile
index bbc26e110a13..273379e3f477 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 19
-SUBLEVEL = 273
+SUBLEVEL = 274
 EXTRAVERSION =
 NAME = "People's Front"
 
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
new file mode 100644
index 000000000000..437dab3fc017
--- /dev/null
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
@@ -0,0 +1,44 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0-or-later
+/*
+ * QorIQ FMan v3 10g port #2 device tree stub [ controller @ offset 0x400000 ]
+ *
+ * Copyright 2022 Sean Anderson <sean.anderson@seco.com>
+ * Copyright 2012 - 2015 Freescale Semiconductor Inc.
+ */
+
+fman@400000 {
+	fman0_rx_0x08: port@88000 {
+		cell-index = <0x8>;
+		compatible = "fsl,fman-v3-port-rx";
+		reg = <0x88000 0x1000>;
+		fsl,fman-10g-port;
+	};
+
+	fman0_tx_0x28: port@a8000 {
+		cell-index = <0x28>;
+		compatible = "fsl,fman-v3-port-tx";
+		reg = <0xa8000 0x1000>;
+		fsl,fman-10g-port;
+	};
+
+	ethernet@e0000 {
+		cell-index = <0>;
+		compatible = "fsl,fman-memac";
+		reg = <0xe0000 0x1000>;
+		fsl,fman-ports = <&fman0_rx_0x08 &fman0_tx_0x28>;
+		ptp-timer = <&ptp_timer0>;
+		pcsphy-handle = <&pcsphy0>;
+	};
+
+	mdio@e1000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
+		reg = <0xe1000 0x1000>;
+		fsl,erratum-a011043; /* must ignore read errors */
+
+		pcsphy0: ethernet-phy@0 {
+			reg = <0x0>;
+		};
+	};
+};
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi
new file mode 100644
index 000000000000..ad116b17850a
--- /dev/null
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi
@@ -0,0 +1,44 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0-or-later
+/*
+ * QorIQ FMan v3 10g port #3 device tree stub [ controller @ offset 0x400000 ]
+ *
+ * Copyright 2022 Sean Anderson <sean.anderson@seco.com>
+ * Copyright 2012 - 2015 Freescale Semiconductor Inc.
+ */
+
+fman@400000 {
+	fman0_rx_0x09: port@89000 {
+		cell-index = <0x9>;
+		compatible = "fsl,fman-v3-port-rx";
+		reg = <0x89000 0x1000>;
+		fsl,fman-10g-port;
+	};
+
+	fman0_tx_0x29: port@a9000 {
+		cell-index = <0x29>;
+		compatible = "fsl,fman-v3-port-tx";
+		reg = <0xa9000 0x1000>;
+		fsl,fman-10g-port;
+	};
+
+	ethernet@e2000 {
+		cell-index = <1>;
+		compatible = "fsl,fman-memac";
+		reg = <0xe2000 0x1000>;
+		fsl,fman-ports = <&fman0_rx_0x09 &fman0_tx_0x29>;
+		ptp-timer = <&ptp_timer0>;
+		pcsphy-handle = <&pcsphy1>;
+	};
+
+	mdio@e3000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
+		reg = <0xe3000 0x1000>;
+		fsl,erratum-a011043; /* must ignore read errors */
+
+		pcsphy1: ethernet-phy@0 {
+			reg = <0x0>;
+		};
+	};
+};
diff --git a/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi b/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
index a97296c64eb2..fda6c9213d9e 100644
--- a/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
+++ b/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
@@ -631,8 +631,8 @@
 /include/ "qoriq-bman1.dtsi"
 
 /include/ "qoriq-fman3-0.dtsi"
-/include/ "qoriq-fman3-0-1g-0.dtsi"
-/include/ "qoriq-fman3-0-1g-1.dtsi"
+/include/ "qoriq-fman3-0-10g-2.dtsi"
+/include/ "qoriq-fman3-0-10g-3.dtsi"
 /include/ "qoriq-fman3-0-1g-2.dtsi"
 /include/ "qoriq-fman3-0-1g-3.dtsi"
 /include/ "qoriq-fman3-0-1g-4.dtsi"
@@ -681,3 +681,19 @@
 		interrupts = <16 2 1 9>;
 	};
 };
+
+&fman0_rx_0x08 {
+	/delete-property/ fsl,fman-10g-port;
+};
+
+&fman0_tx_0x28 {
+	/delete-property/ fsl,fman-10g-port;
+};
+
+&fman0_rx_0x09 {
+	/delete-property/ fsl,fman-10g-port;
+};
+
+&fman0_tx_0x29 {
+	/delete-property/ fsl,fman-10g-port;
+};
diff --git a/drivers/gpu/drm/i915/gvt/gtt.c b/drivers/gpu/drm/i915/gvt/gtt.c
index 40b32b4d1d98..afbc648befec 100644
--- a/drivers/gpu/drm/i915/gvt/gtt.c
+++ b/drivers/gpu/drm/i915/gvt/gtt.c
@@ -1155,10 +1155,8 @@ static int split_2MB_gtt_entry(struct intel_vgpu *vgpu,
 	for_each_shadow_entry(sub_spt, &sub_se, sub_index) {
 		ret = intel_gvt_hypervisor_dma_map_guest_page(vgpu,
 				start_gfn + sub_index, PAGE_SIZE, &dma_addr);
-		if (ret) {
-			ppgtt_invalidate_spt(spt);
-			return ret;
-		}
+		if (ret)
+			goto err;
 		sub_se.val64 = se->val64;
 
 		/* Copy the PAT field from PDE. */
@@ -1177,6 +1175,17 @@ static int split_2MB_gtt_entry(struct intel_vgpu *vgpu,
 	ops->set_pfn(se, sub_spt->shadow_page.mfn);
 	ppgtt_set_shadow_entry(spt, se, index);
 	return 0;
+err:
+	/* Cancel the existing addess mappings of DMA addr. */
+	for_each_present_shadow_entry(sub_spt, &sub_se, sub_index) {
+		gvt_vdbg_mm("invalidate 4K entry\n");
+		ppgtt_invalidate_pte(sub_spt, &sub_se);
+	}
+	/* Release the new allocated spt. */
+	trace_spt_change(sub_spt->vgpu->id, "release", sub_spt,
+		sub_spt->guest_page.gfn, sub_spt->shadow_page.type);
+	ppgtt_free_spt(sub_spt);
+	return ret;
 }
 
 static int split_64KB_gtt_entry(struct intel_vgpu *vgpu,
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
index 2764fdd7e84b..233bbfeaa771 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
@@ -518,6 +518,7 @@ static int kvaser_usb_hydra_send_simple_cmd(struct kvaser_usb *dev,
 					    u8 cmd_no, int channel)
 {
 	struct kvaser_cmd *cmd;
+	size_t cmd_len;
 	int err;
 
 	cmd = kcalloc(1, sizeof(struct kvaser_cmd), GFP_KERNEL);
@@ -525,6 +526,7 @@ static int kvaser_usb_hydra_send_simple_cmd(struct kvaser_usb *dev,
 		return -ENOMEM;
 
 	cmd->header.cmd_no = cmd_no;
+	cmd_len = kvaser_usb_hydra_cmd_size(cmd);
 	if (channel < 0) {
 		kvaser_usb_hydra_set_cmd_dest_he
 				(cmd, KVASER_USB_HYDRA_HE_ADDRESS_ILLEGAL);
@@ -541,7 +543,7 @@ static int kvaser_usb_hydra_send_simple_cmd(struct kvaser_usb *dev,
 	kvaser_usb_hydra_set_cmd_transid
 				(cmd, kvaser_usb_hydra_get_next_transid(dev));
 
-	err = kvaser_usb_send_cmd(dev, cmd, kvaser_usb_hydra_cmd_size(cmd));
+	err = kvaser_usb_send_cmd(dev, cmd, cmd_len);
 	if (err)
 		goto end;
 
@@ -557,6 +559,7 @@ kvaser_usb_hydra_send_simple_cmd_async(struct kvaser_usb_net_priv *priv,
 {
 	struct kvaser_cmd *cmd;
 	struct kvaser_usb *dev = priv->dev;
+	size_t cmd_len;
 	int err;
 
 	cmd = kcalloc(1, sizeof(struct kvaser_cmd), GFP_ATOMIC);
@@ -564,14 +567,14 @@ kvaser_usb_hydra_send_simple_cmd_async(struct kvaser_usb_net_priv *priv,
 		return -ENOMEM;
 
 	cmd->header.cmd_no = cmd_no;
+	cmd_len = kvaser_usb_hydra_cmd_size(cmd);
 
 	kvaser_usb_hydra_set_cmd_dest_he
 		(cmd, dev->card_data.hydra.channel_to_he[priv->channel]);
 	kvaser_usb_hydra_set_cmd_transid
 				(cmd, kvaser_usb_hydra_get_next_transid(dev));
 
-	err = kvaser_usb_send_cmd_async(priv, cmd,
-					kvaser_usb_hydra_cmd_size(cmd));
+	err = kvaser_usb_send_cmd_async(priv, cmd, cmd_len);
 	if (err)
 		kfree(cmd);
 
@@ -715,6 +718,7 @@ static int kvaser_usb_hydra_get_single_capability(struct kvaser_usb *dev,
 {
 	struct kvaser_usb_dev_card_data *card_data = &dev->card_data;
 	struct kvaser_cmd *cmd;
+	size_t cmd_len;
 	u32 value = 0;
 	u32 mask = 0;
 	u16 cap_cmd_res;
@@ -726,13 +730,14 @@ static int kvaser_usb_hydra_get_single_capability(struct kvaser_usb *dev,
 		return -ENOMEM;
 
 	cmd->header.cmd_no = CMD_GET_CAPABILITIES_REQ;
+	cmd_len = kvaser_usb_hydra_cmd_size(cmd);
 	cmd->cap_req.cap_cmd = cpu_to_le16(cap_cmd_req);
 
 	kvaser_usb_hydra_set_cmd_dest_he(cmd, card_data->hydra.sysdbg_he);
 	kvaser_usb_hydra_set_cmd_transid
 				(cmd, kvaser_usb_hydra_get_next_transid(dev));
 
-	err = kvaser_usb_send_cmd(dev, cmd, kvaser_usb_hydra_cmd_size(cmd));
+	err = kvaser_usb_send_cmd(dev, cmd, cmd_len);
 	if (err)
 		goto end;
 
@@ -1555,6 +1560,7 @@ static int kvaser_usb_hydra_get_busparams(struct kvaser_usb_net_priv *priv,
 	struct kvaser_usb *dev = priv->dev;
 	struct kvaser_usb_net_hydra_priv *hydra = priv->sub_priv;
 	struct kvaser_cmd *cmd;
+	size_t cmd_len;
 	int err;
 
 	if (!hydra)
@@ -1565,6 +1571,7 @@ static int kvaser_usb_hydra_get_busparams(struct kvaser_usb_net_priv *priv,
 		return -ENOMEM;
 
 	cmd->header.cmd_no = CMD_GET_BUSPARAMS_REQ;
+	cmd_len = kvaser_usb_hydra_cmd_size(cmd);
 	kvaser_usb_hydra_set_cmd_dest_he
 		(cmd, dev->card_data.hydra.channel_to_he[priv->channel]);
 	kvaser_usb_hydra_set_cmd_transid
@@ -1574,7 +1581,7 @@ static int kvaser_usb_hydra_get_busparams(struct kvaser_usb_net_priv *priv,
 
 	reinit_completion(&priv->get_busparams_comp);
 
-	err = kvaser_usb_send_cmd(dev, cmd, kvaser_usb_hydra_cmd_size(cmd));
+	err = kvaser_usb_send_cmd(dev, cmd, cmd_len);
 	if (err)
 		return err;
 
@@ -1601,6 +1608,7 @@ static int kvaser_usb_hydra_set_bittiming(const struct net_device *netdev,
 	struct kvaser_cmd *cmd;
 	struct kvaser_usb_net_priv *priv = netdev_priv(netdev);
 	struct kvaser_usb *dev = priv->dev;
+	size_t cmd_len;
 	int err;
 
 	cmd = kcalloc(1, sizeof(struct kvaser_cmd), GFP_KERNEL);
@@ -1608,6 +1616,7 @@ static int kvaser_usb_hydra_set_bittiming(const struct net_device *netdev,
 		return -ENOMEM;
 
 	cmd->header.cmd_no = CMD_SET_BUSPARAMS_REQ;
+	cmd_len = kvaser_usb_hydra_cmd_size(cmd);
 	memcpy(&cmd->set_busparams_req.busparams_nominal, busparams,
 	       sizeof(cmd->set_busparams_req.busparams_nominal));
 
@@ -1616,7 +1625,7 @@ static int kvaser_usb_hydra_set_bittiming(const struct net_device *netdev,
 	kvaser_usb_hydra_set_cmd_transid
 				(cmd, kvaser_usb_hydra_get_next_transid(dev));
 
-	err = kvaser_usb_send_cmd(dev, cmd, kvaser_usb_hydra_cmd_size(cmd));
+	err = kvaser_usb_send_cmd(dev, cmd, cmd_len);
 
 	kfree(cmd);
 
@@ -1629,6 +1638,7 @@ static int kvaser_usb_hydra_set_data_bittiming(const struct net_device *netdev,
 	struct kvaser_cmd *cmd;
 	struct kvaser_usb_net_priv *priv = netdev_priv(netdev);
 	struct kvaser_usb *dev = priv->dev;
+	size_t cmd_len;
 	int err;
 
 	cmd = kcalloc(1, sizeof(struct kvaser_cmd), GFP_KERNEL);
@@ -1636,6 +1646,7 @@ static int kvaser_usb_hydra_set_data_bittiming(const struct net_device *netdev,
 		return -ENOMEM;
 
 	cmd->header.cmd_no = CMD_SET_BUSPARAMS_FD_REQ;
+	cmd_len = kvaser_usb_hydra_cmd_size(cmd);
 	memcpy(&cmd->set_busparams_req.busparams_data, busparams,
 	       sizeof(cmd->set_busparams_req.busparams_data));
 
@@ -1653,7 +1664,7 @@ static int kvaser_usb_hydra_set_data_bittiming(const struct net_device *netdev,
 	kvaser_usb_hydra_set_cmd_transid
 				(cmd, kvaser_usb_hydra_get_next_transid(dev));
 
-	err = kvaser_usb_send_cmd(dev, cmd, kvaser_usb_hydra_cmd_size(cmd));
+	err = kvaser_usb_send_cmd(dev, cmd, cmd_len);
 
 	kfree(cmd);
 
@@ -1781,6 +1792,7 @@ static int kvaser_usb_hydra_get_software_info(struct kvaser_usb *dev)
 static int kvaser_usb_hydra_get_software_details(struct kvaser_usb *dev)
 {
 	struct kvaser_cmd *cmd;
+	size_t cmd_len;
 	int err;
 	u32 flags;
 	struct kvaser_usb_dev_card_data *card_data = &dev->card_data;
@@ -1790,6 +1802,7 @@ static int kvaser_usb_hydra_get_software_details(struct kvaser_usb *dev)
 		return -ENOMEM;
 
 	cmd->header.cmd_no = CMD_GET_SOFTWARE_DETAILS_REQ;
+	cmd_len = kvaser_usb_hydra_cmd_size(cmd);
 	cmd->sw_detail_req.use_ext_cmd = 1;
 	kvaser_usb_hydra_set_cmd_dest_he
 				(cmd, KVASER_USB_HYDRA_HE_ADDRESS_ILLEGAL);
@@ -1797,7 +1810,7 @@ static int kvaser_usb_hydra_get_software_details(struct kvaser_usb *dev)
 	kvaser_usb_hydra_set_cmd_transid
 				(cmd, kvaser_usb_hydra_get_next_transid(dev));
 
-	err = kvaser_usb_send_cmd(dev, cmd, kvaser_usb_hydra_cmd_size(cmd));
+	err = kvaser_usb_send_cmd(dev, cmd, cmd_len);
 	if (err)
 		goto end;
 
@@ -1913,6 +1926,7 @@ static int kvaser_usb_hydra_set_opt_mode(const struct kvaser_usb_net_priv *priv)
 {
 	struct kvaser_usb *dev = priv->dev;
 	struct kvaser_cmd *cmd;
+	size_t cmd_len;
 	int err;
 
 	if ((priv->can.ctrlmode &
@@ -1928,6 +1942,7 @@ static int kvaser_usb_hydra_set_opt_mode(const struct kvaser_usb_net_priv *priv)
 		return -ENOMEM;
 
 	cmd->header.cmd_no = CMD_SET_DRIVERMODE_REQ;
+	cmd_len = kvaser_usb_hydra_cmd_size(cmd);
 	kvaser_usb_hydra_set_cmd_dest_he
 		(cmd, dev->card_data.hydra.channel_to_he[priv->channel]);
 	kvaser_usb_hydra_set_cmd_transid
@@ -1937,7 +1952,7 @@ static int kvaser_usb_hydra_set_opt_mode(const struct kvaser_usb_net_priv *priv)
 	else
 		cmd->set_ctrlmode.mode = KVASER_USB_HYDRA_CTRLMODE_NORMAL;
 
-	err = kvaser_usb_send_cmd(dev, cmd, kvaser_usb_hydra_cmd_size(cmd));
+	err = kvaser_usb_send_cmd(dev, cmd, cmd_len);
 	kfree(cmd);
 
 	return err;
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index 0773d81072aa..a484dc6ad30d 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -58,6 +58,7 @@ static struct memory_type_mapping mem_type_mapping_tbl[] = {
 };
 
 static const struct of_device_id mwifiex_sdio_of_match_table[] = {
+	{ .compatible = "marvell,sd8787" },
 	{ .compatible = "marvell,sd8897" },
 	{ .compatible = "marvell,sd8997" },
 	{ }
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index c3c8382dd0ba..e5aac9694ade 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -4375,12 +4375,9 @@ void rtl8xxxu_gen1_report_connect(struct rtl8xxxu_priv *priv,
 void rtl8xxxu_gen2_report_connect(struct rtl8xxxu_priv *priv,
 				  u8 macid, bool connect)
 {
-#ifdef RTL8XXXU_GEN2_REPORT_CONNECT
 	/*
-	 * Barry Day reports this causes issues with 8192eu and 8723bu
-	 * devices reconnecting. The reason for this is unclear, but
-	 * until it is better understood, leave the code in place but
-	 * disabled, so it is not lost.
+	 * The firmware turns on the rate control when it knows it's
+	 * connected to a network.
 	 */
 	struct h2c_cmd h2c;
 
@@ -4393,7 +4390,6 @@ void rtl8xxxu_gen2_report_connect(struct rtl8xxxu_priv *priv,
 		h2c.media_status_rpt.parm &= ~BIT(0);
 
 	rtl8xxxu_gen2_h2c_cmd(priv, &h2c, sizeof(h2c.media_status_rpt));
-#endif
 }
 
 void rtl8xxxu_gen1_init_aggregation(struct rtl8xxxu_priv *priv)
diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
index 9212a026a1f1..74722ce7206c 100644
--- a/fs/ext4/sysfs.c
+++ b/fs/ext4/sysfs.c
@@ -349,6 +349,11 @@ static void ext4_sb_release(struct kobject *kobj)
 	complete(&sbi->s_kobj_unregister);
 }
 
+static void ext4_feat_release(struct kobject *kobj)
+{
+	kfree(kobj);
+}
+
 static const struct sysfs_ops ext4_attr_ops = {
 	.show	= ext4_attr_show,
 	.store	= ext4_attr_store,
@@ -363,7 +368,7 @@ static struct kobj_type ext4_sb_ktype = {
 static struct kobj_type ext4_feat_ktype = {
 	.default_attrs	= ext4_feat_attrs,
 	.sysfs_ops	= &ext4_attr_ops,
-	.release	= (void (*)(struct kobject *))kfree,
+	.release	= ext4_feat_release,
 };
 
 static struct kobject *ext4_root;
diff --git a/include/linux/nospec.h b/include/linux/nospec.h
index 0c5ef54fd416..207ef2a20e48 100644
--- a/include/linux/nospec.h
+++ b/include/linux/nospec.h
@@ -9,6 +9,10 @@
 
 struct task_struct;
 
+#ifndef barrier_nospec
+# define barrier_nospec() do { } while (0)
+#endif
+
 /**
  * array_index_mask_nospec() - generate a ~0 mask when index < size, 0 otherwise
  * @index: array element index
diff --git a/include/linux/random.h b/include/linux/random.h
index 3feafab498ad..ed75fb2b0ca9 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -19,14 +19,14 @@ void add_input_randomness(unsigned int type, unsigned int code,
 void add_interrupt_randomness(int irq) __latent_entropy;
 void add_hwgenerator_randomness(const void *buf, size_t len, size_t entropy);
 
-#if defined(LATENT_ENTROPY_PLUGIN) && !defined(__CHECKER__)
 static inline void add_latent_entropy(void)
 {
+#if defined(LATENT_ENTROPY_PLUGIN) && !defined(__CHECKER__)
 	add_device_randomness((const void *)&latent_entropy, sizeof(latent_entropy));
-}
 #else
-static inline void add_latent_entropy(void) { }
+	add_device_randomness(NULL, 0);
 #endif
+}
 
 void get_random_bytes(void *buf, size_t len);
 size_t __must_check get_random_bytes_arch(void *buf, size_t len);
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index cbbd0168f50c..24e16538e4d7 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -32,6 +32,7 @@
 #include <linux/kallsyms.h>
 #include <linux/rcupdate.h>
 #include <linux/perf_event.h>
+#include <linux/nospec.h>
 
 #include <asm/barrier.h>
 #include <asm/unaligned.h>
@@ -1373,9 +1374,7 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
 		 * reuse preexisting logic from Spectre v1 mitigation that
 		 * happens to produce the required code on x86 for v4 as well.
 		 */
-#ifdef CONFIG_X86
 		barrier_nospec();
-#endif
 		CONT;
 #define LDST(SIZEOP, SIZE)						\
 	STX_MEM_##SIZEOP:						\
diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index 6a2ba39889bd..56af8a97cf2d 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -476,11 +476,35 @@ u64 alarm_forward(struct alarm *alarm, ktime_t now, ktime_t interval)
 }
 EXPORT_SYMBOL_GPL(alarm_forward);
 
-u64 alarm_forward_now(struct alarm *alarm, ktime_t interval)
+static u64 __alarm_forward_now(struct alarm *alarm, ktime_t interval, bool throttle)
 {
 	struct alarm_base *base = &alarm_bases[alarm->type];
+	ktime_t now = base->gettime();
+
+	if (IS_ENABLED(CONFIG_HIGH_RES_TIMERS) && throttle) {
+		/*
+		 * Same issue as with posix_timer_fn(). Timers which are
+		 * periodic but the signal is ignored can starve the system
+		 * with a very small interval. The real fix which was
+		 * promised in the context of posix_timer_fn() never
+		 * materialized, but someone should really work on it.
+		 *
+		 * To prevent DOS fake @now to be 1 jiffie out which keeps
+		 * the overrun accounting correct but creates an
+		 * inconsistency vs. timer_gettime(2).
+		 */
+		ktime_t kj = NSEC_PER_SEC / HZ;
+
+		if (interval < kj)
+			now = ktime_add(now, kj);
+	}
+
+	return alarm_forward(alarm, now, interval);
+}
 
-	return alarm_forward(alarm, base->gettime(), interval);
+u64 alarm_forward_now(struct alarm *alarm, ktime_t interval)
+{
+	return __alarm_forward_now(alarm, interval, false);
 }
 EXPORT_SYMBOL_GPL(alarm_forward_now);
 
@@ -554,9 +578,10 @@ static enum alarmtimer_restart alarm_handle_timer(struct alarm *alarm,
 	if (posix_timer_event(ptr, si_private) && ptr->it_interval) {
 		/*
 		 * Handle ignored signals and rearm the timer. This will go
-		 * away once we handle ignored signals proper.
+		 * away once we handle ignored signals proper. Ensure that
+		 * small intervals cannot starve the system.
 		 */
-		ptr->it_overrun += alarm_forward_now(alarm, ptr->it_interval);
+		ptr->it_overrun += __alarm_forward_now(alarm, ptr->it_interval, true);
 		++ptr->it_requeue_pending;
 		ptr->it_active = 1;
 		result = ALARMTIMER_RESTART;
diff --git a/lib/usercopy.c b/lib/usercopy.c
index 3744b2a8e591..1e99c1baf4ff 100644
--- a/lib/usercopy.c
+++ b/lib/usercopy.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/uaccess.h>
+#include <linux/nospec.h>
 
 /* out-of-line parts */
 
@@ -9,6 +10,12 @@ unsigned long _copy_from_user(void *to, const void __user *from, unsigned long n
 	unsigned long res = n;
 	might_fault();
 	if (likely(access_ok(VERIFY_READ, from, n))) {
+		/*
+		 * Ensure that bad access_ok() speculation will not
+		 * lead to nasty side effects *after* the copy is
+		 * finished:
+		 */
+		barrier_nospec();
 		kasan_check_write(to, n);
 		res = raw_copy_from_user(to, from, n);
 	}
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 2c2532196ef6..c5e5e978d3ed 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -627,6 +627,26 @@ struct mesh_csa_settings {
 	struct cfg80211_csa_settings settings;
 };
 
+/**
+ * struct mesh_table
+ *
+ * @known_gates: list of known mesh gates and their mpaths by the station. The
+ * gate's mpath may or may not be resolved and active.
+ * @gates_lock: protects updates to known_gates
+ * @rhead: the rhashtable containing struct mesh_paths, keyed by dest addr
+ * @walk_head: linked list containing all mesh_path objects
+ * @walk_lock: lock protecting walk_head
+ * @entries: number of entries in the table
+ */
+struct mesh_table {
+	struct hlist_head known_gates;
+	spinlock_t gates_lock;
+	struct rhashtable rhead;
+	struct hlist_head walk_head;
+	spinlock_t walk_lock;
+	atomic_t entries;		/* Up to MAX_MESH_NEIGHBOURS */
+};
+
 struct ieee80211_if_mesh {
 	struct timer_list housekeeping_timer;
 	struct timer_list mesh_path_timer;
@@ -701,8 +721,8 @@ struct ieee80211_if_mesh {
 	/* offset from skb->data while building IE */
 	int meshconf_offset;
 
-	struct mesh_table *mesh_paths;
-	struct mesh_table *mpp_paths; /* Store paths for MPP&MAP */
+	struct mesh_table mesh_paths;
+	struct mesh_table mpp_paths; /* Store paths for MPP&MAP */
 	int mesh_paths_generation;
 	int mpp_paths_generation;
 };
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index e84103b40534..e60444039e76 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -128,26 +128,6 @@ struct mesh_path {
 	bool is_gate;
 };
 
-/**
- * struct mesh_table
- *
- * @known_gates: list of known mesh gates and their mpaths by the station. The
- * gate's mpath may or may not be resolved and active.
- * @gates_lock: protects updates to known_gates
- * @rhead: the rhashtable containing struct mesh_paths, keyed by dest addr
- * @walk_head: linked list containging all mesh_path objects
- * @walk_lock: lock protecting walk_head
- * @entries: number of entries in the table
- */
-struct mesh_table {
-	struct hlist_head known_gates;
-	spinlock_t gates_lock;
-	struct rhashtable rhead;
-	struct hlist_head walk_head;
-	spinlock_t walk_lock;
-	atomic_t entries;		/* Up to MAX_MESH_NEIGHBOURS */
-};
-
 /* Recent multicast cache */
 /* RMC_BUCKETS must be a power of 2, maximum 256 */
 #define RMC_BUCKETS		256
@@ -300,7 +280,7 @@ int mesh_path_error_tx(struct ieee80211_sub_if_data *sdata,
 void mesh_path_assign_nexthop(struct mesh_path *mpath, struct sta_info *sta);
 void mesh_path_flush_pending(struct mesh_path *mpath);
 void mesh_path_tx_pending(struct mesh_path *mpath);
-int mesh_pathtbl_init(struct ieee80211_sub_if_data *sdata);
+void mesh_pathtbl_init(struct ieee80211_sub_if_data *sdata);
 void mesh_pathtbl_unregister(struct ieee80211_sub_if_data *sdata);
 int mesh_path_del(struct ieee80211_sub_if_data *sdata, const u8 *addr);
 void mesh_path_timer(struct timer_list *t);
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 71ebdc85755c..8efb2bf08bf4 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -50,32 +50,24 @@ static void mesh_path_rht_free(void *ptr, void *tblptr)
 	mesh_path_free_rcu(tbl, mpath);
 }
 
-static struct mesh_table *mesh_table_alloc(void)
+static void mesh_table_init(struct mesh_table *tbl)
 {
-	struct mesh_table *newtbl;
+	INIT_HLIST_HEAD(&tbl->known_gates);
+	INIT_HLIST_HEAD(&tbl->walk_head);
+	atomic_set(&tbl->entries,  0);
+	spin_lock_init(&tbl->gates_lock);
+	spin_lock_init(&tbl->walk_lock);
 
-	newtbl = kmalloc(sizeof(struct mesh_table), GFP_ATOMIC);
-	if (!newtbl)
-		return NULL;
-
-	INIT_HLIST_HEAD(&newtbl->known_gates);
-	INIT_HLIST_HEAD(&newtbl->walk_head);
-	atomic_set(&newtbl->entries,  0);
-	spin_lock_init(&newtbl->gates_lock);
-	spin_lock_init(&newtbl->walk_lock);
-	if (rhashtable_init(&newtbl->rhead, &mesh_rht_params)) {
-		kfree(newtbl);
-		return NULL;
-	}
-
-	return newtbl;
+	/* rhashtable_init() may fail only in case of wrong
+	 * mesh_rht_params
+	 */
+	WARN_ON(rhashtable_init(&tbl->rhead, &mesh_rht_params));
 }
 
 static void mesh_table_free(struct mesh_table *tbl)
 {
 	rhashtable_free_and_destroy(&tbl->rhead,
 				    mesh_path_rht_free, tbl);
-	kfree(tbl);
 }
 
 /**
@@ -243,13 +235,13 @@ static struct mesh_path *mpath_lookup(struct mesh_table *tbl, const u8 *dst,
 struct mesh_path *
 mesh_path_lookup(struct ieee80211_sub_if_data *sdata, const u8 *dst)
 {
-	return mpath_lookup(sdata->u.mesh.mesh_paths, dst, sdata);
+	return mpath_lookup(&sdata->u.mesh.mesh_paths, dst, sdata);
 }
 
 struct mesh_path *
 mpp_path_lookup(struct ieee80211_sub_if_data *sdata, const u8 *dst)
 {
-	return mpath_lookup(sdata->u.mesh.mpp_paths, dst, sdata);
+	return mpath_lookup(&sdata->u.mesh.mpp_paths, dst, sdata);
 }
 
 static struct mesh_path *
@@ -286,7 +278,7 @@ __mesh_path_lookup_by_idx(struct mesh_table *tbl, int idx)
 struct mesh_path *
 mesh_path_lookup_by_idx(struct ieee80211_sub_if_data *sdata, int idx)
 {
-	return __mesh_path_lookup_by_idx(sdata->u.mesh.mesh_paths, idx);
+	return __mesh_path_lookup_by_idx(&sdata->u.mesh.mesh_paths, idx);
 }
 
 /**
@@ -301,7 +293,7 @@ mesh_path_lookup_by_idx(struct ieee80211_sub_if_data *sdata, int idx)
 struct mesh_path *
 mpp_path_lookup_by_idx(struct ieee80211_sub_if_data *sdata, int idx)
 {
-	return __mesh_path_lookup_by_idx(sdata->u.mesh.mpp_paths, idx);
+	return __mesh_path_lookup_by_idx(&sdata->u.mesh.mpp_paths, idx);
 }
 
 /**
@@ -314,7 +306,7 @@ int mesh_path_add_gate(struct mesh_path *mpath)
 	int err;
 
 	rcu_read_lock();
-	tbl = mpath->sdata->u.mesh.mesh_paths;
+	tbl = &mpath->sdata->u.mesh.mesh_paths;
 
 	spin_lock_bh(&mpath->state_lock);
 	if (mpath->is_gate) {
@@ -424,7 +416,7 @@ struct mesh_path *mesh_path_add(struct ieee80211_sub_if_data *sdata,
 	if (!new_mpath)
 		return ERR_PTR(-ENOMEM);
 
-	tbl = sdata->u.mesh.mesh_paths;
+	tbl = &sdata->u.mesh.mesh_paths;
 	spin_lock_bh(&tbl->walk_lock);
 	do {
 		ret = rhashtable_lookup_insert_fast(&tbl->rhead,
@@ -473,7 +465,7 @@ int mpp_path_add(struct ieee80211_sub_if_data *sdata,
 		return -ENOMEM;
 
 	memcpy(new_mpath->mpp, mpp, ETH_ALEN);
-	tbl = sdata->u.mesh.mpp_paths;
+	tbl = &sdata->u.mesh.mpp_paths;
 
 	spin_lock_bh(&tbl->walk_lock);
 	ret = rhashtable_lookup_insert_fast(&tbl->rhead,
@@ -502,7 +494,7 @@ int mpp_path_add(struct ieee80211_sub_if_data *sdata,
 void mesh_plink_broken(struct sta_info *sta)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
-	struct mesh_table *tbl = sdata->u.mesh.mesh_paths;
+	struct mesh_table *tbl = &sdata->u.mesh.mesh_paths;
 	static const u8 bcast[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 	struct mesh_path *mpath;
 
@@ -561,7 +553,7 @@ static void __mesh_path_del(struct mesh_table *tbl, struct mesh_path *mpath)
 void mesh_path_flush_by_nexthop(struct sta_info *sta)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
-	struct mesh_table *tbl = sdata->u.mesh.mesh_paths;
+	struct mesh_table *tbl = &sdata->u.mesh.mesh_paths;
 	struct mesh_path *mpath;
 	struct hlist_node *n;
 
@@ -576,7 +568,7 @@ void mesh_path_flush_by_nexthop(struct sta_info *sta)
 static void mpp_flush_by_proxy(struct ieee80211_sub_if_data *sdata,
 			       const u8 *proxy)
 {
-	struct mesh_table *tbl = sdata->u.mesh.mpp_paths;
+	struct mesh_table *tbl = &sdata->u.mesh.mpp_paths;
 	struct mesh_path *mpath;
 	struct hlist_node *n;
 
@@ -610,8 +602,8 @@ static void table_flush_by_iface(struct mesh_table *tbl)
  */
 void mesh_path_flush_by_iface(struct ieee80211_sub_if_data *sdata)
 {
-	table_flush_by_iface(sdata->u.mesh.mesh_paths);
-	table_flush_by_iface(sdata->u.mesh.mpp_paths);
+	table_flush_by_iface(&sdata->u.mesh.mesh_paths);
+	table_flush_by_iface(&sdata->u.mesh.mpp_paths);
 }
 
 /**
@@ -657,7 +649,7 @@ int mesh_path_del(struct ieee80211_sub_if_data *sdata, const u8 *addr)
 	/* flush relevant mpp entries first */
 	mpp_flush_by_proxy(sdata, addr);
 
-	err = table_path_del(sdata->u.mesh.mesh_paths, sdata, addr);
+	err = table_path_del(&sdata->u.mesh.mesh_paths, sdata, addr);
 	sdata->u.mesh.mesh_paths_generation++;
 	return err;
 }
@@ -695,7 +687,7 @@ int mesh_path_send_to_gates(struct mesh_path *mpath)
 	struct mesh_path *gate;
 	bool copy = false;
 
-	tbl = sdata->u.mesh.mesh_paths;
+	tbl = &sdata->u.mesh.mesh_paths;
 
 	rcu_read_lock();
 	hlist_for_each_entry_rcu(gate, &tbl->known_gates, gate_list) {
@@ -775,29 +767,10 @@ void mesh_path_fix_nexthop(struct mesh_path *mpath, struct sta_info *next_hop)
 	mesh_path_tx_pending(mpath);
 }
 
-int mesh_pathtbl_init(struct ieee80211_sub_if_data *sdata)
+void mesh_pathtbl_init(struct ieee80211_sub_if_data *sdata)
 {
-	struct mesh_table *tbl_path, *tbl_mpp;
-	int ret;
-
-	tbl_path = mesh_table_alloc();
-	if (!tbl_path)
-		return -ENOMEM;
-
-	tbl_mpp = mesh_table_alloc();
-	if (!tbl_mpp) {
-		ret = -ENOMEM;
-		goto free_path;
-	}
-
-	sdata->u.mesh.mesh_paths = tbl_path;
-	sdata->u.mesh.mpp_paths = tbl_mpp;
-
-	return 0;
-
-free_path:
-	mesh_table_free(tbl_path);
-	return ret;
+	mesh_table_init(&sdata->u.mesh.mesh_paths);
+	mesh_table_init(&sdata->u.mesh.mpp_paths);
 }
 
 static
@@ -819,12 +792,12 @@ void mesh_path_tbl_expire(struct ieee80211_sub_if_data *sdata,
 
 void mesh_path_expire(struct ieee80211_sub_if_data *sdata)
 {
-	mesh_path_tbl_expire(sdata, sdata->u.mesh.mesh_paths);
-	mesh_path_tbl_expire(sdata, sdata->u.mesh.mpp_paths);
+	mesh_path_tbl_expire(sdata, &sdata->u.mesh.mesh_paths);
+	mesh_path_tbl_expire(sdata, &sdata->u.mesh.mpp_paths);
 }
 
 void mesh_pathtbl_unregister(struct ieee80211_sub_if_data *sdata)
 {
-	mesh_table_free(sdata->u.mesh.mesh_paths);
-	mesh_table_free(sdata->u.mesh.mpp_paths);
+	mesh_table_free(&sdata->u.mesh.mesh_paths);
+	mesh_table_free(&sdata->u.mesh.mpp_paths);
 }

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9D671559
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 11:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbfGWJiv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 05:38:51 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:40781 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726370AbfGWJiv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 05:38:51 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id CF05D529;
        Tue, 23 Jul 2019 05:38:49 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 23 Jul 2019 05:38:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=dvTVQC
        kkgn5HbV+7Tz315Sgy7A08jv+Bp+Q/Ejna8Ps=; b=m3iBKSOdqBq3zgJ9Bq2Sy3
        /0rU0UwUltUHjzvrUsKo9496Ri+aPGFxJ6jKQaATn4cIJrRV3Z12270QGs5iLg27
        xbp3id7b/4IjsGcd4ynzQX6JG0nL0ZTOmEThyRO/irAf9lVJDtSehlj5NxmZ1/j+
        kjSRlVZyuX5jSP08GLdeLwfahOzcSyuR/rBQT4bxKiuLLwpHotvXb6GCxNUopnih
        tlhi6NEY0H4RJf8L1DqJ16sMkV2XS5Wmxna3MilWezvCOX1PWGBCM3wHv95ybmC+
        98cXZBcRdB4xJ5onZG+Z3RRrG3qvi3NlIWdFw4vDXPtFfNfNktle2wJ82So6TERg
        ==
X-ME-Sender: <xms:qdU2XdzzICODCTv-TGTNNHpLjDPGMo207ifVGd6Wv-h4N8Dzn1GaGw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeekgddukecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:qdU2XdsSjmwHDHz1aM9tEQjwv5EDvXd_V8Lsn51O1xMHrZ2hSlouMw>
    <xmx:qdU2XeMLJQQe6aq3BxkD44LKpvzltgBSGsuOT4yd1pp5fZKRoX0wEw>
    <xmx:qdU2XVxxyzIK_CGPAvjkzA50AZZtnX7r5iXinMvZ3G-GPDyQXlUmZw>
    <xmx:qdU2XSZiEt8QKoEFOaPBo8yM8ckNJSjZ4ZElNCxFy6f_DSFa16NZ8g>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A2DDF380086;
        Tue, 23 Jul 2019 05:38:48 -0400 (EDT)
Subject: FAILED: patch "[PATCH] iwlwifi: pcie: add support for qu c-step devices" failed to apply to 5.2-stable tree
To:     luciano.coelho@intel.com, kvalo@codeaurora.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jul 2019 11:38:46 +0200
Message-ID: <156387472560125@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.2-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a7d544d63120061f89459585f06ca44d30842a22 Mon Sep 17 00:00:00 2001
From: Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 8 Jul 2019 18:55:34 +0300
Subject: [PATCH] iwlwifi: pcie: add support for qu c-step devices

Add support for C-step devices.  Currently we don't have a nice way of
matching the step and choosing the proper configuration, so we need to
switch the config structs one by one.

Cc: stable@vger.kernel.org
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
index 93526dfaf791..1f500cddb3a7 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
@@ -80,7 +80,9 @@
 #define IWL_22000_QU_B_HR_B_FW_PRE	"iwlwifi-Qu-b0-hr-b0-"
 #define IWL_22000_HR_B_FW_PRE		"iwlwifi-QuQnj-b0-hr-b0-"
 #define IWL_22000_HR_A0_FW_PRE		"iwlwifi-QuQnj-a0-hr-a0-"
+#define IWL_QU_C_HR_B_FW_PRE		"iwlwifi-Qu-c0-hr-b0-"
 #define IWL_QU_B_JF_B_FW_PRE		"iwlwifi-Qu-b0-jf-b0-"
+#define IWL_QU_C_JF_B_FW_PRE		"iwlwifi-Qu-c0-jf-b0-"
 #define IWL_QUZ_A_HR_B_FW_PRE		"iwlwifi-QuZ-a0-hr-b0-"
 #define IWL_QUZ_A_JF_B_FW_PRE		"iwlwifi-QuZ-a0-jf-b0-"
 #define IWL_QNJ_B_JF_B_FW_PRE		"iwlwifi-QuQnj-b0-jf-b0-"
@@ -109,6 +111,8 @@
 	IWL_QUZ_A_HR_B_FW_PRE __stringify(api) ".ucode"
 #define IWL_QUZ_A_JF_B_MODULE_FIRMWARE(api) \
 	IWL_QUZ_A_JF_B_FW_PRE __stringify(api) ".ucode"
+#define IWL_QU_C_HR_B_MODULE_FIRMWARE(api) \
+	IWL_QU_C_HR_B_FW_PRE __stringify(api) ".ucode"
 #define IWL_QU_B_JF_B_MODULE_FIRMWARE(api) \
 	IWL_QU_B_JF_B_FW_PRE __stringify(api) ".ucode"
 #define IWL_QNJ_B_JF_B_MODULE_FIRMWARE(api)		\
@@ -256,6 +260,30 @@ const struct iwl_cfg iwl_ax201_cfg_qu_hr = {
 	.max_tx_agg_size = IEEE80211_MAX_AMPDU_BUF_HT,
 };
 
+const struct iwl_cfg iwl_ax101_cfg_qu_c0_hr_b0 = {
+	.name = "Intel(R) Wi-Fi 6 AX101",
+	.fw_name_pre = IWL_QU_C_HR_B_FW_PRE,
+	IWL_DEVICE_22500,
+	/*
+	 * This device doesn't support receiving BlockAck with a large bitmap
+	 * so we need to restrict the size of transmitted aggregation to the
+	 * HT size; mac80211 would otherwise pick the HE max (256) by default.
+	 */
+	.max_tx_agg_size = IEEE80211_MAX_AMPDU_BUF_HT,
+};
+
+const struct iwl_cfg iwl_ax201_cfg_qu_c0_hr_b0 = {
+	.name = "Intel(R) Wi-Fi 6 AX201 160MHz",
+	.fw_name_pre = IWL_QU_C_HR_B_FW_PRE,
+	IWL_DEVICE_22500,
+	/*
+	 * This device doesn't support receiving BlockAck with a large bitmap
+	 * so we need to restrict the size of transmitted aggregation to the
+	 * HT size; mac80211 would otherwise pick the HE max (256) by default.
+	 */
+	.max_tx_agg_size = IEEE80211_MAX_AMPDU_BUF_HT,
+};
+
 const struct iwl_cfg iwl_ax101_cfg_quz_hr = {
 	.name = "Intel(R) Wi-Fi 6 AX101",
 	.fw_name_pre = IWL_QUZ_A_HR_B_FW_PRE,
@@ -372,6 +400,30 @@ const struct iwl_cfg iwl9560_2ac_160_cfg_qu_b0_jf_b0 = {
 	IWL_DEVICE_22500,
 };
 
+const struct iwl_cfg iwl9461_2ac_cfg_qu_c0_jf_b0 = {
+	.name = "Intel(R) Wireless-AC 9461",
+	.fw_name_pre = IWL_QU_C_JF_B_FW_PRE,
+	IWL_DEVICE_22500,
+};
+
+const struct iwl_cfg iwl9462_2ac_cfg_qu_c0_jf_b0 = {
+	.name = "Intel(R) Wireless-AC 9462",
+	.fw_name_pre = IWL_QU_C_JF_B_FW_PRE,
+	IWL_DEVICE_22500,
+};
+
+const struct iwl_cfg iwl9560_2ac_cfg_qu_c0_jf_b0 = {
+	.name = "Intel(R) Wireless-AC 9560",
+	.fw_name_pre = IWL_QU_C_JF_B_FW_PRE,
+	IWL_DEVICE_22500,
+};
+
+const struct iwl_cfg iwl9560_2ac_160_cfg_qu_c0_jf_b0 = {
+	.name = "Intel(R) Wireless-AC 9560 160MHz",
+	.fw_name_pre = IWL_QU_C_JF_B_FW_PRE,
+	IWL_DEVICE_22500,
+};
+
 const struct iwl_cfg iwl9560_2ac_cfg_qnj_jf_b0 = {
 	.name = "Intel(R) Wireless-AC 9560 160MHz",
 	.fw_name_pre = IWL_QNJ_B_JF_B_FW_PRE,
@@ -590,6 +642,7 @@ MODULE_FIRMWARE(IWL_22000_HR_A_F0_QNJ_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_22000_HR_B_F0_QNJ_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_22000_HR_B_QNJ_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_22000_HR_A0_QNJ_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL_QU_C_HR_B_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_QU_B_JF_B_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_QUZ_A_HR_B_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_QUZ_A_JF_B_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index bc267bd2c3b0..1c1bf1b281cd 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -565,10 +565,13 @@ extern const struct iwl_cfg iwl22000_2ac_cfg_hr;
 extern const struct iwl_cfg iwl22000_2ac_cfg_hr_cdb;
 extern const struct iwl_cfg iwl22000_2ac_cfg_jf;
 extern const struct iwl_cfg iwl_ax101_cfg_qu_hr;
+extern const struct iwl_cfg iwl_ax101_cfg_qu_c0_hr_b0;
 extern const struct iwl_cfg iwl_ax101_cfg_quz_hr;
 extern const struct iwl_cfg iwl22000_2ax_cfg_hr;
 extern const struct iwl_cfg iwl_ax200_cfg_cc;
 extern const struct iwl_cfg iwl_ax201_cfg_qu_hr;
+extern const struct iwl_cfg iwl_ax201_cfg_qu_hr;
+extern const struct iwl_cfg iwl_ax201_cfg_qu_c0_hr_b0;
 extern const struct iwl_cfg iwl_ax201_cfg_quz_hr;
 extern const struct iwl_cfg iwl_ax1650i_cfg_quz_hr;
 extern const struct iwl_cfg iwl_ax1650s_cfg_quz_hr;
@@ -580,6 +583,10 @@ extern const struct iwl_cfg iwl9461_2ac_cfg_qu_b0_jf_b0;
 extern const struct iwl_cfg iwl9462_2ac_cfg_qu_b0_jf_b0;
 extern const struct iwl_cfg iwl9560_2ac_cfg_qu_b0_jf_b0;
 extern const struct iwl_cfg iwl9560_2ac_160_cfg_qu_b0_jf_b0;
+extern const struct iwl_cfg iwl9461_2ac_cfg_qu_c0_jf_b0;
+extern const struct iwl_cfg iwl9462_2ac_cfg_qu_c0_jf_b0;
+extern const struct iwl_cfg iwl9560_2ac_cfg_qu_c0_jf_b0;
+extern const struct iwl_cfg iwl9560_2ac_160_cfg_qu_c0_jf_b0;
 extern const struct iwl_cfg killer1550i_2ac_cfg_qu_b0_jf_b0;
 extern const struct iwl_cfg killer1550s_2ac_cfg_qu_b0_jf_b0;
 extern const struct iwl_cfg iwl22000_2ax_cfg_jf;
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
index 93da96a7247c..cb4c5514a556 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
@@ -328,6 +328,8 @@ enum {
 #define CSR_HW_REV_TYPE_NONE		(0x00001F0)
 #define CSR_HW_REV_TYPE_QNJ		(0x0000360)
 #define CSR_HW_REV_TYPE_QNJ_B0		(0x0000364)
+#define CSR_HW_REV_TYPE_QU_B0		(0x0000334)
+#define CSR_HW_REV_TYPE_QU_C0		(0x0000338)
 #define CSR_HW_REV_TYPE_QUZ		(0x0000354)
 #define CSR_HW_REV_TYPE_HR_CDB		(0x0000340)
 #define CSR_HW_REV_TYPE_SO		(0x0000370)
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index fe645380bd2f..ea2a03d4bf55 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -1039,6 +1039,27 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		}
 		iwl_trans->cfg = cfg;
 	}
+
+	/*
+	 * This is a hack to switch from Qu B0 to Qu C0.  We need to
+	 * do this for all cfgs that use Qu B0.  All this code is in
+	 * urgent need for a refactor, but for now this is the easiest
+	 * thing to do to support Qu C-step.
+	 */
+	if (iwl_trans->hw_rev == CSR_HW_REV_TYPE_QU_C0) {
+		if (iwl_trans->cfg == &iwl_ax101_cfg_qu_hr)
+			iwl_trans->cfg = &iwl_ax101_cfg_qu_c0_hr_b0;
+		else if (iwl_trans->cfg == &iwl_ax201_cfg_qu_hr)
+			iwl_trans->cfg = &iwl_ax201_cfg_qu_c0_hr_b0;
+		else if (iwl_trans->cfg == &iwl9461_2ac_cfg_qu_b0_jf_b0)
+			iwl_trans->cfg = &iwl9461_2ac_cfg_qu_c0_jf_b0;
+		else if (iwl_trans->cfg == &iwl9462_2ac_cfg_qu_b0_jf_b0)
+			iwl_trans->cfg = &iwl9462_2ac_cfg_qu_c0_jf_b0;
+		else if (iwl_trans->cfg == &iwl9560_2ac_cfg_qu_b0_jf_b0)
+			iwl_trans->cfg = &iwl9560_2ac_cfg_qu_c0_jf_b0;
+		else if (iwl_trans->cfg == &iwl9560_2ac_160_cfg_qu_b0_jf_b0)
+			iwl_trans->cfg = &iwl9560_2ac_160_cfg_qu_c0_jf_b0;
+	}
 #endif
 
 	pci_set_drvdata(pdev, iwl_trans);


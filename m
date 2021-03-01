Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94778327BAB
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 11:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231545AbhCAKOU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 05:14:20 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:52951 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231326AbhCAKOT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 05:14:19 -0500
Received: from compute7.internal (compute7.nyi.internal [10.202.2.47])
        by mailforward.nyi.internal (Postfix) with ESMTP id BEF4C1940B06;
        Mon,  1 Mar 2021 05:13:32 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute7.internal (MEProxy); Mon, 01 Mar 2021 05:13:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=/yi3fl
        Aqxo4dCbN3FanncED/KsBh9VOU77ptgXuZ1/w=; b=HHFtPvck93ZZqSZdhbIyBx
        /WC7VgfGJdUARdtOZvz+iepxox+oArv7v/BJBLV8AeNlgqh2LwNoSf+VVBG58E8I
        G3mKgYhcfbD0D5NTnoP6XNJerA3YUSyLhwwIaR7RrenIsGFBPoxNfLMhDvSgVAPf
        qGT8Li3Fu4BlAbez8ToT7SqvoJhJEhsfKjqJls3Co+A1uUGyhNKPJ44nbqJcyz/U
        xrKgJhEGBZtRPUMh+YsqQ+HOIYW7NVox5iiGQdls74iKhbtyk2++SketwNAFx++Z
        9uksTjRL+n41kz+BFfHWVd/2GPfAJQBLjBpcBs2ahdxmlvWRPHuVtUIISG/MjSGw
        ==
X-ME-Sender: <xms:TL48YBLh_cPrCsfYnxms0fkjnebPmKXcU3saU9LE8LtX2mmfEVGE4w>
    <xme:TL48YEB8SA5ve2aVuKLlBPLjxaSIHpl6Gl6EB4olev9GYWAAcx4nWZJic6SA6czNR
    pujfM0MAVHDiA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdduudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:TL48YGroD0qp4DCICa8iQvrYL96E5iyjRjFtOntatOVCNR-kDqW7Xw>
    <xmx:TL48YPg6IG_8WVVCNcoOhAXsABn39b-yAm2LNkBTZLD49syqKu0K5Q>
    <xmx:TL48YDCsghWQCz92KqjVkH5Gy5zrdTxAwgO2V7Eagwgwm4QuqG_1vQ>
    <xmx:TL48YJDor5R0WSW-zhls3LIrxSQc3PLAxkp3JEgWdnoKUuUK5EVGFA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2C0AA240057;
        Mon,  1 Mar 2021 05:13:32 -0500 (EST)
Subject: FAILED: patch "[PATCH] iwlwifi: add new cards for So and Qu family" failed to apply to 5.11-stable tree
To:     ihab.zhaika@intel.com, luciano.coelho@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 11:13:29 +0100
Message-ID: <16145936091141@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.11-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 410f758529bc227b186ba0846bcc75ac0700ffb2 Mon Sep 17 00:00:00 2001
From: Ihab Zhaika <ihab.zhaika@intel.com>
Date: Sat, 6 Feb 2021 13:01:10 +0200
Subject: [PATCH] iwlwifi: add new cards for So and Qu family

add few PCI ID'S for So with Hr and Qu with Hr in AX family.

Cc: stable@vger.kernel.org
Signed-off-by: Ihab Zhaika <ihab.zhaika@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210206130110.6f0c1849f7dc.I647b4d22f9468c2f34b777a4bfa445912c6f04f0@changeid

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
index e0c7410a01f6..d1e9fcba9645 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
@@ -682,6 +682,24 @@ const struct iwl_cfg iwl_cfg_snj_a0_mr_a0 = {
 	.num_rbds = IWL_NUM_RBDS_AX210_HE,
 };
 
+const struct iwl_cfg iwl_cfg_so_a0_hr_a0 = {
+	.fw_name_pre = IWL_SO_A_HR_B_FW_PRE,
+	IWL_DEVICE_AX210,
+	.num_rbds = IWL_NUM_RBDS_AX210_HE,
+};
+
+const struct iwl_cfg iwl_cfg_quz_a0_hr_b0 = {
+	.fw_name_pre = IWL_QUZ_A_HR_B_FW_PRE,
+	IWL_DEVICE_22500,
+	/*
+	 * This device doesn't support receiving BlockAck with a large bitmap
+	 * so we need to restrict the size of transmitted aggregation to the
+	 * HT size; mac80211 would otherwise pick the HE max (256) by default.
+	 */
+	.max_tx_agg_size = IEEE80211_MAX_AMPDU_BUF_HT,
+	.num_rbds = IWL_NUM_RBDS_22000_HE,
+};
+
 MODULE_FIRMWARE(IWL_QU_B_HR_B_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_QNJ_B_HR_B_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_QU_C_HR_B_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 41d74a8c314d..b72142a247d0 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -609,6 +609,8 @@ extern const struct iwl_cfg iwl_cfg_snj_a0_jf_b0;
 extern const struct iwl_cfg iwl_cfg_ma_a0_gf_a0;
 extern const struct iwl_cfg iwl_cfg_ma_a0_mr_a0;
 extern const struct iwl_cfg iwl_cfg_snj_a0_mr_a0;
+extern const struct iwl_cfg iwl_cfg_so_a0_hr_a0;
+extern const struct iwl_cfg iwl_cfg_quz_a0_hr_b0;
 #endif /* CONFIG_IWLMVM */
 
 #endif /* __IWL_CONFIG_H__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index c45542fa8b7f..c17234c0c945 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -926,6 +926,11 @@ static const struct iwl_dev_info iwl_dev_info_table[] = {
 		      IWL_CFG_RF_TYPE_HR1, IWL_CFG_ANY,
 		      IWL_CFG_ANY, IWL_CFG_ANY,
 		      iwl_quz_a0_hr1_b0, iwl_ax101_name),
+	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
+		      IWL_CFG_MAC_TYPE_QUZ, SILICON_B_STEP,
+		      IWL_CFG_RF_TYPE_HR2, IWL_CFG_ANY,
+		      IWL_CFG_NO_160, IWL_CFG_ANY,
+		      iwl_cfg_quz_a0_hr_b0, iwl_ax203_name),
 
 /* QnJ with Hr */
 	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
@@ -997,6 +1002,27 @@ static const struct iwl_dev_info iwl_dev_info_table[] = {
 		      IWL_CFG_ANY, IWL_CFG_ANY,
 		      iwl_cfg_snj_a0_mr_a0, iwl_ma_name),
 
+/* So with Hr */
+	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
+		      IWL_CFG_MAC_TYPE_SO, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_HR2, IWL_CFG_ANY,
+		      IWL_CFG_NO_160, IWL_CFG_ANY,
+		      iwl_cfg_so_a0_hr_a0, iwl_ax203_name),
+	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
+		      IWL_CFG_MAC_TYPE_SO, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_HR2, IWL_CFG_ANY,
+		      IWL_CFG_NO_160, IWL_CFG_ANY,
+		      iwl_cfg_so_a0_hr_a0, iwl_ax203_name),
+	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
+		      IWL_CFG_MAC_TYPE_SO, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_HR1, IWL_CFG_ANY,
+		      IWL_CFG_160, IWL_CFG_ANY,
+		      iwl_cfg_so_a0_hr_a0, iwl_ax101_name),
+	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
+		      IWL_CFG_MAC_TYPE_SO, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_HR2, IWL_CFG_ANY,
+		      IWL_CFG_160, IWL_CFG_ANY,
+		      iwl_cfg_so_a0_hr_a0, iwl_ax201_name)
 
 #endif /* CONFIG_IWLMVM */
 };


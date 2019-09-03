Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0F61A72EE
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 20:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725882AbfICS6R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 14:58:17 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:44023 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725782AbfICS6R (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Sep 2019 14:58:17 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 6C6DA2221C;
        Tue,  3 Sep 2019 14:58:16 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 03 Sep 2019 14:58:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=GnBCuK
        LGOnhQVg8gHxmpRKAfUyInzjQQUIlYyXUHNnQ=; b=OeFXULJX+dgypmFbIthZwC
        oWC9i/ajZdpvaNcuvpcQR7cR9NB8x42iIUJDeUJhyBlq5T75qn+zHD0nBhunAsgh
        9UGCX6Nd+EQec+/IXI5GVsUZBPuC7hg8FWN58oKHqQGAmkLVONv6dg/fUHDFHEzW
        gAuy3CI/o8ZL+zwVIwff0lX7aIuVbjrmUdyqL3p1JHDpv7q4+CEXdp8v6qVEJQhI
        nqyHUiTTxdXiKKbwqHiJsmtgy6kLCqZ9B1K5rho8bTpN3H3DD21QKqeQ71vbjRCf
        hNP7Xo+L1Z1oF+/fSuHa2DP4J7+3K7SeQTMrt6eNI89gkoWiImKvzKiW/CDvPqsQ
        ==
X-ME-Sender: <xms:yLduXWZuoNLT35molRzIMNFw3K3QRPKJTPc64oQrUDOfoto9_fsldg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudejfedguddtvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekle
    druddtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
    necuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:yLduXUw8DyTP3-xbqvq4MrCARkfTjWco18JZUhXjIRvQk20N7awcqQ>
    <xmx:yLduXe14zuBb2HdEIdYZQnDOB3hCxvTV1dbQay1nic7lfbqERFBrGA>
    <xmx:yLduXTz0JuAOE0pCSnZ_Dsp-fQL021uhiIGdP-MBmXfLi7Jc-aoPXg>
    <xmx:yLduXWG_b3Db5nczcX2sIZ2NE44cx8FwbYT3W7ymekuapT3odVXigg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E9790D6005D;
        Tue,  3 Sep 2019 14:58:15 -0400 (EDT)
Subject: FAILED: patch "[PATCH] iwlwifi: pcie: handle switching killer Qu B0 NICs to C0" failed to apply to 5.2-stable tree
To:     luciano.coelho@intel.com, johannes.berg@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Sep 2019 20:58:14 +0200
Message-ID: <15675370949856@kroah.com>
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

From b9500577d361522a3d9f14da8cf41dc1d824904e Mon Sep 17 00:00:00 2001
From: Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 21 Aug 2019 20:17:32 +0300
Subject: [PATCH] iwlwifi: pcie: handle switching killer Qu B0 NICs to C0

We need to use a different firmware for C0 versions of killer Qu NICs.
Add structures for them and handle them in the if block that detects
C0 revisions.

Additionally, instead of having an inclusive check for QnJ devices,
make the selection exclusive, so that switching to QnJ is the
exception, not the default.  This prevents us from having to add all
the non-QnJ cards to an exclusion list.  To do so, only go into the
QnJ block if the device has an RF ID type HR and HW revision QnJ.

Cc: stable@vger.kernel.org # 5.2
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/20190821171732.2266-1-luca@coelho.fi
Signed-off-by: Johannes Berg <johannes.berg@intel.com>

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
index 1f500cddb3a7..55b713255b8e 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
@@ -556,6 +556,30 @@ const struct iwl_cfg killer1650i_2ax_cfg_qu_b0_hr_b0 = {
 	.max_tx_agg_size = IEEE80211_MAX_AMPDU_BUF_HT,
 };
 
+const struct iwl_cfg killer1650s_2ax_cfg_qu_c0_hr_b0 = {
+	.name = "Killer(R) Wi-Fi 6 AX1650i 160MHz Wireless Network Adapter (201NGW)",
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
+const struct iwl_cfg killer1650i_2ax_cfg_qu_c0_hr_b0 = {
+	.name = "Killer(R) Wi-Fi 6 AX1650s 160MHz Wireless Network Adapter (201D2W)",
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
 const struct iwl_cfg iwl22000_2ax_cfg_jf = {
 	.name = "Intel(R) Dual Band Wireless AX 22000",
 	.fw_name_pre = IWL_QU_B_JF_B_FW_PRE,
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 1c1bf1b281cd..6c04f8223aff 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -577,6 +577,8 @@ extern const struct iwl_cfg iwl_ax1650i_cfg_quz_hr;
 extern const struct iwl_cfg iwl_ax1650s_cfg_quz_hr;
 extern const struct iwl_cfg killer1650s_2ax_cfg_qu_b0_hr_b0;
 extern const struct iwl_cfg killer1650i_2ax_cfg_qu_b0_hr_b0;
+extern const struct iwl_cfg killer1650s_2ax_cfg_qu_c0_hr_b0;
+extern const struct iwl_cfg killer1650i_2ax_cfg_qu_c0_hr_b0;
 extern const struct iwl_cfg killer1650x_2ax_cfg;
 extern const struct iwl_cfg killer1650w_2ax_cfg;
 extern const struct iwl_cfg iwl9461_2ac_cfg_qu_b0_jf_b0;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 7c5aaeaf7fe5..d9ed53b7c768 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -1062,6 +1062,10 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			iwl_trans->cfg = &iwl9560_2ac_cfg_qu_c0_jf_b0;
 		else if (iwl_trans->cfg == &iwl9560_2ac_160_cfg_qu_b0_jf_b0)
 			iwl_trans->cfg = &iwl9560_2ac_160_cfg_qu_c0_jf_b0;
+		else if (iwl_trans->cfg == &killer1650s_2ax_cfg_qu_b0_hr_b0)
+			iwl_trans->cfg = &killer1650s_2ax_cfg_qu_c0_hr_b0;
+		else if (iwl_trans->cfg == &killer1650i_2ax_cfg_qu_b0_hr_b0)
+			iwl_trans->cfg = &killer1650i_2ax_cfg_qu_c0_hr_b0;
 	}
 
 	/* same thing for QuZ... */
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 935e35dafce5..db62c8314603 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -3602,12 +3602,7 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 		}
 	} else if (CSR_HW_RF_ID_TYPE_CHIP_ID(trans->hw_rf_id) ==
 		   CSR_HW_RF_ID_TYPE_CHIP_ID(CSR_HW_RF_ID_TYPE_HR) &&
-		   ((trans->cfg != &iwl_ax200_cfg_cc &&
-		     trans->cfg != &iwl_ax201_cfg_qu_hr &&
-		     trans->cfg != &killer1650x_2ax_cfg &&
-		     trans->cfg != &killer1650w_2ax_cfg &&
-		     trans->cfg != &iwl_ax201_cfg_quz_hr) ||
-		    trans->hw_rev == CSR_HW_REV_TYPE_QNJ_B0)) {
+		   trans->hw_rev == CSR_HW_REV_TYPE_QNJ_B0) {
 		u32 hw_status;
 
 		hw_status = iwl_read_prph(trans, UMAG_GEN_HW_STATUS);


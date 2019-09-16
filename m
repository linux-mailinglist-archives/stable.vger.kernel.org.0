Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97040B3D8B
	for <lists+stable@lfdr.de>; Mon, 16 Sep 2019 17:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388636AbfIPPUl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Sep 2019 11:20:41 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:47983 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388609AbfIPPUl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Sep 2019 11:20:41 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 089CA3CB;
        Mon, 16 Sep 2019 11:20:39 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 16 Sep 2019 11:20:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=HXiT6Z
        fIlSuwl5WVKNrBEiVXB0jpbp6tmMk0pkeXZvI=; b=a30FjeKTHRqBQukFk1x9AT
        DQwWNW4pheii9WYC5am6ZulLcyN/TqPEq0El1Zp3KwsrQO6bKl0l6iz5I/EVqpO0
        OS+iGY0nmWgHp2yioyOlPt0K5AKPm5dRiFys4cmYokm215pP4pFJRMBiEIYOhFfi
        H5KYH83fQeFt7yh1zDSfBakSgsMCUdQaCzyWHCTG3RI5kLQTfau9uTBCjlKwBFJc
        fnzaxmM6NVOEATukARuJBz54MoBsmq5O8GyydLNsI+alG8M8R10mkvvfl0swStqt
        QpzqHi+btQFNNguAjizBVu9IQNjTYJhiG0801+mBDmsF1Fqk29sbzrvl5DoFTuEQ
        ==
X-ME-Sender: <xms:R6h_XSXzUlS10MAlrWxwJ8KTdpBX5jk-snB8lEbBekFZ9zy1hHnN7Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudefgdekjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:R6h_XQHvgS-Z2eq4xYl312Qwo58UqUVExoHylv3WBJXJ00eT9niHNQ>
    <xmx:R6h_XWdmD19TgjWhhi_IS0LQ1Ke7ShyVbAM4EHDsXfuEd_0zwU4_TQ>
    <xmx:R6h_XZJ9fwxpc_f4h--txGKjfE7OUC7MopL4wpXxKPUd00UKxvB1ag>
    <xmx:R6h_XXs_Sh6hzdkC793g6m7j7mNz-UP6IGEOZX6iJi5XXNVhc-h40g>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 08D5DD6005E;
        Mon, 16 Sep 2019 11:20:38 -0400 (EDT)
Subject: FAILED: patch "[PATCH] iwlwifi: assign directly to iwl_trans->cfg in QuZ detection" failed to apply to 5.2-stable tree
To:     luciano.coelho@intel.com, kvalo@codeaurora.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 Sep 2019 17:20:37 +0200
Message-ID: <1568647237149@kroah.com>
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

From 968dcfb4905245dc64d65312c0d17692fa087b99 Mon Sep 17 00:00:00 2001
From: Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 29 Aug 2019 11:13:46 +0300
Subject: [PATCH] iwlwifi: assign directly to iwl_trans->cfg in QuZ detection

We were erroneously assigning the new configuration to a local
variable cfg, but that was not being assigned to anything, so the
change was getting lost.  Assign directly to iwl_trans->cfg instead.

Fixes: 5a8c31aa6357 ("iwlwifi: pcie: fix recognition of QuZ devices")
Cc: stable@vger.kernel.org # 5.2
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index d9ed53b7c768..3b12e7ad35e1 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -1070,18 +1070,18 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	/* same thing for QuZ... */
 	if (iwl_trans->hw_rev == CSR_HW_REV_TYPE_QUZ) {
-		if (cfg == &iwl_ax101_cfg_qu_hr)
-			cfg = &iwl_ax101_cfg_quz_hr;
-		else if (cfg == &iwl_ax201_cfg_qu_hr)
-			cfg = &iwl_ax201_cfg_quz_hr;
-		else if (cfg == &iwl9461_2ac_cfg_qu_b0_jf_b0)
-			cfg = &iwl9461_2ac_cfg_quz_a0_jf_b0_soc;
-		else if (cfg == &iwl9462_2ac_cfg_qu_b0_jf_b0)
-			cfg = &iwl9462_2ac_cfg_quz_a0_jf_b0_soc;
-		else if (cfg == &iwl9560_2ac_cfg_qu_b0_jf_b0)
-			cfg = &iwl9560_2ac_cfg_quz_a0_jf_b0_soc;
-		else if (cfg == &iwl9560_2ac_160_cfg_qu_b0_jf_b0)
-			cfg = &iwl9560_2ac_160_cfg_quz_a0_jf_b0_soc;
+		if (iwl_trans->cfg == &iwl_ax101_cfg_qu_hr)
+			iwl_trans->cfg = &iwl_ax101_cfg_quz_hr;
+		else if (iwl_trans->cfg == &iwl_ax201_cfg_qu_hr)
+			iwl_trans->cfg = &iwl_ax201_cfg_quz_hr;
+		else if (iwl_trans->cfg == &iwl9461_2ac_cfg_qu_b0_jf_b0)
+			iwl_trans->cfg = &iwl9461_2ac_cfg_quz_a0_jf_b0_soc;
+		else if (iwl_trans->cfg == &iwl9462_2ac_cfg_qu_b0_jf_b0)
+			iwl_trans->cfg = &iwl9462_2ac_cfg_quz_a0_jf_b0_soc;
+		else if (iwl_trans->cfg == &iwl9560_2ac_cfg_qu_b0_jf_b0)
+			iwl_trans->cfg = &iwl9560_2ac_cfg_quz_a0_jf_b0_soc;
+		else if (iwl_trans->cfg == &iwl9560_2ac_160_cfg_qu_b0_jf_b0)
+			iwl_trans->cfg = &iwl9560_2ac_160_cfg_quz_a0_jf_b0_soc;
 	}
 
 #endif


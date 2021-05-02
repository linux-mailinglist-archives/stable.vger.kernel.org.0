Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1E8370AF6
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 11:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231801AbhEBJwL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 05:52:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:35246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231818AbhEBJwK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 05:52:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D389611F1;
        Sun,  2 May 2021 09:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619949078;
        bh=NU1lpy/QAbS5boiG75KipNbHgkg0+27DIskIuwYbNEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z4/X5WD6FDk+7S7l3pcnQhMDjtskp/YF4SuQv5+ESo3ZfW7R6Ud1tRkg/JkQmLySE
         7VwBhCSVRuyUOit4Rs3ZNmGx35beMmdp3FRSUSf/ZVrn3ipPdqGqhzUUNFWB1DvpAh
         P3y3ArlYlM+COFyk3sUV6+6wY3m+D0IXTBYGh4jU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.11.18
Date:   Sun,  2 May 2021 11:51:12 +0200
Message-Id: <1619949071144255@kroah.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <161994907115454@kroah.com>
References: <161994907115454@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index d8367e193232..6cf79e492f72 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 11
-SUBLEVEL = 17
+SUBLEVEL = 18
 EXTRAVERSION =
 NAME = 💕 Valentine's Day Edition 💕
 
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 54fd48ee5f27..62a637c03f60 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -4184,7 +4184,7 @@ add_gfx10_3_modifiers(const struct amdgpu_device *adev,
 		    AMD_FMT_MOD_SET(DCC_CONSTANT_ENCODE, 1) |
 		    AMD_FMT_MOD_SET(DCC_INDEPENDENT_64B, 1) |
 		    AMD_FMT_MOD_SET(DCC_INDEPENDENT_128B, 1) |
-		    AMD_FMT_MOD_SET(DCC_MAX_COMPRESSED_BLOCK, AMD_FMT_MOD_DCC_BLOCK_128B));
+		    AMD_FMT_MOD_SET(DCC_MAX_COMPRESSED_BLOCK, AMD_FMT_MOD_DCC_BLOCK_64B));
 
 	add_modifier(mods, size, capacity, AMD_FMT_MOD |
 		    AMD_FMT_MOD_SET(TILE, AMD_FMT_MOD_TILE_GFX9_64K_R_X) |
@@ -4196,7 +4196,7 @@ add_gfx10_3_modifiers(const struct amdgpu_device *adev,
 		    AMD_FMT_MOD_SET(DCC_CONSTANT_ENCODE, 1) |
 		    AMD_FMT_MOD_SET(DCC_INDEPENDENT_64B, 1) |
 		    AMD_FMT_MOD_SET(DCC_INDEPENDENT_128B, 1) |
-		    AMD_FMT_MOD_SET(DCC_MAX_COMPRESSED_BLOCK, AMD_FMT_MOD_DCC_BLOCK_128B));
+		    AMD_FMT_MOD_SET(DCC_MAX_COMPRESSED_BLOCK, AMD_FMT_MOD_DCC_BLOCK_64B));
 
 	add_modifier(mods, size, capacity, AMD_FMT_MOD |
 		    AMD_FMT_MOD_SET(TILE, AMD_FMT_MOD_TILE_GFX9_64K_R_X) |
diff --git a/drivers/misc/mei/hw-me-regs.h b/drivers/misc/mei/hw-me-regs.h
index 14be76d4c2e6..cb34925e10f1 100644
--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -105,6 +105,7 @@
 
 #define MEI_DEV_ID_ADP_S      0x7AE8  /* Alder Lake Point S */
 #define MEI_DEV_ID_ADP_LP     0x7A60  /* Alder Lake Point LP */
+#define MEI_DEV_ID_ADP_P      0x51E0  /* Alder Lake Point P */
 
 /*
  * MEI HW Section
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index a7e179626b63..c3393b383e59 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -111,6 +111,7 @@ static const struct pci_device_id mei_me_pci_tbl[] = {
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_ADP_S, MEI_ME_PCH15_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_ADP_LP, MEI_ME_PCH15_CFG)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_ADP_P, MEI_ME_PCH15_CFG)},
 
 	/* required last entry */
 	{0, }
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
index b9afd9b04042..481c05db1290 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -40,6 +40,7 @@ static int iwl_pcie_gen2_enqueue_hcmd(struct iwl_trans *trans,
 	const u8 *cmddata[IWL_MAX_CMD_TBS_PER_TFD];
 	u16 cmdlen[IWL_MAX_CMD_TBS_PER_TFD];
 	struct iwl_tfh_tfd *tfd;
+	unsigned long flags;
 
 	copy_size = sizeof(struct iwl_cmd_header_wide);
 	cmd_size = sizeof(struct iwl_cmd_header_wide);
@@ -108,14 +109,14 @@ static int iwl_pcie_gen2_enqueue_hcmd(struct iwl_trans *trans,
 		goto free_dup_buf;
 	}
 
-	spin_lock_bh(&txq->lock);
+	spin_lock_irqsave(&txq->lock, flags);
 
 	idx = iwl_txq_get_cmd_index(txq, txq->write_ptr);
 	tfd = iwl_txq_get_tfd(trans, txq, txq->write_ptr);
 	memset(tfd, 0, sizeof(*tfd));
 
 	if (iwl_txq_space(trans, txq) < ((cmd->flags & CMD_ASYNC) ? 2 : 1)) {
-		spin_unlock_bh(&txq->lock);
+		spin_unlock_irqrestore(&txq->lock, flags);
 
 		IWL_ERR(trans, "No space in command queue\n");
 		iwl_op_mode_cmd_queue_full(trans->op_mode);
@@ -250,7 +251,7 @@ static int iwl_pcie_gen2_enqueue_hcmd(struct iwl_trans *trans,
 	spin_unlock(&trans_pcie->reg_lock);
 
 out:
-	spin_unlock_bh(&txq->lock);
+	spin_unlock_irqrestore(&txq->lock, flags);
 free_dup_buf:
 	if (idx < 0)
 		kfree(dup_buf);

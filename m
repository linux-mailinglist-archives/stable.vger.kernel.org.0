Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2C3B3FDC6F
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344437AbhIAMuy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:50:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:49846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345130AbhIAMsM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:48:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 196E46115C;
        Wed,  1 Sep 2021 12:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630500025;
        bh=8uGhlzw8itBNSqnqsC9IrVharzy9ChGrbnsD8NU3DQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NVeaiORdOoXqmvFEK+rCJ7ApNTu3WBDhigQnUDztmK1A8LH1ZBAdN+GLjZJg75+lY
         I7Nw+raWgWR2RvABd2bFyoZNd5ntEBD7TxneOQeR8R44BOBpIvQr3d2ixe4HRYYcnR
         uguSlmS4KK7eKVsnsAlDiQSC/ERkJy9FuweiXLeI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yaara Baruch <yaara.baruch@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 075/113] iwlwifi: add new so-jf devices
Date:   Wed,  1 Sep 2021 14:28:30 +0200
Message-Id: <20210901122304.492697436@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
References: <20210901122301.984263453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yaara Baruch <yaara.baruch@intel.com>

[ Upstream commit 891332f697e14bfb2002f56e21d9bbd4800a7098 ]

Add new so-jf devices to the driver.

Signed-off-by: Yaara Baruch <yaara.baruch@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210719144523.1c9a59fd2760.If5aef1942007828210f0f2c4a17985f63050bb45@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 36 ++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index cd204a9ec87d..9f11a1d5d034 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -1142,7 +1142,41 @@ static const struct iwl_dev_info iwl_dev_info_table[] = {
 		      IWL_CFG_MAC_TYPE_SO, IWL_CFG_ANY,
 		      IWL_CFG_RF_TYPE_GF, IWL_CFG_ANY,
 		      IWL_CFG_160, IWL_CFG_ANY, IWL_CFG_NO_CDB,
-		      iwlax211_2ax_cfg_so_gf_a0, iwl_ax211_name)
+		      iwlax211_2ax_cfg_so_gf_a0, iwl_ax211_name),
+
+/* So with JF2 */
+	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
+		      IWL_CFG_MAC_TYPE_SO, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_JF2, IWL_CFG_RF_ID_JF,
+		      IWL_CFG_160, IWL_CFG_CORES_BT, IWL_CFG_NO_CDB,
+		      iwlax210_2ax_cfg_so_jf_b0, iwl9560_160_name),
+	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
+		      IWL_CFG_MAC_TYPE_SO, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_JF2, IWL_CFG_RF_ID_JF,
+		      IWL_CFG_NO_160, IWL_CFG_CORES_BT, IWL_CFG_NO_CDB,
+		      iwlax210_2ax_cfg_so_jf_b0, iwl9560_name),
+
+/* So with JF */
+	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
+		      IWL_CFG_MAC_TYPE_SO, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_JF1, IWL_CFG_RF_ID_JF1,
+		      IWL_CFG_160, IWL_CFG_CORES_BT, IWL_CFG_NO_CDB,
+		      iwlax210_2ax_cfg_so_jf_b0, iwl9461_160_name),
+	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
+		      IWL_CFG_MAC_TYPE_SO, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_JF1, IWL_CFG_RF_ID_JF1_DIV,
+		      IWL_CFG_160, IWL_CFG_CORES_BT, IWL_CFG_NO_CDB,
+		      iwlax210_2ax_cfg_so_jf_b0, iwl9462_160_name),
+	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
+		      IWL_CFG_MAC_TYPE_SO, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_JF1, IWL_CFG_RF_ID_JF1,
+		      IWL_CFG_NO_160, IWL_CFG_CORES_BT, IWL_CFG_NO_CDB,
+		      iwlax210_2ax_cfg_so_jf_b0, iwl9461_name),
+	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
+		      IWL_CFG_MAC_TYPE_SO, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_JF1, IWL_CFG_RF_ID_JF1_DIV,
+		      IWL_CFG_NO_160, IWL_CFG_CORES_BT, IWL_CFG_NO_CDB,
+		      iwlax210_2ax_cfg_so_jf_b0, iwl9462_name)
 
 #endif /* CONFIG_IWLMVM */
 };
-- 
2.30.2




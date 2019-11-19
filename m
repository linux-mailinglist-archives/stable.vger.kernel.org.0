Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAD7310153A
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:42:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730118AbfKSFl5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:41:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:36526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728636AbfKSFl4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:41:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E053721783;
        Tue, 19 Nov 2019 05:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142115;
        bh=YUdWJefQqbJCfgysInUFfykhGjVrzLCnQMM6zBJYnkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fKmCmknxHI5CIxwLRzvEKT0EAaeylf4SkDwnxUjOu0bEiG73Ws4iGO5Eg5m9fXFU1
         TAjYdM3aFTBB55lWQhye0QVFJBBnKovZm12s0kSlxz1JrMQvqtU+qN8Gp5absjRHMs
         waufriWpp6ULxTfQf4GOMQfW2ekUnK/d0+yp7hbw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erel Geron <erelx.geron@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 392/422] iwlwifi: fix non_shared_ant for 22000 devices
Date:   Tue, 19 Nov 2019 06:19:49 +0100
Message-Id: <20191119051424.524869753@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Erel Geron <erelx.geron@intel.com>

[ Upstream commit a40287727d9b737e183959fd31a4e0c55f312853 ]

The non-shared antenna was wrong for 22000 device series.
Fix it to ANT_B for correct antenna preference by coex in MVM driver.

Fixes: e34d975e40ff ("iwlwifi: Add a000 HW family support")
Signed-off-by: Erel Geron <erelx.geron@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
index b4347806a59ed..a0de61aa0feff 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
@@ -143,7 +143,7 @@ static const struct iwl_ht_params iwl_22000_ht_params = {
 	.ucode_api_min = IWL_22000_UCODE_API_MIN,			\
 	.led_mode = IWL_LED_RF_STATE,					\
 	.nvm_hw_section_num = NVM_HW_SECTION_NUM_FAMILY_22000,		\
-	.non_shared_ant = ANT_A,					\
+	.non_shared_ant = ANT_B,					\
 	.dccm_offset = IWL_22000_DCCM_OFFSET,				\
 	.dccm_len = IWL_22000_DCCM_LEN,					\
 	.dccm2_offset = IWL_22000_DCCM2_OFFSET,				\
-- 
2.20.1




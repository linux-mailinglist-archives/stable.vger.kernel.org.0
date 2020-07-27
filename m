Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F37F22F140
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730468AbgG0Oat (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:30:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:50014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731719AbgG0OVZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:21:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE1C12070A;
        Mon, 27 Jul 2020 14:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859685;
        bh=DFVeJ/lrb11eR2M8PKEcHH/XGizsaMEJnixiYlEdY1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OAYq7emz2+/SQnkFQZu1ozvHpGjs4hyUcfNMEeWeMr3tTz5CywpkwelJG0rRU8P4k
         h9XU4azLTpQ7mWRijypP7kpLHhp8zbR+YHszMsQtl7ERSE4LsWkaS4TRA7sKRssiHq
         Q1dmA8JEgfXe5TiLXJhi8i6gmse9BxxDfSuI9tLU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alessio Bonfiglio <alessio.bonfiglio@mail.polimi.it>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 066/179] iwlwifi: Make some Killer Wireless-AC 1550 cards work again
Date:   Mon, 27 Jul 2020 16:04:01 +0200
Message-Id: <20200727134935.883326149@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alessio Bonfiglio <alessio.bonfiglio@mail.polimi.it>

[ Upstream commit b5ba46b81c2fef00bcf110777fb6d51befa4a23e ]

Fix the regression introduced by commit c8685937d07f ("iwlwifi: move
pu devices to new table") by adding the ids and the configurations of
two missing Killer 1550 cards in order to configure and let them work
correctly again (following the new table convention).
Resolve bug 208141 ("Wireless ac 9560 not working kernel 5.7.2",
https://bugzilla.kernel.org/show_bug.cgi?id=208141).

Fixes: c8685937d07f ("iwlwifi: move pu devices to new table")
Signed-off-by: Alessio Bonfiglio <alessio.bonfiglio@mail.polimi.it>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200714091911.4442-1-alessio.bonfiglio@mail.polimi.it
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 29971c25dba44..9ea3e56346722 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -577,6 +577,8 @@ static const struct iwl_dev_info iwl_dev_info_table[] = {
 	IWL_DEV_INFO(0x30DC, 0x1552, iwl9560_2ac_cfg_soc, iwl9560_killer_1550i_name),
 	IWL_DEV_INFO(0x31DC, 0x1551, iwl9560_2ac_cfg_soc, iwl9560_killer_1550s_name),
 	IWL_DEV_INFO(0x31DC, 0x1552, iwl9560_2ac_cfg_soc, iwl9560_killer_1550i_name),
+	IWL_DEV_INFO(0xA370, 0x1551, iwl9560_2ac_cfg_soc, iwl9560_killer_1550s_name),
+	IWL_DEV_INFO(0xA370, 0x1552, iwl9560_2ac_cfg_soc, iwl9560_killer_1550i_name),
 
 	IWL_DEV_INFO(0x271C, 0x0214, iwl9260_2ac_cfg, iwl9260_1_name),
 
-- 
2.25.1




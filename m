Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA7AA9159
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390882AbfIDSOz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:14:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:60362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387599AbfIDSOz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:14:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F133323404;
        Wed,  4 Sep 2019 18:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620894;
        bh=Wy6VE5DlZm///HDTgjzOkhSW8PQ88cXpCwYirEi6kDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O9FmgXbZ4iBf/J8sARfcJBnd7bzfu753y4y0k4/0AZvXYVMXFKsPvqVkvDRIlTgMW
         Eu8BVlNh7hww5IVaFBpEy2OVKBteictBZz3CvEyromY1UZlFjGeCJbwoj922hO/1If
         xRLMrINMPcirSdp97YMQ6olAWEOefbz2lht7h1Pg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ihab Zhaika <ihab.zhaika@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 134/143] iwlwifi: add new cards for 9000 and 20000 series
Date:   Wed,  4 Sep 2019 19:54:37 +0200
Message-Id: <20190904175319.644760435@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit ffcb60a54f245528e1d49f957ca2d20d6079577c ]

add two new PCI ID's for 9000 and 20000 series

Cc: stable@vger.kernel.org
Signed-off-by: Ihab Zhaika <ihab.zhaika@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 02af9073793af..09cf5f4fccb0f 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -604,6 +604,7 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x2526, 0x40A4, iwl9460_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0x4234, iwl9560_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x2526, 0x42A4, iwl9462_2ac_cfg_soc)},
+	{IWL_PCI_DEVICE(0x2526, 0x6014, iwl9260_2ac_160_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0x8014, iwl9260_2ac_160_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0x8010, iwl9260_2ac_160_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0xA014, iwl9260_2ac_160_cfg)},
@@ -971,6 +972,7 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x7A70, 0x0310, iwlax211_2ax_cfg_so_gf_a0)},
 	{IWL_PCI_DEVICE(0x7A70, 0x0510, iwlax211_2ax_cfg_so_gf_a0)},
 	{IWL_PCI_DEVICE(0x7A70, 0x0A10, iwlax211_2ax_cfg_so_gf_a0)},
+	{IWL_PCI_DEVICE(0x7AF0, 0x0090, iwlax211_2ax_cfg_so_gf_a0)},
 	{IWL_PCI_DEVICE(0x7AF0, 0x0310, iwlax211_2ax_cfg_so_gf_a0)},
 	{IWL_PCI_DEVICE(0x7AF0, 0x0510, iwlax211_2ax_cfg_so_gf_a0)},
 	{IWL_PCI_DEVICE(0x7AF0, 0x0A10, iwlax211_2ax_cfg_so_gf_a0)},
-- 
2.20.1




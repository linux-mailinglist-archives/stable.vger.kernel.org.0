Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03253B201E
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389875AbfIMNQe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:16:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:43380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389872AbfIMNQe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:16:34 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B8BF20CC7;
        Fri, 13 Sep 2019 13:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380593;
        bh=W54ZZlDXwN24a6MZ1KLoAwy0Ob86yk+ognt1D9HV2SQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sIl1L7Dxhl8iB8ekmEbDLYrjCnxMI3KOA7uQx/hTOTbb7BDn/hGOZGYfax4kK3LDT
         7lZ48ZKIjdRN0fwC37WfkobdQ/6QUUxCksN7LwedOLxyWZq8ZErJ1t/K4O9vmHgjH1
         AkHHTOEXIgSHI0XpzQ4mXmG2fnXWEqkSNrX/fdBo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ihab Zhaika <ihab.zhaika@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 094/190] iwlwifi: add new card for 9260 series
Date:   Fri, 13 Sep 2019 14:05:49 +0100
Message-Id: <20190913130607.122076047@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 3941310cf665b8a7965424d2a185c80782faa030 ]

Add one PCI ID for 9260 series.

CC: <stable@vger.kernel.org> # 4.14+
Signed-off-by: Ihab Zhaika <ihab.zhaika@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index d3a1c13bcf6f1..0982bd99b1c3c 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -601,6 +601,7 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x2526, 0x2030, iwl9560_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x2526, 0x2034, iwl9560_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x2526, 0x4010, iwl9260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x2526, 0x4018, iwl9260_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0x4030, iwl9560_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x2526, 0x4034, iwl9560_2ac_cfg_soc)},
 	{IWL_PCI_DEVICE(0x2526, 0x40A4, iwl9460_2ac_cfg)},
-- 
2.20.1




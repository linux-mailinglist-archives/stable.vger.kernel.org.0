Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26A512E3A99
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391286AbgL1NjI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:39:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:39486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731191AbgL1NjH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:39:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C58922A84;
        Mon, 28 Dec 2020 13:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162707;
        bh=XwXVJsrucTyE6ndMrxw3mQM+F3+ZP1Y2wAJWe1kXnqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hfXkryATn6IN1pVHnGXeIMMGIbcV2jxoOp6zezUlnxuqoc3O4gPJQIy4RUpgfifCj
         YGlZ6rbcdCnRFBk3d98DBolKNeTfaLXgDU3EKL2lrB25v9JsZnGyoen/5ndOOdr65i
         cho3eiS+rtqngm4tl45KUKBBXlb4kxrf3oIYvAjw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 046/453] iwlwifi: pcie: add one missing entry for AX210
Date:   Mon, 28 Dec 2020 13:44:42 +0100
Message-Id: <20201228124939.470793536@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

[ Upstream commit 5febcdef30902fa870128b9789b873199f13aff1 ]

The 0x0024 subsytem device ID was missing from the list, so some AX210
devices were not recognized.  Add it.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/iwlwifi.20201202143859.308eab4db42c.I3763196cd3f7bb36f3dcabf02ec4e7c4fe859c0f@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index b0b7eca1754ed..f34297fd453c0 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -968,6 +968,7 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 
 	{IWL_PCI_DEVICE(0x2725, 0x0090, iwlax211_2ax_cfg_so_gf_a0)},
 	{IWL_PCI_DEVICE(0x2725, 0x0020, iwlax210_2ax_cfg_ty_gf_a0)},
+	{IWL_PCI_DEVICE(0x2725, 0x0024, iwlax210_2ax_cfg_ty_gf_a0)},
 	{IWL_PCI_DEVICE(0x2725, 0x0310, iwlax210_2ax_cfg_ty_gf_a0)},
 	{IWL_PCI_DEVICE(0x2725, 0x0510, iwlax210_2ax_cfg_ty_gf_a0)},
 	{IWL_PCI_DEVICE(0x2725, 0x0A10, iwlax210_2ax_cfg_ty_gf_a0)},
-- 
2.27.0




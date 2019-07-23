Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8711E7155A
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 11:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbfGWJi4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 05:38:56 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:45107 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726370AbfGWJiz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 05:38:55 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 245C252F;
        Tue, 23 Jul 2019 05:38:55 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 23 Jul 2019 05:38:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=D2foKC
        IXWSLy4xsoUU+xJDfhC18ZLZWFFpyw2DZtCxg=; b=Cxr325q79IksznobdEEfwo
        Rmyhd5apFRm44YiKhxA5zRBvRlrjhHcG+aZx8nXtTlj1pOG2FJb8oTaXNgLCQacT
        RL315g84YqT+ziyLdQitI+KqmhlDDh+mJnOF4Bw1iLYv6e76OuiTtIdgrk5evBV3
        EPUa9FmsOHuPEpjuJhBgqNVoGQsdrWBJDppJ7wGMiWOgR5qDEElXwdZH6+nywVh/
        lrsiPZ4VFrQhXl7KaFzJJAVe1iBcka9FYgLJto24mdSKhxNyiy3mrsEtqfgk4tCk
        2CNVboOZe5HsV/jQa4GTRjxPZZbiZPqEyilyt0snUA63T7oBAsnDN6P/N49izneQ
        ==
X-ME-Sender: <xms:rtU2XZaRygkz5USyc8fGoQh09vZ-ayCgvE9JQANTYBDwhNSsK2NEVQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeekgddukecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:rtU2XUq2eRX4fY5yofqEcSXyFgCYpc3-ERcl5CGet4d-vclapAWelw>
    <xmx:rtU2XW8GfHiNGg7DHST1pSPTENXP8vqK8U0lU_PqVBpyp3-dopN-cw>
    <xmx:rtU2Xb-A6fmRRW5CURGEW9dZ3N19erdCa4xNXop9fUKMEXJJh9myUA>
    <xmx:rtU2XQr3rvatbfblH_A3Rr9taIRba3iEgfiO6vhQbERJEovSdxz1pw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 34099380075;
        Tue, 23 Jul 2019 05:38:54 -0400 (EDT)
Subject: FAILED: patch "[PATCH] iwlwifi: add new cards for 9000 and 20000 series" failed to apply to 5.2-stable tree
To:     ihab.zhaika@intel.com, kvalo@codeaurora.org,
        luciano.coelho@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jul 2019 11:38:53 +0200
Message-ID: <1563874733249225@kroah.com>
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

From ffcb60a54f245528e1d49f957ca2d20d6079577c Mon Sep 17 00:00:00 2001
From: Ihab Zhaika <ihab.zhaika@intel.com>
Date: Mon, 8 Jul 2019 18:55:33 +0300
Subject: [PATCH] iwlwifi: add new cards for 9000 and 20000 series

add two new PCI ID's for 9000 and 20000 series

Cc: stable@vger.kernel.org
Signed-off-by: Ihab Zhaika <ihab.zhaika@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index ccc83fd74649..fe645380bd2f 100644
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


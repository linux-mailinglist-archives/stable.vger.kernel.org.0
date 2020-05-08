Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5165D1CB03B
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728512AbgEHNYh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:24:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:49280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726776AbgEHMgU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:36:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58AEC207DD;
        Fri,  8 May 2020 12:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941379;
        bh=kY5SVMR4SyAAL2jwU/q+UahhepFgRepGy3cZM6L68DQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VNh29nwWVfIXyAaaGr29t/se6uLYCrdu0LJ4XeaE2ew48Ojoj9pJfk0ZfIC1RCVP+
         eJfqSgDIFPPrjsoezAZ1fz7miyNW2ZUW9HylnFM7I0XXEDKn9PZgTIdcBXHgGz7g9l
         hEIWFrSy36OA6qHYxmEz0vAfmDxtyn6k4VSUfFu4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amitkumar Karwar <akarwar@marvell.com>,
        Shengzhen Li <szli@marvell.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.4 001/312] mwifiex: fix PCIe register information for 8997 chipset
Date:   Fri,  8 May 2020 14:29:52 +0200
Message-Id: <20200508123124.662215732@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amitkumar Karwar <akarwar@marvell.com>

commit ce0c58d998410fb91c63a70e749e98bb0e67eb67 upstream.

This patch corrects some information in mwifiex_pcie_card_reg()
structure for 8997 chipset

Fixes: 6d85ef00d9dfe ("mwifiex: add support for 8997 chipset")
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Shengzhen Li <szli@marvell.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mwifiex/pcie.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/mwifiex/pcie.h
+++ b/drivers/net/wireless/mwifiex/pcie.h
@@ -210,17 +210,17 @@ static const struct mwifiex_pcie_card_re
 	.cmdrsp_addr_lo = PCIE_SCRATCH_4_REG,
 	.cmdrsp_addr_hi = PCIE_SCRATCH_5_REG,
 	.tx_rdptr = 0xC1A4,
-	.tx_wrptr = 0xC1A8,
-	.rx_rdptr = 0xC1A8,
+	.tx_wrptr = 0xC174,
+	.rx_rdptr = 0xC174,
 	.rx_wrptr = 0xC1A4,
 	.evt_rdptr = PCIE_SCRATCH_10_REG,
 	.evt_wrptr = PCIE_SCRATCH_11_REG,
 	.drv_rdy = PCIE_SCRATCH_12_REG,
 	.tx_start_ptr = 16,
 	.tx_mask = 0x0FFF0000,
-	.tx_wrap_mask = 0x01FF0000,
+	.tx_wrap_mask = 0x1FFF0000,
 	.rx_mask = 0x00000FFF,
-	.rx_wrap_mask = 0x000001FF,
+	.rx_wrap_mask = 0x00001FFF,
 	.tx_rollover_ind = BIT(28),
 	.rx_rollover_ind = BIT(12),
 	.evt_rollover_ind = MWIFIEX_BD_FLAG_EVT_ROLLOVER_IND,



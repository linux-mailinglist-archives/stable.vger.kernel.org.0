Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A00983290AB
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239232AbhCAUMX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:12:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:37638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242550AbhCAUCz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:02:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 297BD6538E;
        Mon,  1 Mar 2021 17:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621447;
        bh=6Ll9Un/47s7RZ7EhTxQBer5sNtJ3tvhD9w6KGs9phic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2MCv4veGWcPnqetnhh7yvJGzlTHMr9U24SoxtrFFO3OQrDeFmJSiY4Avmf6W3AVos
         6K3On03u/mQo8OvheHlmpfIzKmXLV66AH1LlgdiBOAWf10v2SGmjGyvt95f+ZyRH+1
         p096Q16oGuu0eh/RzU5M9ldbJRjfanW3T6/tSVIk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Magnum Shan <magnum.shan@unisoc.com>,
        Chunyan Zhang <chunyan.zhang@unisoc.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 519/775] mailbox: sprd: correct definition of SPRD_OUTBOX_FIFO_FULL
Date:   Mon,  1 Mar 2021 17:11:27 +0100
Message-Id: <20210301161227.173083904@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Magnum Shan <magnum.shan@unisoc.com>

[ Upstream commit 4450f128c51160bfded6b483eba37d0628d7adb2 ]

According to the specification, bit[2] represents SPRD_OUTBOX_FIFO_FULL,
not bit[0], so correct it.

Fixes: ca27fc26cd22 ("mailbox: sprd: Add Spreadtrum mailbox driver")
Signed-off-by: Magnum Shan <magnum.shan@unisoc.com>
Signed-off-by: Chunyan Zhang <chunyan.zhang@unisoc.com>
Reviewed-by: Baolin Wang <baolin.wang7@gmail.com>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/sprd-mailbox.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mailbox/sprd-mailbox.c b/drivers/mailbox/sprd-mailbox.c
index f6fab24ae8a9a..4c325301a2fe8 100644
--- a/drivers/mailbox/sprd-mailbox.c
+++ b/drivers/mailbox/sprd-mailbox.c
@@ -35,7 +35,7 @@
 #define SPRD_MBOX_IRQ_CLR			BIT(0)
 
 /* Bit and mask definiation for outbox's SPRD_MBOX_FIFO_STS register */
-#define SPRD_OUTBOX_FIFO_FULL			BIT(0)
+#define SPRD_OUTBOX_FIFO_FULL			BIT(2)
 #define SPRD_OUTBOX_FIFO_WR_SHIFT		16
 #define SPRD_OUTBOX_FIFO_RD_SHIFT		24
 #define SPRD_OUTBOX_FIFO_POS_MASK		GENMASK(7, 0)
-- 
2.27.0




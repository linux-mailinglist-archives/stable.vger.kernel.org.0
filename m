Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5022328E69
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232677AbhCATaD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:30:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:45944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241445AbhCATZU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:25:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62F0964DEF;
        Mon,  1 Mar 2021 17:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619453;
        bh=6Ll9Un/47s7RZ7EhTxQBer5sNtJ3tvhD9w6KGs9phic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pc3GpnORogUG8fcoN5R18Bd96kuglLGnR8aQXmDt7k54zjBayyGGZ9x/GRvfIsuA8
         gKmKGfSB+/5W23mtNVa1s/+RasiLcQrB/8BocNsh5Q4UxnDYXfvC8OKxO8o5hdW0pw
         R+A4VTnNpTpjd7h2d0WLDVpXrd4C1oj3hVaC/k+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Magnum Shan <magnum.shan@unisoc.com>,
        Chunyan Zhang <chunyan.zhang@unisoc.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 430/663] mailbox: sprd: correct definition of SPRD_OUTBOX_FIFO_FULL
Date:   Mon,  1 Mar 2021 17:11:18 +0100
Message-Id: <20210301161203.165523116@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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




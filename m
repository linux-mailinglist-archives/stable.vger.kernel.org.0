Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0AC7490D5C
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 18:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242110AbiAQRCi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 12:02:38 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51112 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241864AbiAQRBY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 12:01:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0DBB3611C2;
        Mon, 17 Jan 2022 17:01:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9951FC36AE7;
        Mon, 17 Jan 2022 17:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642438882;
        bh=AGVkdtvLj/AXz77WxRuV1yF6BCr8p0lcB/5+6NNM0k0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rjEPrQK2JMNrTRAyao7NJSk50a/L1ePVPKgpNCIYLf3MpYO9BJcNLm5H2cG+cxurw
         KQiEzkEJCPy3XMQJZG83mRwFt4caOMLfv+6YxtSzvyKATXpq8eIzTYyIqm1TLMpvBj
         ynQDxpAqxnsopn8onKq/qUr2r0L4LaC+D0JEWaWEXVzbIHXIdXCs2NfdCYVXAoFP2P
         SXJbq+/fYwE2z6ujtCVSvO6b41KpJCstRPnHOTxa0Tf5hV+1T4nTVkTnLfB4BOgDtc
         M+GP1+0iAxeyGeSKjMVb9a7ND0xtzJCoC2ujwanQYYlhS1na5uYuq/pK0Z/m1UbZrE
         sx7LsFcnknrLQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Conor Dooley <conor.dooley@microchip.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sasha Levin <sashal@kernel.org>, lewis.hanly@microchip.com,
        jassisinghbrar@gmail.com, linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.16 51/52] mailbox: change mailbox-mpfs compatible string
Date:   Mon, 17 Jan 2022 11:58:52 -0500
Message-Id: <20220117165853.1470420-51-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220117165853.1470420-1-sashal@kernel.org>
References: <20220117165853.1470420-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Conor Dooley <conor.dooley@microchip.com>

[ Upstream commit f10b1fc0161cd99e54c5687fcc63368aa255e05e ]

The Polarfire SoC is currently using two different compatible string
prefixes. Fix this by changing "polarfire-soc-*" strings to "mpfs-*" in
its system controller in order to match the compatible string used in
the soc binding and device tree.

Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mailbox-mpfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mailbox/mailbox-mpfs.c b/drivers/mailbox/mailbox-mpfs.c
index 0d6e2231a2c75..4e34854d12389 100644
--- a/drivers/mailbox/mailbox-mpfs.c
+++ b/drivers/mailbox/mailbox-mpfs.c
@@ -232,7 +232,7 @@ static int mpfs_mbox_probe(struct platform_device *pdev)
 }
 
 static const struct of_device_id mpfs_mbox_of_match[] = {
-	{.compatible = "microchip,polarfire-soc-mailbox", },
+	{.compatible = "microchip,mpfs-mailbox", },
 	{},
 };
 MODULE_DEVICE_TABLE(of, mpfs_mbox_of_match);
-- 
2.34.1


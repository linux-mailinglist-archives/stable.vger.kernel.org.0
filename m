Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B892491DC1
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344829AbiARDmL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:42:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353611AbiARDCI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 22:02:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AB4CC03400D;
        Mon, 17 Jan 2022 18:47:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D377BB811CF;
        Tue, 18 Jan 2022 02:47:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3F71C36AF3;
        Tue, 18 Jan 2022 02:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642474054;
        bh=0LzPtP+1imS3yKjOyhidBSJgXssfUSqeD1/ITevQIJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=COfch7YApnw9QjbAHT4WxIVSuiguSGWdq4X8TlNldw9QdOm5Z+6wXPZpAU+v0Xkdq
         A7lRmt9+SidlGvZs4+KnOufjxwLM8nPHbpVMhpTJyZoNUOEXRrr9DD5mhbAlg2TGt+
         gbEnuDi0pilY99nKYzvv/IS7XFeNus4DqhM0JkM/IB1Dk9x14iiM3WT7R5X2iPRAGO
         iccRX4c2dIOW+oRIX+OGTtZgjcmLzkfpAHhaSgC5wE77H0Y3UUD1boecqgYtwhVzuN
         ptLt9/qDkfZRvIgEKeTfU7g6fkqqnyoEaLT8Ol1y6G3UFt3AhKbJCx5/J1THsMPxac
         yoysia98wt5oA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Neal Liu <neal_liu@aspeedtech.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, stern@rowland.harvard.edu,
        linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 15/59] usb: uhci: add aspeed ast2600 uhci support
Date:   Mon, 17 Jan 2022 21:46:16 -0500
Message-Id: <20220118024701.1952911-15-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024701.1952911-1-sashal@kernel.org>
References: <20220118024701.1952911-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neal Liu <neal_liu@aspeedtech.com>

[ Upstream commit 554abfe2eadec97d12c71d4a69da1518478f69eb ]

Enable ast2600 uhci quirks.

Signed-off-by: Neal Liu <neal_liu@aspeedtech.com>
Link: https://lore.kernel.org/r/20211126100021.2331024-1-neal_liu@aspeedtech.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/uhci-platform.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/uhci-platform.c b/drivers/usb/host/uhci-platform.c
index 89700e26fb296..813ff3660e9f1 100644
--- a/drivers/usb/host/uhci-platform.c
+++ b/drivers/usb/host/uhci-platform.c
@@ -113,7 +113,8 @@ static int uhci_hcd_platform_probe(struct platform_device *pdev)
 				num_ports);
 		}
 		if (of_device_is_compatible(np, "aspeed,ast2400-uhci") ||
-		    of_device_is_compatible(np, "aspeed,ast2500-uhci")) {
+		    of_device_is_compatible(np, "aspeed,ast2500-uhci") ||
+		    of_device_is_compatible(np, "aspeed,ast2600-uhci")) {
 			uhci->is_aspeed = 1;
 			dev_info(&pdev->dev,
 				 "Enabled Aspeed implementation workarounds\n");
-- 
2.34.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56EC9491A8C
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352694AbiARDA0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:00:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349368AbiARCte (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:49:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B794C0613EF;
        Mon, 17 Jan 2022 18:42:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1165CB8124F;
        Tue, 18 Jan 2022 02:42:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22486C36AEB;
        Tue, 18 Jan 2022 02:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473722;
        bh=Wz1PAbR8+iIe/jPfTcBbjPHkLNB0RxFEi0fK8+Aossk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nbKitrq1ciyk2uwlLdQ/WRrWJeP7goABdUeNDwY5EnwmbOABXAe8jrMr7fbJ9i1EN
         4Dpn7jzGrYDvorsgSCvvIiUj81svPSFTWqLhof9n6alE4gOn7SzDKwSKA7hNvcq7uw
         wJnKA1jWiLzm4hih1w0WzrNn6LBsK4a35ldPNqYtRQJfMuTfKR5QUQo7qNBo8KQqt5
         j/0h2XOCmv+fxKHDYMUylOJU0tWG+iI4D9sYHnsyw4TDuY4SLMuloDkOpvUix7zEER
         lqrYKxrrBq9td68bzjbbY/ElWvv1cHRVsRxzJY2KQqC2Vj6b9fGBsmgq2OCQB1s2qZ
         2AJ/OqyyOq6Tg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Neal Liu <neal_liu@aspeedtech.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, stern@rowland.harvard.edu,
        linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 041/116] usb: uhci: add aspeed ast2600 uhci support
Date:   Mon, 17 Jan 2022 21:38:52 -0500
Message-Id: <20220118024007.1950576-41-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024007.1950576-1-sashal@kernel.org>
References: <20220118024007.1950576-1-sashal@kernel.org>
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
index 70dbd95c3f063..be9e9db7cad10 100644
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


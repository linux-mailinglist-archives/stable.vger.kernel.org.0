Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76959491527
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:26:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245508AbiARC0a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:26:30 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38594 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244620AbiARCY3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:24:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DBD05B8123A;
        Tue, 18 Jan 2022 02:24:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E70B7C36AF4;
        Tue, 18 Jan 2022 02:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472665;
        bh=Wz1PAbR8+iIe/jPfTcBbjPHkLNB0RxFEi0fK8+Aossk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=efLhCs86g7JVqdrXXFUWBNP5Yh4Lb+WPajhwTFz29Lei+w3vUpLaL9+fI2+TP+zkS
         +SxlzKlh9zQcOq4DqiQAV5JG1f3o8g5EFrXD9gSVBML0lZga4ouZXhor/36rJFuPUX
         gGtMGsS0cqTh+vyi4aDezuPlpOqcsDTe+m8e9YVYxMECsxoOlujzYNSeswH6BxYpJ1
         WLtkvcvp/sg1MSO0JdDmV2951+A6BBxnyudHX5SHC4QP6+AxFxdrBP+4zbIsy15Ak/
         qSvyGlXMeF497PYU77eKiBrvm6isI9rfuijBxVtwxF0ZYV0ZOOMRXEU2an0BozzvAp
         owWHDHnA1yl1Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Neal Liu <neal_liu@aspeedtech.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, stern@rowland.harvard.edu,
        linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.16 092/217] usb: uhci: add aspeed ast2600 uhci support
Date:   Mon, 17 Jan 2022 21:17:35 -0500
Message-Id: <20220118021940.1942199-92-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
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


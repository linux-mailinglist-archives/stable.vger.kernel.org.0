Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2985D499587
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:13:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442070AbiAXUwn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:52:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391837AbiAXUtE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:49:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59EF2C08C5C9;
        Mon, 24 Jan 2022 11:58:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 202F4B81218;
        Mon, 24 Jan 2022 19:58:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A29BC340E5;
        Mon, 24 Jan 2022 19:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054283;
        bh=Wz1PAbR8+iIe/jPfTcBbjPHkLNB0RxFEi0fK8+Aossk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AeFBFi4pl93iNzNYFP9Np0pfo2Fwettz/xDrEDgY75zGuqqLODYQnKpp/jj/nDjVl
         yh7YM+rejpxojnsNfmHGRkiDU+7oVQ204txoP0CPHTlBQ9Hp8WXcwt4tb8XmRP6Zfl
         JsxDQRqYJ3UErsFIDOV2O3smFx9d0Mf5Br6KNsuk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neal Liu <neal_liu@aspeedtech.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 338/563] usb: uhci: add aspeed ast2600 uhci support
Date:   Mon, 24 Jan 2022 19:41:43 +0100
Message-Id: <20220124184036.118403513@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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




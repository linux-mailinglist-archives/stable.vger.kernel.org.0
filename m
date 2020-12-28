Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 494322E6440
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388670AbgL1PtS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:49:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:42612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391937AbgL1NmT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:42:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92C9C22582;
        Mon, 28 Dec 2020 13:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162899;
        bh=hgQqUUzWEpHMe1QVlFunP3E+jqTndYMeC8TX7qWAHMk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lnVznXW/W7eUu8YGYk1CSrBIJPTeRVQ27RYY3tf9wufi5qkknKfc5vb0K5oxq8fJy
         DFaqcY7wQCkaZjJc2MyAOHJ6yb4m37U0cCykk2+1boKm8VeouT2eXRucVfTLE7gtnV
         9/EVdFw+OVjEmcSULjgnmqAPGns2QwrQzkgWuakQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vijay Khemka <vijaykhemka@fb.com>,
        Joel Stanley <joel@jms.id.au>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 098/453] ARM: dts: aspeed: tiogapass: Remove vuart
Date:   Mon, 28 Dec 2020 13:45:34 +0100
Message-Id: <20201228124941.945632022@linuxfoundation.org>
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

From: Vijay Khemka <vijaykhemka@fb.com>

[ Upstream commit 14f100c00f1e35e5890340d4c6a64bda5dff4320 ]

Removed vuart for facebook tiogapass platform as it uses uart2 and
uart3 pin with aspeed uart routing feature.

Signed-off-by: Vijay Khemka <vijaykhemka@fb.com>
Reviewed-by: Joel Stanley <joel@jms.id.au>
Fixes: ffdbf494821d ("ARM: dts: aspeed: tiogapass: Enable VUART")
Link: https://lore.kernel.org/r/20200813190431.3331026-1-vijaykhemka@fb.com
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/aspeed-bmc-facebook-tiogapass.dts | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arm/boot/dts/aspeed-bmc-facebook-tiogapass.dts b/arch/arm/boot/dts/aspeed-bmc-facebook-tiogapass.dts
index 682f729ea25e1..c58230fea45f8 100644
--- a/arch/arm/boot/dts/aspeed-bmc-facebook-tiogapass.dts
+++ b/arch/arm/boot/dts/aspeed-bmc-facebook-tiogapass.dts
@@ -81,11 +81,6 @@
 	status = "okay";
 };
 
-&vuart {
-	// VUART Host Console
-	status = "okay";
-};
-
 &uart1 {
 	// Host Console
 	status = "okay";
-- 
2.27.0




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7A4E13EF16
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:13:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395166AbgAPSNJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:13:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:51976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405248AbgAPRg5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:36:57 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B249F20730;
        Thu, 16 Jan 2020 17:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196217;
        bh=9u0eXpBkwqV5PC/UoUroJZ4c7kC3ibEt3Lw5Fw1TC9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ul2J8HR91p0EDOaxwLgT/pwMvCMAN0MmJlmTwMHoJVvuOlYTX2oiQWB076Zftdvxa
         dAqOX2Gn7Y/+M5JPYmn4DPrBDRZA9mKuRIWvarbGh+dr8mSsPSRyvTOk0ooeMbaKOX
         S0xg7s264t1/H3lH7ycKJRTjxLZu9jxtXXu+O+34=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Zapolskiy <vz@mleia.com>, Sasha Levin <sashal@kernel.org>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.9 052/251] ARM: dts: lpc32xx: fix ARM PrimeCell LCD controller variant
Date:   Thu, 16 Jan 2020 12:33:21 -0500
Message-Id: <20200116173641.22137-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116173641.22137-1-sashal@kernel.org>
References: <20200116173641.22137-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Zapolskiy <vz@mleia.com>

[ Upstream commit 7a0790a4121cbcd111cc537cdc801c46ccb789ee ]

ARM PrimeCell PL111 LCD controller is found on On NXP LPC3230
and LPC3250 SoCs variants, the original reference in compatible
property to an older one ARM PrimeCell PL110 is invalid.

Fixes: e04920d9efcb3 ("ARM: LPC32xx: DTS files for device tree conversion")
Signed-off-by: Vladimir Zapolskiy <vz@mleia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/lpc32xx.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/lpc32xx.dtsi b/arch/arm/boot/dts/lpc32xx.dtsi
index 6bd196457ccc..3adbbaff7971 100644
--- a/arch/arm/boot/dts/lpc32xx.dtsi
+++ b/arch/arm/boot/dts/lpc32xx.dtsi
@@ -139,7 +139,7 @@
 		};
 
 		clcd: clcd@31040000 {
-			compatible = "arm,pl110", "arm,primecell";
+			compatible = "arm,pl111", "arm,primecell";
 			reg = <0x31040000 0x1000>;
 			interrupts = <14 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&clk LPC32XX_CLK_LCD>;
-- 
2.20.1


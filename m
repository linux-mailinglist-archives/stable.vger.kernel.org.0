Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADCE414BA83
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:40:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728309AbgA1OQz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:16:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:40516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730403AbgA1OQz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:16:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7918B24681;
        Tue, 28 Jan 2020 14:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221014;
        bh=PQCZOBb0tClRVHStN0KZHSKj/cQZcnA7ddxBlP3cQg4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GfYymceUm2ETCrj7H53LnIHP7AbU4X7CVjwi5Um5Og4VHFQVWHtUHygNUjoWfNpDW
         zjhRs63sQRUuMg0parPGpOON48QFgVmiQtQR7SkPx9zVwGdu4YIvNG9SxF5uPR+7jK
         Txn9Vzdt2AgqNzoFZ8akUjsCqo3mO0f/+cwDbK8A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Zapolskiy <vz@mleia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 054/271] ARM: dts: lpc32xx: fix ARM PrimeCell LCD controller variant
Date:   Tue, 28 Jan 2020 15:03:23 +0100
Message-Id: <20200128135856.660149737@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 6bd196457ccc2..3adbbaff79715 100644
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




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6DC3C8FF9
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240620AbhGNTxl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:53:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:46242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240750AbhGNTuD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:50:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E1A661403;
        Wed, 14 Jul 2021 19:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291958;
        bh=Fwd91rwIIf+AOpLxkn81v7f7WAzoGYQDA1bHJTQ8QEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ed2ClbzpsBDCCa4uRFnfjeFHF21E0La1DPwMKC0Otf02qTJ5ogWPbmeEyO4kbrZRM
         Ry+qn6yLOlVIo3FMWEZWLC/JzfAHSpZzQ7jx3v3BZ0ykmFad1jfYF0prALu2s52FQN
         eHYVw61G8B3jX8l6Z0BJqp7ZSCkOyzUkqGRiG2xe4rCN+n6yCl0bAPn7dW5VJVHUwv
         GIOIhL6eWmCRKSQjypW5HZ+wWtGdjmcFHjIS27mOtv6arzFbKY2aEzOpNvrisFh8b3
         aUxHOmfNgeR0rwpV3ehJpcf7vRiPUIvRPpdd+0z4c9rvDqYQm3GUUOO/xIdOkciMmC
         pAe4bMOUZLXyQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 31/51] ARM: dts: stm32: fix RCC node name on stm32f429 MCU
Date:   Wed, 14 Jul 2021 15:44:53 -0400
Message-Id: <20210714194513.54827-31-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194513.54827-1-sashal@kernel.org>
References: <20210714194513.54827-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Torgue <alexandre.torgue@foss.st.com>

[ Upstream commit e4b948415a89a219d13e454011cdcf9e63ecc529 ]

This prevent warning observed with "make dtbs_check W=1"

Warning (simple_bus_reg): /soc/rcc@40023810: simple-bus unit address format
error, expected "40023800"

Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32f429.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/stm32f429.dtsi b/arch/arm/boot/dts/stm32f429.dtsi
index 5c8a826b3195..1476d3eaf6fa 100644
--- a/arch/arm/boot/dts/stm32f429.dtsi
+++ b/arch/arm/boot/dts/stm32f429.dtsi
@@ -696,7 +696,7 @@ crc: crc@40023000 {
 			status = "disabled";
 		};
 
-		rcc: rcc@40023810 {
+		rcc: rcc@40023800 {
 			#reset-cells = <1>;
 			#clock-cells = <2>;
 			compatible = "st,stm32f42xx-rcc", "st,stm32-rcc";
-- 
2.30.2


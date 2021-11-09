Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 814C744B557
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245554AbhKIWUc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:20:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:40274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245420AbhKIWTy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:19:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50BF56121F;
        Tue,  9 Nov 2021 22:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496227;
        bh=NNmy4jwqEz7jV8ggkkrX6c46LlgBk5vR4SOzWMcdR8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VaA6n5BYBoD7/kseZDaRJe649l6xZxisvMRCg0MkELLMbOGC0LxA807wplvgUjDyT
         pAbbX+D4XMBki4uHquXqg2FCXo48L++gAdgTvx3UFbZ/KB71CYxFwep5RUsGzHM1HT
         6MO0+VJPIK6xoGEDyE6HXQCWXljurqLhlUOaBJjNXNNaROD2w6pDg/eNrZLIz7NnxJ
         ztAQ8CXJtZsNYBwGhCHUMMYWDez8iDgdxpH3XhCo/b0vcW6CdCKw2qTYDqOPM34mob
         gaI8KQ3DW7+6C0+iU3JfFzURa0z5TuaWdCqm5LIg85QmSVqeEVn1Nbaqa/TkD14HWG
         O2Qed9TcjcESA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>, hauke@hauke-m.de,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 09/82] ARM: dts: BCM5301X: Fix MDIO mux binding
Date:   Tue,  9 Nov 2021 17:15:27 -0500
Message-Id: <20211109221641.1233217-9-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221641.1233217-1-sashal@kernel.org>
References: <20211109221641.1233217-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit 6ee0b56f7530e0ebb496fe15d0b54c5f3a1b5e17 ]

This fixes following error for all BCM5301X dts files:
mdio-bus-mux@18003000: compatible: ['mdio-mux-mmioreg'] is too short

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm5301x.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/bcm5301x.dtsi b/arch/arm/boot/dts/bcm5301x.dtsi
index f9d3a53065ef7..d4f355015e3ca 100644
--- a/arch/arm/boot/dts/bcm5301x.dtsi
+++ b/arch/arm/boot/dts/bcm5301x.dtsi
@@ -370,7 +370,7 @@
 	};
 
 	mdio-mux@18003000 {
-		compatible = "mdio-mux-mmioreg";
+		compatible = "mdio-mux-mmioreg", "mdio-mux";
 		mdio-parent-bus = <&mdio>;
 		#address-cells = <1>;
 		#size-cells = <0>;
-- 
2.33.0


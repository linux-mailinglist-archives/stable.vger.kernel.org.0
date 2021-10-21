Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1754356F9
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 02:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231611AbhJUAXq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 20:23:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:42468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231740AbhJUAXd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Oct 2021 20:23:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4504E6128E;
        Thu, 21 Oct 2021 00:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634775678;
        bh=dkCvC7JcUp89D5pDIH6bpJMp72CkeTXg05qjoA65ybs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AAXT1Kwp8gXN4iQChfAZFiSmZexhEHafSCKILPHV7HrBKUVMxdjmejC7OiKWvmLIh
         kMTaA15lQ6MzfHHE+wLaURWPviAs8OypStcQ5CeYK6b1lUkEqolOrzmj0XXxzA6NGB
         Urza02ddlFAxG3gSLqzK9S6Pwd7qSVQ0HZUr9yI4axC74s+uFSsbU2hwHLx0jb8koB
         4Cl8SUbX/VoWJ4V1CR7UX70fjvCE5croiGrBQK1wKePMQVpSS7NyMSyqtEpDQEeclF
         UlRmqY7+EH0aYc0nSfPUxmyYNNJnmWWEj/Os2cKGflDbm8S7GPLf5wt/wcGrxDCJKc
         qLy/KLf1c/wUg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Herve Codina <herve.codina@bootlin.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, vireshk@kernel.org,
        shiraz.linux.kernel@gmail.com, robh+dt@kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 13/26] ARM: dts: spear3xx: Fix gmac node
Date:   Wed, 20 Oct 2021 20:20:10 -0400
Message-Id: <20211021002023.1128949-13-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211021002023.1128949-1-sashal@kernel.org>
References: <20211021002023.1128949-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Herve Codina <herve.codina@bootlin.com>

[ Upstream commit 6636fec29cdf6665bd219564609e8651f6ddc142 ]

On SPEAr3xx, ethernet driver is not compatible with the SPEAr600
one.
Indeed, SPEAr3xx uses an earlier version of this IP (v3.40) and
needs some driver tuning compare to SPEAr600.

The v3.40 IP support was added to stmmac driver and this patch
fixes this issue and use the correct compatible string for
SPEAr3xx

Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/spear3xx.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/spear3xx.dtsi b/arch/arm/boot/dts/spear3xx.dtsi
index f266b7b03482..cc88ebe7a60c 100644
--- a/arch/arm/boot/dts/spear3xx.dtsi
+++ b/arch/arm/boot/dts/spear3xx.dtsi
@@ -47,7 +47,7 @@ dma@fc400000 {
 		};
 
 		gmac: eth@e0800000 {
-			compatible = "st,spear600-gmac";
+			compatible = "snps,dwmac-3.40a";
 			reg = <0xe0800000 0x8000>;
 			interrupts = <23 22>;
 			interrupt-names = "macirq", "eth_wake_irq";
-- 
2.33.0


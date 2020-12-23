Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0B1E2E1230
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728778AbgLWCTt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:19:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:45490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728757AbgLWCTs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:19:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3290F2332A;
        Wed, 23 Dec 2020 02:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689962;
        bh=Vcf1KZNula0B3d6tguNttEK09J/wHmlkr4IZJGbreyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=puKZ+bVcQTEBWmLbpUTe3eh8IcC1t9gsUCGGEpbvrPkVYWKc13xPua95qRXq6/4R1
         gy/OB+iiDcVBNDUMzPnEMtYkypzyIIibmJ8E50ZqeAdsUPdaz10fDqwEiiY09vw07S
         FsKatbQVM2SPn9nB7RApw6TGgGfh9P1ydZBaViMoZCGCrUzkZPqTgOQQM11FIlCeP/
         gvUJpgpvJpt4w3dZB/4SGq10B/1zkyppRMKYIH+gY2EOH+BuZyNL2bsmMoxWQiF5+k
         hi8deDQscMj8StN29iLvy63KtblcFhic6Jzirx0rqq0GLK7iOmI/HkA1MQhS2rYFV6
         Xyv8ZjiU/rf1Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 053/130] ARM: dts: NSP: Fix Ethernet switch SGMII register name
Date:   Tue, 22 Dec 2020 21:16:56 -0500
Message-Id: <20201223021813.2791612-53-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 8b0235d1deace8f1bd8cdd149d698fee3974fdf4 ]

The register name should be "sgmii_config", not "sgmii", this is not a
functional change since no code is currently looking for that register
by name (or at all).

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm-nsp.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/bcm-nsp.dtsi b/arch/arm/boot/dts/bcm-nsp.dtsi
index 8615d89fa4690..eff99bd44b38e 100644
--- a/arch/arm/boot/dts/bcm-nsp.dtsi
+++ b/arch/arm/boot/dts/bcm-nsp.dtsi
@@ -388,7 +388,7 @@ srab: srab@36000 {
 			reg = <0x36000 0x1000>,
 			      <0x3f308 0x8>,
 			      <0x3f410 0xc>;
-			reg-names = "srab", "mux_config", "sgmii";
+			reg-names = "srab", "mux_config", "sgmii_config";
 			interrupts = <GIC_SPI 95 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 96 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 97 IRQ_TYPE_LEVEL_HIGH>,
-- 
2.27.0


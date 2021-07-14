Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E249C3C8F22
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240860AbhGNTvx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:51:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:46244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238634AbhGNTsI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:48:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14E04613E2;
        Wed, 14 Jul 2021 19:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291815;
        bh=cBakN/sw+SBG0A4dFB+/8gCBgPbiPQRJAWuWq+SFgug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UWc5obfDZb389kMgYWtY45KEB0iI3N1j7VN+74UwDQBY0Mpn/5t/sruo8H1VzVCSR
         ZqQvCm3o5kkZ2/za9bH2dDWbun2F7TF3cmp96ZJF2uifapW51pZ2P0gRJM5AgW4XwV
         VlRMIyiFYKJBbA2LJQRhKYSDN8kbMp+Kq3+e5XuAVrVWziK7i/VKUjvMBGapu5vkyU
         fBdnGudCsy7J/XTDwo0V08x4u65yt8K2NRQJWPvMC5cbr0b51V2DpnH+R1t6MBVuFI
         UTtiTg63mePHtGqDWGsXC4Jkdet1z4XwWg1UlmTPuObp0nAh97JPdhjlbM88pUEajV
         cGTXNtmclUkXg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 19/88] ARM: dts: Hurricane 2: Fix NAND nodes names
Date:   Wed, 14 Jul 2021 15:41:54 -0400
Message-Id: <20210714194303.54028-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194303.54028-1-sashal@kernel.org>
References: <20210714194303.54028-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit a4528d9029e2eda16e4fc9b9da1de1fbec10ab26 ]

This matches nand-controller.yaml requirements.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm-hr2.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/bcm-hr2.dtsi b/arch/arm/boot/dts/bcm-hr2.dtsi
index e8df458aad39..84cda16f68a2 100644
--- a/arch/arm/boot/dts/bcm-hr2.dtsi
+++ b/arch/arm/boot/dts/bcm-hr2.dtsi
@@ -179,7 +179,7 @@ amac0: ethernet@22000 {
 			status = "disabled";
 		};
 
-		nand: nand@26000 {
+		nand_controller: nand-controller@26000 {
 			compatible = "brcm,nand-iproc", "brcm,brcmnand-v6.1";
 			reg = <0x26000 0x600>,
 			      <0x11b408 0x600>,
-- 
2.30.2


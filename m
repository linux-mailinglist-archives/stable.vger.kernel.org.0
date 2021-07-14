Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 744BE3C8CEA
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235870AbhGNTnM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:43:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:38286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229721AbhGNTmp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:42:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9795613D3;
        Wed, 14 Jul 2021 19:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291593;
        bh=o/5BGkW9IfiS4kLnJ19sjvYH0Uk7ZMME1iMaVKhqcrE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O7C8UY/3NuI+nBE8GuhhM7i19vagsMbpJOMxe7qT8ShLE5MEcpTfBNYFnHz4aWxxc
         R/AEWHvE/0Or5Q2vZ2OdvbTm0jZD3+ekf6W7Ns8uGfpwO3PQczAgYv/vgeEI8kb4/9
         OmZaehXAQbEpJlb+xAsseAAFExvBa+xqSE/VQm7LoWgp2QOW8xL5IrHnP4vgrkCvWH
         X+W+unCLnTTWtQYbhsqa15msjKJrgByS8WTNa2E5OYwcHUZtN785tAtrDZJO+FKbSk
         1KkE36VfJe+1O5kd0hqnhcEnEIe6pkDDx5ugbbkIpLJDaUIRmyaOiyElpq6tLFe3xb
         Q3hjxGGN1gF5Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Patrick Delaunay <patrick.delaunay@foss.st.com>,
        kernel@dh-electronics.com,
        linux-stm32@st-md-mailman.stormreply.com,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 077/108] ARM: dts: stm32: Rename eth@N to ethernet@N on DHCOM SoM
Date:   Wed, 14 Jul 2021 15:37:29 -0400
Message-Id: <20210714193800.52097-77-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714193800.52097-1-sashal@kernel.org>
References: <20210714193800.52097-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit b586250df24226f8a257e11e1f5953054c54fd35 ]

Fix the following dtbs_check warning:
eth@1,0: $nodename:0: 'eth@1,0' does not match '^ethernet(@.*)?$'

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc: Patrice Chotard <patrice.chotard@foss.st.com>
Cc: Patrick Delaunay <patrick.delaunay@foss.st.com>
Cc: kernel@dh-electronics.com
Cc: linux-stm32@st-md-mailman.stormreply.com
To: linux-arm-kernel@lists.infradead.org
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi b/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi
index 272a1a67a9ad..ae58f3b4d9d4 100644
--- a/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xx-dhcom-som.dtsi
@@ -144,7 +144,7 @@ &fmc {
 	pinctrl-1 = <&fmc_sleep_pins_b>;
 	status = "okay";
 
-	ksz8851: ks8851mll@1,0 {
+	ksz8851: ethernet@1,0 {
 		compatible = "micrel,ks8851-mll";
 		reg = <1 0x0 0x2>, <1 0x2 0x20000>;
 		interrupt-parent = <&gpioc>;
-- 
2.30.2


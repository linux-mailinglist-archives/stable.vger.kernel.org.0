Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6CF03C8F77
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237742AbhGNTwj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:52:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:46246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239898AbhGNTt1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:49:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 255D46141F;
        Wed, 14 Jul 2021 19:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291877;
        bh=1dAUiCV8RZ3na6Q4TsF8CKkJ/0h5oRkuovNOqnr14dg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M6UFRgRwy7KwpNieCSZrzxM8XVMXOLMvj09K7ln2ByBGiyINDhDwNqmAew89fUBLz
         sDKgO5jtkpjB9nID9cg94k9XBz1ubAUEbooX3JNYnzRHbovZhZl4x2w4rQzwSLiuwm
         DVYtGlZVjcliNsJjiYWz+e7nnSk3PFLAxY/Mu/Q33UqwtDWMUumxFdpSYbJzUZJytS
         Lf45SWYIEtqsS8j9ACD2QrgY3VIEsSqeJBcfHE3oDSMAl4sqF3hyyV2PJVNwrPGNnS
         w9HCOj7JEsNpwm+q+5rCy5fmMuwZbvLXbcdp6T2bL1x0EW2qhrf8MhjccYQUVGSCeM
         qQSNkUDm4mJUg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Grzegorz Szymaszek <gszymaszek@short.pl>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 62/88] ARM: dts: stm32: fix the Odyssey SoM eMMC VQMMC supply
Date:   Wed, 14 Jul 2021 15:42:37 -0400
Message-Id: <20210714194303.54028-62-sashal@kernel.org>
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

From: Grzegorz Szymaszek <gszymaszek@short.pl>

[ Upstream commit f493162319788802b6a49634f7268e691b4c10ec ]

The Seeed SoM-STM32MP157C device tree had the eMMC’s (SDMMC2) VQMMC
supply set to v3v3 (buck4), the same as the VMMC supply. That was
incorrect, as on the SoM, the VQMMC supply is provided from vdd (buck3)
instead.

Signed-off-by: Grzegorz Szymaszek <gszymaszek@short.pl>
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp157c-odyssey-som.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/stm32mp157c-odyssey-som.dtsi b/arch/arm/boot/dts/stm32mp157c-odyssey-som.dtsi
index 6cf49a0a9e69..b5601d270c8f 100644
--- a/arch/arm/boot/dts/stm32mp157c-odyssey-som.dtsi
+++ b/arch/arm/boot/dts/stm32mp157c-odyssey-som.dtsi
@@ -269,7 +269,7 @@ &sdmmc2 {
 	st,neg-edge;
 	bus-width = <8>;
 	vmmc-supply = <&v3v3>;
-	vqmmc-supply = <&v3v3>;
+	vqmmc-supply = <&vdd>;
 	mmc-ddr-3_3v;
 	status = "okay";
 };
-- 
2.30.2


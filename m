Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B42E3C8D02
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236079AbhGNTn1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:43:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:38712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234572AbhGNTm5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:42:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B97B6613DA;
        Wed, 14 Jul 2021 19:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291605;
        bh=hTy3bHzj9LJkOJ3PZjheKqGQnrIXHro+9qpvDOZf/ms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hA245KWKic3VZalNc0qg2yWjXVijRGc/iGUDQIKKHKYdR7Zxw2eTgjd7o57Pd2qtY
         xMk5OHC+j0DSOlUzBcD8VrIvkNp59cOgxlcTuCTi5Vqh3imMj876HqY/zG4Ds8/O3b
         OFlIHI878v3M5NuzrFJtwiFMTI2WOydaOzk5DXkTJUbffXR4fYCWLFeN69tlwGpFOt
         7Yfg0dzk8tMJePs6WAsYx7m4VAEpER+RQyFiWiFwPZJzouTbc0a+NwDlrJrMaEGih8
         sNMLB8ZDbPPhQMDD8S5GFmQ2HEPbRW0yeIzzlsVKu05Fesl6tsht5Z918N5dSicZNf
         9FxLCMFAxUAlw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Adam Ford <aford173@gmail.com>, Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 086/108] arm64: dts: imx8mn-beacon-som: Assign PMIC clock
Date:   Wed, 14 Jul 2021 15:37:38 -0400
Message-Id: <20210714193800.52097-86-sashal@kernel.org>
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

From: Adam Ford <aford173@gmail.com>

[ Upstream commit 1de3aa8611d21d6be546ca1cd13ee05bdd650018 ]

The PMIC throws an errors because the clock isn't assigned to it.
Fix this by assigning the clocks info.

Signed-off-by: Adam Ford <aford173@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mn-beacon-som.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mn-beacon-som.dtsi b/arch/arm64/boot/dts/freescale/imx8mn-beacon-som.dtsi
index c35eeaff958f..54eaf3d6055b 100644
--- a/arch/arm64/boot/dts/freescale/imx8mn-beacon-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mn-beacon-som.dtsi
@@ -120,6 +120,9 @@ pmic@4b {
 		interrupt-parent = <&gpio1>;
 		interrupts = <3 IRQ_TYPE_LEVEL_LOW>;
 		rohm,reset-snvs-powered;
+		#clock-cells = <0>;
+		clocks = <&osc_32k 0>;
+		clock-output-names = "clk-32k-out";
 
 		regulators {
 			buck1_reg: BUCK1 {
-- 
2.30.2


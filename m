Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD7E1404C11
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 13:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238021AbhIILz2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 07:55:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:55124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242964AbhIILw7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:52:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BD5261390;
        Thu,  9 Sep 2021 11:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187867;
        bh=COzna+AUvS9AjH9VMQTRotAp6F8lPQK/nnKVsWvii1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e3YwAiPMR2tRz/HjvMj7fcu3nsM64Z6tAtw3ys3m6C9YB2H3GKlpx+nyeNDbxHn8o
         IWcf3F/8uVm6ok4PZFmp5SYckJB+0VCVpbL2Ed7sgjfNCgT0p4JpeCIlhLmZqY0KkS
         dmkSZrPeKEjyFJ424COhK8YwPTb3gTEh7NuaW9ikoU4/pvtULPBDZpXlA+xwE4o1N/
         GHEQNHVUn+FyQsr/5Sezd6nC8K5E3eHRGuDp2tuxh4B997PrJndUlAwB9TeO0NmM1w
         3a993ublTFHdLhIYGutY8RKuYmHHOxY9puBJvkTam2CJGjUq52acIgFCgm6qtha6+w
         vnqG7XKSdXNJg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tim Harvey <tharvey@gateworks.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.14 154/252] arm64: dts: imx8mm-venice-gw700x: fix invalid pmic pin config
Date:   Thu,  9 Sep 2021 07:39:28 -0400
Message-Id: <20210909114106.141462-154-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tim Harvey <tharvey@gateworks.com>

[ Upstream commit 500659f3b401fe6ffd1d63f2449d16d8a4204db7 ]

The GW700x PMIC does not have an interrupt. Remove the invalid pin
config.

Signed-off-by: Tim Harvey <tharvey@gateworks.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-venice-gw700x.dtsi | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw700x.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw700x.dtsi
index 11dda79cc46b..00f86cada30d 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw700x.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw700x.dtsi
@@ -278,8 +278,6 @@ rtc@68 {
 
 	pmic@69 {
 		compatible = "mps,mp5416";
-		pinctrl-names = "default";
-		pinctrl-0 = <&pinctrl_pmic>;
 		reg = <0x69>;
 
 		regulators {
@@ -444,12 +442,6 @@ MX8MM_IOMUXC_I2C2_SDA_I2C2_SDA		0x400001c3
 		>;
 	};
 
-	pinctrl_pmic: pmicgrp {
-		fsl,pins = <
-			MX8MM_IOMUXC_GPIO1_IO03_GPIO1_IO3	0x41
-		>;
-	};
-
 	pinctrl_uart2: uart2grp {
 		fsl,pins = <
 			MX8MM_IOMUXC_UART2_RXD_UART2_DCE_RX	0x140
-- 
2.30.2


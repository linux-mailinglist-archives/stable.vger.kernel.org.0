Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAB4D3C8E43
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238027AbhGNTq7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:46:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:37258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237539AbhGNTqG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:46:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B64660FF2;
        Wed, 14 Jul 2021 19:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291752;
        bh=qUweLN6xljzzvKRDaafKcHAS/rsl78e8oPMyOcU15i8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mQzz46BOmTUu1zdeWLlxI9aegISNyntlsLLlR6gGSImxhEH2jns83JMg+7381sfQ8
         usGcVjTkttoa2WadoSAjyOncFyPrOiEV2zN6yktQU6xqB0FY2GvptOBmwpBYjpgtJG
         3KuNzrUzAu+0nqJNppZwA3utxqBgwt6vrw671jhjpHuy5rKh7VZ+CseyC6av9Bq6P7
         cFpps4dBm9Chg/UP0opaPUZ2VL22HtfjwIVuUASK+8+wHInQZX9DZY0hKAmqnICuuI
         pV61HJ9RcHt3KWAaZn0tVgsixFhGwqVw4bXM9AJ5y4GOjwJMvQE/r5I6gi6SoRkWO1
         QvVALD4zJ0kug==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Adam Ford <aford173@gmail.com>, Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.12 081/102] arm64: dts: imx8mn-beacon-som: Assign PMIC clock
Date:   Wed, 14 Jul 2021 15:40:14 -0400
Message-Id: <20210714194036.53141-81-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194036.53141-1-sashal@kernel.org>
References: <20210714194036.53141-1-sashal@kernel.org>
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
index de2cd0e3201c..8cd9a35afd0e 100644
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


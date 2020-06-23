Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3CA8205ED8
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390702AbgFWU0s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:26:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:46076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390699AbgFWU0r (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:26:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBE68206C3;
        Tue, 23 Jun 2020 20:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944007;
        bh=HPpqoGW58H2wan4+FTXlzM3xAZ9f17wRMJQr5VvZcgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sN+ZYg2jVIQ6NbyinRUSZLI7eC/rBAXpQ6r1mraHFtizEIdyKfullaWmpx0XEUoqs
         yxGN5wDZzAgnRZPSswLNTJVJvINexxCR0FOQMtnq6EQh5PYnng1OB/yh2GfOLj1Dch
         Nf8roV/SC5lwfGrhBemtqpD5BOpuGXjBg0f4iulg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Loic Poulain <loic.poulain@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 129/314] arm64: dts: msm8996: Fix CSI IRQ types
Date:   Tue, 23 Jun 2020 21:55:24 +0200
Message-Id: <20200623195345.025734579@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Loic Poulain <loic.poulain@linaro.org>

[ Upstream commit 4a4a26317ec8aba575f6b85789a42639937bc1a4 ]

Each IRQ_TYPE_NONE interrupt causes a warning at boot.
Fix that by defining an appropriate type.

Fixes: e0531312e78f ("arm64: dts: qcom: msm8996: Add CAMSS support")
Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
Link: https://lore.kernel.org/r/1587470425-13726-1-git-send-email-loic.poulain@linaro.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8996.dtsi | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8996.dtsi b/arch/arm64/boot/dts/qcom/msm8996.dtsi
index fbb8ce78f95be..d303df3887d9f 100644
--- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
@@ -1681,16 +1681,16 @@
 				"csi_clk_mux",
 				"vfe0",
 				"vfe1";
-			interrupts = <GIC_SPI 78 0>,
-				<GIC_SPI 79 0>,
-				<GIC_SPI 80 0>,
-				<GIC_SPI 296 0>,
-				<GIC_SPI 297 0>,
-				<GIC_SPI 298 0>,
-				<GIC_SPI 299 0>,
-				<GIC_SPI 309 0>,
-				<GIC_SPI 314 0>,
-				<GIC_SPI 315 0>;
+			interrupts = <GIC_SPI 78 IRQ_TYPE_EDGE_RISING>,
+				<GIC_SPI 79 IRQ_TYPE_EDGE_RISING>,
+				<GIC_SPI 80 IRQ_TYPE_EDGE_RISING>,
+				<GIC_SPI 296 IRQ_TYPE_EDGE_RISING>,
+				<GIC_SPI 297 IRQ_TYPE_EDGE_RISING>,
+				<GIC_SPI 298 IRQ_TYPE_EDGE_RISING>,
+				<GIC_SPI 299 IRQ_TYPE_EDGE_RISING>,
+				<GIC_SPI 309 IRQ_TYPE_EDGE_RISING>,
+				<GIC_SPI 314 IRQ_TYPE_EDGE_RISING>,
+				<GIC_SPI 315 IRQ_TYPE_EDGE_RISING>;
 			interrupt-names = "csiphy0",
 				"csiphy1",
 				"csiphy2",
-- 
2.25.1




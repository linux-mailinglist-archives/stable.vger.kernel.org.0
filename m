Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52D297FAC9
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 15:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393626AbfHBNVv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 09:21:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:60328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393419AbfHBNVu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 09:21:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3AF32173E;
        Fri,  2 Aug 2019 13:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564752109;
        bh=q9rs/7qq0AtCKj0n7LPcl7VPkSBWqcJCnchLvQih/Tw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AJmXpU8eoGefE2b13zFqc1w9JPzVt9PWecBQ5bs8F1MxE3d4VC0lXMVlgkOdIMnDl
         T7hK6ZYIvpgrXlQwpaoYmeM/i8T/EnZP6uHaK6ryRb6Os6kXPHGIsfR4TqZszYcDlI
         hFuu9Mmolpycwzp8uurM7q0VSWv36MJeF7D50hX0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lucas Stach <l.stach@pengutronix.de>,
        Daniel Baluta <daniel.baluta@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 45/76] arm64: dts: imx8mq: fix SAI compatible
Date:   Fri,  2 Aug 2019 09:19:19 -0400
Message-Id: <20190802131951.11600-45-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190802131951.11600-1-sashal@kernel.org>
References: <20190802131951.11600-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Stach <l.stach@pengutronix.de>

[ Upstream commit 8d0148473dece51675d11dd59b8db5fe4b5d2e7e ]

The i.MX8M SAI block is not compatible with the i.MX6SX one, as the
register layout has changed due to two version registers being added
at the beginning of the address map. Remove the bogus compatible.

Fixes: 8c61538dc945 ("arm64: dts: imx8mq: Add SAI2 node")
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Reviewed-by: Daniel Baluta <daniel.baluta@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mq.dtsi | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mq.dtsi b/arch/arm64/boot/dts/freescale/imx8mq.dtsi
index 6d635ba0904c5..6632cbd88bed3 100644
--- a/arch/arm64/boot/dts/freescale/imx8mq.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mq.dtsi
@@ -675,8 +675,7 @@
 
 			sai2: sai@308b0000 {
 				#sound-dai-cells = <0>;
-				compatible = "fsl,imx8mq-sai",
-					     "fsl,imx6sx-sai";
+				compatible = "fsl,imx8mq-sai";
 				reg = <0x308b0000 0x10000>;
 				interrupts = <GIC_SPI 96 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clk IMX8MQ_CLK_SAI2_IPG>,
-- 
2.20.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4C926B50A
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727195AbgIOXfv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:35:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:47666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727138AbgIOOfY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:35:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C1A622247;
        Tue, 15 Sep 2020 14:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179956;
        bh=4cw+bNFwDeBdr0mXJYcZeLlF1VSD930Q2UFmP1HdAos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bb2Q26QbqWVDpF+axNkRqsOdocuqHzsFuk5FJQe3YKy8V5zXrRXzRCEYlgR6U8hPr
         kcJBpyPRGc7TMzgtsxzUDPlqPi2WMpcOQfNqtHVReA0RKX05ac22vtR3tQvTqVetwS
         Jyf63HA4dSRXv7J1VdC9rjPv6I8aZfl3CzbY1IG8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 024/177] arm64: dts: imx8mq: Fix TMU interrupt property
Date:   Tue, 15 Sep 2020 16:11:35 +0200
Message-Id: <20200915140654.806546181@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 1f2f98f2703e8134678fe20982886085631eda23 ]

"interrupt" is not a valid property.  Using proper name fixes dtbs_check
warning:

  arch/arm64/boot/dts/freescale/imx8mq-zii-ultra-zest.dt.yaml: tmu@30260000: 'interrupts' is a required property

Fixes: e464fd2ba4d4 ("arm64: dts: imx8mq: enable the multi sensor TMU")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mq.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mq.dtsi b/arch/arm64/boot/dts/freescale/imx8mq.dtsi
index 978f8122c0d2c..66ac66856e7e8 100644
--- a/arch/arm64/boot/dts/freescale/imx8mq.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mq.dtsi
@@ -420,7 +420,7 @@
 			tmu: tmu@30260000 {
 				compatible = "fsl,imx8mq-tmu";
 				reg = <0x30260000 0x10000>;
-				interrupt = <GIC_SPI 49 IRQ_TYPE_LEVEL_HIGH>;
+				interrupts = <GIC_SPI 49 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clk IMX8MQ_CLK_TMU_ROOT>;
 				little-endian;
 				fsl,tmu-range = <0xb0000 0xa0026 0x80048 0x70061>;
-- 
2.25.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D469026B5C8
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbgIOXvO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:51:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:43890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727089AbgIOOcm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:32:42 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B56922CAD;
        Tue, 15 Sep 2020 14:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179851;
        bh=ZMFSM/ky15tcCkJXLSBMAm/OUHU3XkGYmq+8LxZSaW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lXWHzGoyJ/luNgDFC6fTvmdCdu1Mhj/LAupdt6+M8y6GqtWtFW0Gd/Smvbng6C0hf
         pMfnh0qipS8BJcLhzcXT02iwgUgn9vTAISfnjaLtPnP995gO/ay9nPy/Xs24Uq5o8p
         nthYyewX2XRIhH5cdgVRbZnPKIGMXWuS4U6XKhzA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anson Huang <Anson.Huang@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 011/177] ARM: dts: imx7ulp: Correct gpio ranges
Date:   Tue, 15 Sep 2020 16:11:22 +0200
Message-Id: <20200915140654.180049299@linuxfoundation.org>
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

From: Anson Huang <Anson.Huang@nxp.com>

[ Upstream commit deb6323b739c54e1a1e83cd3a2bae4901e3eebf6 ]

Correct gpio ranges according to i.MX7ULP pinctrl driver:

gpio_ptc: ONLY pin 0~19 are available;
gpio_ptd: ONLY pin 0~11 are available;
gpio_pte: ONLY pin 0~15 are available;
gpio_ptf: ONLY pin 0~19 are available;

Fixes: 20434dc92c05 ("ARM: dts: imx: add common imx7ulp dtsi support")
Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx7ulp.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/imx7ulp.dtsi b/arch/arm/boot/dts/imx7ulp.dtsi
index f7c4878534c8e..1bff3efe8aafe 100644
--- a/arch/arm/boot/dts/imx7ulp.dtsi
+++ b/arch/arm/boot/dts/imx7ulp.dtsi
@@ -394,7 +394,7 @@
 			clocks = <&pcc2 IMX7ULP_CLK_RGPIO2P1>,
 				 <&pcc3 IMX7ULP_CLK_PCTLC>;
 			clock-names = "gpio", "port";
-			gpio-ranges = <&iomuxc1 0 0 32>;
+			gpio-ranges = <&iomuxc1 0 0 20>;
 		};
 
 		gpio_ptd: gpio@40af0000 {
@@ -408,7 +408,7 @@
 			clocks = <&pcc2 IMX7ULP_CLK_RGPIO2P1>,
 				 <&pcc3 IMX7ULP_CLK_PCTLD>;
 			clock-names = "gpio", "port";
-			gpio-ranges = <&iomuxc1 0 32 32>;
+			gpio-ranges = <&iomuxc1 0 32 12>;
 		};
 
 		gpio_pte: gpio@40b00000 {
@@ -422,7 +422,7 @@
 			clocks = <&pcc2 IMX7ULP_CLK_RGPIO2P1>,
 				 <&pcc3 IMX7ULP_CLK_PCTLE>;
 			clock-names = "gpio", "port";
-			gpio-ranges = <&iomuxc1 0 64 32>;
+			gpio-ranges = <&iomuxc1 0 64 16>;
 		};
 
 		gpio_ptf: gpio@40b10000 {
@@ -436,7 +436,7 @@
 			clocks = <&pcc2 IMX7ULP_CLK_RGPIO2P1>,
 				 <&pcc3 IMX7ULP_CLK_PCTLF>;
 			clock-names = "gpio", "port";
-			gpio-ranges = <&iomuxc1 0 96 32>;
+			gpio-ranges = <&iomuxc1 0 96 20>;
 		};
 	};
 
-- 
2.25.1




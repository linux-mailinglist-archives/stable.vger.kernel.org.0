Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9136126B6D5
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 02:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbgIPAL7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 20:11:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:38308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726938AbgIOO0a (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:26:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD2AD2245F;
        Tue, 15 Sep 2020 14:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179570;
        bh=IJGbvK/EOOaibm70TZ2Guw+wM3bImoQ0GafNoiRZ7LY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2iQl1GyR8twbpUmlaLFt+F/6ts3yMJQoJtn0Mguwb6xqGLOBSrlMvJ2HKk5Kzjnaa
         mRzB5q0fpoe4YeFYu+rZyQt3lZd97/4X/akzJbfkyMmTtuxiP/jp2Dp0fEkYRbQt08
         C66IdxTVMmInYYuir3S7JuhbLWX3ktJ6qnMLEndw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anson Huang <Anson.Huang@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 009/132] ARM: dts: imx7ulp: Correct gpio ranges
Date:   Tue, 15 Sep 2020 16:11:51 +0200
Message-Id: <20200915140644.538491455@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140644.037604909@linuxfoundation.org>
References: <20200915140644.037604909@linuxfoundation.org>
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
index 3dac6898cdc57..0108b63df77d3 100644
--- a/arch/arm/boot/dts/imx7ulp.dtsi
+++ b/arch/arm/boot/dts/imx7ulp.dtsi
@@ -397,7 +397,7 @@
 			clocks = <&pcc2 IMX7ULP_CLK_RGPIO2P1>,
 				 <&pcc3 IMX7ULP_CLK_PCTLC>;
 			clock-names = "gpio", "port";
-			gpio-ranges = <&iomuxc1 0 0 32>;
+			gpio-ranges = <&iomuxc1 0 0 20>;
 		};
 
 		gpio_ptd: gpio@40af0000 {
@@ -411,7 +411,7 @@
 			clocks = <&pcc2 IMX7ULP_CLK_RGPIO2P1>,
 				 <&pcc3 IMX7ULP_CLK_PCTLD>;
 			clock-names = "gpio", "port";
-			gpio-ranges = <&iomuxc1 0 32 32>;
+			gpio-ranges = <&iomuxc1 0 32 12>;
 		};
 
 		gpio_pte: gpio@40b00000 {
@@ -425,7 +425,7 @@
 			clocks = <&pcc2 IMX7ULP_CLK_RGPIO2P1>,
 				 <&pcc3 IMX7ULP_CLK_PCTLE>;
 			clock-names = "gpio", "port";
-			gpio-ranges = <&iomuxc1 0 64 32>;
+			gpio-ranges = <&iomuxc1 0 64 16>;
 		};
 
 		gpio_ptf: gpio@40b10000 {
@@ -439,7 +439,7 @@
 			clocks = <&pcc2 IMX7ULP_CLK_RGPIO2P1>,
 				 <&pcc3 IMX7ULP_CLK_PCTLF>;
 			clock-names = "gpio", "port";
-			gpio-ranges = <&iomuxc1 0 96 32>;
+			gpio-ranges = <&iomuxc1 0 96 20>;
 		};
 	};
 
-- 
2.25.1




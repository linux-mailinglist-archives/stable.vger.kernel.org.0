Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA6C1488E4
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 15:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404169AbgAXOb3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 09:31:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:41394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404834AbgAXOUY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 09:20:24 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C62A32087E;
        Fri, 24 Jan 2020 14:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875623;
        bh=0BOlGA6oAYqfl/yKYGzKEd6mTq0cA3rq4GlXDVgJxYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=prX+HvpxusXF+QzioMf6b4y0R73NvkW+1zrbuq2kCZeCQ3FUcv0Y/FWTU8SR0vsoU
         VyZ/6MLfFpw1xmzJU1IPAGrsLhtAYwqLG13KSVXb4XgD2doD5D8beoR0L0JnSuO/f9
         HFqqpYeXOsHHSYGSHoaaXH9PxzmhqezaRgROSAUo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 09/56] ARM: dts: imx6q-dhcom: fix rtc compatible
Date:   Fri, 24 Jan 2020 09:19:25 -0500
Message-Id: <20200124142012.29752-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124142012.29752-1-sashal@kernel.org>
References: <20200124142012.29752-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

[ Upstream commit 7d7778b1396bc9e2a3875009af522beb4ea9355a ]

The only correct and documented compatible string for the rv3029 is
microcrystal,rv3029. Fix it up.

Fixes: 52c7a088badd ("ARM: dts: imx6q: Add support for the DHCOM iMX6 SoM and PDK2")
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6q-dhcom-som.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6q-dhcom-som.dtsi b/arch/arm/boot/dts/imx6q-dhcom-som.dtsi
index bbba0671f0f41..5b4d78999f809 100644
--- a/arch/arm/boot/dts/imx6q-dhcom-som.dtsi
+++ b/arch/arm/boot/dts/imx6q-dhcom-som.dtsi
@@ -205,7 +205,7 @@
 	};
 
 	rtc@56 {
-		compatible = "rv3029c2";
+		compatible = "microcrystal,rv3029";
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_rtc_hw300>;
 		reg = <0x56>;
-- 
2.20.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE5CF4A4D
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388954AbfKHMIN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 07:08:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:53544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388802AbfKHLkh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:40:37 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C56FC21D7B;
        Fri,  8 Nov 2019 11:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213236;
        bh=Y/lSeFUj09NRedzoVHJVECoGjBONRK90FvfRc4l06y4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YaOF1cCVt2DmfoMdaZWWv/fx/bTDQ83EztKWA8Ag+wwwbJAezMJBBrKrAqUXNcYBZ
         6HWWgfGqDuzrsHn/2hORTUTUcoAOrYv9ZN7mw22A+83QAjELr1IBvHY3VzLAuTQuHZ
         7ajhAgGkFbbjtELgYGwlZEPeA3kI9ypV/5HreiHE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "H. Nikolaus Schaller" <hns@goldelico.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 106/205] ARM: dts: omap3-gta04: give spi_lcd node a label so that we can overwrite in other DTS files
Date:   Fri,  8 Nov 2019 06:36:13 -0500
Message-Id: <20191108113752.12502-106-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "H. Nikolaus Schaller" <hns@goldelico.com>

[ Upstream commit fa0d7dc355c890725b6178dab0cc11b194203afa ]

needed for device variants based on GTA04 board but with
different display panel (driver).

Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/omap3-gta04.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/omap3-gta04.dtsi b/arch/arm/boot/dts/omap3-gta04.dtsi
index ac830b9177763..ae33e0e0f1d2c 100644
--- a/arch/arm/boot/dts/omap3-gta04.dtsi
+++ b/arch/arm/boot/dts/omap3-gta04.dtsi
@@ -78,7 +78,7 @@
 		#sound-dai-cells = <0>;
 	};
 
-	spi_lcd {
+	spi_lcd: spi_lcd {
 		compatible = "spi-gpio";
 		#address-cells = <0x1>;
 		#size-cells = <0x0>;
-- 
2.20.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A64EF480C
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 12:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732259AbfKHLyS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:54:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:34154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387396AbfKHLq0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:46:26 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC2FA22480;
        Fri,  8 Nov 2019 11:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213585;
        bh=H9WHMuJKONkrdmTXS911D1LW5nFnegvaA9HCD7XFBuU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TB5xmufmBP2GtXEL8XlYALYua72jHi6k7sbfiNy+web34tF2b+IFnAYYoGH6ciRrh
         bnPecutFNrXHpKlQZoSVeTkkrtgy6jAuidW7VOz55qS0I0lDwaUZnGhIdiXYV7b4UY
         37i9hKsoWIumFF53lkinsH8zts+pin7RBr/A8iyU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "H. Nikolaus Schaller" <hns@goldelico.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 28/64] ARM: dts: omap3-gta04: give spi_lcd node a label so that we can overwrite in other DTS files
Date:   Fri,  8 Nov 2019 06:45:09 -0500
Message-Id: <20191108114545.15351-28-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114545.15351-1-sashal@kernel.org>
References: <20191108114545.15351-1-sashal@kernel.org>
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
index b3a8b1f24499a..95c6ac44e307f 100644
--- a/arch/arm/boot/dts/omap3-gta04.dtsi
+++ b/arch/arm/boot/dts/omap3-gta04.dtsi
@@ -70,7 +70,7 @@
 		#sound-dai-cells = <0>;
 	};
 
-	spi_lcd {
+	spi_lcd: spi_lcd {
 		compatible = "spi-gpio";
 		#address-cells = <0x1>;
 		#size-cells = <0x0>;
-- 
2.20.1


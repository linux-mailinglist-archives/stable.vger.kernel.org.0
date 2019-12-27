Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD8712B7A8
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 18:51:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728385AbfL0RoP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 12:44:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:42258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728381AbfL0RoO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Dec 2019 12:44:14 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CED7A24650;
        Fri, 27 Dec 2019 17:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468653;
        bh=zDPSuGbcNkmbbtTnk9w1Bx3wZxsTbV4rpqmXHikbpRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NxoVmaFyo2QJlww5vNGwMZPXboHWW3REWjiFWl3wuMNcN3sDo9tFSET8iJ6e9SL4Z
         bjKbW/gXiPcA+OtCUGI6lpqDBwY1E9sFgK72d2e7KA1YzqxDHkJalhPL7asWVlT8HR
         VNR+xzo2Sl//KU96XaZxRW0/37BU8cZaVu3EEqe4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stefan Roese <sr@denx.de>, Fabio Estevam <festevam@gmail.com>,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 16/84] ARM: dts: imx6ul: imx6ul-14x14-evk.dtsi: Fix SPI NOR probing
Date:   Fri, 27 Dec 2019 12:42:44 -0500
Message-Id: <20191227174352.6264-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174352.6264-1-sashal@kernel.org>
References: <20191227174352.6264-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Roese <sr@denx.de>

[ Upstream commit 0aeb1f2b74f3402e9cdb7c0b8e2c369c9767301e ]

Without this "jedec,spi-nor" compatible property, probing of the SPI NOR
does not work on the NXP i.MX6ULL EVK. Fix this by adding this
compatible property to the DT.

Fixes: 7d77b8505aa9 ("ARM: dts: imx6ull: fix the imx6ull-14x14-evk configuration")
Signed-off-by: Stefan Roese <sr@denx.de>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Reviewed-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6ul-14x14-evk.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6ul-14x14-evk.dtsi b/arch/arm/boot/dts/imx6ul-14x14-evk.dtsi
index 818021126559..695303435003 100644
--- a/arch/arm/boot/dts/imx6ul-14x14-evk.dtsi
+++ b/arch/arm/boot/dts/imx6ul-14x14-evk.dtsi
@@ -175,7 +175,7 @@
 	flash0: n25q256a@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
-		compatible = "micron,n25q256a";
+		compatible = "micron,n25q256a", "jedec,spi-nor";
 		spi-max-frequency = <29000000>;
 		reg = <0>;
 	};
-- 
2.20.1


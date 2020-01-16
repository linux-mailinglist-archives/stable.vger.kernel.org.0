Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DABC13E0CA
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729648AbgAPQpo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:45:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:54646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728939AbgAPQpn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:45:43 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41F3D2176D;
        Thu, 16 Jan 2020 16:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193142;
        bh=YNeujmfNV+rEZDZIwmdUZEfgfim5hYv0ejt1bkiSimE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RGAetJb63EfGDko/L7FxJwJ+WMUvhKCAvbT7vqU1bCQPlpajDmG57vuOx9xFpVkPw
         FyW5S8yv1vbKraCPUj5R0RmrhQZF35fxoy7DhmPCx7xVnH51q8fYvGD3XlBENw2pl0
         mB1uafE/a7WH/UPu2qV0ejNZzauXpNtLePhNXyD0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 033/205] arm64: dts: marvell: Add AP806-dual missing CPU clocks
Date:   Thu, 16 Jan 2020 11:40:08 -0500
Message-Id: <20200116164300.6705-33-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit e231c6d47cca4b5df51bcf72dec1af767e63feaf ]

CPU clocks have been added to AP806-quad but not to the -dual
variant.

Fixes: c00bc38354cf ("arm64: dts: marvell: Add cpu clock node on Armada 7K/8K")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/marvell/armada-ap806-dual.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/marvell/armada-ap806-dual.dtsi b/arch/arm64/boot/dts/marvell/armada-ap806-dual.dtsi
index 9024a2d9db07..62ae016ee6aa 100644
--- a/arch/arm64/boot/dts/marvell/armada-ap806-dual.dtsi
+++ b/arch/arm64/boot/dts/marvell/armada-ap806-dual.dtsi
@@ -21,6 +21,7 @@
 			reg = <0x000>;
 			enable-method = "psci";
 			#cooling-cells = <2>;
+			clocks = <&cpu_clk 0>;
 		};
 		cpu1: cpu@1 {
 			device_type = "cpu";
@@ -28,6 +29,7 @@
 			reg = <0x001>;
 			enable-method = "psci";
 			#cooling-cells = <2>;
+			clocks = <&cpu_clk 0>;
 		};
 	};
 };
-- 
2.20.1


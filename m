Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAA6413E2E7
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730992AbgAPQ5d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:57:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:44802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387510AbgAPQ5c (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:57:32 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA12D24656;
        Thu, 16 Jan 2020 16:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193852;
        bh=yYct/yvcXDrlEgA0LcQIaaTkGaXswQCQAppwQZKXnE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IfvXmm5gDbIqmNdpdcCtjEDZpFfioCTqpj/iR2eutdW8u50lJggOl18t9O+zRjxGN
         2bA+kOfjMDZ4ec/5w6BIXaEtNioYrCSiSwxsxdVkvdBkZi9PI0aZI1+vxyNw+HwkaV
         GUYnfuMXBKiGiyboTaPNmtl4Mi5g/gEaLrgaoC8A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Biju Das <biju.das@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 103/671] ARM: dts: r8a7743: Remove generic compatible string from iic3
Date:   Thu, 16 Jan 2020 11:45:34 -0500
Message-Id: <20200116165502.8838-103-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165502.8838-1-sashal@kernel.org>
References: <20200116165502.8838-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Biju Das <biju.das@bp.renesas.com>

[ Upstream commit 072b817589b17660ef19c31d89f7b981dbed3fd2 ]

The iic3 block on RZ/G1M does not support automatic transmission, unlike
other R-Car SoC's. So dropping the compatibility with the generic version.

Fixes: f523405f2a22cc0c307 ("ARM: dts: r8a7743: Add IIC cores to dtsi")
Signed-off-by: Biju Das <biju.das@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/r8a7743.dtsi | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/r8a7743.dtsi b/arch/arm/boot/dts/r8a7743.dtsi
index 24715f74ae08..5015e2273d82 100644
--- a/arch/arm/boot/dts/r8a7743.dtsi
+++ b/arch/arm/boot/dts/r8a7743.dtsi
@@ -565,9 +565,7 @@
 			/* doesn't need pinmux */
 			#address-cells = <1>;
 			#size-cells = <0>;
-			compatible = "renesas,iic-r8a7743",
-				     "renesas,rcar-gen2-iic",
-				     "renesas,rmobile-iic";
+			compatible = "renesas,iic-r8a7743";
 			reg = <0 0xe60b0000 0 0x425>;
 			interrupts = <GIC_SPI 173 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&cpg CPG_MOD 926>;
-- 
2.20.1


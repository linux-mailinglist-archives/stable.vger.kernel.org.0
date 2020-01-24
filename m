Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14595147FCC
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731184AbgAXLFL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:05:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:39432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388777AbgAXLFK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:05:10 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5909D2071A;
        Fri, 24 Jan 2020 11:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579863909;
        bh=upFrTLU97Fe8YuYUDwSEKznKb5Hnav+bcCKJucglAa8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Efnt3nnpNdLMWT+L8X3NKkfi+0MEQ+BpKuUpB3Yi9sd5yCVXMFk2BxLtuZYeLw9pP
         v/t58ekXauvkH0XTJzidd1S7BFg+djzOZJUEzgyE9R/gQ2tLSTqBa4XJwBrVhwZ3UE
         JksTFxaqy5Zgy/vbRCBnBsAWWjYNiYd2mdcgh42Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Biju Das <biju.das@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 120/639] ARM: dts: r8a7743: Remove generic compatible string from iic3
Date:   Fri, 24 Jan 2020 10:24:50 +0100
Message-Id: <20200124093102.330284561@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 24715f74ae08c..5015e2273d82f 100644
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




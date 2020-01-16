Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E68E113F3FB
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:47:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389862AbgAPRKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:10:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:47694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389249AbgAPRKL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:10:11 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EEC52081E;
        Thu, 16 Jan 2020 17:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194611;
        bh=PJJRRjvM01qG8A3jR/oqv9cop8TjjfoNmIAu3nk6O+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xe6Z4lUOjJ2u76kK3VCiCR5eUpQq+xuZ7mLUEoHKaU5afGPrVdNoKr6FwzUxlV5SN
         38w6RBamJW4gps98uLRlXuD19C9haT3VW1IItoHlB8zEqPl7NOE5Af2eT/5kJpXVsE
         MOMDdco1sIDEXpGQhZnZmybVAuOm2xfVqVXAm1wE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yoshihiro Kaneko <ykaneko0929@gmail.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 476/671] arm64: dts: renesas: r8a77995: Fix register range of display node
Date:   Thu, 16 Jan 2020 12:01:54 -0500
Message-Id: <20200116170509.12787-213-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yoshihiro Kaneko <ykaneko0929@gmail.com>

[ Upstream commit 56d651e890f3befd616b6962a862f5ffa1a514fa ]

Since the R8A77995 SoC uses DU{0,1}, the range from the base address to
the 0x4000 address is used.
This patch fixed it.

Fixes: 18f1a773e3f9e6d1 ("arm64: dts: renesas: r8a77995: add DU support")
Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r8a77995.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/renesas/r8a77995.dtsi b/arch/arm64/boot/dts/renesas/r8a77995.dtsi
index fe77bc43c447..fb3ecb2c385d 100644
--- a/arch/arm64/boot/dts/renesas/r8a77995.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a77995.dtsi
@@ -938,7 +938,7 @@
 
 		du: display@feb00000 {
 			compatible = "renesas,du-r8a77995";
-			reg = <0 0xfeb00000 0 0x80000>;
+			reg = <0 0xfeb00000 0 0x40000>;
 			interrupts = <GIC_SPI 256 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 268 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&cpg CPG_MOD 724>,
-- 
2.20.1


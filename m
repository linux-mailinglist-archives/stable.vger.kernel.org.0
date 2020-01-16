Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFB2813E06D
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729064AbgAPQng (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:43:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:51132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726785AbgAPQng (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:43:36 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79377208C3;
        Thu, 16 Jan 2020 16:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193015;
        bh=sa5E/tzsppxLkY47m1pt/tdrVso35PLdcOSPFrUAZ48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GmSObJds9TckzT2QuHw15X0ZUO0zfwvIo2OkixqyPuC2yXSHLUKPfuLlYFkXKuQ8R
         2cwdiJUcR7EvDtJnlcJQL7ttuGUP1hUu9dy3B5HR1gVZXW+4zBsUcsP9il13eWZxwN
         rTtOYsCl4BbFXzRfs3k6EaDu91rEj/6dpIA0GiYc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 007/205] arm64: dts: renesas: r8a77970: Fix PWM3
Date:   Thu, 16 Jan 2020 11:39:42 -0500
Message-Id: <20200116164300.6705-7-sashal@kernel.org>
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

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

[ Upstream commit 28a1b34c00dad4be91108369ca25ef8dc8bf850d ]

The pwm3 was incorrectly added with a compatible reference to the
renesas,pwm-r8a7790 (H2) due to a single characther ommision.

Fix the compatible string.

Fixes: de625477c632 ("arm64: dts: renesas: r8a779{7|8}0: add PWM support")
Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Link: https://lore.kernel.org/r/20190912103143.985-1-kieran.bingham+renesas@ideasonboard.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r8a77970.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/renesas/r8a77970.dtsi b/arch/arm64/boot/dts/renesas/r8a77970.dtsi
index 0cd3b376635d..4952981bb6ba 100644
--- a/arch/arm64/boot/dts/renesas/r8a77970.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a77970.dtsi
@@ -652,7 +652,7 @@
 		};
 
 		pwm3: pwm@e6e33000 {
-			compatible = "renesas,pwm-r8a7790", "renesas,pwm-rcar";
+			compatible = "renesas,pwm-r8a77970", "renesas,pwm-rcar";
 			reg = <0 0xe6e33000 0 8>;
 			#pwm-cells = <2>;
 			clocks = <&cpg CPG_MOD 523>;
-- 
2.20.1


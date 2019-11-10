Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8074EF639B
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 03:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729898AbfKJCvI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:51:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:35420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729895AbfKJCvI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:51:08 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E826B22795;
        Sun, 10 Nov 2019 02:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573354267;
        bh=zwiB0jeC03ZgwzHt91IsT3P3zsTUgNluiRma6fPjWNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E7FpubvNag9L0wdlsI0tUtLtxNGgJTSnOVPOzXQz55ATaeq9UwoZVu9UEU9mprHUd
         sxTNBFtFWh+iGLL+FoNCzGUm1MlEfP6KaJe6aWxvF85M3m8NE+R+2MF/K/L/GwqLUM
         Y2VpjQlPOXOGPUAc8vWr5Vx1nzPTybxZ0x/HMJIU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 16/40] ARM: dts: ux500: Correct SCU unit address
Date:   Sat,  9 Nov 2019 21:50:08 -0500
Message-Id: <20191110025032.827-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110025032.827-1-sashal@kernel.org>
References: <20191110025032.827-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 2f217d24ecaec2012e628d21e244eef0608656a4 ]

The unit address of the Cortex-A9 SCU device node contains one zero too
many.  Remove it.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ste-dbx5x0.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/ste-dbx5x0.dtsi b/arch/arm/boot/dts/ste-dbx5x0.dtsi
index 50f5e9d092038..86bd320057a38 100644
--- a/arch/arm/boot/dts/ste-dbx5x0.dtsi
+++ b/arch/arm/boot/dts/ste-dbx5x0.dtsi
@@ -186,7 +186,7 @@
 			      <0xa0410100 0x100>;
 		};
 
-		scu@a04100000 {
+		scu@a0410000 {
 			compatible = "arm,cortex-a9-scu";
 			reg = <0xa0410000 0x100>;
 		};
-- 
2.20.1


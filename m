Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B22813F7AD
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:13:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733311AbgAPQ47 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:56:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:43664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733307AbgAPQ45 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:56:57 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29AF52467E;
        Thu, 16 Jan 2020 16:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193817;
        bh=o9D02xT1OERTo13eksDUa5Rx6rszZDH9yPUsA+RIBYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pQwnD516Ug8e6PtVP1gsQnBta7eDMZKBWY3j4ar0jQADGCMZkn/1e0lXc68PZeEdX
         8SEOfZPwUYMnan4AIPHC7VPbmR7ssbtCNyM8pgoJkKh/8hXIzlbY7W8Ht9s2uM6XGP
         LSgdGRDP2W0ZLrq4gNtjH36qv+IemmwVPnR2xWSQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 077/671] pinctrl: sh-pfc: r8a77995: Remove bogus SEL_PWM[0-3]_3 configurations
Date:   Thu, 16 Jan 2020 11:45:08 -0500
Message-Id: <20200116165502.8838-77-sashal@kernel.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit e28dc3f09c9d2555a9bd982f0847988591052226 ]

While the SEL_PWM[0-3] fields in the Module Select Register 0 support 4
possible configurations per PWM pin, only the first 3 are valid.

Replace the invalid and unused configurations for SEL_PWM[0-3]_3 by
dummies.

Fixes: 794a6711764658a1 ("pinctrl: sh-pfc: Initial R8A77995 PFC support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sh-pfc/pfc-r8a77995.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/sh-pfc/pfc-r8a77995.c b/drivers/pinctrl/sh-pfc/pfc-r8a77995.c
index adade5b7ffbc..337c80bde8f9 100644
--- a/drivers/pinctrl/sh-pfc/pfc-r8a77995.c
+++ b/drivers/pinctrl/sh-pfc/pfc-r8a77995.c
@@ -391,10 +391,10 @@ FM(IP12_31_28)	IP12_31_28 \
 #define MOD_SEL0_27		FM(SEL_MSIOF3_0)	FM(SEL_MSIOF3_1)
 #define MOD_SEL0_26		FM(SEL_HSCIF3_0)	FM(SEL_HSCIF3_1)
 #define MOD_SEL0_25		FM(SEL_SCIF4_0)		FM(SEL_SCIF4_1)
-#define MOD_SEL0_24_23		FM(SEL_PWM0_0)		FM(SEL_PWM0_1)		FM(SEL_PWM0_2)		FM(SEL_PWM0_3)
-#define MOD_SEL0_22_21		FM(SEL_PWM1_0)		FM(SEL_PWM1_1)		FM(SEL_PWM1_2)		FM(SEL_PWM1_3)
-#define MOD_SEL0_20_19		FM(SEL_PWM2_0)		FM(SEL_PWM2_1)		FM(SEL_PWM2_2)		FM(SEL_PWM2_3)
-#define MOD_SEL0_18_17		FM(SEL_PWM3_0)		FM(SEL_PWM3_1)		FM(SEL_PWM3_2)		FM(SEL_PWM3_3)
+#define MOD_SEL0_24_23		FM(SEL_PWM0_0)		FM(SEL_PWM0_1)		FM(SEL_PWM0_2)		F_(0, 0)
+#define MOD_SEL0_22_21		FM(SEL_PWM1_0)		FM(SEL_PWM1_1)		FM(SEL_PWM1_2)		F_(0, 0)
+#define MOD_SEL0_20_19		FM(SEL_PWM2_0)		FM(SEL_PWM2_1)		FM(SEL_PWM2_2)		F_(0, 0)
+#define MOD_SEL0_18_17		FM(SEL_PWM3_0)		FM(SEL_PWM3_1)		FM(SEL_PWM3_2)		F_(0, 0)
 #define MOD_SEL0_15		FM(SEL_IRQ_0_0)		FM(SEL_IRQ_0_1)
 #define MOD_SEL0_14		FM(SEL_IRQ_1_0)		FM(SEL_IRQ_1_1)
 #define MOD_SEL0_13		FM(SEL_IRQ_2_0)		FM(SEL_IRQ_2_1)
-- 
2.20.1


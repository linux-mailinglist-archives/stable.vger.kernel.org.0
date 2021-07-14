Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8E593C8FDE
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240505AbhGNTxa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:53:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:45124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240584AbhGNTty (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:49:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E0816143A;
        Wed, 14 Jul 2021 19:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291940;
        bh=3SXRqq5v7xjDEso32NNPYcnEN+DUJCLWJL65j8bmld4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X2MNg+XDxCVMrXluo5UFzrMpxr8DGzbUDuIAWsOH8IJvh1jP/EwX2K3uNavjqq7lY
         kmy1fPQpMxjyYK/0BOtbD99unWmKIZk65HOZf3WKItxvSHeDuabqsn/IRiprf6J0cH
         3Gcr3/oGXSbnG8Fr9eALiCjt1XhBjFCwBvVNp+svrUnhuQ9fNH968WaW5gToC0KN7X
         lztcP8kWrxqRxDxlANO3B7vF1wTshT/BSHeZvaGUF9J1sLMyKBHvyU3Q02j1yxsBo4
         Jpqfgb/hfqBD5V2E7DdqDqGmw8H86vR6lJ6kBFYkVC92DbpAb1JuRwJwtA7vWbTQB+
         ZGYVZXKz3YP0Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 18/51] ARM: dts: imx25-pinfunc: Fix gpio function name for pads GPIO_[A-F]
Date:   Wed, 14 Jul 2021 15:44:40 -0400
Message-Id: <20210714194513.54827-18-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194513.54827-1-sashal@kernel.org>
References: <20210714194513.54827-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit e0cdd26af8eb9001689a4cde4f72c61c1c4b06be ]

The pinfunc definitions used GPIO_A as function instead of GPIO_1_0 as
done for all the other pins with GPIO functionality. Fix for consistency.

There are no mainline users that needs adaption.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx25-pinfunc.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/imx25-pinfunc.h b/arch/arm/boot/dts/imx25-pinfunc.h
index f4516ccf2c1a..1e03b0f9b954 100644
--- a/arch/arm/boot/dts/imx25-pinfunc.h
+++ b/arch/arm/boot/dts/imx25-pinfunc.h
@@ -544,31 +544,31 @@
 #define MX25_PAD_DE_B__DE_B			0x1f0 0x3ec 0x000 0x00 0x000
 #define MX25_PAD_DE_B__GPIO_2_20		0x1f0 0x3ec 0x000 0x05 0x000
 
-#define MX25_PAD_GPIO_A__GPIO_A			0x1f4 0x3f0 0x000 0x00 0x000
+#define MX25_PAD_GPIO_A__GPIO_1_0		0x1f4 0x3f0 0x000 0x00 0x000
 #define MX25_PAD_GPIO_A__CAN1_TX		0x1f4 0x3f0 0x000 0x06 0x000
 #define MX25_PAD_GPIO_A__USBOTG_PWR		0x1f4 0x3f0 0x000 0x02 0x000
 
-#define MX25_PAD_GPIO_B__GPIO_B			0x1f8 0x3f4 0x000 0x00 0x000
+#define MX25_PAD_GPIO_B__GPIO_1_1		0x1f8 0x3f4 0x000 0x00 0x000
 #define MX25_PAD_GPIO_B__USBOTG_OC		0x1f8 0x3f4 0x57c 0x02 0x001
 #define MX25_PAD_GPIO_B__CAN1_RX		0x1f8 0x3f4 0x480 0x06 0x001
 
-#define MX25_PAD_GPIO_C__GPIO_C			0x1fc 0x3f8 0x000 0x00 0x000
+#define MX25_PAD_GPIO_C__GPIO_1_2		0x1fc 0x3f8 0x000 0x00 0x000
 #define MX25_PAD_GPIO_C__PWM4_PWMO		0x1fc 0x3f8 0x000 0x01 0x000
 #define MX25_PAD_GPIO_C__I2C2_SCL		0x1fc 0x3f8 0x51c 0x02 0x001
 #define MX25_PAD_GPIO_C__KPP_COL4		0x1fc 0x3f8 0x52c 0x03 0x001
 #define MX25_PAD_GPIO_C__CAN2_TX		0x1fc 0x3f8 0x000 0x06 0x000
 
-#define MX25_PAD_GPIO_D__GPIO_D			0x200 0x3fc 0x000 0x00 0x000
+#define MX25_PAD_GPIO_D__GPIO_1_3		0x200 0x3fc 0x000 0x00 0x000
 #define MX25_PAD_GPIO_D__I2C2_SDA		0x200 0x3fc 0x520 0x02 0x001
 #define MX25_PAD_GPIO_D__CAN2_RX		0x200 0x3fc 0x484 0x06 0x001
 
-#define MX25_PAD_GPIO_E__GPIO_E			0x204 0x400 0x000 0x00 0x000
+#define MX25_PAD_GPIO_E__GPIO_1_4		0x204 0x400 0x000 0x00 0x000
 #define MX25_PAD_GPIO_E__I2C3_CLK		0x204 0x400 0x524 0x01 0x002
 #define MX25_PAD_GPIO_E__LD16			0x204 0x400 0x000 0x02 0x000
 #define MX25_PAD_GPIO_E__AUD7_TXD		0x204 0x400 0x000 0x04 0x000
 #define MX25_PAD_GPIO_E__UART4_RXD		0x204 0x400 0x570 0x06 0x002
 
-#define MX25_PAD_GPIO_F__GPIO_F			0x208 0x404 0x000 0x00 0x000
+#define MX25_PAD_GPIO_F__GPIO_1_5		0x208 0x404 0x000 0x00 0x000
 #define MX25_PAD_GPIO_F__LD17			0x208 0x404 0x000 0x02 0x000
 #define MX25_PAD_GPIO_F__AUD7_TXC		0x208 0x404 0x000 0x04 0x000
 #define MX25_PAD_GPIO_F__UART4_TXD		0x208 0x404 0x000 0x06 0x000
-- 
2.30.2


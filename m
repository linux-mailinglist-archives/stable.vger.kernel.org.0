Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49FB618A449
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 21:53:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgCRUx1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 16:53:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:52332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726619AbgCRUx1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Mar 2020 16:53:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5756A208CA;
        Wed, 18 Mar 2020 20:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564807;
        bh=uXDGNLCrGr2jksJkSRoXf3F08iWPTsL4n2XmsDF9I/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0W9CW62ntiqX8cgol8Qxem+r5dXRH0vznfEjueJGnwGl350RNS282Lu/5MRlcU/Ge
         2o+ybnVieaU0hDLHF5/LPHSejKRh2PZAStmLngJppFhkZiRUAkPr7n0lJ2Th5YW5PY
         mZz2uKsPnIhX/IyKflu851bz9By+hfgP0rgIrRTc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anson Huang <Anson.Huang@nxp.com>, Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.5 04/84] clk: imx8mn: Fix incorrect clock defines
Date:   Wed, 18 Mar 2020 16:52:01 -0400
Message-Id: <20200318205321.16066-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200318205321.16066-1-sashal@kernel.org>
References: <20200318205321.16066-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anson Huang <Anson.Huang@nxp.com>

[ Upstream commit 5eb40257047fb11085d582b7b9ccd0bffe900726 ]

IMX8MN_CLK_I2C4 and IMX8MN_CLK_UART1's index definitions are incorrect,
fix them.

Fixes: 1e80936a42e1 ("dt-bindings: imx: Add clock binding doc for i.MX8MN")
Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/dt-bindings/clock/imx8mn-clock.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/dt-bindings/clock/imx8mn-clock.h b/include/dt-bindings/clock/imx8mn-clock.h
index 0f2b8423ce1d1..65ac6eb6c7330 100644
--- a/include/dt-bindings/clock/imx8mn-clock.h
+++ b/include/dt-bindings/clock/imx8mn-clock.h
@@ -122,8 +122,8 @@
 #define IMX8MN_CLK_I2C1				105
 #define IMX8MN_CLK_I2C2				106
 #define IMX8MN_CLK_I2C3				107
-#define IMX8MN_CLK_I2C4				118
-#define IMX8MN_CLK_UART1			119
+#define IMX8MN_CLK_I2C4				108
+#define IMX8MN_CLK_UART1			109
 #define IMX8MN_CLK_UART2			110
 #define IMX8MN_CLK_UART3			111
 #define IMX8MN_CLK_UART4			112
-- 
2.20.1


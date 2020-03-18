Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B95C818A6A7
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 22:09:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727632AbgCRVJo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 17:09:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:52752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727241AbgCRUxl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Mar 2020 16:53:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CBD7208FE;
        Wed, 18 Mar 2020 20:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564821;
        bh=5uS4a+5EJm4CyeOijDRc8Zh+DisVODdHPSDxweM/j/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=toAxLGlztpQESogpAkn7ob0DdNkvY3Yz0uYUGSAMKb+XuufPDWpskNzwKuwWTFVcZ
         8OlCHqqxERTVhpOHJHH1Wjhhf5+fOw5NLlPf4QtMaGi+7fuooPpnJ2cDwshfHO+2Jp
         t8/uSKhyil4necfKWXxl8O2TN4IHxhDpJT3p4gTI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anson Huang <Anson.Huang@nxp.com>, Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 03/73] clk: imx8mn: Fix incorrect clock defines
Date:   Wed, 18 Mar 2020 16:52:27 -0400
Message-Id: <20200318205337.16279-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200318205337.16279-1-sashal@kernel.org>
References: <20200318205337.16279-1-sashal@kernel.org>
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
index d7b201652f4cd..0c7c750fc2c41 100644
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


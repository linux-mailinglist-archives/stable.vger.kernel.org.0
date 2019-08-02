Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98C617F8AE
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 15:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393601AbfHBNVm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 09:21:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:60196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729866AbfHBNVm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 09:21:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D3862173E;
        Fri,  2 Aug 2019 13:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564752101;
        bh=o3wy5nRhYLcAi7lP2oNchUBAb7gBx8iqR6nIER7hnXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ENDeIjx/AufWvzT6xj39MfOZdYby+aRZiRU4Ap6elgBYkAtVIpuc/QpJSEpIt4enO
         qvid6m7y6iRT8d4QKyS+rV9Cw7G8iugmNiHPwgm1ZWzUY9Uon8QAoohLkubfuAshtC
         jtq55+iudaYCbqOvProZ2M5B7D+X9zle3jzlBzE8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anson Huang <Anson.Huang@nxp.com>, Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 44/76] arm64: dts: imx8mm: Correct SAI3 RXC/TXFS pin's mux option #1
Date:   Fri,  2 Aug 2019 09:19:18 -0400
Message-Id: <20190802131951.11600-44-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190802131951.11600-1-sashal@kernel.org>
References: <20190802131951.11600-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anson Huang <Anson.Huang@nxp.com>

[ Upstream commit 52d09014bb104a9157c0f5530700291052d2955c ]

According to i.MX8MM reference manual Rev.1, 03/2019:

SAI3_RXC pin's mux option #1 should be GPT1_CLK, NOT GPT1_CAPTURE2;
SAI3_TXFS pin's mux option #1 should be GPT1_CAPTURE2, NOT GPT1_CLK.

Fixes: c1c9d41319c3 ("dt-bindings: imx: Add pinctrl binding doc for imx8mm")
Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-pinfunc.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-pinfunc.h b/arch/arm64/boot/dts/freescale/imx8mm-pinfunc.h
index e25f7fcd79975..cffa8991880d1 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-pinfunc.h
+++ b/arch/arm64/boot/dts/freescale/imx8mm-pinfunc.h
@@ -462,7 +462,7 @@
 #define MX8MM_IOMUXC_SAI3_RXFS_GPIO4_IO28                                   0x1CC 0x434 0x000 0x5 0x0
 #define MX8MM_IOMUXC_SAI3_RXFS_TPSMP_HTRANS0                                0x1CC 0x434 0x000 0x7 0x0
 #define MX8MM_IOMUXC_SAI3_RXC_SAI3_RX_BCLK                                  0x1D0 0x438 0x000 0x0 0x0
-#define MX8MM_IOMUXC_SAI3_RXC_GPT1_CAPTURE2                                 0x1D0 0x438 0x000 0x1 0x0
+#define MX8MM_IOMUXC_SAI3_RXC_GPT1_CLK                                      0x1D0 0x438 0x000 0x1 0x0
 #define MX8MM_IOMUXC_SAI3_RXC_SAI5_RX_BCLK                                  0x1D0 0x438 0x4D0 0x2 0x2
 #define MX8MM_IOMUXC_SAI3_RXC_GPIO4_IO29                                    0x1D0 0x438 0x000 0x5 0x0
 #define MX8MM_IOMUXC_SAI3_RXC_TPSMP_HTRANS1                                 0x1D0 0x438 0x000 0x7 0x0
@@ -472,7 +472,7 @@
 #define MX8MM_IOMUXC_SAI3_RXD_GPIO4_IO30                                    0x1D4 0x43C 0x000 0x5 0x0
 #define MX8MM_IOMUXC_SAI3_RXD_TPSMP_HDATA0                                  0x1D4 0x43C 0x000 0x7 0x0
 #define MX8MM_IOMUXC_SAI3_TXFS_SAI3_TX_SYNC                                 0x1D8 0x440 0x000 0x0 0x0
-#define MX8MM_IOMUXC_SAI3_TXFS_GPT1_CLK                                     0x1D8 0x440 0x000 0x1 0x0
+#define MX8MM_IOMUXC_SAI3_TXFS_GPT1_CAPTURE2                                0x1D8 0x440 0x000 0x1 0x0
 #define MX8MM_IOMUXC_SAI3_TXFS_SAI5_RX_DATA1                                0x1D8 0x440 0x4D8 0x2 0x2
 #define MX8MM_IOMUXC_SAI3_TXFS_GPIO4_IO31                                   0x1D8 0x440 0x000 0x5 0x0
 #define MX8MM_IOMUXC_SAI3_TXFS_TPSMP_HDATA1                                 0x1D8 0x440 0x000 0x7 0x0
-- 
2.20.1


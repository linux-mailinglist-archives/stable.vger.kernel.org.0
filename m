Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4F718D941
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729742AbfHNRGv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:06:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:56062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729743AbfHNRGu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:06:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74C362173B;
        Wed, 14 Aug 2019 17:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802409;
        bh=zAJIPmjoCYWSGafJerE0GQskZKt2BcTJxwk8jxxgqyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U7N99X8xJKJtromylpThjigC2FqobTzh1SYk5iwsa1F4Yjsuy/IJpVuCSc9HOsW6H
         /y8ELEB4XgaWYvsrkxXOwZ3GKr5sYbwpYeGxpg/CqLKE+7Kq6BGb23kDIEaGEQbjw6
         hrXEcxLdTuCaltG1+OTAGxNXej4jIWEdcXduzeVg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anson Huang <Anson.Huang@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 088/144] arm64: dts: imx8mm: Correct SAI3 RXC/TXFS pins mux option #1
Date:   Wed, 14 Aug 2019 19:00:44 +0200
Message-Id: <20190814165803.557924318@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165759.466811854@linuxfoundation.org>
References: <20190814165759.466811854@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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




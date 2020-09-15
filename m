Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD2B26B52B
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgIOXjG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:39:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:48030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727132AbgIOOfX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:35:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 577AF20872;
        Tue, 15 Sep 2020 14:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179933;
        bh=mdvMzpxIHZHLEMxXayHzGtPNZw6xii9wJqUXcGFTS5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qVOS1mW+Cr5SVxKf46arzaiwCD1VkqIA4oZsXMLNHvzECMjU7k98Ig7hv9mhwXCPl
         kcSjaxlTMYaHwLSB6LA3JetjKEf7tf6wERNoHBdobKyqbyxaMoMPFJ4le2WNmqcO3Y
         U7LO3y9WI1YAnXZmzZxnIlEdCVT8Ltyq8qU88onI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fugang Duan <fugang.duan@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 042/177] ARM: dts: imx6sx: fix the pad QSPI1B_SCLK mux mode for uart3
Date:   Tue, 15 Sep 2020 16:11:53 +0200
Message-Id: <20200915140655.654566535@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

[ Upstream commit 3ee99f6a2379eca87ab11122b7e9abd68f3441e2 ]

The pad QSPI1B_SCLK mux mode 0x1 is for function UART3_DTE_TX,
correct the mux mode.

Fixes: 743636f25f1d ("ARM: dts: imx: add pin function header for imx6sx")
Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6sx-pinfunc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6sx-pinfunc.h b/arch/arm/boot/dts/imx6sx-pinfunc.h
index 0b02c7e60c174..f4dc46207954c 100644
--- a/arch/arm/boot/dts/imx6sx-pinfunc.h
+++ b/arch/arm/boot/dts/imx6sx-pinfunc.h
@@ -1026,7 +1026,7 @@
 #define MX6SX_PAD_QSPI1B_DQS__SIM_M_HADDR_15                      0x01B0 0x04F8 0x0000 0x7 0x0
 #define MX6SX_PAD_QSPI1B_SCLK__QSPI1_B_SCLK                       0x01B4 0x04FC 0x0000 0x0 0x0
 #define MX6SX_PAD_QSPI1B_SCLK__UART3_DCE_RX                       0x01B4 0x04FC 0x0840 0x1 0x4
-#define MX6SX_PAD_QSPI1B_SCLK__UART3_DTE_TX                       0x01B4 0x04FC 0x0000 0x0 0x0
+#define MX6SX_PAD_QSPI1B_SCLK__UART3_DTE_TX                       0x01B4 0x04FC 0x0000 0x1 0x0
 #define MX6SX_PAD_QSPI1B_SCLK__ECSPI3_SCLK                        0x01B4 0x04FC 0x0730 0x2 0x1
 #define MX6SX_PAD_QSPI1B_SCLK__ESAI_RX_HF_CLK                     0x01B4 0x04FC 0x0780 0x3 0x2
 #define MX6SX_PAD_QSPI1B_SCLK__CSI1_DATA_16                       0x01B4 0x04FC 0x06DC 0x4 0x1
-- 
2.25.1




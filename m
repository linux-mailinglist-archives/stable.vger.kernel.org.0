Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3F0F483D
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 12:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390625AbfKHLzf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:55:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:33328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391206AbfKHLpz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:45:55 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47C36222C2;
        Fri,  8 Nov 2019 11:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213555;
        bh=N18+N6OlaSTcc9dJRJHr9msZMDgvNfCMsLX146+55ag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XoodSAsMpaxIe5aTOFmAAWMun+i0rg+0gcKJG03EJfJmnfEbkzmpa6Jpj+OqUtbG7
         0FniE25qlc2hbTFDpKHrvx3Pm2u1KDsSSio1QBbDUKLO5TYWhB9ovSy23AgEE/tMYr
         2zdyEuQI1+MRntCvumzGY8AXqHaP/kqaM1trRQaA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jay Foster <jayfoster@ieee.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 05/64] ARM: dts: at91/trivial: Fix USART1 definition for at91sam9g45
Date:   Fri,  8 Nov 2019 06:44:46 -0500
Message-Id: <20191108114545.15351-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114545.15351-1-sashal@kernel.org>
References: <20191108114545.15351-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jay Foster <jayfoster@ieee.org>

[ Upstream commit 10af10db8c76fa5b9bf1f52a895c1cb2c0ac24da ]

Fix a typo. No functional change made by this patch.

Signed-off-by: Jay Foster <jayfoster@ieee.org>
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/at91sam9g45.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/at91sam9g45.dtsi b/arch/arm/boot/dts/at91sam9g45.dtsi
index b3501ae2a3bd1..4fba898b8f4f9 100644
--- a/arch/arm/boot/dts/at91sam9g45.dtsi
+++ b/arch/arm/boot/dts/at91sam9g45.dtsi
@@ -546,7 +546,7 @@
 					};
 				};
 
-				uart1 {
+				usart1 {
 					pinctrl_usart1: usart1-0 {
 						atmel,pins =
 							<AT91_PIOB 4 AT91_PERIPH_A AT91_PINCTRL_PULL_UP	/* PB4 periph A with pullup */
-- 
2.20.1


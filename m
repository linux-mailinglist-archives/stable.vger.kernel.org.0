Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 172A5106A07
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:31:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbfKVKbQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:31:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:51154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726546AbfKVKbQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:31:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F54F20715;
        Fri, 22 Nov 2019 10:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574418674;
        bh=hjgsGYra9ME33CEuTHD6rBp6RT0p7NsNyjSyCJszLY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qzmaXdSSNgmKhc8hkkBKozuuUViRl1OQ/U7h2CiUMKBSyS4do7ng7+vWuIVvBxeAP
         74gqHjuJ1BuCECi8/4iCCNQOmm4get2J9D5XyFUVvSg4M+TAAZkRwPubEWa88EUmnJ
         rSX4LVRP2IXs6b9lWpFajXJChenjoMN0rmcEhVIk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jay Foster <jayfoster@ieee.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 014/159] ARM: dts: at91/trivial: Fix USART1 definition for at91sam9g45
Date:   Fri, 22 Nov 2019 11:26:45 +0100
Message-Id: <20191122100719.375961994@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100704.194776704@linuxfoundation.org>
References: <20191122100704.194776704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index af8b708ac312a..53a5a0e311e9d 100644
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




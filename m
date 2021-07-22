Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4AC73D286F
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 18:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbhGVP5O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:57:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:33080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230307AbhGVP47 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:56:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 834916135C;
        Thu, 22 Jul 2021 16:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971854;
        bh=oe/kEJZyEkECaWFGfCpBt5qd+LcQB6wCBZyDJmBpiFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2v2HCQf38h4CEfOPVfUI4wK+FA66R/UwIB0eqoXsX/w7O827BJVtcbSfZMonCkst6
         UrO123vQK5VGol3/RKvcFW8renD7D2t2d56gAEAYe+cd0how9W9hoWPl4wG+k8WhGy
         TwvDk7l8HKhjWFdVcjJoxORXPsOmGQHUNFa/txiU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 053/125] ARM: dts: stm32: fix i2c node name on stm32f746 to prevent warnings
Date:   Thu, 22 Jul 2021 18:30:44 +0200
Message-Id: <20210722155626.476712133@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155624.672583740@linuxfoundation.org>
References: <20210722155624.672583740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Torgue <alexandre.torgue@foss.st.com>

[ Upstream commit ad0ed10ba5792064fc3accbf8f0341152a57eecb ]

Replace upper case by lower case in i2c nodes name.

Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32f746.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/stm32f746.dtsi b/arch/arm/boot/dts/stm32f746.dtsi
index 81a6fe653e66..d49e481b3aa6 100644
--- a/arch/arm/boot/dts/stm32f746.dtsi
+++ b/arch/arm/boot/dts/stm32f746.dtsi
@@ -360,9 +360,9 @@
 			status = "disabled";
 		};
 
-		i2c3: i2c@40005C00 {
+		i2c3: i2c@40005c00 {
 			compatible = "st,stm32f7-i2c";
-			reg = <0x40005C00 0x400>;
+			reg = <0x40005c00 0x400>;
 			interrupts = <72>,
 				     <73>;
 			resets = <&rcc STM32F7_APB1_RESET(I2C3)>;
-- 
2.30.2




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AAB7451F1D
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355639AbhKPAih (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:38:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:45386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344406AbhKOTYi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 780A563484;
        Mon, 15 Nov 2021 18:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002627;
        bh=WD3ugRfNYke0/s4xKMlBr/2is5fw7IUeXxKMc000pKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SEJfTc8odHalsekOwiwvL9cVmG9YSjRO6wimcMbrL53ApSWgzfPtoegPUoDam2D98
         7GoPzWd7JtIkOlZcjMIPi2Xvno6nqiWulwthiq/sZwoSO4cybK9VIyevsEtObt+33W
         3UqlIkkKmn0Fns7REfeYRjGhb8Hi/h+Wxxw89R0U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Olivier Moysan <olivier.moysan@foss.st.com>,
        Marek Vasut <marex@denx.de>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 639/917] ARM: dts: stm32: fix AV96 board SAI2 pin muxing on stm32mp15
Date:   Mon, 15 Nov 2021 18:02:14 +0100
Message-Id: <20211115165450.498945108@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olivier Moysan <olivier.moysan@foss.st.com>

[ Upstream commit 1a9a9d226f0f0ef5d9bf588ab432e0d679bb1954 ]

Fix SAI2A and SAI2B pin muxings for AV96 board on STM32MP15.
Change sai2a-4 & sai2a-5 to sai2a-2 & sai2a-2.
Change sai2a-4 & sai2a-sleep-5 to sai2b-2 & sai2b-sleep-2

Fixes: dcf185ca8175 ("ARM: dts: stm32: Add alternate pinmux for SAI2 pins on stm32mp15")

Signed-off-by: Olivier Moysan <olivier.moysan@foss.st.com>
Reviewed-by: Marek Vasut <marex@denx.de>
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp15-pinctrl.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/stm32mp15-pinctrl.dtsi b/arch/arm/boot/dts/stm32mp15-pinctrl.dtsi
index 5b60ecbd718f0..2ebafe27a865b 100644
--- a/arch/arm/boot/dts/stm32mp15-pinctrl.dtsi
+++ b/arch/arm/boot/dts/stm32mp15-pinctrl.dtsi
@@ -1179,7 +1179,7 @@
 		};
 	};
 
-	sai2a_pins_c: sai2a-4 {
+	sai2a_pins_c: sai2a-2 {
 		pins {
 			pinmux = <STM32_PINMUX('D', 13, AF10)>, /* SAI2_SCK_A */
 				 <STM32_PINMUX('D', 11, AF10)>, /* SAI2_SD_A */
@@ -1190,7 +1190,7 @@
 		};
 	};
 
-	sai2a_sleep_pins_c: sai2a-5 {
+	sai2a_sleep_pins_c: sai2a-2 {
 		pins {
 			pinmux = <STM32_PINMUX('D', 13, ANALOG)>, /* SAI2_SCK_A */
 				 <STM32_PINMUX('D', 11, ANALOG)>, /* SAI2_SD_A */
@@ -1235,14 +1235,14 @@
 		};
 	};
 
-	sai2b_pins_c: sai2a-4 {
+	sai2b_pins_c: sai2b-2 {
 		pins1 {
 			pinmux = <STM32_PINMUX('F', 11, AF10)>; /* SAI2_SD_B */
 			bias-disable;
 		};
 	};
 
-	sai2b_sleep_pins_c: sai2a-sleep-5 {
+	sai2b_sleep_pins_c: sai2b-sleep-2 {
 		pins {
 			pinmux = <STM32_PINMUX('F', 11, ANALOG)>; /* SAI2_SD_B */
 		};
-- 
2.33.0




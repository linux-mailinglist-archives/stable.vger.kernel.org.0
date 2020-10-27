Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 051CC29BCB1
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:41:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1811000AbgJ0Qgl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:36:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:45260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1764560AbgJ0PrY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:47:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 172C920575;
        Tue, 27 Oct 2020 15:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813643;
        bh=aGWb6TazCrp4N4kSL+nv/YnlpLXLLZSBY2kRmolS5IY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GEXtvfeAwht0USP4vzuVMY//PtA3B5ZBW/EX2ktY/cutC/lQzvMIymJUXz8w1oGwp
         8s5EAnNT9DKfLautCedIvja3zRrAOteeK7ZFNEguS7NlAjg5Va2ARMsfHJ/CiqmrOc
         t3dqB/GN+zGTXI8Sh1AWzVWMZjwsOLmYrTxcR7n8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Patrick Delaunay <patrick.delaunay@st.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 622/757] ARM: dts: stm32: Fix DH PDK2 display PWM channel
Date:   Tue, 27 Oct 2020 14:54:32 +0100
Message-Id: <20201027135519.720566569@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit 57592d2a98dbc3bde3ddc062e91a8486bdcb211e ]

The display PWM channel is number 3 (PWM2 CH4), make it so.

Fixes: 34e0c7847dcf ("ARM: dts: stm32: Add DH Electronics DHCOM STM32MP1 SoM and PDK2 board")
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Patrice Chotard <patrice.chotard@st.com>
Cc: Patrick Delaunay <patrick.delaunay@st.com>
Cc: linux-stm32@st-md-mailman.stormreply.com
To: linux-arm-kernel@lists.infradead.org
Signed-off-by: Alexandre Torgue <alexandre.torgue@st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi b/arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi
index 9cf6d90fbf69f..e4e3c92eb30d3 100644
--- a/arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xx-dhcom-pdk2.dtsi
@@ -25,7 +25,7 @@ clk_ext_audio_codec: clock-codec {
 
 	display_bl: display-bl {
 		compatible = "pwm-backlight";
-		pwms = <&pwm2 0 500000 PWM_POLARITY_INVERTED>;
+		pwms = <&pwm2 3 500000 PWM_POLARITY_INVERTED>;
 		brightness-levels = <0 16 22 30 40 55 75 102 138 188 255>;
 		default-brightness-level = <8>;
 		enable-gpios = <&gpioi 0 GPIO_ACTIVE_HIGH>;
-- 
2.25.1




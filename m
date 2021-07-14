Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4223C8F7A
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238270AbhGNTwk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:52:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:46242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239896AbhGNTt1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:49:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9099D613DA;
        Wed, 14 Jul 2021 19:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291874;
        bh=6ieHKvphwhmfwt8amToFbVb304Q+ZqQq8HyMAHggoFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OhnXHaJstg6BKQGq5lXLrmpZDmw2J/A4xcwl7nJn+Iq5XscTpOUSoQG7WhbGIEpCz
         bo+1/KSCV3Xs1PzNJF+QdZGWbpT5vK0r2f8J73qexz2GZVOpCnTk8ulz5MGI0nk+tI
         Xo39RhQN+syEY9yc5pHzDz7N2hpxYdtncMj0oLVISUZ7gabStANWvWYRxWQViGjJrr
         y/fj7QeXhch6HCTlpD1WmKY/Rtc6Hz8GrLf6QD8T6yRv0do2ekkE/sSwxY8KU/d47t
         WEWG256UAdRKQhrOgOXftoAnavCCqu/XFdk6dqLBuLHRRYkx+zcmOtNspfVZkz0cMW
         Bwp+Ige/Oy5VQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 60/88] ARM: dts: stm32: fix i2c node name on stm32f746 to prevent warnings
Date:   Wed, 14 Jul 2021 15:42:35 -0400
Message-Id: <20210714194303.54028-60-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194303.54028-1-sashal@kernel.org>
References: <20210714194303.54028-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
@@ -360,9 +360,9 @@ i2c2: i2c@40005800 {
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


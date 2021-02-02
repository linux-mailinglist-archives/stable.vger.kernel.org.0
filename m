Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 283AC30C038
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 14:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233125AbhBBNvo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 08:51:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:38220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232951AbhBBNuH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:50:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FC7C64FAF;
        Tue,  2 Feb 2021 13:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273375;
        bh=LM2qWff60IMJo1OJvVAJsJAhFaxjYTrsSw9J23a4p8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SeedF9ABJD1qIyigcxrJbWLgpB6XJC/qVuWRzJIwgapTvhYQeht0smWumsfR4TxQM
         heROIo7mdOuUjhCuQl24kfHObaOVXanhocaT1SeIq2FLLKCIjjxbrFjWLHUaNGkaKZ
         OUmh9iOh/xVnH0uzGpwJyT/CWlmgjMjUWk/Ux/vw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marco Felsch <m.felsch@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 084/142] ARM: dts: imx6qdl-kontron-samx6i: fix i2c_lcd/cam default status
Date:   Tue,  2 Feb 2021 14:37:27 +0100
Message-Id: <20210202133001.179285574@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Felsch <m.felsch@pengutronix.de>

[ Upstream commit 70b6ff4c549a62b59b286445f66cfec6c5327ac8 ]

Fix typo so the gpio i2c busses are really disabled.

Fixes: 2125212785c9 ("ARM: dts: imx6qdl-kontron-samx6i: add Kontron SMARC SoM Support")
Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi b/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
index f486d6d8fb4a7..92f9977d14822 100644
--- a/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
@@ -167,7 +167,7 @@
 		i2c-gpio,delay-us = <2>; /* ~100 kHz */
 		#address-cells = <1>;
 		#size-cells = <0>;
-		status = "disabld";
+		status = "disabled";
 	};
 
 	i2c_cam: i2c-gpio-cam {
@@ -179,7 +179,7 @@
 		i2c-gpio,delay-us = <2>; /* ~100 kHz */
 		#address-cells = <1>;
 		#size-cells = <0>;
-		status = "disabld";
+		status = "disabled";
 	};
 };
 
-- 
2.27.0




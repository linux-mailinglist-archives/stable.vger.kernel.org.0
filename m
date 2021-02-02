Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC0B030CC9D
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 21:04:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240243AbhBBUBr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 15:01:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:36462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232840AbhBBNrT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:47:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 42B6F64F8E;
        Tue,  2 Feb 2021 13:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273306;
        bh=OPMirwcJRJZW/Bua4zf6RPbMZuNcRRkZXO0XSGE8MT4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q+A9vmPlHF75PI77BoeQBcBpgtekTXffn4mDYK21LOu331ik2Rm3ggBs2rZX8zHeo
         n+Oq4Nv5ASNMVsc+NZrQyV3Nzh6TxScngpAaPXGKHuBhDxAqBrhDFZ7Rl4DtsglTjQ
         VduOWiH3/wpIyO9ushwCJvx2Zgv0+Pld24uto0ws=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marco Felsch <m.felsch@pengutronix.de>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.10 058/142] ARM: dts: imx6qdl-kontron-samx6i: fix pwms for lcd-backlight
Date:   Tue,  2 Feb 2021 14:37:01 +0100
Message-Id: <20210202133000.113854696@linuxfoundation.org>
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

commit 6337c2353a069b6f1276dc35421e421ef6c1ead9 upstream.

The pwms property have to specify the no-/inverted flag since
commit fa28d8212ede ("ARM: dts: imx: default to #pwm-cells = <3>
in the SoC dtsi files").

Fixes: fa28d8212ede ("ARM: dts: imx: default to #pwm-cells = <3> in the SoC dtsi files")
Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
@@ -137,7 +137,7 @@
 
 	lcd_backlight: lcd-backlight {
 		compatible = "pwm-backlight";
-		pwms = <&pwm4 0 5000000>;
+		pwms = <&pwm4 0 5000000 0>;
 		pwm-names = "LCD_BKLT_PWM";
 
 		brightness-levels = <0 10 20 30 40 50 60 70 80 90 100>;



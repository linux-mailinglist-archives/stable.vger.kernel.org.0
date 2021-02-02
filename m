Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 755B230C0A1
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 15:05:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233450AbhBBODI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 09:03:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:46344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233572AbhBBOBk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:01:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55D5464FFF;
        Tue,  2 Feb 2021 13:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273642;
        bh=KY7YeEnxEBtC4EUEsySrq3CSASrYZ38Ye6dhoc+QzzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ni5zpDeJ2ecwYGeD09m5XhzELpB5NzONMvm5nul2Wj/jTKbvA6sbobiHm18TVrFwQ
         hm3TlDNkRSpgSfzqvLuvmU8rlIIFJbCvmR0xXlKegvO7eBn3V/1HIHNR2Rj6Ifu0O+
         JnkvzHFT33v/x8u9CqFD1cIP3uKsjC/rr3U39PPI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marco Felsch <m.felsch@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 38/61] ARM: dts: imx6qdl-kontron-samx6i: fix i2c_lcd/cam default status
Date:   Tue,  2 Feb 2021 14:38:16 +0100
Message-Id: <20210202132948.075878679@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132946.480479453@linuxfoundation.org>
References: <20210202132946.480479453@linuxfoundation.org>
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
index 6acc8591219a7..eea317b41020d 100644
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




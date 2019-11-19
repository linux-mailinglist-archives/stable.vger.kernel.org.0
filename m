Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8E510172F
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731533AbfKSFtq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:49:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:46660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731526AbfKSFtq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:49:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBA3B20721;
        Tue, 19 Nov 2019 05:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142585;
        bh=wI0Y7z5AHDqJ+AST5CMYwQhdap/yK+byxdopLPwAtqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J9W2o8nQ/sX4UFlmE91+MuAgES4lhsAWQj4V4S6xHDc8SYGgDSm84UaC99utxQGbk
         NsvZk9N/Ey3LPOnNnx09bxFHa0Qa3WERIQvnL+fA1fUIJy0PRJqrjEjI8QbwuVlFJw
         OZon1UPGJ4qqI6gyqCZbsMn1ECxGXS120J8P2aio=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "H. Nikolaus Schaller" <hns@goldelico.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 081/239] ARM: dts: omap3-gta04: keep vpll2 always on
Date:   Tue, 19 Nov 2019 06:18:01 +0100
Message-Id: <20191119051315.368896635@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: H. Nikolaus Schaller <hns@goldelico.com>

[ Upstream commit 1ae00833e30c9b4af5cbfda65d75b1de12f74013 ]

This is needed to make the display and venc work properly.
Compare to omap3-beagle.dts.

Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/omap3-gta04.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/omap3-gta04.dtsi b/arch/arm/boot/dts/omap3-gta04.dtsi
index 7992489b953e8..e83d0619b3b7c 100644
--- a/arch/arm/boot/dts/omap3-gta04.dtsi
+++ b/arch/arm/boot/dts/omap3-gta04.dtsi
@@ -537,6 +537,12 @@
 	regulator-max-microvolt = <3150000>;
 };
 
+/* Needed to power the DPI pins */
+
+&vpll2 {
+	regulator-always-on;
+};
+
 &dss {
 	pinctrl-names = "default";
 	pinctrl-0 = < &dss_dpi_pins >;
-- 
2.20.1




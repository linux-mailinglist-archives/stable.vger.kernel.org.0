Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11B5C10187B
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:08:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbfKSGIJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 01:08:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:51206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727880AbfKSFbo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:31:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E955621939;
        Tue, 19 Nov 2019 05:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141504;
        bh=eeTc2pfq9EWlG+BdGFAxdNrRoZjrMQ6OknzkJeh0Dh4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gu6Ka1tmSZSySkUP3QLdhP3ruUaIBMVparin8nPph1MMqR5RVzAPd2acFQrujqH8x
         cyCX2761sKFaejy5bJJ/+c3rvqYa5QSHWuhEHNWoVuT0MO8hdDzeYf9XxAOmLGzQeg
         Km1rtgxwU+Be+OuwNp42fM1UtiMdi9Yd2XvBySLM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "H. Nikolaus Schaller" <hns@goldelico.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 143/422] ARM: dts: omap3-gta04: keep vpll2 always on
Date:   Tue, 19 Nov 2019 06:15:40 +0100
Message-Id: <20191119051408.001044886@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
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
index bb435684500fc..0c39a2340030b 100644
--- a/arch/arm/boot/dts/omap3-gta04.dtsi
+++ b/arch/arm/boot/dts/omap3-gta04.dtsi
@@ -548,6 +548,12 @@
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




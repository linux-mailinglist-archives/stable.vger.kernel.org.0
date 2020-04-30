Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5791BF9F8
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 15:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726782AbgD3Nuq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 09:50:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:58254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726770AbgD3Nuq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 09:50:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 195B920774;
        Thu, 30 Apr 2020 13:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254646;
        bh=2S1FFwLlLxdFqit01Fd6EhlCpN6yg+s+wXPuB7KRNn4=;
        h=From:To:Cc:Subject:Date:From;
        b=kLhbRl26lw1Z/P+DYHCiDnSDJrSETSE+1xlBtTuhMPFMUcPsUttJSyjNp4zvO3Dng
         oY1M20VK1P5RyPWWT7970wzG6X6fMfp0Us+Op47Cc0VpDzp0ZbLPHB8bVRiVNsTA0W
         CNqA78hjG+XazcT9ZAFg/8ilgQv9h1JDvcvYawBk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aaro Koskinen <aaro.koskinen@iki.fi>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.6 01/79] ARM: dts: OMAP3: disable RNG on N950/N9
Date:   Thu, 30 Apr 2020 09:49:25 -0400
Message-Id: <20200430135043.19851-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aaro Koskinen <aaro.koskinen@iki.fi>

[ Upstream commit 07bdc492cff6f555538df95e9812fe72e16d154a ]

Like on N900, we cannot access RNG directly on N950/N9. Mark it disabled in
the DTS to allow kernel to boot.

Fixes: 308607e5545f ("ARM: dts: Configure omap3 rng")
Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/omap3-n950-n9.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/omap3-n950-n9.dtsi b/arch/arm/boot/dts/omap3-n950-n9.dtsi
index a075b63f3087d..11d41e86f814d 100644
--- a/arch/arm/boot/dts/omap3-n950-n9.dtsi
+++ b/arch/arm/boot/dts/omap3-n950-n9.dtsi
@@ -341,6 +341,11 @@
 	status = "disabled";
 };
 
+/* RNG not directly accessible on N950/N9. */
+&rng_target {
+	status = "disabled";
+};
+
 &usb_otg_hs {
 	interface-type = <0>;
 	usb-phy = <&usb2_phy>;
-- 
2.20.1


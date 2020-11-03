Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A76DD2A38F9
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 02:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727618AbgKCBWI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 20:22:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:36542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728347AbgKCBVL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Nov 2020 20:21:11 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07F8E2242E;
        Tue,  3 Nov 2020 01:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604366470;
        bh=m4phLv8FUPrGZMKDqhmhak7euiy1IqbmK6lazu0t8v4=;
        h=From:To:Cc:Subject:Date:From;
        b=dwgdI5tj65jyosDQR0HyQ6i2OQc6iasG2VewHHl7tm9jbIt7HLN/TmLCALcLEeHFv
         F7YJi5M7Chn+N9lRSEBzy5JmXVsyoTVatDUnu6j8L5wWgH405t78W7GRxOp9w04ogp
         4a2abp6BdCScu7kJrTyRhQ+JTPrsJtxRbP2yTevw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Cl=C3=A9ment=20P=C3=A9ron?= <peron.clem@gmail.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.9 1/7] ARM: dts: sun4i-a10: fix cpu_alert temperature
Date:   Mon,  2 Nov 2020 20:21:02 -0500
Message-Id: <20201103012108.183942-1-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Clément Péron <peron.clem@gmail.com>

[ Upstream commit dea252fa41cd8ce332d148444e4799235a8a03ec ]

When running dtbs_check thermal_zone warn about the
temperature declared.

thermal-zones: cpu-thermal:trips:cpu-alert0:temperature:0:0: 850000 is greater than the maximum of 200000

It's indeed wrong the real value is 85°C and not 850°C.

Signed-off-by: Clément Péron <peron.clem@gmail.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://lore.kernel.org/r/20201003100332.431178-1-peron.clem@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/sun4i-a10.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/sun4i-a10.dtsi b/arch/arm/boot/dts/sun4i-a10.dtsi
index 7e7dfc2b43db0..d1af56d2f25e5 100644
--- a/arch/arm/boot/dts/sun4i-a10.dtsi
+++ b/arch/arm/boot/dts/sun4i-a10.dtsi
@@ -144,7 +144,7 @@ map0 {
 			trips {
 				cpu_alert0: cpu_alert0 {
 					/* milliCelsius */
-					temperature = <850000>;
+					temperature = <85000>;
 					hysteresis = <2000>;
 					type = "passive";
 				};
-- 
2.27.0


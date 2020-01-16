Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3966713E3A6
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388572AbgAPRDI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:03:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:56990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388562AbgAPRDH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:03:07 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B27FE2468A;
        Thu, 16 Jan 2020 17:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194186;
        bh=61EJZJPc1a3gs4XIN+LWQPcIiCAAXoiKIMY7tgHtW+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W+5Dqh8nWgaS0eYSiPJ9OTDeNlpQdzsvPxyJwD9Ih1R4m5YtTTSWXzA790gZ/pjQz
         ii3DB5Lng6zJ1WkhKiLkGX6fupPX1VuF0+8Vf8vFEy48zDMbSIYpQ9+a7JACoYUGiC
         bOfKMyJ8FajXUXj4RNQluNNxnTZA9OpylS1TuIn8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Sasha Levin <sashal@kernel.org>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 259/671] ARM: dts: sun9i: optimus: Fix fixed-regulators
Date:   Thu, 16 Jan 2020 11:52:48 -0500
Message-Id: <20200116165940.10720-142-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime.ripard@bootlin.com>

[ Upstream commit c2a5b554751545023056559121a8ecf86aebe541 ]

Commit 1848f3f44444 ("ARM: dts: sun9i: Remove GPIO pinctrl nodes to avoid
warnings") was wrong on the optimus, and instead of droping the
pinctrl-names property, it dropped the regulator-name one.

Obviously, that wasn't what was intended. Reinstate regulator-name and drop
pinctrl-names.

Fixes: 1848f3f44444 ("ARM: dts: sun9i: Remove GPIO pinctrl nodes to avoid warnings")
Acked-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/sun9i-a80-optimus.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/sun9i-a80-optimus.dts b/arch/arm/boot/dts/sun9i-a80-optimus.dts
index 58a199b0e494..d1e58a6a4343 100644
--- a/arch/arm/boot/dts/sun9i-a80-optimus.dts
+++ b/arch/arm/boot/dts/sun9i-a80-optimus.dts
@@ -82,7 +82,7 @@
 
 	reg_usb1_vbus: usb1-vbus {
 		compatible = "regulator-fixed";
-		pinctrl-names = "default";
+		regulator-name = "usb1-vbus";
 		regulator-min-microvolt = <5000000>;
 		regulator-max-microvolt = <5000000>;
 		enable-active-high;
@@ -91,7 +91,7 @@
 
 	reg_usb3_vbus: usb3-vbus {
 		compatible = "regulator-fixed";
-		pinctrl-names = "default";
+		regulator-name = "usb3-vbus";
 		regulator-min-microvolt = <5000000>;
 		regulator-max-microvolt = <5000000>;
 		enable-active-high;
-- 
2.20.1


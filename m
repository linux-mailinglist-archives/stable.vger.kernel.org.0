Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E37911B03D
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:21:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732403AbfLKPU7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:20:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:50776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732401AbfLKPU6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:20:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97E5022B48;
        Wed, 11 Dec 2019 15:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077658;
        bh=77xwrJu3iw/lj0VEKXGjYKTaKrhvkfdALuPcALj+K2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VFZ4vr2QyHfE10I5+Z/kDed8enZC8bdsk44E5LIQeb2UrHb8IDgV+xr59utuCb5Br
         6UjgMK/ZRJ2EgeOh2gIlqM5pmR6ILFmmA+rPLTNh400Mn09IY1y9QShmkNT5RTOoq8
         RyLho3tvbn3EafDcavDCWIythsl8km+RZssmegW4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 122/243] ARM: dts: sun4i: Fix gpio-keys warning
Date:   Wed, 11 Dec 2019 16:04:44 +0100
Message-Id: <20191211150347.368304042@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime.ripard@bootlin.com>

[ Upstream commit c9b543404c5e1fd51a7ac375294519be5064bf80 ]

Fix the 'unnecessary #address-cells/#size-cells without "ranges" or child
"reg" property' DTC warning for the gpio-keys DT node on A10 boards.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
Acked-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/sun4i-a10-inet9f-rev03.dts | 2 --
 arch/arm/boot/dts/sun4i-a10-pcduino.dts      | 2 --
 2 files changed, 4 deletions(-)

diff --git a/arch/arm/boot/dts/sun4i-a10-inet9f-rev03.dts b/arch/arm/boot/dts/sun4i-a10-inet9f-rev03.dts
index 221acd10f6c84..2f0d966f39ad8 100644
--- a/arch/arm/boot/dts/sun4i-a10-inet9f-rev03.dts
+++ b/arch/arm/boot/dts/sun4i-a10-inet9f-rev03.dts
@@ -63,8 +63,6 @@
 		compatible = "gpio-keys-polled";
 		pinctrl-names = "default";
 		pinctrl-0 = <&key_pins_inet9f>;
-		#address-cells = <1>;
-		#size-cells = <0>;
 		poll-interval = <20>;
 
 		left-joystick-left {
diff --git a/arch/arm/boot/dts/sun4i-a10-pcduino.dts b/arch/arm/boot/dts/sun4i-a10-pcduino.dts
index b97a0f2f20b97..d82a604f3d9c7 100644
--- a/arch/arm/boot/dts/sun4i-a10-pcduino.dts
+++ b/arch/arm/boot/dts/sun4i-a10-pcduino.dts
@@ -76,8 +76,6 @@
 
 	gpio-keys {
 		compatible = "gpio-keys";
-		#address-cells = <1>;
-		#size-cells = <0>;
 
 		back {
 			label = "Key Back";
-- 
2.20.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5DD7F893
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 15:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393472AbfHBNUu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 09:20:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:59278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393451AbfHBNUt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 09:20:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4233D21849;
        Fri,  2 Aug 2019 13:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564752048;
        bh=bcoJHee30V1b63jHD1ymaV8AOPOg4oTRH05ezVaKWOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PrNZTcBQDkQO1qYNLAJfIrg+50yFhs0ZDhp74rWCvcMxta/4L1GT6Tyscg+/MKpEp
         w82rS1ieiOsNxzJFuOVHeY8kx1CeItrP4wOmR6VvS4FqUsRdye+ClnYZ2V0tE8i136
         Q1VC1eBQBF5QjSNucrQnhSgu+mRwT8mNbKA+r0i4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?S=C3=A9bastien=20Szymanski?= 
        <sebastien.szymanski@armadeus.com>,
        Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 33/76] ARM: dts: imx6ul: fix clock frequency property name of I2C buses
Date:   Fri,  2 Aug 2019 09:19:07 -0400
Message-Id: <20190802131951.11600-33-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190802131951.11600-1-sashal@kernel.org>
References: <20190802131951.11600-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sébastien Szymanski <sebastien.szymanski@armadeus.com>

[ Upstream commit 2ca99396333999b9b5c5b91b36cbccacfe571aaf ]

A few boards set clock frequency of their I2C buses with
"clock_frequency" property. The right property is "clock-frequency".

Signed-off-by: Sébastien Szymanski <sebastien.szymanski@armadeus.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6ul-14x14-evk.dtsi  | 2 +-
 arch/arm/boot/dts/imx6ul-geam.dts        | 2 +-
 arch/arm/boot/dts/imx6ul-isiot.dtsi      | 2 +-
 arch/arm/boot/dts/imx6ul-pico-hobbit.dts | 2 +-
 arch/arm/boot/dts/imx6ul-pico-pi.dts     | 4 ++--
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/imx6ul-14x14-evk.dtsi b/arch/arm/boot/dts/imx6ul-14x14-evk.dtsi
index 9207d5d071f11..d556f7c541ce6 100644
--- a/arch/arm/boot/dts/imx6ul-14x14-evk.dtsi
+++ b/arch/arm/boot/dts/imx6ul-14x14-evk.dtsi
@@ -112,7 +112,7 @@
 };
 
 &i2c2 {
-	clock_frequency = <100000>;
+	clock-frequency = <100000>;
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_i2c2>;
 	status = "okay";
diff --git a/arch/arm/boot/dts/imx6ul-geam.dts b/arch/arm/boot/dts/imx6ul-geam.dts
index bc77f26a2f1de..6157a058feec9 100644
--- a/arch/arm/boot/dts/imx6ul-geam.dts
+++ b/arch/arm/boot/dts/imx6ul-geam.dts
@@ -156,7 +156,7 @@
 };
 
 &i2c2 {
-	clock_frequency = <100000>;
+	clock-frequency = <100000>;
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_i2c2>;
 	status = "okay";
diff --git a/arch/arm/boot/dts/imx6ul-isiot.dtsi b/arch/arm/boot/dts/imx6ul-isiot.dtsi
index 213e802bf35c5..23e6e2e7ace9d 100644
--- a/arch/arm/boot/dts/imx6ul-isiot.dtsi
+++ b/arch/arm/boot/dts/imx6ul-isiot.dtsi
@@ -148,7 +148,7 @@
 };
 
 &i2c2 {
-	clock_frequency = <100000>;
+	clock-frequency = <100000>;
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_i2c2>;
 	status = "okay";
diff --git a/arch/arm/boot/dts/imx6ul-pico-hobbit.dts b/arch/arm/boot/dts/imx6ul-pico-hobbit.dts
index 39eeeddac39e3..09f7ffa9ad8c4 100644
--- a/arch/arm/boot/dts/imx6ul-pico-hobbit.dts
+++ b/arch/arm/boot/dts/imx6ul-pico-hobbit.dts
@@ -43,7 +43,7 @@
 };
 
 &i2c2 {
-	clock_frequency = <100000>;
+	clock-frequency = <100000>;
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_i2c2>;
 	status = "okay";
diff --git a/arch/arm/boot/dts/imx6ul-pico-pi.dts b/arch/arm/boot/dts/imx6ul-pico-pi.dts
index de07357b27fc2..6cd7d5877d20c 100644
--- a/arch/arm/boot/dts/imx6ul-pico-pi.dts
+++ b/arch/arm/boot/dts/imx6ul-pico-pi.dts
@@ -43,7 +43,7 @@
 };
 
 &i2c2 {
-	clock_frequency = <100000>;
+	clock-frequency = <100000>;
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_i2c2>;
 	status = "okay";
@@ -58,7 +58,7 @@
 };
 
 &i2c3 {
-	clock_frequency = <100000>;
+	clock-frequency = <100000>;
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_i2c3>;
 	status = "okay";
-- 
2.20.1


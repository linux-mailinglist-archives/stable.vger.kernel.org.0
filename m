Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 277BC101855
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727736AbfKSGHa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 01:07:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:53608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729502AbfKSFdK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:33:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C383221783;
        Tue, 19 Nov 2019 05:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141589;
        bh=AnQeayZI8Q5t0IuDvtp0ycef/61y+WT5LaZc9K/UZ0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HOYmxRHE78vqrtjnHX+g5qo4hrWGXA/7jMAxT49hk1Q0B+dR+G0AdMv7xi8QSzcu/
         TdcPGc1mjdk+cc7z2HXZx/EqBpQlC7o/rFXWUDcdS1D5omIW6A5SZu1jYVYGlWi79x
         f/rINGpY7WUhH7PQYyLuryE5M+eUbM7+G4lKwhx8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        linux-aspeed@lists.ozlabs.org, Rob Herring <robh@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 211/422] ARM: dts: aspeed: Fix I2C bus warnings
Date:   Tue, 19 Nov 2019 06:16:48 +0100
Message-Id: <20191119051412.266011758@linuxfoundation.org>
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

From: Rob Herring <robh@kernel.org>

[ Upstream commit 1426d40e11f730e0c0fd3700a7048082f87b0e6e ]

dtc has new checks for I2C buses. The ASpeed dts files have a node named
'i2c' which causes a false positive warning. As the node is a 'simple-bus',
correct the node name to be 'bus' to fix the warnings.

arch/arm/boot/dts/aspeed-bmc-opp-lanyang.dtb: Warning (i2c_bus_bridge): /ahb/apb/i2c@1e78a000: incorrect #size-cells for I2C bus
arch/arm/boot/dts/aspeed-bmc-opp-romulus.dtb: Warning (i2c_bus_bridge): /ahb/apb/i2c@1e78a000: incorrect #size-cells for I2C bus
arch/arm/boot/dts/aspeed-ast2500-evb.dtb: Warning (i2c_bus_bridge): /ahb/apb/i2c@1e78a000: incorrect #size-cells for I2C bus
arch/arm/boot/dts/aspeed-bmc-arm-centriq2400-rep.dtb: Warning (i2c_bus_bridge): /ahb/apb/i2c@1e78a000: incorrect #size-cells for I2C bus
arch/arm/boot/dts/aspeed-bmc-intel-s2600wf.dtb: Warning (i2c_bus_bridge): /ahb/apb/i2c@1e78a000: incorrect #size-cells for I2C bus
arch/arm/boot/dts/aspeed-bmc-opp-palmetto.dtb: Warning (i2c_bus_bridge): /ahb/apb/i2c@1e78a000: incorrect #size-cells for I2C bus
arch/arm/boot/dts/aspeed-bmc-opp-witherspoon.dtb: Warning (i2c_bus_bridge): /ahb/apb/i2c@1e78a000: incorrect #size-cells for I2C bus
arch/arm/boot/dts/aspeed-bmc-opp-zaius.dtb: Warning (i2c_bus_bridge): /ahb/apb/i2c@1e78a000: incorrect #size-cells for I2C bus
arch/arm/boot/dts/aspeed-bmc-portwell-neptune.dtb: Warning (i2c_bus_bridge): /ahb/apb/i2c@1e78a000: incorrect #size-cells for I2C bus
arch/arm/boot/dts/aspeed-bmc-quanta-q71l.dtb: Warning (i2c_bus_bridge): /ahb/apb/i2c@1e78a000: incorrect #size-cells for I2C bus

Cc: Joel Stanley <joel@jms.id.au>
Cc: Andrew Jeffery <andrew@aj.id.au>
Cc: linux-aspeed@lists.ozlabs.org
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/aspeed-g4.dtsi | 2 +-
 arch/arm/boot/dts/aspeed-g5.dtsi | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/aspeed-g4.dtsi b/arch/arm/boot/dts/aspeed-g4.dtsi
index b23a983f95a53..69f6b9d2e7e7d 100644
--- a/arch/arm/boot/dts/aspeed-g4.dtsi
+++ b/arch/arm/boot/dts/aspeed-g4.dtsi
@@ -350,7 +350,7 @@
 				status = "disabled";
 			};
 
-			i2c: i2c@1e78a000 {
+			i2c: bus@1e78a000 {
 				compatible = "simple-bus";
 				#address-cells = <1>;
 				#size-cells = <1>;
diff --git a/arch/arm/boot/dts/aspeed-g5.dtsi b/arch/arm/boot/dts/aspeed-g5.dtsi
index 87fdc146ff525..d107459fc0f89 100644
--- a/arch/arm/boot/dts/aspeed-g5.dtsi
+++ b/arch/arm/boot/dts/aspeed-g5.dtsi
@@ -410,7 +410,7 @@
 				status = "disabled";
 			};
 
-			i2c: i2c@1e78a000 {
+			i2c: bus@1e78a000 {
 				compatible = "simple-bus";
 				#address-cells = <1>;
 				#size-cells = <1>;
-- 
2.20.1




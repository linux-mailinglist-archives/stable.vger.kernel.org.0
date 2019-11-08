Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8C6F563C
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391465AbfKHTHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:07:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:38260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391459AbfKHTHd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:07:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA364206A3;
        Fri,  8 Nov 2019 19:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573240052;
        bh=FRfSfBQVULDXdAO520uMvwwd2i4lO+PEwK/kcFWv+wc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mC2WNHRA19d3FDINKq6tq7iitlyJET7UcTStlJF5vbgcv9ZrwO9he97MmC38egpt0
         wEfu/2So4tOvOJZfhhupuJOsVchJFtGEOa2bLsFVa8rWPilnF1fFwAZHYSAVTH+pX0
         LjMNJmnVd459r/IRsrEv8s4gK00kZY2vGCnCixRk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrey Smirnov <andrew.smirnov@gmail.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Graeme Smecher <gsmecher@threespeedlogic.com>,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 030/140] ARM: dts: am3874-iceboard: Fix i2c-mux-idle-disconnect usage
Date:   Fri,  8 Nov 2019 19:49:18 +0100
Message-Id: <20191108174905.818458961@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174900.189064908@linuxfoundation.org>
References: <20191108174900.189064908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Smirnov <andrew.smirnov@gmail.com>

[ Upstream commit 647c8977e111c0a62c93a489ebc4b045c833fdb4 ]

According to
Documentation/devicetree/bindings/i2c/i2c-mux-pca954x.txt,
i2c-mux-idle-disconnect is a property of a parent node since it
pertains to the mux/switch as a whole, so move it there and drop all
of the concurrences in child nodes.

Fixes: d031773169df ("ARM: dts: Adds device tree file for McGill's IceBoard, based on TI AM3874")
Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: Benoît Cousson <bcousson@baylibre.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Graeme Smecher <gsmecher@threespeedlogic.com>
Cc: linux-omap@vger.kernel.org
Cc: devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Tested-by: Graeme Smecher <gsmecher@threespeedlogic.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/am3874-iceboard.dts | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/arch/arm/boot/dts/am3874-iceboard.dts b/arch/arm/boot/dts/am3874-iceboard.dts
index 883fb85135d46..1b4b2b0500e4c 100644
--- a/arch/arm/boot/dts/am3874-iceboard.dts
+++ b/arch/arm/boot/dts/am3874-iceboard.dts
@@ -111,13 +111,13 @@
 		reg = <0x70>;
 		#address-cells = <1>;
 		#size-cells = <0>;
+		i2c-mux-idle-disconnect;
 
 		i2c@0 {
 			/* FMC A */
 			#address-cells = <1>;
 			#size-cells = <0>;
 			reg = <0>;
-			i2c-mux-idle-disconnect;
 		};
 
 		i2c@1 {
@@ -125,7 +125,6 @@
 			#address-cells = <1>;
 			#size-cells = <0>;
 			reg = <1>;
-			i2c-mux-idle-disconnect;
 		};
 
 		i2c@2 {
@@ -133,7 +132,6 @@
 			#address-cells = <1>;
 			#size-cells = <0>;
 			reg = <2>;
-			i2c-mux-idle-disconnect;
 		};
 
 		i2c@3 {
@@ -141,7 +139,6 @@
 			#address-cells = <1>;
 			#size-cells = <0>;
 			reg = <3>;
-			i2c-mux-idle-disconnect;
 		};
 
 		i2c@4 {
@@ -149,14 +146,12 @@
 			#address-cells = <1>;
 			#size-cells = <0>;
 			reg = <4>;
-			i2c-mux-idle-disconnect;
 		};
 
 		i2c@5 {
 			#address-cells = <1>;
 			#size-cells = <0>;
 			reg = <5>;
-			i2c-mux-idle-disconnect;
 
 			ina230@40 { compatible = "ti,ina230"; reg = <0x40>; shunt-resistor = <5000>; };
 			ina230@41 { compatible = "ti,ina230"; reg = <0x41>; shunt-resistor = <5000>; };
@@ -182,14 +177,12 @@
 			#address-cells = <1>;
 			#size-cells = <0>;
 			reg = <6>;
-			i2c-mux-idle-disconnect;
 		};
 
 		i2c@7 {
 			#address-cells = <1>;
 			#size-cells = <0>;
 			reg = <7>;
-			i2c-mux-idle-disconnect;
 
 			u41: pca9575@20 {
 				compatible = "nxp,pca9575";
-- 
2.20.1




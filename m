Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4858B15E510
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:39:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393850AbgBNQjf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:39:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:59302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405554AbgBNQXM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:23:12 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EABE2476E;
        Fri, 14 Feb 2020 16:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697391;
        bh=60wDpPFn61IGgirDpObDN+GtIav6ew+mgPwLMFb64XY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IaIWg/jc9EeWIcicKQdeYh10r39Q/YwKbLBKJAZaEBzpFBWWhGCtzkQ3K49amGnt4
         Di9g7jpi9gv7lyEvFV8CBeBiZTzucEqcLaSI6nZMM4s99B8DAM96Aip77TX1GT9TmS
         ksJWgccgDPEnQY0mfdBAtgY8ZwNjuhwMOMUtZe1Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        =?UTF-8?q?Karl=20Rudb=C3=A6k=20Olsen?= <karl@micro-technic.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 086/141] ARM: dts: at91: sama5d3: define clock rate range for tcb1
Date:   Fri, 14 Feb 2020 11:20:26 -0500
Message-Id: <20200214162122.19794-86-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214162122.19794-1-sashal@kernel.org>
References: <20200214162122.19794-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

[ Upstream commit a7e0f3fc01df4b1b7077df777c37feae8c9e8b6d ]

The clock rate range for the TCB1 clock is missing. define it in the device
tree.

Reported-by: Karl Rudbæk Olsen <karl@micro-technic.com>
Fixes: d2e8190b7916 ("ARM: at91/dt: define sama5d3 clocks")
Link: https://lore.kernel.org/r/20200110172007.1253659-2-alexandre.belloni@bootlin.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/sama5d3_tcb1.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/sama5d3_tcb1.dtsi b/arch/arm/boot/dts/sama5d3_tcb1.dtsi
index 801f9745e82f1..b80dbc45a3c20 100644
--- a/arch/arm/boot/dts/sama5d3_tcb1.dtsi
+++ b/arch/arm/boot/dts/sama5d3_tcb1.dtsi
@@ -23,6 +23,7 @@
 					tcb1_clk: tcb1_clk {
 						#clock-cells = <0>;
 						reg = <27>;
+						atmel,clk-output-range = <0 166000000>;
 					};
 				};
 			};
-- 
2.20.1


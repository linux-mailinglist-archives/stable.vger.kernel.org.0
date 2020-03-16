Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8801862F5
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 03:42:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729814AbgCPCeU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Mar 2020 22:34:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:37680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729434AbgCPCeU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Mar 2020 22:34:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED29620726;
        Mon, 16 Mar 2020 02:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584326059;
        bh=sagaxxPBDu0NGQWOqfrmvT5ZLXJ0mZtSQz96D2dNjy8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n3A3SGhWyq+rPKG2HdO+xy40cAEd8HpVGTjFyKAk9Fbbn668ROyK3jlnr82qvMvK3
         UJa7pSTZX0LqqkMAyDeq+eU8MSZkH8QHE7IQk+a8mO3jAEtbDO826rFhWG2Le2yMoj
         8rvEiZpTGAUJXVywA8F7q77EY4B/8E69bxS4kdAs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 07/35] ARM: dts: dra7-l4: mark timer13-16 as pwm capable
Date:   Sun, 15 Mar 2020 22:33:43 -0400
Message-Id: <20200316023411.1263-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200316023411.1263-1-sashal@kernel.org>
References: <20200316023411.1263-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

[ Upstream commit 00a39c92c8ab94727f021297d1748531af113fcd ]

DMTimers 13 - 16 are PWM capable and also can be used for CPTS input
signals generation. Hence, mark them as "ti,timer-pwm".

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Reviewed-by: Lokesh Vutla <lokeshvutla@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/dra7-l4.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/dra7-l4.dtsi b/arch/arm/boot/dts/dra7-l4.dtsi
index c3954e34835b8..3ae4f6358da41 100644
--- a/arch/arm/boot/dts/dra7-l4.dtsi
+++ b/arch/arm/boot/dts/dra7-l4.dtsi
@@ -3413,6 +3413,7 @@
 				clocks = <&l4per3_clkctrl DRA7_L4PER3_TIMER13_CLKCTRL 24>;
 				clock-names = "fck";
 				interrupts = <GIC_SPI 339 IRQ_TYPE_LEVEL_HIGH>;
+				ti,timer-pwm;
 			};
 		};
 
@@ -3441,6 +3442,7 @@
 				clocks = <&l4per3_clkctrl DRA7_L4PER3_TIMER14_CLKCTRL 24>;
 				clock-names = "fck";
 				interrupts = <GIC_SPI 340 IRQ_TYPE_LEVEL_HIGH>;
+				ti,timer-pwm;
 			};
 		};
 
@@ -3469,6 +3471,7 @@
 				clocks = <&l4per3_clkctrl DRA7_L4PER3_TIMER15_CLKCTRL 24>;
 				clock-names = "fck";
 				interrupts = <GIC_SPI 341 IRQ_TYPE_LEVEL_HIGH>;
+				ti,timer-pwm;
 			};
 		};
 
@@ -3497,6 +3500,7 @@
 				clocks = <&l4per3_clkctrl DRA7_L4PER3_TIMER16_CLKCTRL 24>;
 				clock-names = "fck";
 				interrupts = <GIC_SPI 342 IRQ_TYPE_LEVEL_HIGH>;
+				ti,timer-pwm;
 			};
 		};
 
-- 
2.20.1


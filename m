Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E12D8190F12
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:19:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728552AbgCXNRP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:17:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:36942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728475AbgCXNRP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:17:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25457208E4;
        Tue, 24 Mar 2020 13:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585055834;
        bh=sagaxxPBDu0NGQWOqfrmvT5ZLXJ0mZtSQz96D2dNjy8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=116l9mv2DPFYvOS+9wDEs6Vam755R+bXzzSbElLURV4f+GUtmpm0XaIRWDS6mOPsu
         6rnaYpV6JVe1w7QNIZLmEAd4FyXqDCDhp1DcGdE1JHtOlyrQt12gDuMdWHf7kqs28w
         ki8d7UDE5Se8UmAhuNha5569f2dB6ntX4ykE5Aco=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 007/102] ARM: dts: dra7-l4: mark timer13-16 as pwm capable
Date:   Tue, 24 Mar 2020 14:09:59 +0100
Message-Id: <20200324130807.262365313@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130806.544601211@linuxfoundation.org>
References: <20200324130806.544601211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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




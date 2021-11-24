Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17BF445C2E9
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349576AbhKXNeM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:34:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:57704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351444AbhKXNbn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:31:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE71861BBF;
        Wed, 24 Nov 2021 12:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758356;
        bh=2wMAuXLRN/NQAokn0DVCi+mWaxJq4k1jhHlsdCP2pww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YgQgd55Pu6PnhYTZC2GUdD1FA1bUdmXBjHZf5lmrbdSeylTbXR0G04nkkQt6w0Jud
         Opp4JMiUo4tQbktXG865wMozvaJDRvzdeDesZvqez2LO6BzqXXQ5mVSMpFw1MGEsRn
         EWxh8S+5kTFKjTcIFYoygTgcTEPjGPRZ/jnyhcdE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Wei Xu <xuwei5@hisilicon.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 010/154] arm64: dts: hisilicon: fix arm,sp805 compatible string
Date:   Wed, 24 Nov 2021 12:56:46 +0100
Message-Id: <20211124115702.714925067@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Walle <michael@walle.cc>

[ Upstream commit 894d4f1f77d0e88f1f81af2e1e37333c1c41b631 ]

According to Documentation/devicetree/bindings/watchdog/arm,sp805.yaml
the compatible is:
  compatible = "arm,sp805", "arm,primecell";

The current compatible string doesn't exist at all. Fix it.

Signed-off-by: Michael Walle <michael@walle.cc>
Signed-off-by: Wei Xu <xuwei5@hisilicon.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/hisilicon/hi3660.dtsi | 4 ++--
 arch/arm64/boot/dts/hisilicon/hi6220.dtsi | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/hisilicon/hi3660.dtsi b/arch/arm64/boot/dts/hisilicon/hi3660.dtsi
index 994140fbc916e..fe4dce23ef7e1 100644
--- a/arch/arm64/boot/dts/hisilicon/hi3660.dtsi
+++ b/arch/arm64/boot/dts/hisilicon/hi3660.dtsi
@@ -1086,7 +1086,7 @@
 		};
 
 		watchdog0: watchdog@e8a06000 {
-			compatible = "arm,sp805-wdt", "arm,primecell";
+			compatible = "arm,sp805", "arm,primecell";
 			reg = <0x0 0xe8a06000 0x0 0x1000>;
 			interrupts = <GIC_SPI 44 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&crg_ctrl HI3660_OSC32K>,
@@ -1095,7 +1095,7 @@
 		};
 
 		watchdog1: watchdog@e8a07000 {
-			compatible = "arm,sp805-wdt", "arm,primecell";
+			compatible = "arm,sp805", "arm,primecell";
 			reg = <0x0 0xe8a07000 0x0 0x1000>;
 			interrupts = <GIC_SPI 45 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&crg_ctrl HI3660_OSC32K>,
diff --git a/arch/arm64/boot/dts/hisilicon/hi6220.dtsi b/arch/arm64/boot/dts/hisilicon/hi6220.dtsi
index 014735a9bc731..fbce014bdc270 100644
--- a/arch/arm64/boot/dts/hisilicon/hi6220.dtsi
+++ b/arch/arm64/boot/dts/hisilicon/hi6220.dtsi
@@ -840,7 +840,7 @@
 		};
 
 		watchdog0: watchdog@f8005000 {
-			compatible = "arm,sp805-wdt", "arm,primecell";
+			compatible = "arm,sp805", "arm,primecell";
 			reg = <0x0 0xf8005000 0x0 0x1000>;
 			interrupts = <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&ao_ctrl HI6220_WDT0_PCLK>,
-- 
2.33.0




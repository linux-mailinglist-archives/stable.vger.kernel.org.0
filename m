Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30B6D11B479
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732719AbfLKPZq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:25:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:58120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732716AbfLKPZn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:25:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0F4F2173E;
        Wed, 11 Dec 2019 15:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077942;
        bh=cZpitACy2KXnabzudAg8l5hYZuEEYB2y4ZV+QDVz0gA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vbDz181FPXVf5MmuIYp78hG7wE2KThSdBwpCL7lzStdMVLXXUm0pdNVn+VJHxQb94
         ObtdIvf5xTf9NT+LX8T2DPFwMdADNkT0pdKYeQZChf6VXAEHtfA50ZZZ5wCLyzFGwd
         aHCmg1z6QvMWhDGqKXVqrsTt8k17VTm4lbgw3YVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Rob Herring <robh@kernel.org>,
        Will Deacon <will.deacon@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 192/243] ARM: dts: sunxi: Fix PMU compatible strings
Date:   Wed, 11 Dec 2019 16:05:54 +0100
Message-Id: <20191211150352.132077034@linuxfoundation.org>
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

From: Rob Herring <robh@kernel.org>

[ Upstream commit 5719ac19fc32d892434939c1756c2f9a8322e6ef ]

"arm,cortex-a15-pmu" is not a valid fallback compatible string for an
Cortex-A7 PMU, so drop it.

Cc: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Rob Herring <robh@kernel.org>
Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/sun6i-a31.dtsi | 2 +-
 arch/arm/boot/dts/sun7i-a20.dtsi | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/sun6i-a31.dtsi b/arch/arm/boot/dts/sun6i-a31.dtsi
index debc0bf22ea3b..76924fa42bbc3 100644
--- a/arch/arm/boot/dts/sun6i-a31.dtsi
+++ b/arch/arm/boot/dts/sun6i-a31.dtsi
@@ -201,7 +201,7 @@
 	};
 
 	pmu {
-		compatible = "arm,cortex-a7-pmu", "arm,cortex-a15-pmu";
+		compatible = "arm,cortex-a7-pmu";
 		interrupts = <GIC_SPI 120 IRQ_TYPE_LEVEL_HIGH>,
 			     <GIC_SPI 121 IRQ_TYPE_LEVEL_HIGH>,
 			     <GIC_SPI 122 IRQ_TYPE_LEVEL_HIGH>,
diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
index 73e789a133de1..355619dce7994 100644
--- a/arch/arm/boot/dts/sun7i-a20.dtsi
+++ b/arch/arm/boot/dts/sun7i-a20.dtsi
@@ -183,7 +183,7 @@
 	};
 
 	pmu {
-		compatible = "arm,cortex-a7-pmu", "arm,cortex-a15-pmu";
+		compatible = "arm,cortex-a7-pmu";
 		interrupts = <GIC_SPI 120 IRQ_TYPE_LEVEL_HIGH>,
 			     <GIC_SPI 121 IRQ_TYPE_LEVEL_HIGH>;
 	};
-- 
2.20.1




Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E36131218E9
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:47:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727278AbfLPRzH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:55:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:51962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727728AbfLPRzG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:55:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9322C205ED;
        Mon, 16 Dec 2019 17:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576518906;
        bh=02XFS/OU1KS/UCytUjHWP9OXSM3pQQE2fb1PRIdLJOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nc18RJx9aP3+Jyyxs6wzld7ewxVd4Eb+KMtq48aR/bBiz/4xIRQeYC/96N1EpLDkw
         bre9vEZoqoKi1ZuiA52BPrB3TT0Bf8LfcRnRLWoEk0uS9XOIdCWy6dlczA10iKUGo3
         Gtj+MspTMC9Rf6YN59B2+6iNhWaqQ4NNE+y1lw4A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Rob Herring <robh@kernel.org>,
        Will Deacon <will.deacon@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 116/267] ARM: dts: sunxi: Fix PMU compatible strings
Date:   Mon, 16 Dec 2019 18:47:22 +0100
Message-Id: <20191216174903.063059705@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
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
index eef072a21acca..0bb82d0442a59 100644
--- a/arch/arm/boot/dts/sun6i-a31.dtsi
+++ b/arch/arm/boot/dts/sun6i-a31.dtsi
@@ -173,7 +173,7 @@
 	};
 
 	pmu {
-		compatible = "arm,cortex-a7-pmu", "arm,cortex-a15-pmu";
+		compatible = "arm,cortex-a7-pmu";
 		interrupts = <GIC_SPI 120 IRQ_TYPE_LEVEL_HIGH>,
 			     <GIC_SPI 121 IRQ_TYPE_LEVEL_HIGH>,
 			     <GIC_SPI 122 IRQ_TYPE_LEVEL_HIGH>,
diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
index 96bee776e1456..77f04dbdf9967 100644
--- a/arch/arm/boot/dts/sun7i-a20.dtsi
+++ b/arch/arm/boot/dts/sun7i-a20.dtsi
@@ -171,7 +171,7 @@
 	};
 
 	pmu {
-		compatible = "arm,cortex-a7-pmu", "arm,cortex-a15-pmu";
+		compatible = "arm,cortex-a7-pmu";
 		interrupts = <GIC_SPI 120 IRQ_TYPE_LEVEL_HIGH>,
 			     <GIC_SPI 121 IRQ_TYPE_LEVEL_HIGH>;
 	};
-- 
2.20.1




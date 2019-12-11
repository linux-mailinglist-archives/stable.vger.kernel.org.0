Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8855711B55A
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731121AbfLKPxS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:53:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:48078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732066AbfLKPTV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:19:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C95BF22527;
        Wed, 11 Dec 2019 15:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077561;
        bh=GX1VV5c3skhmIwY+N99FM1nMhLwWQonoi7vrcwG+g6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1nfvkvxekqNTlT8aXD+FQsOrg8IEyqW1RH+Mcnt8jiZs2KNA7UL7gTFS2mtjKHG/M
         KqYGUrusYaKEVG/zuVYVL/1ofLN8On4TJc7Ui3OqOwnDszPjxHtlMsGWFnr+vIGF6w
         /O0VTCuV6uUqS9/opyQgHOhJaFMSi7M+1NQGQ5eM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 086/243] ARM: dts: exynos: Use Samsung SoC specific compatible for DWC2 module
Date:   Wed, 11 Dec 2019 16:04:08 +0100
Message-Id: <20191211150344.917765151@linuxfoundation.org>
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

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit 6035cbcceb069f87296b3cd0bc4736ad5618bf47 ]

DWC2 hardware module integrated in Samsung SoCs requires some quirks to
operate properly, so use Samsung SoC specific compatible to notify driver
to apply respective fixes.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos3250.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index 94efca78c42ff..5892a9f7622fa 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -360,7 +360,7 @@
 		};
 
 		hsotg: hsotg@12480000 {
-			compatible = "snps,dwc2";
+			compatible = "samsung,s3c6400-hsotg", "snps,dwc2";
 			reg = <0x12480000 0x20000>;
 			interrupts = <GIC_SPI 141 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&cmu CLK_USBOTG>;
-- 
2.20.1




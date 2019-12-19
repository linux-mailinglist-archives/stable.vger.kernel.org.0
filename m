Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C371A126A00
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728387AbfLSSnM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:43:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:34682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728002AbfLSSnK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:43:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B08124672;
        Thu, 19 Dec 2019 18:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576780989;
        bh=zDW9b2/pZe+ctZdj3Mjiww5eCHoqpYII5WQley0EyZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CiRn4LMcTOCXX7MqhSmsLC8ihV1TqTX4qEHUdgoO1troleZt+8Lw+ckxvgX0EMjVy
         ILLMtYpG3nfvjbEVa2ZGnskMMmNA/hO84vivE32OQ2aIkaeOgBF7b0qd6ss/xcDioV
         eZCQOM93tNE7ZwUMPexDaKV/l90mKVfWp5BM1eDY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 036/199] ARM: dts: exynos: Use Samsung SoC specific compatible for DWC2 module
Date:   Thu, 19 Dec 2019 19:31:58 +0100
Message-Id: <20191219183216.911380403@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183214.629503389@linuxfoundation.org>
References: <20191219183214.629503389@linuxfoundation.org>
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
index 51dbd8cb91cb5..99b3d23319719 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -345,7 +345,7 @@
 		};
 
 		hsotg: hsotg@12480000 {
-			compatible = "snps,dwc2";
+			compatible = "samsung,s3c6400-hsotg", "snps,dwc2";
 			reg = <0x12480000 0x20000>;
 			interrupts = <0 141 0>;
 			clocks = <&cmu CLK_USBOTG>;
-- 
2.20.1




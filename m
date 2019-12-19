Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98CA6126D7F
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727624AbfLSSgc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:36:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:53548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727617AbfLSSgb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:36:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA5F024672;
        Thu, 19 Dec 2019 18:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576780591;
        bh=Isu3PsevsWCapFsKhQtOcN0Gn243im6GOktkJsovBIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rsdnvBjusCu+2bVCr5DAZhpuNX4keSRLeStVuKt90kgWKJdIcArWVqA08ISUWDQKr
         5+vPQrVwTDHAoWhYIZVVMAByJi2SwnTH5vaYoW6LQUMpa3Rs3vfOoc3Yt69FBJJiQg
         2kZpyZeUfYd1lDZZ6B+eRNqz6tcdpn8ZCKs+xTYs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 029/162] ARM: dts: exynos: Use Samsung SoC specific compatible for DWC2 module
Date:   Thu, 19 Dec 2019 19:32:17 +0100
Message-Id: <20191219183209.421641412@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183150.477687052@linuxfoundation.org>
References: <20191219183150.477687052@linuxfoundation.org>
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
index e81a27214188c..cbe3507e6e249 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -325,7 +325,7 @@
 		};
 
 		hsotg: hsotg@12480000 {
-			compatible = "snps,dwc2";
+			compatible = "samsung,s3c6400-hsotg", "snps,dwc2";
 			reg = <0x12480000 0x20000>;
 			interrupts = <0 141 0>;
 			clocks = <&cmu CLK_USBOTG>;
-- 
2.20.1




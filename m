Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43F9B408D06
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240423AbhIMNWz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:22:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:34850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240726AbhIMNVb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:21:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C585B6103B;
        Mon, 13 Sep 2021 13:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539215;
        bh=/fInKGmN6+naJElx8rPkaWTIq4JwxR7euQotjQJOQbE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1phvIH0iEGPKt/KrUvtGX8BN3VKM4aj9lJ32mGJfE/sPt6/VbvDhd72ARPnDwa473
         vhLksQg6vB/0ABA3WBYDryRyIQn2Fmc9d8nBqyi3G7GxIrprRKHvfo1ZTfms7naDYk
         3QNdtqTKdwo+d7bf2Lbc5SSq6WxSw0CGvDEZ79SI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sam Protsenko <semen.protsenko@linaro.org>,
        Marc Zyngier <maz@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 084/144] arm64: dts: exynos: correct GIC CPU interfaces address range on Exynos7
Date:   Mon, 13 Sep 2021 15:14:25 +0200
Message-Id: <20210913131050.770742190@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131047.974309396@linuxfoundation.org>
References: <20210913131047.974309396@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

[ Upstream commit 01c72cad790cb6cd3ccbe4c1402b6cb6c6bbffd0 ]

The GIC-400 CPU interfaces address range is defined as 0x2000-0x3FFF (by
ARM).

Reported-by: Sam Protsenko <semen.protsenko@linaro.org>
Reported-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Reviewed-by: Sam Protsenko <semen.protsenko@linaro.org>
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Fixes: b9024cbc937d ("arm64: dts: Add initial device tree support for exynos7")
Link: https://lore.kernel.org/r/20210805072110.4730-1-krzysztof.kozlowski@canonical.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/exynos/exynos7.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/exynos/exynos7.dtsi b/arch/arm64/boot/dts/exynos/exynos7.dtsi
index 25549d9552ae..84f92b44c323 100644
--- a/arch/arm64/boot/dts/exynos/exynos7.dtsi
+++ b/arch/arm64/boot/dts/exynos/exynos7.dtsi
@@ -113,7 +113,7 @@
 			#address-cells = <0>;
 			interrupt-controller;
 			reg =	<0x11001000 0x1000>,
-				<0x11002000 0x1000>,
+				<0x11002000 0x2000>,
 				<0x11004000 0x2000>,
 				<0x11006000 0x2000>;
 		};
-- 
2.30.2




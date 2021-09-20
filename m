Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0A74411A5B
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244103AbhITQtJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:49:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:36970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236886AbhITQsT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:48:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D32861262;
        Mon, 20 Sep 2021 16:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156413;
        bh=OAuICGPFYNooVAgf6Q3TEPh/vMOymSiG9/Da2Z6hG/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0tg4Fq8uXrxEH5nBQk5bNEUIZbJxNhcZl64blf13LihwcStdRpdbOD9RxDaQHfkbq
         LPUg/8cfGhesPqb2dQbvYKrhm4+voNAjaNr5RQNgMIbWzDFx/oLlPQJTdzj7n+GKG7
         zMMitaxw8lvXEQZ4gx5LDznWyyAakJg7wbh/4R14=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sam Protsenko <semen.protsenko@linaro.org>,
        Marc Zyngier <maz@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 047/133] arm64: dts: exynos: correct GIC CPU interfaces address range on Exynos7
Date:   Mon, 20 Sep 2021 18:42:05 +0200
Message-Id: <20210920163914.188587813@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163912.603434365@linuxfoundation.org>
References: <20210920163912.603434365@linuxfoundation.org>
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
index f9c5a549c2c0..cb863891f29e 100644
--- a/arch/arm64/boot/dts/exynos/exynos7.dtsi
+++ b/arch/arm64/boot/dts/exynos/exynos7.dtsi
@@ -90,7 +90,7 @@
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




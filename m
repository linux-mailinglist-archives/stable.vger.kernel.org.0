Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD99411D3F
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347082AbhITRRg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:17:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:40008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345969AbhITRPg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:15:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A102613BD;
        Mon, 20 Sep 2021 16:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157126;
        bh=bKLi7OrXodncjfXyVY8h2UD1AdDUN5BAz8hxTqFknFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h6Sc6TFbDrliDYaXEfudmH4yHzQ7bKsksrsDUR1x+61YVzTxoXSfS/SXjX77oDFiP
         9Pvxp4WYqfuRhzv42tvHL5PpXPqEiQWPMB9ZkjtGj93F2K85HglNldj5pn7f4Z3Xza
         fLY4ur3f4Cm3wS9oChQr48q66T/I9ZpHET8kpNbY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sam Protsenko <semen.protsenko@linaro.org>,
        Marc Zyngier <maz@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 064/217] arm64: dts: exynos: correct GIC CPU interfaces address range on Exynos7
Date:   Mon, 20 Sep 2021 18:41:25 +0200
Message-Id: <20210920163926.795622430@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163924.591371269@linuxfoundation.org>
References: <20210920163924.591371269@linuxfoundation.org>
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
index 875297a470da..331dcf94acf0 100644
--- a/arch/arm64/boot/dts/exynos/exynos7.dtsi
+++ b/arch/arm64/boot/dts/exynos/exynos7.dtsi
@@ -94,7 +94,7 @@
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




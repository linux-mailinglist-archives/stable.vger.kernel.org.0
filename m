Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA633D298E
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbhGVQF1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:05:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:39688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233969AbhGVQD6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:03:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2AE5461C7A;
        Thu, 22 Jul 2021 16:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972254;
        bh=NOcS7aCnZjAKS1x5qwQ53pdWHCg6MgbIwggL6/yzyFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q/oRUFikBLSt8ygjp2q9HGwtRMTVpnncFDnEeczCO9wYQkYyR7rJqnhr5FA8m+zpi
         QQeT4frc/J/Y3D78/vAfbBTtNkIeWU1K2q4IrFNP4ZGWdyaoTs7qqoq84l+71GLT1F
         tG74ma9vi/5iKokS/tKKmzIGJFyNsGEcAOZNArw4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Svyatoslav Ryhel <clamor95@gmail.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 045/156] ARM: tegra: nexus7: Correct 3v3 regulator GPIO of PM269 variant
Date:   Thu, 22 Jul 2021 18:30:20 +0200
Message-Id: <20210722155629.866541255@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit c4dd6066bc304649e3159f1c7a08ece25d537e00 ]

The 3v3 regulator GPIO is GP6 and not GP7, which is the DDR regulator.
Both regulators are always-on, nevertheless the DT model needs to be
corrected, fix it.

Reported-by: Svyatoslav Ryhel <clamor95@gmail.com>
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/tegra30-asus-nexus7-grouper-ti-pmic.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/tegra30-asus-nexus7-grouper-ti-pmic.dtsi b/arch/arm/boot/dts/tegra30-asus-nexus7-grouper-ti-pmic.dtsi
index b97da45ebdb4..e1325ee0a3c4 100644
--- a/arch/arm/boot/dts/tegra30-asus-nexus7-grouper-ti-pmic.dtsi
+++ b/arch/arm/boot/dts/tegra30-asus-nexus7-grouper-ti-pmic.dtsi
@@ -144,7 +144,7 @@
 	};
 
 	vdd_3v3_sys: regulator@1 {
-		gpio = <&pmic 7 GPIO_ACTIVE_HIGH>;
+		gpio = <&pmic 6 GPIO_ACTIVE_HIGH>;
 		enable-active-high;
 	};
 };
-- 
2.30.2




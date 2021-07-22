Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EED8D3D290D
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbhGVQAx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:00:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:34178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233259AbhGVP6T (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:58:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA6646136E;
        Thu, 22 Jul 2021 16:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971934;
        bh=vA0VA+LH8LhvALOUJR9kqFiPBGVALk+dR7V5FWRGdQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EQsWXr7GDsVXbDSzkzjaMkUsDNXROD/iu4HRoQESSqEKSHTwsdlqWySOLq+D6EHVI
         VaCDT+7BKsMpVvzVx/o3GqQOFA240CZgGhBFzIIBoOZrKRNqzVkYKjbxj4Lp36plbb
         di88Mm26s4VU66h4i4kP1TGjvfqZ8T0+21GE1b3w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Svyatoslav Ryhel <clamor95@gmail.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 037/125] ARM: tegra: nexus7: Correct 3v3 regulator GPIO of PM269 variant
Date:   Thu, 22 Jul 2021 18:30:28 +0200
Message-Id: <20210722155625.925875952@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155624.672583740@linuxfoundation.org>
References: <20210722155624.672583740@linuxfoundation.org>
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
index bfc06b988781..215e497652d8 100644
--- a/arch/arm/boot/dts/tegra30-asus-nexus7-grouper-ti-pmic.dtsi
+++ b/arch/arm/boot/dts/tegra30-asus-nexus7-grouper-ti-pmic.dtsi
@@ -143,7 +143,7 @@
 	};
 
 	vdd_3v3_sys: regulator@1 {
-		gpio = <&pmic 7 GPIO_ACTIVE_HIGH>;
+		gpio = <&pmic 6 GPIO_ACTIVE_HIGH>;
 		enable-active-high;
 	};
 };
-- 
2.30.2




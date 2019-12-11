Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9A2611B580
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731632AbfLKPRU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:17:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:44702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730738AbfLKPRT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:17:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 550D924671;
        Wed, 11 Dec 2019 15:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077438;
        bh=lfFSyBdXDD0UcUCCfLXP7ssA1e4znSyr58XFBC1iaRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xAlWh3q4jLRtP839JLuqf0sgTSmA7wXRyn627O90jSBKod3X/uDwjfcx2mWwZbPMv
         W8B0CHJwmoWzSKUTYyZbDnoIh1JAAl/FhRjdzAfFvKxiPFx4Hb6Qvqaf+dtJ8E6i9v
         fov8bNlDU8Vs7PlumrpFX46wi/D1RcZMaWF2vYn8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anand Moon <linux.amoon@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 040/243] ARM: dts: exynos: Fix LDO13 min values on Odroid XU3/XU4/HC1
Date:   Wed, 11 Dec 2019 16:03:22 +0100
Message-Id: <20191211150341.878081012@linuxfoundation.org>
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

From: Anand Moon <linux.amoon@gmail.com>

[ Upstream commit 8fe325fa9d065aa54db4914fdaccab2169fd67a8 ]

>From Odroid XU3/XU4/HC1 schematics the LDO13 regulator for SD2, can be
set on 1.8V or 2.8V so the minimal value should be fixed to 1.8V.  This
is necessary to support UHS-I tuning (otherwise card won't be detected
during boot).

Signed-off-by: Anand Moon <linux.amoon@gmail.com>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos5422-odroid-core.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos5422-odroid-core.dtsi b/arch/arm/boot/dts/exynos5422-odroid-core.dtsi
index 27214e6ebe4f4..d476ba0f07b6b 100644
--- a/arch/arm/boot/dts/exynos5422-odroid-core.dtsi
+++ b/arch/arm/boot/dts/exynos5422-odroid-core.dtsi
@@ -224,7 +224,7 @@
 
 			ldo13_reg: LDO13 {
 				regulator-name = "vddq_mmc2";
-				regulator-min-microvolt = <2800000>;
+				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <2800000>;
 			};
 
-- 
2.20.1




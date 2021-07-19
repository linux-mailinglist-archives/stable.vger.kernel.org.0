Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02D513CDFAD
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344230AbhGSPLP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:11:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:41268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237769AbhGSPKE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:10:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1E4360FD7;
        Mon, 19 Jul 2021 15:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709843;
        bh=Aquf+yxyLmUn+hwFCJwh0LODQnBZyyp44vYZPrbUCYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TVCnRpDq8ckp6XRMjoXiHq2cd6m6bnP6xXO0+g+3zbKwIW2Vor9skm1541gs3Opsu
         +zvk/2/K+SxMiud2czR7bXQC8V3Z/r+YJF6lI4UCNKTLfZyeLFfH0lkOcaiQ0j68+a
         5j2365cArnCiGwYwQy1XERNmK3FjBN3IU/SKxbTQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 120/149] ARM: dts: exynos: fix PWM LED max brightness on Odroid XU4
Date:   Mon, 19 Jul 2021 16:53:48 +0200
Message-Id: <20210719144929.816431585@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144901.370365147@linuxfoundation.org>
References: <20210719144901.370365147@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

[ Upstream commit fd2f1717966535b7d0b6fe45cf0d79e94330da5f ]

There is no "max_brightness" property as pointed out by dtschema:

  arch/arm/boot/dts/exynos5422-odroidxu4.dt.yaml: led-controller: led-1: 'max-brightness' is a required property

Fixes: 6658356014cb ("ARM: dts: Add support Odroid XU4 board for exynos5422-odroidxu4")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Link: https://lore.kernel.org/r/20210505135941.59898-5-krzysztof.kozlowski@canonical.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos5422-odroidxu4.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos5422-odroidxu4.dts b/arch/arm/boot/dts/exynos5422-odroidxu4.dts
index 892d389d6d09..1fc354485403 100644
--- a/arch/arm/boot/dts/exynos5422-odroidxu4.dts
+++ b/arch/arm/boot/dts/exynos5422-odroidxu4.dts
@@ -24,7 +24,7 @@
 			label = "blue:heartbeat";
 			pwms = <&pwm 2 2000000 0>;
 			pwm-names = "pwm2";
-			max_brightness = <255>;
+			max-brightness = <255>;
 			linux,default-trigger = "heartbeat";
 		};
 	};
-- 
2.30.2




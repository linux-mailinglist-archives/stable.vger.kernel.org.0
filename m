Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30F693CE40D
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348287AbhGSPlz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:41:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:57394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348893AbhGSPfe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 231D661264;
        Mon, 19 Jul 2021 16:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711324;
        bh=fzPHRoAOAEIIqq0W0q/JtfuEMoLMGz06AMQ7FxmadH4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PW7KGFGvj9ls5nFJYNjoia2Lz2t0XVgR+92taYfocd7vj07qGgPxpsi8I3/sF9hJ5
         KpNspg1arxcm1RtG7suv4JPcPqgSXk3HSDNFWOKTeHdZQb/93uRKShi6XrCvxdRnVi
         ZV6t/IREtvd+PTgW3QhvVsJwLe7iKX3MKnhQFoGs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 278/351] ARM: dts: exynos: fix PWM LED max brightness on Odroid HC1
Date:   Mon, 19 Jul 2021 16:53:44 +0200
Message-Id: <20210719144954.154380284@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

[ Upstream commit a7e59c84cf2055a1894f45855c8319191f2fa59e ]

There is no "max_brightness" property as pointed out by dtschema:

  arch/arm/boot/dts/exynos5422-odroidhc1.dt.yaml: led-controller: led-1: 'max-brightness' is a required property

Fixes: 1ac49427b566 ("ARM: dts: exynos: Add support for Hardkernel's Odroid HC1 board")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Link: https://lore.kernel.org/r/20210505135941.59898-4-krzysztof.kozlowski@canonical.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos5422-odroidhc1.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos5422-odroidhc1.dts b/arch/arm/boot/dts/exynos5422-odroidhc1.dts
index 20c222b33f98..d91f7fa2cf80 100644
--- a/arch/arm/boot/dts/exynos5422-odroidhc1.dts
+++ b/arch/arm/boot/dts/exynos5422-odroidhc1.dts
@@ -22,7 +22,7 @@
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




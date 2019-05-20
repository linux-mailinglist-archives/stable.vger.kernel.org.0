Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E33D9235DD
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391433AbfETMkW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:40:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:49868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390633AbfETMcv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:32:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79BA7204FD;
        Mon, 20 May 2019 12:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355571;
        bh=m2OBlvN8mbEPP164pnDww0IyPiWYtAYv6jdY+RysYcs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1qxRwm7soe2fXnvHv4V3WvaKpYGbtTdMUxFlu9rATxOn0FYTZvY7TzQ99HJKwROCg
         3sx1yj4P7DKGSC9KkoyPCXF1JXvuQiE0DNecHul96NLMYqZRUI/J3lmXS7Eq+At95m
         efXaPDvyzrprrTsKrvMN6z3t/6Fq/Tc9T4lZGS7U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 5.1 009/128] ARM: dts: exynos: Fix audio routing on Odroid XU3
Date:   Mon, 20 May 2019 14:13:16 +0200
Message-Id: <20190520115250.073006506@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115249.449077487@linuxfoundation.org>
References: <20190520115249.449077487@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sylwester Nawrocki <s.nawrocki@samsung.com>

commit 34dc82257488ccbdfb6ecdd087b3c8b371e03ee3 upstream.

Add missing audio routing entry for the capture stream, this change
is required to fix audio recording on Odroid XU3/XU3-Lite.

Fixes: 885b005d232c ("ARM: dts: exynos: Add support for secondary DAI to Odroid XU3")
Cc: stable@vger.kernel.org
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/exynos5422-odroidxu3-audio.dtsi |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/arm/boot/dts/exynos5422-odroidxu3-audio.dtsi
+++ b/arch/arm/boot/dts/exynos5422-odroidxu3-audio.dtsi
@@ -26,7 +26,8 @@
 			"Speakers", "SPKL",
 			"Speakers", "SPKR",
 			"I2S Playback", "Mixer DAI TX",
-			"HiFi Playback", "Mixer DAI TX";
+			"HiFi Playback", "Mixer DAI TX",
+			"Mixer DAI RX", "HiFi Capture";
 
 		assigned-clocks = <&clock CLK_MOUT_EPLL>,
 				<&clock CLK_MOUT_MAU_EPLL>,



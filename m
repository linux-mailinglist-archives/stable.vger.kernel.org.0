Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE8923737
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 15:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388474AbfETMWp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:22:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:36878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388486AbfETMWp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:22:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B32B20656;
        Mon, 20 May 2019 12:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558354964;
        bh=vENCxlkEC564e0tIMqMIzm3b6Nb2+zQVTcPaW5XIdUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HpYajj60sNcMVtaqaNLe4ohHcpaLDz69vR7ItR2dxGihqmpbEsPQI2Uu5r2jgqLdG
         KsC1LfvPWW8wHqB99EFaR3JI2Qy2C9js8t5gtRGn0sV2ljkCD+ryEDaJrEor3rrd2G
         e9fXv780OY3ljNE81zQewNoZ7buYj21wMOcVFiEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 4.19 007/105] ARM: dts: exynos: Fix audio (microphone) routing on Odroid XU3
Date:   Mon, 20 May 2019 14:13:13 +0200
Message-Id: <20190520115247.557577558@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115247.060821231@linuxfoundation.org>
References: <20190520115247.060821231@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sylwester Nawrocki <s.nawrocki@samsung.com>

commit 9b23e1a3e8fde76e8cc0e366ab1ed4ffb4440feb upstream.

The name of CODEC input widget to which microphone is connected through
the "Headphone" jack is "IN12" not "IN1". This fixes microphone support
on Odroid XU3.

Cc: <stable@vger.kernel.org> # v4.14+
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/exynos5422-odroidxu3-audio.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/exynos5422-odroidxu3-audio.dtsi
+++ b/arch/arm/boot/dts/exynos5422-odroidxu3-audio.dtsi
@@ -22,7 +22,7 @@
 			"Headphone Jack", "HPL",
 			"Headphone Jack", "HPR",
 			"Headphone Jack", "MICBIAS",
-			"IN1", "Headphone Jack",
+			"IN12", "Headphone Jack",
 			"Speakers", "SPKL",
 			"Speakers", "SPKR";
 



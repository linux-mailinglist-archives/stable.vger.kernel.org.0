Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41B262ABBA8
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:32:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732792AbgKIN2r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:28:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:39126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732891AbgKINNS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:13:18 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3374620789;
        Mon,  9 Nov 2020 13:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927597;
        bh=58c/msi/u8d3e2Kp3wEGdUEzAsteqRLN0G+j5akGqGc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tgh9Kwhs5uhS4qeJWF5ftNF/hZZMFPobGgOYgrSv1bgGbyTkKw4g4kdgIpJuGDLL1
         k+7LlWH9KfMsdEs4Oq/4mbocvZKaG5yyfVBHkEXTfs0Muxz91ODz0PVz2Frs24xXyn
         j0Tn8HhKjjCSdpdJIviQbYf76yABBeSc7PRRbOUM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Scott K Logan <logans@cottsay.net>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 43/85] arm64: dts: meson: add missing g12 rng clock
Date:   Mon,  9 Nov 2020 13:55:40 +0100
Message-Id: <20201109125024.659176896@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125022.614792961@linuxfoundation.org>
References: <20201109125022.614792961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Scott K Logan <logans@cottsay.net>

[ Upstream commit a1afbbb0285797e01313779c71287d936d069245 ]

This adds the missing perpheral clock for the RNG for Amlogic G12. As
stated in amlogic,meson-rng.yaml, this isn't always necessary for the
RNG to function, but is better to have in case the clock is disabled for
some reason prior to loading.

Signed-off-by: Scott K Logan <logans@cottsay.net>
Suggested-by: Neil Armstrong <narmstrong@baylibre.com>
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Link: https://lore.kernel.org/r/520a1a8ec7a958b3d918d89563ec7e93a4100a45.camel@cottsay.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
index 1234bc7974294..354ef2f3eac67 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
@@ -167,6 +167,8 @@
 				hwrng: rng@218 {
 					compatible = "amlogic,meson-rng";
 					reg = <0x0 0x218 0x0 0x4>;
+					clocks = <&clkc CLKID_RNG0>;
+					clock-names = "core";
 				};
 			};
 
-- 
2.27.0




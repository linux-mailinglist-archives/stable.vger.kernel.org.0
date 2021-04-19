Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 234333643E3
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239873AbhDSNW6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:22:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:56334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241534AbhDSNUw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:20:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51E59613F5;
        Mon, 19 Apr 2021 13:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838231;
        bh=NBsJ+wVHbhl8jABuRW1CmUiNr4KdoBx5iL1Vsid6tJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jcpv3bsntzj/YiTbWRXt8vJILujJNJFTR9vabt5qp7Uq9wGVzBzX1mB69BBjfyDcS
         xf99fq7c2sXwJ7y7PNZlFhTNfTjzybAvddL6MM7tx68V8InvItlqVD647qPGZUUGng
         a/a1FVtlevvcXAaKNzzN+vkYuwt325W14g3sp9Y0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jernej Skrabec <jernej.skrabec@siol.net>,
        =?UTF-8?q?Cl=C3=A9ment=20P=C3=A9ron?= <peron.clem@gmail.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 091/103] arm64: dts: allwinner: h6: beelink-gs1: Remove ext. 32 kHz osc reference
Date:   Mon, 19 Apr 2021 15:06:42 +0200
Message-Id: <20210419130530.923096484@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130527.791982064@linuxfoundation.org>
References: <20210419130527.791982064@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jernej Skrabec <jernej.skrabec@siol.net>

[ Upstream commit 7a2f6e69e9c1060a7a09c1f8322ccb8d942b3078 ]

Although every Beelink GS1 seems to have external 32768 Hz oscillator,
it works only on one from four tested. There are more reports of RTC
issues elsewhere, like Armbian forum.

One Beelink GS1 owner read RTC osc status register on Android which
shipped with the box. Reported value indicated problems with external
oscillator.

In order to fix RTC and related issues (HDMI-CEC and suspend/resume with
Crust) on all boards, switch to internal oscillator.

Fixes: 32507b868119 ("arm64: dts: allwinner: h6: Move ext. oscillator to board DTs")
Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
Tested-by: Clément Péron <peron.clem@gmail.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://lore.kernel.org/r/20210330184218.279738-1-jernej.skrabec@siol.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/allwinner/sun50i-h6-beelink-gs1.dts | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h6-beelink-gs1.dts b/arch/arm64/boot/dts/allwinner/sun50i-h6-beelink-gs1.dts
index 7c9dbde645b5..e8163c572dab 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h6-beelink-gs1.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h6-beelink-gs1.dts
@@ -289,10 +289,6 @@
 	vcc-pm-supply = <&reg_aldo1>;
 };
 
-&rtc {
-	clocks = <&ext_osc32k>;
-};
-
 &spdif {
 	status = "okay";
 };
-- 
2.30.2




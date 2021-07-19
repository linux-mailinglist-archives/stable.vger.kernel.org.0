Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09DFB3CE5C2
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239888AbhGSPxU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:53:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:47934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346537AbhGSPrU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:47:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0219D6144E;
        Mon, 19 Jul 2021 16:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626712051;
        bh=dQ6jBxel0zs8R32fG0TfjmV0geTMvOiuEXZIOSy8qzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CgSxcQUxAg3sIkm1PzuRsDMGrlBTVpQTGnzdDC9SJprRje+FdwoSW+98oL85nAt31
         Kh3EYvOCEI90IFgT+dv2k3DNATdGITlZ1Az6KNywJJdGeH8ga6k4RzERqwtAiQwLG0
         dkEcVUE/F6vNrT0mjV4IvuyZchSa29f8CqgLqH7g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 224/292] ARM: dts: gemini-rut1xx: remove duplicate ethernet node
Date:   Mon, 19 Jul 2021 16:54:46 +0200
Message-Id: <20210719144950.343872440@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Corentin Labbe <clabbe@baylibre.com>

[ Upstream commit 3d3bb3d27cd371d3edb43eeb1beb8ae4e92a356d ]

Two ethernet node was added by
commit 95220046a62c ("ARM: dts: Add ethernet to a bunch of platforms")
and commit d6d0cef55e5b ("ARM: dts: Add the FOTG210 USB host to Gemini boards")

This patch removes the duplicate one.

Fixes: d6d0cef55e5b ("ARM: dts: Add the FOTG210 USB host to Gemini boards")
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/gemini-rut1xx.dts | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/arch/arm/boot/dts/gemini-rut1xx.dts b/arch/arm/boot/dts/gemini-rut1xx.dts
index 9611ddf06792..08091d2a64e1 100644
--- a/arch/arm/boot/dts/gemini-rut1xx.dts
+++ b/arch/arm/boot/dts/gemini-rut1xx.dts
@@ -125,18 +125,6 @@
 			};
 		};
 
-		ethernet@60000000 {
-			status = "okay";
-
-			ethernet-port@0 {
-				phy-mode = "rgmii";
-				phy-handle = <&phy0>;
-			};
-			ethernet-port@1 {
-				/* Not used in this platform */
-			};
-		};
-
 		usb@68000000 {
 			status = "okay";
 		};
-- 
2.30.2




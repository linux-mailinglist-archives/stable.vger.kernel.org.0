Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B23C44B75A
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344176AbhKIWep (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:34:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:55842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344251AbhKIWcD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:32:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FEB361A89;
        Tue,  9 Nov 2021 22:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496472;
        bh=OXA71uP9NRZyclYMUe01xxTp0HU8RDER5d0J8mQ1w9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uz98yK4bzZsaGzuqyJ6hRGCP5S8I2BvqjtzXicXlPJPNpK5YkbPgb1Bz94xpD73IU
         S8eN9QD+KSkZOqVejgKclvOaWkdmEbJpBqtcnkrLMylOVs/Q2zkB71OzIQ4je3+sh7
         Zr5A279TDQAs5unW7vgHC+ELW5W7N9KBmgfwxIkNscClypEfSf5lFknIo4DDqbKI9p
         SJy3jtiyRL7+EfewZgcQKAAYHF9Oip/5iupvosduThQj6qgmeJwLbelp8yQpBQHzAQ
         b0k5Y70GWhAiysslCk/KHHbAbKvcMpBZ69Ib38eOaKQocu7JMAkmea5Y10oJUCVdAt
         ISujAOr9Ep94g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxime Ripard <maxime@cerno.tech>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        catalin.marinas@arm.com, will.deacon@arm.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 04/50] arm64: dts: allwinner: h5: Fix GPU thermal zone node name
Date:   Tue,  9 Nov 2021 17:20:17 -0500
Message-Id: <20211109222103.1234885-4-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109222103.1234885-1-sashal@kernel.org>
References: <20211109222103.1234885-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit 94a0f2b0e4e0953d8adf319c44244ef7a57de32c ]

The GPU thermal zone is named gpu_thermal. However, the underscore is
an invalid character for a node name and the thermal zone binding
explicitly requires that zones are called *-thermal. Let's fix it.

Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Acked-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://lore.kernel.org/r/20210901091852.479202-48-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi
index 10489e5086956..0ee8a5adf02b0 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi
@@ -204,7 +204,7 @@
 			};
 		};
 
-		gpu_thermal {
+		gpu-thermal {
 			polling-delay-passive = <0>;
 			polling-delay = <0>;
 			thermal-sensors = <&ths 1>;
-- 
2.33.0


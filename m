Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B49FA44B54D
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245440AbhKIWT6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:19:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:40128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245369AbhKIWTr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:19:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C07F611C9;
        Tue,  9 Nov 2021 22:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496220;
        bh=BbpHWivRzZID6ht/Rvo7OXU0ZAbqUhl0w4ryIymsZ2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qWKeYk/SvQW3mSpRmBRJgs4Mbslk9/eAK4nCtJncRwlTF0mD1DeDZq2y+c9POWB8p
         UYJA45bzNBTFE7WVtTRgliRzEUIyt1hwvS99K2A+YGbivPGc7m4asGRR+Qphpm9V/u
         qcqZWRzq9ejIDVcirY0DklwCgWm88seTqaxH5ck7cTiONbwBFX6Qlpf1EMztlm16MM
         okdGY3IAZkHrT9sqp0QX9nCVs+xfowDbACpMP7VJDPH/2C6pi34krbfQSePgQP8bfD
         K2qgb71nvG7jXXVVwHxDtRTpIlv5ySLbcXACM2IrZfyTsnBUEa/v4V2+SJJxp4cclM
         zvU04db3Py1yA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxime Ripard <maxime@cerno.tech>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        catalin.marinas@arm.com, will.deacon@arm.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 05/82] arm64: dts: allwinner: h5: Fix GPU thermal zone node name
Date:   Tue,  9 Nov 2021 17:15:23 -0500
Message-Id: <20211109221641.1233217-5-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221641.1233217-1-sashal@kernel.org>
References: <20211109221641.1233217-1-sashal@kernel.org>
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
index 578a63dedf466..9988e87ea7b3d 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi
@@ -217,7 +217,7 @@
 			};
 		};
 
-		gpu_thermal {
+		gpu-thermal {
 			polling-delay-passive = <0>;
 			polling-delay = <0>;
 			thermal-sensors = <&ths 1>;
-- 
2.33.0


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8638B2A394E
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 02:24:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728079AbgKCBYf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 20:24:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:34778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728029AbgKCBUO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Nov 2020 20:20:14 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2564223EA;
        Tue,  3 Nov 2020 01:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604366413;
        bh=sLdD2WHhyZznq7z3KqCeqdwr5+xOdL5zrp3tEJEMszE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U4z3FbweP6ZigvdgS6MsbXOkCzTANY0acU1ECLFZmBlj93PAn9hTzIun3bVjecMws
         sftvN9u3dQdWXCHo045qFbKqPwBSVvgy2AOuZsAtPvDcuwDMIRT0iZjsIgn7xK19Bl
         ARpe2+GK55X1QtUsYfDX9e69IlA3Dza8njePyGW0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Scott K Logan <logans@cottsay.net>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 04/24] arm64: dts: meson: add missing g12 rng clock
Date:   Mon,  2 Nov 2020 20:19:47 -0500
Message-Id: <20201103012007.183429-4-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201103012007.183429-1-sashal@kernel.org>
References: <20201103012007.183429-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
@@ -167,6 +167,8 @@ apb_efuse: bus@30000 {
 				hwrng: rng@218 {
 					compatible = "amlogic,meson-rng";
 					reg = <0x0 0x218 0x0 0x4>;
+					clocks = <&clkc CLKID_RNG0>;
+					clock-names = "core";
 				};
 			};
 
-- 
2.27.0


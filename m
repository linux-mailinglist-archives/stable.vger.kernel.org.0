Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 645A02A388B
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 02:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbgKCBTi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 20:19:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:33540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727810AbgKCBTe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Nov 2020 20:19:34 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A20AD2225E;
        Tue,  3 Nov 2020 01:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604366374;
        bh=aTsZddXXY6zBpcpU2W7as/OIhERYbm7uhhG5pxtddKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yAbnwBX71fpIWXq1dWxTrNPsLATSoH/0bEoBtXBt7b84GCflpZp+hy8ulrMiQbnx6
         jtRjA66FeoQ7w8AhMsSrUDPEITOp7YGW018AkvLkG+WhubwT8O17utjL0+6ZNGaF6L
         gOr9Uw3picD6Q/Z95FgDZyx5rcKfazfUvcKSfUS8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Scott K Logan <logans@cottsay.net>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org
Subject: [PATCH AUTOSEL 5.8 04/29] arm64: dts: meson: add missing g12 rng clock
Date:   Mon,  2 Nov 2020 20:19:03 -0500
Message-Id: <20201103011928.183145-4-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201103011928.183145-1-sashal@kernel.org>
References: <20201103011928.183145-1-sashal@kernel.org>
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
index 593a006f4b7b3..6ec40af658ba0 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
@@ -247,6 +247,8 @@ apb_efuse: bus@30000 {
 				hwrng: rng@218 {
 					compatible = "amlogic,meson-rng";
 					reg = <0x0 0x218 0x0 0x4>;
+					clocks = <&clkc CLKID_RNG0>;
+					clock-names = "core";
 				};
 			};
 
-- 
2.27.0


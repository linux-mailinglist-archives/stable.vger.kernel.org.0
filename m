Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D58753C8DAB
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236328AbhGNTp0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:45:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:37098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236952AbhGNToo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:44:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EEDA7613F3;
        Wed, 14 Jul 2021 19:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291682;
        bh=E7h3iTt1ipTDM3KLuAmvg0r0tNRIzKUwbHDkdM031/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BfRY4MQvuydqsuLzmoozQx4vY38EX0rPhMSUpuKJeycff3uCHcuRgdldZg2axFwHF
         i2x9uEudnXQ+KXdx552/wUpuFjLvpyskzy3DsU3R3HVJj4XmB+GAX0DoCfxb8wfJfV
         LS+SMYRtgbhz9WXX01vOZ6YdCsa4LWIA08Kl2dgQV+Oy2/O1CMSqgTjR00Fax+W0Ym
         /dKrdDrnmuiw2zNbrrZFJwSpSB8f89iTCuLHHazAW3UtP8kMUwHsdckoXSPyWFekEf
         tsP4FkAWTPYSWG2g0wkScV9KcfW7ZFEbsjmVFTMv6bfqmuJ6b5K8i5/JWt2XfTvxZ7
         hhFx96rRZ/h/w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 032/102] ARM: dts: ux500: Fix orientation of accelerometer
Date:   Wed, 14 Jul 2021 15:39:25 -0400
Message-Id: <20210714194036.53141-32-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194036.53141-1-sashal@kernel.org>
References: <20210714194036.53141-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 4beba4011995a2c44ee27e1d358dc32e6b9211b3 ]

This adds a mounting matrix to the accelerometer
on the TVK1281618 R3.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ste-href-tvk1281618-r3.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/boot/dts/ste-href-tvk1281618-r3.dtsi b/arch/arm/boot/dts/ste-href-tvk1281618-r3.dtsi
index b580397ede83..a143198ef9c0 100644
--- a/arch/arm/boot/dts/ste-href-tvk1281618-r3.dtsi
+++ b/arch/arm/boot/dts/ste-href-tvk1281618-r3.dtsi
@@ -19,6 +19,9 @@ accelerometer@19 {
 					     <19 IRQ_TYPE_EDGE_RISING>;
 				pinctrl-names = "default";
 				pinctrl-0 = <&accel_tvk_mode>;
+				mount-matrix = "0", "-1", "0",
+					       "-1", "0", "0",
+					       "0", "0", "-1";
 			};
 			magnetometer@1e {
 				compatible = "st,lsm303dlm-magn";
-- 
2.30.2


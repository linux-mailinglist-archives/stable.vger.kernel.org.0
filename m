Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1100D2F313E
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 14:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389529AbhALM5D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 07:57:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:53894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388706AbhALM5D (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:57:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D8DB2312F;
        Tue, 12 Jan 2021 12:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456155;
        bh=qRABFwRk2dCFkpe08baA/CnbeKDSjGWKDP3jaT7zd7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OFKtk8NST0wkkz+LSgmeLnWTAEsuZxp5ibitO7+L678zKQuuPmcBiLpn3AH3yOboM
         6VCZjrLH8Sm5CzCwSfCCvvOjTLoO1f3GKGCE7DWU4gTEzdo+Yzko6oSjxcOwatBKPo
         jKrX9I0w8Dq8hypkZUn8WvCQoT3n2yd+eeXdFuKowZB6av6nIKV2dydAHi881si4dj
         nMhAUtKn3H0wxADGJ2aIZwIg8PpEHtKQ1OMxsqal/7vP0aFbz/v4F+g7dc7nwK4rMe
         ++RubA8Jth7qutND2D48VZ1+OAYgAExez2sg5EfS0l+ePxmig2En/8y/vb8jbvUiE7
         tcTc/p14CDXUg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Stephan Gerhold <stephan@gerhold.net>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 15/51] ARM: dts: ux500/golden: Set display max brightness
Date:   Tue, 12 Jan 2021 07:54:57 -0500
Message-Id: <20210112125534.70280-15-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125534.70280-1-sashal@kernel.org>
References: <20210112125534.70280-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 7887cc89d5851cbdec49219e9614beec776af150 ]

A too high brightness by default (default is max) makes the
screen go blank. Set this to 15 as in the Vendor tree.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephan Gerhold <stephan@gerhold.net>
Link: https://lore.kernel.org/r/20201214223413.253893-1-linus.walleij@linaro.org'
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ste-ux500-samsung-golden.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/ste-ux500-samsung-golden.dts b/arch/arm/boot/dts/ste-ux500-samsung-golden.dts
index a1093cb37dc7a..aed1f2d5f2467 100644
--- a/arch/arm/boot/dts/ste-ux500-samsung-golden.dts
+++ b/arch/arm/boot/dts/ste-ux500-samsung-golden.dts
@@ -326,6 +326,7 @@ dsi-controller@a0351000 {
 				panel@0 {
 					compatible = "samsung,s6e63m0";
 					reg = <0>;
+					max-brightness = <15>;
 					vdd3-supply = <&panel_reg_3v0>;
 					vci-supply = <&panel_reg_1v8>;
 					reset-gpios = <&gpio4 11 GPIO_ACTIVE_LOW>;
-- 
2.27.0


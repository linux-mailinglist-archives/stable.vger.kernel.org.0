Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5BEB2FA2FA
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 15:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390939AbhARO1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 09:27:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:39632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389443AbhARLos (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:44:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAC1F22D2C;
        Mon, 18 Jan 2021 11:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970215;
        bh=OdN5lbGQCfpG7Q3hq4ZGHU3rYbQqbB0YsfGMAyDF5xY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cIEL1swbfWWR0Watzk/NbvqybcujMyMjpcznEDTwsHGJBUVTWjm/t3FEzDmhhmrdU
         Qg5UOek7ZxVqEQUL+6MsdIg4lCBAdUkJtZkww7n6TZ8ZKqYiDG5BgepT4CwyJrurTF
         ZITwAmjorTYtqDvDiLxqTvMrCd5GQpSs8L3iRFjA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Stephan Gerhold <stephan@gerhold.net>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 068/152] ARM: dts: ux500/golden: Set display max brightness
Date:   Mon, 18 Jan 2021 12:34:03 +0100
Message-Id: <20210118113356.046346753@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
@@ -326,6 +326,7 @@
 				panel@0 {
 					compatible = "samsung,s6e63m0";
 					reg = <0>;
+					max-brightness = <15>;
 					vdd3-supply = <&panel_reg_3v0>;
 					vci-supply = <&panel_reg_1v8>;
 					reset-gpios = <&gpio4 11 GPIO_ACTIVE_LOW>;
-- 
2.27.0




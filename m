Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 782C03E7F79
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232978AbhHJRkf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:40:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:43990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235271AbhHJRj3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:39:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD2D46112D;
        Tue, 10 Aug 2021 17:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617025;
        bh=uQZg2yJPU33qth7MbzF84g9s18ngRx81XDaZvVJN/Bw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WO9Zn5wA8Sm0uZjTZ+BrCpdsqR6+945lJzyZieqnxmIx8ywymFrMyKy4uXr98dL7+
         uur9t0ur/t0gC+zRayMgbeFp7qne9adJ+y61fkYEWln8UqahZJ4vNQEJ3s0M93vZ2g
         GU2j6RKK4qhX5gfo6yDQjp3HfFrJqv8Z6zDOABKY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 012/135] ARM: dts: imx: Swap M53Menlo pinctrl_power_button/pinctrl_power_out pins
Date:   Tue, 10 Aug 2021 19:29:06 +0200
Message-Id: <20210810172956.087950326@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit 3d9e30a52047f2d464efdfd1d561ae1f707a0286 ]

The pinctrl_power_button/pinctrl_power_out each define single GPIO
pinmux, except it is exactly the other one than the matching gpio-keys
and gpio-poweroff DT nodes use for that functionality. Swap the two
GPIOs to correct this error.

Fixes: 50d29fdb765d ("ARM: dts: imx53: Add power GPIOs on M53Menlo")
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Shawn Guo <shawnguo@kernel.org>
Cc: Fabio Estevam <festevam@gmail.com>
Cc: NXP Linux Team <linux-imx@nxp.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx53-m53menlo.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/imx53-m53menlo.dts b/arch/arm/boot/dts/imx53-m53menlo.dts
index f98691ae4415..d3082b9774e4 100644
--- a/arch/arm/boot/dts/imx53-m53menlo.dts
+++ b/arch/arm/boot/dts/imx53-m53menlo.dts
@@ -388,13 +388,13 @@
 
 		pinctrl_power_button: powerbutgrp {
 			fsl,pins = <
-				MX53_PAD_SD2_DATA2__GPIO1_13		0x1e4
+				MX53_PAD_SD2_DATA0__GPIO1_15		0x1e4
 			>;
 		};
 
 		pinctrl_power_out: poweroutgrp {
 			fsl,pins = <
-				MX53_PAD_SD2_DATA0__GPIO1_15		0x1e4
+				MX53_PAD_SD2_DATA2__GPIO1_13		0x1e4
 			>;
 		};
 
-- 
2.30.2




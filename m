Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C91673E7ECA
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232360AbhHJRfR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:35:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:41468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232973AbhHJRec (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:34:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF58B61058;
        Tue, 10 Aug 2021 17:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628616850;
        bh=636JA/ho/gDE3EQsYbfH67TTiFPzGuZS/rIWlAEom2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hbgPKCdf5AUnE02WNxok1NQfIKbuzavDpq70GJ71MyRWMJry1JGpoZi1MnpT8E3oZ
         0/I/0phljYnv0uuffrsflYlYCpb4kcjpYLWIIgggIqsKvKAztvFd0CfqSivVj/NqRd
         UQZLiLL2dNd+8P+JRciYG9ez52s6xo0QOa8g2oH8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 09/85] ARM: dts: imx: Swap M53Menlo pinctrl_power_button/pinctrl_power_out pins
Date:   Tue, 10 Aug 2021 19:29:42 +0200
Message-Id: <20210810172948.513429281@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172948.192298392@linuxfoundation.org>
References: <20210810172948.192298392@linuxfoundation.org>
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
index 719ed5ca454a..64faf5b46d92 100644
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




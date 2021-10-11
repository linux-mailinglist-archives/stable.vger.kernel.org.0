Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2167C42906C
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238445AbhJKOIN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:08:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:56480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238317AbhJKOFm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:05:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE58460F6E;
        Mon, 11 Oct 2021 13:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960798;
        bh=Uah9RG02gyZ/4ViQNxLFyNklvhf4WWpOsJDQtz3V4Vs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dWNyaVRQnhut7FmihHF/EgHry73EvZ/3P5fuMvxz8TZEVCkJql7dNnAr0CnKMSVFn
         tPCW5wAtfToGItYu5s+KBB8bv1so/Rago/qpqo7XmNdlE59lDE2aaB95C6mUs7FIex
         aZngz43inD9eotTm3KwfxVETb89UbVJSeFI8XPho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 043/151] ARM: dts: imx: Add missing pinctrl-names for panel on M53Menlo
Date:   Mon, 11 Oct 2021 15:45:15 +0200
Message-Id: <20211011134519.242766747@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit c8c1efe14a4aadcfe93a158b1272e48298d2de15 ]

The panel already contains pinctrl-0 phandle, but it is missing
the default pinctrl-names property, so the pin configuration is
ignored. Fill in the missing pinctrl-names property, so the pin
configuration is applied.

Fixes: d81765d693db6 ("ARM: dts: imx53: Update LCD panel node on M53Menlo")
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Shawn Guo <shawnguo@kernel.org>
Cc: Fabio Estevam <festevam@gmail.com>
Cc: NXP Linux Team <linux-imx@nxp.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx53-m53menlo.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/imx53-m53menlo.dts b/arch/arm/boot/dts/imx53-m53menlo.dts
index d3082b9774e4..48adcfd32cea 100644
--- a/arch/arm/boot/dts/imx53-m53menlo.dts
+++ b/arch/arm/boot/dts/imx53-m53menlo.dts
@@ -56,6 +56,7 @@
 	panel {
 		compatible = "edt,etm0700g0dh6";
 		pinctrl-0 = <&pinctrl_display_gpio>;
+		pinctrl-names = "default";
 		enable-gpios = <&gpio6 0 GPIO_ACTIVE_HIGH>;
 
 		port {
-- 
2.33.0




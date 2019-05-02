Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD8D11CD3
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727478AbfEBPZN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:25:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:41346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727476AbfEBPZM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:25:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8DD020449;
        Thu,  2 May 2019 15:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556810712;
        bh=AjiXTbQ+wFTjj3aP/Q6+dQXyutOY9jFe48P2zMrHrsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gy+erdd7dQdhoC+oM7J1cUk1agt5BjGyKXDHu5MH+u2Gh/BhxfLJ1AZSLEbl5Fwkd
         v7HtYd3O69/lS6ZYY5jMWLJjxHDp4Xg4Hnmpml+9H4lfGzcuaczFtj1AUGhxp+a1jH
         UQ/tdVIf1ynyl8CRJ3i8NvOEZJcbxzrUH3GLbBQU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masanari Iida <standby24x7@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 4.14 31/49] ARM: dts: imx6qdl: Fix typo in imx6qdl-icore-rqs.dtsi
Date:   Thu,  2 May 2019 17:21:08 +0200
Message-Id: <20190502143327.822226131@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143323.397051088@linuxfoundation.org>
References: <20190502143323.397051088@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 41b37f4c0fa67185691bcbd30201cad566f2f0d1 ]

This patch fixes a spelling typo.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
Fixes: cc42603de320 ("ARM: dts: imx6q-icore-rqs: Add Engicam IMX6 Q7 initial support")
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6qdl-icore-rqs.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/imx6qdl-icore-rqs.dtsi b/arch/arm/boot/dts/imx6qdl-icore-rqs.dtsi
index 7ca291e9dbdb..80f1b3fb6abc 100644
--- a/arch/arm/boot/dts/imx6qdl-icore-rqs.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-icore-rqs.dtsi
@@ -222,7 +222,7 @@
 	pinctrl-2 = <&pinctrl_usdhc3_200mhz>;
 	vmcc-supply = <&reg_sd3_vmmc>;
 	cd-gpios = <&gpio1 1 GPIO_ACTIVE_LOW>;
-	bus-witdh = <4>;
+	bus-width = <4>;
 	no-1-8-v;
 	status = "okay";
 };
@@ -233,7 +233,7 @@
 	pinctrl-1 = <&pinctrl_usdhc4_100mhz>;
 	pinctrl-2 = <&pinctrl_usdhc4_200mhz>;
 	vmcc-supply = <&reg_sd4_vmmc>;
-	bus-witdh = <8>;
+	bus-width = <8>;
 	no-1-8-v;
 	non-removable;
 	status = "okay";
-- 
2.19.1




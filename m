Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 782E31016E5
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730924AbfKSFwA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:52:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:49558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728603AbfKSFv5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:51:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E48AC208C3;
        Tue, 19 Nov 2019 05:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142717;
        bh=J5MJjxD5jAeVkjz/fx+zVxhI7b1OTA8vjQiUHrSwREs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mGXCwo0C3NnUtqRyv3+DyySsmnrUF4uQkHIYTULMydMRci8whi34iODYJaIhmp5Wg
         FiIiC3tf7X1KBCoWRmBCHUAHjWA2uCuULZt+RoQzYd9e7D+poD7mYegyuJRS8xGWJj
         vD6cHLWx1VTI9KCkc+8FmleFEpmegpeDkm+n41lI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 169/239] ARM: dts: clearfog: fix sdhci supply property name
Date:   Tue, 19 Nov 2019 06:19:29 +0100
Message-Id: <20191119051333.872849565@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baruch Siach <baruch@tkos.co.il>

[ Upstream commit e807f0298144c06740022a2f900d86b7f115595e ]

The vmmc phandle, like all power supply property names, must have the
'-supply' suffix.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/armada-388-clearfog.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/armada-388-clearfog.dtsi b/arch/arm/boot/dts/armada-388-clearfog.dtsi
index 68acfc9687069..8a3bbb7d6cc10 100644
--- a/arch/arm/boot/dts/armada-388-clearfog.dtsi
+++ b/arch/arm/boot/dts/armada-388-clearfog.dtsi
@@ -89,7 +89,7 @@
 					     &clearfog_sdhci_cd_pins>;
 				pinctrl-names = "default";
 				status = "okay";
-				vmmc = <&reg_3p3v>;
+				vmmc-supply = <&reg_3p3v>;
 				wp-inverted;
 			};
 
-- 
2.20.1




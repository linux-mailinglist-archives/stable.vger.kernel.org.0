Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 823E5F650D
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729203AbfKJCq5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:46:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:51630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729201AbfKJCq5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:46:57 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEE5E21850;
        Sun, 10 Nov 2019 02:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573354016;
        bh=J5MJjxD5jAeVkjz/fx+zVxhI7b1OTA8vjQiUHrSwREs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BBgG9UGsRu7h95TVaP2Dq5NcXd6gXbuOCA8ovjeM9dQhM39iH/2RNLZZ7WQKCV1Ot
         C5USzKibgvw8lE7Bu6TBkm+6K5PlUvLnpnWZaAHhxmpQpjOUg6IuVBPGelIpbxPVFl
         tfbZXTQ/tHeP06XfF9fWnKg6/xCbiBaZoV8xL3EI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Baruch Siach <baruch@tkos.co.il>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 040/109] ARM: dts: clearfog: fix sdhci supply property name
Date:   Sat,  9 Nov 2019 21:44:32 -0500
Message-Id: <20191110024541.31567-40-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024541.31567-1-sashal@kernel.org>
References: <20191110024541.31567-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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


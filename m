Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA18445C3E8
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:41:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351086AbhKXNom (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:44:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:37400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353544AbhKXNn3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:43:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CF5760E98;
        Wed, 24 Nov 2021 12:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758730;
        bh=ig/lQmlHcJkyan3DclMOIznNcfL9Fqkv3BZFekULDyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CGeUImk3xnUV7bvUgnd/Nztc0otvEYTYyA+MiEWaw1NVWT75D2mt5smjnaXxjYsEN
         8HxlNW7Scs0zHfibENSX8RVidOdSSkAe8KeoOGJhKitf/ovcXUjprVdPxe1RXncvGv
         iogtdo+Eo+CXOO6ZajjOUb/gR3/7IU0yi8Nzzvco=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 011/279] arm64: dts: broadcom: bcm4908: Move reboot syscon out of bus
Date:   Wed, 24 Nov 2021 12:54:58 +0100
Message-Id: <20211124115719.142912635@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit 6cf9f70255b90b540b9cbde062f18fea29024a75 ]

This fixes following error for every bcm4908 DTS file:
bus@ff800000: reboot: {'type': 'object'} is not allowed for {'compatible': ['syscon-reboot'], 'regmap': [[15]], 'offset': [[52]], 'mask': [[1]]}

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi b/arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi
index f6b93bbb49228..5118816b1ed76 100644
--- a/arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi
+++ b/arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi
@@ -326,12 +326,12 @@
 				#reset-cells = <1>;
 			};
 		};
+	};
 
-		reboot {
-			compatible = "syscon-reboot";
-			regmap = <&timer>;
-			offset = <0x34>;
-			mask = <1>;
-		};
+	reboot {
+		compatible = "syscon-reboot";
+		regmap = <&timer>;
+		offset = <0x34>;
+		mask = <1>;
 	};
 };
-- 
2.33.0




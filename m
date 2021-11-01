Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81E8744169F
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:26:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232253AbhKAJ1Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:27:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:59152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232492AbhKAJY4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:24:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 691B3610E8;
        Mon,  1 Nov 2021 09:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758496;
        bh=EyVhYykjNsNJaeHThoyuDdJZpI/45o5n5Mwbt2kBEr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WVbXZxVOZJZ+/muDMPADLnGmRhxk3JXjj78+ugby9luMtRIV0COIqZflW+aRKGPAz
         +BKSHiDUyl0o3RdhvFBgoC0EtlBItQ/ic6o1bi935G8B8tsD/HJ+JueBb5QkyTo7Zj
         ExSP5GEkqHQwQ2q8HR0slFpLCcgCXSPlQbd53eZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Cl=C3=A9ment=20B=C5=93sch?= <u@pkh.me>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Maxime Ripard <maxime@cerno.tech>
Subject: [PATCH 4.19 23/35] arm64: dts: allwinner: h5: NanoPI Neo 2: Fix ethernet node
Date:   Mon,  1 Nov 2021 10:17:35 +0100
Message-Id: <20211101082457.023981695@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082451.430720900@linuxfoundation.org>
References: <20211101082451.430720900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Clément Bœsch <u@pkh.me>

commit 0764e365dacd0b8f75c1736f9236be280649bd18 upstream.

RX and TX delay are provided by ethernet PHY. Reflect that in ethernet
node.

Fixes: 44a94c7ef989 ("arm64: dts: allwinner: H5: Restore EMAC changes")
Signed-off-by: Clément Bœsch <u@pkh.me>
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://lore.kernel.org/r/20210905002027.171984-1-u@pkh.me
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/allwinner/sun50i-h5-nanopi-neo2.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/allwinner/sun50i-h5-nanopi-neo2.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h5-nanopi-neo2.dts
@@ -114,7 +114,7 @@
 	pinctrl-0 = <&emac_rgmii_pins>;
 	phy-supply = <&reg_gmac_3v3>;
 	phy-handle = <&ext_rgmii_phy>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 	status = "okay";
 };
 



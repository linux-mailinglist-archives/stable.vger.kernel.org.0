Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B84E4441792
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233067AbhKAJht (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:37:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:43580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232342AbhKAJfq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:35:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B53F8611AF;
        Mon,  1 Nov 2021 09:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758756;
        bh=iYzB8uoi1sGWZCZS/I4pYim9/2xbkFY0MsMsRt2QZkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kFOlepsHKZvsr9CsX5USaNocnTHsEktUSNgoYFFUIE1yC4Gpx4Z6JT40bvBp9OmoQ
         weo1RG7/YmtlwJ52rSHP49x/nv4ne9vQ7NkloA4v4cYLflA/S692R4CjXaWmu+15QL
         GoN8GlrxOwAn+LMVtPoyNk6u/C4NkHF0f8a2XYBo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Cl=C3=A9ment=20B=C5=93sch?= <u@pkh.me>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Maxime Ripard <maxime@cerno.tech>
Subject: [PATCH 5.10 46/77] arm64: dts: allwinner: h5: NanoPI Neo 2: Fix ethernet node
Date:   Mon,  1 Nov 2021 10:17:34 +0100
Message-Id: <20211101082521.513840405@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082511.254155853@linuxfoundation.org>
References: <20211101082511.254155853@linuxfoundation.org>
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
@@ -75,7 +75,7 @@
 	pinctrl-0 = <&emac_rgmii_pins>;
 	phy-supply = <&reg_gmac_3v3>;
 	phy-handle = <&ext_rgmii_phy>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 	status = "okay";
 };
 



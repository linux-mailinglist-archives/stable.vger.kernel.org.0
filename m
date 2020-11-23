Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFBD42C0698
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731125AbgKWMcp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:32:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:43988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731117AbgKWMcl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:32:41 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2403920888;
        Mon, 23 Nov 2020 12:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134760;
        bh=7ZpuectY38jz0qndGQ4BhQ8W5m7X9JBRlN7ZxMBO6kw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T0fsmSKOl8qvMKJ4C/MNyMf6zAZ1b69s5kJzGP322xkSXbzRe5afXogZNrFsh/Rp0
         TDEzOwrWb6FIY+FGVdmB3RcRkaQZ3rkyk9c9IvfuBPsmUL6sQBZNOl2DZ860RmKMkI
         nM960reBn+PW7L5p8lLk/7BBBsds1XJvWyX18tWM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nenad Peric <nperic@gmail.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 42/91] arm64: dts: allwinner: h5: OrangePi Prime: Fix ethernet node
Date:   Mon, 23 Nov 2020 13:22:02 +0100
Message-Id: <20201123121811.360155548@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121809.285416732@linuxfoundation.org>
References: <20201123121809.285416732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nenad Peric <nperic@gmail.com>

[ Upstream commit 107954afc5df667da438644aa4982606663f9b17 ]

RX and TX delay are provided by ethernet PHY. Reflect that in ethernet
node.

Fixes: 44a94c7ef989 ("arm64: dts: allwinner: H5: Restore EMAC changes")
Signed-off-by: Nenad Peric <nperic@gmail.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Acked-by: Jernej Skrabec <jernej.skrabec@siol.net>
Link: https://lore.kernel.org/r/20201028115817.68113-1-nperic@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/allwinner/sun50i-h5-orangepi-prime.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h5-orangepi-prime.dts b/arch/arm64/boot/dts/allwinner/sun50i-h5-orangepi-prime.dts
index b75ca4d7d0019..7a30211d59ef5 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h5-orangepi-prime.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h5-orangepi-prime.dts
@@ -164,7 +164,7 @@
 	pinctrl-0 = <&emac_rgmii_pins>;
 	phy-supply = <&reg_gmac_3v3>;
 	phy-handle = <&ext_rgmii_phy>;
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-id";
 	status = "okay";
 };
 
-- 
2.27.0




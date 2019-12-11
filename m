Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37ABF11B531
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:52:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732405AbfLKPVB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:21:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:50890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731850AbfLKPVB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:21:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 191FD2467A;
        Wed, 11 Dec 2019 15:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077660;
        bh=Akr5z4nXc7Wq89WJ0i/DW8zdQvzfWbQSOGyngKtx9zE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wq0/Yt4hhxvRdNOJTqO2iKXVNsXJZ8sTha127JQWj1EORaCAdviQ2/AKTXua9IrAV
         iKAJcyfXuXMc0QzfXH7JTTSgCYXUqtnP8RrcO4BlpZkCFsMg2m67o+OmG88hU1jfAl
         QV2HTfZfAJiffDrmEDZEwfYOyjJjVWcU1Qhj2+I8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 123/243] ARM: dts: sun4i: Fix HDMI output DTC warning
Date:   Wed, 11 Dec 2019 16:04:45 +0100
Message-Id: <20191211150347.434243635@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime.ripard@bootlin.com>

[ Upstream commit 123b796d3fac60d69a3737d81901ab483c4efd6e ]

Our HDMI output endpoint on the A10 DTSI has a warning under DTC: "graph
node has single child node 'endpoint', #address-cells/#size-cells are not
necessary". Fix this by removing those properties.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
Acked-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/sun4i-a10.dtsi | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/boot/dts/sun4i-a10.dtsi b/arch/arm/boot/dts/sun4i-a10.dtsi
index 3d62a89507207..5d46bb0139fad 100644
--- a/arch/arm/boot/dts/sun4i-a10.dtsi
+++ b/arch/arm/boot/dts/sun4i-a10.dtsi
@@ -530,8 +530,6 @@
 				};
 
 				hdmi_out: port@1 {
-					#address-cells = <1>;
-					#size-cells = <0>;
 					reg = <1>;
 				};
 			};
-- 
2.20.1




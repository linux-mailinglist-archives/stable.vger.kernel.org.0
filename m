Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5E911B4F3
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732614AbfLKPuW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:50:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:54416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732163AbfLKPXZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:23:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A75B52073D;
        Wed, 11 Dec 2019 15:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077805;
        bh=Jl4QxbO6L+qoP/p1ka54CawFUBq3dsH+5MInaQdTOIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y1OKR1QMN0VlFF+eJGzNn43pbPkvCCC6HLPTq2Ft8ots8fbrK/za3rmsIP6yo92rf
         eRNo1TmaJeWM/AUhAlaWAIowIkoGN8ENSaNDqaeANd+JOHPc57UgIhizXMCo7znu1n
         Eb4KR/HzLqsMoleu3RtbJRntZbjt9t2Js0sKvVqo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 177/243] ARM: dts: sun8i: h3: Fix the system-control register range
Date:   Wed, 11 Dec 2019 16:05:39 +0100
Message-Id: <20191211150351.120418760@linuxfoundation.org>
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

From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

[ Upstream commit 925c5afd78c40169c7e0e6adec52d5119ff43751 ]

Unlike in previous generations, the system-control register range is not
limited to a size of 0x30 on the H3. In particular, the EMAC clock
configuration register (accessed through syscon) is at offset 0x30 in
that range.

Extend the register size to its full range (0x1000) as a result.

Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Acked-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/sun8i-h3.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/sun8i-h3.dtsi b/arch/arm/boot/dts/sun8i-h3.dtsi
index 97de6ad133dc2..9233ba30a857c 100644
--- a/arch/arm/boot/dts/sun8i-h3.dtsi
+++ b/arch/arm/boot/dts/sun8i-h3.dtsi
@@ -122,7 +122,7 @@
 	soc {
 		system-control@1c00000 {
 			compatible = "allwinner,sun8i-h3-system-control";
-			reg = <0x01c00000 0x30>;
+			reg = <0x01c00000 0x1000>;
 			#address-cells = <1>;
 			#size-cells = <1>;
 			ranges;
-- 
2.20.1




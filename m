Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 746F32E642F
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:48:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404296AbgL1Nmq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:42:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:43214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404293AbgL1Nmp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:42:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9E242063A;
        Mon, 28 Dec 2020 13:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162925;
        bh=7ijiIkXtaoRTd8+ztD5P0ZqMup1IJAUZ6lADCB6sOBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ux5W6ludb3kwlVf+7bLXqyBbqAPomc9LswdqzV6YenrqeNtu0/jxedYpHXMnLszb7
         AG2MMQef95o2zEzVjnsZOlvlJKkBQykZg8rpZqX/TihQ56cIas6J1znD6HuPfpG9FT
         WBlNLpIJFACv0vdalBHNP1VyJgiq6MzTdAeyIWvU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Biju Das <biju.das.jz@bp.renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 077/453] arm64: dts: renesas: hihope-rzg2-ex: Drop rxc-skew-ps from ethernet-phy node
Date:   Mon, 28 Dec 2020 13:45:13 +0100
Message-Id: <20201228124940.944244812@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit 67d3dcf12a3d245b6fd6ca5672893f7ae4e137ed ]

HiHope RZG2[HMN] boards uses Realtek phy and the driver does not support
rxc-skew-ps property. So remove rxc-skew-ps from ethernet-phy node.

Fixes: 7433f1fb8ec8fe ("arm64: dts: renesas: Add HiHope RZ/G2M sub board support")
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Link: https://lore.kernel.org/r/20201015132350.8360-1-biju.das.jz@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/hihope-rzg2-ex.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/renesas/hihope-rzg2-ex.dtsi b/arch/arm64/boot/dts/renesas/hihope-rzg2-ex.dtsi
index 4280b190dc682..6a001cdfd38e2 100644
--- a/arch/arm64/boot/dts/renesas/hihope-rzg2-ex.dtsi
+++ b/arch/arm64/boot/dts/renesas/hihope-rzg2-ex.dtsi
@@ -23,7 +23,6 @@
 	status = "okay";
 
 	phy0: ethernet-phy@0 {
-		rxc-skew-ps = <1500>;
 		reg = <0>;
 		interrupt-parent = <&gpio2>;
 		interrupts = <11 IRQ_TYPE_LEVEL_LOW>;
-- 
2.27.0




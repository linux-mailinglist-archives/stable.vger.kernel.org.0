Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA413451452
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344228AbhKOUCe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:02:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:45214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344272AbhKOTYR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2608B6331A;
        Mon, 15 Nov 2021 18:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002497;
        bh=ktiQlAr03wTODgE0WDOZ329NnHLJV/l+gP1tWQzDaZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1l4cSKKLduvufFB30Dr1hkGN1p5sPm0Q7HQJ2t5sOzBBb7HC9yxsmsUYaXG7z5x57
         icPHuklboaRCGOzkAVgXVSo1rnigou103ABHz5R44msVa3/WnvyfW0O4rw4Ox4KUPE
         hxx/ThZTJQ/T88O/XJ5bRkmwiTiMWurC2DhkBo3U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Rosin <peda@axentia.se>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 588/917] ARM: dts: at91: tse850: the emac<->phy interface is rmii
Date:   Mon, 15 Nov 2021 18:01:23 +0100
Message-Id: <20211115165448.705065541@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Rosin <peda@axentia.se>

[ Upstream commit dcdbc335a91a26e022a803e1a6b837266989c032 ]

This went unnoticed until commit 7897b071ac3b ("net: macb: convert
to phylink") which tickled the problem. The sama5d3 emac has never
been capable of rgmii, and it all just happened to work before that
commit.

Fixes: 21dd0ece34c2 ("ARM: dts: at91: add devicetree for the Axentia TSE-850")
Signed-off-by: Peter Rosin <peda@axentia.se>
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/ea781f5e-422f-6cbf-3cf4-d5a7bac9392d@axentia.se
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/at91-tse850-3.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/at91-tse850-3.dts b/arch/arm/boot/dts/at91-tse850-3.dts
index 3ca97b47c69ce..7e5c598e7e68f 100644
--- a/arch/arm/boot/dts/at91-tse850-3.dts
+++ b/arch/arm/boot/dts/at91-tse850-3.dts
@@ -262,7 +262,7 @@
 &macb1 {
 	status = "okay";
 
-	phy-mode = "rgmii";
+	phy-mode = "rmii";
 
 	#address-cells = <1>;
 	#size-cells = <0>;
-- 
2.33.0




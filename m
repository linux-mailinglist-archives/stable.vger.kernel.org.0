Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C737945C069
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:04:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347440AbhKXNHt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:07:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:45426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346997AbhKXNFr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:05:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E9196109E;
        Wed, 24 Nov 2021 12:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757474;
        bh=4GxYLiRu0/5cGEZFA0a/FmoW1A58lQKwN3F1JsBlUKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qu7bCN/yV02mHJk45Qz7bP6KI3oE36BiHPJQBKXtNIBuCDz/40HNtr4pwHRvP05Lk
         mNOcTH6Ygb846pQrqlhnPEqtfMNawdiyx3ZHzw+UgwlUK8fpjn2nkPWft0yS1pR/hy
         oP1xXemEBYIpnfvvlKEQu437G7+RJtJwONhrSRXQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Rosin <peda@axentia.se>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 180/323] ARM: dts: at91: tse850: the emac<->phy interface is rmii
Date:   Wed, 24 Nov 2021 12:56:10 +0100
Message-Id: <20211124115725.024469156@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
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
index 2fbec69d9cd68..6b2be520066e2 100644
--- a/arch/arm/boot/dts/at91-tse850-3.dts
+++ b/arch/arm/boot/dts/at91-tse850-3.dts
@@ -269,7 +269,7 @@
 &macb1 {
 	status = "okay";
 
-	phy-mode = "rgmii";
+	phy-mode = "rmii";
 
 	#address-cells = <1>;
 	#size-cells = <0>;
-- 
2.33.0




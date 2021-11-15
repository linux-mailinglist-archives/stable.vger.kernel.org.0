Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFD48450BE0
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:28:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237952AbhKORay (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:30:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:53206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238049AbhKOR2t (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:28:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C75E163292;
        Mon, 15 Nov 2021 17:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996776;
        bh=ktiQlAr03wTODgE0WDOZ329NnHLJV/l+gP1tWQzDaZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=veIAm4Uc1574pMT97f9mtSmOSE9W8EJgSa2DK6U7un9D5CEBti43UfCIPc3W6/PFL
         3ptaO55WfXhAEVmVLJim4VnEIbJnZKJC0t9CdIsXSesykOT5MaDV2lkAdxlV5GbmCW
         X21kw6jfhohh/qjuy0XaawktOlQDR85d3sCobGdw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Rosin <peda@axentia.se>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 263/355] ARM: dts: at91: tse850: the emac<->phy interface is rmii
Date:   Mon, 15 Nov 2021 18:03:07 +0100
Message-Id: <20211115165322.243916856@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
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




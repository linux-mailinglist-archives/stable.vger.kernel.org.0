Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7D23C8DB9
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236898AbhGNTpd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:45:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:38034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236464AbhGNTo4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:44:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF311613EA;
        Wed, 14 Jul 2021 19:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291696;
        bh=61zfSRzG8fZ7cjyr30XK1KAYJ+D4Q/kZXSuqGCbjFjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rbJUXTe7aEeAqHfl6DO9VY2aAMUPlmveXnBpjuPgsxQzLJUZv5iABe8px0UDQQjsU
         HNsr27lbWn5ivQF7bOehaK1VKe63aW01rMBoCurATrga1V8BNG7jmIQirAcMdFBthP
         WC4X3GWwhAIAUYbhGwOzfk2yijRcffxnQ1jLSsm2WtbYP1WzPuRShjhcXySQfHciJn
         SzVNzXO6HHrB5hgRA1Cq3XNQeo++u+eROJW6e0b9VH5CTJ6kKjtjnggpRaFUGYIZZ2
         +b7kg0EXXE2pQOC7YbJg3j/6C5Qzhx8QCxTI0hzYDh0EbX9Z2m5lwDehoWEkStyzYX
         hU2y5miYzk4og==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 043/102] ARM: dts: omap5-board-common: align gpio hog names with dt-schema
Date:   Wed, 14 Jul 2021 15:39:36 -0400
Message-Id: <20210714194036.53141-43-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194036.53141-1-sashal@kernel.org>
References: <20210714194036.53141-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

[ Upstream commit 4823117cb80eedf31ddbc126b9bd92e707bd9a26 ]

The GPIO Hog dt-schema node naming convention expect GPIO hogs node names
to end with a 'hog' suffix.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/omap5-board-common.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/omap5-board-common.dtsi b/arch/arm/boot/dts/omap5-board-common.dtsi
index d8f13626cfd1..45435bb88c89 100644
--- a/arch/arm/boot/dts/omap5-board-common.dtsi
+++ b/arch/arm/boot/dts/omap5-board-common.dtsi
@@ -149,7 +149,7 @@ sound: sound {
 
 &gpio8 {
 	/* TI trees use GPIO instead of msecure, see also muxing */
-	p234 {
+	msecure-hog {
 		gpio-hog;
 		gpios = <10 GPIO_ACTIVE_HIGH>;
 		output-high;
-- 
2.30.2


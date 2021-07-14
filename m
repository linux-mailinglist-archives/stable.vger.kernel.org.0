Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB513C9171
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 22:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235311AbhGNUBe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 16:01:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:49182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241366AbhGNTwS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:52:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB81061408;
        Wed, 14 Jul 2021 19:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626292122;
        bh=hlH8BbQ65qD6St2GHLj3WZH2zz2r3k/1PkdScImkti8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q+PEnQn5F4frtYwARcXX1AJGlmXJf0zFvkFGMR+o/PHDaqyelCrUuklutXGqEnsFE
         riCjk6b0zQX9LOmVW9+5nIcQnGo08hwM8Al4OJly4SpP8RTrud6kCH+1v/ED3BABAy
         tLygNvyIY/Ns+5NmJdJMd1mZ4HMoR9mkmFsPHgFrZek57XO06My3A0AO9IbavvGDZB
         y1teI4A1GVjJ1dNNNGVZKJ11Ac1EevLvSZwhiXC38aoWMZwCAGp/3ZVkgk5CbqeNDV
         +47g/jMBaD5lw2chOpnHvbOak7QTrZgtHOiXf1iiAcY1EuzoGWtHCn8JQGntDBix7S
         PSr+S7eI1PBcw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 06/10] ARM: dts: omap5-board-common: align gpio hog names with dt-schema
Date:   Wed, 14 Jul 2021 15:48:29 -0400
Message-Id: <20210714194833.56197-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194833.56197-1-sashal@kernel.org>
References: <20210714194833.56197-1-sashal@kernel.org>
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
index 41e80e7f20be..282d393b63b6 100644
--- a/arch/arm/boot/dts/omap5-board-common.dtsi
+++ b/arch/arm/boot/dts/omap5-board-common.dtsi
@@ -132,7 +132,7 @@ sound: sound {
 
 &gpio8 {
 	/* TI trees use GPIO instead of msecure, see also muxing */
-	p234 {
+	msecure-hog {
 		gpio-hog;
 		gpios = <10 GPIO_ACTIVE_HIGH>;
 		output-high;
-- 
2.30.2


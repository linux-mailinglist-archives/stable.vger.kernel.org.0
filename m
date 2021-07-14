Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C48053C8FF0
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240581AbhGNTxi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:53:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240689AbhGNTuA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:50:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A6DA61444;
        Wed, 14 Jul 2021 19:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291950;
        bh=RywVA5kS/dV0wQVIaIAAO3/ObrcdDAxQv/OEKJ/WeeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oTeqnM/M1qJj/YcNN667x2WqqRaGvBkqVdLcB2ev5qYe7ZWZgr2oT+D4VHg5aX4ef
         /j2i64w+A7fREst75ShBbKnm8gjoS4MQslLHr6k+oqKS5DqGsl022hUGUht4A8rxjH
         gxu5hdNQABNQpNRDiMtkXGL6xYuM5t/oqOp0fAWNbylGaRuLphwvwEqB00Rb+9GL0I
         y5ZMXOIkueStWi5uYXwYQyx+wPDSycAomDTwQp9pA+e27eqPNf7tws1y8v/qiBcI0b
         XB0qkb/G2VZ/OYj71U7mf7F40APSW/lhieiiAh32FAJ5yAJBA/Q2XInV2U+v7Pj0jQ
         Bce6j3BF5b3sg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 26/51] ARM: dts: omap5-board-common: align gpio hog names with dt-schema
Date:   Wed, 14 Jul 2021 15:44:48 -0400
Message-Id: <20210714194513.54827-26-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194513.54827-1-sashal@kernel.org>
References: <20210714194513.54827-1-sashal@kernel.org>
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
index 68ac04641bdb..c73f32e8ca0f 100644
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


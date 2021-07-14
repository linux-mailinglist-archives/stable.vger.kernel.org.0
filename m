Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1933F3C9051
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 22:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241360AbhGNTyT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:54:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:46244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241118AbhGNTuY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:50:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1DF94613DB;
        Wed, 14 Jul 2021 19:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626292015;
        bh=fBiXEbNjIL03Ae+xmjpisMHK+pbo5kCF/pSDV8lG4s4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tBv1ED8WskqwXDN7Cxl7sFmRG4DiacUuk9hEvaUFfpqsG0qV2Q+KIMAz6EmLSeGfu
         vr9R3NDZjlJ4RUQqFdoj1JQyLFwihaW4Vep3GiN40pNgHAWAcbS5xuciM2Jn9qwm1u
         uRnyx/FHeh2v0ySzP3W252xc52ThnewP5rK0UmnHlG05k94o+E5yqR5NekB+UoETpp
         ueauXvsY7JU8HVaAFmWgFD/MYn4pjWv7hX+WQ21dDqcx39VdRuA8RkddaiDZcQXIOK
         7h4NWBYfsNZqNEwQX+vnoEYmaA9D9igvzRxC8JJNXmbmOoympvvFjdro+xDR18cNET
         1Dq/YOw6pcV2g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 21/39] ARM: dts: omap5-board-common: align gpio hog names with dt-schema
Date:   Wed, 14 Jul 2021 15:46:06 -0400
Message-Id: <20210714194625.55303-21-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194625.55303-1-sashal@kernel.org>
References: <20210714194625.55303-1-sashal@kernel.org>
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
index 61a06f6add3c..1d7f497e8ffb 100644
--- a/arch/arm/boot/dts/omap5-board-common.dtsi
+++ b/arch/arm/boot/dts/omap5-board-common.dtsi
@@ -152,7 +152,7 @@ sound: sound {
 
 &gpio8 {
 	/* TI trees use GPIO instead of msecure, see also muxing */
-	p234 {
+	msecure-hog {
 		gpio-hog;
 		gpios = <10 GPIO_ACTIVE_HIGH>;
 		output-high;
-- 
2.30.2


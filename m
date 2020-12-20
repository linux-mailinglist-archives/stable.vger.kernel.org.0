Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBDC2DF313
	for <lists+stable@lfdr.de>; Sun, 20 Dec 2020 04:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727875AbgLTDgP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 22:36:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:58002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727841AbgLTDgP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Dec 2020 22:36:15 -0500
From:   Sasha Levin <sashal@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul Kocialkowski <contact@paulk.fr>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 1/6] ARM: sunxi: Add machine match for the Allwinner V3 SoC
Date:   Sat, 19 Dec 2020 22:35:06 -0500
Message-Id: <20201220033511.2728659-1-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Kocialkowski <contact@paulk.fr>

[ Upstream commit ad2091f893bd5dfe2824f0d6819600d120698e9f ]

The Allwinner V3 SoC shares the same base as the V3s but comes with
extra pins and features available. As a result, it has its dedicated
compatible string (already used in device trees), which is added here.

Signed-off-by: Paul Kocialkowski <contact@paulk.fr>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://lore.kernel.org/r/20201031182137.1879521-2-contact@paulk.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-sunxi/sunxi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-sunxi/sunxi.c b/arch/arm/mach-sunxi/sunxi.c
index de4b0e932f22e..aa08b8cb01524 100644
--- a/arch/arm/mach-sunxi/sunxi.c
+++ b/arch/arm/mach-sunxi/sunxi.c
@@ -66,6 +66,7 @@ static const char * const sun8i_board_dt_compat[] = {
 	"allwinner,sun8i-h2-plus",
 	"allwinner,sun8i-h3",
 	"allwinner,sun8i-r40",
+	"allwinner,sun8i-v3",
 	"allwinner,sun8i-v3s",
 	NULL,
 };
-- 
2.27.0


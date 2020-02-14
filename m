Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5551415ED19
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392218AbgBNRb7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:31:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:57640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390534AbgBNQGy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:06:54 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B36624676;
        Fri, 14 Feb 2020 16:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696413;
        bh=c2FN921kY1CefLsiWaCjWz6K+vYQcvTloLawxS3AYGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uHTFnNG8cyHaFmEM9nJpRYZwBy9OPdOq5T2lWvOQnvbEF6za4W3o4yewGZR0x75Pk
         +PnxVt1LiTgDFzFlTVE9Jh6S2ZbuRjYYVGLAobsuGCmnSHlkoAl4HTFS8dKXDb27SP
         iQTmroX6DdzbX/WDGYLSlUAk6CH3y5dqh1fVzG4g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 235/459] pinctrl: sh-pfc: r8a7778: Fix duplicate SDSELF_B and SD1_CLK_B
Date:   Fri, 14 Feb 2020 10:58:05 -0500
Message-Id: <20200214160149.11681-235-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 805f635703b2562b5ddd822c62fc9124087e5dd5 ]

The FN_SDSELF_B and FN_SD1_CLK_B enum IDs are used twice, which means
one set of users must be wrong.  Replace them by the correct enum IDs.

Fixes: 87f8c988636db0d4 ("sh-pfc: Add r8a7778 pinmux support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20191218194812.12741-2-geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sh-pfc/pfc-r8a7778.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/sh-pfc/pfc-r8a7778.c b/drivers/pinctrl/sh-pfc/pfc-r8a7778.c
index 24866a5958aee..a9875038ed9b6 100644
--- a/drivers/pinctrl/sh-pfc/pfc-r8a7778.c
+++ b/drivers/pinctrl/sh-pfc/pfc-r8a7778.c
@@ -2305,7 +2305,7 @@ static const struct pinmux_cfg_reg pinmux_config_regs[] = {
 		FN_ATAG0_A,	0,		FN_REMOCON_B,	0,
 		/* IP0_11_8 [4] */
 		FN_SD1_DAT2_A,	FN_MMC_D2,	0,		FN_BS,
-		FN_ATADIR0_A,	0,		FN_SDSELF_B,	0,
+		FN_ATADIR0_A,	0,		FN_SDSELF_A,	0,
 		FN_PWM4_B,	0,		0,		0,
 		0,		0,		0,		0,
 		/* IP0_7_5 [3] */
@@ -2349,7 +2349,7 @@ static const struct pinmux_cfg_reg pinmux_config_regs[] = {
 		FN_TS_SDAT0_A,	0,		0,		0,
 		0,		0,		0,		0,
 		/* IP1_10_8 [3] */
-		FN_SD1_CLK_B,	FN_MMC_D6,	0,		FN_A24,
+		FN_SD1_CD_A,	FN_MMC_D6,	0,		FN_A24,
 		FN_DREQ1_A,	0,		FN_HRX0_B,	FN_TS_SPSYNC0_A,
 		/* IP1_7_5 [3] */
 		FN_A23,		FN_HTX0_B,	FN_TX2_B,	FN_DACK2_A,
-- 
2.20.1


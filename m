Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 820DF4077BC
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 15:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237645AbhIKNTx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 09:19:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:38304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236937AbhIKNRn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Sep 2021 09:17:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D29A61357;
        Sat, 11 Sep 2021 13:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631366029;
        bh=ZWcDGK7J3ICcqK6E0ld5xmH3Dpj8mEOLl71Gkvr1t7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o/I5/d3Yw6CKCJBRuahWz+ReMPLF8ZphgE2OFjCPSNNNo7TKd+DoI/KAAwfg10dRW
         ObaUj0/i1P+xZG+VmV7ti3jKVvwZFmm6wh/28QpMyF7oMHVtd1DxcA9LniGMTJ20B5
         YoraZCqHvb3fmqoh5574zpQtR2Y59WasDbyJg5rsEkDH/IE5b1YlvI0ptoQTALYUaD
         w0lVWpGzI4ZxguiDcCf4XFSzgaEG7p2Fc8WX0YnhDrM9MGX+eq+uuV5uYk1OBcF64s
         +g4bdsJYcgLZeYC/nn/OMq0qYYcrFbwNQIy7Kfw9rYXPE/NHAbRhXLwW2PHJv1EWjH
         lekgmZO7zyV8Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        phone-devel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 02/14] mfd: db8500-prcmu: Adjust map to reality
Date:   Sat, 11 Sep 2021 09:13:33 -0400
Message-Id: <20210911131345.285564-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210911131345.285564-1-sashal@kernel.org>
References: <20210911131345.285564-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit ec343111c056ec3847800302f6dbc57281f833fa ]

These are the actual frequencies reported by the PLL, so let's
report these. The roundoffs are inappropriate, we should round
to the frequency that the clock will later report.

Drop some whitespace at the same time.

Cc: phone-devel@vger.kernel.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/db8500-prcmu.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index dfac6afa82ca..f1f2ad9ff0b3 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -1695,22 +1695,20 @@ static long round_clock_rate(u8 clock, unsigned long rate)
 }
 
 static const unsigned long db8500_armss_freqs[] = {
-	200000000,
-	400000000,
-	800000000,
+	199680000,
+	399360000,
+	798720000,
 	998400000
 };
 
 /* The DB8520 has slightly higher ARMSS max frequency */
 static const unsigned long db8520_armss_freqs[] = {
-	200000000,
-	400000000,
-	800000000,
+	199680000,
+	399360000,
+	798720000,
 	1152000000
 };
 
-
-
 static long round_armss_rate(unsigned long rate)
 {
 	unsigned long freq = 0;
-- 
2.30.2


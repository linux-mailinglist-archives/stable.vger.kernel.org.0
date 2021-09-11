Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5023E407718
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 15:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235975AbhIKNPD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 09:15:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:38756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236461AbhIKNOC (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Sep 2021 09:14:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B68361212;
        Sat, 11 Sep 2021 13:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631365958;
        bh=H2S98NgF5nE//kCjsLA97ZkAoRV+Q07i8WlsSzpuacg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qm0azN1EdzfHeQ8Kr+14OuU+nqEUeFbYlyOWtUZ5HJTM/bCVunOMKog/fB3SnBvFj
         5y/yjr7YsVzknpYkuo4y1g3HX1896A/tc2K18G4TbRAD6UmBeXuu1drPQroQllU5iB
         kW2wlLKUBlZOTpbMyQERHNtRhGwJqKUvGD4ZazGg42necLdQn1XbBfK/1N3w3ywVBH
         3AyjiL6PFFwjoJrSpgftWkH2AHqvjD7X3xY4HkLscLqst13HYP5xhaevXRQtNFINzZ
         x8XiW9AZ4rw1i5wUBh6JG13rM6n24/Q3vW91iCnfbVPGssUhTMltympbiSIAYndV3t
         KcZZXio2nu4uA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        phone-devel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 03/29] mfd: db8500-prcmu: Adjust map to reality
Date:   Sat, 11 Sep 2021 09:12:07 -0400
Message-Id: <20210911131233.284800-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210911131233.284800-1-sashal@kernel.org>
References: <20210911131233.284800-1-sashal@kernel.org>
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
index 167faac9b75b..5aa7b3a36f22 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -1622,22 +1622,20 @@ static long round_clock_rate(u8 clock, unsigned long rate)
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


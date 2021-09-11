Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61DF640778F
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 15:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236631AbhIKNSO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 09:18:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:39158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237018AbhIKNPi (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Sep 2021 09:15:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC4A46124D;
        Sat, 11 Sep 2021 13:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631365995;
        bh=GzxPKoFSUPqjQDPedCrh21+0h4qkVoTJdFaYoAVuqa8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DeeyE2IoNarFrHKPoXZyKSYsubZMh+KWdqxestEPc3DzhkxasjmMo40YT99/AjQ2e
         0aiSIzkFVkpbMxfPyQC6Kgy2m2ZSTgpR5IiboYPpsAJicSc39zIYHHn9Ik9TYaQWeP
         upHYI8iRM7ijqHMfcBHGoHlfjqvbRaLznSVhO1srGqPnlr3yMck7ixSbvClAF87iAV
         97jwAhzEpp8/Py82oPYZYGmuHyY9c7YZvQDeaZXwxP0CKRixSsldBubTux4oTOqLOy
         qKoErGt8oVH6l4Vx6zQQII9ZrEYjI9AlVDDhTQnojsNq32b+YQrcSy3QW1a2bdsflf
         uXDesa+vCry7Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        phone-devel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 02/25] mfd: db8500-prcmu: Adjust map to reality
Date:   Sat, 11 Sep 2021 09:12:49 -0400
Message-Id: <20210911131312.285225-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210911131312.285225-1-sashal@kernel.org>
References: <20210911131312.285225-1-sashal@kernel.org>
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
index a5983d515db0..8d5f8f07d8a6 100644
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


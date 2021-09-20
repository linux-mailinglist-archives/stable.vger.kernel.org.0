Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25479412337
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378013AbhITSW2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:22:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:40368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1377563AbhITSUT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:20:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 145BB61A8C;
        Mon, 20 Sep 2021 17:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158606;
        bh=ZWcDGK7J3ICcqK6E0ld5xmH3Dpj8mEOLl71Gkvr1t7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UsPDKIPZQv2yT2TIuWtkHr6Q6KTxlu4tBRG7a3QYwATu8LfytFElssE7bLXr0vGMH
         iHOsv+y5qd4RQtB47OMDhNsj4kVM2/calZ6SBYhjIx1zspj5KT8xxDouJ3xbLl1YY+
         OC6rnm/TzzUhSgXGsZEX0yGWUgeplPXTjZkgu3/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, phone-devel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 234/260] mfd: db8500-prcmu: Adjust map to reality
Date:   Mon, 20 Sep 2021 18:44:12 +0200
Message-Id: <20210920163939.073100257@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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




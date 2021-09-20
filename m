Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04CDD4125B2
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354551AbhITSrO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:47:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:59828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1383114AbhITSoL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:44:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 526C16334A;
        Mon, 20 Sep 2021 17:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159137;
        bh=r9bKAP/Db2Ctbq5jkaSZAU9PRMN3GIB1qKROsvayfJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hDCgseZOgElcyPqVrvwTKIrUyVV0LMd6m5/RKWuX0FUvSl+aZuP95klNh0yJz6HL7
         i8IhHqSKEJMODpqA1CbWPTSM1OS1ZXEaMYyuEnCOS+acreTQud5L79iGtkq+4dQK3M
         Pxcyefssne3Q/335WO7tmzlPwkfyF8w07BVwx8Dk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, phone-devel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 092/168] mfd: db8500-prcmu: Adjust map to reality
Date:   Mon, 20 Sep 2021 18:43:50 +0200
Message-Id: <20210920163924.657418197@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
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
index 3bde7fda755f..dea4e4e8bed5 100644
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




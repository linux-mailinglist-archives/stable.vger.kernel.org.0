Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEA3A15C6B8
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:12:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730154AbgBMQDK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 11:03:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:37424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728665AbgBMPYV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:24:21 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9C4724691;
        Thu, 13 Feb 2020 15:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607460;
        bh=8kYutW9+41XF0O/3w4uBAxEow1/LGdc52OsXTqnh5vA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qEU7tuBwHhLOWVsdNwgPN/OeDlsUIzxuLCtuMbVv10+jXoHCT28GEttvDYoLZXyMS
         Xy6JCqBEziXPniV2CGrgDQtT4z1xgPsuaBsRJ5j6KgOejtDitRzf8WgFN6RHiM0+K2
         RBVjs5FDQbq3nDGzRi0JOcl9j3u+kySMgbzs34Ms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 4.9 110/116] pinctrl: sh-pfc: r8a7778: Fix duplicate SDSELF_B and SD1_CLK_B
Date:   Thu, 13 Feb 2020 07:20:54 -0800
Message-Id: <20200213151924.653864752@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151842.259660170@linuxfoundation.org>
References: <20200213151842.259660170@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit 805f635703b2562b5ddd822c62fc9124087e5dd5 upstream.

The FN_SDSELF_B and FN_SD1_CLK_B enum IDs are used twice, which means
one set of users must be wrong.  Replace them by the correct enum IDs.

Fixes: 87f8c988636db0d4 ("sh-pfc: Add r8a7778 pinmux support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20191218194812.12741-2-geert+renesas@glider.be
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/sh-pfc/pfc-r8a7778.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/pinctrl/sh-pfc/pfc-r8a7778.c
+++ b/drivers/pinctrl/sh-pfc/pfc-r8a7778.c
@@ -2324,7 +2324,7 @@ static const struct pinmux_cfg_reg pinmu
 		FN_ATAG0_A,	0,		FN_REMOCON_B,	0,
 		/* IP0_11_8 [4] */
 		FN_SD1_DAT2_A,	FN_MMC_D2,	0,		FN_BS,
-		FN_ATADIR0_A,	0,		FN_SDSELF_B,	0,
+		FN_ATADIR0_A,	0,		FN_SDSELF_A,	0,
 		FN_PWM4_B,	0,		0,		0,
 		0,		0,		0,		0,
 		/* IP0_7_5 [3] */
@@ -2366,7 +2366,7 @@ static const struct pinmux_cfg_reg pinmu
 		FN_TS_SDAT0_A,	0,		0,		0,
 		0,		0,		0,		0,
 		/* IP1_10_8 [3] */
-		FN_SD1_CLK_B,	FN_MMC_D6,	0,		FN_A24,
+		FN_SD1_CD_A,	FN_MMC_D6,	0,		FN_A24,
 		FN_DREQ1_A,	0,		FN_HRX0_B,	FN_TS_SPSYNC0_A,
 		/* IP1_7_5 [3] */
 		FN_A23,		FN_HTX0_B,	FN_TX2_B,	FN_DACK2_A,



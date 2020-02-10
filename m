Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1FB1576C2
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729392AbgBJMzL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:55:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:44918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730078AbgBJMlt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:41:49 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38FD6208C3;
        Mon, 10 Feb 2020 12:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338509;
        bh=cucRQDhGe24rU2zOLkLoSLI0yPN9jpc3vBoGq3QcSCw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w/L8GblxEk3QmDcZx9xrQlG1ZozgnR7iaUvc0olfdQnEuUDWEG3zpwZFaQ0AHexjU
         diCHAYGhXRXwOco8E6F7XOZ7wyVdyLOLg/O/IDsvt9735SSy+M+wjtKO9fCCxDc4Qc
         of38v6ufrcaNPraxqJl5GLoSA1uoC5xD3tofAmE0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Stephan Gerhold <stephan@gerhold.net>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 5.5 312/367] mfd: ab8500: Fix ab8500-clk typo
Date:   Mon, 10 Feb 2020 04:33:45 -0800
Message-Id: <20200210122452.079149441@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

commit 702204c22c53f94b2e25a3bdcda759cce7b26305 upstream.

Commit f4d41ad84433 ("mfd: ab8500: Example using new OF_MFD_CELL MACRO")
has a typo error renaming "ab8500-clk" to "abx500-clk"
with the result att ALSA SoC audio broke as the clock
driver was not probing anymore. Fixed it up.

Fixes: f4d41ad84433 ("mfd: ab8500: Example using new OF_MFD_CELL MACRO")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Stephan Gerhold <stephan@gerhold.net>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mfd/ab8500-core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -631,8 +631,8 @@ static const struct mfd_cell ab8500_devs
 		    NULL, NULL, 0, 0, "stericsson,ab8500-ext-regulator"),
 	OF_MFD_CELL("ab8500-regulator",
 		    NULL, NULL, 0, 0, "stericsson,ab8500-regulator"),
-	OF_MFD_CELL("abx500-clk",
-		    NULL, NULL, 0, 0, "stericsson,abx500-clk"),
+	OF_MFD_CELL("ab8500-clk",
+		    NULL, NULL, 0, 0, "stericsson,ab8500-clk"),
 	OF_MFD_CELL("ab8500-gpadc",
 		    NULL, NULL, 0, 0, "stericsson,ab8500-gpadc"),
 	OF_MFD_CELL("ab8500-rtc",



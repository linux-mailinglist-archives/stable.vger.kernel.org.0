Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A64DA178245
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:03:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732921AbgCCSKI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 13:10:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:59346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731971AbgCCRvT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:51:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78D4A206E6;
        Tue,  3 Mar 2020 17:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257878;
        bh=ZbFEaN5l+8Ba/vTiEQbdT83zjZPqCfMcehVz7b5ITFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R2Rz4lFjXkgbojDJTQAACdT5ucW+jVOUMe1Trt/x/3oUqBFpJzwCR/jQPaMsWpPmJ
         0eECopcnlJ9/jTQDi85juMWamndn8RLslqLXnR9QOx7mZ9mi5qJ+CUfHlEaPla0cQi
         92sJ/cG6fqYKucF1TefvJB/TzbiFejqa6BP8QCKg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Stephan Gerhold <stephan@gerhold.net>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5.5 162/176] thermal: db8500: Depromote debug print
Date:   Tue,  3 Mar 2020 18:43:46 +0100
Message-Id: <20200303174322.996587705@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

commit c56dcfa3d4d0f49f0c37cd24886aa86db7aa7f30 upstream.

We are not interested in getting this debug print on our
console all the time.

Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Stephan Gerhold <stephan@gerhold.net>
Fixes: 6c375eccded4 ("thermal: db8500: Rewrite to be a pure OF sensor")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Stephan Gerhold <stephan@gerhold.net>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20191119074650.2664-1-linus.walleij@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/thermal/db8500_thermal.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/thermal/db8500_thermal.c
+++ b/drivers/thermal/db8500_thermal.c
@@ -152,8 +152,8 @@ static irqreturn_t prcmu_high_irq_handle
 		db8500_thermal_update_config(th, idx, THERMAL_TREND_RAISING,
 					     next_low, next_high);
 
-		dev_info(&th->tz->device,
-			 "PRCMU set max %ld, min %ld\n", next_high, next_low);
+		dev_dbg(&th->tz->device,
+			"PRCMU set max %ld, min %ld\n", next_high, next_low);
 	} else if (idx == num_points - 1)
 		/* So we roof out 1 degree over the max point */
 		th->interpolated_temp = db8500_thermal_points[idx] + 1;



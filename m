Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45D5A1B2655
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 14:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728739AbgDUMku (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 08:40:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728874AbgDUMku (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 08:40:50 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B88FDC061A41
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 05:40:49 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id y24so3495436wma.4
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 05:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FufN8ACRAoxbxjTegJ+M/1R/ELgdwjuEiGq1TqIq1Lc=;
        b=vLKSrKHBC50HSMEdUg3fKqcwrRGVHBJu7KLH38rc0PcUh6NQ+hOhqV3S39seQRhw0f
         o33MVGiFdMGCo9284qpruQ2jhc/Ui+O3ieHQvF5mdpbf7MG9xow358kY8NNJkarcutuw
         Wh1Z8TXg1PshyCVx5EWPyG2Zz9drckRADrqb/2IvB/kAnXdHexjLejkNZrSh7jVaBHSy
         9oqOfuTlKOJL+xJxIV1wPC2Iyutby492EpNZdi9gSi33CAbI5Ehed4bW5P1EJFyO9fSS
         BOvzWfpG3PGdtw9BbU4jS5fKPPYyts9IJt8sqR+9BpqZQ2H+YGQPo6Uh5UwprN+xCEpT
         7rsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FufN8ACRAoxbxjTegJ+M/1R/ELgdwjuEiGq1TqIq1Lc=;
        b=SsJxM5e7TaIb8rgOzlBPzl+Q+3MTnc5kSzZ7JUE53lbMfOiboO9SHv0WOl4MmgtXA/
         FDKssMgkoUkuUcNuuN5nmPbLgsD0MgBJkiRg5YeQDq9Y694Qwh5ta1uNNehxJKAsSbor
         tjSRP1VJ9gQV4DqzZiJL18X3njAg0Xpczo3mHefP4SFpsh1pQ+Ti875/8rhx1Ukvzmyk
         jjJC0EqhZSd/vxdCsJZXPKg/PPf5ec7qXTIPr24zixoyiHBIIdNLno0PjAkPkJsqG47e
         LLQMu/Biv/y09wl592BgU0LQQpqt0xp3qJpBt33aDPgPEScY8FMwibr+Y/pwJ6BVyE5d
         Gzeg==
X-Gm-Message-State: AGi0PuZ4ffKQKpnlnxVwQoWapYnrzKvuutHizvJpSGDArms9FV5JKVWl
        zeV5XjOKqkbqI7wbplrbe3Se7pErXbg=
X-Google-Smtp-Source: APiQypLDkm0AyICgP+rg7hysUAnYTbVKrjTvaL/62bezJ48PyKrWuUyqg3dDcSP1h71u3NvC3ObVjQ==
X-Received: by 2002:a1c:4085:: with SMTP id n127mr5008186wma.163.1587472848215;
        Tue, 21 Apr 2020 05:40:48 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id u3sm3408232wrt.93.2020.04.21.05.40.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 05:40:47 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Timur Tabi <timur@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.14 03/24] Revert "gpio: set up initial state from .get_direction()"
Date:   Tue, 21 Apr 2020 13:39:56 +0100
Message-Id: <20200421124017.272694-4-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200421124017.272694-1-lee.jones@linaro.org>
References: <20200421124017.272694-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Timur Tabi <timur@codeaurora.org>

[ Upstream commit 1ca2a92b2a99323f666f1b669b7484df4bda05e4 ]

This reverts commit 72d3200061776264941be1b5a9bb8e926b3b30a5.

We cannot blindly query the direction of all GPIOs when the pins are
first registered.  The get_direction callback normally triggers a
read/write to hardware, but we shouldn't be touching the hardware for
an individual GPIO until after it's been properly claimed.

Signed-off-by: Timur Tabi <timur@codeaurora.org>
Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/gpio/gpiolib.c | 31 +++++++------------------------
 1 file changed, 7 insertions(+), 24 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index f0777a7a4305b..d5b42cc86d718 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1245,31 +1245,14 @@ int gpiochip_add_data(struct gpio_chip *chip, void *data)
 		struct gpio_desc *desc = &gdev->descs[i];
 
 		desc->gdev = gdev;
-		/*
-		 * REVISIT: most hardware initializes GPIOs as inputs
-		 * (often with pullups enabled) so power usage is
-		 * minimized. Linux code should set the gpio direction
-		 * first thing; but until it does, and in case
-		 * chip->get_direction is not set, we may expose the
-		 * wrong direction in sysfs.
-		 */
-
-		if (chip->get_direction) {
-			/*
-			 * If we have .get_direction, set up the initial
-			 * direction flag from the hardware.
-			 */
-			int dir = chip->get_direction(chip, i);
 
-			if (!dir)
-				set_bit(FLAG_IS_OUT, &desc->flags);
-		} else if (!chip->direction_input) {
-			/*
-			 * If the chip lacks the .direction_input callback
-			 * we logically assume all lines are outputs.
-			 */
-			set_bit(FLAG_IS_OUT, &desc->flags);
-		}
+		/* REVISIT: most hardware initializes GPIOs as inputs (often
+		 * with pullups enabled) so power usage is minimized. Linux
+		 * code should set the gpio direction first thing; but until
+		 * it does, and in case chip->get_direction is not set, we may
+		 * expose the wrong direction in sysfs.
+		 */
+		desc->flags = !chip->direction_input ? (1 << FLAG_IS_OUT) : 0;
 	}
 
 #ifdef CONFIG_PINCTRL
-- 
2.25.1


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D13CE1B430D
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 13:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbgDVLUN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 07:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726323AbgDVLUM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 07:20:12 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56014C03C1A8
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 04:20:12 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id d17so1900609wrg.11
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 04:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TF7tLYxH/nWJdyfEM3nOdhDC+3Fxk90WqRFDxs2gGHI=;
        b=u7/EF+m0w1IWee7NtzSqGGbri+KJLkMh6HISPqYMN4eiba+8P696iSN6aW9sRyJlzI
         YBhBZTY8Mcj+0L1m+IAcADFStG8YP7i2VuCtIoSjLp7d2yn2gXDWbymDapk0zTJEuPxC
         oK+F8VmcV7rQH58Dmz4CoR/xkYPp6GPjPUIGDCzPtq8ecJLPK8tWT2ymSYsnOX/qonKF
         xnFEkB3c+oBr7ibv4PflhlSMu+5LMwXIBoxQHwxn6RAuQmcP+mTErUwOXiUIP8zPiwrC
         S4fpEG1lvSZP6g5NKZj/zIyw1jZMkQiY0MCtIL3NxYLKP+dHIK6uUnDa04qcS4p74uTR
         Mjew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TF7tLYxH/nWJdyfEM3nOdhDC+3Fxk90WqRFDxs2gGHI=;
        b=shpGHXo5bS2cn9iJQ0mvAqi31rJSBcmlaXjBHWpT7dAJ4Z7k9Vz+eDLxKSSIl98DG2
         Xisq2iSaoOlVLdgVPPY3y7GyJV7BHAwyUTvrQjILqxCkg0x5xIvA/pBmE2kGjaDoRY5X
         Dj8WvB6YFDsi9vJxlTs1EDarn3WvPmMTMDQ+Vstrik3zbr95hOrRAA15D4837gsWxoIH
         OJBXdYQpezGZ4BcHhBMwFH5sb6zoCTivQovoBW2sfxp2n5wm5bGDXRiGnzseyazY2UBj
         FONDXOalww1050Nh2XTq/sWjV44XHYO0zhRyvbatKUhF8wOaRjnybnA7zhBHn0XRcp0V
         0kwg==
X-Gm-Message-State: AGi0PuZFVRDm9Tn+e6AXOYuUVNUmO3iVITCnT8a1ymKPfKg6nKh8G+v2
        d8jafYgbu5hwF2d5HCpWXHtttneS6U4=
X-Google-Smtp-Source: APiQypLgOkt4koV8w80540HjFqRUlz1SHP8Qsjo8tiZrBT6Iwe8SZerBoqi0+qCggUArdQB+WYJD3Q==
X-Received: by 2002:adf:f648:: with SMTP id x8mr21488249wrp.257.1587554410772;
        Wed, 22 Apr 2020 04:20:10 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id n6sm8247255wrs.81.2020.04.22.04.20.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2020 04:20:10 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Timur Tabi <timur@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.9 08/21] Revert "gpio: set up initial state from .get_direction()"
Date:   Wed, 22 Apr 2020 12:19:44 +0100
Message-Id: <20200422111957.569589-9-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200422111957.569589-1-lee.jones@linaro.org>
References: <20200422111957.569589-1-lee.jones@linaro.org>
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
index 505dead076196..73d02f6089d56 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1232,31 +1232,14 @@ int gpiochip_add_data(struct gpio_chip *chip, void *data)
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


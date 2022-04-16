Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3EF350349C
	for <lists+stable@lfdr.de>; Sat, 16 Apr 2022 09:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbiDPHOi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Apr 2022 03:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiDPHOh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 16 Apr 2022 03:14:37 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88F7A237C1;
        Sat, 16 Apr 2022 00:12:06 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id bx5so9134166pjb.3;
        Sat, 16 Apr 2022 00:12:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IN2ONTq4FQTpo6zkZYEzpNCVy6bLNMJdxea3lAKB0xc=;
        b=EB5o+bjfuGJ0EVpCAeYQa92iag/8piehTEyCIMaBp+wffQKngt0IKVcgcTAy4h0+do
         37diJsYCcBAMajOwuqLv5JtfkBkIF1ubZ7wE+RCRoShEezImzfXxRdmI0f2nRlQJ4xvR
         cQbIpzGn8YF1MfInKDnfYsOn6tP++NV20cFnLF0EL6MO72/dekkW4gvgIr46A5A8qOk0
         ad5sIYNr93VKHqTEzl8hXh4U4ex5ZUPdWzcIGgxEAxpropjs8E+pkmz4YxTQI9wOHGzp
         mAa/50I3mdZ+IDJaX+2LoBcCt4/VeYTLZwfgDLvI9F12y8CeRp11CgqXyCpgGWusx8US
         lv0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IN2ONTq4FQTpo6zkZYEzpNCVy6bLNMJdxea3lAKB0xc=;
        b=ptkubJcB7v8dHgfXmilEwpD5IB9a3eMIJnox8oWZTJfSHye7UGRw/qHPGaJZDskgM7
         CShdWchlNPDW7x1Y89s5qxjjkwh5CQOMVEsu1Fpu/YQuk3wJVWProYXkvCUd+bhQH0Kr
         +IhMxL81NzYUufNGDvMJa53XBHA7EwWUdJTRSZl008jk4bTlD+7KtDleJIXc/XCXUeoe
         GNsSLh1zaF02TpRE2KDHXIPyPLD23IC+rmnBBNTtEQziiSgAMw7UyT0CLWmz8wKof1H+
         DhySR7PIBKVM2r1Hvp+24vJPeaQgRRv1QLCWobzRCQ8DqRAoWUM6h/1mNtynvBZy14nb
         xFhQ==
X-Gm-Message-State: AOAM531V+OyeHYYFWUSvXunH0omDJ6++Y2RXnZu/l1wtyB6kzriHOm+f
        1tV+GsZM7MNxFZ9kL9h/Mvsw+Ox3B+5wZA==
X-Google-Smtp-Source: ABdhPJwrwklHaXhUc9BpuMtbsgKzkWjYnYKG174ie/S3tOi5AbR82jI54+T9WzudC09f0/pOaMaDxA==
X-Received: by 2002:a17:902:bf07:b0:158:24d9:3946 with SMTP id bi7-20020a170902bf0700b0015824d93946mr2513838plb.28.1650093125680;
        Sat, 16 Apr 2022 00:12:05 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-90.three.co.id. [180.214.233.90])
        by smtp.gmail.com with ESMTPSA id c139-20020a621c91000000b00505deaddb09sm4882405pfc.107.2022.04.16.00.11.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Apr 2022 00:12:05 -0700 (PDT)
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     linux-doc@vger.kernel.org
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>, linux-pm@vger.kernel.org,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Thierry Reding <treding@nvidia.com>,
        Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Saravana Kannan <saravanak@google.com>,
        Todd Kjos <tkjos@google.com>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kevin Hilman <khilman@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Rob Herring <robh@kernel.org>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH] Documentation: dd: Use ReST lists for return values of driver_deferred_probe_check_state()
Date:   Sat, 16 Apr 2022 14:11:38 +0700
Message-Id: <20220416071137.19512-1-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sphinx reported build warnings mentioning drivers/base/dd.c:

</path/to/linux>/Documentation/driver-api/infrastructure:35:
./drivers/base/dd.c:280: WARNING: Unexpected indentation.
</path/to/linux>/Documentation/driver-api/infrastructure:35:
./drivers/base/dd.c:281: WARNING: Block quote ends without a blank line;
unexpected unindent.

The warnings above is due to syntax error in the "Return" section of driver_deferred_probe_check_state() which messed up with desired line breaks.

Fix the issue by using ReST lists syntax.

Fixes: c8c43cee29f6ca ("driver core: Fix driver_deferred_probe_check_state() logic")
Cc: linux-pm@vger.kernel.org
Cc: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Thierry Reding <treding@nvidia.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Saravana Kannan <saravanak@google.com>
Cc: Todd Kjos <tkjos@google.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Kevin Hilman <khilman@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Rob Herring <robh@kernel.org>
Cc: John Stultz <john.stultz@linaro.org>
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 drivers/base/dd.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 3fc3b5940bb..b0b410347ab 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -274,10 +274,10 @@ __setup("deferred_probe_timeout=", deferred_probe_timeout_setup);
  * @dev: device to check
  *
  * Return:
- * -ENODEV if initcalls have completed and modules are disabled.
- * -ETIMEDOUT if the deferred probe timeout was set and has expired
- *  and modules are enabled.
- * -EPROBE_DEFER in other cases.
+ * * -ENODEV if initcalls have completed and modules are disabled.
+ * * -ETIMEDOUT if the deferred probe timeout was set and has expired
+ *   and modules are enabled.
+ * * -EPROBE_DEFER in other cases.
  *
  * Drivers or subsystems can opt-in to calling this function instead of directly
  * returning -EPROBE_DEFER.

base-commit: 59250f8a7f3a60a2661b84cbafc1e0eb5d05ec9b
-- 
An old man doll... just what I always wanted! - Clara


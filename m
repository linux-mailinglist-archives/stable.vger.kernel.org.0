Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95154A98BC
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 05:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731091AbfIEDIX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 23:08:23 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42010 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731070AbfIEDIW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Sep 2019 23:08:22 -0400
Received: by mail-pg1-f196.google.com with SMTP id p3so545304pgb.9
        for <stable@vger.kernel.org>; Wed, 04 Sep 2019 20:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=PfNn/W0PmjQ9bUUZ6dAEkvRvRPYcOrbr2656dQFRs6Q=;
        b=Rfnun+BKpxLGSH5iYf9FM54fTzUr/1eAOg+7ooMe9cJVIYKInFGkE5PP8FtwBa54Lu
         hDju3syhY1Tz6ydSOrJ3+ZFZU8o5CzZIWg3aM6HnvUgjwjQ7N7ohBKWrP10BM/RbEsbz
         Lt4v78Gehe70tjX9vpE3FVaoGNT25TOCm8/Evglc197eKQynU/NCrrk/D1mxTbpm6U5Z
         XedhzH7HGU87rl7hqtoUVFg8bMwl9arkXoON3SF8PQPgE/nARM80G+mo6tQnTkL27uQY
         t4fbl2EvxU5VeD0ccEHRWivNn11uAXVswJmNzq2fuFGpN0CnQGtXXcndB/SzBQaP0HrW
         mQwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=PfNn/W0PmjQ9bUUZ6dAEkvRvRPYcOrbr2656dQFRs6Q=;
        b=IJQCNHjU+7T6UuPrk84v4UnORdTP0TZ1vl3waxmB3314jrwBpSPyjZZTNUELfaixX1
         iNZFlWJY8EG5CXltGIFOQJTRxI7yIwW93K9hIlTtTTxtkOVy+34eX228oEoU6SA2KCM7
         x8t/lqf6o5LMhkkZPV+r14ru9OuJERDfon/HqgLPmX4+AeDBXmq65T/YCrGq7A7n/w/I
         4Lkq5yob+xnsXh+xS4BXmv/GEGd1PUjjPGc1vX3D4dJTJKwFvli3CzoogWYsMd2D8IoQ
         46XBpC5bKBOjR+ToC2J4eoPPA4pu3996M24+kidKRozhU7yIbgmp7PIuKjjkro9KqfUQ
         J4mw==
X-Gm-Message-State: APjAAAVZNlQzJr3GHGbb/AjUWr1yQQqlB9/gi4yvrXFyr4o3dWys6Ifk
        pW19vCcqlnoNHa4j2dnMRqEqfZCtEksBdw==
X-Google-Smtp-Source: APXvYqzLtfOPZjB56l72tPxU34aCQyYpUADkwCEg5v8DnhXx1pXs3Xk57srn2UH+MmKw8Yi0OemPAQ==
X-Received: by 2002:a65:68c9:: with SMTP id k9mr1152083pgt.28.1567652902075;
        Wed, 04 Sep 2019 20:08:22 -0700 (PDT)
Received: from baolinwangubtpc.spreadtrum.com ([117.18.48.82])
        by smtp.gmail.com with ESMTPSA id s4sm497041pfh.15.2019.09.04.20.08.19
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 04 Sep 2019 20:08:21 -0700 (PDT)
From:   Baolin Wang <baolin.wang@linaro.org>
To:     stable@vger.kernel.org, linus.walleij@linaro.org,
        natechancellor@gmail.com
Cc:     linux-gpio@vger.kernel.org, arnd@arndb.de, baolin.wang@linaro.org,
        orsonzhai@gmail.com, vincent.guittot@linaro.org,
        linux-kernel@vger.kernel.org
Subject: [BACKPORT 4.14.y v2 3/6] pinctrl: sprd: Use define directive for sprd_pinconf_params values
Date:   Thu,  5 Sep 2019 11:07:52 +0800
Message-Id: <db6ae70b6b727e646b1f9ed5c2c8d490cfc50695.1567649729.git.baolin.wang@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1567649728.git.baolin.wang@linaro.org>
References: <cover.1567649728.git.baolin.wang@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[Upstream commit 957063c924736d4341e5d588757b9f31e8f6fa24]

Clang warns when one enumerated type is implicitly converted to another:

drivers/pinctrl/sprd/pinctrl-sprd.c:845:19: warning: implicit conversion
from enumeration type 'enum sprd_pinconf_params' to different
enumeration type 'enum pin_config_param' [-Wenum-conversion]
        {"sprd,control", SPRD_PIN_CONFIG_CONTROL, 0},
        ~                ^~~~~~~~~~~~~~~~~~~~~~~
drivers/pinctrl/sprd/pinctrl-sprd.c:846:22: warning: implicit conversion
from enumeration type 'enum sprd_pinconf_params' to different
enumeration type 'enum pin_config_param' [-Wenum-conversion]
        {"sprd,sleep-mode", SPRD_PIN_CONFIG_SLEEP_MODE, 0},
        ~                   ^~~~~~~~~~~~~~~~~~~~~~~~~~

It is expected that pinctrl drivers can extend pin_config_param because
of the gap between PIN_CONFIG_END and PIN_CONFIG_MAX so this conversion
isn't an issue. Most drivers that take advantage of this define the
PIN_CONFIG variables as constants, rather than enumerated values. Do the
same thing here so that Clang no longer warns.

Link: https://github.com/ClangBuiltLinux/linux/issues/138
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Baolin Wang <baolin.wang@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
---
 drivers/pinctrl/sprd/pinctrl-sprd.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/sprd/pinctrl-sprd.c b/drivers/pinctrl/sprd/pinctrl-sprd.c
index 6352991..83958bd 100644
--- a/drivers/pinctrl/sprd/pinctrl-sprd.c
+++ b/drivers/pinctrl/sprd/pinctrl-sprd.c
@@ -159,10 +159,8 @@ struct sprd_pinctrl {
 	struct sprd_pinctrl_soc_info *info;
 };
 
-enum sprd_pinconf_params {
-	SPRD_PIN_CONFIG_CONTROL = PIN_CONFIG_END + 1,
-	SPRD_PIN_CONFIG_SLEEP_MODE = PIN_CONFIG_END + 2,
-};
+#define SPRD_PIN_CONFIG_CONTROL		(PIN_CONFIG_END + 1)
+#define SPRD_PIN_CONFIG_SLEEP_MODE	(PIN_CONFIG_END + 2)
 
 static int sprd_pinctrl_get_id_by_name(struct sprd_pinctrl *sprd_pctl,
 				       const char *name)
-- 
1.7.9.5


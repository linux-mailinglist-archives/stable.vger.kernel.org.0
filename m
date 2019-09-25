Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11750BDB81
	for <lists+stable@lfdr.de>; Wed, 25 Sep 2019 11:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732618AbfIYJyd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Sep 2019 05:54:33 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:35897 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732583AbfIYJyd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Sep 2019 05:54:33 -0400
Received: by mail-pf1-f196.google.com with SMTP id y22so3094232pfr.3
        for <stable@vger.kernel.org>; Wed, 25 Sep 2019 02:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qjt9nGee6IRgKbTvjid5ObbFQrI9vCTeU4UrRiALsas=;
        b=kg8lbcqYpgzcKQyZHGhI7ejPMzvDJkhTF8+VLoKNp6I0PZW3MWX13h0iqXQz+W4ftP
         jTixi9u0JwyhtYY/BNrY/39d/0c5CbNRDkCmfFRpVwNbzp3epZud42ngEFiREiFbRIP0
         rYOdkfT4JsJx6qUBBuX9DR4DnVh4+NmfUFyMIozvXGnO3AoyZZEjseLyCkL81vZbmxiK
         kkBcMijzCe69hXkUI1owV1UhlJ3LiVqMGzgNMjDPArVDbfnK40jQDxvDToQwzaG5HnyL
         toDVSZDPE+7C9XGhcRlKuLbkIDgZWDK0fCO6XoMQR/ZqKlkjzm2Qb6XAAWGfstda6Puh
         KM7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=qjt9nGee6IRgKbTvjid5ObbFQrI9vCTeU4UrRiALsas=;
        b=m1uTqoqYOfNobsuhqDz41DljLATWrALXIKFzrCtkY04ZkME7I1/uVEzTlnMZUgISxZ
         hb76xWHB49nLK+u1duU4uDtaowwijqpV/zIum4KhCnttheRwDdYm7fIg0VIo9Hgw43Pg
         sj7zfvrejBNUHw+ex+tBOsWB9QXIDlkt5Xu+zRV6Njspj7y3BypGNsLaIcYjy8UJvZP9
         dA/ERAT8X87xHRrSUL0drXkMkb63g0wQwMAL0wxWTMGLXWs4Pnam6LeUE5k2uUakB6st
         ZuMelhh7sHJ25Fvp6gKkDiuFkhN9y8V2Swz04ucwvRKAfSYw87vTYwgJsYholpHBJnHc
         X2fA==
X-Gm-Message-State: APjAAAUrMqYZnhGk2CobUzqUanfgEFsUrJWPUKsDLBGCcbvptBXSaKVy
        TnYF0rdA+0IBMLyJkXcbKkv/ElBx713TJQ==
X-Google-Smtp-Source: APXvYqwj9vYR+usXdpMYRActcK2WXECClntp1jjA+Fzj8B5VVqPOtYW+ZMwHg73Z/ckv/aAJEpR37w==
X-Received: by 2002:a63:1950:: with SMTP id 16mr8180123pgz.213.1569405271867;
        Wed, 25 Sep 2019 02:54:31 -0700 (PDT)
Received: from baolinwangubtpc.spreadtrum.com ([117.18.48.82])
        by smtp.gmail.com with ESMTPSA id i126sm5298307pfc.29.2019.09.25.02.54.28
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 25 Sep 2019 02:54:30 -0700 (PDT)
From:   Baolin Wang <baolin.wang@linaro.org>
To:     stable@vger.kernel.org, linus.walleij@linaro.org,
        natechancellor@gmail.com
Cc:     linux-gpio@vger.kernel.org, arnd@arndb.de, baolin.wang@linaro.org,
        orsonzhai@gmail.com, vincent.guittot@linaro.org,
        linux-kernel@vger.kernel.org
Subject: [BACKPORT 4.19.y 2/3] pinctrl: sprd: Use define directive for sprd_pinconf_params values
Date:   Wed, 25 Sep 2019 17:54:09 +0800
Message-Id: <a1d7a04b0319dc977a0dcc7224d7fd41c635b6b9.1569404757.git.baolin.wang@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1569404757.git.baolin.wang@linaro.org>
References: <cover.1569404757.git.baolin.wang@linaro.org>
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
index 78c2f54..8f3468d 100644
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


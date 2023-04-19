Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC306E830A
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 23:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbjDSVIV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 17:08:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231347AbjDSVIU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 17:08:20 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59ADE659F;
        Wed, 19 Apr 2023 14:08:17 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id m39-20020a05600c3b2700b003f170e75bd3so2606459wms.1;
        Wed, 19 Apr 2023 14:08:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681938496; x=1684530496;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ehYDxVU02fn2ZkXnUcD0JtMkdqmb9th/dYG75X055ng=;
        b=JwRafYxks4ZW9UecZY4eqmo5FKHyDxwuYi5VAsPf6UWl4eR8eRczTFuc6KvqIPoc12
         RbTqA4mT9JS0NlX7sCEvvhwWdGvWglMMZwc9juIZoL444AKX0vkKIXMfJ1t1YX/lmJoF
         2m80rXDfg0ov2r4d2fCDUh/VwAvR0J+LQdrLvDxxn4uglHr2bMhNOpHSnDAhEWoEINAr
         Sburf4C1ltCzrl/J8s9aoPYt0be7fxt/tg/K5aYaLbn975xzIPn0n49Hj8LSxN0NMhtf
         KIqQdGQJSvt6VRD876+BSgsU6kZfxQbMQXT/9D6o9fKG7gnNtU5xUWUL1VIUpmNJJOVs
         YknA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681938496; x=1684530496;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ehYDxVU02fn2ZkXnUcD0JtMkdqmb9th/dYG75X055ng=;
        b=PBSss+wZkr9w8mwhJq4z3olMdQPqQteFDJWZ6v0Dyi8XGUekaZuU95pOOaDrmKNIul
         TPBIZ5YAM6uipOFmttA+L/w2gsm/Y/vNsZJk0RxMcjP7zWGStXvvpds1gk3V0hYFzp8/
         InH9DwBMwU3qBtfIQO3yj8csEWx8pXzfphSY+iOPkcsp4cPdQgusAmluFKUlhwDLSWCq
         MKoYvKhL/JzW2lEOXm/azATacUyQcSXIHWff2lJd4AcLx+Uda+DjBG9pgWvYD1iyFSwM
         jXpukn5NNb2eF02VwJOqDjoLKUy9VQWePYVc6fMZsSNyENPw911YG9t5eIrb0EukGq7O
         68Og==
X-Gm-Message-State: AAQBX9dAu0GtEHFNkb1nzHSdPm6dzNnL2Jg/TZ0HwJhYGWI5OrAFO5//
        wdnSq712RBOjRbLNVx6mTFs=
X-Google-Smtp-Source: AKy350bpR2ntMHwK5Uj+zwSpTPl5Escd1GXHcMe/lfkEefigenjs1F+0v7UETpJWgm+TbiA54PNpPw==
X-Received: by 2002:a05:600c:221a:b0:3f0:a798:2757 with SMTP id z26-20020a05600c221a00b003f0a7982757mr17039715wml.25.1681938495512;
        Wed, 19 Apr 2023 14:08:15 -0700 (PDT)
Received: from localhost.localdomain (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.googlemail.com with ESMTPSA id g3-20020a5d5543000000b002fe254f6c33sm81295wrw.92.2023.04.19.14.08.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 14:08:15 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Martin Schiller <ms@dev.tdt.de>, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Cc:     stable@vger.kernel.org
Subject: [PATCH 1/5] leds: trigger: netdev: recheck NETDEV_LED_MODE_LINKUP on dev rename
Date:   Wed, 19 Apr 2023 23:07:39 +0200
Message-Id: <20230419210743.3594-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230419210743.3594-1-ansuelsmth@gmail.com>
References: <20230419210743.3594-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dev can be renamed also while up for supported device. We currently
wrongly clear the NETDEV_LED_MODE_LINKUP flag on NETDEV_CHANGENAME
event.

Fix this by rechecking if the carrier is ok on NETDEV_CHANGENAME and
correctly set the NETDEV_LED_MODE_LINKUP bit.

Fixes: 5f820ed52371 ("leds: trigger: netdev: fix handling on interface rename")
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Cc: stable@vger.kernel.org # v5.5+
---
 drivers/leds/trigger/ledtrig-netdev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index d5e774d83021..f4d670ec30bc 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -318,6 +318,9 @@ static int netdev_trig_notify(struct notifier_block *nb,
 	clear_bit(NETDEV_LED_MODE_LINKUP, &trigger_data->mode);
 	switch (evt) {
 	case NETDEV_CHANGENAME:
+		if (netif_carrier_ok(dev))
+			set_bit(NETDEV_LED_MODE_LINKUP, &trigger_data->mode);
+		fallthrough;
 	case NETDEV_REGISTER:
 		if (trigger_data->net_dev)
 			dev_put(trigger_data->net_dev);
-- 
2.39.2


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29BBF1EFDE7
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 18:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728439AbgFEQ3A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 12:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727024AbgFEQ0K (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jun 2020 12:26:10 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 275F5C08C5C2;
        Fri,  5 Jun 2020 09:26:10 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id d10so5363382pgn.4;
        Fri, 05 Jun 2020 09:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=IEApNuKp8gKWvflXdIy4+ZsvdThFgVJg626w5D+H1A0=;
        b=ZKppMvOf6dQxrlW1P8yxfhr/IhrEHAIY4xLXS6TZ/nZd1CEB9OKfPrCJRYA6XUxTV6
         T8V+GemHui3biwV7wMGN1a/TERAtJtiU4KvcHx9+DaCKW4E9g1E2G7baHhOnpHfk0DnY
         P6gv8ZhAcshCWSJE0GiTdNoF3sts1isfPcy+w0Tpcq0deZPYiYt0jx1AenyaUy3Mszbl
         LSFJWXvMrzmJM5jhyBtHsHZ1UNj69DaCfzr7DeP+9Qwk6lQbO//BxcOnq8HvNwPx8VtB
         VI+3Ud7lxRNg5EiBndcWaDBHXEeR6emEA+OGhy7/1USUu3xV5/UzCA6Hawo0tKtLUwr1
         MtgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=IEApNuKp8gKWvflXdIy4+ZsvdThFgVJg626w5D+H1A0=;
        b=kt/urm4lIsPDOATzUVbVNEcgz25A+Y6/eEEV7CEpUiJHkhlc7410wx3s1p7LHHumVC
         mcW0hJhIUStEQjUNA33uvN5/vmt7DgJVO3RXpAckjMt6+UDRP5vZhhfVc0SnVXW3+FZ+
         toIZJOeoB/ITyb0kw5xogcUY1g4yp3fCcRYfXFXIUsudfq4zTJIflmSp5yDdohDkXPdU
         UAsUXvuqwYDwlyzwsAA/3exoQRI1c+wmtr6ri5B/vEEGpLg869H24OEBL48tZEYvEzG0
         mDW+sMO6Nv3yeN6ZVrAPcUXcRApi8QNDLh1EB12u5o8iLAz0N4xx6BW2L1lKXc4XsJSK
         7hAA==
X-Gm-Message-State: AOAM530mbdj8SoJdGfwVY4IaWvJZPN0f1uFS32WCB8cpgYmPC04cpUF6
        agSoFXM0ZsIXt9zivOe43shw8uk3
X-Google-Smtp-Source: ABdhPJxNyiAyQP0+5b2n1II/vh9F5sV6RSsX9MwOgGH3s+ZJ04N+1dI1EJJ6OrPdlE7xeS5jyEFIUA==
X-Received: by 2002:aa7:9acc:: with SMTP id x12mr10428830pfp.24.1591374369200;
        Fri, 05 Jun 2020 09:26:09 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b29sm86205pff.176.2020.06.05.09.26.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2020 09:26:08 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
X-Google-Original-From: Florian Fainelli <florian.fainelli@broadcom.com>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Shuah Khan <shuah@kernel.org>,
        Jaedon Shin <jaedon.shin@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        linux-media@vger.kernel.org (open list:MEDIA INPUT INFRASTRUCTURE
        (V4L/DVB)),
        linux-fsdevel@vger.kernel.org (open list:FILESYSTEMS (VFS and
        infrastructure))
Subject: [PATCH stable 4.9 06/21] media: stv0288: get rid of set_property boilerplate
Date:   Fri,  5 Jun 2020 09:25:03 -0700
Message-Id: <20200605162518.28099-7-florian.fainelli@broadcom.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200605162518.28099-1-florian.fainelli@broadcom.com>
References: <20200605162518.28099-1-florian.fainelli@broadcom.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab@s-opensource.com>

commit 473e4b4c1cf3046fc6b3437be9a9f3c89c2e61ef upstream

This driver doesn't implement support for set_property(). Yet,
it implements a boilerplate for it. Get rid of it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/media/dvb-frontends/stv0288.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv0288.c b/drivers/media/dvb-frontends/stv0288.c
index c93d9a45f7f7..2b8c75f28d2e 100644
--- a/drivers/media/dvb-frontends/stv0288.c
+++ b/drivers/media/dvb-frontends/stv0288.c
@@ -447,12 +447,6 @@ static int stv0288_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 	return 0;
 }
 
-static int stv0288_set_property(struct dvb_frontend *fe, struct dtv_property *p)
-{
-	dprintk("%s(..)\n", __func__);
-	return 0;
-}
-
 static int stv0288_set_frontend(struct dvb_frontend *fe)
 {
 	struct stv0288_state *state = fe->demodulator_priv;
@@ -568,7 +562,6 @@ static struct dvb_frontend_ops stv0288_ops = {
 	.set_tone = stv0288_set_tone,
 	.set_voltage = stv0288_set_voltage,
 
-	.set_property = stv0288_set_property,
 	.set_frontend = stv0288_set_frontend,
 };
 
-- 
2.17.1


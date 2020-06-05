Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 500BD1EFDF0
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 18:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbgFEQ3A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 12:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727037AbgFEQ0M (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Jun 2020 12:26:12 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B23EC08C5C3;
        Fri,  5 Jun 2020 09:26:12 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id 64so5120575pfg.8;
        Fri, 05 Jun 2020 09:26:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dASDXMiZEph5YCTisMlHTdhBBOP44OwUKjYtbrazK0w=;
        b=lRsBh9rYlD3/klFZqakJ0sVqCrjSPf2sDijjIOPnDVwZ7apuHjMIwwQDkp0+o754gF
         4/xGNuMr+V1FHGugjT8Ie3mOvRMgbkxkDzn1B1wmUksTu/6TkerWdC4b5JgLu6MmHpVq
         qGU0/l0rodSFQVrMSXc6gP4B7Pqb9bcYNABfaqO0EyBbBVsnEskMDEt8tJxFCGtU/EQe
         i36ujV6luk8DndCyrMCvPNxMMfB34OiDPeljv9TEbLLh1INxeEBEOOVMaFI1bmu1XC+J
         oOshsyJtmIG+waJl7NW2fTf6KGn3GipfU5B45FbpYN7hvkgZ8TLEm6+UYw1cS+qD75L8
         9+iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dASDXMiZEph5YCTisMlHTdhBBOP44OwUKjYtbrazK0w=;
        b=jYpXyNsYad1wDZFYYagu/wWmccRmASORfeJwti5T59pcWhouLMfzbubtL+DcU0ssxn
         QQK2lQv9Xi02wRLGPAA8yB9IJ3mL4gMvO/X66MvM8A1G2WWsjq7320WeeVkrfA6nHDOG
         jfnog2fb+dtSP4I+kN/HUy+Xte5+ZHlu/hKZnQOvX0c4YYO57H+HE9wLkD02MILcDtRh
         rfXXHTFAIXH2RPr5G9Dh5Zs6RnWfuhfCtIseJO13v65ZqYAEVA5/imdlRqrP9kFK7naa
         y1MLPxZQTPYpjyUx/ZUeOPCRc/JvzTTITTjcQo8QPHEvzbX4V7eb33/szFJBXfpTGpme
         L8qQ==
X-Gm-Message-State: AOAM531AuyWN6mhHlqDRaVgXuzWen0wNtzDbgQEeAb/ioi0o5QQ5tJWV
        /nlxBOSvnKhkQILSWsWSu3EmWjga
X-Google-Smtp-Source: ABdhPJwXx/cGe9xW2SYlzP6+8kzFsQ21N0G0adYtcyJqEYt6Q8PYpLKRa6OKd3iLBwEm+8laxXxzXg==
X-Received: by 2002:a63:7519:: with SMTP id q25mr9985787pgc.224.1591374371249;
        Fri, 05 Jun 2020 09:26:11 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b29sm86205pff.176.2020.06.05.09.26.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2020 09:26:10 -0700 (PDT)
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
Subject: [PATCH stable 4.9 07/21] media: stv6110: get rid of a srate dead code
Date:   Fri,  5 Jun 2020 09:25:04 -0700
Message-Id: <20200605162518.28099-8-florian.fainelli@broadcom.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200605162518.28099-1-florian.fainelli@broadcom.com>
References: <20200605162518.28099-1-florian.fainelli@broadcom.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab@s-opensource.com>

commit 282996925b4d78f9795d176f7fb409281c98d56d upstream

The stv6110 has a weird code that checks if get_property
and set_property ioctls are defined. If they're, it initializes
a "srate" var from properties cache. Otherwise, it sets to
15MBaud, with won't make any sense.

Thankfully, it seems that someone else discovered the issue in
the past, as "srate" is currently not used anywhere!

So, get rid of that really weird dead code logic.

Reported-by: Honza Petrous <jpetrous@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/media/dvb-frontends/stv6110.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv6110.c b/drivers/media/dvb-frontends/stv6110.c
index 66a5a7f2295c..93262b13c644 100644
--- a/drivers/media/dvb-frontends/stv6110.c
+++ b/drivers/media/dvb-frontends/stv6110.c
@@ -263,11 +263,9 @@ static int stv6110_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 static int stv6110_set_frequency(struct dvb_frontend *fe, u32 frequency)
 {
 	struct stv6110_priv *priv = fe->tuner_priv;
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	u8 ret = 0x04;
 	u32 divider, ref, p, presc, i, result_freq, vco_freq;
 	s32 p_calc, p_calc_opt = 1000, r_div, r_div_opt = 0, p_val;
-	s32 srate;
 
 	dprintk("%s, freq=%d kHz, mclk=%d Hz\n", __func__,
 						frequency, priv->mclk);
@@ -278,13 +276,6 @@ static int stv6110_set_frequency(struct dvb_frontend *fe, u32 frequency)
 				((((priv->mclk / 1000000) - 16) & 0x1f) << 3);
 
 	/* BB_GAIN = db/2 */
-	if (fe->ops.set_property && fe->ops.get_property) {
-		srate = c->symbol_rate;
-		dprintk("%s: Get Frontend parameters: srate=%d\n",
-							__func__, srate);
-	} else
-		srate = 15000000;
-
 	priv->regs[RSTV6110_CTRL2] &= ~0x0f;
 	priv->regs[RSTV6110_CTRL2] |= (priv->gain & 0x0f);
 
-- 
2.17.1


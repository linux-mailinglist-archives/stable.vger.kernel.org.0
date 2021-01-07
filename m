Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B42A82EE94B
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 23:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728500AbhAGWxj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 17:53:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728997AbhAGWx2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 17:53:28 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4836C0612F9;
        Thu,  7 Jan 2021 14:52:47 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id c12so4973971pfo.10;
        Thu, 07 Jan 2021 14:52:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fLaUUyKZV1n5I1oaAK7wF0mjKoazvM828WYSvM0xN9U=;
        b=SrpDw5ZL20CJZu2dUwe8XoGxa8GIvJGIQ58RqydQMTU1f/39JUSEcZH59Avzzhr0hw
         u4OjgOG7Jtu2JOvBtgOe/ryAD9ly94Advoxj8BgXDON7dT/jVzLBlei7310PCPbfxXjf
         z1RtU3G9tUoz/jPSIvN1w1FXFzdGtQz5jdYzOlLvumk6JKxT8QZ43/m/5/uZ5wsjC0md
         BL0+pqB26Z4qb/EaMWgIsSFtEXRd2BirdmpGNEztvm1B1Cs0iCWJ+TJcOpj8FlKQVava
         CxZbDGR4YwqjcXRskkLu2v0UEo13kXAIK3oiuZgzuA6uuNQ5dDml6D0iJnV2nKVtK7Rn
         4ZVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fLaUUyKZV1n5I1oaAK7wF0mjKoazvM828WYSvM0xN9U=;
        b=r2px37+R5G4BTwF/JS7HQYrgzGkX8UcbYDqs28ZEZL9/Rk/e6HjSNbaAWjsVH52LGQ
         lfhBjhHkekJM/HVGAHwrt06DJYw55+zciSvj+IrHOlfGkugGXEktBsm7EURAkWjYNwd3
         rQ/q6Fz7Uzjs29N34eNwchCSmQKJG5ewEjLojBJdvSK00hr1uxWJy/UQWt2C9n0wPzjV
         ez/UNwMtPW7zfG3GQ6BrwpzflNDD0I+XHG6pYtxEY4gtlNUo7X7zYitGq3NhdJzkPhkz
         C7EddKB6yg6PQs6aSCaiSJSCub1pTn4qf1uANceAJheeyMfMbm5jNJQvi873MzkAxYAW
         umFA==
X-Gm-Message-State: AOAM530W0RN/wvPesO4Uy897mIouRRh9Cg0bZJShe7F8rZ8WgNOjoB3R
        nGVslop3Cb1UB1Mv5Rfe8/mpdLFgarM=
X-Google-Smtp-Source: ABdhPJwWe0iclf9Bfkbmx4pOC1sWmREK06Dw6UmzdkgvyEB8jD36VH1Z7UB5GxPuQyfdJbrV+MGjAA==
X-Received: by 2002:a62:b60c:0:b029:1ae:6d91:4eb6 with SMTP id j12-20020a62b60c0000b02901ae6d914eb6mr2150198pff.33.1610059966794;
        Thu, 07 Jan 2021 14:52:46 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a10sm6510603pfi.168.2021.01.07.14.52.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:52:45 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Du Changbin <changbin.du@gmail.com>,
        Kieran Bingham <kbingham@kernel.org>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Kieran Bingham <kieran@ksquared.org.uk>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        =?UTF-8?q?Andr=C3=A9=20Draszik?= <git@andred.net>
Subject: [stable 4.9.y 4/4] scripts/gdb: fix lx-version string output
Date:   Thu,  7 Jan 2021 14:52:29 -0800
Message-Id: <20210107225229.1502459-5-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210107225229.1502459-1-f.fainelli@gmail.com>
References: <20210107225229.1502459-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Du Changbin <changbin.du@gmail.com>

commit b058809bfc8faeb7b7cae047666e23375a060059 upstream

A bug is present in GDB which causes early string termination when
parsing variables.  This has been reported [0], but we should ensure
that we can support at least basic printing of the core kernel strings.

For current gdb version (has been tested with 7.3 and 8.1), 'lx-version'
only prints one character.

  (gdb) lx-version
  L(gdb)

This can be fixed by casting 'linux_banner' as (char *).

  (gdb) lx-version
  Linux version 4.19.0-rc1+ (changbin@acer) (gcc version 7.3.0 (Ubuntu 7.3.0-16ubuntu3)) #21 SMP Sat Sep 1 21:43:30 CST 2018

[0] https://sourceware.org/bugzilla/show_bug.cgi?id=20077

[kbingham@kernel.org: add detail to commit message]
Link: http://lkml.kernel.org/r/20181111162035.8356-1-kieran.bingham@ideasonboard.com
Fixes: 2d061d999424 ("scripts/gdb: add version command")
Signed-off-by: Du Changbin <changbin.du@gmail.com>
Signed-off-by: Kieran Bingham <kbingham@kernel.org>
Acked-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 scripts/gdb/linux/proc.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/gdb/linux/proc.py b/scripts/gdb/linux/proc.py
index 38b1f09d1cd9..822e3767bc05 100644
--- a/scripts/gdb/linux/proc.py
+++ b/scripts/gdb/linux/proc.py
@@ -40,7 +40,7 @@ class LxVersion(gdb.Command):
 
     def invoke(self, arg, from_tty):
         # linux_banner should contain a newline
-        gdb.write(gdb.parse_and_eval("linux_banner").string())
+        gdb.write(gdb.parse_and_eval("(char *)linux_banner").string())
 
 LxVersion()
 
-- 
2.25.1


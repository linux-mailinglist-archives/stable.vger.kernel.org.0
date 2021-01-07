Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1B672EE949
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 23:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728991AbhAGWx2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 17:53:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728575AbhAGWxX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 17:53:23 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE84C0612F6;
        Thu,  7 Jan 2021 14:52:43 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id i5so6348378pgo.1;
        Thu, 07 Jan 2021 14:52:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kkJanOIEtiwTHNCIrofj7wjT/1euAC35OtiXO+rsH/E=;
        b=Ei2AWvifiZYCkJWJPT/YrvJ7SPQ9DmXUkyPZsf10UwBdcdXPyoVE+NPHlQnK0ul/mr
         mxAHqS+kkDqHCoGfNUFSq3INr5TOGHI9tvhJicP8nW7HAi3FrW+z7nztuk29wuVmqWCv
         1SUKMpcR/n8twiVwFTrjNsQIt8ij8PT/hXw1R7xqJU81hh9EfYUuGHuMW0B2ZXLTSUiF
         th2JbqpTak31kP4FM/VH1UIAesWvXdIkdRs8sXkQ3sYQZmaZMqCK1LNOIAQXLaw9TSNM
         XpjhlId5Sc6sUwtK3cX5PCxppMZF6umoPpnltEEhdpPaZWZJrv543rm2eZvXKPRUlrjZ
         daWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kkJanOIEtiwTHNCIrofj7wjT/1euAC35OtiXO+rsH/E=;
        b=HkzkJXRWdBRZ3ZaDKU7UV3u4TW6QqzAcDY5xFUxuGYeprPQBWQbdJ9ip+nXRTL0wHA
         UAx9gKXkakq+tbduQon8Xpw71+8U6HZi6euEicWj+sPK22OW7X5C199yZmIBTCI+RloV
         YUV7M6d4N8UhgFzUDda7NwcbA36wJgb2HeqOoULUEzg82RrYngsdCEhH+DCZr2FJquPA
         Ti4/+CA9BS+2gp5l8dCMul46akoVXcyr8t/jYBW0GRXk/c1wHYDacPzvfRms+AU8H/ij
         MJsZYm1A3rhg8dJuJiVM4XtunhTgHlzZ1gF9u1aIvZBLeh4CGLlbNIojK+AOM/j3etDh
         2chg==
X-Gm-Message-State: AOAM532FzSdiUaqbpZaUngOCKrMDCjkIiCMI/52UFKFpoJXXEg0Ylb/u
        8RZhgcoHouVFJRsNYDxSK+J9KCR7jPo=
X-Google-Smtp-Source: ABdhPJyLusqCid8FHWWE34bs/i16qmL4MuvouQT7oKVY/d5gsIShKLLYlnuuo4YbpUicFqtpGLf9PA==
X-Received: by 2002:aa7:9625:0:b029:1a4:3b48:a19c with SMTP id r5-20020aa796250000b02901a43b48a19cmr4089524pfg.13.1610059962868;
        Thu, 07 Jan 2021 14:52:42 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a10sm6510603pfi.168.2021.01.07.14.52.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:52:42 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Leonard Crestez <leonard.crestez@nxp.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Kieran Bingham <kieran@ksquared.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Kieran Bingham <kieran@ksquared.org.uk>,
        =?UTF-8?q?Andr=C3=A9=20Draszik?= <git@andred.net>,
        Du Changbin <changbin.du@gmail.com>
Subject: [stable 4.9.y 2/4] scripts/gdb: lx-dmesg: cast log_buf to void* for addr fetch
Date:   Thu,  7 Jan 2021 14:52:27 -0800
Message-Id: <20210107225229.1502459-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210107225229.1502459-1-f.fainelli@gmail.com>
References: <20210107225229.1502459-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leonard Crestez <leonard.crestez@nxp.com>

commit c454756f47277b651ad41a5a163499294529e35d upstream

In some cases it is possible for the str() conversion here to throw
encoding errors because log_buf might not point to valid ascii.  For
example:

  (gdb) python print str(gdb.parse_and_eval("log_buf"))
  Traceback (most recent call last):
    File "<string>", line 1, in <module>
  UnicodeEncodeError: 'ascii' codec can't encode character u'\u0303' in
  	position 24: ordinal not in range(128)

Avoid this by explicitly casting to (void *) inside the gdb expression.

Link: http://lkml.kernel.org/r/ba6f85dbb02ca980ebd0e2399b0649423399b565.1498481469.git.leonard.crestez@nxp.com
Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>
Reviewed-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Kieran Bingham <kieran@ksquared.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 scripts/gdb/linux/dmesg.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/gdb/linux/dmesg.py b/scripts/gdb/linux/dmesg.py
index 5afd1098e33a..f5a030333dfd 100644
--- a/scripts/gdb/linux/dmesg.py
+++ b/scripts/gdb/linux/dmesg.py
@@ -24,7 +24,7 @@ class LxDmesg(gdb.Command):
 
     def invoke(self, arg, from_tty):
         log_buf_addr = int(str(gdb.parse_and_eval(
-            "'printk.c'::log_buf")).split()[0], 16)
+            "(void *)'printk.c'::log_buf")).split()[0], 16)
         log_first_idx = int(gdb.parse_and_eval("'printk.c'::log_first_idx"))
         log_next_idx = int(gdb.parse_and_eval("'printk.c'::log_next_idx"))
         log_buf_len = int(gdb.parse_and_eval("'printk.c'::log_buf_len"))
-- 
2.25.1


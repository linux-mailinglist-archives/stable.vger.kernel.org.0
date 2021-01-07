Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7C172EE947
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 23:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729005AbhAGWx2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 17:53:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728500AbhAGWx0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 17:53:26 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF5A5C0612F8;
        Thu,  7 Jan 2021 14:52:45 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id y8so4622853plp.8;
        Thu, 07 Jan 2021 14:52:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2ueD+y4HncE6w9jLMFht2hirEsKe0+RLoakKJGnlCRI=;
        b=F/+dBQ5/TJD3FLQmjpCGt3bHe/bl5YWRtzj81VN8619gn6d0u+7Q9ZQOWi/DCtsHz/
         ppKd/DyuvEb3O74Wz0otcsVgQ7DDELs6GiBfIeSUE9Z0rQsLqPAsPRpPBz0tFXzm/3k4
         iX6EV8df/KfQlJC0aoPUfGZM5bKvgXHd/so5OpOH5iKxHYYz5pvNiHYiuJFBohVR9OgV
         0JoLI7U954HVX3lrLGUXeuipSLwttbkZU3wQVI9EpmPWSDZoE3IX2GHiDnK3l2e2hH0E
         Keb5XFOKyVOuwhrkkvfjhOvrWEcc6A/gi9Dg0HPcFcnJwIVW0aggaAxA+yaL16pn3YRu
         uBVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2ueD+y4HncE6w9jLMFht2hirEsKe0+RLoakKJGnlCRI=;
        b=WlWG2z3mqGxIpUU9vZcUN2pwQIxXLUo0CaIrcxVj3N8UaDH212vR6Ethrc7lTSxGeA
         AQBUO6uN01+wTetaQApkCBdPLgKAc+pOVNpp6/+EzswTyLVf/QBZkGOowxaLZcOSM+H0
         vl3P4+RE9ZYgPEeajPilXEEZFA8SfBRTSp1FyC4yP6czeUn98qwbDNcRHGIVhkaP+6xb
         YmQpl0KSJbQ2MAulByNkTYZcGl8sVo7jfeRTEf8mAQOi233rddGWhSg72W4miHnyjDjD
         ojR46ITq4sL8oRFKmdiCupU5a9QKZIECjS9E+uPIGnh3kj+kXpleGMQbm3f3Uq1wlOyN
         K5eg==
X-Gm-Message-State: AOAM531JUPwUMiCGiLNWttoV8ua+SpoZyw1Lbht2tv24yXSEzjFDT51G
        vs5ImHR/795rDO4wiZhl+YgnEcR8+9I=
X-Google-Smtp-Source: ABdhPJzOr+Go+X8XB+wHjQaMBDvrPAdLRyYoBhbgEE5L9wbzE/CPXN5rzCwqLy/Bk++sgSPCbCpGFA==
X-Received: by 2002:a17:90a:ba88:: with SMTP id t8mr641283pjr.229.1610059964848;
        Thu, 07 Jan 2021 14:52:44 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a10sm6510603pfi.168.2021.01.07.14.52.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:52:44 -0800 (PST)
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
Subject: [stable 4.9.y 3/4] scripts/gdb: lx-dmesg: use explicit encoding=utf8 errors=replace
Date:   Thu,  7 Jan 2021 14:52:28 -0800
Message-Id: <20210107225229.1502459-4-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210107225229.1502459-1-f.fainelli@gmail.com>
References: <20210107225229.1502459-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leonard Crestez <leonard.crestez@nxp.com>

commit 46d10a094353c05144f3b0530516bdac3ce7c435 upstream

Use errors=replace because it is never desirable for lx-dmesg to fail on
string decoding errors, not even if the log buffer is corrupt and we
show incorrect info.

The kernel will sometimes print utf8, for example the copyright symbol
from jffs2.  In order to make this work specify 'utf8' everywhere
because python2 otherwise defaults to 'ascii'.

In theory the second errors='replace' is not be required because
everything that can be decoded as utf8 should also be encodable back to
utf8.  But it's better to be extra safe here.  It's worth noting that
this is definitely not true for encoding='ascii', unknown characters are
replaced with U+FFFD REPLACEMENT CHARACTER and they fail to encode back
to ascii.

Link: http://lkml.kernel.org/r/acee067f3345954ed41efb77b80eebdc038619c6.1498481469.git.leonard.crestez@nxp.com
Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>
Acked-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Kieran Bingham <kieran@ksquared.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 scripts/gdb/linux/dmesg.py | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/scripts/gdb/linux/dmesg.py b/scripts/gdb/linux/dmesg.py
index f5a030333dfd..6d2e09a2ad2f 100644
--- a/scripts/gdb/linux/dmesg.py
+++ b/scripts/gdb/linux/dmesg.py
@@ -12,6 +12,7 @@
 #
 
 import gdb
+import sys
 
 from linux import utils
 
@@ -52,13 +53,19 @@ class LxDmesg(gdb.Command):
                 continue
 
             text_len = utils.read_u16(log_buf[pos + 10:pos + 12])
-            text = log_buf[pos + 16:pos + 16 + text_len].decode()
+            text = log_buf[pos + 16:pos + 16 + text_len].decode(
+                encoding='utf8', errors='replace')
             time_stamp = utils.read_u64(log_buf[pos:pos + 8])
 
             for line in text.splitlines():
-                gdb.write("[{time:12.6f}] {line}\n".format(
+                msg = u"[{time:12.6f}] {line}\n".format(
                     time=time_stamp / 1000000000.0,
-                    line=line))
+                    line=line)
+                # With python2 gdb.write will attempt to convert unicode to
+                # ascii and might fail so pass an utf8-encoded str instead.
+                if sys.hexversion < 0x03000000:
+                    msg = msg.encode(encoding='utf8', errors='replace')
+                gdb.write(msg)
 
             pos += length
 
-- 
2.25.1


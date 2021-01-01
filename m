Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54EAA2E8579
	for <lists+stable@lfdr.de>; Fri,  1 Jan 2021 21:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727334AbhAAUEA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jan 2021 15:04:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727213AbhAAUEA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jan 2021 15:04:00 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5EBFC061573
        for <stable@vger.kernel.org>; Fri,  1 Jan 2021 12:03:19 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id b2so20906841edm.3
        for <stable@vger.kernel.org>; Fri, 01 Jan 2021 12:03:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GGSO8OxkF6hVMbv6PeMzO/mXZvVHJSTmb3a2o4hLj6g=;
        b=XsZoZUDL8IyGBYbhZI7T/CzSLNz6uzXpOAPvCtRbL9RJdUoYJ16b5QLs0QZlYAEUfv
         wKqg9P10HLY0U2wUDQS3b66Zy1VmG+xmVFvQk4ZhCh1ItkVX5+/75zUslHraBwC17Py7
         o5ZSR1o1A8F2QRcqXpDs2QYPR7EkTcPRWecAxQIh3ApkEcSDpgndkykfeJM6C+J2cm3f
         4lOGoPO7ZrRQ1N9UV5yysMEJoL+aH2O+I5nSoOKhuMgZwfy//2yzJGs6worYzSZy8Pnf
         /aVLvdZVkeX16V6k+ZvAHmaHlrpMQygKMnhanMT899BIQ65JOigTCerDXp/527N/3xB0
         hTQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GGSO8OxkF6hVMbv6PeMzO/mXZvVHJSTmb3a2o4hLj6g=;
        b=CQCsG5EKKwmkC4x0+2Dvf9PXLwt1Gd0M5ceqBJy34pdFXWQ8P/mVH3COk1UGntra9N
         oPsLiIO3b/i6552E0v2eswdIb0CvdYvK9rc08JNNJ5l8UhnQqjijHev17Ll31DESGNp8
         WDCyOntCugxYSex+SgAlILDN31UnlE1wZ8J7PXBwSfcT26fidV8uA00+sxUN81qyx2ic
         qyyT0Q5YqN1tldDEUSa4/V3dwlKPqsk30iR9qG8nUmLC+xxq82NDoDfofxkpaRJQxEUs
         UftY4FzVM/TLakhY0VqC30gYfZqIec6LV1j2B83w8My/xD6P5N3taxY+e5pOvxXgv/xU
         Eamg==
X-Gm-Message-State: AOAM531U4Mrm3FsjPoeTyfRZUoY4IcwRhAPGRP9Jao5+DVCiwSIx4AL4
        7sDLyW5ODnFAto01Fg8dxcR1+y2ervNplg==
X-Google-Smtp-Source: ABdhPJxtGpDjWYmQS/fG/j+y6GTxlsqVAB7JQnjU/YWwXdenh/bvqz0AbvcI2dozTv87+LPPU4Pm+g==
X-Received: by 2002:a05:6402:4c1:: with SMTP id n1mr46670417edw.66.1609531398170;
        Fri, 01 Jan 2021 12:03:18 -0800 (PST)
Received: from localhost.localdomain ([62.201.25.198])
        by smtp.gmail.com with ESMTPSA id bn21sm21278980ejb.47.2021.01.01.12.03.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jan 2021 12:03:17 -0800 (PST)
From:   Petr Vorel <petr.vorel@gmail.com>
To:     stable@vger.kernel.org
Cc:     Petr Vorel <petr.vorel@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, Rich Felker <dalias@libc.org>,
        Peter Korsgaard <peter@korsgaard.com>,
        Baruch Siach <baruch@tkos.co.il>,
        Florian Weimer <fweimer@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] uapi: move constants from <linux/kernel.h> to <linux/const.h>
Date:   Fri,  1 Jan 2021 21:03:08 +0100
Message-Id: <20210101200308.22770-1-petr.vorel@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

and include <linux/const.h> in UAPI headers instead of <linux/kernel.h>.

commit a85cbe6159ffc973e5702f70a3bd5185f8f3c38d upstream.

The reason is to avoid indirect <linux/sysinfo.h> include when using
some network headers: <linux/netlink.h> or others -> <linux/kernel.h>
-> <linux/sysinfo.h>.

This indirect include causes on MUSL redefinition of struct sysinfo when
included both <sys/sysinfo.h> and some of UAPI headers:

    In file included from x86_64-buildroot-linux-musl/sysroot/usr/include/linux/kernel.h:5,
                     from x86_64-buildroot-linux-musl/sysroot/usr/include/linux/netlink.h:5,
                     from ../include/tst_netlink.h:14,
                     from tst_crypto.c:13:
    x86_64-buildroot-linux-musl/sysroot/usr/include/linux/sysinfo.h:8:8: error: redefinition of `struct sysinfo'
     struct sysinfo {
            ^~~~~~~
    In file included from ../include/tst_safe_macros.h:15,
                     from ../include/tst_test.h:93,
                     from tst_crypto.c:11:
    x86_64-buildroot-linux-musl/sysroot/usr/include/sys/sysinfo.h:10:8: note: originally defined here

Link: https://lkml.kernel.org/r/20201015190013.8901-1-petr.vorel@gmail.com
Signed-off-by: Petr Vorel <petr.vorel@gmail.com>
Suggested-by: Rich Felker <dalias@aerifal.cx>
Acked-by: Rich Felker <dalias@libc.org>
Cc: Peter Korsgaard <peter@korsgaard.com>
Cc: Baruch Siach <baruch@tkos.co.il>
Cc: Florian Weimer <fweimer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
Hi,

could this fix be backported to stable releases?
Maybe safer to wait till v5.11 release.

Adjusted for stable/linux-4.9.y.

Kind regards,
Petr

 include/uapi/linux/const.h              | 5 +++++
 include/uapi/linux/lightnvm.h           | 2 +-
 include/uapi/linux/netfilter/x_tables.h | 2 +-
 include/uapi/linux/netlink.h            | 2 +-
 include/uapi/linux/sysctl.h             | 2 +-
 5 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/const.h b/include/uapi/linux/const.h
index c872bfd25e13..03c3e1869be7 100644
--- a/include/uapi/linux/const.h
+++ b/include/uapi/linux/const.h
@@ -24,4 +24,9 @@
 #define _BITUL(x)	(_AC(1,UL) << (x))
 #define _BITULL(x)	(_AC(1,ULL) << (x))
 
+#define __ALIGN_KERNEL(x, a)		__ALIGN_KERNEL_MASK(x, (typeof(x))(a) - 1)
+#define __ALIGN_KERNEL_MASK(x, mask)	(((x) + (mask)) & ~(mask))
+
+#define __KERNEL_DIV_ROUND_UP(n, d) (((n) + (d) - 1) / (d))
+
 #endif /* !(_LINUX_CONST_H) */
diff --git a/include/uapi/linux/lightnvm.h b/include/uapi/linux/lightnvm.h
index 928f98997d8a..4acefd697677 100644
--- a/include/uapi/linux/lightnvm.h
+++ b/include/uapi/linux/lightnvm.h
@@ -20,7 +20,7 @@
 #define _UAPI_LINUX_LIGHTNVM_H
 
 #ifdef __KERNEL__
-#include <linux/kernel.h>
+#include <linux/const.h>
 #include <linux/ioctl.h>
 #else /* __KERNEL__ */
 #include <stdio.h>
diff --git a/include/uapi/linux/netfilter/x_tables.h b/include/uapi/linux/netfilter/x_tables.h
index c36969b91533..8f40c2fe0ed4 100644
--- a/include/uapi/linux/netfilter/x_tables.h
+++ b/include/uapi/linux/netfilter/x_tables.h
@@ -1,6 +1,6 @@
 #ifndef _UAPI_X_TABLES_H
 #define _UAPI_X_TABLES_H
-#include <linux/kernel.h>
+#include <linux/const.h>
 #include <linux/types.h>
 
 #define XT_FUNCTION_MAXNAMELEN 30
diff --git a/include/uapi/linux/netlink.h b/include/uapi/linux/netlink.h
index 0dba4e4ed2be..b5b4fd791fc8 100644
--- a/include/uapi/linux/netlink.h
+++ b/include/uapi/linux/netlink.h
@@ -1,7 +1,7 @@
 #ifndef _UAPI__LINUX_NETLINK_H
 #define _UAPI__LINUX_NETLINK_H
 
-#include <linux/kernel.h>
+#include <linux/const.h>
 #include <linux/socket.h> /* for __kernel_sa_family_t */
 #include <linux/types.h>
 
diff --git a/include/uapi/linux/sysctl.h b/include/uapi/linux/sysctl.h
index 0956373b56db..436204409d08 100644
--- a/include/uapi/linux/sysctl.h
+++ b/include/uapi/linux/sysctl.h
@@ -22,7 +22,7 @@
 #ifndef _UAPI_LINUX_SYSCTL_H
 #define _UAPI_LINUX_SYSCTL_H
 
-#include <linux/kernel.h>
+#include <linux/const.h>
 #include <linux/types.h>
 #include <linux/compiler.h>
 
-- 
2.29.2


Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5922E857E
	for <lists+stable@lfdr.de>; Fri,  1 Jan 2021 21:11:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727155AbhAAULI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jan 2021 15:11:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727088AbhAAULI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jan 2021 15:11:08 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F404DC061573
        for <stable@vger.kernel.org>; Fri,  1 Jan 2021 12:10:27 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id g20so28885862ejb.1
        for <stable@vger.kernel.org>; Fri, 01 Jan 2021 12:10:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=F1P8mbB705ykxmF6spFqbhcvWM3TKxUZa1C4TjIJzcs=;
        b=nyv/RclcnsUivaYH/lNAsLGKPhuThAthlMSsnEYrjuBkaty1oH8dLuIyxcu6QpccZi
         HJ/uD0/dRRH7NJLWz1+UyUXMhjxl/jJ0PzyptxbSTZzWcDnHe4wYlAoxcerKPHlTA8xF
         mAkCJCIDdZlbvyAGo7LLe2JkWuzwv2KeTvZHlCyhZLGzVaKGz+r6JeAjxIA6dyu5XSuO
         /70ARczDLPtxfDsWELzx80BfUq3lcj+TMDG/vnzTzKsAEZrw8yL71wq9rNR50lwAt7Zs
         Jb3U6rbnvATJa1LIM2acsHrElOO3s2tl2C7UE6yrTKsv59nVyM62Y2kgQobBYqHxaKR0
         eR6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=F1P8mbB705ykxmF6spFqbhcvWM3TKxUZa1C4TjIJzcs=;
        b=h1FmkYCtdfKdCCOo2IUa7i2nGGCqbKfKBj28Q2GIarQnvpaoiINPRBZpLvUbsfD2Rf
         EJjW+v65gY7k4YRNpM0eWI9DMDek+f5ZzUrLdzo1xtWYPzdyeJm7xCoKBnB4Oo2oKNJT
         ZDQhkg4LYIzhTDqFGiYTllfkWNYaZ5ZY9BTY67P0tIJ8ZFYTgRgqT8oyoL4fLt/V9Cbr
         lPIEekFCldHuYsiFuoJ7eNbjF8+cZlPKFGeOpCgksaBeVNc+Ncdv7mIkBfGLiCp2Bl3i
         kTiJ4ZErSMJ2KWiv7cHZBPt/fFPB/VZC4Kc0DRfQ5IehMOipwDxxVeRibOkZltNmaLr7
         LsHA==
X-Gm-Message-State: AOAM5316ylWJDhvly+E/iX1ol6R1jFAaIaBCxiwVwFD0ON/cCtlkrHy7
        rpMhwWvQsmqGuwoJc9DHWuovLYxoiuzNHw==
X-Google-Smtp-Source: ABdhPJx1qkVFhjNQPriaQMypLgFqCT8jhdzlwNvi2MKVsgjzS98fm2h5lQ7LKXY5V9ICacNivSD1Ag==
X-Received: by 2002:a17:906:f153:: with SMTP id gw19mr59475481ejb.272.1609531826610;
        Fri, 01 Jan 2021 12:10:26 -0800 (PST)
Received: from localhost.localdomain ([62.201.25.198])
        by smtp.gmail.com with ESMTPSA id d3sm37221605edt.32.2021.01.01.12.10.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jan 2021 12:10:26 -0800 (PST)
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
Date:   Fri,  1 Jan 2021 21:10:00 +0100
Message-Id: <20210101201000.24353-1-petr.vorel@gmail.com>
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

Adjusted for stable/linux-4.14.y.

Kind regards,
Petr

 include/uapi/linux/const.h              | 5 +++++
 include/uapi/linux/ethtool.h            | 2 +-
 include/uapi/linux/kernel.h             | 9 +--------
 include/uapi/linux/lightnvm.h           | 2 +-
 include/uapi/linux/mroute6.h            | 2 +-
 include/uapi/linux/netfilter/x_tables.h | 2 +-
 include/uapi/linux/netlink.h            | 2 +-
 include/uapi/linux/sysctl.h             | 2 +-
 8 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/include/uapi/linux/const.h b/include/uapi/linux/const.h
index 92537757590a..dab9f34383e5 100644
--- a/include/uapi/linux/const.h
+++ b/include/uapi/linux/const.h
@@ -25,4 +25,9 @@
 #define _BITUL(x)	(_AC(1,UL) << (x))
 #define _BITULL(x)	(_AC(1,ULL) << (x))
 
+#define __ALIGN_KERNEL(x, a)		__ALIGN_KERNEL_MASK(x, (typeof(x))(a) - 1)
+#define __ALIGN_KERNEL_MASK(x, mask)	(((x) + (mask)) & ~(mask))
+
+#define __KERNEL_DIV_ROUND_UP(n, d) (((n) + (d) - 1) / (d))
+
 #endif /* !(_LINUX_CONST_H) */
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 9eae13eefc49..1e3f1a43bf1d 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -14,7 +14,7 @@
 #ifndef _UAPI_LINUX_ETHTOOL_H
 #define _UAPI_LINUX_ETHTOOL_H
 
-#include <linux/kernel.h>
+#include <linux/const.h>
 #include <linux/types.h>
 #include <linux/if_ether.h>
 
diff --git a/include/uapi/linux/kernel.h b/include/uapi/linux/kernel.h
index 0ff8f7477847..fadf2db71fe8 100644
--- a/include/uapi/linux/kernel.h
+++ b/include/uapi/linux/kernel.h
@@ -3,13 +3,6 @@
 #define _UAPI_LINUX_KERNEL_H
 
 #include <linux/sysinfo.h>
-
-/*
- * 'kernel.h' contains some often-used function prototypes etc
- */
-#define __ALIGN_KERNEL(x, a)		__ALIGN_KERNEL_MASK(x, (typeof(x))(a) - 1)
-#define __ALIGN_KERNEL_MASK(x, mask)	(((x) + (mask)) & ~(mask))
-
-#define __KERNEL_DIV_ROUND_UP(n, d) (((n) + (d) - 1) / (d))
+#include <linux/const.h>
 
 #endif /* _UAPI_LINUX_KERNEL_H */
diff --git a/include/uapi/linux/lightnvm.h b/include/uapi/linux/lightnvm.h
index 42d1a434af29..0d44ebba0093 100644
--- a/include/uapi/linux/lightnvm.h
+++ b/include/uapi/linux/lightnvm.h
@@ -21,7 +21,7 @@
 #define _UAPI_LINUX_LIGHTNVM_H
 
 #ifdef __KERNEL__
-#include <linux/kernel.h>
+#include <linux/const.h>
 #include <linux/ioctl.h>
 #else /* __KERNEL__ */
 #include <stdio.h>
diff --git a/include/uapi/linux/mroute6.h b/include/uapi/linux/mroute6.h
index 9999cc006390..1617eb9949a5 100644
--- a/include/uapi/linux/mroute6.h
+++ b/include/uapi/linux/mroute6.h
@@ -2,7 +2,7 @@
 #ifndef _UAPI__LINUX_MROUTE6_H
 #define _UAPI__LINUX_MROUTE6_H
 
-#include <linux/kernel.h>
+#include <linux/const.h>
 #include <linux/types.h>
 #include <linux/sockios.h>
 #include <linux/in6.h>		/* For struct sockaddr_in6. */
diff --git a/include/uapi/linux/netfilter/x_tables.h b/include/uapi/linux/netfilter/x_tables.h
index a8283f7dbc51..b8c6bb233ac1 100644
--- a/include/uapi/linux/netfilter/x_tables.h
+++ b/include/uapi/linux/netfilter/x_tables.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
 #ifndef _UAPI_X_TABLES_H
 #define _UAPI_X_TABLES_H
-#include <linux/kernel.h>
+#include <linux/const.h>
 #include <linux/types.h>
 
 #define XT_FUNCTION_MAXNAMELEN 30
diff --git a/include/uapi/linux/netlink.h b/include/uapi/linux/netlink.h
index 776bc92e9118..3481cde43a84 100644
--- a/include/uapi/linux/netlink.h
+++ b/include/uapi/linux/netlink.h
@@ -2,7 +2,7 @@
 #ifndef _UAPI__LINUX_NETLINK_H
 #define _UAPI__LINUX_NETLINK_H
 
-#include <linux/kernel.h>
+#include <linux/const.h>
 #include <linux/socket.h> /* for __kernel_sa_family_t */
 #include <linux/types.h>
 
diff --git a/include/uapi/linux/sysctl.h b/include/uapi/linux/sysctl.h
index 0f272818a4d2..5fc0b7fd0847 100644
--- a/include/uapi/linux/sysctl.h
+++ b/include/uapi/linux/sysctl.h
@@ -23,7 +23,7 @@
 #ifndef _UAPI_LINUX_SYSCTL_H
 #define _UAPI_LINUX_SYSCTL_H
 
-#include <linux/kernel.h>
+#include <linux/const.h>
 #include <linux/types.h>
 #include <linux/compiler.h>
 
-- 
2.29.2


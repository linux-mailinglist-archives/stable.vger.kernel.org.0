Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1132E857C
	for <lists+stable@lfdr.de>; Fri,  1 Jan 2021 21:07:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727333AbhAAUHe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jan 2021 15:07:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727213AbhAAUHe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jan 2021 15:07:34 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DC34C061757
        for <stable@vger.kernel.org>; Fri,  1 Jan 2021 12:06:53 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id y24so20851339edt.10
        for <stable@vger.kernel.org>; Fri, 01 Jan 2021 12:06:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oM0vVQLrhSB0K7nJ3VEUzVcJjdbN6oxKjUTC3pQ/Gsc=;
        b=r72WZFIuyPTdGJB2+tM+6UP3RB18Fw3RYJ3XHhmPld1Ry0603hPInJ17AMGpIQUXnw
         sEEAXGbD/thIv3Ub9kWwozoRYWnWKANUCLUwj+vZrhmuNEXqF1v9vyJcUwdSLnQKuZIg
         3bvfiMLms0OORUDtEoyh8dipSTjuitDzAPTVhlCT0SKqvhoMoy9ty/MtsZPzYmUagsDr
         E+4Qx18xo51IHdOoIBYdBlx5h4DLRB70vqoem8U/GTvejQkbqbBHUFGVkN4G11+YinJ3
         vTGbZCCHisZuTV1TwgImi9u+dMVrvDtlXFHTRFDar22CeKnfMKR3qpv+pxtSmh6zrpO0
         70Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oM0vVQLrhSB0K7nJ3VEUzVcJjdbN6oxKjUTC3pQ/Gsc=;
        b=cWsV5RzlHfTVPmPIbPKGqHiR0DMxICEETNuHvC8h53vbQLDuJBwkyUlqG55kzgarj7
         JGjZFBabjkBgk/if/JZAnFyA+JLh3oDqv3w836N2hRsgl8472pG93jXkP/d2pyUEdqyY
         o1R7zc2Eixu55M1utV26gMV1UQohFctOttt5HXeoVM/4yBPBCCtSIYPuDVerVCk3psTz
         fAlBnbb+PwJCt2kIYkpsYurWhsu7G/T0Gxui+6S4Qxi0ytMoYnRRnLX5iZeHHLw9DH/S
         xxNMRLQnotDWqNqP1cx3/g6ECPtL0gnuYiZt2rr1G5P6R7WJxvJ75KqngRELHEEWHhIF
         XBNA==
X-Gm-Message-State: AOAM533x4B9ejE9fG0JdeGOpUlnh5zMnpfwuhWm9eYPDN98+mU9+eef3
        LIvSz8TedPiA2wX5cfUzy6pA2QYf4ZuP+A==
X-Google-Smtp-Source: ABdhPJxb4WIDxitQZBBCTgLdZeYqFUgl4GMNHHJFDWX9GNeYMRsVjk0P+qUZ98SnHRYo+YPpMQic6g==
X-Received: by 2002:aa7:d74d:: with SMTP id a13mr61485094eds.78.1609531612336;
        Fri, 01 Jan 2021 12:06:52 -0800 (PST)
Received: from localhost.localdomain ([62.201.25.198])
        by smtp.gmail.com with ESMTPSA id w10sm21051408ejq.121.2021.01.01.12.06.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jan 2021 12:06:51 -0800 (PST)
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
Date:   Fri,  1 Jan 2021 21:06:44 +0100
Message-Id: <20210101200644.23404-1-petr.vorel@gmail.com>
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
 include/uapi/linux/ethtool.h            | 2 +-
 include/uapi/linux/kernel.h             | 9 +--------
 include/uapi/linux/lightnvm.h           | 2 +-
 include/uapi/linux/mroute6.h            | 2 +-
 include/uapi/linux/netfilter/x_tables.h | 2 +-
 include/uapi/linux/netlink.h            | 2 +-
 include/uapi/linux/sysctl.h             | 2 +-
 8 files changed, 12 insertions(+), 14 deletions(-)

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
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 5dd3332ebc66..e7e4e672d9a8 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -13,7 +13,7 @@
 #ifndef _UAPI_LINUX_ETHTOOL_H
 #define _UAPI_LINUX_ETHTOOL_H
 
-#include <linux/kernel.h>
+#include <linux/const.h>
 #include <linux/types.h>
 #include <linux/if_ether.h>
 
diff --git a/include/uapi/linux/kernel.h b/include/uapi/linux/kernel.h
index 466073f0ce46..6e8db547fbd0 100644
--- a/include/uapi/linux/kernel.h
+++ b/include/uapi/linux/kernel.h
@@ -2,13 +2,6 @@
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
index 774a43128a7a..fd18dcf76ec6 100644
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
diff --git a/include/uapi/linux/mroute6.h b/include/uapi/linux/mroute6.h
index ed5721148768..54543bca1b79 100644
--- a/include/uapi/linux/mroute6.h
+++ b/include/uapi/linux/mroute6.h
@@ -1,7 +1,7 @@
 #ifndef _UAPI__LINUX_MROUTE6_H
 #define _UAPI__LINUX_MROUTE6_H
 
-#include <linux/kernel.h>
+#include <linux/const.h>
 #include <linux/types.h>
 #include <linux/sockios.h>
 #include <linux/in6.h>		/* For struct sockaddr_in6. */
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
index d2b12152e358..954bd77326df 100644
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


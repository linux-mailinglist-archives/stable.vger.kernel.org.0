Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08B85370FB2
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 01:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232166AbhEBXSa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 19:18:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbhEBXS3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 May 2021 19:18:29 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B479C06174A
        for <stable@vger.kernel.org>; Sun,  2 May 2021 16:17:37 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id z6so3694287wrm.4
        for <stable@vger.kernel.org>; Sun, 02 May 2021 16:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :content-transfer-encoding;
        bh=ko1Kz2dMQR+GXqMlTpurY9tWFozfSMmE+BT/6U/k7hg=;
        b=KzpOZTpT8H5Sg17gPuusgxn/WehSkLGgrongVwue7GF8/lq5fJBDrMFOaOkuhuwxll
         HGPtCWkred08YCfQXjQy9iX4zKr88Xabl6qUE3g4b8PFbvhMu2IYNUL1zRqd5XAoCRev
         97jPoybjVyslDuRxXqpQWA7C3li/dzt9BLhd27yKigySgZQD6Bj3OkSaULqhnHguAPSM
         h1/h7Cex+SitI/q1Z1dFRIYYWPnPL83KsaPcQBg6ys14lcBe03gY23+MCXygCuZtZWbg
         jQjlXzyyAm6IgxSVaPnm4orSn7UrjstYsasBUDWM09c/5OQsvT8tVjWlIy8APKJkA3Mg
         AKhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding;
        bh=ko1Kz2dMQR+GXqMlTpurY9tWFozfSMmE+BT/6U/k7hg=;
        b=OGRzgOFihhqXye9edEjLIEyZmJcFDB/mk6ZxX31nRTF/RzrGCHAVT2SDtq9NX+GtXQ
         jK9R7W7LMcYLFpnxky9YuttAK1shd9SraEphxqkZWStQCh10OsRxBwzomlglf29koLem
         Y/dhyA/p+j56+JPS5neS/rWWsolz+jQhWik0oohTSCQD66AT1rldOmtOfQVWL5MRvvjS
         mkOI5gOBP0iGqXmakBY2X4gvaO2I5TWzgJ4u4lfQCGGkjQhnTiJdBqIumfgLr7D18Mof
         7XnOR9LqFkCELUMtZWVGusN9c1+mkPWjXQnYPzKAboBXupjP8hqLgFzGFCqPwExNvw7W
         BmrQ==
X-Gm-Message-State: AOAM5312T5jC2bMmxUWCvwRF1xWIc5SPfVd8n63rg5P1pHPScdJfZgN7
        Km2I7PGdp5F+AQcQceSb+88=
X-Google-Smtp-Source: ABdhPJx8ECyYouJAnrQTlKt4zcYgcvaXr5V7VYxN86Xuqu8eD4fkULfiS6UcQB4ocRlKSYT4+ZGFuA==
X-Received: by 2002:adf:9d48:: with SMTP id o8mr21083315wre.183.1619997455873;
        Sun, 02 May 2021 16:17:35 -0700 (PDT)
Received: from debian (host-2-98-62-17.as13285.net. [2.98.62.17])
        by smtp.gmail.com with ESMTPSA id f4sm10465271wrz.33.2021.05.02.16.17.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 May 2021 16:17:35 -0700 (PDT)
Date:   Mon, 3 May 2021 00:17:33 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Romain Naour <romain.naour@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: backport of 1d7ba0165d82 ("mips: Do not include hi and lo in clobber
 list for R6") for 4.14-stable
Message-ID: <YI8zDV+b6j1u6QA4@debian>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1EuHtrLrVyh/agl0"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--1EuHtrLrVyh/agl0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

Attached is the backport of 1d7ba0165d82 ("mips: Do not include hi and lo
in clobber list for R6") for 4.14-stable.

It will also need two more commits (attached).
1690905240fd ("MIPS: Introduce isa-rev.h to define MIPS_ISA_REV")
18ba210a29d0 ("MIPS: cpu-features.h: Replace __mips_isa_rev with MIPS_ISA_REV")


--
Regards
Sudip

--1EuHtrLrVyh/agl0
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-MIPS-Introduce-isa-rev.h-to-define-MIPS_ISA_REV.patch"

From 098929f616c8905fe7ada0e6c0bf72e53efadfcc Mon Sep 17 00:00:00 2001
From: Matt Redfearn <matt.redfearn@mips.com>
Date: Mon, 26 Feb 2018 17:02:42 +0000
Subject: [PATCH 1/3] MIPS: Introduce isa-rev.h to define MIPS_ISA_REV

commit 1690905240fd45cc04e873312df8574631c9f595 upstream

There are multiple instances in the kernel where we need to include or
exclude particular instructions based on the ISA revision of the target
processor. For MIPS32 / MIPS64, the compiler exports a __mips_isa_rev
define. However, when targeting MIPS I - V, this define is absent. This
leads to each use of __mips_isa_rev having to check that it is defined
first. To simplify this, introduce the isa-rev.h header which always
exports MIPS_ISA_REV. The name is changed so as to avoid confusion with
the compiler builtin and to avoid accidentally using the builtin.
MIPS_ISA_REV is defined to the compilers builtin if provided, or 0,
which satisfies all current usages.

Suggested-by: Paul Burton <paul.burton@mips.com>
Signed-off-by: Matt Redfearn <matt.redfearn@mips.com>
Reviewed-by: Maciej W. Rozycki <macro@mips.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org
Patchwork: https://patchwork.linux-mips.org/patch/18676/
Signed-off-by: James Hogan <jhogan@kernel.org>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 arch/mips/include/asm/isa-rev.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)
 create mode 100644 arch/mips/include/asm/isa-rev.h

diff --git a/arch/mips/include/asm/isa-rev.h b/arch/mips/include/asm/isa-rev.h
new file mode 100644
index 000000000000..683ea3454dcb
--- /dev/null
+++ b/arch/mips/include/asm/isa-rev.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2018 MIPS Tech, LLC
+ * Author: Matt Redfearn <matt.redfearn@mips.com>
+ */
+
+#ifndef __MIPS_ASM_ISA_REV_H__
+#define __MIPS_ASM_ISA_REV_H__
+
+/*
+ * The ISA revision level. This is 0 for MIPS I to V and N for
+ * MIPS{32,64}rN.
+ */
+
+/* If the compiler has defined __mips_isa_rev, believe it. */
+#ifdef __mips_isa_rev
+#define MIPS_ISA_REV __mips_isa_rev
+#else
+/* The compiler hasn't defined the isa rev so assume it's MIPS I - V (0) */
+#define MIPS_ISA_REV 0
+#endif
+
+
+#endif /* __MIPS_ASM_ISA_REV_H__ */
-- 
2.30.2


--1EuHtrLrVyh/agl0
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0002-MIPS-cpu-features.h-Replace-__mips_isa_rev-with-MIPS.patch"

From bbd101055aae7d6e18b555f4afa2328f2deb849c Mon Sep 17 00:00:00 2001
From: Matt Redfearn <matt.redfearn@mips.com>
Date: Mon, 26 Feb 2018 17:02:43 +0000
Subject: [PATCH 2/3] MIPS: cpu-features.h: Replace __mips_isa_rev with
 MIPS_ISA_REV

commit 18ba210a29d08ea96025cb9d19c2eebf65846330 upstream

Remove the need to check that __mips_isa_rev is defined by using the
newly added MIPS_ISA_REV.

Signed-off-by: Matt Redfearn <matt.redfearn@mips.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Paul Burton <paul.burton@mips.com>
Cc: "Maciej W. Rozycki" <macro@mips.com>
Cc: linux-mips@linux-mips.org
Patchwork: https://patchwork.linux-mips.org/patch/18675/
Signed-off-by: James Hogan <jhogan@kernel.org>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 arch/mips/include/asm/cpu-features.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/mips/include/asm/cpu-features.h b/arch/mips/include/asm/cpu-features.h
index 721b698bfe3c..5f74590e0bea 100644
--- a/arch/mips/include/asm/cpu-features.h
+++ b/arch/mips/include/asm/cpu-features.h
@@ -11,6 +11,7 @@
 
 #include <asm/cpu.h>
 #include <asm/cpu-info.h>
+#include <asm/isa-rev.h>
 #include <cpu-feature-overrides.h>
 
 /*
@@ -493,7 +494,7 @@
 # define cpu_has_perf		(cpu_data[0].options & MIPS_CPU_PERF)
 #endif
 
-#if defined(CONFIG_SMP) && defined(__mips_isa_rev) && (__mips_isa_rev >= 6)
+#if defined(CONFIG_SMP) && (MIPS_ISA_REV >= 6)
 /*
  * Some systems share FTLB RAMs between threads within a core (siblings in
  * kernel parlance). This means that FTLB entries may become invalid at almost
@@ -525,7 +526,7 @@
 #  define cpu_has_shared_ftlb_entries \
 	(current_cpu_data.options & MIPS_CPU_SHARED_FTLB_ENTRIES)
 # endif
-#endif /* SMP && __mips_isa_rev >= 6 */
+#endif /* SMP && MIPS_ISA_REV >= 6 */
 
 #ifndef cpu_has_shared_ftlb_ram
 # define cpu_has_shared_ftlb_ram 0
-- 
2.30.2


--1EuHtrLrVyh/agl0
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0003-mips-Do-not-include-hi-and-lo-in-clobber-list-for-R6.patch"
Content-Transfer-Encoding: 8bit

From 2c7a12964194c882de7443ff98d8be0fd5bcf7b4 Mon Sep 17 00:00:00 2001
From: Romain Naour <romain.naour@gmail.com>
Date: Tue, 20 Apr 2021 22:12:10 +0100
Subject: [PATCH 3/3] mips: Do not include hi and lo in clobber list for R6
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

commit 1d7ba0165d8206ac073f7ac3b14fc0836b66eae7 upstream

From [1]
"GCC 10 (PR 91233) won't silently allow registers that are not
architecturally available to be present in the clobber list anymore,
resulting in build failure for mips*r6 targets in form of:
...
.../sysdep.h:146:2: error: the register ‘lo’ cannot be clobbered in ‘asm’ for the current target
  146 |  __asm__ volatile (      \
      |  ^~~~~~~

This is because base R6 ISA doesn't define hi and lo registers w/o DSP
extension. This patch provides the alternative clobber list for r6 targets
that won't include those registers."

Since kernel 5.4 and mips support for generic vDSO [2], the kernel fail to
build for mips r6 cpus with gcc 10 for the same reason as glibc.

[1] https://sourceware.org/git/?p=glibc.git;a=commit;h=020b2a97bb15f807c0482f0faee2184ed05bcad8
[2] '24640f233b46 ("mips: Add support for generic vDSO")'

Signed-off-by: Romain Naour <romain.naour@gmail.com>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 arch/mips/vdso/gettimeofday.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/mips/vdso/gettimeofday.c b/arch/mips/vdso/gettimeofday.c
index e22b422f282c..9fdc84fc3985 100644
--- a/arch/mips/vdso/gettimeofday.c
+++ b/arch/mips/vdso/gettimeofday.c
@@ -18,6 +18,12 @@
 #include <asm/unistd.h>
 #include <asm/vdso.h>
 
+#if MIPS_ISA_REV < 6
+#define VDSO_SYSCALL_CLOBBERS "hi", "lo",
+#else
+#define VDSO_SYSCALL_CLOBBERS
+#endif
+
 #ifdef CONFIG_MIPS_CLOCK_VSYSCALL
 
 static __always_inline long gettimeofday_fallback(struct timeval *_tv,
@@ -34,7 +40,9 @@ static __always_inline long gettimeofday_fallback(struct timeval *_tv,
 	: "=r" (ret), "=r" (error)
 	: "r" (tv), "r" (tz), "r" (nr)
 	: "$1", "$3", "$8", "$9", "$10", "$11", "$12", "$13",
-	  "$14", "$15", "$24", "$25", "hi", "lo", "memory");
+	  "$14", "$15", "$24", "$25",
+	  VDSO_SYSCALL_CLOBBERS
+	  "memory");
 
 	return error ? -ret : ret;
 }
@@ -55,7 +63,9 @@ static __always_inline long clock_gettime_fallback(clockid_t _clkid,
 	: "=r" (ret), "=r" (error)
 	: "r" (clkid), "r" (ts), "r" (nr)
 	: "$1", "$3", "$8", "$9", "$10", "$11", "$12", "$13",
-	  "$14", "$15", "$24", "$25", "hi", "lo", "memory");
+	  "$14", "$15", "$24", "$25",
+	  VDSO_SYSCALL_CLOBBERS
+	  "memory");
 
 	return error ? -ret : ret;
 }
-- 
2.30.2


--1EuHtrLrVyh/agl0--

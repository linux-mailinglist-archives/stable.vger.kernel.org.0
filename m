Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5BE370FAF
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 01:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbhEBXOM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 19:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232603AbhEBXOL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 May 2021 19:14:11 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 801E6C06174A
        for <stable@vger.kernel.org>; Sun,  2 May 2021 16:13:16 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id h4so3663129wrt.12
        for <stable@vger.kernel.org>; Sun, 02 May 2021 16:13:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :content-transfer-encoding;
        bh=3tuVSC6vDNpKfrCjJUe/nCxX97q6ktVH9sjkVIVEHuw=;
        b=VMLHXDMCI7WnWEo0qE21ncp3mIiVTI3/6erZ1BWswUsfZl4XP3bX8OL2t+VusgeqUa
         yfPQRo70m5zT/uRQbj9vcyaUsf8nVuz3lHEIe9JLDpYh9wJz36OriypK4sYLBTYR0cZ1
         UjRtJeOAQSdAc/DtBvyjFhzNpEyNcqmODsc/lpqn00uRKBsCRpqkC+r+JjGXsHUUCVmo
         BvVasReTusVRfJ7k1QnWTywM9POUT1NKqRn1pN7kYoWSdSavYm6hTu9FBvt/+hgeuXUY
         JiFj63eOU4VeSoVpSHsbJs7ecSEVZbymjkwCLfpcJqZfuUnHJovAoSklCTqodRjy7g3S
         zFUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding;
        bh=3tuVSC6vDNpKfrCjJUe/nCxX97q6ktVH9sjkVIVEHuw=;
        b=Xgku6octF8sOv0kLy1HCY99ZvX4KoYwxfQ1SF/L1KTKmj9OflDZwsn9ILNxum+upPM
         G6selBEpnAa9oJs798LhNRpuanTXUXrvJQGWau99nTwGYgkCTkNl9fI7PjQIXdIOYoh3
         PVkDcv3/UtkYJVWb5FyGa17DDTDjFrcqZ6nnSY+gwJO+cwerlpG/QWsk1OKyqxmz/0ot
         OpUBib/rCwtIvESvgRKXOerjCJ7Lzvtz27RzZ03Sm5XGSxqrZ3BKdj3/xVNDRIAn3AQ9
         KupDJjfgd1kZl7U2hTDrkKCg/ReTDYMjDpM3nJcxxRoQplIQQRG7nTLmxhFcctqY8mvF
         FcFQ==
X-Gm-Message-State: AOAM532KU3Z0iPY/2U2NN+Lv2JT1mwfK7v4ORzBOgzVKzqKbJbWHdMjJ
        S2FaRR0inJ9CEEOyPTDfIsQ=
X-Google-Smtp-Source: ABdhPJwXi6U4ZTlrv65bMHe0Tvfa9fFmcxBJBqgIYLY83DhYYLDK398niVS5ffWvY3sPZ5gz2s7drg==
X-Received: by 2002:a5d:608a:: with SMTP id w10mr17707793wrt.342.1619997195177;
        Sun, 02 May 2021 16:13:15 -0700 (PDT)
Received: from debian (host-2-98-62-17.as13285.net. [2.98.62.17])
        by smtp.gmail.com with ESMTPSA id a2sm10872524wrt.82.2021.05.02.16.13.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 May 2021 16:13:14 -0700 (PDT)
Date:   Mon, 3 May 2021 00:13:13 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Romain Naour <romain.naour@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: backport of 1d7ba0165d82 ("mips: Do not include hi and lo in clobber
 list for R6") for 4.19-stable
Message-ID: <YI8yCa3zqHTmm25V@debian>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="IW4QZ7hvdV4P+Mia"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--IW4QZ7hvdV4P+Mia
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

Attached is the backport of 1d7ba0165d82 ("mips: Do not include hi and
lo in clobber list for R6") for 4.19-stable.


--
Regards
Sudip

--IW4QZ7hvdV4P+Mia
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0001-mips-Do-not-include-hi-and-lo-in-clobber-list-for-R6.patch"
Content-Transfer-Encoding: 8bit

From 5f2fac41073b083bec0463ac3d40b162d0fffaed Mon Sep 17 00:00:00 2001
From: Romain Naour <romain.naour@gmail.com>
Date: Tue, 20 Apr 2021 22:12:10 +0100
Subject: [PATCH] mips: Do not include hi and lo in clobber list for R6
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


--IW4QZ7hvdV4P+Mia--

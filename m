Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 127F5664CE6
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 21:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbjAJUBz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 15:01:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231439AbjAJUBz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 15:01:55 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F190639D
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 12:01:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1673380909; bh=rUVnX4YG//5+qEwyJmcw9bhWgpttQlLGeqYrgA6blgk=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=ZMNHk6C6gqMHFDKx5mjSBIZ2Y+mDdW/ZIp6B6DDMTMGE83GtnRHMtpMWcMYiVCVr6
         W8agNwcplbYb66+suFngicF/gnM+QfThYt/NkYpmftbSrwFpsGjfNLr+4zISG5pQBL
         ZAw6kk04VwoSIlbQ98hVUBmXm7ODFdeZLXYSk7wU00SMhY/p/1D8sDUF51Ytd4GilW
         q/+4MQM0E8JjbOzESRVWdOzMXTM+nNS1wmw45oa4dlnBjli3hIr8HGcgFf68/qJj0H
         JjPdThXOAXc6HOc6CaSqjhL2OGBamVFO1LwSijSTnwctiikcSCeXja8gpcLFzw0GiT
         uWIe2RJTwbt8Q==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from p100 ([92.116.138.186]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MmUHp-1oWxdk22RV-00iRlX; Tue, 10
 Jan 2023 21:01:49 +0100
Date:   Tue, 10 Jan 2023 21:01:48 +0100
From:   Helge Deller <deller@gmx.de>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     John David Anglin <dave.anglin@bell.net>
Subject: [STABLE] [PATCH] parisc: Align parisc MADV_XXX constants with all
 other architectures
Message-ID: <Y73ELN4bGardXInF@p100>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Provags-ID: V03:K1:VXHiw+WtFY7ebz8oiohxGVLS3oObJXlIqgSDfPPDbWUp5H1kRSg
 WwsZWXFKqERtv70bMn6dit0BHGDsOIP1a4pEV5DmNNZTwQwH4YKHBc4V7PenhJS8nHjI638
 BgdDBdwgEOsjsxqaLh93OSOYf0haolLX7Hh9evCi0SOUP093e7qFkGLdIiAuCkcAiSe0UXw
 1oMNE5BSV1BUlVyb1v47Q==
UI-OutboundReport: notjunk:1;M01:P0:LkVhxefVrfU=;MUV8mkuYeBXawR4WXiu1SeHOtVO
 PuFRpZ3+wjxVztPytCCZGcZsTTT3GRZ46aYehDP00sGN0GQuxLaDbwyyfh3111QwiYQPb7C/z
 Jb1Y6J8l9TleFDARfo6Hxxm1XBfk0HcH1yiw4gDt5ckvAgmulbiq2IdUbkAEVfhYB4sF5NA6/
 qMMEyxYQQ2saLQja0hNrAe0ZpSuSENQ6FFWVrB3rPX3BOlR0CKEckjS3Kz5F/EJHoh1EjGWRs
 Hq5Vr8IuVXT7TB/jBOU0yIC1gPrW0eOd/nqc8+HLjAZbmMueBaBNHz2tCE1YAN1AlbvmkikFS
 N1MX/QBxsF5fkA/5Mli6HfQJ9nPJrZhFJlK/Tm/LKpsCMMIJek/QnGLgBMbx749urjTiG+o8p
 gFzv47HeZXEFdjdZ04Ym7d28xB513V4dwinWjZyZc3SrGKcC2X/u+Fi5S2XkrXatXCxUpyVs3
 xabUCTTGDW+EQbqts1OFQBDxqFk9mDWW/USQuiE6CMO5U7nBrAp2DLEKiC4AiSHspSy+qp/ld
 ew1ivoiY6W9JAE1qxChyA/mJKH2zE3NXj6Q6FBHq7lzAZwspgFd8sZgWRk/zEw1/DYkGd2R5j
 PTjEsjlkLXB0Cj55tNT41K8j/HRmMOE+1g/AoaHFZmpE813Y+7vs/fX2oYxDETINXQWeNX6Gt
 oUAVr1q6EO/7wKj6sTgXCM3/iLNYYIbAmfElZdnfZw//Xc6hXDjr4TjsxgsU08t9cf4BIBfPr
 OVbOduF6NsVWfHmeCjOy172/3UkykrQTQTIVKSj1LeuCopkaOBaAWFXvSXwlSwIyovrusQa0W
 tZUy56Ec2t4qBizvOJ/eQ61qYRo+kkwu8l8W8xnP3eXri6+mjlZ2pOW9pDNc2gY+/pDfwwrhC
 K+5rGeZZE7UGtBrHZVmRyi3yz8PyylzK5wAbbia4pf4VDlLNKWj6MlBiPIaixNb22fZeZLamN
 0iHgGQ==
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,
can you please consider adding this patch to the 6.0-stable series
(actually kernels 5.18 up to and including 6.0)?
It's a backport of upstream commit 71bdea6f798b425bc0003780b13e3fdecb16a01=
0

Thanks!
Helge


From: Helge Deller <deller@gmx.de>
Subject: [PATCH] parisc: Align parisc MADV_XXX constants with all other ar=
chitectures

Adjust some MADV_XXX constants to be in sync what their values are on
all other platforms. There is currently no reason to have an own
numbering on parisc, but it requires workarounds in many userspace
sources (e.g. glibc, qemu, ...) - which are often forgotten and thus
introduce bugs and different behaviour on parisc.

A wrapper avoids an ABI breakage for existing userspace applications by
translating any old values to the new ones, so this change allows us to
move over all programs to the new ABI over time.

Signed-off-by: Helge Deller <deller@gmx.de>

diff --git a/arch/parisc/include/uapi/asm/mman.h b/arch/parisc/include/uap=
i/asm/mman.h
index a7ea3204a5fa..3fff360ae4a0 100644
=2D-- a/arch/parisc/include/uapi/asm/mman.h
+++ b/arch/parisc/include/uapi/asm/mman.h
@@ -49,6 +49,19 @@
 #define MADV_DONTFORK	10		/* don't inherit across fork */
 #define MADV_DOFORK	11		/* do inherit across fork */

+#define MADV_MERGEABLE   12		/* KSM may merge identical pages */
+#define MADV_UNMERGEABLE 13		/* KSM may not merge identical pages */
+
+#define MADV_HUGEPAGE	14		/* Worth backing with hugepages */
+#define MADV_NOHUGEPAGE 15		/* Not worth backing with hugepages */
+
+#define MADV_DONTDUMP   16		/* Explicity exclude from the core dump,
+					   overrides the coredump filter bits */
+#define MADV_DODUMP	17		/* Clear the MADV_NODUMP flag */
+
+#define MADV_WIPEONFORK 18		/* Zero memory on fork, child only */
+#define MADV_KEEPONFORK 19		/* Undo MADV_WIPEONFORK */
+
 #define MADV_COLD	20		/* deactivate these pages */
 #define MADV_PAGEOUT	21		/* reclaim these pages */

@@ -57,25 +70,11 @@

 #define MADV_DONTNEED_LOCKED	24	/* like DONTNEED, but drop locked pages t=
oo */

-#define MADV_MERGEABLE   65		/* KSM may merge identical pages */
-#define MADV_UNMERGEABLE 66		/* KSM may not merge identical pages */
-
-#define MADV_HUGEPAGE	67		/* Worth backing with hugepages */
-#define MADV_NOHUGEPAGE	68		/* Not worth backing with hugepages */
-
-#define MADV_DONTDUMP   69		/* Explicity exclude from the core dump,
-					   overrides the coredump filter bits */
-#define MADV_DODUMP	70		/* Clear the MADV_NODUMP flag */
-
-#define MADV_WIPEONFORK 71		/* Zero memory on fork, child only */
-#define MADV_KEEPONFORK 72		/* Undo MADV_WIPEONFORK */
-
 #define MADV_HWPOISON     100		/* poison a page for testing */
 #define MADV_SOFT_OFFLINE 101		/* soft offline page for testing */

 /* compatibility flags */
 #define MAP_FILE	0
-#define MAP_VARIABLE	0

 #define PKEY_DISABLE_ACCESS	0x1
 #define PKEY_DISABLE_WRITE	0x2
diff --git a/arch/parisc/kernel/sys_parisc.c b/arch/parisc/kernel/sys_pari=
sc.c
index 2b34294517a1..306dde7f0d3a 100644
=2D-- a/arch/parisc/kernel/sys_parisc.c
+++ b/arch/parisc/kernel/sys_parisc.c
@@ -465,3 +465,30 @@ asmlinkage long parisc_inotify_init1(int flags)
 	flags =3D FIX_O_NONBLOCK(flags);
 	return sys_inotify_init1(flags);
 }
+
+/*
+ * madvise() wrapper
+ *
+ * Up to kernel v6.1 parisc has different values than all other
+ * platforms for the MADV_xxx flags listed below.
+ * To keep binary compatibility with existing userspace programs
+ * translate the former values to the new values.
+ *
+ * XXX: Remove this wrapper in year 2025 (or later)
+ */
+
+asmlinkage notrace long parisc_madvise(unsigned long start, size_t len_in=
, int behavior)
+{
+	switch (behavior) {
+	case 65: behavior =3D MADV_MERGEABLE;	break;
+	case 66: behavior =3D MADV_UNMERGEABLE;	break;
+	case 67: behavior =3D MADV_HUGEPAGE;	break;
+	case 68: behavior =3D MADV_NOHUGEPAGE;	break;
+	case 69: behavior =3D MADV_DONTDUMP;	break;
+	case 70: behavior =3D MADV_DODUMP;	break;
+	case 71: behavior =3D MADV_WIPEONFORK;	break;
+	case 72: behavior =3D MADV_KEEPONFORK;	break;
+	}
+
+	return sys_madvise(start, len_in, behavior);
+}
diff --git a/arch/parisc/kernel/syscalls/syscall.tbl b/arch/parisc/kernel/=
syscalls/syscall.tbl
index 8a99c998da9b..0e42fceb2d5e 100644
=2D-- a/arch/parisc/kernel/syscalls/syscall.tbl
+++ b/arch/parisc/kernel/syscalls/syscall.tbl
@@ -131,7 +131,7 @@
 116	common	sysinfo			sys_sysinfo			compat_sys_sysinfo
 117	common	shutdown		sys_shutdown
 118	common	fsync			sys_fsync
-119	common	madvise			sys_madvise
+119	common	madvise			parisc_madvise
 120	common	clone			sys_clone_wrapper
 121	common	setdomainname		sys_setdomainname
 122	common	sendfile		sys_sendfile			compat_sys_sendfile
diff --git a/tools/arch/parisc/include/uapi/asm/mman.h b/tools/arch/parisc=
/include/uapi/asm/mman.h
index 506c06a6536f..4cc88a642e10 100644
=2D-- a/tools/arch/parisc/include/uapi/asm/mman.h
+++ b/tools/arch/parisc/include/uapi/asm/mman.h
@@ -1,20 +1,20 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
 #ifndef TOOLS_ARCH_PARISC_UAPI_ASM_MMAN_FIX_H
 #define TOOLS_ARCH_PARISC_UAPI_ASM_MMAN_FIX_H
-#define MADV_DODUMP	70
+#define MADV_DODUMP	17
 #define MADV_DOFORK	11
-#define MADV_DONTDUMP   69
+#define MADV_DONTDUMP   16
 #define MADV_DONTFORK	10
 #define MADV_DONTNEED   4
 #define MADV_FREE	8
-#define MADV_HUGEPAGE	67
-#define MADV_MERGEABLE   65
-#define MADV_NOHUGEPAGE	68
+#define MADV_HUGEPAGE	14
+#define MADV_MERGEABLE  12
+#define MADV_NOHUGEPAGE 15
 #define MADV_NORMAL     0
 #define MADV_RANDOM     1
 #define MADV_REMOVE	9
 #define MADV_SEQUENTIAL 2
-#define MADV_UNMERGEABLE 66
+#define MADV_UNMERGEABLE 13
 #define MADV_WILLNEED   3
 #define MAP_ANONYMOUS	0x10
 #define MAP_DENYWRITE	0x0800
diff --git a/tools/perf/bench/bench.h b/tools/perf/bench/bench.h
index 6cefb4315d75..a5d49b3b6a09 100644
=2D-- a/tools/perf/bench/bench.h
+++ b/tools/perf/bench/bench.h
@@ -10,25 +10,13 @@ extern struct timeval bench__start, bench__end, bench_=
_runtime;
  * The madvise transparent hugepage constants were added in glibc
  * 2.13. For compatibility with older versions of glibc, define these
  * tokens if they are not already defined.
- *
- * PA-RISC uses different madvise values from other architectures and
- * needs to be special-cased.
  */
-#ifdef __hppa__
-# ifndef MADV_HUGEPAGE
-#  define MADV_HUGEPAGE		67
-# endif
-# ifndef MADV_NOHUGEPAGE
-#  define MADV_NOHUGEPAGE	68
-# endif
-#else
 # ifndef MADV_HUGEPAGE
 #  define MADV_HUGEPAGE		14
 # endif
 # ifndef MADV_NOHUGEPAGE
 #  define MADV_NOHUGEPAGE	15
 # endif
-#endif

 int bench_numa(int argc, const char **argv);
 int bench_sched_messaging(int argc, const char **argv);

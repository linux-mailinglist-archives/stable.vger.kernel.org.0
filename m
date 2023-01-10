Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF6A3664DC6
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 21:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232281AbjAJU7F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 15:59:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233074AbjAJU7E (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 15:59:04 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AE6859537
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 12:59:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1673384337; bh=8te9rmxT7njdo4VpGB+lBuJKeKO6QaWvuNqi8HgfrAc=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=o3AyqMVijmkcL47lE/LSivEK/vpaGjvw3HALTg3g1KlNJuOihqLfY2NJP6+sLqbiS
         5uf3kDydXlV7C6YUXRk/9uzs1ejztvfFG7XQ+5j2JH4AboEQ6vvebaRM5z9hYKeyrN
         sbQq92PMNQxKUCStoxj2mEqqkBMKJVMsgLtSBxA0CbOXbPOM31/4KKnu2K6EiwgbMz
         wAqnfTpWBrvf3mVt9r5aV+ghvZ0Sl2nrtoCfR1pOLRWPioCAcnPZaquB3L40E7JLGG
         sLtLf57LdTlFjB1rjLTFmtcjtE0HqmLkoJxv/MwLOsGQzs6bcnpdapFZ1ACiwC6YD3
         II8vqMYJkCv7Q==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from p100 ([92.116.138.186]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MNbkp-1pQY033dr1-00P3kZ; Tue, 10
 Jan 2023 21:58:56 +0100
Date:   Tue, 10 Jan 2023 21:58:54 +0100
From:   Helge Deller <deller@gmx.de>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     John David Anglin <dave.anglin@bell.net>
Subject: [STABLE 4.14/4.19] [PATCH] parisc: Align parisc MADV_XXX constants
 with all other architectures
Message-ID: <Y73Rjn7y35vQskE1@p100>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Provags-ID: V03:K1:vevvzD/G/+1rV+dBU1FG7TKzVuiDyOSEvMGah41HMcwf5mYvGEY
 4RUldsacZBHS7hgnQ3XR9UBXnueskqtVzNpRq5iPVjrrkuYZDQy27tnAol0vvQBMEJXoD66
 18w4LKz76n1wzq0YBvZER/NoyptKZzbqRFDzCI9hDttJlHWTLCBGsP7/VPh1rNXOcZkGzY4
 RRxbpuToI0vtkniuNWSsg==
UI-OutboundReport: notjunk:1;M01:P0:KdWo8OzBZvg=;5b9m6hA6piKoVpPiw00e6ZEvktq
 3y/5e855MvSESItEDn41Ejmddk5yXLXg6T47hKjhqXuRvcy+Ui68l3jJOKMHS7P0Q/wOQL/Mx
 sUbv1XeqVUg4Gt9O/1+GgJ2gobJyFlYm6kNqXa7/tYytG1wW4ZSqgFQ5OU9/yg2gKgGM/nNr7
 /k+8my7Nw2pSk1LFBage7p+DsdA0lXdSVtJ0/BvOfscES/gP38ffHxgrZ0HJPWfYZw6vpXzN0
 ZCWUYJxmhN6vT/X3rMB1Ib9c/+WBwcGdyS9rUnSXgdnBNg7XzgaBqH3wSya7Fnl+DPiRWqzik
 jZo4FXNsiVv5y5cmhXTzi3CC6dhSVBS1B3aLrNbkSmQ4DFhU2n/HzWMj1NUlYWrSkN4AxON6a
 OUzcOEuVyPSjq+Y856kR11ytu8dLht95pm/7qA0wTHtx78eq2V5ndaid+qlGmNkgDfnQMlcQi
 U/Nnx9XNIS+SK4JDX0FppU8p+ggUef3TkEhyRVigsSBHuyALzUJSYlo1kUirfEdC8mp44mHyQ
 uCZq239X8b3vEIERzw5wt3hcdeyWA4WFexh/1JyvN03YbpyK95hcFO+XUHRTTX1fi+Vehwk+E
 e12sZQqrV4wu2cECdJMdUbHB/xtlpVC1IvmXVUjPWbypJvyVmBRB6IIbH3c9cF6GNj4HF9B9X
 tvruewdxhrjVVyV4gs4PPOmyIrAZMVUWdLJSwecXMtGSfMN5q5VCBny0iSQkpce3lh2d1jJY8
 M3zAS4HZqwoctl6IR4GUbGeHgloZLc7IZStopzFzrSDEFS4a15M8L6ja0KsVna0cXKJqtdZeB
 CCV4AA22/EJrrcw4YrI49KZdKD/VcDJekAq2tW4V2LRDAxn7ewu//Q3T4ur7F2A21Tr4yVPYW
 yF7wqfRElDFkB0yUclurnNhV/mCWO1q2wO0Dj4o5SHaGlndxvAlhYK6HszhcoH9KdVAKY/VoW
 OwHEfz6qCXSMl7ZwCE/iyRy/Q9k=
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

can you please consider adding this patch to the 4.14 and 4.19 stable kern=
els?
It's a backport of upstream commit 71bdea6f798b425bc0003780b13e3fdecb16a01=
0

Thanks!
Helge



=46rom 71bdea6f798b425bc0003780b13e3fdecb16a010 Mon Sep 17 00:00:00 2001
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
index 870fbf8c7088..13f61fdf3823 100644
=2D-- a/arch/parisc/include/uapi/asm/mman.h
+++ b/arch/parisc/include/uapi/asm/mman.h
@@ -50,25 +50,24 @@
 #define MADV_DONTFORK	10		/* don't inherit across fork */
 #define MADV_DOFORK	11		/* do inherit across fork */

-#define MADV_MERGEABLE   65		/* KSM may merge identical pages */
-#define MADV_UNMERGEABLE 66		/* KSM may not merge identical pages */
+#define MADV_MERGEABLE   12		/* KSM may merge identical pages */
+#define MADV_UNMERGEABLE 13		/* KSM may not merge identical pages */

-#define MADV_HUGEPAGE	67		/* Worth backing with hugepages */
-#define MADV_NOHUGEPAGE	68		/* Not worth backing with hugepages */
+#define MADV_HUGEPAGE	14		/* Worth backing with hugepages */
+#define MADV_NOHUGEPAGE 15		/* Not worth backing with hugepages */

-#define MADV_DONTDUMP   69		/* Explicity exclude from the core dump,
+#define MADV_DONTDUMP   16		/* Explicity exclude from the core dump,
 					   overrides the coredump filter bits */
-#define MADV_DODUMP	70		/* Clear the MADV_NODUMP flag */
+#define MADV_DODUMP	17		/* Clear the MADV_NODUMP flag */

-#define MADV_WIPEONFORK 71		/* Zero memory on fork, child only */
-#define MADV_KEEPONFORK 72		/* Undo MADV_WIPEONFORK */
+#define MADV_WIPEONFORK 18		/* Zero memory on fork, child only */
+#define MADV_KEEPONFORK 19		/* Undo MADV_WIPEONFORK */

 #define MADV_HWPOISON     100		/* poison a page for testing */
 #define MADV_SOFT_OFFLINE 101		/* soft offline page for testing */

 /* compatibility flags */
 #define MAP_FILE	0
-#define MAP_VARIABLE	0

 #define PKEY_DISABLE_ACCESS	0x1
 #define PKEY_DISABLE_WRITE	0x2
diff --git a/arch/parisc/kernel/sys_parisc.c b/arch/parisc/kernel/sys_pari=
sc.c
index 376ea0d1b275..4306d1bea98b 100644
=2D-- a/arch/parisc/kernel/sys_parisc.c
+++ b/arch/parisc/kernel/sys_parisc.c
@@ -386,3 +386,30 @@ long parisc_personality(unsigned long personality)

 	return err;
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
diff --git a/arch/parisc/kernel/syscall_table.S b/arch/parisc/kernel/sysca=
ll_table.S
index fe3f2a49d2b1..64a72f161eeb 100644
=2D-- a/arch/parisc/kernel/syscall_table.S
+++ b/arch/parisc/kernel/syscall_table.S
@@ -195,7 +195,7 @@
 	ENTRY_COMP(sysinfo)
 	ENTRY_SAME(shutdown)
 	ENTRY_SAME(fsync)
-	ENTRY_SAME(madvise)
+	ENTRY_OURS(madvise)
 	ENTRY_SAME(clone_wrapper)	/* 120 */
 	ENTRY_SAME(setdomainname)
 	ENTRY_COMP(sendfile)
diff --git a/tools/arch/parisc/include/uapi/asm/mman.h b/tools/arch/parisc=
/include/uapi/asm/mman.h
index 1bd78758bde9..5d789369aeef 100644
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
index b3e418afc21a..71010922cd4d 100644
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

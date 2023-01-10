Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6428E664D1B
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 21:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbjAJUOX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 15:14:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231852AbjAJUOA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 15:14:00 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DC4517884
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 12:13:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1673381634; bh=qwLtSTAS4w35VauxSCR2XMtvTJE0kPedzkxwZxnFbVE=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=VFuAN73AAIGlQ3qKh8CWEoPpEcGxfgZERIFnM/8wZpOOB6qKC+8+PNN3Z8XP4vp2G
         tV6El8EmBfVBXo9vdufjJgElzjQG1TsJyeR1R5SYFM4jgAKm1LroD4hBMSlukSsVYw
         YFC9cZ3dkZw9IRCd7+QDVdwCmOy4SPbNtWjctj+mO56FdSFe5HqR4eWgRZUlDO4ejz
         EudI2w3xEX0q9PM8eAiFdENz7XoJBwYOH85VF9+9vZV3rIJhF6KfEmGlLFQs+f0gG3
         afUwVd+toOfIsF9cV2jjIH+tuoOUy8aFrSnHBF1FePcsiS5ng9Gn7CFHE5046nZ1I4
         BzubKR29yjlwg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from p100 ([92.116.138.186]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MN5eX-1pVUJT1N3t-00J2ID; Tue, 10
 Jan 2023 21:13:54 +0100
Date:   Tue, 10 Jan 2023 21:13:52 +0100
From:   Helge Deller <deller@gmx.de>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     John David Anglin <dave.anglin@bell.net>
Subject: [STABLE-v5.15] [PATCH] parisc: Align parisc MADV_XXX constants with
 all other architectures
Message-ID: <Y73HAH5Mm9SSmtYG@p100>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Provags-ID: V03:K1:/tEZStyVhBzP2lcsSyZNI3aR1yZPJiIZ3VT/pbkyAjp5pqaIqT7
 pO/y+NNF8T52SaEDLr+ZX+iVzD27HpSC3Np5FJsq7GSk4c1dEoHOP6OPYUL6Lmg39f6BAg4
 c2X+y2jF9k0rkcu35YzAK0LLNhyTNx86OEgxHy2N1wEvQLTG7bLPkRjTvsERIAJq/J5whOv
 0WPmpQhtbHEH9weCiz0sA==
UI-OutboundReport: notjunk:1;M01:P0:NmEr3Omkgqo=;kzfthqtmF4G5egAZD1PUUYYbIJ+
 wMAmLV9xIs5joG0C+E5WFE5WA58jMtryxALCzIfn8mTRkX49BeFYr5LA/uK6eMmLZwi6u7gqL
 ++b30g4Q/5sikrEzySxe0BYOub4bAYHVEugEo46S8gO9jJYommkUhLCN9jB/eBQlJzmwM7Dvv
 R2RFgAaTC7e1WYIsGq59oaQYCZi1PT1cG5v7DOMklxOkxN1p/DevQ/S2DQtISMV7w6FC7Rc70
 hQxCfGW4+ahWxAfRLlXiwL2RK4NFP2XsJLG45/eegmrd3RLAE4vebWadPhq8iDLRKX34FNqhy
 U4qd7aNbyduwUe3L4JCjsNBmg54fXD9cL4VVA5W/sldwLKRpZFWMWN3HJtkvoXwZV4gRpHFxb
 HTynQrC72PRZbWC5lvD0RlvXjpa3Xg3zq7BIvFBPukYD8lq9dnsbpfuxQgeGy3goOEuNuGMhp
 UZA7ssi4smvdQIVTy6Lji7P9bWdLH7OlqqxrUKOn8KNzbRK1I8A9g5fYrsZPt8MDaNmGUvr4y
 xRVryrX5nTLCkBKrQHhWdJ6lXbkLJfRD073cEZFzWbih4bBqkWdileZebOnS567vHGLHgEmMB
 VDCy6y+JXgs9ZZ3Iie+VZ0Pih1MO25bNSInpv5kI5TnQwieFMvOd05acVW+QyWdXHyYGG9ck2
 KZCqJ3yDMxi8awLuFvQ6xkAPmSCHT+5gVM+HIExFrncuVVbGxjADNi0dW8o7z0kTLZWNouT3e
 CFWoxjScwMSzrPaqLvbF0UM7iuwSU3ZAqcxfRTlc2jyGNC3E7Yms+9wvmH/FJ4usf6k78slWe
 DyXC2Suau8WWptl8w2RROLElt+b6ajvvqKHPuza3nd++Q02AVoWvEYMvI1vfcHvrytJdqymsD
 AcYWR3gstXBG1A8aP15JG73fvo6kyKDHdyYSRpsDexTzW3DYYv5SEm96QTNkPMOB4LiuECxD2
 Swfy3g==
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
can you please consider adding this patch to the 5.15-stable kernel
(actually kernels 5.14 up to and including 5.17)?
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
index 9e3c010c0f61..5f1f3eea5aa5 100644
=2D-- a/arch/parisc/include/uapi/asm/mman.h
+++ b/arch/parisc/include/uapi/asm/mman.h
@@ -49,31 +49,30 @@
 #define MADV_DONTFORK	10		/* don't inherit across fork */
 #define MADV_DOFORK	11		/* do inherit across fork */

-#define MADV_COLD	20		/* deactivate these pages */
-#define MADV_PAGEOUT	21		/* reclaim these pages */
+#define MADV_MERGEABLE   12		/* KSM may merge identical pages */
+#define MADV_UNMERGEABLE 13		/* KSM may not merge identical pages */

-#define MADV_POPULATE_READ	22	/* populate (prefault) page tables readable=
 */
-#define MADV_POPULATE_WRITE	23	/* populate (prefault) page tables writabl=
e */
+#define MADV_HUGEPAGE	14		/* Worth backing with hugepages */
+#define MADV_NOHUGEPAGE 15		/* Not worth backing with hugepages */

-#define MADV_MERGEABLE   65		/* KSM may merge identical pages */
-#define MADV_UNMERGEABLE 66		/* KSM may not merge identical pages */
+#define MADV_DONTDUMP   16		/* Explicity exclude from the core dump,
+					   overrides the coredump filter bits */
+#define MADV_DODUMP	17		/* Clear the MADV_NODUMP flag */

-#define MADV_HUGEPAGE	67		/* Worth backing with hugepages */
-#define MADV_NOHUGEPAGE	68		/* Not worth backing with hugepages */
+#define MADV_WIPEONFORK 18		/* Zero memory on fork, child only */
+#define MADV_KEEPONFORK 19		/* Undo MADV_WIPEONFORK */

-#define MADV_DONTDUMP   69		/* Explicity exclude from the core dump,
-					   overrides the coredump filter bits */
-#define MADV_DODUMP	70		/* Clear the MADV_NODUMP flag */
+#define MADV_COLD	20		/* deactivate these pages */
+#define MADV_PAGEOUT	21		/* reclaim these pages */

-#define MADV_WIPEONFORK 71		/* Zero memory on fork, child only */
-#define MADV_KEEPONFORK 72		/* Undo MADV_WIPEONFORK */
+#define MADV_POPULATE_READ	22	/* populate (prefault) page tables readable=
 */
+#define MADV_POPULATE_WRITE	23	/* populate (prefault) page tables writabl=
e */

 #define MADV_HWPOISON     100		/* poison a page for testing */
 #define MADV_SOFT_OFFLINE 101		/* soft offline page for testing */

 /* compatibility flags */
 #define MAP_FILE	0
-#define MAP_VARIABLE	0

 #define PKEY_DISABLE_ACCESS	0x1
 #define PKEY_DISABLE_WRITE	0x2
diff --git a/arch/parisc/kernel/sys_parisc.c b/arch/parisc/kernel/sys_pari=
sc.c
index 5f12537318ab..31950882e272 100644
=2D-- a/arch/parisc/kernel/sys_parisc.c
+++ b/arch/parisc/kernel/sys_parisc.c
@@ -463,3 +463,30 @@ asmlinkage long parisc_inotify_init1(int flags)
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
index c23f4fa17005..50c759f11c25 100644
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
index b3480bc33fe8..baa7c6301400 100644
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

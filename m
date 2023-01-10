Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5BBD664D7D
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 21:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233719AbjAJUdJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 15:33:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235312AbjAJUcU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 15:32:20 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83BE04ECA3
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 12:30:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1673382621; bh=8KZPauge/uZMh/XoWUudmj5xUO8A54vP+0w4TTtS0Go=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=fdsT6mB4We9g0xGPncak/oXfwdRKNmFf4wgDaXkQOkmQKiatx5rDgzCPDptGQMkEq
         I2VlnUKMt6NGGMK0wuKevmRvQH/4aa0pz0ZYsAKcI6LwRsN6ERFT4Uo7I3okf0ZaUk
         WQkj7DoNaHFspiR+Bqqb9INniRxXC560yBRiwqSHW8lf4Ouwg0seTp8R5HcOTRjEnJ
         Q15I1ySw0S7KQtfFqI3C9uBBSDHmM3ohBp82aDy1Ndcr9gx4u5YaYbTmwXy19Sm8At
         Q7av1YleRQnpRWvG6feaK/wVGS9ABZblvwA/9YkRZ2SSyJVRCLiCUf5HbR3dCq3FEE
         c2lo3ZNxcppBA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from p100 ([92.116.138.186]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MryT9-1oRUNs2U5N-00o1tN; Tue, 10
 Jan 2023 21:30:21 +0100
Date:   Tue, 10 Jan 2023 21:30:19 +0100
From:   Helge Deller <deller@gmx.de>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     John David Anglin <dave.anglin@bell.net>
Subject: [STABLE 5.4/5.10] [PATCH] parisc: Align parisc MADV_XXX constants
 with all other architectures
Message-ID: <Y73K28F+C0JeEHzf@p100>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Provags-ID: V03:K1:X/plHMqJFMKuvUf6YMc3ToL0XHczydG9z4cK2wBUWc12P0/z+du
 tr17N1pMVgj2uK/nE+FWMgk3oOBVJk79m7aet6NBFIaH6030bqM5sjSZmP6f+kBZY5k/5WA
 rEXlIyZ4c9D0ywswyL3q+rO1xTfHtF6+uPPMlavzn62bplBX38yqZUqE+H9D8SN2huoDO1k
 QzsEzhQz6p41PST3qgRbg==
UI-OutboundReport: notjunk:1;M01:P0:3NZtbvZMGSs=;6dbXK7kc9iGrELSM9GFxzeS55dE
 I6rq/29nm6be6heWBaUcNL+2oxEYf/BA/LyoXXUEQrLkC5iX8QNrQMra275T5BOQfbuXElrH6
 BLoZTyh3xVwg+IuSXoEpwfz6gU3+SjEx4fdBR1b/gQSW/O3etBBt2e0Xc81d1GOuPd7jDgEr0
 Wgg3ioarQ3AMYbyiWXv1ch9PE29FXartOclO4wmiHv3lDZ/0zxemBKh0N+oJrNHyGVMdRKJab
 fh9/uvnns6gAjjOAQRdB2I9Nqm/JBlnnKI1TFBDi/C1HiAD+3Dx44UEbwT+jEdOL4uUOR6rGD
 HxjpqBK5Cy3A7WL0CcM7B+dgb2KHk9dS5MF/UsmwNLT9CJxGDMdojhAyIy7AJ/lRhn/CTzoii
 A598ywfAzL/f+xHAr59QBuebTGclTT6j5sUoen7dGxK1krNwGcPAlIDHuokNliZRJJC3bB4x5
 3HGG/b4AL0hrk3SSxJvcCmXlB0njV9ILt1G77cFR4dUs5rW/zn89cScDzddGOaM08DcOT4MDr
 4/BhEad5j5tlBPZ5m07wWLryTdcUGDuyq3JTdPTdNTZNy8vcByJ+BZWaLwk56umLvUmgT/OLi
 HoDnm2Rfs6D/AO+knd3wVpSOWNuvzODiGd/Hu8fCqe7D3rBX0cVDgh//JWo86Kj4GmSUnvrer
 N0HKEVMDjld5GKOTJI4Mk9fyXKhHtuvk0SlUyTPvSwArcDDV5kDfnNoytjbLgmP5ebKUdKoxb
 191OGuCu7J46QFWrU6tN9CBOrwwAXwwrSO3/ePXD7+VtQ90AsAUl8jsJqydm5Sci9daZtQvO8
 ZJ4zgjswcRDv5JYg7Vf003uUgDFMR0s7YURNQeLYhrDNS+dl8tMYL4Sx5q6xRpTP1mU9W6uTu
 38/9kDNx1KiFongbM7hadUbxsSTCPKvZCIRZ+MbizEwNrvJBc18/g2xMjqTGbkp87IeWibfDK
 9uq2YJtI8A+napPnA6Gy8u7AVf0=
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
can you please consider adding this patch to the 5.4 and 5.10 stable kerne=
ls
(actually kernels 5.0 up to and including 5.13)?
It's a backport of upstream commit 71bdea6f798b425bc0003780b13e3fdecb16a01=
0

Thanks!
Helge



From: Helge Deller <deller@gmx.de>
Date: Sun, 11 Dec 2022 19:50:20 +0100
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
index ab78cba446ed..ef9b53b80b9d 100644
=2D-- a/arch/parisc/include/uapi/asm/mman.h
+++ b/arch/parisc/include/uapi/asm/mman.h
@@ -49,28 +49,27 @@
 #define MADV_DONTFORK	10		/* don't inherit across fork */
 #define MADV_DOFORK	11		/* do inherit across fork */

-#define MADV_COLD	20		/* deactivate these pages */
-#define MADV_PAGEOUT	21		/* reclaim these pages */
-
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
+
+#define MADV_COLD	20		/* deactivate these pages */
+#define MADV_PAGEOUT	21		/* reclaim these pages */

 #define MADV_HWPOISON     100		/* poison a page for testing */
 #define MADV_SOFT_OFFLINE 101		/* soft offline page for testing */

 /* compatibility flags */
 #define MAP_FILE	0
-#define MAP_VARIABLE	0

 #define PKEY_DISABLE_ACCESS	0x1
 #define PKEY_DISABLE_WRITE	0x2
diff --git a/arch/parisc/kernel/sys_parisc.c b/arch/parisc/kernel/sys_pari=
sc.c
index 9549496f5523..40f881f729e4 100644
=2D-- a/arch/parisc/kernel/sys_parisc.c
+++ b/arch/parisc/kernel/sys_parisc.c
@@ -444,3 +444,30 @@ asmlinkage long parisc_inotify_init1(int flags)
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
index d526ebfa58e5..dfe9254ee74b 100644
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
index eac36afab2b3..9a56a44f87dd 100644
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

Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8260729EC09
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 13:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbgJ2Mmf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 08:42:35 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:48777 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725601AbgJ2Mme (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 08:42:34 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 6460B61D;
        Thu, 29 Oct 2020 08:42:10 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 29 Oct 2020 08:42:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=gWtkCQ
        DGHxTvLcGlAqeI4HayxGbuvCDw3uTzvqtjDjI=; b=Lk0rq4SIqoASdSIIaLs35F
        6/Z1T8pi347fWnouRpVt2WNkXjvllkQQ/lrM+mqhqWdCBaCldZRR/mpFcurzFKgr
        JV1TCzPgnSo3uOf+JMCEu7ZHXJAXEqr0bI0XxZ4eHk8oMcENZM9IPkEhQIajeoFG
        XI4BOTj29zpHE0j00bwHG3BZOEXQOXHjoE3l4BI9oa1CYiWzNl51O3MER1DHW9uD
        ajQ7CPjAdS6TDBTiWEvov3TxOsO8KuVASP0+5dkl37PElWGnjgt05OZhu51dt1UM
        xnFT0v9QWX72VekZVQ+4U5hTtdXCFDuF2QzslM1dBKeZUITMxBFe6LMS8vgvglLw
        ==
X-ME-Sender: <xms:obiaX-8xG-QeZtUjSk6r5IjR28KNAhB1P12U9BAxahHNnsfBne8jCQ>
    <xme:obiaX-sYuyAmoI6dVR17cwFGWJeA4AWejFQPbRj6goQDMf-EqOwq4yXGveybSqQ5n
    D2gzm6WPiLybQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrleefgdegfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeehleefgeeufeevuedtfedvvefhtdduteffffekiedtke
    fhjeeuteetiedvledvueenucffohhmrghinhepkhgvrhhnvghlrdhorhhgpdeigedrshgs
    necukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:obiaX0AWEcLI0Z0G9OeMfVeAGYge2Ai81OT1sglitrN_UjcY4pHwbA>
    <xmx:obiaX2dlJ0PkdsnU-ioVCgv5SkP8xt-6KLdMKBAOAC-p61mO7ErqoA>
    <xmx:obiaXzN7GAZbhA4760Uv5tqxvefOg6kYLYVEypAfK2rlw0EJZFfLzw>
    <xmx:oriaX8pA2xkRxRnU2IJqMh5b3_fXwDryZkcObgrPCXyLYFWZYw0CHxH8vZQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id EA8C23280063;
        Thu, 29 Oct 2020 08:42:08 -0400 (EDT)
Subject: FAILED: patch "[PATCH] x86, powerpc: Rename memcpy_mcsafe() to copy_mc_to_{user," failed to apply to 5.4-stable tree
To:     dan.j.williams@intel.com, bp@suse.de, mpe@ellerman.id.au,
        stable@vger.kernel.org, tony.luck@intel.com,
        torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 29 Oct 2020 13:43:00 +0100
Message-ID: <160397538017373@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ec6347bb43395cb92126788a1a5b25302543f815 Mon Sep 17 00:00:00 2001
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 5 Oct 2020 20:40:16 -0700
Subject: [PATCH] x86, powerpc: Rename memcpy_mcsafe() to copy_mc_to_{user,
 kernel}()

In reaction to a proposal to introduce a memcpy_mcsafe_fast()
implementation Linus points out that memcpy_mcsafe() is poorly named
relative to communicating the scope of the interface. Specifically what
addresses are valid to pass as source, destination, and what faults /
exceptions are handled.

Of particular concern is that even though x86 might be able to handle
the semantics of copy_mc_to_user() with its common copy_user_generic()
implementation other archs likely need / want an explicit path for this
case:

  On Fri, May 1, 2020 at 11:28 AM Linus Torvalds <torvalds@linux-foundation.org> wrote:
  >
  > On Thu, Apr 30, 2020 at 6:21 PM Dan Williams <dan.j.williams@intel.com> wrote:
  > >
  > > However now I see that copy_user_generic() works for the wrong reason.
  > > It works because the exception on the source address due to poison
  > > looks no different than a write fault on the user address to the
  > > caller, it's still just a short copy. So it makes copy_to_user() work
  > > for the wrong reason relative to the name.
  >
  > Right.
  >
  > And it won't work that way on other architectures. On x86, we have a
  > generic function that can take faults on either side, and we use it
  > for both cases (and for the "in_user" case too), but that's an
  > artifact of the architecture oddity.
  >
  > In fact, it's probably wrong even on x86 - because it can hide bugs -
  > but writing those things is painful enough that everybody prefers
  > having just one function.

Replace a single top-level memcpy_mcsafe() with either
copy_mc_to_user(), or copy_mc_to_kernel().

Introduce an x86 copy_mc_fragile() name as the rename for the
low-level x86 implementation formerly named memcpy_mcsafe(). It is used
as the slow / careful backend that is supplanted by a fast
copy_mc_generic() in a follow-on patch.

One side-effect of this reorganization is that separating copy_mc_64.S
to its own file means that perf no longer needs to track dependencies
for its memcpy_64.S benchmarks.

 [ bp: Massage a bit. ]

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: <stable@vger.kernel.org>
Link: http://lore.kernel.org/r/CAHk-=wjSqtXAqfUJxFtWNwmguFASTgB0dz1dT3V-78Quiezqbg@mail.gmail.com
Link: https://lkml.kernel.org/r/160195561680.2163339.11574962055305783722.stgit@dwillia2-desk3.amr.corp.intel.com

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 1f48bbfb3ce9..76473eda3426 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -136,7 +136,7 @@ config PPC
 	select ARCH_HAS_STRICT_KERNEL_RWX	if (PPC32 && !HIBERNATION)
 	select ARCH_HAS_TICK_BROADCAST		if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_HAS_UACCESS_FLUSHCACHE
-	select ARCH_HAS_UACCESS_MCSAFE		if PPC64
+	select ARCH_HAS_COPY_MC			if PPC64
 	select ARCH_HAS_UBSAN_SANITIZE_ALL
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select ARCH_KEEP_MEMBLOCK
diff --git a/arch/powerpc/include/asm/string.h b/arch/powerpc/include/asm/string.h
index 283552cd0e58..2aa0e31e6884 100644
--- a/arch/powerpc/include/asm/string.h
+++ b/arch/powerpc/include/asm/string.h
@@ -53,9 +53,7 @@ void *__memmove(void *to, const void *from, __kernel_size_t n);
 #ifndef CONFIG_KASAN
 #define __HAVE_ARCH_MEMSET32
 #define __HAVE_ARCH_MEMSET64
-#define __HAVE_ARCH_MEMCPY_MCSAFE
 
-extern int memcpy_mcsafe(void *dst, const void *src, __kernel_size_t sz);
 extern void *__memset16(uint16_t *, uint16_t v, __kernel_size_t);
 extern void *__memset32(uint32_t *, uint32_t v, __kernel_size_t);
 extern void *__memset64(uint64_t *, uint64_t v, __kernel_size_t);
diff --git a/arch/powerpc/include/asm/uaccess.h b/arch/powerpc/include/asm/uaccess.h
index 00699903f1ef..20a35373cafc 100644
--- a/arch/powerpc/include/asm/uaccess.h
+++ b/arch/powerpc/include/asm/uaccess.h
@@ -435,6 +435,32 @@ do {								\
 extern unsigned long __copy_tofrom_user(void __user *to,
 		const void __user *from, unsigned long size);
 
+#ifdef CONFIG_ARCH_HAS_COPY_MC
+unsigned long __must_check
+copy_mc_generic(void *to, const void *from, unsigned long size);
+
+static inline unsigned long __must_check
+copy_mc_to_kernel(void *to, const void *from, unsigned long size)
+{
+	return copy_mc_generic(to, from, size);
+}
+#define copy_mc_to_kernel copy_mc_to_kernel
+
+static inline unsigned long __must_check
+copy_mc_to_user(void __user *to, const void *from, unsigned long n)
+{
+	if (likely(check_copy_size(from, n, true))) {
+		if (access_ok(to, n)) {
+			allow_write_to_user(to, n);
+			n = copy_mc_generic((void *)to, from, n);
+			prevent_write_to_user(to, n);
+		}
+	}
+
+	return n;
+}
+#endif
+
 #ifdef __powerpc64__
 static inline unsigned long
 raw_copy_in_user(void __user *to, const void __user *from, unsigned long n)
@@ -523,20 +549,6 @@ raw_copy_to_user(void __user *to, const void *from, unsigned long n)
 	return ret;
 }
 
-static __always_inline unsigned long __must_check
-copy_to_user_mcsafe(void __user *to, const void *from, unsigned long n)
-{
-	if (likely(check_copy_size(from, n, true))) {
-		if (access_ok(to, n)) {
-			allow_write_to_user(to, n);
-			n = memcpy_mcsafe((void *)to, from, n);
-			prevent_write_to_user(to, n);
-		}
-	}
-
-	return n;
-}
-
 unsigned long __arch_clear_user(void __user *addr, unsigned long size);
 
 static inline unsigned long clear_user(void __user *addr, unsigned long size)
diff --git a/arch/powerpc/lib/Makefile b/arch/powerpc/lib/Makefile
index d66a645503eb..69a91b571845 100644
--- a/arch/powerpc/lib/Makefile
+++ b/arch/powerpc/lib/Makefile
@@ -39,7 +39,7 @@ obj-$(CONFIG_PPC_BOOK3S_64) += copyuser_power7.o copypage_power7.o \
 			       memcpy_power7.o
 
 obj64-y	+= copypage_64.o copyuser_64.o mem_64.o hweight_64.o \
-	   memcpy_64.o memcpy_mcsafe_64.o
+	   memcpy_64.o copy_mc_64.o
 
 ifndef CONFIG_PPC_QUEUED_SPINLOCKS
 obj64-$(CONFIG_SMP)	+= locks.o
diff --git a/arch/powerpc/lib/memcpy_mcsafe_64.S b/arch/powerpc/lib/copy_mc_64.S
similarity index 98%
rename from arch/powerpc/lib/memcpy_mcsafe_64.S
rename to arch/powerpc/lib/copy_mc_64.S
index cb882d9a6d8a..88d46c471493 100644
--- a/arch/powerpc/lib/memcpy_mcsafe_64.S
+++ b/arch/powerpc/lib/copy_mc_64.S
@@ -50,7 +50,7 @@ err3;	stb	r0,0(r3)
 	blr
 
 
-_GLOBAL(memcpy_mcsafe)
+_GLOBAL(copy_mc_generic)
 	mr	r7,r5
 	cmpldi	r5,16
 	blt	.Lshort_copy
@@ -239,4 +239,4 @@ err1;	stb	r0,0(r3)
 15:	li	r3,0
 	blr
 
-EXPORT_SYMBOL_GPL(memcpy_mcsafe);
+EXPORT_SYMBOL_GPL(copy_mc_generic);
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 7101ac64bb20..e876b3a087f9 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -75,7 +75,7 @@ config X86
 	select ARCH_HAS_PTE_DEVMAP		if X86_64
 	select ARCH_HAS_PTE_SPECIAL
 	select ARCH_HAS_UACCESS_FLUSHCACHE	if X86_64
-	select ARCH_HAS_UACCESS_MCSAFE		if X86_64 && X86_MCE
+	select ARCH_HAS_COPY_MC			if X86_64
 	select ARCH_HAS_SET_MEMORY
 	select ARCH_HAS_SET_DIRECT_MAP
 	select ARCH_HAS_STRICT_KERNEL_RWX
diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index ee1d3c5834c6..27b5e2bc6a01 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -62,7 +62,7 @@ config EARLY_PRINTK_USB_XDBC
 	  You should normally say N here, unless you want to debug early
 	  crashes or need a very simple printk logging facility.
 
-config MCSAFE_TEST
+config COPY_MC_TEST
 	def_bool n
 
 config EFI_PGT_DUMP
diff --git a/arch/x86/include/asm/copy_mc_test.h b/arch/x86/include/asm/copy_mc_test.h
new file mode 100644
index 000000000000..e4991ba96726
--- /dev/null
+++ b/arch/x86/include/asm/copy_mc_test.h
@@ -0,0 +1,75 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _COPY_MC_TEST_H_
+#define _COPY_MC_TEST_H_
+
+#ifndef __ASSEMBLY__
+#ifdef CONFIG_COPY_MC_TEST
+extern unsigned long copy_mc_test_src;
+extern unsigned long copy_mc_test_dst;
+
+static inline void copy_mc_inject_src(void *addr)
+{
+	if (addr)
+		copy_mc_test_src = (unsigned long) addr;
+	else
+		copy_mc_test_src = ~0UL;
+}
+
+static inline void copy_mc_inject_dst(void *addr)
+{
+	if (addr)
+		copy_mc_test_dst = (unsigned long) addr;
+	else
+		copy_mc_test_dst = ~0UL;
+}
+#else /* CONFIG_COPY_MC_TEST */
+static inline void copy_mc_inject_src(void *addr)
+{
+}
+
+static inline void copy_mc_inject_dst(void *addr)
+{
+}
+#endif /* CONFIG_COPY_MC_TEST */
+
+#else /* __ASSEMBLY__ */
+#include <asm/export.h>
+
+#ifdef CONFIG_COPY_MC_TEST
+.macro COPY_MC_TEST_CTL
+	.pushsection .data
+	.align 8
+	.globl copy_mc_test_src
+	copy_mc_test_src:
+		.quad 0
+	EXPORT_SYMBOL_GPL(copy_mc_test_src)
+	.globl copy_mc_test_dst
+	copy_mc_test_dst:
+		.quad 0
+	EXPORT_SYMBOL_GPL(copy_mc_test_dst)
+	.popsection
+.endm
+
+.macro COPY_MC_TEST_SRC reg count target
+	leaq \count(\reg), %r9
+	cmp copy_mc_test_src, %r9
+	ja \target
+.endm
+
+.macro COPY_MC_TEST_DST reg count target
+	leaq \count(\reg), %r9
+	cmp copy_mc_test_dst, %r9
+	ja \target
+.endm
+#else
+.macro COPY_MC_TEST_CTL
+.endm
+
+.macro COPY_MC_TEST_SRC reg count target
+.endm
+
+.macro COPY_MC_TEST_DST reg count target
+.endm
+#endif /* CONFIG_COPY_MC_TEST */
+#endif /* __ASSEMBLY__ */
+#endif /* _COPY_MC_TEST_H_ */
diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 109af5c7f515..ba2062d6df92 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -174,6 +174,15 @@ extern void mce_unregister_decode_chain(struct notifier_block *nb);
 
 extern int mce_p5_enabled;
 
+#ifdef CONFIG_ARCH_HAS_COPY_MC
+extern void enable_copy_mc_fragile(void);
+unsigned long __must_check copy_mc_fragile(void *dst, const void *src, unsigned cnt);
+#else
+static inline void enable_copy_mc_fragile(void)
+{
+}
+#endif
+
 #ifdef CONFIG_X86_MCE
 int mcheck_init(void);
 void mcheck_cpu_init(struct cpuinfo_x86 *c);
diff --git a/arch/x86/include/asm/mcsafe_test.h b/arch/x86/include/asm/mcsafe_test.h
deleted file mode 100644
index eb59804b6201..000000000000
--- a/arch/x86/include/asm/mcsafe_test.h
+++ /dev/null
@@ -1,75 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _MCSAFE_TEST_H_
-#define _MCSAFE_TEST_H_
-
-#ifndef __ASSEMBLY__
-#ifdef CONFIG_MCSAFE_TEST
-extern unsigned long mcsafe_test_src;
-extern unsigned long mcsafe_test_dst;
-
-static inline void mcsafe_inject_src(void *addr)
-{
-	if (addr)
-		mcsafe_test_src = (unsigned long) addr;
-	else
-		mcsafe_test_src = ~0UL;
-}
-
-static inline void mcsafe_inject_dst(void *addr)
-{
-	if (addr)
-		mcsafe_test_dst = (unsigned long) addr;
-	else
-		mcsafe_test_dst = ~0UL;
-}
-#else /* CONFIG_MCSAFE_TEST */
-static inline void mcsafe_inject_src(void *addr)
-{
-}
-
-static inline void mcsafe_inject_dst(void *addr)
-{
-}
-#endif /* CONFIG_MCSAFE_TEST */
-
-#else /* __ASSEMBLY__ */
-#include <asm/export.h>
-
-#ifdef CONFIG_MCSAFE_TEST
-.macro MCSAFE_TEST_CTL
-	.pushsection .data
-	.align 8
-	.globl mcsafe_test_src
-	mcsafe_test_src:
-		.quad 0
-	EXPORT_SYMBOL_GPL(mcsafe_test_src)
-	.globl mcsafe_test_dst
-	mcsafe_test_dst:
-		.quad 0
-	EXPORT_SYMBOL_GPL(mcsafe_test_dst)
-	.popsection
-.endm
-
-.macro MCSAFE_TEST_SRC reg count target
-	leaq \count(\reg), %r9
-	cmp mcsafe_test_src, %r9
-	ja \target
-.endm
-
-.macro MCSAFE_TEST_DST reg count target
-	leaq \count(\reg), %r9
-	cmp mcsafe_test_dst, %r9
-	ja \target
-.endm
-#else
-.macro MCSAFE_TEST_CTL
-.endm
-
-.macro MCSAFE_TEST_SRC reg count target
-.endm
-
-.macro MCSAFE_TEST_DST reg count target
-.endm
-#endif /* CONFIG_MCSAFE_TEST */
-#endif /* __ASSEMBLY__ */
-#endif /* _MCSAFE_TEST_H_ */
diff --git a/arch/x86/include/asm/string_64.h b/arch/x86/include/asm/string_64.h
index 75314c3dbe47..6e450827f677 100644
--- a/arch/x86/include/asm/string_64.h
+++ b/arch/x86/include/asm/string_64.h
@@ -82,38 +82,6 @@ int strcmp(const char *cs, const char *ct);
 
 #endif
 
-#define __HAVE_ARCH_MEMCPY_MCSAFE 1
-__must_check unsigned long __memcpy_mcsafe(void *dst, const void *src,
-		size_t cnt);
-DECLARE_STATIC_KEY_FALSE(mcsafe_key);
-
-/**
- * memcpy_mcsafe - copy memory with indication if a machine check happened
- *
- * @dst:	destination address
- * @src:	source address
- * @cnt:	number of bytes to copy
- *
- * Low level memory copy function that catches machine checks
- * We only call into the "safe" function on systems that can
- * actually do machine check recovery. Everyone else can just
- * use memcpy().
- *
- * Return 0 for success, or number of bytes not copied if there was an
- * exception.
- */
-static __always_inline __must_check unsigned long
-memcpy_mcsafe(void *dst, const void *src, size_t cnt)
-{
-#ifdef CONFIG_X86_MCE
-	if (static_branch_unlikely(&mcsafe_key))
-		return __memcpy_mcsafe(dst, src, cnt);
-	else
-#endif
-		memcpy(dst, src, cnt);
-	return 0;
-}
-
 #ifdef CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE
 #define __HAVE_ARCH_MEMCPY_FLUSHCACHE 1
 void __memcpy_flushcache(void *dst, const void *src, size_t cnt);
diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index ecefaffd15d4..eff7fb847149 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -455,6 +455,15 @@ extern __must_check long strnlen_user(const char __user *str, long n);
 unsigned long __must_check clear_user(void __user *mem, unsigned long len);
 unsigned long __must_check __clear_user(void __user *mem, unsigned long len);
 
+#ifdef CONFIG_ARCH_HAS_COPY_MC
+unsigned long __must_check
+copy_mc_to_kernel(void *to, const void *from, unsigned len);
+#define copy_mc_to_kernel copy_mc_to_kernel
+
+unsigned long __must_check
+copy_mc_to_user(void *to, const void *from, unsigned len);
+#endif
+
 /*
  * movsl can be slow when source and dest are not both 8-byte aligned
  */
diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index bc10e3dc64fe..e7265a552f4f 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -46,22 +46,6 @@ copy_user_generic(void *to, const void *from, unsigned len)
 	return ret;
 }
 
-static __always_inline __must_check unsigned long
-copy_to_user_mcsafe(void *to, const void *from, unsigned len)
-{
-	unsigned long ret;
-
-	__uaccess_begin();
-	/*
-	 * Note, __memcpy_mcsafe() is explicitly used since it can
-	 * handle exceptions / faults.  memcpy_mcsafe() may fall back to
-	 * memcpy() which lacks this handling.
-	 */
-	ret = __memcpy_mcsafe(to, from, len);
-	__uaccess_end();
-	return ret;
-}
-
 static __always_inline __must_check unsigned long
 raw_copy_from_user(void *dst, const void __user *src, unsigned long size)
 {
@@ -102,8 +86,4 @@ __copy_from_user_flushcache(void *dst, const void __user *src, unsigned size)
 	kasan_check_write(dst, size);
 	return __copy_user_flushcache(dst, src, size);
 }
-
-unsigned long
-mcsafe_handle_tail(char *to, char *from, unsigned len);
-
 #endif /* _ASM_X86_UACCESS_64_H */
diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 11b6697be010..b5b70f4b351d 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -40,7 +40,6 @@
 #include <linux/debugfs.h>
 #include <linux/irq_work.h>
 #include <linux/export.h>
-#include <linux/jump_label.h>
 #include <linux/set_memory.h>
 #include <linux/sync_core.h>
 #include <linux/task_work.h>
@@ -2124,7 +2123,7 @@ void mce_disable_bank(int bank)
 	and older.
  * mce=nobootlog Don't log MCEs from before booting.
  * mce=bios_cmci_threshold Don't program the CMCI threshold
- * mce=recovery force enable memcpy_mcsafe()
+ * mce=recovery force enable copy_mc_fragile()
  */
 static int __init mcheck_enable(char *str)
 {
@@ -2732,13 +2731,10 @@ static void __init mcheck_debugfs_init(void)
 static void __init mcheck_debugfs_init(void) { }
 #endif
 
-DEFINE_STATIC_KEY_FALSE(mcsafe_key);
-EXPORT_SYMBOL_GPL(mcsafe_key);
-
 static int __init mcheck_late_init(void)
 {
 	if (mca_cfg.recovery)
-		static_branch_inc(&mcsafe_key);
+		enable_copy_mc_fragile();
 
 	mcheck_debugfs_init();
 
diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index 1b10717c9321..6d0df6a58873 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -8,6 +8,7 @@
 
 #include <asm/hpet.h>
 #include <asm/setup.h>
+#include <asm/mce.h>
 
 #if defined(CONFIG_X86_IO_APIC) && defined(CONFIG_SMP) && defined(CONFIG_PCI)
 
@@ -624,10 +625,6 @@ static void amd_disable_seq_and_redirect_scrub(struct pci_dev *dev)
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_16H_NB_F3,
 			amd_disable_seq_and_redirect_scrub);
 
-#if defined(CONFIG_X86_64) && defined(CONFIG_X86_MCE)
-#include <linux/jump_label.h>
-#include <asm/string_64.h>
-
 /* Ivy Bridge, Haswell, Broadwell */
 static void quirk_intel_brickland_xeon_ras_cap(struct pci_dev *pdev)
 {
@@ -636,7 +633,7 @@ static void quirk_intel_brickland_xeon_ras_cap(struct pci_dev *pdev)
 	pci_read_config_dword(pdev, 0x84, &capid0);
 
 	if (capid0 & 0x10)
-		static_branch_inc(&mcsafe_key);
+		enable_copy_mc_fragile();
 }
 
 /* Skylake */
@@ -653,7 +650,7 @@ static void quirk_intel_purley_xeon_ras_cap(struct pci_dev *pdev)
 	 * enabled, so memory machine check recovery is also enabled.
 	 */
 	if ((capid0 & 0xc0) == 0xc0 || (capid5 & 0x1e0))
-		static_branch_inc(&mcsafe_key);
+		enable_copy_mc_fragile();
 
 }
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x0ec3, quirk_intel_brickland_xeon_ras_cap);
@@ -661,7 +658,6 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x2fc0, quirk_intel_brickland_xeon_
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x6fc0, quirk_intel_brickland_xeon_ras_cap);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x2083, quirk_intel_purley_xeon_ras_cap);
 #endif
-#endif
 
 bool x86_apple_machine;
 EXPORT_SYMBOL(x86_apple_machine);
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index d46fff11f06f..f7d23c9c22b2 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -44,6 +44,7 @@ obj-$(CONFIG_SMP) += msr-smp.o cache-smp.o
 lib-y := delay.o misc.o cmdline.o cpu.o
 lib-y += usercopy_$(BITS).o usercopy.o getuser.o putuser.o
 lib-y += memcpy_$(BITS).o
+lib-$(CONFIG_ARCH_HAS_COPY_MC) += copy_mc.o copy_mc_64.o
 lib-$(CONFIG_INSTRUCTION_DECODER) += insn.o inat.o insn-eval.o
 lib-$(CONFIG_RANDOMIZE_BASE) += kaslr.o
 lib-$(CONFIG_FUNCTION_ERROR_INJECTION)	+= error-inject.o
diff --git a/arch/x86/lib/copy_mc.c b/arch/x86/lib/copy_mc.c
new file mode 100644
index 000000000000..2633635530b7
--- /dev/null
+++ b/arch/x86/lib/copy_mc.c
@@ -0,0 +1,82 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2016-2020 Intel Corporation. All rights reserved. */
+
+#include <linux/jump_label.h>
+#include <linux/uaccess.h>
+#include <linux/export.h>
+#include <linux/string.h>
+#include <linux/types.h>
+
+#include <asm/mce.h>
+
+#ifdef CONFIG_X86_MCE
+/*
+ * See COPY_MC_TEST for self-test of the copy_mc_fragile()
+ * implementation.
+ */
+static DEFINE_STATIC_KEY_FALSE(copy_mc_fragile_key);
+
+void enable_copy_mc_fragile(void)
+{
+	static_branch_inc(&copy_mc_fragile_key);
+}
+#define copy_mc_fragile_enabled (static_branch_unlikely(&copy_mc_fragile_key))
+
+/*
+ * Similar to copy_user_handle_tail, probe for the write fault point, or
+ * source exception point.
+ */
+__visible notrace unsigned long
+copy_mc_fragile_handle_tail(char *to, char *from, unsigned len)
+{
+	for (; len; --len, to++, from++)
+		if (copy_mc_fragile(to, from, 1))
+			break;
+	return len;
+}
+#else
+/*
+ * No point in doing careful copying, or consulting a static key when
+ * there is no #MC handler in the CONFIG_X86_MCE=n case.
+ */
+void enable_copy_mc_fragile(void)
+{
+}
+#define copy_mc_fragile_enabled (0)
+#endif
+
+/**
+ * copy_mc_to_kernel - memory copy that handles source exceptions
+ *
+ * @dst:	destination address
+ * @src:	source address
+ * @len:	number of bytes to copy
+ *
+ * Call into the 'fragile' version on systems that have trouble
+ * actually do machine check recovery. Everyone else can just
+ * use memcpy().
+ *
+ * Return 0 for success, or number of bytes not copied if there was an
+ * exception.
+ */
+unsigned long __must_check copy_mc_to_kernel(void *dst, const void *src, unsigned len)
+{
+	if (copy_mc_fragile_enabled)
+		return copy_mc_fragile(dst, src, len);
+	memcpy(dst, src, len);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(copy_mc_to_kernel);
+
+unsigned long __must_check copy_mc_to_user(void *dst, const void *src, unsigned len)
+{
+	unsigned long ret;
+
+	if (!copy_mc_fragile_enabled)
+		return copy_user_generic(dst, src, len);
+
+	__uaccess_begin();
+	ret = copy_mc_fragile(dst, src, len);
+	__uaccess_end();
+	return ret;
+}
diff --git a/arch/x86/lib/copy_mc_64.S b/arch/x86/lib/copy_mc_64.S
new file mode 100644
index 000000000000..c3b613c4544a
--- /dev/null
+++ b/arch/x86/lib/copy_mc_64.S
@@ -0,0 +1,127 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright(c) 2016-2020 Intel Corporation. All rights reserved. */
+
+#include <linux/linkage.h>
+#include <asm/copy_mc_test.h>
+#include <asm/export.h>
+#include <asm/asm.h>
+
+#ifndef CONFIG_UML
+
+#ifdef CONFIG_X86_MCE
+COPY_MC_TEST_CTL
+
+/*
+ * copy_mc_fragile - copy memory with indication if an exception / fault happened
+ *
+ * The 'fragile' version is opted into by platform quirks and takes
+ * pains to avoid unrecoverable corner cases like 'fast-string'
+ * instruction sequences, and consuming poison across a cacheline
+ * boundary. The non-fragile version is equivalent to memcpy()
+ * regardless of CPU machine-check-recovery capability.
+ */
+SYM_FUNC_START(copy_mc_fragile)
+	cmpl $8, %edx
+	/* Less than 8 bytes? Go to byte copy loop */
+	jb .L_no_whole_words
+
+	/* Check for bad alignment of source */
+	testl $7, %esi
+	/* Already aligned */
+	jz .L_8byte_aligned
+
+	/* Copy one byte at a time until source is 8-byte aligned */
+	movl %esi, %ecx
+	andl $7, %ecx
+	subl $8, %ecx
+	negl %ecx
+	subl %ecx, %edx
+.L_read_leading_bytes:
+	movb (%rsi), %al
+	COPY_MC_TEST_SRC %rsi 1 .E_leading_bytes
+	COPY_MC_TEST_DST %rdi 1 .E_leading_bytes
+.L_write_leading_bytes:
+	movb %al, (%rdi)
+	incq %rsi
+	incq %rdi
+	decl %ecx
+	jnz .L_read_leading_bytes
+
+.L_8byte_aligned:
+	movl %edx, %ecx
+	andl $7, %edx
+	shrl $3, %ecx
+	jz .L_no_whole_words
+
+.L_read_words:
+	movq (%rsi), %r8
+	COPY_MC_TEST_SRC %rsi 8 .E_read_words
+	COPY_MC_TEST_DST %rdi 8 .E_write_words
+.L_write_words:
+	movq %r8, (%rdi)
+	addq $8, %rsi
+	addq $8, %rdi
+	decl %ecx
+	jnz .L_read_words
+
+	/* Any trailing bytes? */
+.L_no_whole_words:
+	andl %edx, %edx
+	jz .L_done_memcpy_trap
+
+	/* Copy trailing bytes */
+	movl %edx, %ecx
+.L_read_trailing_bytes:
+	movb (%rsi), %al
+	COPY_MC_TEST_SRC %rsi 1 .E_trailing_bytes
+	COPY_MC_TEST_DST %rdi 1 .E_trailing_bytes
+.L_write_trailing_bytes:
+	movb %al, (%rdi)
+	incq %rsi
+	incq %rdi
+	decl %ecx
+	jnz .L_read_trailing_bytes
+
+	/* Copy successful. Return zero */
+.L_done_memcpy_trap:
+	xorl %eax, %eax
+.L_done:
+	ret
+SYM_FUNC_END(copy_mc_fragile)
+EXPORT_SYMBOL_GPL(copy_mc_fragile)
+
+	.section .fixup, "ax"
+	/*
+	 * Return number of bytes not copied for any failure. Note that
+	 * there is no "tail" handling since the source buffer is 8-byte
+	 * aligned and poison is cacheline aligned.
+	 */
+.E_read_words:
+	shll	$3, %ecx
+.E_leading_bytes:
+	addl	%edx, %ecx
+.E_trailing_bytes:
+	mov	%ecx, %eax
+	jmp	.L_done
+
+	/*
+	 * For write fault handling, given the destination is unaligned,
+	 * we handle faults on multi-byte writes with a byte-by-byte
+	 * copy up to the write-protected page.
+	 */
+.E_write_words:
+	shll	$3, %ecx
+	addl	%edx, %ecx
+	movl	%ecx, %edx
+	jmp copy_mc_fragile_handle_tail
+
+	.previous
+
+	_ASM_EXTABLE_FAULT(.L_read_leading_bytes, .E_leading_bytes)
+	_ASM_EXTABLE_FAULT(.L_read_words, .E_read_words)
+	_ASM_EXTABLE_FAULT(.L_read_trailing_bytes, .E_trailing_bytes)
+	_ASM_EXTABLE(.L_write_leading_bytes, .E_leading_bytes)
+	_ASM_EXTABLE(.L_write_words, .E_write_words)
+	_ASM_EXTABLE(.L_write_trailing_bytes, .E_trailing_bytes)
+#endif /* CONFIG_X86_MCE */
+#endif /* !CONFIG_UML */
diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
index bbcc05bcefad..037faac46b0c 100644
--- a/arch/x86/lib/memcpy_64.S
+++ b/arch/x86/lib/memcpy_64.S
@@ -4,7 +4,6 @@
 #include <linux/linkage.h>
 #include <asm/errno.h>
 #include <asm/cpufeatures.h>
-#include <asm/mcsafe_test.h>
 #include <asm/alternative-asm.h>
 #include <asm/export.h>
 
@@ -187,117 +186,3 @@ SYM_FUNC_START_LOCAL(memcpy_orig)
 SYM_FUNC_END(memcpy_orig)
 
 .popsection
-
-#ifndef CONFIG_UML
-
-MCSAFE_TEST_CTL
-
-/*
- * __memcpy_mcsafe - memory copy with machine check exception handling
- * Note that we only catch machine checks when reading the source addresses.
- * Writes to target are posted and don't generate machine checks.
- */
-SYM_FUNC_START(__memcpy_mcsafe)
-	cmpl $8, %edx
-	/* Less than 8 bytes? Go to byte copy loop */
-	jb .L_no_whole_words
-
-	/* Check for bad alignment of source */
-	testl $7, %esi
-	/* Already aligned */
-	jz .L_8byte_aligned
-
-	/* Copy one byte at a time until source is 8-byte aligned */
-	movl %esi, %ecx
-	andl $7, %ecx
-	subl $8, %ecx
-	negl %ecx
-	subl %ecx, %edx
-.L_read_leading_bytes:
-	movb (%rsi), %al
-	MCSAFE_TEST_SRC %rsi 1 .E_leading_bytes
-	MCSAFE_TEST_DST %rdi 1 .E_leading_bytes
-.L_write_leading_bytes:
-	movb %al, (%rdi)
-	incq %rsi
-	incq %rdi
-	decl %ecx
-	jnz .L_read_leading_bytes
-
-.L_8byte_aligned:
-	movl %edx, %ecx
-	andl $7, %edx
-	shrl $3, %ecx
-	jz .L_no_whole_words
-
-.L_read_words:
-	movq (%rsi), %r8
-	MCSAFE_TEST_SRC %rsi 8 .E_read_words
-	MCSAFE_TEST_DST %rdi 8 .E_write_words
-.L_write_words:
-	movq %r8, (%rdi)
-	addq $8, %rsi
-	addq $8, %rdi
-	decl %ecx
-	jnz .L_read_words
-
-	/* Any trailing bytes? */
-.L_no_whole_words:
-	andl %edx, %edx
-	jz .L_done_memcpy_trap
-
-	/* Copy trailing bytes */
-	movl %edx, %ecx
-.L_read_trailing_bytes:
-	movb (%rsi), %al
-	MCSAFE_TEST_SRC %rsi 1 .E_trailing_bytes
-	MCSAFE_TEST_DST %rdi 1 .E_trailing_bytes
-.L_write_trailing_bytes:
-	movb %al, (%rdi)
-	incq %rsi
-	incq %rdi
-	decl %ecx
-	jnz .L_read_trailing_bytes
-
-	/* Copy successful. Return zero */
-.L_done_memcpy_trap:
-	xorl %eax, %eax
-.L_done:
-	ret
-SYM_FUNC_END(__memcpy_mcsafe)
-EXPORT_SYMBOL_GPL(__memcpy_mcsafe)
-
-	.section .fixup, "ax"
-	/*
-	 * Return number of bytes not copied for any failure. Note that
-	 * there is no "tail" handling since the source buffer is 8-byte
-	 * aligned and poison is cacheline aligned.
-	 */
-.E_read_words:
-	shll	$3, %ecx
-.E_leading_bytes:
-	addl	%edx, %ecx
-.E_trailing_bytes:
-	mov	%ecx, %eax
-	jmp	.L_done
-
-	/*
-	 * For write fault handling, given the destination is unaligned,
-	 * we handle faults on multi-byte writes with a byte-by-byte
-	 * copy up to the write-protected page.
-	 */
-.E_write_words:
-	shll	$3, %ecx
-	addl	%edx, %ecx
-	movl	%ecx, %edx
-	jmp mcsafe_handle_tail
-
-	.previous
-
-	_ASM_EXTABLE_FAULT(.L_read_leading_bytes, .E_leading_bytes)
-	_ASM_EXTABLE_FAULT(.L_read_words, .E_read_words)
-	_ASM_EXTABLE_FAULT(.L_read_trailing_bytes, .E_trailing_bytes)
-	_ASM_EXTABLE(.L_write_leading_bytes, .E_leading_bytes)
-	_ASM_EXTABLE(.L_write_words, .E_write_words)
-	_ASM_EXTABLE(.L_write_trailing_bytes, .E_trailing_bytes)
-#endif
diff --git a/arch/x86/lib/usercopy_64.c b/arch/x86/lib/usercopy_64.c
index b0dfac3d3df7..5f1d4a9ebd5a 100644
--- a/arch/x86/lib/usercopy_64.c
+++ b/arch/x86/lib/usercopy_64.c
@@ -56,27 +56,6 @@ unsigned long clear_user(void __user *to, unsigned long n)
 }
 EXPORT_SYMBOL(clear_user);
 
-/*
- * Similar to copy_user_handle_tail, probe for the write fault point,
- * but reuse __memcpy_mcsafe in case a new read error is encountered.
- * clac() is handled in _copy_to_iter_mcsafe().
- */
-__visible notrace unsigned long
-mcsafe_handle_tail(char *to, char *from, unsigned len)
-{
-	for (; len; --len, to++, from++) {
-		/*
-		 * Call the assembly routine back directly since
-		 * memcpy_mcsafe() may silently fallback to memcpy.
-		 */
-		unsigned long rem = __memcpy_mcsafe(to, from, 1);
-
-		if (rem)
-			break;
-	}
-	return len;
-}
-
 #ifdef CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE
 /**
  * clean_cache_range - write back a cache range with CLWB
diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 86dbe0c8b45c..9fc18fadacc6 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -49,7 +49,7 @@ do {								\
 #define pmem_assign(dest, src)	((dest) = (src))
 #endif
 
-#if defined(__HAVE_ARCH_MEMCPY_MCSAFE) && defined(DM_WRITECACHE_HAS_PMEM)
+#if IS_ENABLED(CONFIG_ARCH_HAS_COPY_MC) && defined(DM_WRITECACHE_HAS_PMEM)
 #define DM_WRITECACHE_HANDLE_HARDWARE_ERRORS
 #endif
 
@@ -984,7 +984,8 @@ static void writecache_resume(struct dm_target *ti)
 	}
 	wc->freelist_size = 0;
 
-	r = memcpy_mcsafe(&sb_seq_count, &sb(wc)->seq_count, sizeof(uint64_t));
+	r = copy_mc_to_kernel(&sb_seq_count, &sb(wc)->seq_count,
+			      sizeof(uint64_t));
 	if (r) {
 		writecache_error(wc, r, "hardware memory error when reading superblock: %d", r);
 		sb_seq_count = cpu_to_le64(0);
@@ -1000,7 +1001,8 @@ static void writecache_resume(struct dm_target *ti)
 			e->seq_count = -1;
 			continue;
 		}
-		r = memcpy_mcsafe(&wme, memory_entry(wc, e), sizeof(struct wc_memory_entry));
+		r = copy_mc_to_kernel(&wme, memory_entry(wc, e),
+				      sizeof(struct wc_memory_entry));
 		if (r) {
 			writecache_error(wc, r, "hardware memory error when reading metadata entry %lu: %d",
 					 (unsigned long)b, r);
@@ -1198,7 +1200,7 @@ static void bio_copy_block(struct dm_writecache *wc, struct bio *bio, void *data
 
 		if (rw == READ) {
 			int r;
-			r = memcpy_mcsafe(buf, data, size);
+			r = copy_mc_to_kernel(buf, data, size);
 			flush_dcache_page(bio_page(bio));
 			if (unlikely(r)) {
 				writecache_error(wc, r, "hardware memory error when reading data: %d", r);
@@ -2341,7 +2343,7 @@ static int writecache_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		}
 	}
 
-	r = memcpy_mcsafe(&s, sb(wc), sizeof(struct wc_memory_superblock));
+	r = copy_mc_to_kernel(&s, sb(wc), sizeof(struct wc_memory_superblock));
 	if (r) {
 		ti->error = "Hardware memory error when reading superblock";
 		goto bad;
@@ -2352,7 +2354,8 @@ static int writecache_ctr(struct dm_target *ti, unsigned argc, char **argv)
 			ti->error = "Unable to initialize device";
 			goto bad;
 		}
-		r = memcpy_mcsafe(&s, sb(wc), sizeof(struct wc_memory_superblock));
+		r = copy_mc_to_kernel(&s, sb(wc),
+				      sizeof(struct wc_memory_superblock));
 		if (r) {
 			ti->error = "Hardware memory error when reading superblock";
 			goto bad;
diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
index 45964acba944..22d865ba6353 100644
--- a/drivers/nvdimm/claim.c
+++ b/drivers/nvdimm/claim.c
@@ -268,7 +268,7 @@ static int nsio_rw_bytes(struct nd_namespace_common *ndns,
 	if (rw == READ) {
 		if (unlikely(is_bad_pmem(&nsio->bb, sector, sz_align)))
 			return -EIO;
-		if (memcpy_mcsafe(buf, nsio->addr + offset, size) != 0)
+		if (copy_mc_to_kernel(buf, nsio->addr + offset, size) != 0)
 			return -EIO;
 		return 0;
 	}
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index fab29b514372..5c6939e004e2 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -125,7 +125,7 @@ static blk_status_t read_pmem(struct page *page, unsigned int off,
 	while (len) {
 		mem = kmap_atomic(page);
 		chunk = min_t(unsigned int, len, PAGE_SIZE - off);
-		rem = memcpy_mcsafe(mem + off, pmem_addr, chunk);
+		rem = copy_mc_to_kernel(mem + off, pmem_addr, chunk);
 		kunmap_atomic(mem);
 		if (rem)
 			return BLK_STS_IOERR;
@@ -304,7 +304,7 @@ static long pmem_dax_direct_access(struct dax_device *dax_dev,
 
 /*
  * Use the 'no check' versions of copy_from_iter_flushcache() and
- * copy_to_iter_mcsafe() to bypass HARDENED_USERCOPY overhead. Bounds
+ * copy_mc_to_iter() to bypass HARDENED_USERCOPY overhead. Bounds
  * checking, both file offset and device offset, is handled by
  * dax_iomap_actor()
  */
@@ -317,7 +317,7 @@ static size_t pmem_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff,
 static size_t pmem_copy_to_iter(struct dax_device *dax_dev, pgoff_t pgoff,
 		void *addr, size_t bytes, struct iov_iter *i)
 {
-	return _copy_to_iter_mcsafe(addr, bytes, i);
+	return _copy_mc_to_iter(addr, bytes, i);
 }
 
 static const struct dax_operations pmem_dax_ops = {
diff --git a/include/linux/string.h b/include/linux/string.h
index 9b7a0632e87a..b1f3894a0a3e 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -161,20 +161,13 @@ extern int bcmp(const void *,const void *,__kernel_size_t);
 #ifndef __HAVE_ARCH_MEMCHR
 extern void * memchr(const void *,int,__kernel_size_t);
 #endif
-#ifndef __HAVE_ARCH_MEMCPY_MCSAFE
-static inline __must_check unsigned long memcpy_mcsafe(void *dst,
-		const void *src, size_t cnt)
-{
-	memcpy(dst, src, cnt);
-	return 0;
-}
-#endif
 #ifndef __HAVE_ARCH_MEMCPY_FLUSHCACHE
 static inline void memcpy_flushcache(void *dst, const void *src, size_t cnt)
 {
 	memcpy(dst, src, cnt);
 }
 #endif
+
 void *memchr_inv(const void *s, int c, size_t n);
 char *strreplace(char *s, char old, char new);
 
diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index 94b285411659..1ae36bc8db35 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -179,6 +179,19 @@ copy_in_user(void __user *to, const void __user *from, unsigned long n)
 }
 #endif
 
+#ifndef copy_mc_to_kernel
+/*
+ * Without arch opt-in this generic copy_mc_to_kernel() will not handle
+ * #MC (or arch equivalent) during source read.
+ */
+static inline unsigned long __must_check
+copy_mc_to_kernel(void *dst, const void *src, size_t cnt)
+{
+	memcpy(dst, src, cnt);
+	return 0;
+}
+#endif
+
 static __always_inline void pagefault_disabled_inc(void)
 {
 	current->pagefault_disabled++;
diff --git a/include/linux/uio.h b/include/linux/uio.h
index 3835a8a8e9ea..f14410c678bd 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -185,10 +185,10 @@ size_t _copy_from_iter_flushcache(void *addr, size_t bytes, struct iov_iter *i);
 #define _copy_from_iter_flushcache _copy_from_iter_nocache
 #endif
 
-#ifdef CONFIG_ARCH_HAS_UACCESS_MCSAFE
-size_t _copy_to_iter_mcsafe(const void *addr, size_t bytes, struct iov_iter *i);
+#ifdef CONFIG_ARCH_HAS_COPY_MC
+size_t _copy_mc_to_iter(const void *addr, size_t bytes, struct iov_iter *i);
 #else
-#define _copy_to_iter_mcsafe _copy_to_iter
+#define _copy_mc_to_iter _copy_to_iter
 #endif
 
 static __always_inline __must_check
@@ -201,12 +201,12 @@ size_t copy_from_iter_flushcache(void *addr, size_t bytes, struct iov_iter *i)
 }
 
 static __always_inline __must_check
-size_t copy_to_iter_mcsafe(void *addr, size_t bytes, struct iov_iter *i)
+size_t copy_mc_to_iter(void *addr, size_t bytes, struct iov_iter *i)
 {
 	if (unlikely(!check_copy_size(addr, bytes, true)))
 		return 0;
 	else
-		return _copy_to_iter_mcsafe(addr, bytes, i);
+		return _copy_mc_to_iter(addr, bytes, i);
 }
 
 size_t iov_iter_zero(size_t bytes, struct iov_iter *);
diff --git a/lib/Kconfig b/lib/Kconfig
index b4b98a03ff98..b46a9fd122c8 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -635,7 +635,12 @@ config UACCESS_MEMCPY
 config ARCH_HAS_UACCESS_FLUSHCACHE
 	bool
 
-config ARCH_HAS_UACCESS_MCSAFE
+# arch has a concept of a recoverable synchronous exception due to a
+# memory-read error like x86 machine-check or ARM data-abort, and
+# implements copy_mc_to_{user,kernel} to abort and report
+# 'bytes-transferred' if that exception fires when accessing the source
+# buffer.
+config ARCH_HAS_COPY_MC
 	bool
 
 # Temporary. Goes away when all archs are cleaned up
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 5e40786c8f12..d13304a034f5 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -637,30 +637,30 @@ size_t _copy_to_iter(const void *addr, size_t bytes, struct iov_iter *i)
 }
 EXPORT_SYMBOL(_copy_to_iter);
 
-#ifdef CONFIG_ARCH_HAS_UACCESS_MCSAFE
-static int copyout_mcsafe(void __user *to, const void *from, size_t n)
+#ifdef CONFIG_ARCH_HAS_COPY_MC
+static int copyout_mc(void __user *to, const void *from, size_t n)
 {
 	if (access_ok(to, n)) {
 		instrument_copy_to_user(to, from, n);
-		n = copy_to_user_mcsafe((__force void *) to, from, n);
+		n = copy_mc_to_user((__force void *) to, from, n);
 	}
 	return n;
 }
 
-static unsigned long memcpy_mcsafe_to_page(struct page *page, size_t offset,
+static unsigned long copy_mc_to_page(struct page *page, size_t offset,
 		const char *from, size_t len)
 {
 	unsigned long ret;
 	char *to;
 
 	to = kmap_atomic(page);
-	ret = memcpy_mcsafe(to + offset, from, len);
+	ret = copy_mc_to_kernel(to + offset, from, len);
 	kunmap_atomic(to);
 
 	return ret;
 }
 
-static size_t copy_pipe_to_iter_mcsafe(const void *addr, size_t bytes,
+static size_t copy_mc_pipe_to_iter(const void *addr, size_t bytes,
 				struct iov_iter *i)
 {
 	struct pipe_inode_info *pipe = i->pipe;
@@ -678,7 +678,7 @@ static size_t copy_pipe_to_iter_mcsafe(const void *addr, size_t bytes,
 		size_t chunk = min_t(size_t, n, PAGE_SIZE - off);
 		unsigned long rem;
 
-		rem = memcpy_mcsafe_to_page(pipe->bufs[i_head & p_mask].page,
+		rem = copy_mc_to_page(pipe->bufs[i_head & p_mask].page,
 					    off, addr, chunk);
 		i->head = i_head;
 		i->iov_offset = off + chunk - rem;
@@ -695,18 +695,17 @@ static size_t copy_pipe_to_iter_mcsafe(const void *addr, size_t bytes,
 }
 
 /**
- * _copy_to_iter_mcsafe - copy to user with source-read error exception handling
+ * _copy_mc_to_iter - copy to iter with source memory error exception handling
  * @addr: source kernel address
  * @bytes: total transfer length
  * @iter: destination iterator
  *
- * The pmem driver arranges for filesystem-dax to use this facility via
- * dax_copy_to_iter() for protecting read/write to persistent memory.
- * Unless / until an architecture can guarantee identical performance
- * between _copy_to_iter_mcsafe() and _copy_to_iter() it would be a
- * performance regression to switch more users to the mcsafe version.
+ * The pmem driver deploys this for the dax operation
+ * (dax_copy_to_iter()) for dax reads (bypass page-cache and the
+ * block-layer). Upon #MC read(2) aborts and returns EIO or the bytes
+ * successfully copied.
  *
- * Otherwise, the main differences between this and typical _copy_to_iter().
+ * The main differences between this and typical _copy_to_iter().
  *
  * * Typical tail/residue handling after a fault retries the copy
  *   byte-by-byte until the fault happens again. Re-triggering machine
@@ -717,23 +716,22 @@ static size_t copy_pipe_to_iter_mcsafe(const void *addr, size_t bytes,
  * * ITER_KVEC, ITER_PIPE, and ITER_BVEC can return short copies.
  *   Compare to copy_to_iter() where only ITER_IOVEC attempts might return
  *   a short copy.
- *
- * See MCSAFE_TEST for self-test.
  */
-size_t _copy_to_iter_mcsafe(const void *addr, size_t bytes, struct iov_iter *i)
+size_t _copy_mc_to_iter(const void *addr, size_t bytes, struct iov_iter *i)
 {
 	const char *from = addr;
 	unsigned long rem, curr_addr, s_addr = (unsigned long) addr;
 
 	if (unlikely(iov_iter_is_pipe(i)))
-		return copy_pipe_to_iter_mcsafe(addr, bytes, i);
+		return copy_mc_pipe_to_iter(addr, bytes, i);
 	if (iter_is_iovec(i))
 		might_fault();
 	iterate_and_advance(i, bytes, v,
-		copyout_mcsafe(v.iov_base, (from += v.iov_len) - v.iov_len, v.iov_len),
+		copyout_mc(v.iov_base, (from += v.iov_len) - v.iov_len,
+			   v.iov_len),
 		({
-		rem = memcpy_mcsafe_to_page(v.bv_page, v.bv_offset,
-                               (from += v.bv_len) - v.bv_len, v.bv_len);
+		rem = copy_mc_to_page(v.bv_page, v.bv_offset,
+				      (from += v.bv_len) - v.bv_len, v.bv_len);
 		if (rem) {
 			curr_addr = (unsigned long) from;
 			bytes = curr_addr - s_addr - rem;
@@ -741,8 +739,8 @@ size_t _copy_to_iter_mcsafe(const void *addr, size_t bytes, struct iov_iter *i)
 		}
 		}),
 		({
-		rem = memcpy_mcsafe(v.iov_base, (from += v.iov_len) - v.iov_len,
-				v.iov_len);
+		rem = copy_mc_to_kernel(v.iov_base, (from += v.iov_len)
+					- v.iov_len, v.iov_len);
 		if (rem) {
 			curr_addr = (unsigned long) from;
 			bytes = curr_addr - s_addr - rem;
@@ -753,8 +751,8 @@ size_t _copy_to_iter_mcsafe(const void *addr, size_t bytes, struct iov_iter *i)
 
 	return bytes;
 }
-EXPORT_SYMBOL_GPL(_copy_to_iter_mcsafe);
-#endif /* CONFIG_ARCH_HAS_UACCESS_MCSAFE */
+EXPORT_SYMBOL_GPL(_copy_mc_to_iter);
+#endif /* CONFIG_ARCH_HAS_COPY_MC */
 
 size_t _copy_from_iter(void *addr, size_t bytes, struct iov_iter *i)
 {
diff --git a/tools/arch/x86/include/asm/mcsafe_test.h b/tools/arch/x86/include/asm/mcsafe_test.h
deleted file mode 100644
index 2ccd588fbad4..000000000000
--- a/tools/arch/x86/include/asm/mcsafe_test.h
+++ /dev/null
@@ -1,13 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _MCSAFE_TEST_H_
-#define _MCSAFE_TEST_H_
-
-.macro MCSAFE_TEST_CTL
-.endm
-
-.macro MCSAFE_TEST_SRC reg count target
-.endm
-
-.macro MCSAFE_TEST_DST reg count target
-.endm
-#endif /* _MCSAFE_TEST_H_ */
diff --git a/tools/arch/x86/lib/memcpy_64.S b/tools/arch/x86/lib/memcpy_64.S
index 45f8e1b02241..0b5b8ae56bd9 100644
--- a/tools/arch/x86/lib/memcpy_64.S
+++ b/tools/arch/x86/lib/memcpy_64.S
@@ -4,7 +4,6 @@
 #include <linux/linkage.h>
 #include <asm/errno.h>
 #include <asm/cpufeatures.h>
-#include <asm/mcsafe_test.h>
 #include <asm/alternative-asm.h>
 #include <asm/export.h>
 
@@ -187,117 +186,3 @@ SYM_FUNC_START(memcpy_orig)
 SYM_FUNC_END(memcpy_orig)
 
 .popsection
-
-#ifndef CONFIG_UML
-
-MCSAFE_TEST_CTL
-
-/*
- * __memcpy_mcsafe - memory copy with machine check exception handling
- * Note that we only catch machine checks when reading the source addresses.
- * Writes to target are posted and don't generate machine checks.
- */
-SYM_FUNC_START(__memcpy_mcsafe)
-	cmpl $8, %edx
-	/* Less than 8 bytes? Go to byte copy loop */
-	jb .L_no_whole_words
-
-	/* Check for bad alignment of source */
-	testl $7, %esi
-	/* Already aligned */
-	jz .L_8byte_aligned
-
-	/* Copy one byte at a time until source is 8-byte aligned */
-	movl %esi, %ecx
-	andl $7, %ecx
-	subl $8, %ecx
-	negl %ecx
-	subl %ecx, %edx
-.L_read_leading_bytes:
-	movb (%rsi), %al
-	MCSAFE_TEST_SRC %rsi 1 .E_leading_bytes
-	MCSAFE_TEST_DST %rdi 1 .E_leading_bytes
-.L_write_leading_bytes:
-	movb %al, (%rdi)
-	incq %rsi
-	incq %rdi
-	decl %ecx
-	jnz .L_read_leading_bytes
-
-.L_8byte_aligned:
-	movl %edx, %ecx
-	andl $7, %edx
-	shrl $3, %ecx
-	jz .L_no_whole_words
-
-.L_read_words:
-	movq (%rsi), %r8
-	MCSAFE_TEST_SRC %rsi 8 .E_read_words
-	MCSAFE_TEST_DST %rdi 8 .E_write_words
-.L_write_words:
-	movq %r8, (%rdi)
-	addq $8, %rsi
-	addq $8, %rdi
-	decl %ecx
-	jnz .L_read_words
-
-	/* Any trailing bytes? */
-.L_no_whole_words:
-	andl %edx, %edx
-	jz .L_done_memcpy_trap
-
-	/* Copy trailing bytes */
-	movl %edx, %ecx
-.L_read_trailing_bytes:
-	movb (%rsi), %al
-	MCSAFE_TEST_SRC %rsi 1 .E_trailing_bytes
-	MCSAFE_TEST_DST %rdi 1 .E_trailing_bytes
-.L_write_trailing_bytes:
-	movb %al, (%rdi)
-	incq %rsi
-	incq %rdi
-	decl %ecx
-	jnz .L_read_trailing_bytes
-
-	/* Copy successful. Return zero */
-.L_done_memcpy_trap:
-	xorl %eax, %eax
-.L_done:
-	ret
-SYM_FUNC_END(__memcpy_mcsafe)
-EXPORT_SYMBOL_GPL(__memcpy_mcsafe)
-
-	.section .fixup, "ax"
-	/*
-	 * Return number of bytes not copied for any failure. Note that
-	 * there is no "tail" handling since the source buffer is 8-byte
-	 * aligned and poison is cacheline aligned.
-	 */
-.E_read_words:
-	shll	$3, %ecx
-.E_leading_bytes:
-	addl	%edx, %ecx
-.E_trailing_bytes:
-	mov	%ecx, %eax
-	jmp	.L_done
-
-	/*
-	 * For write fault handling, given the destination is unaligned,
-	 * we handle faults on multi-byte writes with a byte-by-byte
-	 * copy up to the write-protected page.
-	 */
-.E_write_words:
-	shll	$3, %ecx
-	addl	%edx, %ecx
-	movl	%ecx, %edx
-	jmp mcsafe_handle_tail
-
-	.previous
-
-	_ASM_EXTABLE_FAULT(.L_read_leading_bytes, .E_leading_bytes)
-	_ASM_EXTABLE_FAULT(.L_read_words, .E_read_words)
-	_ASM_EXTABLE_FAULT(.L_read_trailing_bytes, .E_trailing_bytes)
-	_ASM_EXTABLE(.L_write_leading_bytes, .E_leading_bytes)
-	_ASM_EXTABLE(.L_write_words, .E_write_words)
-	_ASM_EXTABLE(.L_write_trailing_bytes, .E_trailing_bytes)
-#endif
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index e034a8f24f46..893f021fec63 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -548,8 +548,8 @@ static const char *uaccess_safe_builtin[] = {
 	"__ubsan_handle_shift_out_of_bounds",
 	/* misc */
 	"csum_partial_copy_generic",
-	"__memcpy_mcsafe",
-	"mcsafe_handle_tail",
+	"copy_mc_fragile",
+	"copy_mc_fragile_handle_tail",
 	"ftrace_likely_update", /* CONFIG_TRACE_BRANCH_PROFILING */
 	NULL
 };
diff --git a/tools/perf/bench/Build b/tools/perf/bench/Build
index dd68a40a790c..878db6a59a41 100644
--- a/tools/perf/bench/Build
+++ b/tools/perf/bench/Build
@@ -13,7 +13,6 @@ perf-y += synthesize.o
 perf-y += kallsyms-parse.o
 perf-y += find-bit-bench.o
 
-perf-$(CONFIG_X86_64) += mem-memcpy-x86-64-lib.o
 perf-$(CONFIG_X86_64) += mem-memcpy-x86-64-asm.o
 perf-$(CONFIG_X86_64) += mem-memset-x86-64-asm.o
 
diff --git a/tools/perf/bench/mem-memcpy-x86-64-lib.c b/tools/perf/bench/mem-memcpy-x86-64-lib.c
deleted file mode 100644
index 4130734dde84..000000000000
--- a/tools/perf/bench/mem-memcpy-x86-64-lib.c
+++ /dev/null
@@ -1,24 +0,0 @@
-/*
- * From code in arch/x86/lib/usercopy_64.c, copied to keep tools/ copy
- * of the kernel's arch/x86/lib/memcpy_64.s used in 'perf bench mem memcpy'
- * happy.
- */
-#include <linux/types.h>
-
-unsigned long __memcpy_mcsafe(void *dst, const void *src, size_t cnt);
-unsigned long mcsafe_handle_tail(char *to, char *from, unsigned len);
-
-unsigned long mcsafe_handle_tail(char *to, char *from, unsigned len)
-{
-	for (; len; --len, to++, from++) {
-		/*
-		 * Call the assembly routine back directly since
-		 * memcpy_mcsafe() may silently fallback to memcpy.
-		 */
-		unsigned long rem = __memcpy_mcsafe(to, from, 1);
-
-		if (rem)
-			break;
-	}
-	return len;
-}
diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index a1a5dc645b40..2ac0fff6dad8 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -23,7 +23,8 @@
 #include "nfit_test.h"
 #include "../watermark.h"
 
-#include <asm/mcsafe_test.h>
+#include <asm/copy_mc_test.h>
+#include <asm/mce.h>
 
 /*
  * Generate an NFIT table to describe the following topology:
@@ -3283,7 +3284,7 @@ static struct platform_driver nfit_test_driver = {
 	.id_table = nfit_test_id,
 };
 
-static char mcsafe_buf[PAGE_SIZE] __attribute__((__aligned__(PAGE_SIZE)));
+static char copy_mc_buf[PAGE_SIZE] __attribute__((__aligned__(PAGE_SIZE)));
 
 enum INJECT {
 	INJECT_NONE,
@@ -3291,7 +3292,7 @@ enum INJECT {
 	INJECT_DST,
 };
 
-static void mcsafe_test_init(char *dst, char *src, size_t size)
+static void copy_mc_test_init(char *dst, char *src, size_t size)
 {
 	size_t i;
 
@@ -3300,7 +3301,7 @@ static void mcsafe_test_init(char *dst, char *src, size_t size)
 		src[i] = (char) i;
 }
 
-static bool mcsafe_test_validate(unsigned char *dst, unsigned char *src,
+static bool copy_mc_test_validate(unsigned char *dst, unsigned char *src,
 		size_t size, unsigned long rem)
 {
 	size_t i;
@@ -3321,12 +3322,12 @@ static bool mcsafe_test_validate(unsigned char *dst, unsigned char *src,
 	return true;
 }
 
-void mcsafe_test(void)
+void copy_mc_test(void)
 {
 	char *inject_desc[] = { "none", "source", "destination" };
 	enum INJECT inj;
 
-	if (IS_ENABLED(CONFIG_MCSAFE_TEST)) {
+	if (IS_ENABLED(CONFIG_COPY_MC_TEST)) {
 		pr_info("%s: run...\n", __func__);
 	} else {
 		pr_info("%s: disabled, skip.\n", __func__);
@@ -3344,31 +3345,31 @@ void mcsafe_test(void)
 
 			switch (inj) {
 			case INJECT_NONE:
-				mcsafe_inject_src(NULL);
-				mcsafe_inject_dst(NULL);
-				dst = &mcsafe_buf[2048];
-				src = &mcsafe_buf[1024 - i];
+				copy_mc_inject_src(NULL);
+				copy_mc_inject_dst(NULL);
+				dst = &copy_mc_buf[2048];
+				src = &copy_mc_buf[1024 - i];
 				expect = 0;
 				break;
 			case INJECT_SRC:
-				mcsafe_inject_src(&mcsafe_buf[1024]);
-				mcsafe_inject_dst(NULL);
-				dst = &mcsafe_buf[2048];
-				src = &mcsafe_buf[1024 - i];
+				copy_mc_inject_src(&copy_mc_buf[1024]);
+				copy_mc_inject_dst(NULL);
+				dst = &copy_mc_buf[2048];
+				src = &copy_mc_buf[1024 - i];
 				expect = 512 - i;
 				break;
 			case INJECT_DST:
-				mcsafe_inject_src(NULL);
-				mcsafe_inject_dst(&mcsafe_buf[2048]);
-				dst = &mcsafe_buf[2048 - i];
-				src = &mcsafe_buf[1024];
+				copy_mc_inject_src(NULL);
+				copy_mc_inject_dst(&copy_mc_buf[2048]);
+				dst = &copy_mc_buf[2048 - i];
+				src = &copy_mc_buf[1024];
 				expect = 512 - i;
 				break;
 			}
 
-			mcsafe_test_init(dst, src, 512);
-			rem = __memcpy_mcsafe(dst, src, 512);
-			valid = mcsafe_test_validate(dst, src, 512, expect);
+			copy_mc_test_init(dst, src, 512);
+			rem = copy_mc_fragile(dst, src, 512);
+			valid = copy_mc_test_validate(dst, src, 512, expect);
 			if (rem == expect && valid)
 				continue;
 			pr_info("%s: copy(%#lx, %#lx, %d) off: %d rem: %ld %s expect: %ld\n",
@@ -3380,8 +3381,8 @@ void mcsafe_test(void)
 		}
 	}
 
-	mcsafe_inject_src(NULL);
-	mcsafe_inject_dst(NULL);
+	copy_mc_inject_src(NULL);
+	copy_mc_inject_dst(NULL);
 }
 
 static __init int nfit_test_init(void)
@@ -3392,7 +3393,7 @@ static __init int nfit_test_init(void)
 	libnvdimm_test();
 	acpi_nfit_test();
 	device_dax_test();
-	mcsafe_test();
+	copy_mc_test();
 	dax_pmem_test();
 	dax_pmem_core_test();
 #ifdef CONFIG_DEV_DAX_PMEM_COMPAT
diff --git a/tools/testing/selftests/powerpc/copyloops/.gitignore b/tools/testing/selftests/powerpc/copyloops/.gitignore
index ddaf140b8255..994b11af765c 100644
--- a/tools/testing/selftests/powerpc/copyloops/.gitignore
+++ b/tools/testing/selftests/powerpc/copyloops/.gitignore
@@ -12,4 +12,4 @@ memcpy_p7_t1
 copyuser_64_exc_t0
 copyuser_64_exc_t1
 copyuser_64_exc_t2
-memcpy_mcsafe_64
+copy_mc_64
diff --git a/tools/testing/selftests/powerpc/copyloops/Makefile b/tools/testing/selftests/powerpc/copyloops/Makefile
index 0917983a1c78..3095b1f1c02b 100644
--- a/tools/testing/selftests/powerpc/copyloops/Makefile
+++ b/tools/testing/selftests/powerpc/copyloops/Makefile
@@ -12,7 +12,7 @@ ASFLAGS = $(CFLAGS) -Wa,-mpower4
 TEST_GEN_PROGS := copyuser_64_t0 copyuser_64_t1 copyuser_64_t2 \
 		copyuser_p7_t0 copyuser_p7_t1 \
 		memcpy_64_t0 memcpy_64_t1 memcpy_64_t2 \
-		memcpy_p7_t0 memcpy_p7_t1 memcpy_mcsafe_64 \
+		memcpy_p7_t0 memcpy_p7_t1 copy_mc_64 \
 		copyuser_64_exc_t0 copyuser_64_exc_t1 copyuser_64_exc_t2
 
 EXTRA_SOURCES := validate.c ../harness.c stubs.S
@@ -45,9 +45,9 @@ $(OUTPUT)/memcpy_p7_t%:	memcpy_power7.S $(EXTRA_SOURCES)
 		-D SELFTEST_CASE=$(subst memcpy_p7_t,,$(notdir $@)) \
 		-o $@ $^
 
-$(OUTPUT)/memcpy_mcsafe_64: memcpy_mcsafe_64.S $(EXTRA_SOURCES)
+$(OUTPUT)/copy_mc_64: copy_mc_64.S $(EXTRA_SOURCES)
 	$(CC) $(CPPFLAGS) $(CFLAGS) \
-		-D COPY_LOOP=test_memcpy_mcsafe \
+		-D COPY_LOOP=test_copy_mc_generic \
 		-o $@ $^
 
 $(OUTPUT)/copyuser_64_exc_t%: copyuser_64.S exc_validate.c ../harness.c \
diff --git a/tools/testing/selftests/powerpc/copyloops/copy_mc_64.S b/tools/testing/selftests/powerpc/copyloops/copy_mc_64.S
new file mode 120000
index 000000000000..dcbe06d500fb
--- /dev/null
+++ b/tools/testing/selftests/powerpc/copyloops/copy_mc_64.S
@@ -0,0 +1 @@
+../../../../../arch/powerpc/lib/copy_mc_64.S
\ No newline at end of file
diff --git a/tools/testing/selftests/powerpc/copyloops/memcpy_mcsafe_64.S b/tools/testing/selftests/powerpc/copyloops/memcpy_mcsafe_64.S
deleted file mode 120000
index f0feef3062f6..000000000000
--- a/tools/testing/selftests/powerpc/copyloops/memcpy_mcsafe_64.S
+++ /dev/null
@@ -1 +0,0 @@
-../../../../../arch/powerpc/lib/memcpy_mcsafe_64.S
\ No newline at end of file


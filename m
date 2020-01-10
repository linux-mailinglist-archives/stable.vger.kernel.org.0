Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8BC5137957
	for <lists+stable@lfdr.de>; Fri, 10 Jan 2020 23:08:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728362AbgAJWH3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jan 2020 17:07:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:55266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728358AbgAJWH3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jan 2020 17:07:29 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D40F2072E;
        Fri, 10 Jan 2020 22:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578694048;
        bh=n5A8zrx5IBkhzFGC6iVubvTMK9ruwTJwfg3zKQNUoG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yilyjwdmJmvZCjbPYvhgezvAmgsPRSCUGD5FJWdIzgUfgSvxWlwG4IlRmyMalyi2Q
         TRyceHxn6G7vU6l3OWG3yzMnv/CJON1Ye1Co3/JVQAzHtnN1ynT4a0aa6ic3bp8A2g
         vmeEQYKVGwDMrbz+DTrcBa7WtXm12j6wpi37Y1fk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Sid Manning <sidneym@codeaurora.org>,
        Brian Cain <bcain@codeaurora.org>,
        Lee Jones <lee.jones@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Tuowen Zhao <ztuowen@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Allison Randal <allison@lohutok.net>,
        Will Deacon <will@kernel.org>,
        Richard Fontana <rfontana@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-hexagon@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 4/6] hexagon: parenthesize registers in asm predicates
Date:   Fri, 10 Jan 2020 17:07:19 -0500
Message-Id: <20200110220721.28780-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200110220721.28780-1-sashal@kernel.org>
References: <20200110220721.28780-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Desaulniers <ndesaulniers@google.com>

[ Upstream commit 780a0cfda9006a9a22d6473c2d4c527f5c68eb2e ]

Hexagon requires that register predicates in assembly be parenthesized.

Link: https://github.com/ClangBuiltLinux/linux/issues/754
Link: http://lkml.kernel.org/r/20191209222956.239798-3-ndesaulniers@google.com
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Suggested-by: Sid Manning <sidneym@codeaurora.org>
Acked-by: Brian Cain <bcain@codeaurora.org>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Tuowen Zhao <ztuowen@gmail.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexios Zavras <alexios.zavras@intel.com>
Cc: Allison Randal <allison@lohutok.net>
Cc: Will Deacon <will@kernel.org>
Cc: Richard Fontana <rfontana@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/hexagon/include/asm/atomic.h   |  8 ++++----
 arch/hexagon/include/asm/bitops.h   |  8 ++++----
 arch/hexagon/include/asm/cmpxchg.h  |  2 +-
 arch/hexagon/include/asm/futex.h    |  6 +++---
 arch/hexagon/include/asm/spinlock.h | 20 ++++++++++----------
 arch/hexagon/kernel/vm_entry.S      |  2 +-
 6 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/arch/hexagon/include/asm/atomic.h b/arch/hexagon/include/asm/atomic.h
index a62ba368b27d..1ae06190b68f 100644
--- a/arch/hexagon/include/asm/atomic.h
+++ b/arch/hexagon/include/asm/atomic.h
@@ -103,7 +103,7 @@ static inline void atomic_##op(int i, atomic_t *v)			\
 		"1:	%0 = memw_locked(%1);\n"			\
 		"	%0 = "#op "(%0,%2);\n"				\
 		"	memw_locked(%1,P3)=%0;\n"			\
-		"	if !P3 jump 1b;\n"				\
+		"	if (!P3) jump 1b;\n"				\
 		: "=&r" (output)					\
 		: "r" (&v->counter), "r" (i)				\
 		: "memory", "p3"					\
@@ -119,7 +119,7 @@ static inline int atomic_##op##_return(int i, atomic_t *v)		\
 		"1:	%0 = memw_locked(%1);\n"			\
 		"	%0 = "#op "(%0,%2);\n"				\
 		"	memw_locked(%1,P3)=%0;\n"			\
-		"	if !P3 jump 1b;\n"				\
+		"	if (!P3) jump 1b;\n"				\
 		: "=&r" (output)					\
 		: "r" (&v->counter), "r" (i)				\
 		: "memory", "p3"					\
@@ -136,7 +136,7 @@ static inline int atomic_fetch_##op(int i, atomic_t *v)			\
 		"1:	%0 = memw_locked(%2);\n"			\
 		"	%1 = "#op "(%0,%3);\n"				\
 		"	memw_locked(%2,P3)=%1;\n"			\
-		"	if !P3 jump 1b;\n"				\
+		"	if (!P3) jump 1b;\n"				\
 		: "=&r" (output), "=&r" (val)				\
 		: "r" (&v->counter), "r" (i)				\
 		: "memory", "p3"					\
@@ -185,7 +185,7 @@ static inline int __atomic_add_unless(atomic_t *v, int a, int u)
 		"	}"
 		"	memw_locked(%2, p3) = %1;"
 		"	{"
-		"		if !p3 jump 1b;"
+		"		if (!p3) jump 1b;"
 		"	}"
 		"2:"
 		: "=&r" (__oldval), "=&r" (tmp)
diff --git a/arch/hexagon/include/asm/bitops.h b/arch/hexagon/include/asm/bitops.h
index 2691a1857d20..634306cda006 100644
--- a/arch/hexagon/include/asm/bitops.h
+++ b/arch/hexagon/include/asm/bitops.h
@@ -52,7 +52,7 @@ static inline int test_and_clear_bit(int nr, volatile void *addr)
 	"1:	R12 = memw_locked(R10);\n"
 	"	{ P0 = tstbit(R12,R11); R12 = clrbit(R12,R11); }\n"
 	"	memw_locked(R10,P1) = R12;\n"
-	"	{if !P1 jump 1b; %0 = mux(P0,#1,#0);}\n"
+	"	{if (!P1) jump 1b; %0 = mux(P0,#1,#0);}\n"
 	: "=&r" (oldval)
 	: "r" (addr), "r" (nr)
 	: "r10", "r11", "r12", "p0", "p1", "memory"
@@ -76,7 +76,7 @@ static inline int test_and_set_bit(int nr, volatile void *addr)
 	"1:	R12 = memw_locked(R10);\n"
 	"	{ P0 = tstbit(R12,R11); R12 = setbit(R12,R11); }\n"
 	"	memw_locked(R10,P1) = R12;\n"
-	"	{if !P1 jump 1b; %0 = mux(P0,#1,#0);}\n"
+	"	{if (!P1) jump 1b; %0 = mux(P0,#1,#0);}\n"
 	: "=&r" (oldval)
 	: "r" (addr), "r" (nr)
 	: "r10", "r11", "r12", "p0", "p1", "memory"
@@ -102,7 +102,7 @@ static inline int test_and_change_bit(int nr, volatile void *addr)
 	"1:	R12 = memw_locked(R10);\n"
 	"	{ P0 = tstbit(R12,R11); R12 = togglebit(R12,R11); }\n"
 	"	memw_locked(R10,P1) = R12;\n"
-	"	{if !P1 jump 1b; %0 = mux(P0,#1,#0);}\n"
+	"	{if (!P1) jump 1b; %0 = mux(P0,#1,#0);}\n"
 	: "=&r" (oldval)
 	: "r" (addr), "r" (nr)
 	: "r10", "r11", "r12", "p0", "p1", "memory"
@@ -237,7 +237,7 @@ static inline int ffs(int x)
 	int r;
 
 	asm("{ P0 = cmp.eq(%1,#0); %0 = ct0(%1);}\n"
-		"{ if P0 %0 = #0; if !P0 %0 = add(%0,#1);}\n"
+		"{ if (P0) %0 = #0; if (!P0) %0 = add(%0,#1);}\n"
 		: "=&r" (r)
 		: "r" (x)
 		: "p0");
diff --git a/arch/hexagon/include/asm/cmpxchg.h b/arch/hexagon/include/asm/cmpxchg.h
index a6e34e2acbba..db258424059f 100644
--- a/arch/hexagon/include/asm/cmpxchg.h
+++ b/arch/hexagon/include/asm/cmpxchg.h
@@ -44,7 +44,7 @@ static inline unsigned long __xchg(unsigned long x, volatile void *ptr,
 	__asm__ __volatile__ (
 	"1:	%0 = memw_locked(%1);\n"    /*  load into retval */
 	"	memw_locked(%1,P0) = %2;\n" /*  store into memory */
-	"	if !P0 jump 1b;\n"
+	"	if (!P0) jump 1b;\n"
 	: "=&r" (retval)
 	: "r" (ptr), "r" (x)
 	: "memory", "p0"
diff --git a/arch/hexagon/include/asm/futex.h b/arch/hexagon/include/asm/futex.h
index c607b77c8215..12bd92f3ea41 100644
--- a/arch/hexagon/include/asm/futex.h
+++ b/arch/hexagon/include/asm/futex.h
@@ -15,7 +15,7 @@
 	    /* For example: %1 = %4 */ \
 	    insn \
 	"2: memw_locked(%3,p2) = %1;\n" \
-	"   if !p2 jump 1b;\n" \
+	"   if (!p2) jump 1b;\n" \
 	"   %1 = #0;\n" \
 	"3:\n" \
 	".section .fixup,\"ax\"\n" \
@@ -83,10 +83,10 @@ futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr, u32 oldval,
 	"1: %1 = memw_locked(%3)\n"
 	"   {\n"
 	"      p2 = cmp.eq(%1,%4)\n"
-	"      if !p2.new jump:NT 3f\n"
+	"      if (!p2.new) jump:NT 3f\n"
 	"   }\n"
 	"2: memw_locked(%3,p2) = %5\n"
-	"   if !p2 jump 1b\n"
+	"   if (!p2) jump 1b\n"
 	"3:\n"
 	".section .fixup,\"ax\"\n"
 	"4: %0 = #%6\n"
diff --git a/arch/hexagon/include/asm/spinlock.h b/arch/hexagon/include/asm/spinlock.h
index a1c55788c5d6..f61bb3185305 100644
--- a/arch/hexagon/include/asm/spinlock.h
+++ b/arch/hexagon/include/asm/spinlock.h
@@ -44,9 +44,9 @@ static inline void arch_read_lock(arch_rwlock_t *lock)
 	__asm__ __volatile__(
 		"1:	R6 = memw_locked(%0);\n"
 		"	{ P3 = cmp.ge(R6,#0); R6 = add(R6,#1);}\n"
-		"	{ if !P3 jump 1b; }\n"
+		"	{ if (!P3) jump 1b; }\n"
 		"	memw_locked(%0,P3) = R6;\n"
-		"	{ if !P3 jump 1b; }\n"
+		"	{ if (!P3) jump 1b; }\n"
 		:
 		: "r" (&lock->lock)
 		: "memory", "r6", "p3"
@@ -60,7 +60,7 @@ static inline void arch_read_unlock(arch_rwlock_t *lock)
 		"1:	R6 = memw_locked(%0);\n"
 		"	R6 = add(R6,#-1);\n"
 		"	memw_locked(%0,P3) = R6\n"
-		"	if !P3 jump 1b;\n"
+		"	if (!P3) jump 1b;\n"
 		:
 		: "r" (&lock->lock)
 		: "memory", "r6", "p3"
@@ -75,7 +75,7 @@ static inline int arch_read_trylock(arch_rwlock_t *lock)
 	__asm__ __volatile__(
 		"	R6 = memw_locked(%1);\n"
 		"	{ %0 = #0; P3 = cmp.ge(R6,#0); R6 = add(R6,#1);}\n"
-		"	{ if !P3 jump 1f; }\n"
+		"	{ if (!P3) jump 1f; }\n"
 		"	memw_locked(%1,P3) = R6;\n"
 		"	{ %0 = P3 }\n"
 		"1:\n"
@@ -102,9 +102,9 @@ static inline void arch_write_lock(arch_rwlock_t *lock)
 	__asm__ __volatile__(
 		"1:	R6 = memw_locked(%0)\n"
 		"	{ P3 = cmp.eq(R6,#0);  R6 = #-1;}\n"
-		"	{ if !P3 jump 1b; }\n"
+		"	{ if (!P3) jump 1b; }\n"
 		"	memw_locked(%0,P3) = R6;\n"
-		"	{ if !P3 jump 1b; }\n"
+		"	{ if (!P3) jump 1b; }\n"
 		:
 		: "r" (&lock->lock)
 		: "memory", "r6", "p3"
@@ -118,7 +118,7 @@ static inline int arch_write_trylock(arch_rwlock_t *lock)
 	__asm__ __volatile__(
 		"	R6 = memw_locked(%1)\n"
 		"	{ %0 = #0; P3 = cmp.eq(R6,#0);  R6 = #-1;}\n"
-		"	{ if !P3 jump 1f; }\n"
+		"	{ if (!P3) jump 1f; }\n"
 		"	memw_locked(%1,P3) = R6;\n"
 		"	%0 = P3;\n"
 		"1:\n"
@@ -141,9 +141,9 @@ static inline void arch_spin_lock(arch_spinlock_t *lock)
 	__asm__ __volatile__(
 		"1:	R6 = memw_locked(%0);\n"
 		"	P3 = cmp.eq(R6,#0);\n"
-		"	{ if !P3 jump 1b; R6 = #1; }\n"
+		"	{ if (!P3) jump 1b; R6 = #1; }\n"
 		"	memw_locked(%0,P3) = R6;\n"
-		"	{ if !P3 jump 1b; }\n"
+		"	{ if (!P3) jump 1b; }\n"
 		:
 		: "r" (&lock->lock)
 		: "memory", "r6", "p3"
@@ -163,7 +163,7 @@ static inline unsigned int arch_spin_trylock(arch_spinlock_t *lock)
 	__asm__ __volatile__(
 		"	R6 = memw_locked(%1);\n"
 		"	P3 = cmp.eq(R6,#0);\n"
-		"	{ if !P3 jump 1f; R6 = #1; %0 = #0; }\n"
+		"	{ if (!P3) jump 1f; R6 = #1; %0 = #0; }\n"
 		"	memw_locked(%1,P3) = R6;\n"
 		"	%0 = P3;\n"
 		"1:\n"
diff --git a/arch/hexagon/kernel/vm_entry.S b/arch/hexagon/kernel/vm_entry.S
index 67c6ccc14770..9f4a73ff7203 100644
--- a/arch/hexagon/kernel/vm_entry.S
+++ b/arch/hexagon/kernel/vm_entry.S
@@ -382,7 +382,7 @@ ret_from_fork:
 		R26.L = #LO(do_work_pending);
 		R0 = #VM_INT_DISABLE;
 	}
-	if P0 jump check_work_pending
+	if (P0) jump check_work_pending
 	{
 		R0 = R25;
 		callr R24
-- 
2.20.1


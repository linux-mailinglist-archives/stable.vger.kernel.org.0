Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD04D13FE3E
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391582AbgAPXdb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:33:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:43980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404367AbgAPXdb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:33:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACD9120684;
        Thu, 16 Jan 2020 23:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217610;
        bh=LpHopoKz/bbwRlgRC6AOrj9CzyQdGyVQ010QDbvc1kk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WjuA42/D33gaq5dLdVGu3q2Q3fPoq8zmZ97B9oRvn8DaCvOJ4R7T3jks5jiS/TFe2
         HQyQI9wD0mc2h2s1R4TxPspwaLpAMmX5WShrviBASf8jNCYJoly+cL9syhveq9U8GP
         hdqpO6+Txzos22NjhguDmg720XxK/h08i11HlSdE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        Sid Manning <sidneym@codeaurora.org>,
        Brian Cain <bcain@codeaurora.org>,
        Lee Jones <lee.jones@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Tuowen Zhao <ztuowen@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
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
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 69/71] hexagon: parenthesize registers in asm predicates
Date:   Fri, 17 Jan 2020 00:19:07 +0100
Message-Id: <20200116231718.920161728@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231709.377772748@linuxfoundation.org>
References: <20200116231709.377772748@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index fb3dfb2a667e..d4e283b4f335 100644
--- a/arch/hexagon/include/asm/atomic.h
+++ b/arch/hexagon/include/asm/atomic.h
@@ -105,7 +105,7 @@ static inline void atomic_##op(int i, atomic_t *v)			\
 		"1:	%0 = memw_locked(%1);\n"			\
 		"	%0 = "#op "(%0,%2);\n"				\
 		"	memw_locked(%1,P3)=%0;\n"			\
-		"	if !P3 jump 1b;\n"				\
+		"	if (!P3) jump 1b;\n"				\
 		: "=&r" (output)					\
 		: "r" (&v->counter), "r" (i)				\
 		: "memory", "p3"					\
@@ -121,7 +121,7 @@ static inline int atomic_##op##_return(int i, atomic_t *v)		\
 		"1:	%0 = memw_locked(%1);\n"			\
 		"	%0 = "#op "(%0,%2);\n"				\
 		"	memw_locked(%1,P3)=%0;\n"			\
-		"	if !P3 jump 1b;\n"				\
+		"	if (!P3) jump 1b;\n"				\
 		: "=&r" (output)					\
 		: "r" (&v->counter), "r" (i)				\
 		: "memory", "p3"					\
@@ -138,7 +138,7 @@ static inline int atomic_fetch_##op(int i, atomic_t *v)			\
 		"1:	%0 = memw_locked(%2);\n"			\
 		"	%1 = "#op "(%0,%3);\n"				\
 		"	memw_locked(%2,P3)=%1;\n"			\
-		"	if !P3 jump 1b;\n"				\
+		"	if (!P3) jump 1b;\n"				\
 		: "=&r" (output), "=&r" (val)				\
 		: "r" (&v->counter), "r" (i)				\
 		: "memory", "p3"					\
@@ -187,7 +187,7 @@ static inline int __atomic_add_unless(atomic_t *v, int a, int u)
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
index c889f5993ecd..e8e5e47afb37 100644
--- a/arch/hexagon/include/asm/futex.h
+++ b/arch/hexagon/include/asm/futex.h
@@ -16,7 +16,7 @@
 	    /* For example: %1 = %4 */ \
 	    insn \
 	"2: memw_locked(%3,p2) = %1;\n" \
-	"   if !p2 jump 1b;\n" \
+	"   if (!p2) jump 1b;\n" \
 	"   %1 = #0;\n" \
 	"3:\n" \
 	".section .fixup,\"ax\"\n" \
@@ -84,10 +84,10 @@ futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr, u32 oldval,
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
index 53a8d5885887..007056263b8e 100644
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




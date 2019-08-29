Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED56A18B4
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 13:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbfH2LfB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 07:35:01 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41700 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbfH2LfB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 07:35:01 -0400
Received: by mail-pf1-f195.google.com with SMTP id 196so1855157pfz.8
        for <stable@vger.kernel.org>; Thu, 29 Aug 2019 04:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ES6KJwQvdOYp/ZF0zdgUUsDi+h2pkDI/v1RQA0OQPVY=;
        b=N8ypWh9bUBCQg5Qrp3UqxAwWng+Qg3fzHmDGkcGYs3MmNmm2g40ZfbG6LcePKVNtcN
         2SqhleEP3CF+UMjT+Q8lIsUUb04onlh1FnqC+rOlnICQ5SY72w9ZTRSz+Ssvc6ocLrB2
         t7UZ9Ici3AH5doJc+q+SWI6Mpno9SBbcmKo/oYyy9Dub9FpEdk6mbwwKHfmKfAC8GCOR
         P/hlqL30UkbzV3NZhDtedPQ8hNugxum8f6BjdZDwMHsIboa30nvtGlJICaeHXjA1rqLp
         E6UpmqFPrUEn3Muc2TJPfcw7aGy3xgrPS0UMR6jaUZNekPVxRXqeM1jxxTZMs/IAvZ9O
         +g5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ES6KJwQvdOYp/ZF0zdgUUsDi+h2pkDI/v1RQA0OQPVY=;
        b=c4htNs0lT/jwzjnbqoXGSoTsjpeIRv/u4FuAQk/bfbTWj+i3n1EmXaC/+23AKFp4e2
         /iz+JpLZqLfnoS8GeoHLlvNCY5cvy34MscAXv+Xwt4ILfp2ndyxDnw1s2w+wsC2Rw8GC
         1GudU+BcrZdzPuBU9Q70pQJ6e/HM0YiClcZioQ3y7ou7DrM5Y7Z/3TJD029VNyQp/WDe
         D5lN3kH2RMEsx/figpZXtjcJsZpxnO8v+PuKvzbduj7YJiaV3LIt+Th+IV2qxzwR69Xq
         CjqRK7jACdnUhr7gVqya0UxFvKFSp8dCwNcVzypIB2yaDPI6f55B2EBCPHRUA6/LN8rI
         m5NA==
X-Gm-Message-State: APjAAAUmn7byfQhkh7pSHT/vl2SJYv4FXj/JzxEWWlUoWLYcCKb7Z+E2
        M0NaA9SFAss+17b3eQ6hXob+8h/mh1E=
X-Google-Smtp-Source: APXvYqxr33ZzfzDwQVSTt96WoT+YgW+FF6uN6OiW9GTsMKP0VTDzy6Vho/bY8M4uoVrl+6Phw5Lq0Q==
X-Received: by 2002:a63:9e56:: with SMTP id r22mr7890169pgo.221.1567078500171;
        Thu, 29 Aug 2019 04:35:00 -0700 (PDT)
Received: from localhost ([122.167.132.221])
        by smtp.gmail.com with ESMTPSA id p2sm5205020pfb.122.2019.08.29.04.34.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 04:34:59 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org, Julien Thierry <Julien.Thierry@arm.com>,
        Mark Rutland <mark.rutland@arm.com>
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
Subject: [PATCH ARM64 v4.4 V3 03/44] arm64: move TASK_* definitions to <asm/processor.h>
Date:   Thu, 29 Aug 2019 17:03:48 +0530
Message-Id: <687d13717c9736bc33b9128bd09371fc0453fbdd.1567077734.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1567077734.git.viresh.kumar@linaro.org>
References: <cover.1567077734.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yury Norov <ynorov@caviumnetworks.com>

commit eef94a3d09aab437c8c254de942d8b1aa76455e2 upstream.

ILP32 series [1] introduces the dependency on <asm/is_compat.h> for
TASK_SIZE macro. Which in turn requires <asm/thread_info.h>, and
<asm/thread_info.h> include <asm/memory.h>, giving a circular dependency,
because TASK_SIZE is currently located in <asm/memory.h>.

In other architectures, TASK_SIZE is defined in <asm/processor.h>, and
moving TASK_SIZE there fixes the problem.

Discussion: https://patchwork.kernel.org/patch/9929107/

[1] https://github.com/norov/linux/tree/ilp32-next

CC: Will Deacon <will.deacon@arm.com>
CC: Laura Abbott <labbott@redhat.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Morse <james.morse@arm.com>
Suggested-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Yury Norov <ynorov@caviumnetworks.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm64/include/asm/memory.h    | 15 ---------------
 arch/arm64/include/asm/processor.h | 21 +++++++++++++++++++++
 arch/arm64/kernel/entry.S          |  2 +-
 3 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index b42b930cc19a..959a1e9188fe 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -43,8 +43,6 @@
  *		 (VA_BITS - 1))
  * VA_BITS - the maximum number of bits for virtual addresses.
  * VA_START - the first kernel virtual address.
- * TASK_SIZE - the maximum size of a user space task.
- * TASK_UNMAPPED_BASE - the lower boundary of the mmap VM area.
  * The module space lives between the addresses given by TASK_SIZE
  * and PAGE_OFFSET - it must be within 128MB of the kernel text.
  */
@@ -58,19 +56,6 @@
 #define PCI_IO_END		(MODULES_VADDR - SZ_2M)
 #define PCI_IO_START		(PCI_IO_END - PCI_IO_SIZE)
 #define FIXADDR_TOP		(PCI_IO_START - SZ_2M)
-#define TASK_SIZE_64		(UL(1) << VA_BITS)
-
-#ifdef CONFIG_COMPAT
-#define TASK_SIZE_32		UL(0x100000000)
-#define TASK_SIZE		(test_thread_flag(TIF_32BIT) ? \
-				TASK_SIZE_32 : TASK_SIZE_64)
-#define TASK_SIZE_OF(tsk)	(test_tsk_thread_flag(tsk, TIF_32BIT) ? \
-				TASK_SIZE_32 : TASK_SIZE_64)
-#else
-#define TASK_SIZE		TASK_SIZE_64
-#endif /* CONFIG_COMPAT */
-
-#define TASK_UNMAPPED_BASE	(PAGE_ALIGN(TASK_SIZE / 4))
 
 /*
  * Physical vs virtual RAM address space conversion.  These are
diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index d08559528927..75d9ef6c457c 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -19,6 +19,10 @@
 #ifndef __ASM_PROCESSOR_H
 #define __ASM_PROCESSOR_H
 
+#define TASK_SIZE_64		(UL(1) << VA_BITS)
+
+#ifndef __ASSEMBLY__
+
 /*
  * Default implementation of macro that returns current
  * instruction pointer ("program counter").
@@ -36,6 +40,22 @@
 #include <asm/types.h>
 
 #ifdef __KERNEL__
+/*
+ * TASK_SIZE - the maximum size of a user space task.
+ * TASK_UNMAPPED_BASE - the lower boundary of the mmap VM area.
+ */
+#ifdef CONFIG_COMPAT
+#define TASK_SIZE_32		UL(0x100000000)
+#define TASK_SIZE		(test_thread_flag(TIF_32BIT) ? \
+				TASK_SIZE_32 : TASK_SIZE_64)
+#define TASK_SIZE_OF(tsk)	(test_tsk_thread_flag(tsk, TIF_32BIT) ? \
+				TASK_SIZE_32 : TASK_SIZE_64)
+#else
+#define TASK_SIZE		TASK_SIZE_64
+#endif /* CONFIG_COMPAT */
+
+#define TASK_UNMAPPED_BASE	(PAGE_ALIGN(TASK_SIZE / 4))
+
 #define STACK_TOP_MAX		TASK_SIZE_64
 #ifdef CONFIG_COMPAT
 #define AARCH32_VECTORS_BASE	0xffff0000
@@ -188,4 +208,5 @@ static inline void spin_lock_prefetch(const void *x)
 
 int cpu_enable_pan(void *__unused);
 
+#endif /* __ASSEMBLY__ */
 #endif /* __ASM_PROCESSOR_H */
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 586326981769..c849be9231bb 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -27,7 +27,7 @@
 #include <asm/cpufeature.h>
 #include <asm/errno.h>
 #include <asm/esr.h>
-#include <asm/memory.h>
+#include <asm/processor.h>
 #include <asm/thread_info.h>
 #include <asm/asm-uaccess.h>
 #include <asm/unistd.h>
-- 
2.21.0.rc0.269.g1a574e7a288b


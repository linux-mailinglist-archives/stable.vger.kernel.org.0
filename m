Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC8A517B51
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 02:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbiECA42 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 May 2022 20:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiECA42 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 May 2022 20:56:28 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 842D8366BA;
        Mon,  2 May 2022 17:52:54 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id j8so13750904pll.11;
        Mon, 02 May 2022 17:52:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hnww5jPhyaEAX5g2GtQoqlyUaT1dU8vWzF8Ey92TbW8=;
        b=jvvdzac5DSmYSRqZj9T346PreWZSg98z1SOksSTOj3JqhSGgajdb5W3CUBIkb8STsO
         S+vvHjQTrY7qXeSiaDtUWSSSxmeM0esOKCR7Q2U1nmqnEHpgdq8OpStimgNmIxEXOYD9
         NKav5cPms5CDNpuL+2wDZ0fGPRCWGhVz3ZuDbNbIOBlD1vTbeWCP1lFHnoyPPxzDYX7x
         15tXq29kbE+iHjGHz5nSqC8FTOY8kg6rfDoo36ti0XEjEZxCN25y4XKC8XBJXJOhL0y9
         njYldyMIz2u2SPhEcpD2vQcdafateg9OwlSQD2QmY7g73BNwFQUqb4Vb5HyWuRwNoJzM
         aTug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=hnww5jPhyaEAX5g2GtQoqlyUaT1dU8vWzF8Ey92TbW8=;
        b=GKBSC91R55zusFbeQhFA/88LeZgu8CUvB0EjSZLRd8+uK+alE/m0fGhQ2CRSIEebNx
         WXuPMkgAk152J0MUwkJARo4Truyk8HuBL3zwojquP0726uxvbjEApVfcetqV02G7hgEl
         scYdnmcRTf8evCvHIw/xgtqGprSVeAsqGhoma7Gx/roMwTtS5pmkcLoiTUhXic0mwBWK
         edJ+fA2Q5y4RDqWYiWHIm8QzNe8/tph7PxmpuiwrY2z83IK8tKyRRT1PCbpb4Tlya554
         XexzyvKsU6xt0hPwaKBcrDemixdEJr9XYv5kj2MbNf/Nd27CLizH+tL/afjiHyGvaOC/
         sMgA==
X-Gm-Message-State: AOAM532R7KVMWLsbypEKjlzHpRaW0YpXjI0dfxYHler3tjU+UvfkYEgh
        0v/5r8Vj82XUBQbaml3xr7wWiryIzYg=
X-Google-Smtp-Source: ABdhPJzQ4Q6h/bQpS2ogARRfyE8TLnNsToYhMDGjvx76e3UDbQpwIYSvJkOqn1z9T4BUqnmuQmkqOA==
X-Received: by 2002:a05:6a00:1707:b0:50e:23d:834f with SMTP id h7-20020a056a00170700b0050e023d834fmr3203581pfc.82.1651538258712;
        Mon, 02 May 2022 17:37:38 -0700 (PDT)
Received: from balhae.hsd1.ca.comcast.net ([2601:647:4f00:3590:4f92:5746:ebb:6bda])
        by smtp.gmail.com with ESMTPSA id v9-20020aa78089000000b0050dc76281a1sm5246417pff.123.2022.05.02.17.37.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 17:37:37 -0700 (PDT)
Sender: Namhyung Kim <namhyung@gmail.com>
From:   Namhyung Kim <namhyung@kernel.org>
To:     stable@vger.kernel.org
Cc:     Ian Rogers <irogers@google.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        John Garry <john.garry@huawei.com>,
        Leo Yan <leo.yan@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michael Petlan <mpetlan@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Will Deacon <will@kernel.org>, linux-s390@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH for v5.15] perf symbol: Remove arch__symbols__fixup_end()
Date:   Mon,  2 May 2022 17:37:36 -0700
Message-Id: <20220503003736.711789-1-namhyung@kernel.org>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Now the generic code can handle kallsyms fixup properly so no need to
keep the arch-functions anymore.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Ian Rogers <irogers@google.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Garry <john.garry@huawei.com>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michael Petlan <mpetlan@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Will Deacon <will@kernel.org>
Cc: linux-s390@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Link: https://lore.kernel.org/r/20220416004048.1514900-4-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
The original commit id is a5d20d42a2f2dc2b2f9e9361912062732414090d

 tools/perf/arch/arm64/util/Build       |  1 -
 tools/perf/arch/arm64/util/machine.c   | 28 --------------------------
 tools/perf/arch/powerpc/util/Build     |  1 -
 tools/perf/arch/powerpc/util/machine.c | 25 -----------------------
 tools/perf/arch/s390/util/machine.c    | 16 ---------------
 tools/perf/util/symbol.c               |  5 -----
 tools/perf/util/symbol.h               |  1 -
 7 files changed, 77 deletions(-)
 delete mode 100644 tools/perf/arch/arm64/util/machine.c
 delete mode 100644 tools/perf/arch/powerpc/util/machine.c

diff --git a/tools/perf/arch/arm64/util/Build b/tools/perf/arch/arm64/util/Build
index 9fcb4e68add9..78dfc282e5e2 100644
--- a/tools/perf/arch/arm64/util/Build
+++ b/tools/perf/arch/arm64/util/Build
@@ -1,5 +1,4 @@
 perf-y += header.o
-perf-y += machine.o
 perf-y += perf_regs.o
 perf-y += tsc.o
 perf-y += pmu.o
diff --git a/tools/perf/arch/arm64/util/machine.c b/tools/perf/arch/arm64/util/machine.c
deleted file mode 100644
index 7e7714290a87..000000000000
--- a/tools/perf/arch/arm64/util/machine.c
+++ /dev/null
@@ -1,28 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-
-#include <inttypes.h>
-#include <stdio.h>
-#include <string.h>
-#include "debug.h"
-#include "symbol.h"
-
-/* On arm64, kernel text segment starts at high memory address,
- * for example 0xffff 0000 8xxx xxxx. Modules start at a low memory
- * address, like 0xffff 0000 00ax xxxx. When only small amount of
- * memory is used by modules, gap between end of module's text segment
- * and start of kernel text segment may reach 2G.
- * Therefore do not fill this gap and do not assign it to the kernel dso map.
- */
-
-#define SYMBOL_LIMIT (1 << 12) /* 4K */
-
-void arch__symbols__fixup_end(struct symbol *p, struct symbol *c)
-{
-	if ((strchr(p->name, '[') && strchr(c->name, '[') == NULL) ||
-			(strchr(p->name, '[') == NULL && strchr(c->name, '[')))
-		/* Limit range of last symbol in module and kernel */
-		p->end += SYMBOL_LIMIT;
-	else
-		p->end = c->start;
-	pr_debug4("%s sym:%s end:%#" PRIx64 "\n", __func__, p->name, p->end);
-}
diff --git a/tools/perf/arch/powerpc/util/Build b/tools/perf/arch/powerpc/util/Build
index 8a79c4126e5b..0115f3166568 100644
--- a/tools/perf/arch/powerpc/util/Build
+++ b/tools/perf/arch/powerpc/util/Build
@@ -1,5 +1,4 @@
 perf-y += header.o
-perf-y += machine.o
 perf-y += kvm-stat.o
 perf-y += perf_regs.o
 perf-y += mem-events.o
diff --git a/tools/perf/arch/powerpc/util/machine.c b/tools/perf/arch/powerpc/util/machine.c
deleted file mode 100644
index e652a1aa8132..000000000000
--- a/tools/perf/arch/powerpc/util/machine.c
+++ /dev/null
@@ -1,25 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-
-#include <inttypes.h>
-#include <stdio.h>
-#include <string.h>
-#include <internal/lib.h> // page_size
-#include "debug.h"
-#include "symbol.h"
-
-/* On powerpc kernel text segment start at memory addresses, 0xc000000000000000
- * whereas the modules are located at very high memory addresses,
- * for example 0xc00800000xxxxxxx. The gap between end of kernel text segment
- * and beginning of first module's text segment is very high.
- * Therefore do not fill this gap and do not assign it to the kernel dso map.
- */
-
-void arch__symbols__fixup_end(struct symbol *p, struct symbol *c)
-{
-	if (strchr(p->name, '[') == NULL && strchr(c->name, '['))
-		/* Limit the range of last kernel symbol */
-		p->end += page_size;
-	else
-		p->end = c->start;
-	pr_debug4("%s sym:%s end:%#" PRIx64 "\n", __func__, p->name, p->end);
-}
diff --git a/tools/perf/arch/s390/util/machine.c b/tools/perf/arch/s390/util/machine.c
index 7644a4f6d4a4..98bc3f39d5f3 100644
--- a/tools/perf/arch/s390/util/machine.c
+++ b/tools/perf/arch/s390/util/machine.c
@@ -35,19 +35,3 @@ int arch__fix_module_text_start(u64 *start, u64 *size, const char *name)
 
 	return 0;
 }
-
-/* On s390 kernel text segment start is located at very low memory addresses,
- * for example 0x10000. Modules are located at very high memory addresses,
- * for example 0x3ff xxxx xxxx. The gap between end of kernel text segment
- * and beginning of first module's text segment is very big.
- * Therefore do not fill this gap and do not assign it to the kernel dso map.
- */
-void arch__symbols__fixup_end(struct symbol *p, struct symbol *c)
-{
-	if (strchr(p->name, '[') == NULL && strchr(c->name, '['))
-		/* Last kernel symbol mapped to end of page */
-		p->end = roundup(p->end, page_size);
-	else
-		p->end = c->start;
-	pr_debug4("%s sym:%s end:%#" PRIx64 "\n", __func__, p->name, p->end);
-}
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index a420caebd526..b1e5fd99e38a 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -101,11 +101,6 @@ static int prefix_underscores_count(const char *str)
 	return tail - str;
 }
 
-void __weak arch__symbols__fixup_end(struct symbol *p, struct symbol *c)
-{
-	p->end = c->start;
-}
-
 const char * __weak arch__normalize_symbol_name(const char *name)
 {
 	return name;
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 66d5b732bb7a..28721d761d91 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -230,7 +230,6 @@ const char *arch__normalize_symbol_name(const char *name);
 #define SYMBOL_A 0
 #define SYMBOL_B 1
 
-void arch__symbols__fixup_end(struct symbol *p, struct symbol *c);
 int arch__compare_symbol_names(const char *namea, const char *nameb);
 int arch__compare_symbol_names_n(const char *namea, const char *nameb,
 				 unsigned int n);
-- 
2.36.0.464.gb9c8b46e94-goog


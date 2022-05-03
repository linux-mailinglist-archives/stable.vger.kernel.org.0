Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7F76517B52
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 02:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbiECA5l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 May 2022 20:57:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiECA5k (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 May 2022 20:57:40 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91D9441FB4;
        Mon,  2 May 2022 17:54:06 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id e1so8890346ile.2;
        Mon, 02 May 2022 17:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=z6SbXsprQLOiqwaC6PZW9LYNv33UTf7Rzrgeep2Yrzw=;
        b=Tfr3MWYtyNj6k0jjfWdSkBf5DEtonztrmR7vYz0crnSoOXpnvPP+UxjlvU4CWZxNCk
         IczE0YCSTnOBGyNsnBSgY4uu+04H8ZKgFpGvgrb0yAxoaN0LKphArPpDoj+EjdJ/2caO
         fYCXFiMV3CgD+4Vd+yfDNnQKpqYFfR1eoia0y4IOoBE1p4oNCdv8RyHZ/AP7rJLbR8uN
         I3+4DN755uz5DDFXVZ4Eq6ZtUIliblbq31AVTpBz5hsrymUVL2hob361vbHSWu0iGJqA
         bgQxzDp0+XcltNZ5gkPZ5MywZEcxq7iiYl5yPFzF8GiREAXYCB6lypVp5p1r7fEdxBxL
         mjXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=z6SbXsprQLOiqwaC6PZW9LYNv33UTf7Rzrgeep2Yrzw=;
        b=XTvCZoeDANq0QcD64slDletI0MOqQE4GzQdQHm30ptR0KoSLbrR1nniJI5zwoxk7zN
         plpYIF4tDDcu3RIx+aLsWbmRdiLdAA5BFdvxkdPAVehZl1yQun/A+keKL7Z++Baw/3Qp
         lBPJnwB5nbL/kG5b4ublVklnUFafrId/q62k0GJFEEzKPVC2LxkaXUPf9tHNH+PjWMZO
         JExuIeIID+xXMxB0O4kFdo3BYo/BGSdYQ40xYB5jpFFhTigoniMjzNnoE46RMuge3Npo
         ySXxmy7hnU/+rt9F0v8J19oTP9j4lykp+odJAnH1wizHohxkHSS/BgS31e815nKkTd+k
         KzYw==
X-Gm-Message-State: AOAM532igOTGYNCl6jF/qWi3NlA10KH32rdZXuITrXgk/y8yKcDgj+nj
        D4crhfH6yGZ1XyUSF20SYQn8HJ1gl6w=
X-Google-Smtp-Source: ABdhPJznfXwUKn70bLgk2uXJZR9xIknHNS7cZLBfurSF8+hscprxf+Ex1WEXpOnlut38fMa44HtXgA==
X-Received: by 2002:a63:2309:0:b0:398:d3fe:1c41 with SMTP id j9-20020a632309000000b00398d3fe1c41mr11808733pgj.131.1651538559219;
        Mon, 02 May 2022 17:42:39 -0700 (PDT)
Received: from balhae.hsd1.ca.comcast.net ([2601:647:4f00:3590:4f92:5746:ebb:6bda])
        by smtp.gmail.com with ESMTPSA id e3-20020a170903240300b0015e8d4eb28fsm5193686plo.217.2022.05.02.17.42.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 17:42:38 -0700 (PDT)
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
Subject: [PATCH for v5.10] perf symbol: Remove arch__symbols__fixup_end()
Date:   Mon,  2 May 2022 17:42:36 -0700
Message-Id: <20220503004236.712241-1-namhyung@kernel.org>
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
 tools/perf/arch/arm64/util/Build     |  1 -
 tools/perf/arch/arm64/util/machine.c | 27 ---------------------------
 tools/perf/arch/s390/util/machine.c  | 16 ----------------
 tools/perf/util/symbol.c             |  5 -----
 tools/perf/util/symbol.h             |  1 -
 5 files changed, 50 deletions(-)
 delete mode 100644 tools/perf/arch/arm64/util/machine.c

diff --git a/tools/perf/arch/arm64/util/Build b/tools/perf/arch/arm64/util/Build
index b53294d74b01..eddaf9bf5729 100644
--- a/tools/perf/arch/arm64/util/Build
+++ b/tools/perf/arch/arm64/util/Build
@@ -1,5 +1,4 @@
 perf-y += header.o
-perf-y += machine.o
 perf-y += perf_regs.o
 perf-y += tsc.o
 perf-$(CONFIG_DWARF)     += dwarf-regs.o
diff --git a/tools/perf/arch/arm64/util/machine.c b/tools/perf/arch/arm64/util/machine.c
deleted file mode 100644
index d41b27e781d3..000000000000
--- a/tools/perf/arch/arm64/util/machine.c
+++ /dev/null
@@ -1,27 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-
-#include <stdio.h>
-#include <string.h>
-#include "debug.h"
-#include "symbol.h"
-
-/* On arm64, kernel text segment start at high memory address,
- * for example 0xffff 0000 8xxx xxxx. Modules start at a low memory
- * address, like 0xffff 0000 00ax xxxx. When only samll amount of
- * memory is used by modules, gap between end of module's text segment
- * and start of kernel text segment may be reach 2G.
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
-	pr_debug4("%s sym:%s end:%#lx\n", __func__, p->name, p->end);
-}
diff --git a/tools/perf/arch/s390/util/machine.c b/tools/perf/arch/s390/util/machine.c
index 724efb2d842d..7219ecdb8423 100644
--- a/tools/perf/arch/s390/util/machine.c
+++ b/tools/perf/arch/s390/util/machine.c
@@ -34,19 +34,3 @@ int arch__fix_module_text_start(u64 *start, u64 *size, const char *name)
 
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
-	pr_debug4("%s sym:%s end:%#lx\n", __func__, p->name, p->end);
-}
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 8f63cf8d0669..33954835c823 100644
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


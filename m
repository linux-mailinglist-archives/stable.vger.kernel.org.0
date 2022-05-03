Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9449517A63
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 01:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbiEBXIE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 May 2022 19:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230517AbiEBXIB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 May 2022 19:08:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96E782E6B9
        for <stable@vger.kernel.org>; Mon,  2 May 2022 16:04:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CBD3F6126B
        for <stable@vger.kernel.org>; Mon,  2 May 2022 23:04:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27A22C385AC;
        Mon,  2 May 2022 23:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651532669;
        bh=KA5WaiWna6rQ4lWJJizJojdw/i+uVSVev5falF3FZXk=;
        h=Subject:To:Cc:From:Date:From;
        b=BLXl459x+WvEdtf6qZzBHJzAWr7nr7+8wz+IjDXE2pbIOZpSORZtyd0sEHzxChacZ
         1BjWCmqpyFDkS/if4OHhzwUCvyzkInxMD/ak07w0drReVfiTr5zARpEMDZR/IwqGo6
         Pmzsf4tv3g2kS9fY1U5GNK6v8m6W7xGpw166WMJ4=
Subject: FAILED: patch "[PATCH] perf symbol: Remove arch__symbols__fixup_end()" failed to apply to 4.19-stable tree
To:     namhyung@kernel.org, acme@redhat.com, hca@linux.ibm.com,
        irogers@google.com, john.garry@huawei.com, jolsa@kernel.org,
        leo.yan@linaro.org, mark.rutland@arm.com,
        mathieu.poirier@linaro.org, mhiramat@kernel.org, mingo@kernel.org,
        mpe@ellerman.id.au, mpetlan@redhat.com, peterz@infradead.org,
        songliubraving@fb.com, will@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 May 2022 01:04:21 +0200
Message-ID: <1651532661145199@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a5d20d42a2f2dc2b2f9e9361912062732414090d Mon Sep 17 00:00:00 2001
From: Namhyung Kim <namhyung@kernel.org>
Date: Fri, 15 Apr 2022 17:40:48 -0700
Subject: [PATCH] perf symbol: Remove arch__symbols__fixup_end()

Now the generic code can handle kallsyms fixup properly so no need to
keep the arch-functions anymore.

Fixes: 3cf6a32f3f2a4594 ("perf symbols: Fix symbol size calculation condition")
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

diff --git a/tools/perf/arch/arm64/util/machine.c b/tools/perf/arch/arm64/util/machine.c
index d2ce31e28cd7..41c1596e5207 100644
--- a/tools/perf/arch/arm64/util/machine.c
+++ b/tools/perf/arch/arm64/util/machine.c
@@ -8,27 +8,6 @@
 #include "callchain.h"
 #include "record.h"
 
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
-
 void arch__add_leaf_frame_record_opts(struct record_opts *opts)
 {
 	opts->sample_user_regs |= sample_reg_masks[PERF_REG_ARM64_LR].mask;
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
index 623094e866fd..f72baf636724 100644
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
index 5fcdd1f94c56..0b893dcc8ea6 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -241,7 +241,6 @@ const char *arch__normalize_symbol_name(const char *name);
 #define SYMBOL_A 0
 #define SYMBOL_B 1
 
-void arch__symbols__fixup_end(struct symbol *p, struct symbol *c);
 int arch__compare_symbol_names(const char *namea, const char *nameb);
 int arch__compare_symbol_names_n(const char *namea, const char *nameb,
 				 unsigned int n);


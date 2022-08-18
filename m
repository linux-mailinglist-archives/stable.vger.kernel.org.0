Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DAF7598289
	for <lists+stable@lfdr.de>; Thu, 18 Aug 2022 13:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244404AbiHRLzC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Aug 2022 07:55:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244376AbiHRLy7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Aug 2022 07:54:59 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94BE280F51;
        Thu, 18 Aug 2022 04:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660823696; x=1692359696;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gQKfIYlO9P5cbeQgk2dCYXSSNGBpDfeCOBQCd2osiHk=;
  b=FzXV8MeSUkmMiubUrkihAcq4urmTjhfk++V3t8e4gBzONgUwkcNpDVWR
   DrWzLj2IlB700XocorTsDTJJOWNPFbbT4JTFHJDJLBLKsiU9ZAh3eDldK
   osZnjzdCfZn/dlytS42+hQ1FZsFUbI+VMJB7aM0j4zdZEqWnB6vSN3ibo
   vAWwkRi+2Lga5zH6eY00DRZN9YC+LIGiAlw9hmRCNBmANwuH+Ak2yeBnq
   n04snvK11IafozIcbyXT3Lo+3GDvQi2YptMpIPS65EI3nQ2ikR9XlWeWC
   WolqFyVHk6cyPoO4es78usIUQSUzJQRYR45e4NkoczyJ35Qv4NOd0SdLc
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10442"; a="292737006"
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="292737006"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 04:54:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="558500904"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga003.jf.intel.com with ESMTP; 18 Aug 2022 04:54:51 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 27IBsmft013911;
        Thu, 18 Aug 2022 12:54:50 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     linux-kernel@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        linux-kbuild@vger.kernel.org, live-patching@vger.kernel.org,
        lkp@intel.com, stable@vger.kernel.org,
        Alexander Lobakin <alexandr.lobakin@intel.com>
Subject: [RFC PATCH 2/3] [STUB] increase kallsyms length limit
Date:   Thu, 18 Aug 2022 13:53:05 +0200
Message-Id: <20220818115306.1109642-3-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220818115306.1109642-1-alexandr.lobakin@intel.com>
References: <20220818115306.1109642-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a stub just to make it work without including one more
series into this one, for the actual changes please look at the
Rust kallsyms prereqs[0].

[0] https://github.com/Rust-for-Linux/linux/commits/rust-next

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 include/linux/kallsyms.h | 2 +-
 kernel/livepatch/core.c  | 4 ++--
 scripts/kallsyms.c       | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
index ad39636e0c3f..bd10c436ea90 100644
--- a/include/linux/kallsyms.h
+++ b/include/linux/kallsyms.h
@@ -15,7 +15,7 @@
 
 #include <asm/sections.h>
 
-#define KSYM_NAME_LEN 128
+#define KSYM_NAME_LEN 256
 #define KSYM_SYMBOL_LEN (sizeof("%s+%#lx/%#lx [%s %s]") + \
 			(KSYM_NAME_LEN - 1) + \
 			2*(BITS_PER_LONG*3/10) + (MODULE_NAME_LEN - 1) + \
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index bc475e62279d..fd300fb26f64 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -213,7 +213,7 @@ static int klp_resolve_symbols(Elf_Shdr *sechdrs, const char *strtab,
 	 * we use the smallest/strictest upper bound possible (56, based on
 	 * the current definition of MODULE_NAME_LEN) to prevent overflows.
 	 */
-	BUILD_BUG_ON(MODULE_NAME_LEN < 56 || KSYM_NAME_LEN != 128);
+	BUILD_BUG_ON(MODULE_NAME_LEN < 56 || KSYM_NAME_LEN != 256);
 
 	relas = (Elf_Rela *) relasec->sh_addr;
 	/* For each rela in this klp relocation section */
@@ -227,7 +227,7 @@ static int klp_resolve_symbols(Elf_Shdr *sechdrs, const char *strtab,
 
 		/* Format: .klp.sym.sym_objname.sym_name,sympos */
 		cnt = sscanf(strtab + sym->st_name,
-			     ".klp.sym.%55[^.].%127[^,],%lu",
+			     ".klp.sym.%55[^.].%255[^,],%lu",
 			     sym_objname, sym_name, &sympos);
 		if (cnt != 3) {
 			pr_err("symbol %s has an incorrectly formatted name\n",
diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index f18e6dfc68c5..445c7fe0ccfe 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -27,7 +27,7 @@
 
 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof(arr[0]))
 
-#define KSYM_NAME_LEN		128
+#define KSYM_NAME_LEN		256
 
 struct sym_entry {
 	unsigned long long addr;
-- 
2.37.2


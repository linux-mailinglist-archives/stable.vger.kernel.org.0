Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B416E41A101
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 23:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237137AbhI0VEh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 17:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237164AbhI0VEg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Sep 2021 17:04:36 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F5EEC061575;
        Mon, 27 Sep 2021 14:02:58 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id nn5-20020a17090b38c500b0019af1c4b31fso1076225pjb.3;
        Mon, 27 Sep 2021 14:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bimQO4n91GwebqTeqal9550g27LpE/Hmqiy4705XVm8=;
        b=leftCfSzGzble1Fw22k7k0BxtNDwCre+nfH1jLOxJthT3lV4PJVeP4SgPPNRlejP1i
         Y0kZvHB/7NiSRtFCsNl5cpxnErMfEKFKpVMAkM+EuCaHaWNWI0aQlDRgo+bCgPDDjHWZ
         yik5wApUZKysDL4+7GVDFIILkpLPugcjU0y/nCh7FeuUhr9QFM9n14CyfV2bVF7GzXiB
         Fau8WJUBtlJI49fecaTfrrxtf6pyjdyEoSefBHTghmDFfjupl+HDENVo7FRuZtwGNFaN
         ffljU9/yypgLS0ncUiH63TFWM0T21qiK67cB75h3yiS0oBbFR6zFnwUVPfafWA6l4SC0
         dwMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bimQO4n91GwebqTeqal9550g27LpE/Hmqiy4705XVm8=;
        b=XxHhe1MzkoHaOQz6G4SPuDs3XBNy2WvTPt06mZ+O+hr2BlGlDJyZ7VFio8SjAO5379
         NcojeI2VEsdIhbtpxazuGx+2STQlzEZQ2IL+QIpXb3aGAYbucvABG+2jqZhMVUmBb7Ub
         286hnlN9G+o1fetZKCqmdFEQND9SNICwArZKNT0TuRKLNa6vgX4rqVy9h2Lqjyx3jJ44
         GzW9nyfsk6Zq4UV+qzCHd8XeLO7WU6Q/r1nXUGiWtlqSqYss+OFIPrYOm8OqbzsOAI1p
         G91XkB+gZzf5UU3fQYvmJXPz0FGlYt6Nxav43Poy0rWCK8PXecDoopuitwjC7EfJafnB
         dP9A==
X-Gm-Message-State: AOAM533XnmVppqG4PZg12yNCLa4vDw85Spm2FO59UzUj9XlkZs8x2x/P
        28zohvyD389pynTKw1uyJtEdo72UHVs=
X-Google-Smtp-Source: ABdhPJzhyYBq89rl8dvLFT5TgzzyHEwLCIIg+B/ypzqjVZXhwO9faPBbkvNrnUuE3DQxtIsUos30Eg==
X-Received: by 2002:a17:903:1cc:b0:13e:3a0f:b2ae with SMTP id e12-20020a17090301cc00b0013e3a0fb2aemr1768622plh.3.1632776577717;
        Mon, 27 Sep 2021 14:02:57 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y3sm310537pjg.7.2021.09.27.14.02.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 14:02:57 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Alex Sverdlin <alexander.sverdlin@nokia.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT)
Subject: [PATCH stable 4.19 v3 3/4] ARM: 9079/1: ftrace: Add MODULE_PLTS support
Date:   Mon, 27 Sep 2021 14:02:45 -0700
Message-Id: <20210927210246.3216892-4-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210927210246.3216892-1-f.fainelli@gmail.com>
References: <20210927210246.3216892-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Sverdlin <alexander.sverdlin@nokia.com>

commit 79f32b221b18c15a98507b101ef4beb52444cc6f upstream

Teach ftrace_make_call() and ftrace_make_nop() about PLTs.
Teach PLT code about FTRACE and all its callbacks.
Otherwise the following might happen:

------------[ cut here ]------------
WARNING: CPU: 14 PID: 2265 at .../arch/arm/kernel/insn.c:14 __arm_gen_branch+0x83/0x8c()
...
Hardware name: LSI Axxia AXM55XX
[<c0314a49>] (unwind_backtrace) from [<c03115e9>] (show_stack+0x11/0x14)
[<c03115e9>] (show_stack) from [<c0519f51>] (dump_stack+0x81/0xa8)
[<c0519f51>] (dump_stack) from [<c032185d>] (warn_slowpath_common+0x69/0x90)
[<c032185d>] (warn_slowpath_common) from [<c03218f3>] (warn_slowpath_null+0x17/0x1c)
[<c03218f3>] (warn_slowpath_null) from [<c03143cf>] (__arm_gen_branch+0x83/0x8c)
[<c03143cf>] (__arm_gen_branch) from [<c0314337>] (ftrace_make_nop+0xf/0x24)
[<c0314337>] (ftrace_make_nop) from [<c038ebcb>] (ftrace_process_locs+0x27b/0x3e8)
[<c038ebcb>] (ftrace_process_locs) from [<c0378d79>] (load_module+0x11e9/0x1a44)
[<c0378d79>] (load_module) from [<c037974d>] (SyS_finit_module+0x59/0x84)
[<c037974d>] (SyS_finit_module) from [<c030e981>] (ret_fast_syscall+0x1/0x18)
---[ end trace e1b64ced7a89adcc ]---
------------[ cut here ]------------
WARNING: CPU: 14 PID: 2265 at .../kernel/trace/ftrace.c:1979 ftrace_bug+0x1b1/0x234()
...
Hardware name: LSI Axxia AXM55XX
[<c0314a49>] (unwind_backtrace) from [<c03115e9>] (show_stack+0x11/0x14)
[<c03115e9>] (show_stack) from [<c0519f51>] (dump_stack+0x81/0xa8)
[<c0519f51>] (dump_stack) from [<c032185d>] (warn_slowpath_common+0x69/0x90)
[<c032185d>] (warn_slowpath_common) from [<c03218f3>] (warn_slowpath_null+0x17/0x1c)
[<c03218f3>] (warn_slowpath_null) from [<c038e87d>] (ftrace_bug+0x1b1/0x234)
[<c038e87d>] (ftrace_bug) from [<c038ebd5>] (ftrace_process_locs+0x285/0x3e8)
[<c038ebd5>] (ftrace_process_locs) from [<c0378d79>] (load_module+0x11e9/0x1a44)
[<c0378d79>] (load_module) from [<c037974d>] (SyS_finit_module+0x59/0x84)
[<c037974d>] (SyS_finit_module) from [<c030e981>] (ret_fast_syscall+0x1/0x18)
---[ end trace e1b64ced7a89adcd ]---
ftrace failed to modify [<e9ef7006>] 0xe9ef7006
actual: 02:f0:3b:fa
ftrace record flags: 0
(0) expected tramp: c0314265

[florian: resolved merge conflict with struct
dyn_arch_ftrace::old_mcount]

Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 arch/arm/include/asm/ftrace.h |  3 +++
 arch/arm/include/asm/module.h |  1 +
 arch/arm/kernel/ftrace.c      | 50 ++++++++++++++++++++++++++++-------
 arch/arm/kernel/module-plts.c | 44 +++++++++++++++++++++++++++---
 4 files changed, 84 insertions(+), 14 deletions(-)

diff --git a/arch/arm/include/asm/ftrace.h b/arch/arm/include/asm/ftrace.h
index 9e842ff41768..faeb6b1c0089 100644
--- a/arch/arm/include/asm/ftrace.h
+++ b/arch/arm/include/asm/ftrace.h
@@ -19,6 +19,9 @@ struct dyn_arch_ftrace {
 #ifdef CONFIG_OLD_MCOUNT
 	bool	old_mcount;
 #endif
+#ifdef CONFIG_ARM_MODULE_PLTS
+	struct module *mod;
+#endif
 };
 
 static inline unsigned long ftrace_call_adjust(unsigned long addr)
diff --git a/arch/arm/include/asm/module.h b/arch/arm/include/asm/module.h
index 56d4c97e578a..6b36656eed83 100644
--- a/arch/arm/include/asm/module.h
+++ b/arch/arm/include/asm/module.h
@@ -30,6 +30,7 @@ struct plt_entries {
 
 struct mod_plt_sec {
 	struct elf32_shdr	*plt;
+	struct plt_entries	*plt_ent;
 	int			plt_count;
 };
 
diff --git a/arch/arm/kernel/ftrace.c b/arch/arm/kernel/ftrace.c
index 05bf124ae324..51839250e49a 100644
--- a/arch/arm/kernel/ftrace.c
+++ b/arch/arm/kernel/ftrace.c
@@ -96,9 +96,10 @@ int ftrace_arch_code_modify_post_process(void)
 	return 0;
 }
 
-static unsigned long ftrace_call_replace(unsigned long pc, unsigned long addr)
+static unsigned long ftrace_call_replace(unsigned long pc, unsigned long addr,
+					 bool warn)
 {
-	return arm_gen_branch_link(pc, addr, true);
+	return arm_gen_branch_link(pc, addr, warn);
 }
 
 static int ftrace_modify_code(unsigned long pc, unsigned long old,
@@ -137,14 +138,14 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
 	int ret;
 
 	pc = (unsigned long)&ftrace_call;
-	new = ftrace_call_replace(pc, (unsigned long)func);
+	new = ftrace_call_replace(pc, (unsigned long)func, true);
 
 	ret = ftrace_modify_code(pc, 0, new, false);
 
 #ifdef CONFIG_DYNAMIC_FTRACE_WITH_REGS
 	if (!ret) {
 		pc = (unsigned long)&ftrace_regs_call;
-		new = ftrace_call_replace(pc, (unsigned long)func);
+		new = ftrace_call_replace(pc, (unsigned long)func, true);
 
 		ret = ftrace_modify_code(pc, 0, new, false);
 	}
@@ -153,7 +154,7 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
 #ifdef CONFIG_OLD_MCOUNT
 	if (!ret) {
 		pc = (unsigned long)&ftrace_call_old;
-		new = ftrace_call_replace(pc, (unsigned long)func);
+		new = ftrace_call_replace(pc, (unsigned long)func, true);
 
 		ret = ftrace_modify_code(pc, 0, new, false);
 	}
@@ -166,10 +167,22 @@ int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 {
 	unsigned long new, old;
 	unsigned long ip = rec->ip;
+	unsigned long aaddr = adjust_address(rec, addr);
+	struct module *mod = NULL;
+
+#ifdef CONFIG_ARM_MODULE_PLTS
+	mod = rec->arch.mod;
+#endif
 
 	old = ftrace_nop_replace(rec);
 
-	new = ftrace_call_replace(ip, adjust_address(rec, addr));
+	new = ftrace_call_replace(ip, aaddr, !mod);
+#ifdef CONFIG_ARM_MODULE_PLTS
+	if (!new && mod) {
+		aaddr = get_module_plt(mod, ip, aaddr);
+		new = ftrace_call_replace(ip, aaddr, true);
+	}
+#endif
 
 	return ftrace_modify_code(rec->ip, old, new, true);
 }
@@ -182,9 +195,9 @@ int ftrace_modify_call(struct dyn_ftrace *rec, unsigned long old_addr,
 	unsigned long new, old;
 	unsigned long ip = rec->ip;
 
-	old = ftrace_call_replace(ip, adjust_address(rec, old_addr));
+	old = ftrace_call_replace(ip, adjust_address(rec, old_addr), true);
 
-	new = ftrace_call_replace(ip, adjust_address(rec, addr));
+	new = ftrace_call_replace(ip, adjust_address(rec, addr), true);
 
 	return ftrace_modify_code(rec->ip, old, new, true);
 }
@@ -194,12 +207,29 @@ int ftrace_modify_call(struct dyn_ftrace *rec, unsigned long old_addr,
 int ftrace_make_nop(struct module *mod,
 		    struct dyn_ftrace *rec, unsigned long addr)
 {
+	unsigned long aaddr = adjust_address(rec, addr);
 	unsigned long ip = rec->ip;
 	unsigned long old;
 	unsigned long new;
 	int ret;
 
-	old = ftrace_call_replace(ip, adjust_address(rec, addr));
+#ifdef CONFIG_ARM_MODULE_PLTS
+	/* mod is only supplied during module loading */
+	if (!mod)
+		mod = rec->arch.mod;
+	else
+		rec->arch.mod = mod;
+#endif
+
+	old = ftrace_call_replace(ip, aaddr,
+				  !IS_ENABLED(CONFIG_ARM_MODULE_PLTS) || !mod);
+#ifdef CONFIG_ARM_MODULE_PLTS
+	if (!old && mod) {
+		aaddr = get_module_plt(mod, ip, aaddr);
+		old = ftrace_call_replace(ip, aaddr, true);
+	}
+#endif
+
 	new = ftrace_nop_replace(rec);
 	ret = ftrace_modify_code(ip, old, new, true);
 
@@ -207,7 +237,7 @@ int ftrace_make_nop(struct module *mod,
 	if (ret == -EINVAL && addr == MCOUNT_ADDR) {
 		rec->arch.old_mcount = true;
 
-		old = ftrace_call_replace(ip, adjust_address(rec, addr));
+		old = ftrace_call_replace(ip, adjust_address(rec, addr), true);
 		new = ftrace_nop_replace(rec);
 		ret = ftrace_modify_code(ip, old, new, true);
 	}
diff --git a/arch/arm/kernel/module-plts.c b/arch/arm/kernel/module-plts.c
index f272711c411f..6804a145be11 100644
--- a/arch/arm/kernel/module-plts.c
+++ b/arch/arm/kernel/module-plts.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/elf.h>
+#include <linux/ftrace.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/sort.h>
@@ -22,19 +23,52 @@
 						    (PLT_ENT_STRIDE - 8))
 #endif
 
+static const u32 fixed_plts[] = {
+#ifdef CONFIG_FUNCTION_TRACER
+	FTRACE_ADDR,
+	MCOUNT_ADDR,
+#endif
+};
+
 static bool in_init(const struct module *mod, unsigned long loc)
 {
 	return loc - (u32)mod->init_layout.base < mod->init_layout.size;
 }
 
+static void prealloc_fixed(struct mod_plt_sec *pltsec, struct plt_entries *plt)
+{
+	int i;
+
+	if (!ARRAY_SIZE(fixed_plts) || pltsec->plt_count)
+		return;
+	pltsec->plt_count = ARRAY_SIZE(fixed_plts);
+
+	for (i = 0; i < ARRAY_SIZE(plt->ldr); ++i)
+		plt->ldr[i] = PLT_ENT_LDR;
+
+	BUILD_BUG_ON(sizeof(fixed_plts) > sizeof(plt->lit));
+	memcpy(plt->lit, fixed_plts, sizeof(fixed_plts));
+}
+
 u32 get_module_plt(struct module *mod, unsigned long loc, Elf32_Addr val)
 {
 	struct mod_plt_sec *pltsec = !in_init(mod, loc) ? &mod->arch.core :
 							  &mod->arch.init;
+	struct plt_entries *plt;
+	int idx;
+
+	/* cache the address, ELF header is available only during module load */
+	if (!pltsec->plt_ent)
+		pltsec->plt_ent = (struct plt_entries *)pltsec->plt->sh_addr;
+	plt = pltsec->plt_ent;
 
-	struct plt_entries *plt = (struct plt_entries *)pltsec->plt->sh_addr;
-	int idx = 0;
+	prealloc_fixed(pltsec, plt);
+
+	for (idx = 0; idx < ARRAY_SIZE(fixed_plts); ++idx)
+		if (plt->lit[idx] == val)
+			return (u32)&plt->ldr[idx];
 
+	idx = 0;
 	/*
 	 * Look for an existing entry pointing to 'val'. Given that the
 	 * relocations are sorted, this will be the last entry we allocated.
@@ -182,8 +216,8 @@ static unsigned int count_plts(const Elf32_Sym *syms, Elf32_Addr base,
 int module_frob_arch_sections(Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
 			      char *secstrings, struct module *mod)
 {
-	unsigned long core_plts = 0;
-	unsigned long init_plts = 0;
+	unsigned long core_plts = ARRAY_SIZE(fixed_plts);
+	unsigned long init_plts = ARRAY_SIZE(fixed_plts);
 	Elf32_Shdr *s, *sechdrs_end = sechdrs + ehdr->e_shnum;
 	Elf32_Sym *syms = NULL;
 
@@ -238,6 +272,7 @@ int module_frob_arch_sections(Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
 	mod->arch.core.plt->sh_size = round_up(core_plts * PLT_ENT_SIZE,
 					       sizeof(struct plt_entries));
 	mod->arch.core.plt_count = 0;
+	mod->arch.core.plt_ent = NULL;
 
 	mod->arch.init.plt->sh_type = SHT_NOBITS;
 	mod->arch.init.plt->sh_flags = SHF_EXECINSTR | SHF_ALLOC;
@@ -245,6 +280,7 @@ int module_frob_arch_sections(Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
 	mod->arch.init.plt->sh_size = round_up(init_plts * PLT_ENT_SIZE,
 					       sizeof(struct plt_entries));
 	mod->arch.init.plt_count = 0;
+	mod->arch.init.plt_ent = NULL;
 
 	pr_debug("%s: plt=%x, init.plt=%x\n", __func__,
 		 mod->arch.core.plt->sh_size, mod->arch.init.plt->sh_size);
-- 
2.25.1


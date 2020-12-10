Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D7EA2D5BBB
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 14:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729847AbgLJN3H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 08:29:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbgLJN3H (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 08:29:07 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9812DC0613D6
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 05:28:26 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id t16so5483351wra.3
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 05:28:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hWNs2NwF97BFuQp7y8JsAXRv1DenSN9AlNUmwdO7OfM=;
        b=gkkkz7BXpScVdyeB20eMRhasTYfzIhZfEqEJKT6wDmcMIbQkM7VK3DDOn6s0iCtlON
         WlzqLEPe3rxDkigWR1heQwhlJOP+vh7vSkLF2mkd/rA0kUZCfiSBFxiiow44umSf/r/F
         qhRW3smwxWmrKiuT2X1ZmnWVXQzpm/Z+ikOC/HNqx9uxnv+A658ZxRp2gvyI5ha/Xh0t
         +zk9qtzAltpwzJStcgGyqRZFC1b/YO2HMlV8nkQ9Dpd7Bwj51Tn3NpCi1SFRjc45SIOE
         btSijXBQ1tFY8Evz1xtJKRW+HnmGHklkRf/TBG3BJtOpwyPlliexyP+S1tsg+yNqbl7x
         38Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=hWNs2NwF97BFuQp7y8JsAXRv1DenSN9AlNUmwdO7OfM=;
        b=U0Ffa6BL/ijiVNqWiG2w3cUCc4XMNRCQZjNOZMVNflvOg1shM6S5Nw+smMACkwP9VA
         MckCiZQqbCcgI9F6YiIiSsl0Xw9O5HdhwEraoFVDuQ3nF6L+Isp1/clPNh/BEFG997z/
         sxQbh6snrMtttNPb8fvDpBB2Q1ResDX1MrNAS/m6ivDYsbkLhHUVKZ71tuA2A1LXamz/
         eVHKr4id2xwWisarYr7E26EEdN/ZA5/6oAY//fWIhRQVmQJ16qaHRyf/xQmO++8neAkp
         B9QStlJMO2Bdznyhk2VQb3x/fqzoJNmWJIyigvx0tfCkfsPwPCNLIHBOED2Zf2hkM9lA
         WLmg==
X-Gm-Message-State: AOAM5304BDCore5ArIkKfDQRflvJzFXgGPiOuPtYnpMBN3LMA5EiHxIM
        qD1wFEuelEtyv+s9dMDuxKk=
X-Google-Smtp-Source: ABdhPJxJ+VaoszuaYpVSYyspyvrIiZlUy3Y4QZzLOGxsYND3G8rI5AIx7WuViM/4FIByARgxaeqYhQ==
X-Received: by 2002:adf:b343:: with SMTP id k3mr8110381wrd.202.1607606905388;
        Thu, 10 Dec 2020 05:28:25 -0800 (PST)
Received: from debian (host-92-5-241-147.as43234.net. [92.5.241.147])
        by smtp.gmail.com with ESMTPSA id n14sm9335306wrx.79.2020.12.10.05.28.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 10 Dec 2020 05:28:24 -0800 (PST)
Date:   Thu, 10 Dec 2020 13:28:23 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     mhiramat@kernel.org, bp@suse.de, keescook@chromium.org,
        srikar@linux.vnet.ibm.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] x86/uprobes: Do not use prefixes.nbytes
 when looping over" failed to apply to 4.9-stable tree
Message-ID: <20201210132823.yhvovcgp2q5fzkix@debian>
References: <1607506451251211@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="aps7pattqsz2nhab"
Content-Disposition: inline
In-Reply-To: <1607506451251211@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--aps7pattqsz2nhab
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Wed, Dec 09, 2020 at 10:34:11AM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport.

--
Regards
Sudip

--aps7pattqsz2nhab
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-x86-uprobes-Do-not-use-prefixes.nbytes-when-looping-.patch"

From 7437b190bde2ba9d0190eb25e11d1a549e45cfb9 Mon Sep 17 00:00:00 2001
From: Masami Hiramatsu <mhiramat@kernel.org>
Date: Thu, 3 Dec 2020 13:50:37 +0900
Subject: [PATCH] x86/uprobes: Do not use prefixes.nbytes when looping over prefixes.bytes

commit 4e9a5ae8df5b3365183150f6df49e49dece80d8c upstream

Since insn.prefixes.nbytes can be bigger than the size of
insn.prefixes.bytes[] when a prefix is repeated, the proper check must
be

  insn.prefixes.bytes[i] != 0 and i < 4

instead of using insn.prefixes.nbytes.

Introduce a for_each_insn_prefix() macro for this purpose. Debugged by
Kees Cook <keescook@chromium.org>.

 [ bp: Massage commit message, sync with the respective header in tools/
   and drop "we". ]

Fixes: 2b1444983508 ("uprobes, mm, x86: Add the ability to install and remove uprobes breakpoints")
Reported-by: syzbot+9b64b619f10f19d19a7c@syzkaller.appspotmail.com
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/160697103739.3146288.7437620795200799020.stgit@devnote2
[sudip: adjust context, use old insn.h]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 arch/x86/include/asm/insn.h               | 15 +++++++++++++++
 arch/x86/kernel/uprobes.c                 | 10 ++++++----
 tools/objtool/arch/x86/include/asm/insn.h | 15 +++++++++++++++
 3 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/insn.h b/arch/x86/include/asm/insn.h
index c2c01f84df75..3e0e18d376d2 100644
--- a/arch/x86/include/asm/insn.h
+++ b/arch/x86/include/asm/insn.h
@@ -208,6 +208,21 @@ static inline int insn_offset_immediate(struct insn *insn)
 	return insn_offset_displacement(insn) + insn->displacement.nbytes;
 }
 
+/**
+ * for_each_insn_prefix() -- Iterate prefixes in the instruction
+ * @insn: Pointer to struct insn.
+ * @idx:  Index storage.
+ * @prefix: Prefix byte.
+ *
+ * Iterate prefix bytes of given @insn. Each prefix byte is stored in @prefix
+ * and the index is stored in @idx (note that this @idx is just for a cursor,
+ * do not change it.)
+ * Since prefixes.nbytes can be bigger than 4 if some prefixes
+ * are repeated, it cannot be used for looping over the prefixes.
+ */
+#define for_each_insn_prefix(insn, idx, prefix)	\
+	for (idx = 0; idx < ARRAY_SIZE(insn->prefixes.bytes) && (prefix = insn->prefixes.bytes[idx]) != 0; idx++)
+
 #define POP_SS_OPCODE 0x1f
 #define MOV_SREG_OPCODE 0x8e
 
diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 73391c1bd2a9..52bb7413f352 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -268,10 +268,11 @@ static volatile u32 good_2byte_insns[256 / 32] = {
 
 static bool is_prefix_bad(struct insn *insn)
 {
+	insn_byte_t p;
 	int i;
 
-	for (i = 0; i < insn->prefixes.nbytes; i++) {
-		switch (insn->prefixes.bytes[i]) {
+	for_each_insn_prefix(insn, i, p) {
+		switch (p) {
 		case 0x26:	/* INAT_PFX_ES   */
 		case 0x2E:	/* INAT_PFX_CS   */
 		case 0x36:	/* INAT_PFX_DS   */
@@ -711,6 +712,7 @@ static const struct uprobe_xol_ops branch_xol_ops = {
 static int branch_setup_xol_ops(struct arch_uprobe *auprobe, struct insn *insn)
 {
 	u8 opc1 = OPCODE1(insn);
+	insn_byte_t p;
 	int i;
 
 	switch (opc1) {
@@ -741,8 +743,8 @@ static int branch_setup_xol_ops(struct arch_uprobe *auprobe, struct insn *insn)
 	 * Intel and AMD behavior differ in 64-bit mode: Intel ignores 66 prefix.
 	 * No one uses these insns, reject any branch insns with such prefix.
 	 */
-	for (i = 0; i < insn->prefixes.nbytes; i++) {
-		if (insn->prefixes.bytes[i] == 0x66)
+	for_each_insn_prefix(insn, i, p) {
+		if (p == 0x66)
 			return -ENOTSUPP;
 	}
 
diff --git a/tools/objtool/arch/x86/include/asm/insn.h b/tools/objtool/arch/x86/include/asm/insn.h
index b3e32b010ab1..b56241a44639 100644
--- a/tools/objtool/arch/x86/include/asm/insn.h
+++ b/tools/objtool/arch/x86/include/asm/insn.h
@@ -208,4 +208,19 @@ static inline int insn_offset_immediate(struct insn *insn)
 	return insn_offset_displacement(insn) + insn->displacement.nbytes;
 }
 
+/**
+ * for_each_insn_prefix() -- Iterate prefixes in the instruction
+ * @insn: Pointer to struct insn.
+ * @idx:  Index storage.
+ * @prefix: Prefix byte.
+ *
+ * Iterate prefix bytes of given @insn. Each prefix byte is stored in @prefix
+ * and the index is stored in @idx (note that this @idx is just for a cursor,
+ * do not change it.)
+ * Since prefixes.nbytes can be bigger than 4 if some prefixes
+ * are repeated, it cannot be used for looping over the prefixes.
+ */
+#define for_each_insn_prefix(insn, idx, prefix)        \
+	for (idx = 0; idx < ARRAY_SIZE(insn->prefixes.bytes) && (prefix = insn->prefixes.bytes[idx]) != 0; idx++)
+
 #endif /* _ASM_X86_INSN_H */
-- 
2.11.0


--aps7pattqsz2nhab--

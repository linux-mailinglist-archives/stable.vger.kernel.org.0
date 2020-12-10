Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC36A2D5BB8
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 14:29:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730352AbgLJN2I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 08:28:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732028AbgLJN1w (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 08:27:52 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29FF1C0613CF
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 05:27:12 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id r7so5467450wrc.5
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 05:27:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4osJ18UtA8ajd/femdvNBGenLx3kgKDKVEO2CLs+lxc=;
        b=hdm+QwYgG6P3mReipmla9PBQaMSUv3mHmsTtZ/Pu01xU8gR/zrcUND4aSS0ahBP4BR
         f4a3Ce6UeWccxgiyFS6IsxhmHE9JBpZBziXyzYzl8wBmJddYTkR5YqSANSP8bv0ME3I8
         /MJhI/VJ5uIp5xxmimwnrhr4f1SzhPAqcZv44sWHWp/Rmj161c+I0QfzZTQwir9EToS7
         u4YFYo9hJCQu1DEBl45ncqR3TMnENgZ0QosTZdqMPE4hDqbFHOdsClDuTJxD2iRisnIn
         zIsv9x3syNkso3aIJ807W/inwxapWcv7j+bNJ+w4sOItEIKBKFBwSD+KrV2bkipnl7rR
         oN9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4osJ18UtA8ajd/femdvNBGenLx3kgKDKVEO2CLs+lxc=;
        b=nPOanlCoSqDhFXKPuGag/N65GsG8tXLcm6tl4pNGlAcVVy3R+jMYKFoTWXbPGPFk5s
         QrEk8UWJ+QHnj5IDnvWE+/y4KMU6Kc/cqVYLD7x5MRWFHSQv88qD8B5E2KqenWv6l5rP
         SZF6EmUPowM0yG72lUjtua7tCQtwDs3/dSacKttTxcDYfTIVcJ0pwhX61NdyU+47hBag
         jXQU5+epPKVeoxQIMbYph/Q1rjwre8PjWjYnFJJPjMnrLqG40ByEYEhY9G3CRVi1bJ8B
         mx9ECcViDw6ub2zJ/HAoow6UfpthNw2In4K5lMQDT0tZt8ijAFfMdX+W4++RFIe/EvNR
         /QeA==
X-Gm-Message-State: AOAM531NjjJRyFfP5J4YdV62VMtgpZXPirtxBZIAPDGSDtDMDGWf5dWH
        qyUT6Q+a4faODbUONDoqifM=
X-Google-Smtp-Source: ABdhPJyRESZX28S0RKJSrdq+MihyfOT4JCTbjYc3w8fAcTtMIAUStEFmEfxXinjWLJgoiLXC143JFw==
X-Received: by 2002:a05:6000:1d1:: with SMTP id t17mr8508764wrx.164.1607606830800;
        Thu, 10 Dec 2020 05:27:10 -0800 (PST)
Received: from debian (host-92-5-241-147.as43234.net. [92.5.241.147])
        by smtp.gmail.com with ESMTPSA id b73sm9862449wmb.0.2020.12.10.05.27.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 10 Dec 2020 05:27:10 -0800 (PST)
Date:   Thu, 10 Dec 2020 13:27:08 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     mhiramat@kernel.org, bp@suse.de, keescook@chromium.org,
        srikar@linux.vnet.ibm.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] x86/uprobes: Do not use prefixes.nbytes
 when looping over" failed to apply to 4.14-stable tree
Message-ID: <20201210132708.v4ixgqi2yfg4g4xm@debian>
References: <160750644919092@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="sqifyruwii3f5ywn"
Content-Disposition: inline
In-Reply-To: <160750644919092@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--sqifyruwii3f5ywn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Wed, Dec 09, 2020 at 10:34:09AM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport.

--
Regards
Sudip

--sqifyruwii3f5ywn
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-x86-uprobes-Do-not-use-prefixes.nbytes-when-looping-.patch"

From a5827defc6d1f74b0ea6824b27e4f90c4e4ae387 Mon Sep 17 00:00:00 2001
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
index c2c01f84df75..e9f21f836dfb 100644
--- a/tools/objtool/arch/x86/include/asm/insn.h
+++ b/tools/objtool/arch/x86/include/asm/insn.h
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
+#define for_each_insn_prefix(insn, idx, prefix)        \
+	for (idx = 0; idx < ARRAY_SIZE(insn->prefixes.bytes) && (prefix = insn->prefixes.bytes[idx]) != 0; idx++)
+
 #define POP_SS_OPCODE 0x1f
 #define MOV_SREG_OPCODE 0x8e
 
-- 
2.11.0


--sqifyruwii3f5ywn--

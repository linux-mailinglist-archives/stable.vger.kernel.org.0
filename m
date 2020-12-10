Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BDD52D5BC3
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 14:30:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728925AbgLJN3w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 08:29:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbgLJN3v (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 08:29:51 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 632DBC0613CF
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 05:29:11 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id w206so2776246wma.0
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 05:29:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=EZIKJshnUL3kUdlYLE62F3RKqAJYIn3hQ5FjpAY3LLQ=;
        b=X699sP28A8L22+gOyhAZuKHdjPT41tYwDVThKmJ/8cKUN8xWv0hc7U+IxtldjL6ztT
         iS1NPjQ9GXEFz6lOdIScN7EtUwDUbpE7l+ZVqoxaMBzkO6HxE39WFvTSEh8Xp55f7+/Q
         yCNeYmmcHDl96+ZFe1HvhOVFYfGBwNzayH2vCF4YtUZa3ohwikTTp95Ckcg5+mhtk4jq
         SrSL2w2wKPKBnChlVwnlnLF4apBP785V+MXSwaS2IbrXtGjpSSjXMMtaZkxryNvU/tUq
         emN/VqjrarrQd1DVEOTwQv16ZTwTNdm9Wt6gw5Bczrx9lab5vMJ/QxwV0uCTTRnb3fS7
         k7Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=EZIKJshnUL3kUdlYLE62F3RKqAJYIn3hQ5FjpAY3LLQ=;
        b=BheiO7w8QD1U0V8Lg0Vj77ifpmvimQr6a/+eFb7sW8RdY0TgwUzDnzNsyve5lfStfs
         83UlpYIBt0fz9t79zInOuLFhDKrxzqJ/YW2ufG3ikxXy+vV7Swh0gNiem44ezOVg67hU
         Oi3TbMsBhZ/yHZy9z8e4AjWkT13bqE5Gs4mV0GzgZ3kDJYq+tG/ExavtmhiaAM6+zJ4Y
         +ws8MTIruk4pBlH1QpVIl78hpxrkb6BXr3tLgdvU7KvH8N7+ekXWn99LHJSqMvB9Xttm
         Uysyz8o43KRcGsGom0JfDg1+rPiHIgEG1lYVZ3SK1U5Sz2Y34eU62Qb306nVuwXwuvHp
         mpZQ==
X-Gm-Message-State: AOAM532tR7e399jVQW+OfRqlN6o45qp7PWz496khPuM2Kz24agu6FwmM
        LOL04sIluFr8jDuKoW7bksFAGApvIJzzRjo+
X-Google-Smtp-Source: ABdhPJwugNzZl6k40hjkpc+lN5JCFRu4U17s8j0OA86CK3rtUjn+eirLMnrFmee9dQPUz0ki+JWyBg==
X-Received: by 2002:a7b:ce0f:: with SMTP id m15mr8113084wmc.56.1607606950222;
        Thu, 10 Dec 2020 05:29:10 -0800 (PST)
Received: from debian (host-92-5-241-147.as43234.net. [92.5.241.147])
        by smtp.gmail.com with ESMTPSA id p3sm9178017wrs.50.2020.12.10.05.29.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 10 Dec 2020 05:29:09 -0800 (PST)
Date:   Thu, 10 Dec 2020 13:29:07 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     mhiramat@kernel.org, bp@suse.de, keescook@chromium.org,
        srikar@linux.vnet.ibm.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] x86/uprobes: Do not use prefixes.nbytes
 when looping over" failed to apply to 4.4-stable tree
Message-ID: <20201210132907.rdiix6xynfl72ghz@debian>
References: <1607506453129233@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="7es5a55obfkbnqjz"
Content-Disposition: inline
In-Reply-To: <1607506453129233@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--7es5a55obfkbnqjz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Wed, Dec 09, 2020 at 10:34:13AM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport.

--
Regards
Sudip

--7es5a55obfkbnqjz
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-x86-uprobes-Do-not-use-prefixes.nbytes-when-looping-.patch"

From 5bc40766ed55e4c47fbf8fcb49ee78c645eb235d Mon Sep 17 00:00:00 2001
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
[sudip: adjust context, drop change of insn.h in tools]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 arch/x86/include/asm/insn.h | 15 +++++++++++++++
 arch/x86/kernel/uprobes.c   | 10 ++++++----
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/insn.h b/arch/x86/include/asm/insn.h
index 5a51fcbbe563..6db02d52cdf4 100644
--- a/arch/x86/include/asm/insn.h
+++ b/arch/x86/include/asm/insn.h
@@ -198,6 +198,21 @@ static inline int insn_offset_immediate(struct insn *insn)
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
index 8c38784cf992..60ccfa4c2768 100644
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
@@ -711,6 +712,7 @@ static struct uprobe_xol_ops branch_xol_ops = {
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
 
-- 
2.11.0


--7es5a55obfkbnqjz--

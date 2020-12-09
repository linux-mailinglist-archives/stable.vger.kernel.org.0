Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 774F52D462C
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 16:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728739AbgLIP5I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 10:57:08 -0500
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:34329 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730402AbgLIPxw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 10:53:52 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 26CBB194021B;
        Wed,  9 Dec 2020 04:32:56 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 09 Dec 2020 04:32:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=4kz5WI
        kxVcmPl7bk2RDg4ZGbEL5YbCWAJB/MhvcRdJc=; b=omMJzF38HaVlRcOhtVJEfk
        3rEE11Zn5vSa0bUxobB//L3rnuNyBmnXVXleTEIvnnTe0KocX7fV+50xCpqHwWf6
        w2OE8Flwm5WjIjC3h97BWMJVYGg+NkNa0XBzGIVhTyj+z0VdFOG5dow0aza+3c4s
        XeEiSlmyX54sZXIHxdoXEcgI5bWAWsj9tSeiF46qe64BqXpGqZJyTvR+RQGSwByu
        sgV7k21tOHFlMVzI2v+IOxS2RImtqnUjLaWK5uZfogYDDNt51jL4X83GC9i2yuxR
        fuhU0AasjLIk86aKbDNMKlg1ZjZ+dAqVivXShLKJjYFkPhBit73VLcfof5C90UpQ
        ==
X-ME-Sender: <xms:yJnQX8V5LoKiGj-U-GOX4I0H95a0pNZLx2sfKKETLR1bC8kYVZz3ng>
    <xme:yJnQXwnzwo7T4mZkHvLLIXo1dq8NYjAk56T3gEODI58GCJpmjZArNqFN6Zds_qBwm
    xoKIfSHs0L4dw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejkedgtdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:yJnQXwbpB8EUjvsjIFp8URDl4A7UM2k_s241yelYI03HViVqfFZPfQ>
    <xmx:yJnQX7UHJZb7Pj8qeEumDRvjNiFbGkb4iYsfst2tHLCdiznTJAjg5Q>
    <xmx:yJnQX2mq0H8PoGnMcxLP56gtUdAcWo38phDik0NdQ2g9LY3ZMc1EOg>
    <xmx:yJnQX7w7taj2WvU1Zrk_I7TBFZ2b5twRwcL4J6RZdY9TDQLDQuDyxw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id B1F15240067;
        Wed,  9 Dec 2020 04:32:55 -0500 (EST)
Subject: FAILED: patch "[PATCH] x86/uprobes: Do not use prefixes.nbytes when looping over" failed to apply to 4.9-stable tree
To:     mhiramat@kernel.org, bp@suse.de, keescook@chromium.org,
        srikar@linux.vnet.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 09 Dec 2020 10:34:11 +0100
Message-ID: <1607506451251211@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4e9a5ae8df5b3365183150f6df49e49dece80d8c Mon Sep 17 00:00:00 2001
From: Masami Hiramatsu <mhiramat@kernel.org>
Date: Thu, 3 Dec 2020 13:50:37 +0900
Subject: [PATCH] x86/uprobes: Do not use prefixes.nbytes when looping over
 prefixes.bytes

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

diff --git a/arch/x86/include/asm/insn.h b/arch/x86/include/asm/insn.h
index 5c1ae3eff9d4..a8c3d284fa46 100644
--- a/arch/x86/include/asm/insn.h
+++ b/arch/x86/include/asm/insn.h
@@ -201,6 +201,21 @@ static inline int insn_offset_immediate(struct insn *insn)
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
index 3fdaa042823d..138bdb1fd136 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -255,12 +255,13 @@ static volatile u32 good_2byte_insns[256 / 32] = {
 
 static bool is_prefix_bad(struct insn *insn)
 {
+	insn_byte_t p;
 	int i;
 
-	for (i = 0; i < insn->prefixes.nbytes; i++) {
+	for_each_insn_prefix(insn, i, p) {
 		insn_attr_t attr;
 
-		attr = inat_get_opcode_attribute(insn->prefixes.bytes[i]);
+		attr = inat_get_opcode_attribute(p);
 		switch (attr) {
 		case INAT_MAKE_PREFIX(INAT_PFX_ES):
 		case INAT_MAKE_PREFIX(INAT_PFX_CS):
@@ -715,6 +716,7 @@ static const struct uprobe_xol_ops push_xol_ops = {
 static int branch_setup_xol_ops(struct arch_uprobe *auprobe, struct insn *insn)
 {
 	u8 opc1 = OPCODE1(insn);
+	insn_byte_t p;
 	int i;
 
 	switch (opc1) {
@@ -746,8 +748,8 @@ static int branch_setup_xol_ops(struct arch_uprobe *auprobe, struct insn *insn)
 	 * Intel and AMD behavior differ in 64-bit mode: Intel ignores 66 prefix.
 	 * No one uses these insns, reject any branch insns with such prefix.
 	 */
-	for (i = 0; i < insn->prefixes.nbytes; i++) {
-		if (insn->prefixes.bytes[i] == 0x66)
+	for_each_insn_prefix(insn, i, p) {
+		if (p == 0x66)
 			return -ENOTSUPP;
 	}
 
diff --git a/tools/arch/x86/include/asm/insn.h b/tools/arch/x86/include/asm/insn.h
index 568854b14d0a..52c6262e6bfd 100644
--- a/tools/arch/x86/include/asm/insn.h
+++ b/tools/arch/x86/include/asm/insn.h
@@ -201,6 +201,21 @@ static inline int insn_offset_immediate(struct insn *insn)
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
 


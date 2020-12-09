Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCB672D45E1
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 16:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729583AbgLIPxc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 10:53:32 -0500
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:40897 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730084AbgLIPxa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 10:53:30 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 90DC219439BE;
        Wed,  9 Dec 2020 03:46:53 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 09 Dec 2020 03:46:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=87+r+G
        P+A7KR32bmAvoGiHvFTpPLY9HpMibpAt/PX+4=; b=gGT910TPjv48XOvjlmCsEr
        FI3AAhd6EIj5ICXVYdp8/4F9XTW7Kv5CoUqim8YFtizxau6k4noMDtzb4rM58Lv6
        exC5Aa4LDEMc/k6vmfXicxR/vKfJyGu2xPj1e6hgCTNOjcwptpGXiwf/Yw8fYTAv
        X+IcsrUBtW53psUIdFnhpygPrBwaV4Tgm+IgyY8hufHzP7TszvDQdpz9I33H8oHd
        +dpeMP5qmrrGyBpIFy5ZYz3p6XrYuZh1STx0I/+9oquujjr5ztzdDmyUUgorTe77
        6Z/3+fQkGLLO9SMfLv/MX0nBPssPeMMPkB2CNUuMTVHbTNJ8oAlLcTs5sO9LB1hg
        ==
X-ME-Sender: <xms:_Y7QX9k5TLHZr6KmGFm8xw0HiRPA1QHPTignbv_WEAa229FhYNTyfQ>
    <xme:_Y7QX42zb8NjO9_cctCjTwiT-kc6gUcnjDExYrsuWV41enfTLO0Npsf-SuN7JAgeC
    Bqqq3IY_MoXjw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejjedguddvvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:_Y7QXzp5PFWwlbbsgdHuv8bbusORPGWUWwAYIMUjV5rgovv7uKn_jg>
    <xmx:_Y7QX9klBfKYiuQDlhqoQM1A3aLKgRrvI6inIKGMXBy0zgj5cHlpsQ>
    <xmx:_Y7QX73XgfoEunxIrRAmkNMPPn1gYNx2iNnpazFjYzJFJOr5ePxjZQ>
    <xmx:_Y7QX0-z378ExvPukP_V739S_QZwV3ovySu49DVR7WVB8xqhymbP2Q>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2399624005B;
        Wed,  9 Dec 2020 03:46:53 -0500 (EST)
Subject: FAILED: patch "[PATCH] x86/insn-eval: Use new for_each_insn_prefix() macro to loop" failed to apply to 5.4-stable tree
To:     mhiramat@kernel.org, bp@suse.de, keescook@chromium.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 09 Dec 2020 09:48:09 +0100
Message-ID: <1607503689184177@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 12cb908a11b2544b5f53e9af856e6b6a90ed5533 Mon Sep 17 00:00:00 2001
From: Masami Hiramatsu <mhiramat@kernel.org>
Date: Thu, 3 Dec 2020 13:50:50 +0900
Subject: [PATCH] x86/insn-eval: Use new for_each_insn_prefix() macro to loop
 over prefixes bytes

Since insn.prefixes.nbytes can be bigger than the size of
insn.prefixes.bytes[] when a prefix is repeated, the proper check must
be

  insn.prefixes.bytes[i] != 0 and i < 4

instead of using insn.prefixes.nbytes. Use the new
for_each_insn_prefix() macro which does it correctly.

Debugged by Kees Cook <keescook@chromium.org>.

 [ bp: Massage commit message. ]

Fixes: 32d0b95300db ("x86/insn-eval: Add utility functions to get segment selector")
Reported-by: syzbot+9b64b619f10f19d19a7c@syzkaller.appspotmail.com
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/160697104969.3146288.16329307586428270032.stgit@devnote2

diff --git a/arch/x86/lib/insn-eval.c b/arch/x86/lib/insn-eval.c
index 58f7fb95c7f4..4229950a5d78 100644
--- a/arch/x86/lib/insn-eval.c
+++ b/arch/x86/lib/insn-eval.c
@@ -63,13 +63,12 @@ static bool is_string_insn(struct insn *insn)
  */
 bool insn_has_rep_prefix(struct insn *insn)
 {
+	insn_byte_t p;
 	int i;
 
 	insn_get_prefixes(insn);
 
-	for (i = 0; i < insn->prefixes.nbytes; i++) {
-		insn_byte_t p = insn->prefixes.bytes[i];
-
+	for_each_insn_prefix(insn, i, p) {
 		if (p == 0xf2 || p == 0xf3)
 			return true;
 	}
@@ -95,14 +94,15 @@ static int get_seg_reg_override_idx(struct insn *insn)
 {
 	int idx = INAT_SEG_REG_DEFAULT;
 	int num_overrides = 0, i;
+	insn_byte_t p;
 
 	insn_get_prefixes(insn);
 
 	/* Look for any segment override prefixes. */
-	for (i = 0; i < insn->prefixes.nbytes; i++) {
+	for_each_insn_prefix(insn, i, p) {
 		insn_attr_t attr;
 
-		attr = inat_get_opcode_attribute(insn->prefixes.bytes[i]);
+		attr = inat_get_opcode_attribute(p);
 		switch (attr) {
 		case INAT_MAKE_PREFIX(INAT_PFX_CS):
 			idx = INAT_SEG_REG_CS;


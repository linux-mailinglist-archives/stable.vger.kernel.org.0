Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 931C71D7D82
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 17:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbgERPy6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 11:54:58 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:52805 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728162AbgERPy5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 May 2020 11:54:57 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 035AC194038F;
        Mon, 18 May 2020 11:54:56 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 18 May 2020 11:54:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=hmy90e
        PUvksgBLRATS7BnP5HVVDQ2eGXkuYtd3zG7gU=; b=GCXdJf6JXlzBVYKKYxj4HK
        e6K+X27llUVPw5BIIFXrGwlImG3Eir6TYX3u+kuL98NOtifR8Ywvo4o58rFu8Ued
        PlZ1X4gyWAClbwZLv+gsJoRyy/5x+mJZGopGkl2J9ujC26MWrgAsCsxsC5OYKVdt
        skgMvmtMxjzF6IGs7bveqKiBaQ/fQYMBNV3psw0vuR1nRs392ZZ/YT6HHnoZRede
        Zuou9t7Ioyxz+zPqHzoemVA1wf7dPBwL5tTDTDINGmDxSsDabaBhRW21qdgdHvim
        O8xB/KHKZ4mEsYqybKvMgNK+cr5GL1UO5sqxTV6CIAPdHtI4SDsxkTtAI+yjiqXg
        ==
X-ME-Sender: <xms:z6_CXoib6h58Ulm_fN9ss2Vmc5rhB6QtRD04ws5bvTORcYY3Rhc92g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddthedgleefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:z6_CXhCF9opzc55BDVnAcr3YA1Luxd40_RBTpcnSllrkmUft8xkTqg>
    <xmx:z6_CXgFgoyhp00ajp9zDEfuPQ34Ng3i4D8ohtYDHnyulQiMDiDJESg>
    <xmx:z6_CXpQyoLmPQ9qPs5599Sdn7M01V35t1NZd23xp2SLiis5qELYsAg>
    <xmx:0K_CXt8DMXdAbk0gRrElNUYYKESPUXtO46jcxILZCif8ElY3bll9vQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 845E73280068;
        Mon, 18 May 2020 11:54:55 -0400 (EDT)
Subject: FAILED: patch "[PATCH] bpf: Restrict bpf_trace_printk()'s %s usage and add %pks," failed to apply to 5.4-stable tree
To:     daniel@iogearbox.net, ast@kernel.org, brendan.d.gregg@gmail.com,
        hch@lst.de, mhiramat@kernel.org, torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 May 2020 17:54:46 +0200
Message-ID: <15898172865189@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From b2a5212fb634561bb734c6356904e37f6665b955 Mon Sep 17 00:00:00 2001
From: Daniel Borkmann <daniel@iogearbox.net>
Date: Fri, 15 May 2020 12:11:18 +0200
Subject: [PATCH] bpf: Restrict bpf_trace_printk()'s %s usage and add %pks,
 %pus specifier

Usage of plain %s conversion specifier in bpf_trace_printk() suffers from the
very same issue as bpf_probe_read{,str}() helpers, that is, it is broken on
archs with overlapping address ranges.

While the helpers have been addressed through work in 6ae08ae3dea2 ("bpf: Add
probe_read_{user, kernel} and probe_read_{user, kernel}_str helpers"), we need
an option for bpf_trace_printk() as well to fix it.

Similarly as with the helpers, force users to make an explicit choice by adding
%pks and %pus specifier to bpf_trace_printk() which will then pick the corresponding
strncpy_from_unsafe*() variant to perform the access under KERNEL_DS or USER_DS.
The %pk* (kernel specifier) and %pu* (user specifier) can later also be extended
for other objects aside strings that are probed and printed under tracing, and
reused out of other facilities like bpf_seq_printf() or BTF based type printing.

Existing behavior of %s for current users is still kept working for archs where it
is not broken and therefore gated through CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE.
For archs not having this property we fall-back to pick probing under KERNEL_DS as
a sensible default.

Fixes: 8d3b7dce8622 ("bpf: add support for %s specifier to bpf_trace_printk()")
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Reported-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Brendan Gregg <brendan.d.gregg@gmail.com>
Link: https://lore.kernel.org/bpf/20200515101118.6508-4-daniel@iogearbox.net

diff --git a/Documentation/core-api/printk-formats.rst b/Documentation/core-api/printk-formats.rst
index 8ebe46b1af39..5dfcc4592b23 100644
--- a/Documentation/core-api/printk-formats.rst
+++ b/Documentation/core-api/printk-formats.rst
@@ -112,6 +112,20 @@ used when printing stack backtraces. The specifier takes into
 consideration the effect of compiler optimisations which may occur
 when tail-calls are used and marked with the noreturn GCC attribute.
 
+Probed Pointers from BPF / tracing
+----------------------------------
+
+::
+
+	%pks	kernel string
+	%pus	user string
+
+The ``k`` and ``u`` specifiers are used for printing prior probed memory from
+either kernel memory (k) or user memory (u). The subsequent ``s`` specifier
+results in printing a string. For direct use in regular vsnprintf() the (k)
+and (u) annotation is ignored, however, when used out of BPF's bpf_trace_printk(),
+for example, it reads the memory it is pointing to without faulting.
+
 Kernel Pointers
 ---------------
 
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index b83bdaa31c7b..a010edc37ee0 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -323,17 +323,15 @@ static const struct bpf_func_proto *bpf_get_probe_write_proto(void)
 
 /*
  * Only limited trace_printk() conversion specifiers allowed:
- * %d %i %u %x %ld %li %lu %lx %lld %lli %llu %llx %p %s
+ * %d %i %u %x %ld %li %lu %lx %lld %lli %llu %llx %p %pks %pus %s
  */
 BPF_CALL_5(bpf_trace_printk, char *, fmt, u32, fmt_size, u64, arg1,
 	   u64, arg2, u64, arg3)
 {
+	int i, mod[3] = {}, fmt_cnt = 0;
+	char buf[64], fmt_ptype;
+	void *unsafe_ptr = NULL;
 	bool str_seen = false;
-	int mod[3] = {};
-	int fmt_cnt = 0;
-	u64 unsafe_addr;
-	char buf[64];
-	int i;
 
 	/*
 	 * bpf_check()->check_func_arg()->check_stack_boundary()
@@ -359,40 +357,71 @@ BPF_CALL_5(bpf_trace_printk, char *, fmt, u32, fmt_size, u64, arg1,
 		if (fmt[i] == 'l') {
 			mod[fmt_cnt]++;
 			i++;
-		} else if (fmt[i] == 'p' || fmt[i] == 's') {
+		} else if (fmt[i] == 'p') {
 			mod[fmt_cnt]++;
+			if ((fmt[i + 1] == 'k' ||
+			     fmt[i + 1] == 'u') &&
+			    fmt[i + 2] == 's') {
+				fmt_ptype = fmt[i + 1];
+				i += 2;
+				goto fmt_str;
+			}
+
 			/* disallow any further format extensions */
 			if (fmt[i + 1] != 0 &&
 			    !isspace(fmt[i + 1]) &&
 			    !ispunct(fmt[i + 1]))
 				return -EINVAL;
-			fmt_cnt++;
-			if (fmt[i] == 's') {
-				if (str_seen)
-					/* allow only one '%s' per fmt string */
-					return -EINVAL;
-				str_seen = true;
-
-				switch (fmt_cnt) {
-				case 1:
-					unsafe_addr = arg1;
-					arg1 = (long) buf;
-					break;
-				case 2:
-					unsafe_addr = arg2;
-					arg2 = (long) buf;
-					break;
-				case 3:
-					unsafe_addr = arg3;
-					arg3 = (long) buf;
-					break;
-				}
-				buf[0] = 0;
-				strncpy_from_unsafe(buf,
-						    (void *) (long) unsafe_addr,
+
+			goto fmt_next;
+		} else if (fmt[i] == 's') {
+			mod[fmt_cnt]++;
+			fmt_ptype = fmt[i];
+fmt_str:
+			if (str_seen)
+				/* allow only one '%s' per fmt string */
+				return -EINVAL;
+			str_seen = true;
+
+			if (fmt[i + 1] != 0 &&
+			    !isspace(fmt[i + 1]) &&
+			    !ispunct(fmt[i + 1]))
+				return -EINVAL;
+
+			switch (fmt_cnt) {
+			case 0:
+				unsafe_ptr = (void *)(long)arg1;
+				arg1 = (long)buf;
+				break;
+			case 1:
+				unsafe_ptr = (void *)(long)arg2;
+				arg2 = (long)buf;
+				break;
+			case 2:
+				unsafe_ptr = (void *)(long)arg3;
+				arg3 = (long)buf;
+				break;
+			}
+
+			buf[0] = 0;
+			switch (fmt_ptype) {
+			case 's':
+#ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
+				strncpy_from_unsafe(buf, unsafe_ptr,
 						    sizeof(buf));
+				break;
+#endif
+			case 'k':
+				strncpy_from_unsafe_strict(buf, unsafe_ptr,
+							   sizeof(buf));
+				break;
+			case 'u':
+				strncpy_from_unsafe_user(buf,
+					(__force void __user *)unsafe_ptr,
+							 sizeof(buf));
+				break;
 			}
-			continue;
+			goto fmt_next;
 		}
 
 		if (fmt[i] == 'l') {
@@ -403,6 +432,7 @@ BPF_CALL_5(bpf_trace_printk, char *, fmt, u32, fmt_size, u64, arg1,
 		if (fmt[i] != 'i' && fmt[i] != 'd' &&
 		    fmt[i] != 'u' && fmt[i] != 'x')
 			return -EINVAL;
+fmt_next:
 		fmt_cnt++;
 	}
 
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 7c488a1ce318..532b6606a18a 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -2168,6 +2168,10 @@ char *fwnode_string(char *buf, char *end, struct fwnode_handle *fwnode,
  *		f full name
  *		P node name, including a possible unit address
  * - 'x' For printing the address. Equivalent to "%lx".
+ * - '[ku]s' For a BPF/tracing related format specifier, e.g. used out of
+ *           bpf_trace_printk() where [ku] prefix specifies either kernel (k)
+ *           or user (u) memory to probe, and:
+ *              s a string, equivalent to "%s" on direct vsnprintf() use
  *
  * ** When making changes please also update:
  *	Documentation/core-api/printk-formats.rst
@@ -2251,6 +2255,14 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 		if (!IS_ERR(ptr))
 			break;
 		return err_ptr(buf, end, ptr, spec);
+	case 'u':
+	case 'k':
+		switch (fmt[1]) {
+		case 's':
+			return string(buf, end, ptr, spec);
+		default:
+			return error_string(buf, end, "(einval)", spec);
+		}
 	}
 
 	/* default is to _not_ leak addresses, hash before printing */


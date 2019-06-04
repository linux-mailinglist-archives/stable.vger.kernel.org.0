Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39FCE34650
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 14:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727538AbfFDMMc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 08:12:32 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:47929 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726847AbfFDMMc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 08:12:32 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id E3C7C459;
        Tue,  4 Jun 2019 08:12:30 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 04 Jun 2019 08:12:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=GrCWf0
        /of7ZL4QMGsusbDf6wrAEgcezHgxiHNgF9YGI=; b=DBxdlyu/6Welgqzu/1c8QL
        SJXlTbJDu5zzfQ18s4TS+QneNgXX8qRj9I8W7u4vaFTmgzGKIwcOsX1hDuArzI6N
        HICfGQKig7CzFbW5xaIaAjBGGVs/I5oX0udpVeJtduw4cyhZqGLkWInWgpoTPlHm
        95Mr1mX2ZZP6+cP5M7SdfqA6+BIHo1UISHxoAkzrgHq78Vp2r6lFneVJ9jIAfDSK
        iXBCCBHZ4WCf14sg9/J/bvw26oeeKNe8nB2lZ09n2dn85tGDHvrleeCJNtyMytbj
        VBZBhKE7ocgPAs/YbC+DB/1FCHG5udIADd62ZtYKfUeYpklmo/acDOibUdf/qbMA
        ==
X-ME-Sender: <xms:LWD2XN0cDkiINpJPijJl0ntTPzLHgJ_9OM5c-bUMs6XSVYHHnYh9DA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudefledghedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:LWD2XLjPfk8LBqS6I3ws499BrssmU7TQIBIoqi0jTXPeryBnXExNCg>
    <xmx:LWD2XLTJuwm3bYxGPbsKParvNJc58ZwRA5HTMen7e5Lppy1W5RxAcw>
    <xmx:LWD2XEgd586dAiYz5VyjEhhERgXLgZ-BpB82Ooump6Xs_eJX-_nvLw>
    <xmx:LmD2XDgAubCB5xn179XVAJuecUZkfVVzRagzqKVnxDDdcydOWd9xxA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8DDF98006A;
        Tue,  4 Jun 2019 08:12:29 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ima: show rules with IMA_INMASK correctly" failed to apply to 4.9-stable tree
To:     roberto.sassu@huawei.com, zohar@linux.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 04 Jun 2019 14:12:28 +0200
Message-ID: <155965034819524@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 8cdc23a3d9ec0944000ad43bad588e36afdc38cd Mon Sep 17 00:00:00 2001
From: Roberto Sassu <roberto.sassu@huawei.com>
Date: Wed, 29 May 2019 15:30:35 +0200
Subject: [PATCH] ima: show rules with IMA_INMASK correctly

Show the '^' character when a policy rule has flag IMA_INMASK.

Fixes: 80eae209d63ac ("IMA: allow reading back the current IMA policy")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>

diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 0f6fe53cef09..1cc822a59054 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -1147,10 +1147,10 @@ enum {
 };
 
 static const char *const mask_tokens[] = {
-	"MAY_EXEC",
-	"MAY_WRITE",
-	"MAY_READ",
-	"MAY_APPEND"
+	"^MAY_EXEC",
+	"^MAY_WRITE",
+	"^MAY_READ",
+	"^MAY_APPEND"
 };
 
 #define __ima_hook_stringify(str)	(#str),
@@ -1210,6 +1210,7 @@ int ima_policy_show(struct seq_file *m, void *v)
 	struct ima_rule_entry *entry = v;
 	int i;
 	char tbuf[64] = {0,};
+	int offset = 0;
 
 	rcu_read_lock();
 
@@ -1233,15 +1234,17 @@ int ima_policy_show(struct seq_file *m, void *v)
 	if (entry->flags & IMA_FUNC)
 		policy_func_show(m, entry->func);
 
-	if (entry->flags & IMA_MASK) {
+	if ((entry->flags & IMA_MASK) || (entry->flags & IMA_INMASK)) {
+		if (entry->flags & IMA_MASK)
+			offset = 1;
 		if (entry->mask & MAY_EXEC)
-			seq_printf(m, pt(Opt_mask), mt(mask_exec));
+			seq_printf(m, pt(Opt_mask), mt(mask_exec) + offset);
 		if (entry->mask & MAY_WRITE)
-			seq_printf(m, pt(Opt_mask), mt(mask_write));
+			seq_printf(m, pt(Opt_mask), mt(mask_write) + offset);
 		if (entry->mask & MAY_READ)
-			seq_printf(m, pt(Opt_mask), mt(mask_read));
+			seq_printf(m, pt(Opt_mask), mt(mask_read) + offset);
 		if (entry->mask & MAY_APPEND)
-			seq_printf(m, pt(Opt_mask), mt(mask_append));
+			seq_printf(m, pt(Opt_mask), mt(mask_append) + offset);
 		seq_puts(m, " ");
 	}
 


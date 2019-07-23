Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 659DB717CC
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 14:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387846AbfGWMJu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 08:09:50 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:35923 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730000AbfGWMJu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 08:09:50 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 966A9E1F;
        Tue, 23 Jul 2019 08:09:48 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 23 Jul 2019 08:09:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=qYaye2
        LVV6hrb7FS4b0CeYtgHKcexr5fSIrvtSi+nAo=; b=LlMwSrbdzyK13jF6fJjDlQ
        REx82TYMnMj0MlIXqbHPqr8wi5CFGVwCuXiiyu1nzjn9EVS4MocM7lTIqhRJ2Gah
        x9D8nbaJ0hxfl6rkOKOcMxdqVjX+eC00RmSCgEfV209O36x9BqHHYBblDh/ZKNWx
        wxW1nv2M1P6IGQabp9JRNEUEidKo6lnnKcAFvSeoqSZqStJfU6CcNcn4qEwYRnIn
        QleFIre3CQbE0jNklb31BFrVSt6qC0nPUbRN1b+hSHIz1fYs9qZGK9q8ammOKaRU
        KfQWdXtdYA43PAyn8Ev54NahPubbJqewb4y7upcxg2eb2MtaBYQMHEemZcEQU7HQ
        ==
X-ME-Sender: <xms:C_k2Xdf7UNDmEvKAWwJgAHitQ4zUseeSnpUtrUBBqxrNJzR49GihHQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeekgdegkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:C_k2XeeLnT1LRhYKIpfVyIbpIgZ6PcmeU0Zxj8rbZh-uxzz4KAsFAA>
    <xmx:C_k2XamHSRxgxWVF3gRgUegroDHqTvFx2nOF7c49qxjp-1n9I0dpjQ>
    <xmx:C_k2XQ_Uh4H1fqjMHxCS9peWgbcoH4xj9rNDSuwYrg-2R3qkVTrLJg>
    <xmx:DPk2XXpqEgzqzwYpCsoGn7Qeo7Rlfvyu0D36V-8GQAJqCScf3rRT7g>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5EA85380075;
        Tue, 23 Jul 2019 08:09:47 -0400 (EDT)
Subject: FAILED: patch "[PATCH] resource: fix locking in find_next_iomem_res()" failed to apply to 4.19-stable tree
To:     namit@vmware.com, akpm@linux-foundation.org, bhelgaas@google.com,
        bp@suse.de, dan.j.williams@intel.com, dave.hansen@linux.intel.com,
        mingo@kernel.org, peterz@infradead.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, toshi.kani@hpe.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jul 2019 14:09:45 +0200
Message-ID: <1563883785235106@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 49f17c26c123b60fd1c74629eef077740d16ffc2 Mon Sep 17 00:00:00 2001
From: Nadav Amit <namit@vmware.com>
Date: Thu, 18 Jul 2019 15:57:31 -0700
Subject: [PATCH] resource: fix locking in find_next_iomem_res()

Since resources can be removed, locking should ensure that the resource
is not removed while accessing it.  However, find_next_iomem_res() does
not hold the lock while copying the data of the resource.

Keep holding the lock while the data is copied.  While at it, change the
return value to a more informative value.  It is disregarded by the
callers.

[akpm@linux-foundation.org: fix find_next_iomem_res() documentation]
Link: http://lkml.kernel.org/r/20190613045903.4922-2-namit@vmware.com
Fixes: ff3cc952d3f00 ("resource: Add remove_resource interface")
Signed-off-by: Nadav Amit <namit@vmware.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/kernel/resource.c b/kernel/resource.c
index d22423e85cf8..3ced0cd45bdd 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -326,7 +326,7 @@ EXPORT_SYMBOL(release_resource);
  *
  * If a resource is found, returns 0 and @*res is overwritten with the part
  * of the resource that's within [@start..@end]; if none is found, returns
- * -1 or -EINVAL for other invalid parameters.
+ * -ENODEV.  Returns -EINVAL for invalid parameters.
  *
  * This function walks the whole tree and not just first level children
  * unless @first_lvl is true.
@@ -365,16 +365,16 @@ static int find_next_iomem_res(resource_size_t start, resource_size_t end,
 			break;
 	}
 
+	if (p) {
+		/* copy data */
+		res->start = max(start, p->start);
+		res->end = min(end, p->end);
+		res->flags = p->flags;
+		res->desc = p->desc;
+	}
+
 	read_unlock(&resource_lock);
-	if (!p)
-		return -1;
-
-	/* copy data */
-	res->start = max(start, p->start);
-	res->end = min(end, p->end);
-	res->flags = p->flags;
-	res->desc = p->desc;
-	return 0;
+	return p ? 0 : -ENODEV;
 }
 
 static int __walk_iomem_res_desc(resource_size_t start, resource_size_t end,


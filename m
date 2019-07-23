Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC99C717CE
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 14:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731982AbfGWMKA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 08:10:00 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:51199 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730000AbfGWMKA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 08:10:00 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id A8A857C;
        Tue, 23 Jul 2019 08:09:58 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 23 Jul 2019 08:09:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=X8mfQa
        JxP+hVhRMH7ILkYCPdOXVTvoSIj4HDz+ZkIJg=; b=np54jGbTxbIuclqPlCQaOr
        MYTaqtDUx/aVgG6SoGx0kAE16SBIPIKUdEA6jvzuEOa07rMNqXdDcGL3N8d74qLM
        5qLyL/ms1XZ272GtZnBqxbcvq85RsnQZ8oRUGGXcBTMO+dJXspMPtoKq1X9DE0y8
        J6pNqWqEQyDakF9uS4aWeGtGaICdXTfd+GQnWr1Sq5on47ovZ/diHPZ80yfUY3Bi
        QE3uHFeHcLaAfzGl8lHh5elNv8A+zrEUN9i6Mjd4QCjEhI4ZG//HmKvoLw6gECuv
        OucGRnc74THVvg0BqRJ7bb8Q5VsRYotrOstdrFi5YlZzDIhSDnN9GkU0ZkDym8fw
        ==
X-ME-Sender: <xms:Fvk2XcDrxMF6kCOMgqnBzK1w9je1vu4zXRDGnZDu3AejUte-ezPVdQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeekgdegkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:Fvk2XScKEOe7_cQmDHJrAQzLb4Jz1buDcogEnKeezaKLU0EWz1IHEg>
    <xmx:Fvk2XYpbGjgKW5rY_-FlzLG_AKPsA34_rQt_TsO2NE83KB3iE1vF_w>
    <xmx:Fvk2XbR9VVln6r-yV2XvHZhMUHlsEccJEVeFIBhQhx-VycNuGRIIXQ>
    <xmx:Fvk2XUkf_B3cN3FieVPJ6mUNmUePYhv8j0fcyKyp0JXm4F7FwsRCAQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 17325380083;
        Tue, 23 Jul 2019 08:09:57 -0400 (EDT)
Subject: FAILED: patch "[PATCH] resource: fix locking in find_next_iomem_res()" failed to apply to 4.14-stable tree
To:     namit@vmware.com, akpm@linux-foundation.org, bhelgaas@google.com,
        bp@suse.de, dan.j.williams@intel.com, dave.hansen@linux.intel.com,
        mingo@kernel.org, peterz@infradead.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, toshi.kani@hpe.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jul 2019 14:09:46 +0200
Message-ID: <156388378659181@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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


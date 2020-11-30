Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5D2D2C800D
	for <lists+stable@lfdr.de>; Mon, 30 Nov 2020 09:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbgK3Ie4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Nov 2020 03:34:56 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:55545 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726045AbgK3Ie4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Nov 2020 03:34:56 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 40F2EA55;
        Mon, 30 Nov 2020 03:33:50 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 30 Nov 2020 03:33:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=BhI8OR
        OZOtoKOwJYwsIJvfb+CAI2r27CkV7Z/vAGRcw=; b=RkMWeLJmwnRWZsxa+JM9z1
        OCRlEi/9LsqyeizDrQW7rI0YxkoUWkB3OU3NxzfnDH4Eg1fHh11tRzgOLvNmQW2c
        0hxDvoO9DWEmX/k96PWQzeDk6cqV1HrmmSPOZ4FWV6VABpjqUt33AxAuMA1Ea8WN
        swy1QQ8n4v62Bz5WJsW1Sf/ZacZ+Ait7X1/kTSJnnNkS3L7frarLkdxdYkH1z6CF
        CE4FkUSTiItSRpwXiv62tiOL9Kj7tgd2sZF/53/S+jYMcXNiX3DvTfvA7XbMRGs8
        C1dVdhero2fgG9CfJSweDRsdt0i5xKCFFoFRSL2ugtOHDA6LG6ROUnxrw3b5bbaA
        ==
X-ME-Sender: <xms:ba7EX2VgazMTgaDsRmh60Gs3L1n5jbk7aZPZs3bcTQacx2_mYm35Og>
    <xme:ba7EXynlZBiy53Txxqlf78Cf-uIuZ6j0ErgIogNE-SDY3lxJOerJ-ZFv5Wqehbatk
    AtiGxmx6EBJ0A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudehledguddvtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepheenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:ba7EX6bABNAspJZLGqxZliw6Icj0eHLXmwTPPW8g2fLlvxhW5TH79A>
    <xmx:ba7EX9WWBqnISxoHjVyQXoWx65cn0yDJxX4zNU8oSHrJeO17s2rytQ>
    <xmx:ba7EXwlb8eHU736V89zUwV-eCBebPXnm9e_WVDsNbGvXH-IMgVMbSA>
    <xmx:ba7EX1xgv4MeGEIrR_AS46r6P7o9Um4vBtjA3sQYQ4t5a1rwm1idemD0Cpo>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6343B328005A;
        Mon, 30 Nov 2020 03:33:49 -0500 (EST)
Subject: FAILED: patch "[PATCH] x86/resctrl: Add necessary kernfs_put() calls to prevent" failed to apply to 4.19-stable tree
To:     xiaochen.shen@intel.com, bp@suse.de, reinette.chatre@intel.com,
        willemb@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 30 Nov 2020 09:34:46 +0100
Message-ID: <1606725286224153@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 758999246965eeb8b253d47e72f7bfe508804b16 Mon Sep 17 00:00:00 2001
From: Xiaochen Shen <xiaochen.shen@intel.com>
Date: Sat, 31 Oct 2020 03:11:28 +0800
Subject: [PATCH] x86/resctrl: Add necessary kernfs_put() calls to prevent
 refcount leak

On resource group creation via a mkdir an extra kernfs_node reference is
obtained by kernfs_get() to ensure that the rdtgroup structure remains
accessible for the rdtgroup_kn_unlock() calls where it is removed on
deletion. Currently the extra kernfs_node reference count is only
dropped by kernfs_put() in rdtgroup_kn_unlock() while the rdtgroup
structure is removed in a few other locations that lack the matching
reference drop.

In call paths of rmdir and umount, when a control group is removed,
kernfs_remove() is called to remove the whole kernfs nodes tree of the
control group (including the kernfs nodes trees of all child monitoring
groups), and then rdtgroup structure is freed by kfree(). The rdtgroup
structures of all child monitoring groups under the control group are
freed by kfree() in free_all_child_rdtgrp().

Before calling kfree() to free the rdtgroup structures, the kernfs node
of the control group itself as well as the kernfs nodes of all child
monitoring groups still take the extra references which will never be
dropped to 0 and the kernfs nodes will never be freed. It leads to
reference count leak and kernfs_node_cache memory leak.

For example, reference count leak is observed in these two cases:
  (1) mount -t resctrl resctrl /sys/fs/resctrl
      mkdir /sys/fs/resctrl/c1
      mkdir /sys/fs/resctrl/c1/mon_groups/m1
      umount /sys/fs/resctrl

  (2) mkdir /sys/fs/resctrl/c1
      mkdir /sys/fs/resctrl/c1/mon_groups/m1
      rmdir /sys/fs/resctrl/c1

The same reference count leak issue also exists in the error exit paths
of mkdir in mkdir_rdt_prepare() and rdtgroup_mkdir_ctrl_mon().

Fix this issue by following changes to make sure the extra kernfs_node
reference on rdtgroup is dropped before freeing the rdtgroup structure.
  (1) Introduce rdtgroup removal helper rdtgroup_remove() to wrap up
  kernfs_put() and kfree().

  (2) Call rdtgroup_remove() in rdtgroup removal path where the rdtgroup
  structure is about to be freed by kfree().

  (3) Call rdtgroup_remove() or kernfs_put() as appropriate in the error
  exit paths of mkdir where an extra reference is taken by kernfs_get().

Fixes: f3cbeacaa06e ("x86/intel_rdt/cqm: Add rmdir support")
Fixes: e02737d5b826 ("x86/intel_rdt: Add tasks files")
Fixes: 60cf5e101fd4 ("x86/intel_rdt: Add mkdir to resctrl file system")
Reported-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Xiaochen Shen <xiaochen.shen@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/1604085088-31707-1-git-send-email-xiaochen.shen@intel.com

diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 2ab1266a5f14..6f4ca4bea625 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -507,6 +507,24 @@ static ssize_t rdtgroup_cpus_write(struct kernfs_open_file *of,
 	return ret ?: nbytes;
 }
 
+/**
+ * rdtgroup_remove - the helper to remove resource group safely
+ * @rdtgrp: resource group to remove
+ *
+ * On resource group creation via a mkdir, an extra kernfs_node reference is
+ * taken to ensure that the rdtgroup structure remains accessible for the
+ * rdtgroup_kn_unlock() calls where it is removed.
+ *
+ * Drop the extra reference here, then free the rdtgroup structure.
+ *
+ * Return: void
+ */
+static void rdtgroup_remove(struct rdtgroup *rdtgrp)
+{
+	kernfs_put(rdtgrp->kn);
+	kfree(rdtgrp);
+}
+
 struct task_move_callback {
 	struct callback_head	work;
 	struct rdtgroup		*rdtgrp;
@@ -529,7 +547,7 @@ static void move_myself(struct callback_head *head)
 	    (rdtgrp->flags & RDT_DELETED)) {
 		current->closid = 0;
 		current->rmid = 0;
-		kfree(rdtgrp);
+		rdtgroup_remove(rdtgrp);
 	}
 
 	if (unlikely(current->flags & PF_EXITING))
@@ -2065,8 +2083,7 @@ void rdtgroup_kn_unlock(struct kernfs_node *kn)
 		    rdtgrp->mode == RDT_MODE_PSEUDO_LOCKED)
 			rdtgroup_pseudo_lock_remove(rdtgrp);
 		kernfs_unbreak_active_protection(kn);
-		kernfs_put(rdtgrp->kn);
-		kfree(rdtgrp);
+		rdtgroup_remove(rdtgrp);
 	} else {
 		kernfs_unbreak_active_protection(kn);
 	}
@@ -2341,7 +2358,7 @@ static void free_all_child_rdtgrp(struct rdtgroup *rdtgrp)
 		if (atomic_read(&sentry->waitcount) != 0)
 			sentry->flags = RDT_DELETED;
 		else
-			kfree(sentry);
+			rdtgroup_remove(sentry);
 	}
 }
 
@@ -2383,7 +2400,7 @@ static void rmdir_all_sub(void)
 		if (atomic_read(&rdtgrp->waitcount) != 0)
 			rdtgrp->flags = RDT_DELETED;
 		else
-			kfree(rdtgrp);
+			rdtgroup_remove(rdtgrp);
 	}
 	/* Notify online CPUs to update per cpu storage and PQR_ASSOC MSR */
 	update_closid_rmid(cpu_online_mask, &rdtgroup_default);
@@ -2818,7 +2835,7 @@ static int mkdir_rdt_prepare(struct kernfs_node *parent_kn,
 	 * kernfs_remove() will drop the reference count on "kn" which
 	 * will free it. But we still need it to stick around for the
 	 * rdtgroup_kn_unlock(kn) call. Take one extra reference here,
-	 * which will be dropped inside rdtgroup_kn_unlock().
+	 * which will be dropped by kernfs_put() in rdtgroup_remove().
 	 */
 	kernfs_get(kn);
 
@@ -2859,6 +2876,7 @@ static int mkdir_rdt_prepare(struct kernfs_node *parent_kn,
 out_idfree:
 	free_rmid(rdtgrp->mon.rmid);
 out_destroy:
+	kernfs_put(rdtgrp->kn);
 	kernfs_remove(rdtgrp->kn);
 out_free_rgrp:
 	kfree(rdtgrp);
@@ -2871,7 +2889,7 @@ static void mkdir_rdt_prepare_clean(struct rdtgroup *rgrp)
 {
 	kernfs_remove(rgrp->kn);
 	free_rmid(rgrp->mon.rmid);
-	kfree(rgrp);
+	rdtgroup_remove(rgrp);
 }
 
 /*


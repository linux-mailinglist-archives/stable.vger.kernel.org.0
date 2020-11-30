Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 402142C8008
	for <lists+stable@lfdr.de>; Mon, 30 Nov 2020 09:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbgK3IeJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Nov 2020 03:34:09 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:32965 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726950AbgK3IeI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Nov 2020 03:34:08 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 9D1B4861;
        Mon, 30 Nov 2020 03:33:22 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 30 Nov 2020 03:33:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=RXqwLP
        Sx1xcl2idVFN5VTTfivFPnzFeRzLjP8PZdPwE=; b=BgWICoQ/LKlq8q1r2ALo2A
        iUAPAbgBC70NMB4az5bGppXL1oid1lBGQ3iKS0eBlYfmC/x59SWO2cJBPREvRDN5
        gkPYH2YkBSeKumwLeLCpC1XGIYzhIGoL9ZCacgK0Y6MqkXRv6MUNxtS+ReWKipKs
        Hi8WZGqNO+e+17mnr3DaSSE2/LCfWj+n0Xxi0n9ubi7OefgAXipIByzMMJrcJlKR
        P7++7RNuOV0CUhfYyNhtiAgys8vgehS/rrT5TmGuRyvMvzvf9jrw9pfWu5f6cwuo
        rtHAErhFF5VZbv4KQf/vC0v3c5/tDs9o1SRAxENjHd7NNusNqdc3GPT1VQG71vVg
        ==
X-ME-Sender: <xms:Ua7EX0sHVVh_kDS8CVvRsNdWRsN6Ztt9KYGd5QF5_aus8YkiAk8Tkw>
    <xme:Ua7EXxeZ2wtJn4NoJfbo-E-xo00nIbKK359OJ-OH21BOrC0LDRfVheTDbzstr3tB3
    dVeRc6ApiWqZw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudehledguddvtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:Ua7EX_wwn2IYEkjmgSyHR6SR8q0Z0JwzolnU9Ukr-4rT9bkBoZNWWQ>
    <xmx:Ua7EX3Ov_fhqSLzWspG5gqHOv0ERpuIU8A8ciw8v3IHr05sDOa46Rg>
    <xmx:Ua7EX0_K7KOzsvCKDllAGaiZCbIXmngE-qaqjOjXQh3dtFY9UMcb9Q>
    <xmx:Uq7EX2IyYz7yLbkUdcPK2Wr_GHw212WywzZn5WkYQp7qQVaOj9KzlsSMB04>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6E2323280063;
        Mon, 30 Nov 2020 03:33:21 -0500 (EST)
Subject: FAILED: patch "[PATCH] x86/resctrl: Remove superfluous kernfs_get() calls to prevent" failed to apply to 4.19-stable tree
To:     xiaochen.shen@intel.com, bp@suse.de, reinette.chatre@intel.com,
        willemb@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 30 Nov 2020 09:34:26 +0100
Message-ID: <16067252669529@kroah.com>
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

From fd8d9db3559a29fd737bcdb7c4fcbe1940caae34 Mon Sep 17 00:00:00 2001
From: Xiaochen Shen <xiaochen.shen@intel.com>
Date: Sat, 31 Oct 2020 03:10:53 +0800
Subject: [PATCH] x86/resctrl: Remove superfluous kernfs_get() calls to prevent
 refcount leak

Willem reported growing of kernfs_node_cache entries in slabtop when
repeatedly creating and removing resctrl subdirectories as well as when
repeatedly mounting and unmounting the resctrl filesystem.

On resource group (control as well as monitoring) creation via a mkdir
an extra kernfs_node reference is obtained to ensure that the rdtgroup
structure remains accessible for the rdtgroup_kn_unlock() calls where it
is removed on deletion. The kernfs_node reference count is dropped by
kernfs_put() in rdtgroup_kn_unlock().

With the above explaining the need for one kernfs_get()/kernfs_put()
pair in resctrl there are more places where a kernfs_node reference is
obtained without a corresponding release. The excessive amount of
reference count on kernfs nodes will never be dropped to 0 and the
kernfs nodes will never be freed in the call paths of rmdir and umount.
It leads to reference count leak and kernfs_node_cache memory leak.

Remove the superfluous kernfs_get() calls and expand the existing
comments surrounding the remaining kernfs_get()/kernfs_put() pair that
remains in use.

Superfluous kernfs_get() calls are removed from two areas:

  (1) In call paths of mount and mkdir, when kernfs nodes for "info",
  "mon_groups" and "mon_data" directories and sub-directories are
  created, the reference count of newly created kernfs node is set to 1.
  But after kernfs_create_dir() returns, superfluous kernfs_get() are
  called to take an additional reference.

  (2) kernfs_get() calls in rmdir call paths.

Fixes: 17eafd076291 ("x86/intel_rdt: Split resource group removal in two")
Fixes: 4af4a88e0c92 ("x86/intel_rdt/cqm: Add mount,umount support")
Fixes: f3cbeacaa06e ("x86/intel_rdt/cqm: Add rmdir support")
Fixes: d89b7379015f ("x86/intel_rdt/cqm: Add mon_data")
Fixes: c7d9aac61311 ("x86/intel_rdt/cqm: Add mkdir support for RDT monitoring")
Fixes: 5dc1d5c6bac2 ("x86/intel_rdt: Simplify info and base file lists")
Fixes: 60cf5e101fd4 ("x86/intel_rdt: Add mkdir to resctrl file system")
Fixes: 4e978d06dedb ("x86/intel_rdt: Add "info" files to resctrl file system")
Reported-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Xiaochen Shen <xiaochen.shen@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Tested-by: Willem de Bruijn <willemb@google.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/1604085053-31639-1-git-send-email-xiaochen.shen@intel.com

diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index af323e2e3100..2ab1266a5f14 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -1769,7 +1769,6 @@ static int rdtgroup_mkdir_info_resdir(struct rdt_resource *r, char *name,
 	if (IS_ERR(kn_subdir))
 		return PTR_ERR(kn_subdir);
 
-	kernfs_get(kn_subdir);
 	ret = rdtgroup_kn_set_ugid(kn_subdir);
 	if (ret)
 		return ret;
@@ -1792,7 +1791,6 @@ static int rdtgroup_create_info_dir(struct kernfs_node *parent_kn)
 	kn_info = kernfs_create_dir(parent_kn, "info", parent_kn->mode, NULL);
 	if (IS_ERR(kn_info))
 		return PTR_ERR(kn_info);
-	kernfs_get(kn_info);
 
 	ret = rdtgroup_add_files(kn_info, RF_TOP_INFO);
 	if (ret)
@@ -1813,12 +1811,6 @@ static int rdtgroup_create_info_dir(struct kernfs_node *parent_kn)
 			goto out_destroy;
 	}
 
-	/*
-	 * This extra ref will be put in kernfs_remove() and guarantees
-	 * that @rdtgrp->kn is always accessible.
-	 */
-	kernfs_get(kn_info);
-
 	ret = rdtgroup_kn_set_ugid(kn_info);
 	if (ret)
 		goto out_destroy;
@@ -1847,12 +1839,6 @@ mongroup_create_dir(struct kernfs_node *parent_kn, struct rdtgroup *prgrp,
 	if (dest_kn)
 		*dest_kn = kn;
 
-	/*
-	 * This extra ref will be put in kernfs_remove() and guarantees
-	 * that @rdtgrp->kn is always accessible.
-	 */
-	kernfs_get(kn);
-
 	ret = rdtgroup_kn_set_ugid(kn);
 	if (ret)
 		goto out_destroy;
@@ -2139,13 +2125,11 @@ static int rdt_get_tree(struct fs_context *fc)
 					  &kn_mongrp);
 		if (ret < 0)
 			goto out_info;
-		kernfs_get(kn_mongrp);
 
 		ret = mkdir_mondata_all(rdtgroup_default.kn,
 					&rdtgroup_default, &kn_mondata);
 		if (ret < 0)
 			goto out_mongrp;
-		kernfs_get(kn_mondata);
 		rdtgroup_default.mon.mon_data_kn = kn_mondata;
 	}
 
@@ -2499,11 +2483,6 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
 	if (IS_ERR(kn))
 		return PTR_ERR(kn);
 
-	/*
-	 * This extra ref will be put in kernfs_remove() and guarantees
-	 * that kn is always accessible.
-	 */
-	kernfs_get(kn);
 	ret = rdtgroup_kn_set_ugid(kn);
 	if (ret)
 		goto out_destroy;
@@ -2838,8 +2817,8 @@ static int mkdir_rdt_prepare(struct kernfs_node *parent_kn,
 	/*
 	 * kernfs_remove() will drop the reference count on "kn" which
 	 * will free it. But we still need it to stick around for the
-	 * rdtgroup_kn_unlock(kn} call below. Take one extra reference
-	 * here, which will be dropped inside rdtgroup_kn_unlock().
+	 * rdtgroup_kn_unlock(kn) call. Take one extra reference here,
+	 * which will be dropped inside rdtgroup_kn_unlock().
 	 */
 	kernfs_get(kn);
 
@@ -3049,11 +3028,6 @@ static int rdtgroup_rmdir_mon(struct kernfs_node *kn, struct rdtgroup *rdtgrp,
 	WARN_ON(list_empty(&prdtgrp->mon.crdtgrp_list));
 	list_del(&rdtgrp->mon.crdtgrp_list);
 
-	/*
-	 * one extra hold on this, will drop when we kfree(rdtgrp)
-	 * in rdtgroup_kn_unlock()
-	 */
-	kernfs_get(kn);
 	kernfs_remove(rdtgrp->kn);
 
 	return 0;
@@ -3065,11 +3039,6 @@ static int rdtgroup_ctrl_remove(struct kernfs_node *kn,
 	rdtgrp->flags = RDT_DELETED;
 	list_del(&rdtgrp->rdtgroup_list);
 
-	/*
-	 * one extra hold on this, will drop when we kfree(rdtgrp)
-	 * in rdtgroup_kn_unlock()
-	 */
-	kernfs_get(kn);
 	kernfs_remove(rdtgrp->kn);
 	return 0;
 }


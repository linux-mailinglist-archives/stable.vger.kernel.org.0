Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE1A02F92D8
	for <lists+stable@lfdr.de>; Sun, 17 Jan 2021 15:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729165AbhAQOW7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jan 2021 09:22:59 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:57283 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729105AbhAQOW6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Jan 2021 09:22:58 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id B6D8919C0AF8;
        Sun, 17 Jan 2021 09:21:51 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 17 Jan 2021 09:21:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=2/AkaL
        MK4Q473iagg/KbfCQbvReG16giE58A9pgQT5A=; b=HN0tkkOJQVmDOPc7zyu1GE
        7fDz9f2+uGPKXVJwTag8OR7WaLKjdDuUep5aspn/EMC7doD+kO9/rgA0OV9iVb8Q
        XzL7RsR0h24yRT0Uq9gVU1GZodBXKJqGTGbZNpRcUA5eoiNusrEkT1P/do6TsDOC
        O5r9HrKaDt1f1nijzLl4XwPE0H9Sgu1h0V5nrSzeu6W0hI1EGuu1P7L4X7R6B2rm
        D7Gysv0I8h/L88GHKF1DxpoBv2K+YLUKdXwBqRWtrvQKuqKqjMUzef/7qu7OdZVA
        BhuOY5CmThYkf6FbpwZlSxy+n0URYjNTORUhB31gbzY0G2p17b8Az+JsjN/C2YzQ
        ==
X-ME-Sender: <xms:_0cEYO7xK0mL7pAd40tZUZ0sljUYAzmLEHInqHipMYWCGEeNuP4fDg>
    <xme:_0cEYH7yb1au22x_ga5DOmMBtT0RbhOF1QsPLb8iyDfWikVg4CrCBc1DPQGRLr2is
    yWb-CmQYGOPEQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtdeigdeihecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    ejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeekjefgffetgfevgeeghedugfelheektdehtdeihfeile
    eiteevjedvgfdvleejleenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:_0cEYNfLDylPiePz-ZXZSJCVSVB9sGpcpwpGx_-TVz9l4fOqtja47w>
    <xmx:_0cEYLJg9E2Dq-BtQRiuoTxfgEWc2zfqDvZXLuiZ8v5Z8tbFU0A0sQ>
    <xmx:_0cEYCLcSHxfnLZMGux_xoPbEkCoAjgDhec2dCfB0kODF0RQqczqxA>
    <xmx:_0cEYEgQoHeIRmGkUSxcdOV5u6LdViibSBErmCu6jnWHuc7nbm7Z8A>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 53E11240057;
        Sun, 17 Jan 2021 09:21:51 -0500 (EST)
Subject: FAILED: patch "[PATCH] xen/privcmd: allow fetching resource sizes" failed to apply to 4.19-stable tree
To:     roger.pau@citrix.com, andrew.cooper3@citrix.com, jgross@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 17 Jan 2021 15:21:49 +0100
Message-ID: <16108933095487@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From ef3a575baf53571dc405ee4028e26f50856898e7 Mon Sep 17 00:00:00 2001
From: Roger Pau Monne <roger.pau@citrix.com>
Date: Tue, 12 Jan 2021 12:53:58 +0100
Subject: [PATCH] xen/privcmd: allow fetching resource sizes
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Allow issuing an IOCTL_PRIVCMD_MMAP_RESOURCE ioctl with num = 0 and
addr = 0 in order to fetch the size of a specific resource.

Add a shortcut to the default map resource path, since fetching the
size requires no address to be passed in, and thus no VMA to setup.

This is missing from the initial implementation, and causes issues
when mapping resources that don't have fixed or known sizes.

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Tested-by: Andrew Cooper <andrew.cooper3@citrix.com>
Cc: stable@vger.kernel.org # >= 4.18
Link: https://lore.kernel.org/r/20210112115358.23346-1-roger.pau@citrix.com
Signed-off-by: Juergen Gross <jgross@suse.com>

diff --git a/drivers/xen/privcmd.c b/drivers/xen/privcmd.c
index b0c73c58f987..720a7b7abd46 100644
--- a/drivers/xen/privcmd.c
+++ b/drivers/xen/privcmd.c
@@ -717,14 +717,15 @@ static long privcmd_ioctl_restrict(struct file *file, void __user *udata)
 	return 0;
 }
 
-static long privcmd_ioctl_mmap_resource(struct file *file, void __user *udata)
+static long privcmd_ioctl_mmap_resource(struct file *file,
+				struct privcmd_mmap_resource __user *udata)
 {
 	struct privcmd_data *data = file->private_data;
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
 	struct privcmd_mmap_resource kdata;
 	xen_pfn_t *pfns = NULL;
-	struct xen_mem_acquire_resource xdata;
+	struct xen_mem_acquire_resource xdata = { };
 	int rc;
 
 	if (copy_from_user(&kdata, udata, sizeof(kdata)))
@@ -734,6 +735,22 @@ static long privcmd_ioctl_mmap_resource(struct file *file, void __user *udata)
 	if (data->domid != DOMID_INVALID && data->domid != kdata.dom)
 		return -EPERM;
 
+	/* Both fields must be set or unset */
+	if (!!kdata.addr != !!kdata.num)
+		return -EINVAL;
+
+	xdata.domid = kdata.dom;
+	xdata.type = kdata.type;
+	xdata.id = kdata.id;
+
+	if (!kdata.addr && !kdata.num) {
+		/* Query the size of the resource. */
+		rc = HYPERVISOR_memory_op(XENMEM_acquire_resource, &xdata);
+		if (rc)
+			return rc;
+		return __put_user(xdata.nr_frames, &udata->num);
+	}
+
 	mmap_write_lock(mm);
 
 	vma = find_vma(mm, kdata.addr);
@@ -768,10 +785,6 @@ static long privcmd_ioctl_mmap_resource(struct file *file, void __user *udata)
 	} else
 		vma->vm_private_data = PRIV_VMA_LOCKED;
 
-	memset(&xdata, 0, sizeof(xdata));
-	xdata.domid = kdata.dom;
-	xdata.type = kdata.type;
-	xdata.id = kdata.id;
 	xdata.frame = kdata.idx;
 	xdata.nr_frames = kdata.num;
 	set_xen_guest_handle(xdata.frame_list, pfns);

